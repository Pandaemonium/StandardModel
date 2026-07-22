import PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical

/-!
# Assumption-footprint guards for the canonical massive HNU Cayley selector

These guards pin endpoint commutation, the exact rest-frame inverse Cayley
formula, the positive sign certificate, certified-sign uniqueness, and the
negative-projector convention to Lean/Mathlib's standard three principles.
They do not assert that the selected band is the complete physical sector or
that its momentum-space projector is local in position space.
-/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.certifiedSign_commutes_cayleyUnitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.certifiedSign_commutes_cayleyUnitary

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayley_certifiedSign_commutes_endpoint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayley_certifiedSign_commutes_endpoint

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayleyGenerator_rest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayleyGenerator_rest

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.beta_signCertificate_rest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.beta_signCertificate_rest

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayley_certifiedSign_rest_unique' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayley_certifiedSign_rest_unique

/-- info: 'PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayley_negativeProjector_rest' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HNUCayleyBandSelectorCanonical.hnuCayley_negativeProjector_rest
