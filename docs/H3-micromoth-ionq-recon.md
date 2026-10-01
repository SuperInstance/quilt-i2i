# H3: MicroMoth → IonQ recon (research-only draft)

Booked by `lucineer-bootstrap-recon`, 2026-09-29. Ledger claim: `163d0bf6-…`, delivery books `4d056078-…` + final.
No silicon was harmed: this is the map + ladder draft the handoff asked for.

## Sources

- MicroMoth source (read in full): https://github.com/moth-quantum/MicroMoth — `micromoth.py` template; docs https://micromoth.readthedocs.io/en/latest/
- Moth Atlas platform API (live-recon'd): https://api.mothquantum.com/openapi.json (moth-api v0.41.0), Scalar docs at https://platform.mothquantum.com / https://api.mothquantum.com/docs
- TypeSafe AI (adjacent lane tooling): https://docs.typesafe.ai/ — POST /v1/systemone, GET /v1/models
- IonQ access paths (not yet exercised): qiskit-ionq provider (github.com/Qiskit/qiskit-ionq), IonQ Cloud docs.ionq.com — signup carries limited free credits; Braket/Azure Quantum offer free tiers. **Stop at any paywall.**

## 1. MicroMoth "cell format" vs quilt cell contract

MicroMoth is a MicroQiskit fork: a `QuantumCircuit(n, m)` whose `data` is an ordered list of
gate tuples `('gate', args…)`. That flat tuple-list **is** the cell format. Mapping:

| Quilt contract | MicroMoth carrier | Notes |
|---|---|---|
| `qm_bind` | constructor `n` + `('init', [amplitudes])` | Qubit allocation binds the cell to substrate; `init` sets its ground state. |
| `qm_link` | `('cx', s, t)`, `('crx', θ, s, t)`, `('swap', s, t)` | Directed edge source→target. Two-qubit gates ARE the relational links. |
| `qm_effect` | `('x', q)`, `('h', q)`, `('rx', θ, q)`, `('rz', θ, q)` | Local mutations on bound qubits. ry/z/t/y are decomposed into these. |
| `qm_view` | `('m', q, b)` / `measure_all()` | Qubit→clbit map = readout projection; `simulate(get='counts', shots=N)`. |
| `qm_tick` | **implicit** — ordinal position in `data` | No barriers/scheduler. Tick = list index. `simulate(noise_model=[p…])` = per-tick decoherence proxy (measurement-error list). |

Gaps to remember: no explicit tick id, noise model is readout-error-only (no gate noise),
view is destructive (counts, no marginal statevector snapshotting without rerunning).

## 2. Three-rung IonQ experiment ladder (falsify FIRST, cheapest first)

What can quantum hardware falsify first about cell relational-logic? Ordered so each rung
needs only the previous rung's survivors:

- **Rung 1 — Link reality (2 qubits, ~1 job).** Build a 2-cell pair: `bind` both, `link` via `cx`, `view` both. Compare IonQ-measured Bell correlation vs MicroMoth `simulate()` ideal and `noise_model` variants. **Falsifies:** whether `qm_link` (cx-as-edge) survives IonQ transpilation to native gates (GPI/GPI2/ZZ). If deviation exceeds modeled readout error, "link" is notation, not physics.
- **Rung 2 — Tick-order causality (3–4 qubits, 2 jobs).** Two quilts identical except tick order: one pair of gates commuting, one non-commuting. Hardware should only distinguish the non-commuting variant. **Falsifies:** tick-as-ordinal semantics — if IonQ shows order sensitivity where the simulator says commute (or flattens real order), the tick abstraction leaks under hardware noise.
- **Rung 3 — View composition at quilt scale (7–11 qubits).** A small cell graph; compare global `measure_all` vs partial `qm_view` subsets against simulator marginals. **Falsifies:** `qm_view` as a lossless projection — IonQ's per-qubit readout error compounds across a quilt; if marginals drift beyond the noise model, view composition needs an error-mitigation layer before it means anything.

Bridge path: MicroMoth tuples map 1:1 to Qiskit gates (fork lineage) → `qiskit-ionq`
submits. Atlas `emu` mode (free local Aer) is the pre-flight cross-check before any IonQ spend.

## 3. Adjacent capability discovered during recon (booking 4d056078)

Atlas exposes 32 quantum engines over HTTP — including `graph-v1`, `labyrinth-v1`,
`comet-qrng-v1`, `qrc-*` (quantum reservoir computing), `tomography-api-v2`,
`entanglement-shader-v1` — with `mode: emu|qpu` (qpu → **IBM** hardware). This is a
ready-made rung-0 lab: relational structure generation and simulation without any IonQ
account. Auth: `moth_` bearer key (in Casey's key.txt; verified live, role `player`).
