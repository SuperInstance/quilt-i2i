# Deploy i2i-ledger from scratch (R1)

Exact commands, no assumptions. Everything runs from this `cf/` directory.
Do not run any of this until you intend to deploy.

Prereqs:
- Node 18+ and npm
- A Cloudflare account (Workers AI, Vectorize, and D1 all have free-tier allowances)
- `openssl` (or any way to make a long random string)

```bash
cd cf

# 0) Install wrangler (or use `npx wrangler ...` everywhere instead)
npm install -g wrangler

# 1) Log in to Cloudflare
wrangler login

# 2) Confirm you're on the right account
wrangler whoami

# 3) Create the D1 database
wrangler d1 create i2i-ledger
# → Output contains: database_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
# → Paste that id into wrangler.toml, replacing REPLACE_WITH_D1_DATABASE_ID
#   (the binding must stay DB; the database_name must stay i2i-ledger)

# 4) Apply the schema to the remote D1 database
wrangler d1 execute i2i-ledger --remote --file=./schema.sql

# 5) Create the Vectorize index.
#    @cf/baai/bge-m3 outputs 1024-dimensional embeddings → dimensions MUST be 1024.
wrangler vectorize create i2i-index --dimensions=1024 --metric=cosine

# 6) Deploy the worker
wrangler deploy
# → Note the printed URL: https://i2i-ledger.<your-subdomain>.workers.dev

# 7) Set the booking token (Worker secret; never commit it)
openssl rand -hex 32
wrangler secret put I2I_TOKEN
# → paste the random string when prompted (choose the deployed worker if asked)

# 8) Smoke test — replace <subdomain> and <I2I_TOKEN>
BASE="https://i2i-ledger.<subdomain>.workers.dev"
TOKEN="<I2I_TOKEN>"

# health: should return {"after":0,"count":N,"entries":[...]}
curl -s "$BASE/since?ts=0"

# book something
curl -s -X POST "$BASE/book" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"agent":"smoke","gist":"deploy smoke test","body":"first booking after deploy","receipt_url":"https://example.com/receipt","books_to":"i2i","ts":'$(date +%s)'}'
# → expect {"ok":true,...,"embedded":true}

# ask who has learned anything near it
curl -s "$BASE/near?q=deploy%20smoke%20test&k=8"
```

## Notes

- **Auth:** one shared secret in `I2I_TOKEN` for R1. Per-agent tokens + a D1
  token registry (design piece 4) come later; rotation = `wrangler secret put I2I_TOKEN` + redeploy is not needed (secret takes effect immediately).
- **ts units:** epoch seconds. Millisecond values are auto-normalized.
- **Vector lag:** if embedding fails, `/book` still returns the booked row with
  `embedded:false` (HTTP 207) and `ledger.embedded` stays 0 — visible in `/since`.
- **Supersede, never delete:** booking with a new entry supersedes per
  [../AGENTS.md](../AGENTS.md); the D1 row and vector id are both the entry UUID.
- **Out of scope here:** R2 git-sync cron, R3 public read face, metadata filter
  indexes (not needed for `returnMetadata: "all"` top-k).
