import PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

/-!
# Homogeneous Pluecker action cannot select a nonzero mass scale

The landed finite Pluecker action derives a mass curvature from supplied
spinors, but it does not select their overall normalization.  Under a common
real rescaling of both primitive spinors, the action is exactly quartic.  At
every configuration with positive unscaled action, the scale equation has the
unique stationary solution `t = 0`.  Thus this positive homogeneous action
collapses the scale instead of spontaneously selecting a nonzero mass.

The explicit orthogonal-spinor/quartet witness has positive action `1/2`, so
the no-go is nonvacuous.  A nonzero selected scale requires an additional
term with different homogeneity, a constraint, an ensemble scale, or another
dimensionful input.  This module does not claim that all possible null-edge
actions share the obstruction.

Provenance: clean-room scale audit of `PluckerActionHessian.action`, using the
project's explicit Pluecker coordinate.  Lean 4.28.0.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerScaleSelectionNoGo

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

abbrev Quartet :=
  PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.Quartet

abbrev qe2 :=
  PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.qe2

/-- Common rescaling of both primitive spinors in the finite action. -/
def scaleProfile (psi phi : CSpinor) (x : Quartet) (t : Real) : Real :=
  action ((t : Complex) • psi) ((t : Complex) • phi) x

/-- Exact quartic homogeneity of the Pluecker action under common scaling. -/
theorem scaleProfile_eq (psi phi : CSpinor) (x : Quartet) (t : Real) :
    scaleProfile psi phi x t = t ^ 4 * action psi phi x := by
  unfold scaleProfile action massSq spinorWedge
  simp [Complex.normSq, pow_succ]
  ring

/-- The scale equation is the derivative of the exact quartic profile. -/
theorem scaleProfile_hasDerivAt (psi phi : CSpinor) (x : Quartet) (t : Real) :
    HasDerivAt (scaleProfile psi phi x)
      (4 * t ^ 3 * action psi phi x) t := by
  rw [show scaleProfile psi phi x =
      fun s => s ^ 4 * action psi phi x by
        funext s
        exact scaleProfile_eq psi phi x s]
  convert ((hasDerivAt_pow 4 t).mul_const (action psi phi x)) using 1

/-- A positive homogeneous Pluecker action has only the collapsed stationary
scale. -/
theorem scale_stationary_iff_zero (psi phi : CSpinor) (x : Quartet)
    (hpos : 0 < action psi phi x) (t : Real) :
    4 * t ^ 3 * action psi phi x = 0 ↔ t = 0 := by
  constructor
  · intro h
    rcases mul_eq_zero.mp h with hleft | ha
    · rcases mul_eq_zero.mp hleft with hfour | ht
      · norm_num at hfour
      · exact eq_zero_of_pow_eq_zero ht
    · exact False.elim (ne_of_gt hpos ha)
  · rintro rfl
    ring

/-- No nonzero common scale can solve the scale equation when the unscaled
action is positive. -/
theorem no_nonzero_stationary_scale (psi phi : CSpinor) (x : Quartet)
    (hpos : 0 < action psi phi x) :
    ¬ ∃ t : Real, t ≠ 0 ∧ 4 * t ^ 3 * action psi phi x = 0 := by
  rintro ⟨t, ht, heom⟩
  exact ht ((scale_stationary_iff_zero psi phi x hpos t).mp heom)

def psiWitness : CSpinor := ![1, 0]
def phiWitness : CSpinor := ![0, 1]

/-- Nondegenerate exact fixture: orthogonal primitive spinors and the positive
quartet direction give action `1/2`, hence no nonzero stationary scale. -/
theorem positive_action_control :
    action psiWitness phiWitness qe2 = 1 / 2 ∧
      ¬ ∃ t : Real, t ≠ 0 ∧
        4 * t ^ 3 * action psiWitness phiWitness qe2 = 0 := by
  have haction : action psiWitness phiWitness qe2 = 1 / 2 := by
    change (1 / 2 : Real) *
      Complex.normSq (spinorWedge psiWitness phiWitness) * (qe2 2) ^ 2 = 1 / 2
    have hwedge : spinorWedge psiWitness phiWitness = 1 := by
      norm_num [psiWitness, phiWitness, spinorWedge]
    have hq : qe2 2 = 1 := by rfl
    rw [hwedge, hq]
    norm_num [Complex.normSq]
  refine ⟨haction, ?_⟩
  apply no_nonzero_stationary_scale
  rw [haction]
  norm_num

/-- A homogeneity-breaking radial potential with supplied scale `c`. -/
def scaleBreakingPotential (c t : Real) : Real := (t ^ 2 - c) ^ 2

def scaleBreakingEom (c t : Real) : Real := 4 * t * (t ^ 2 - c)

/-- The supplied scale creates nonzero stationary radii exactly when
`t^2 = c`; the collapsed stationary point remains. -/
theorem scaleBreaking_eom_zero_iff (c t : Real) :
    scaleBreakingEom c t = 0 ↔ t = 0 ∨ t ^ 2 = c := by
  unfold scaleBreakingEom
  rw [mul_eq_zero]
  constructor
  · intro h
    rcases h with h | h
    · exact Or.inl ((mul_eq_zero.mp h).resolve_left (by norm_num))
    · exact Or.inr (sub_eq_zero.mp h)
  · intro h
    rcases h with rfl | h
    · left
      ring
    · right
      exact sub_eq_zero.mpr h

/-- Exact positive control: after supplying unit scale, `t = 1` and `t = -1` are
nonzero stationary global minima.  Their magnitude is the supplied input. -/
theorem supplied_unit_scale_control :
    scaleBreakingEom 1 1 = 0 ∧ scaleBreakingEom 1 (-1) = 0 ∧
      (1 : Real) ≠ 0 ∧ (-1 : Real) ≠ 0 ∧
      scaleBreakingPotential 1 1 = 0 ∧ scaleBreakingPotential 1 (-1) = 0 ∧
      ∀ t : Real, 0 ≤ scaleBreakingPotential 1 t := by
  norm_num [scaleBreakingEom, scaleBreakingPotential]
  intro t
  positivity

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerScaleSelectionNoGo.no_nonzero_stationary_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_nonzero_stationary_scale

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerScaleSelectionNoGo.positive_action_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_action_control

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerScaleSelectionNoGo.supplied_unit_scale_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms supplied_unit_scale_control

end PhysicsSM.Draft.NullEdge.Carrier.PluckerScaleSelectionNoGo
