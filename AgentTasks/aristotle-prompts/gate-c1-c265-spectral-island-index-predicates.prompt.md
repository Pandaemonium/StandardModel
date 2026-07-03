# Aristotle job C265: spectral island and branch-index predicates

This is a non-blocking theorem-design job for the PhysicsSM null-edge Gate C1 program.

Context:
- C262 clarified that scalar Wilson gives only the true inverse bad-sector gap clause.
- Physical branch retention requires a target spectral island separated by delta > 0 and a nonzero origin/chiral index.
- We need definitions and theorem statements before choosing a concrete `W_branch`.

Please produce a report named:

GateC1_SpectralIslandIndex_Predicates.md

Answer:
1. What finite-dimensional Lean predicates should represent a separated target spectral island?
2. Should we use explicit finite spectra, polynomial spectral projectors, Riesz projector as an abstract predicate, or matrix block decomposition first?
3. How should `nonzero origin chiral index` be represented in finite matrix Lean without overclaiming analytic index theory?
4. Give a `BranchRetentionCertificate` structure with exactly the three clauses: island separation, nonzero index, true inverse bad-sector gap.
5. Provide near-Lean theorem statements and acceptance tests, including a zero-index commuting trap theorem.

Keep it finite-dimensional and draft-safe. Do not depend on overlap locality or gauge fields.
