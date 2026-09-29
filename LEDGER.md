# The I2I Ledger — instance-to-instance insight bookings

The fleet's shared coordination ledger. Every agent books what it learns here;
every other agent reads it before building. Double-entry flavored: each entry
says what was learned, where the receipt lives, and what it **books to** (which
lane / repo / idea it's relevant to).

Conventions: [AGENTS.md](AGENTS.md). Append under the date. Never delete —
supersede with a new entry that names the old one.

## 2026-09-29

### [lucineer] C1 KEEP — Cosmos 3 Edge runs on boat-class silicon
- 4B edge world model, NF4 4-bit, RTX 4050 6 GB: **17.5 tok/s** decode,
  **1.95 GiB** peak alloc (3.12 GiB VRAM of 6), **49 °C**, 48/48 tokens via
  the repo chat template. Nobody had published a 4050-class number — AR tower
  only; diffusion/WAM tower is C2+.
- Receipt: SuperInstance/quilt-gpu-lab `9579dd9` (results/c1_cosmos_boots.json
  + two fail-loud attempt receipts: debug-print crash, raw-text 1-token EOS).
- Books to: hundred-boats lane (wheelhouse silicon), plato-room perception
  cells, C2 world-model smoke / C3 cross-encoder probe.

### [lucineer] IE2 KEEP — the boundary was in the reader, not the rung
- IE1's "blob direction unreadable" (r2 ≈ 0.03) was **reader dilution**: a
  blob-only-trained linear reader hits r2 0.54/0.81/0.93 (acc → 1.0) even
  though the pooled blob signal is 40–150× smaller than the grating signal.
  Wide-field pooling carries small-field motion fine.
- Receipt: quilt-gpu-lab `13ea5a7`.
- Books to: fly-eye lane (ie3 = two-head reader on the single 4-code stream),
  "preferred when" doctrine instance (which reader head, which regime).

### [lucineer] K3c — domain split is a units-translation problem (ActiveLedger avant la lettre)
- V-JEPA-2 state z-codes are domain-anchored (synth-half val 4.3–4.7 vs floor
  2.85); frame-diffs transfer across domains for free (1.77 on the same drawn
  mix). The diff arm IS the translation page between two book-keepers.
- Receipt: quilt-gpu-lab `38eec97` (86 s diagnosis: poisoned cells + healthy
  controls, per-domain curves).
- Books to: ActiveLedger doctrine, C3 (same probe on Cosmos latents — does the
  finding generalize beyond V-JEPA-2?).

### [lucineer] Doctrines filed (Casey 09:54 + 10:02)
- **Anti-GAN:** novelty of *process* toward the same product; many routes to
  one answer = durability; "preferred when," not "best." Every experiment does
  something new; unique PoCs prized; push often.
- **ActiveLedger:** routing tensor of unit-translations between book-keepers
  (vibration books as heat in one ledger, never sound in the listener's);
  filter-cell routes (speech gate → STT → polish → context → Pincher
  pinch-off → game-engine → LLM); **plato-room = the rack** — front =
  ActiveLog (each cell's most-valuable reading), back = ActiveLedger (the
  routing), and unlike Reason the back is an improvement surface for IT agents
  AND humans.
- Vision PoC: [docs/rack-flip.html](docs/rack-flip.html) — flip the rack.
- Books to: every lane.

### [lucineer] Cloudflare synergy backend — design up
- Workers + Vectorize + D1 as first-class synergy jobs: embed every booking,
  `/near` similarity queries, git-sync catch-up for plain-push agents. We
  already pay for Cloudflare; this is the shared-brain backend.
- Receipt: [docs/cf-synergy-backend.md](docs/cf-synergy-backend.md).
- Books to: i2i coordination loop; later, the public "smarter together" face.

### [lucineer] C2 attempt-2 — first video-token numbers on 4050 silicon; degenerate-loop FAIL booked honestly
- Videos actually flowed (8 frames → 1026 input tokens; processor `videos=` path works after placeholder fix). Both anticipation tasks degenerated under greedy decoding → gate's scene-relevance clause unmet → KILL.
- Numbers: video decode **2.98 tok/s** vs image decode **49.1 tok/s** (video KV-cache tax), 2.01 GiB peak, guard clean.
- Receipt: quilt-gpu-lab `results/c2_world_smoke.attempt2-degenerate.json` + RESULTS.md.
- Books to: C2 attempt-3 (sampling params + repo example prompt), anyone driving Cosmos/VLMs on small GPUs.

### [lucineer] CF R1 skeleton landed — i2i-ledger worker, deploy-ready
- `cf/` in this repo: wrangler.toml (D1 `DB` + Vectorize `i2i-index` + Workers AI `AI`), `src/worker.js` (POST /book token-auth → D1 insert + bge-m3 embed + Vectorize upsert; GET /near?q&k; GET /since?ts), schema.sql, README-DEPLOY.md (copy-paste deploy from scratch, 1024-dim cosine index).
- Deviations booked: single shared secret first (per-agent token registry = R2), `embedded` flag + HTTP 207 so a D1 row survives embed failure, ts accepts ms/s, /near hydrates full rows from D1.
- Books to: deploy rung (needs wrangler auth on the paid CF account — Casey's go), then R2 git-sync cron.

### [lucineer] C2 attempt-3 — sampler exonerated, vision-path isolated as suspect
- Repo example prompt + full sampling (do_sample, temp 1.0): still loops. V-task 19.76 tok/s video decode (256 tok), I-task 46.2 tok/s. Scene-relevance unmet → KILL, booked honestly.
- Books to: attempt-4 vision-path isolation probe; anyone debugging NF4-quantized VLMs where text is coherent but vision tasks garble (suspect: vision-tower feature quality or processor path, NOT the sampler).

### [lucineer] C3 data-regen pre-registered — 256 clips, 2 domains, unfired
- Plan + script landed (glm-5.2 lane, reviewed): synth = 5 pinned lavfi families (K-law seeds, 224-crop→256), real = snapshot's 2 curated example mp4s with deterministic t0 grids. 96 train + 32 val × 2, T=16, 256×256 raw ≈ 768 MiB. Fail-loud gates, streaming sha256 manifest, list-form subprocess verified.
- Open question booked: real domain rests on 2 sources — thin-source frozen default for C3, external footage possible at C3b.
- Books to: C3 firing (Cosmos latents → K3c domain-anchoring replication test) once data regen runs.

### [lucineer] R1 LIVE + embed shape fix + fleet plug-ins published
- i2i-ledger live at https://i2i-ledger.casey-digennaro.workers.dev (D1 row-of-record + bge-m3 vectors + Vectorize /near). First live smoke booking exposed a response-shape bug (code expected data[0].embedding; Workers AI returns the vector at data[0]) — fixed, redeploying, re-verifying.
- skills/i2i-ledger/SKILL.md — portable skill: any OpenClaw/agent adopts the shared brain from one file (HTTP or plain-git transport, doctrine included: failures are first-class, /near before starting unfamiliar work).
- docs/HANDOFFS.md — 5 delegable open questions with exact deliverables + claim protocol: H1 C3b real-footage curation (browser agent), H2 bf16 Cosmos vision check (≥12GB VRAM box, probe script portable), H3 MicroMoth→IonQ recon (research-only, parked for weeks), H4 rack-flip visual verify (any working-browser box), H5 Liquid GGUF re-pull + baseline (any Ollama box).
- Books to: fleet adoption of the shared brain; handoff claims via books_to: handoff:<id>.

### [lucineer] Vision-path poison LOCALIZED — 3-cell probe names the vision tokens
- C2 attempt-4: text-only coherent on the same NF4 loader; image+thinking -> digit-cycle garble; image+no-thinking -> "..." + EOS. Sampler, prompt, thinking flag all exonerated. Vision-token injection breaks Cosmos3-Edge under 4-bit.
- Tool shipped: experiments/c2_probe_vision_path.py — a portable 3-cell VLM sanity probe; any agent with any VLM localizes vision-vs-text-vs-sampler failure in minutes.
- Books to: attempt-5 (vision tower bf16 + LM NF4, the skip-modules recipe), H2 handoff (full-bf16 check on a big box), NF4-VLM doctrine for small-GPU boxes.

### [lucineer] C2 CLOSED — skip-tower recipe proven on 6GB silicon
- attempt-5b KEEP: vision tower + projector bf16, LM NF4 → image coherence restored, structured bbox-JSON grounding output. The quantized vision tower was the poison (sampler/prompt/thinking exonerated in attempts 3-4).
- TOOL (proven): skip-tower-quantizer — `llm_int8_skip_modules=["visual","projector"]` (+ qualified forms), runtime receipt checks dtype==bf16 AND type==Parameter. Any 6GB box runs a coherent 4B-class VLM at ~50 tok/s image decode.
- C3 data landed: 256 clips / 768 MiB / sha256 manifest, 2 domains, K-law seeds. Books to: C3 latent probe.

### [lucineer] C3: domain anchoring replicates cross-encoder
- Cosmos3-Edge latents (skip-tower NF4 loader): nearest-centroid val AUC 1.0, 64/64, p 5.4e-20. The synth/real structure K3c found in the first encoder is a general property of video encoders, not an idiosyncrasy. Cells may key on domain structure in any encoder. Secondary logistic head flagged label-flip (booking discipline: named, not hidden).

### [lucineer] C4 + IE3 — video identity separable; dilution confirmed
- C4: av_0-vs-av_1 video identity perfectly decodable from Cosmos latents (LOOCV 1.0000, both scoring geometries). Temporal-drift control strongly structured, orientation geometry-dependent — action-vs-content attribution deferred to C5 paired design.
- IE3: DILUTION_CONFIRMS — shared trunks (joint or sequential) lose to dedicated specialists (0.987/0.984). Fleet doctrine in silicon: cells should be dedicated; the mesh routes BETWEEN cells.

### [lucineer] superinstance-api v0.1.0 LIVE — five seams + MCP tooling
- Fleet context brain deployed: https://superinstance-api.casey-digennaro.workers.dev (repo SuperInstance/superinstance-api @ 02df79f; D1 superinstance-db + Vectorize superinstance-index + Workers AI bge-m3). plato-cf absorbed as the tile subsystem: Lamport versions, tiers full/gist/hint, demotion REQUIRES a measurement receipt (honesty pin verified: 400 without, ok with). Reflex seam: pinch FIRE ≥0.92 / CONFIRM ≥0.75 / ESCALATE, compile-back with deterministic vector ids — paraphrase pinch → CONFIRM 0.892, zero LLM. Field seam: γ/η on every booking, conservation view (49/1585 after smoke). Growth seam: rooms stage-tagged. MCP Streamable-HTTP /mcp: initialize / tools/list / tools/call — any MCP client joins with one URL + per-agent bearer token (SI_API_TOKENS "agent:token"; identity comes from the credential, not the body).
- Banked platform lessons: key.txt CF_API_TOKEN fails API verify (6111) — wrangler stored OAuth is the deploy path; [[ai]] in wrangler.toml is array-of-tables (use [ai]); Vectorize metadata filters returned EMPTY when unfiltered queries matched the same vectors — pinch queries topK=10 and filters kind in JS; empty-string metadata silently rejects upserts.
- Books to: fleet adoption (client skills next: Claude Code / OpenCode / OpenClaw); handoff:lever-runner still unidentified (asked Casey).
