# Aristotle job C268: production overlap-index layer

This is a non-blocking Lean/proof-design job for the PhysicsSM null-edge Gate C1 program.

Context:
- C266 produced `OverlapIndexToy.lean`, correcting the sign intuition: with `Dov = 1 + gamma5 eps`, `overlapIndex = 1/2(Tr gamma5 - Tr eps)`, so anticommutation forces zero index while a commuting classifier can carry nonzero index.
- C263 proposed a later bridge to the Standard Model anomaly package.
- We now need a less toy-like `OverlapIndex.lean` layer that keeps the finite-dimensional scope but is suitable for downstream anomaly wiring.

Please produce a report named `GateC1_OverlapIndex_ProductionReport.md`.

If feasible, also produce a Lean draft `PhysicsSM/Draft/NullEdge/GateC1/OverlapIndex.lean` with no open placeholders.

Requested target:
1. Move the robust parts of `OverlapIndexToy` into production-style names and theorem statements.
2. Add a finite-dimensional integrality route if feasible: trace of an idempotent/projector equals rank, or index as a difference of projector ranks.
3. Pin the sign/normalization choices needed before connecting to rational anomaly weights.
4. Propose the next `IndexAnomalyBridge.lean` theorem statements against `StandardModel/AnomalyPackage.lean`.
5. Keep the claim boundary explicit: no locality, gauge covariance, or infinite-volume index theorem.

Avoid raw placeholder tokens in prose. Do not weaken theorem statements silently.
