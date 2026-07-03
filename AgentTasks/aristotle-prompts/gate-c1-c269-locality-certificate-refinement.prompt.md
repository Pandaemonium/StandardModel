# Aristotle job C269: overlap locality certificate refinement

This is a non-blocking theorem-design/audit job for the PhysicsSM null-edge Gate C1 program.

Context:
- C261 produced `OverlapLocality.lean`, a finite-dimensional range algebra and polynomial-approximant route to exponential locality of a sign-kernel surrogate.
- Full physical C1 still needs a literature-aligned locality theorem for `sign(H_ne)` under a gap and admissible/smooth gauge fields.
- We need to refine the finite scaffold into named certificates that can later connect to Hernandez-Jansen-Luscher or domain-wall transfer-matrix hypotheses.

Please produce a report named `GateC1_LocalityCertificate_Refinement.md`.

If feasible, also produce a Lean draft extending or complementing `OverlapLocality.lean` with certificate structures, but do not block on proof of analytic locality.

Requested target:
1. Define the minimal certificate structures: finite range/bounded hopping, gap interval, polynomial sign approximation family, exponential approximation rate, and optional gauge admissibility placeholder.
2. Explain which parts are already finite-dimensional Lean algebra and which are external analytic/literature hypotheses.
3. Give near-Lean theorem statements connecting those certificates to `ExpLocal`.
4. Identify the exact literature theorem we should cite or formalize next, and which hypotheses must be mirrored.
5. Keep this independent of local scalar `Kfree/Hfree` assembly.

Avoid raw placeholder tokens in prose. Do not overclaim full physical locality.
