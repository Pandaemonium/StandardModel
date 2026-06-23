# P9 positive T2 coarse-map triage (2026-06-23)

Scope: P9 source-visibility branch; T1 witness is `NullEdgeP9DiamondLocalSeparation`; T2 erasure control is `NullEdgeP9CoarseMapErasureGuardrail`.

Searches run:
- `neo4j_doc_search.py` for "causal-set observables source visibility boundary exact diamond closure defect", "Alexandrov subdiamond coarse graining causal diamond", "Laplacian coarse graining spectral coarse modes harmonic", "causal-set observables interval abundance intrinsic causal-set observable", and "subdiamond coarse map endpoint-preserving Alexandrov restrictions critical collapse".
- `neo4j_paper_search.py` for "Laplacian coarse graining graph reduction spectral projector" and "causal set coarse graining Alexandrov interval abundance causal-set cosmological constant".

## 1) Three admissible coarse-map classes

### C1. Endpoint-preserving Alexandrov / subdiamond restriction
- Data: finite causal relation, diamonds `D(p,q)`, and a pre-chosen selection policy `R_A` on subdiamonds (e.g. interval-depth truncation, local neighborhood radius, endpoint-preserving restriction).
- Candidate statistic: `localIntervalSignature` on a frozen probe point inside a fixed diamond.
- Literature anchors: `RC5XF8RD` (interval abundance and intrinsic observables), plus current program notes in `Sources/Null_Edge_Key_Conjectures.md` and `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`.
- Pros: closest to causal-set ontology; directly blocks pure offset/block-tuning arguments and ties to intrinsic order observables.
- Cons: formal proof target is more brittle unless endpoint and locality conditions are explicit.

### C2. Spectral / Hodge coarse modes (finite Laplacian projector family)
- Data: finite weighted Hodge 1-Laplacian (`L`), finite metric/co-differential convention, and fixed linear map `R` (or orthogonal/symmetric projector) from harmonic- or band-limited coarse modes.
- Candidate statistic: `tr(R K R^T)`, harmonic-sector projection, projected condition number, and coarse-source trace density.
- Literature anchors in index: `RA8QNNKW`, `AN5RZGJZ`, `UR5ADCBP`, `PTU4XM4U`, `WB8WBSBX` (stability/DEC-FEEC guardrails).
- Pros: many algebraic lemmas already scaffolded (`NullEdgeP9CoarseBoundaryInvariance`, `NullEdgeP9CoarseKernelPSD`, `NullEdgeP9ProjectedNoiseKernel`, `NullEdgeP9HodgeProjectorInstantiation`).
- Cons: strong geometric assumptions can drift into "operator-driven" rather than order-driven if `R` is underspecified.

### C3. Observer-forced graph-reduction maps (spectral/cut guarantees; alternative coarse readout channel)
- Data: a fixed graph-reduction map `R` with explicit selection/alignment rule (e.g. Loukas-style reduction) plus a fixed causal-diamond test window.
- Candidate statistic: coarse quadratic test response on the reduced cell/block algebra, with boundary- and block-alignment controls.
- Literature anchors: `PTU4XM4U` (spectral/cut guarantees), plus existing guardrails in sources tied to boundary-artifact and offset-robustness failures.
- Pros: practical for pilot automation and comparability with finite complexity metrics.
- Cons: can become ad hoc unless reduction is fixed before observing the T1 witness.

## 2) Which class to use next

- Most Lean-friendly: **C2 (Spectral/Hodge projector)**. Existing finite lemmas already support PSD/coarse-response transport and boundary-perturbation invariance; this is the shortest route to a sound T2 theorem statement.
- Most physically meaningful for publishability: **C1 (Alexandrov/subdiamond)** with explicit intrinsic observables (`intervalAbundance`, local interval signatures) and no post-hoc map-tuning, because it is closest to causal-set observables and the P9 gate.

## 3) Failure modes and controls
- Tautological map design: if `R` depends on the T1 witness, the preservation claim is vacuous. Control: freeze admissible class in advance and include `all`/`no` tuning metadata.
- Erasure counterexample: `NullEdgeP9CoarseMapErasureGuardrail` already shows a natural critical-collapse map can erase T1; any C2/C3 claim must assume admissibility conditions excluding this class.
- Geometry-blindness: if separated signal collapses under offset/weight shuffle/boundary strips, do not upgrade to publishable visibility physics.
- Boundary leakage: controls from `NullEdgeP9BoundaryExactPerturbationInvariant` / boundary-invariance scaffolds; include explicit hypotheses that tested perturbations are within declared boundary mode.
- Noise-as-signal confusion: mean-zero residual plus nonzero variance is not enough; control with explicit source/response law for `noiseResponse` and recoverability visibility gap.

## 4) Source additions needed?
- No new papers need to be added for this triage pass.
- Existing/relevant anchors already present and repeatedly used in this branch: `RC5XF8RD`, `RA8QNNKW`, `AN5RZGJZ`, `UR5ADCBP`, `PTU4XM4U`; also active relevance checks mention `DQ9CF6I2`, `I72KXVQA`, `G3FT8BXC`, `K5CFI3HI`, `IHVSDGUC` in notes.

## 5) Recommended theorem direction (next focused job)
- Prove a C2-leaned T2 stability theorem for a fixed projector-style map:
  - assumptions: endpoint-preserving `R`, fixed scale family, boundary-exact annihilation control, and nontriviality (`R` does not collapse all local interval modes),
  - target: `coarseLocalIntervalSignature` is preserved for a T1-valid pair under `coarseRel`,
  - plus a companion noise theorem: `coarse_noise_response = fine_response after pulled_back_test` and PSD preserved.
