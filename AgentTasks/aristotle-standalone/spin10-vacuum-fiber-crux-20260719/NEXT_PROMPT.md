# Spin(10) marked vacuum-fiber transitivity crux

Prove `exists_vacuumStabilizer_smul_eq_scalar_weak` in
`PhysicsSM/Draft/Spin10VacuumFiberTransitivity.lean`. The two warmups and the
scalar-line special case are already proved. The target is stabilizer
transitivity on the complete `d = 3` pure-spinor fiber.

Use only clean proved declarations; do not close the goal via the documented
general-incidence or normal-form holes in imported draft modules. Develop
explicit stabilizer generators, an adapted two-mode complement, or a clean
coordinate-chart reduction. A counterexample is first-class. If the general
statement cannot yet be reached, land the largest nontrivial chart/basis family
and list at most three exact missing lemmas. No statement weakening, new
assumptions, or compiler-trusted procedures. Run the narrow target and print
axioms. Read `CONTEXT.md`.
