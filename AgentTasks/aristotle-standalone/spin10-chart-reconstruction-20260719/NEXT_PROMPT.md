# Pure-spinor affine chart reconstruction

Prove `exists_creationRoots_vacuum_eq_of_quadric_chart` in
`PhysicsSM/Draft/Spin10VacuumChartReconstruction.lean`, using the five proved
degree-four coordinate formulas in
`PhysicsSM/Draft/Spin10VacuumChartQuadrics.lean`.

The target says that every normalized even spinor satisfying the Cartan
quadrics is a finite product of the ten explicit `creationRootEnd` operations
applied to `vacuumSpinor`. Expand the product by degree, use the five chart
quadrics for degree four, and use evenness for odd degrees. Preserve the
existing root order and signs. Do not work on the global chart-entry or pair
transitivity holes. No new assumptions or compiler-trusted procedures. Return
an axiom-clean theorem or an exact sign/order counterexample. Run the successor
module directly and read `CONTEXT.md`.
