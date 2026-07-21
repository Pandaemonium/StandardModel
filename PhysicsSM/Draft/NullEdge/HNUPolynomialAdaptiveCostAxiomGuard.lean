import PhysicsSM.Draft.NullEdge.HNUPolynomialAdaptiveCost

/-!
# Axiom guards for polynomial unitary-product cost and the exact HNU word
-/

/-- info: 'HNUPolynomialAdaptiveCost.skewHermitian_ordered_product_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HNUPolynomialAdaptiveCost.skewHermitian_ordered_product_bound

/-- info: 'HNUPolynomialAdaptiveCost.unitary_power_telescope_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HNUPolynomialAdaptiveCost.unitary_power_telescope_bound

/-- info: 'HNUPolynomialAdaptiveCost.polynomialSteps_changing_window_cubic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HNUPolynomialAdaptiveCost.polynomialSteps_changing_window_cubic

/-- info: 'HNUPolynomialAdaptiveCost.hnuEndpoint_eq_ordered_exponential_word' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms HNUPolynomialAdaptiveCost.hnuEndpoint_eq_ordered_exponential_word
