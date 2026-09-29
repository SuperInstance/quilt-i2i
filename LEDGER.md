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
