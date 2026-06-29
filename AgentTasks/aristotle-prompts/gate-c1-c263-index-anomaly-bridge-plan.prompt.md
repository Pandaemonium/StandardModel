# Aristotle job C263: Gate C1 index/anomaly bridge plan

This is a non-blocking strategy/proof-design job for the PhysicsSM null-edge Gate C1 program.

Context:
- The repo already has kernel-checked Standard Model anomaly cancellation and Furey/Hughes-adjacent anomaly bridge modules.
- Aristotle C260 judged that this existing work is useful but only as a particle-content certificate, not as a C1 operator/index anomaly certificate.
- The overlap operator should satisfy a Ginsparg-Wilson relation, and the full physical C1 anomaly obligation should involve the lattice index/anomaly realization plus no spurious mirror/ghost anomaly contribution.

Please read the included anomaly files/notes and produce a Markdown report named:

GateC1_IndexAnomalyBridge_Plan.md

Answer:
1. What exact content bridge theorem should connect null-edge retained spectrum to the existing Standard Model anomaly package?
2. What exact operator/index theorem statements are needed beyond content cancellation?
3. How should we state no-spurious-mirror-anomaly/no-propagator-zero-cheat as a Lean predicate or theorem obligation?
4. Which pieces can be proved soon as finite-dimensional algebra, and which require serious lattice gauge/index theory?
5. Give 3-5 near-Lean theorem statements with target files.

Be careful not to overclaim: existing anomaly cancellation is prerequisite content bookkeeping, not full C1 anomaly realization.
