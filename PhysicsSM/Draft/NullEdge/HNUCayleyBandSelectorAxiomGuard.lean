import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector

/-!
# Assumption-footprint guards for the massive HNU Cayley band selector

These guards pin the inverse-Cayley Hermiticity and invertibility bridge, the
live massive-HNU certified sign, and its negative-sign orthogonal projector to
Lean/Mathlib's standard three principles.  They do not assert position-space
locality, rank, or a physical occupied-sector interpretation.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.cayleyGenerator_isHermitian' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.cayleyGenerator_isHermitian

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.cayleyGenerator_isUnit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.cayleyGenerator_isUnit

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.hnuCayley_certifiedSign_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.hnuCayley_certifiedSign_exists

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.hnuCayley_negativeProjector_exists' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelector.hnuCayley_negativeProjector_exists
