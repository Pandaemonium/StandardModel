/-
# Axiom guard for `CubeLawTripotent`

Build-enforced trust footprint for the shared cube-closure -> tripotent corollary
(`PhysicsSM/Draft/NullEdge/CubeLawTripotent.lean`, harvested from Aristotle job
`f8753b41`). Each pin records the exact kernel footprint; a regression (a `sorry`,
an `axiom`, or a `native_decide` entering a transitive proof) breaks this build.

All pins are `native_decide`-free. Note `tripotent_partial_involution` depends only
on `[propext]` (pure `pow`/`rw` reasoning, no choice), so it is pinned at that
sharper footprint; the two normalized-tripotent instantiations and the real-scalar
normalizer pull in the standard `[propext, Classical.choice, Quot.sound]`.
-/
import PhysicsSM.Draft.NullEdge.CubeLawTripotent

namespace PhysicsSM.Draft.NullEdge.CubeLawTripotentAxiomGuard

/-- info: 'CubeLawTripotent.cube_to_tripotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CubeLawTripotent.cube_to_tripotent

/-- info: 'CubeLawTripotent.tripotent_partial_involution' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms CubeLawTripotent.tripotent_partial_involution

/-- info: 'CubeLawTripotent.restOp_normalized_tripotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CubeLawTripotent.restOp_normalized_tripotent

/-- info: 'CubeLawTripotent.pairGenSector_normalized_tripotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CubeLawTripotent.pairGenSector_normalized_tripotent

end PhysicsSM.Draft.NullEdge.CubeLawTripotentAxiomGuard
