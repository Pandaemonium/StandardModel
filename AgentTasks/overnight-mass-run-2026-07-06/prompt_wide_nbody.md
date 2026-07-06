Lane A (aperture), toward the full origin of mass. Generalize the composite
aperture mass to N null constituents. Create NEW
`PhysicsSM/Draft/NullEdge/GateI1/NBodyAperture.lean`. Reuse
`CompositeApertureMass` (minkDot, minkowskiSq, IsFutureNull,
compositeMassSq_eq_sum_pairwise, compositeMassSq_eq_zero_iff_collinear) and
`ApertureEqualsTurn`. Check with `lake env lean`.

Prove (finite/kinematic, standard axioms): for a Finset of future-null momenta
`p : iota -> Momentum4`, (1) `minkowskiSq (sum p_i) = sum_{i<j} 2 minkDot p_i p_j`
with each `minkDot p_i p_j >= 0` (already have the pieces - assemble the N-body
nonnegativity `compositeMassSq_nonneg`); (2) the headline N-body aperture:
`minkowskiSq (sum p_i) = 0 <-> all p_i collinear` (single null direction) - i.e.
the composite is massless iff it is effectively one null edge, for ANY N. This is
the full N-body statement of "mass = aperture of the null bundle". No new axiom /
native_decide / weakening. If lake build stalls, SKIP; return source.
