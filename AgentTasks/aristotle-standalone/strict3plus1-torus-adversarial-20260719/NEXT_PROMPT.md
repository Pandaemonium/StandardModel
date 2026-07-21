# Adversarial strict 3+1 torus doubling

The only open target is
`PhysicsSM/Draft/NullEdge/Strict3Plus1TorusDoubling.lean` theorem
`admissible_doubling_torus`. Decide it: prove it, construct a kernel-checkable
counterexample, or identify the minimal missing topological hypothesis.

Treat `AdmissibleWalk` exactly as defined. In particular, audit whether local
Dirac tangent, continuity, periodicity, and unitarity alone force a second
zero-or-pi crossing away from the origin lattice. Do not infer determinant
doubling from coefficient zeros. A false statement with a concrete admissible
walk is a full success. If an added charge/balance hypothesis is necessary,
state the sharp corrected theorem separately while leaving the original hole
visible. Run the target file first; no new assumptions or compiler-trusted
procedures. Read `CONTEXT.md`.
