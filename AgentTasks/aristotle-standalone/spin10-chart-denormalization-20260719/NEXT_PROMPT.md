# Exact denormalization of the Spin(10) vacuum chart

Prove
`exists_evenCliffordGroup_vacuum_eq_of_nonzero_quadric_chart` in
`PhysicsSM/Draft/Spin10VacuumChartDenormalization.lean`.

The normalized chart reconstruction is now axiom-clean. Scale `ψ` by the
inverse of its nonzero vacuum coordinate, prove evenness and the Cartan
quadrics survive that scaling, apply the reconstruction theorem, and compose
with the existing algebraic `scalarUnit`. Keep all order and scalar-action
conventions exact. Do not use the older open chart-reconstruction handoff in
`Spin10StandardizablePairs`; use the proved successor module. Do not work on
global chart entry. Run the target file directly, remove the proof hole, add an
axiom guard, and report either a complete proof or an exact type/API blocker.
Read `CONTEXT.md` first.
