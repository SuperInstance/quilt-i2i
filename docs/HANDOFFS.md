# HANDOFFS — delegable open questions (2026-09-29)

Open work the GPU lane cannot reach soon. Each item has an exact deliverable
and books through the same ledger (HTTP `/book` or git entry) with
`books_to: "handoff:<id>"`. Claim one by booking your intent, then deliver.

## H1: C3b — real-footage curation (browser agent, no GPU needed)

**DELIVERED 2026-10-04 15:3x AKDT** — 21 CC/PD clips determinized to exact C3 geometry
(16 frames, 256×256, rgb24, 10 fps) in quilt-gpu-lab `results/c3b_clips/` (commit `69f3836`).
Manifest = MANIFEST.json (per-clip sha256 + license mirror + argv), provenance = sources.json,
notes = CURATION.md. Blobs local-only (gitignored; tarball is the pick-up). Injectivity OK
(0 duplicates); one black-fade fallback (sdo_sun → pool midpoint) per the t0 law.
Curation is Wikimedia Commons + NASA/USDA/BLM public-domain only (Pexels/Pixabay denied
non-browser curl — recorded honestly). Ready for the C3b GPU latent pass.

C3's "real" domain rests on only 2 snapshot clips — too thin to trust
domain-anchoring conclusions. **Deliver:** ~20 diverse short clips (5–30 s,
real-world scenes, permissive/CC license, note source+license per clip),
determinized to the exact spec in `experiments/c3_make_data.py` (256×256,
T=16 frames, sha256 manifest — read the script, don't guess). **Book:** the
manifest + a tarball URL; the GPU lane picks up C3 from there.

## H2: bf16 Cosmos vision check (any box with ≥12 GB VRAM)

The 4050 can only run Cosmos3-Edge under NF4 4-bit; text-only is coherent,
all vision tasks garble, sampler already exonerated. **Question:** is NF4
the poison, or the model/harness? **Deliver:** run
`experiments/c2_probe_vision_path.py` on a bigger card with the
`BitsAndBytesConfig` removed (pure bf16, everything else identical). Coherent
image-task text at bf16 → NF4 is the poison. Still loops → the vision path
itself is broken for everyone, worth an upstream issue. Book the JSON.

## H3: MicroMoth → IonQ recon (research-only, no silicon)

Map MicroMoth-quilt's cell format against the quilt cell contract
(`qm_bind/link/effect/view/tick`) and draft a 3-rung IonQ experiment ladder:
what could quantum hardware falsify FIRST about cell relational-logic?
**Deliverable:** a docs draft in this repo + ledger booking. This has been
parked here for weeks for lack of a lane.

## H4: rack-flip visual verification (any box with a working browser)

`docs/rack-flip.html` — the Reason-skin PoC (front = ActiveLog prose,
back = ActiveLedger instrument panel). This box's browser wrapper is broken,
so it has never been visually verified. **Deliver:** screenshots of front +
flipped back, confirm the instrument panel renders and reads correctly.
Book both PNGs + verdict.

## H5: Liquid baseline re-pull (any box with Ollama)

`LiquidAI/LFM2.5-2.6B` GGUF tag is absent on the 4050 box (corrupt pull
earlier). **Deliver:** re-pull the GGUF, run a 3-prompt baseline battery
(tok/s + coherence notes), book the numbers. Unblocks the local-lane
doctrine: free-at-the-margin agentic work on the edge.

## Delivered (2026-10-04, local-lane handoffs)

### H4 — rack-flip visual verification ✅ VERIFIED

First-ever visual pass of `docs/rack-flip.html` (OpenClaw browser tool; the
old broken wrapper is gone). Front = ActiveLog (7 units, prose readings, VU
meters, LEDs) and back = ActiveLedger instrument panel both render and read
correctly. Flip trigger = FLIP RACK button, `?back=1` param also works.
Screenshots at `docs/artifacts/rack-flip-{front,back}.png` (900×1020
viewport — default headless 720px clips units 4-7; use a ≥950px viewport).
Minor QA note, not a blocker: SVG cables cross some back-face text in the
bottom third (over "sees only novel routes", "action"), and right-edge cable
labels can clip at narrow widths. Verdict: KEEP.

### H5 — Liquid baseline re-pull ✅ CLEAN PULL

`ollama pull LiquidAI/LFM2.5-2.6B` succeeded (1.7 GB, Q4_K_M, lfm2 arch —
previous corrupt pull resolved on Ollama 0.35.1-rc0). Battery run **CPU-only**
(second `ollama serve` on :11435 with `CUDA_VISIBLE_DEVICES=` empty — GPU was
occupied by the C5 lane, 3053 MiB used):

- A reasoning (boat heel): **22.66 tok/s**, 616 tok — correct, 3 sentences
- B instruction (git branch pushed?): **25.21 tok/s**, 1780 tok — accurate numbered steps (fetch / branch -v / ls-remote)
- C creative (lighthouse keeper): **22.88 tok/s**, 1281 tok — coherent single paragraph

Avg ≈ 23.6 tok/s CPU-only; coherence good across all three. Local-lane
doctrine unblocked. GPU numbers still pending a free GPU window.
