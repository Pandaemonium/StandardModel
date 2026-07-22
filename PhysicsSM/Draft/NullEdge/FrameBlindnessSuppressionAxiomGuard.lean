import PhysicsSM.Draft.NullEdge.FrameBlindnessSuppression

/-! Build-enforced axiom footprint for finite-group frame-blindness suppression. -/

/-- info: 'FrameBlindness.suppression_on_orbit_span' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms FrameBlindness.suppression_on_orbit_span

/-- info: 'FrameBlindness.invariantWitness_properties' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms FrameBlindness.invariantWitness_properties

/-- info: 'FrameBlindness.selectiveWitness_kernel_on_zeroSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms FrameBlindness.selectiveWitness_kernel_on_zeroSum

/-- info: 'FrameBlindness.selectiveWitness_sharp' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs(info) in
#print axioms FrameBlindness.selectiveWitness_sharp
