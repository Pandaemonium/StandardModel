import Mathlib

/-!
# Finite homogeneous actions cannot select an isolated positive scale

This module isolates the radial obstruction behind the existing quartic
Pluecker scale-collapse result.  If an action is positive at a configuration
and its radial profile is homogeneous of positive natural degree, the radial
derivative at unit scale is strictly positive.  The configuration therefore
cannot be stationary.  Degree zero is the complementary control: the radial
profile is flat and cannot select an isolated scale.

This is a finite variational no-go.  It does not exclude dimensional
transmutation in a refining family with running dimensionless couplings.
-/

namespace PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo

/-- The derivative of a positive homogeneous radial profile is nonzero at unit
scale, so zero radial derivative is impossible. -/
theorem no_zero_derivative_positive_homogeneous_profile
    (p : Nat) (hp : 0 < p) (S : Real) (hS : 0 < S) :
    ¬ HasDerivAt (fun r : Real => r ^ p * S) 0 1 := by
  intro hzero
  have hcanonical :
      HasDerivAt (fun r : Real => r ^ p * S) ((p : Real) * S) 1 := by
    convert (hasDerivAt_pow p (1 : Real)).mul_const S using 1
    all_goals norm_num
  have heq : (p : Real) * S = 0 := hcanonical.unique hzero
  have hpos : 0 < (p : Real) * S :=
    mul_pos (Nat.cast_pos.mpr hp) hS
  exact (ne_of_gt hpos) heq

/-- A positive-degree homogeneous action cannot be stationary at a positive
configuration, because stationarity would include the radial variation. -/
theorem no_stationary_positive_homogeneous_action
    {E : Type*} [SMul Real E]
    (action : E -> Real) (x : E) (p : Nat) (hp : 0 < p)
    (hpositive : 0 < action x)
    (hhomogeneous : ∀ r : Real, action (r • x) = r ^ p * action x) :
    ¬ HasDerivAt (fun r : Real => action (r • x)) 0 1 := by
  intro hstationary
  apply no_zero_derivative_positive_homogeneous_profile p hp (action x) hpositive
  simpa only [hhomogeneous] using hstationary

/-- Degree-zero control: a homogeneous radial profile is exactly flat and has
zero derivative everywhere. -/
theorem degree_zero_profile_flat (S x : Real) :
    HasDerivAt (fun r : Real => r ^ (0 : Nat) * S) 0 x := by
  simpa using hasDerivAt_const x S

/-- Explicit nondegenerate degree-four witness: the unit-scale radial
derivative is exactly four. -/
theorem quartic_unit_witness :
    HasDerivAt (fun r : Real => r ^ (4 : Nat)) 4 1 := by
  convert hasDerivAt_pow 4 (1 : Real) using 1
  all_goals norm_num

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo.no_zero_derivative_positive_homogeneous_profile' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_zero_derivative_positive_homogeneous_profile

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo.no_stationary_positive_homogeneous_action' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_stationary_positive_homogeneous_action

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo.degree_zero_profile_flat' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms degree_zero_profile_flat

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo.quartic_unit_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartic_unit_witness

end PhysicsSM.Draft.NullEdge.FiniteHomogeneousScaleNoGo
