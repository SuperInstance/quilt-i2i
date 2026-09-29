/**
 * i2i-ledger — R1 skeleton for the I2I coordination ledger.
 * Design: ../docs/cf-synergy-backend.md
 *
 * Routes:
 *   POST /book   Authorization: Bearer <I2I_TOKEN>
 *                body: {agent, gist, body, receipt_url, books_to, ts}
 *                → insert into D1 `ledger`, embed gist+body via
 *                  Workers AI @cf/baai/bge-m3, upsert Vectorize i2i-index
 *                  with metadata {id, agent, ts, url}
 *   GET  /near   ?q=...&k=8   → embed q → Vectorize top-k → hydrated ledger rows
 *   GET  /since  ?ts=...      → D1 rows after ts (catch-up for waking agents)
 *
 * Bindings (wrangler.toml): DB = D1, INDEX = Vectorize (i2i-index), AI = Workers AI.
 * R2 (git-sync cron) and R3 (public face) are intentionally out of scope here.
 */

const EMBED_MODEL = "@cf/baai/bge-m3"; // outputs 1024-dim vectors
const EMBED_DIMS = 1024;

function json(data, status = 200) {
  return new Response(JSON.stringify(data, null, 2) + "\n", {
    status,
    headers: { "content-type": "application/json; charset=utf-8" },
  });
}

function bearerToken(request) {
  const header = request.headers.get("Authorization") || "";
  const match = /^Bearer\s+(.+)$/.exec(header);
  return match ? match[1].trim() : null;
}

function safeEqual(a, b) {
  if (typeof a !== "string" || typeof b !== "string" || a.length !== b.length) {
    return false;
  }
  let diff = 0;
  for (let i = 0; i < a.length; i++) diff |= a.charCodeAt(i) ^ b.charCodeAt(i);
  return diff === 0;
}

function authorized(request, env) {
  return Boolean(env.I2I_TOKEN) && safeEqual(bearerToken(request) || "", env.I2I_TOKEN);
}

/** Accept epoch seconds or milliseconds; default to now. Returns integer seconds. */
function normalizeTs(value) {
  const n = Number(value);
  if (!Number.isFinite(n) || n <= 0) return Math.floor(Date.now() / 1000);
  return n > 1e12 ? Math.floor(n / 1000) : Math.floor(n);
}

async function embed(env, text) {
  const res = await env.AI.run(EMBED_MODEL, { text: [text] });
  const vector = res && res.data && res.data[0] && res.data[0].embedding;
  if (!Array.isArray(vector) || vector.length !== EMBED_DIMS) {
    throw new Error("bad embedding from " + EMBED_MODEL);
  }
  return vector;
}

async function handleBook(request, env) {
  if (!authorized(request, env)) return json({ error: "unauthorized" }, 401);

  let payload;
  try {
    payload = await request.json();
  } catch {
    return json({ error: "invalid JSON body" }, 400);
  }

  const agent = typeof payload.agent === "string" ? payload.agent.trim() : "";
  const gist = typeof payload.gist === "string" ? payload.gist.trim() : "";
  if (!agent || !gist) return json({ error: "agent and gist are required" }, 400);

  const body = typeof payload.body === "string" ? payload.body : "";
  const receiptUrl = typeof payload.receipt_url === "string" ? payload.receipt_url : "";
  const booksTo = typeof payload.books_to === "string" ? payload.books_to : "";
  const ts = normalizeTs(payload.ts);
  const id = crypto.randomUUID();

  // 1) Book it to D1 first — the row of record lands even if embedding lags.
  await env.DB
    .prepare(
      "INSERT INTO ledger (id, agent, gist, body, receipt_url, books_to, ts, embedded) " +
        "VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, 0)"
    )
    .bind(id, agent, gist, body, receiptUrl, booksTo, ts)
    .run();

  // 2) Translate to the shared vector space and upsert.
  try {
    const vector = await embed(env, (gist + "\n" + body).trim());
    await env.INDEX.upsert([
      {
        id,
        values: vector,
        metadata: { id, agent, ts, url: receiptUrl },
      },
    ]);
    await env.DB.prepare("UPDATE ledger SET embedded = 1 WHERE id = ?1").bind(id).run();
    return json({ ok: true, id, agent, ts, embedded: true });
  } catch (err) {
    // Row is safe in D1 (embedded=0); report the vector lag honestly.
    return json({ ok: true, id, agent, ts, embedded: false, error: String(err) }, 207);
  }
}

async function handleNear(url, env) {
  const q = (url.searchParams.get("q") || "").trim();
  if (!q) return json({ error: "q is required, e.g. /near?q=world+model&k=8" }, 400);

  const parsedK = parseInt(url.searchParams.get("k") || "8", 10);
  const k = Math.max(1, Math.min(50, Number.isFinite(parsedK) ? parsedK : 8));

  const vector = await embed(env, q);
  const res = await env.INDEX.query(vector, { topK: k, returnMetadata: "all" });
  const matches = (res && res.matches) || [];

  // Hydrate from D1 so callers get gist/body/books_to, not just vector metadata.
  const ids = matches.map((m) => m.id);
  const rowsById = new Map();
  if (ids.length > 0) {
    const placeholders = ids.map((_, i) => "?" + (i + 1)).join(", ");
    const rows = await env.DB
      .prepare(
        "SELECT id, agent, gist, body, receipt_url, books_to, ts " +
          "FROM ledger WHERE id IN (" + placeholders + ")"
      )
      .bind(...ids)
      .all();
    for (const row of (rows && rows.results) || []) rowsById.set(row.id, row);
  }

  return json({
    query: q,
    k,
    matches: matches.map((m) => ({
      id: m.id,
      score: m.score,
      agent: (m.metadata && m.metadata.agent) || null,
      ts: (m.metadata && typeof m.metadata.ts === "number") ? m.metadata.ts : null,
      url: (m.metadata && m.metadata.url) || null,
      entry: rowsById.get(m.id) || null,
    })),
  });
}

async function handleSince(url, env) {
  const raw = url.searchParams.get("ts");
  if (raw == null || raw.trim() === "") {
    return json({ error: "ts is required (epoch seconds), e.g. /since?ts=1759000000" }, 400);
  }
  const ts = normalizeTs(raw);

  const rows = await env.DB
    .prepare(
      "SELECT id, agent, gist, body, receipt_url, books_to, ts, embedded " +
        "FROM ledger WHERE ts > ?1 ORDER BY ts ASC LIMIT 500"
    )
    .bind(ts)
    .all();

  const entries = (rows && rows.results) || [];
  return json({ after: ts, count: entries.length, entries });
}

export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const path = url.pathname.replace(/\/+$/, "") || "/";

    try {
      if (request.method === "POST" && path === "/book") return await handleBook(request, env);
      if (request.method === "GET" && path === "/near") return await handleNear(url, env);
      if (request.method === "GET" && path === "/since") return await handleSince(url, env);
      return json(
        {
          error: "not found",
          routes: ["POST /book", "GET /near?q=&k=", "GET /since?ts="],
        },
        404
      );
    } catch (err) {
      return json({ error: String((err && err.message) || err) }, 500);
    }
  },
};
