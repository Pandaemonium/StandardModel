# Aristotle job C266: finite overlap-index toy layer and zero-index trap

This is a non-blocking proof/design job for the PhysicsSM null-edge Gate C1 program.

Context:
- C263 proposed a finite-dimensional `OverlapIndex.lean` layer with `Ghat`, `overlapIndex`, trace/index rewrites, and zero-index/nonzero-index toy witnesses.
- The local repo already has `OverlapGinspargWilson.dov_ginsparg_wilson` for `Dov = 1 + gamma5 * eps`.
- Codex is locally working on finite/free operator assembly, so this job should focus on the overlap-index algebra and toy acceptance tests.

Please produce a report named:

GateC1_OverlapIndexToy_Layer.md

If feasible, also produce a Lean draft file `OverlapIndexToy.lean` with sorry-free finite matrix lemmas. If not feasible, give exact theorem statements and proof plans.

Answer:
1. What is the correct normalized definition of `Ghat` and `overlapIndex` for `Dov = 1 + gamma5 * eps`?
2. Prove or outline the trace formula in finite matrix algebra.
3. Prove or outline a zero-index theorem when the candidate classifier commutes with chirality.
4. Provide a concrete finite toy witness with nonzero index, or explain what extra hypotheses are required.
5. Identify sign/normalization choices we must pin before connecting to Standard Model anomaly weights.

Keep the scope finite-dimensional. Do not attempt locality, gauge covariance, or infinite-volume index theory.
