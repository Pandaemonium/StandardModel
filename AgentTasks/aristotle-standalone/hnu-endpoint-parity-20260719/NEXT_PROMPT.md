# HNU endpoint-reversal parity core

Work only on `PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean` and its
included dependencies. Prove `endpoint_eq_momentumReverse_iff`; helper lemmas
may be added in that file. The intended result is the exact parity census for
the depth-eight HNU endpoint, not an infrared approximation.

Start from the explicit SU(2)/Pauli endpoint entries. A good intermediate is
that equality with the reversed endpoint forces the relevant sine coefficients
to vanish and the cosine product to be extremal. Preserve the exact factor
order and corrected HNU signs. Do not touch the two later spectral-gap holes.

If the iff is false, return an exact counterexample and the sharp corrected
statement. No new assumptions or compiler-trusted decision procedures. Run
`lake env lean PhysicsSM/Draft/NullEdge/HNUMassiveGlobalGap.lean` and report the
assumption footprint of every theorem proved. Read `CONTEXT.md` first.
