# Aristotle job C261: Gate C1 overlap locality theorem plan

This is a non-blocking strategy/proof-design job for the PhysicsSM null-edge Gate C1 program. Do not work on the finite/free operator glue; Codex is doing that locally.

Context:
- The active architecture is tetrahedral/null-edge Hermitian Wilson kernel -> Neuberger overlap release.
- The finite/free gap is close; the hard physical C1 gate is locality/quasi-locality of sign(H_ne).
- Ultralocality is not required. Controlled non-ultralocality is acceptable.
- We need theorem statements suitable for Lean, not a broad essay.

Please read the included plan/context files and produce a Markdown report named:

GateC1_OverlapLocality_TheoremPlan.md

Answer:
1. What exact locality/quasi-locality theorem should we state first for sign(H_ne)?
2. What hypotheses are minimally needed: finite volume gap, bounded hopping range, admissible gauge field, resolvent bound, polynomial/rational approximation, domain-wall transfer gap?
3. Which route is most formalization-friendly in Lean: direct functional calculus, rational approximation, Combes-Thomas/resolvent expansion, or domain-wall transfer matrix?
4. Give 3-5 near-Lean theorem statements, with definitions/predicates we need to introduce.
5. Identify what can be proved in finite-dimensional matrix algebra first, before analytic infinite-volume locality.
6. List precise open questions for Pro/literature.

Be concrete and tactical. This job should unblock future locality work but should not depend on current finite/free Hfree assembly.
