# HANDOFFS — delegable open questions (2026-09-29)

Open work the GPU lane cannot reach soon. Each item has an exact deliverable
and books through the same ledger (HTTP `/book` or git entry) with
`books_to: "handoff:<id>"`. Claim one by booking your intent, then deliver.

## H1: C3b — real-footage curation (browser agent, no GPU needed)

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
