# Chevalley incidence on the full normalized vacuum chart

Prove
`annihilatorIntersectionDim_vacuum_eq_three_of_quadric_chart` in
`PhysicsSM/Draft/Spin10VacuumChartIncidence.lean`.

The fixed ordered creation-root product now reconstructs every normalized
even spinor satisfying the Cartan quadrics. Use that explicit chart, the
orthogonality equation, and projective distinctness to compute the common
annihilator dimension. The previous return handles only a single basis-two
direction; this target permits all degree-two coordinates and their forced
degree-four Pluecker coordinates. Do not close the theorem through the open
general incidence or normal-form handoffs. Purity/quadric, orthogonality, and
distinctness are all scientifically essential and may not be dropped. Seek an
exact counterexample if the statement is false. Otherwise remove the proof
hole, add an axiom guard, and run the narrow file. Read `CONTEXT.md`.
