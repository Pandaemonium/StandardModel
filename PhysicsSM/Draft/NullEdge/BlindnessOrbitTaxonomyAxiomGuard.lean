import PhysicsSM.Draft.NullEdge.BlindnessOrbitTaxonomy

/-! Build-enforced axiom footprint for the three-way blindness taxonomy. -/

/-- info: 'Blindness.invariant_iff_factors_through_orbits' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms Blindness.invariant_iff_factors_through_orbits

/-- info: 'Blindness.SpectrumWeight.both_weight_extremes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms Blindness.SpectrumWeight.both_weight_extremes

/-- info: 'Blindness.GaugeOverlap.invariant_operators_can_have_zero_or_nonzero_overlap' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs(info) in
#print axioms Blindness.GaugeOverlap.invariant_operators_can_have_zero_or_nonzero_overlap

/-- info: 'Blindness.UniformShift.rawTrace_not_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms Blindness.UniformShift.rawTrace_not_invariant
