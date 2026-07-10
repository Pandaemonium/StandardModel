import PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

/-!
# Conserved finite oscillator dynamics from the Pluecker mass scale

The positive Pluecker scale can be used as the frequency of an exact finite
oscillator step. On the normalized circle `c^2 + s^2 = 1`, the displayed
rotation in `(q,p)` coordinates preserves the quadratic energy exactly. When
`m^2` is the Pluecker mass of the supplied spinor pair, the conserved potential
coefficient is the same invariant as the positive-direction Hessian of the
finite Pluecker action.

This supplies a genuine action-to-curvature-to-conserved-dynamics composition.
The oscillator step and the choice of a square root `m` remain supplied; it is
not yet a unique variational integrator or a field-theoretic Noether theorem.

Provenance: oscillator conservation proof completed by Aristotle project
`52ffa150-41b6-495f-82d5-c733c478cba7`; clean-room composition through the
project Pluecker action API on 2026-07-10. The theorem shape was cross-checked
against PhysLean's harmonic-oscillator conservation declarations.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorDynamics

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.CanonicalGramTurnDictionary
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

abbrev OscillatorState := ℝ × ℝ

/-- Quadratic oscillator energy, without an inessential factor of `1/2`. -/
def energy (m : ℝ) (x : OscillatorState) : ℝ :=
  x.2 ^ 2 + m ^ 2 * x.1 ^ 2

/-- Exact oscillator rotation in `(q,p)` coordinates. -/
noncomputable def step (m c s : ℝ) (x : OscillatorState) : OscillatorState :=
  (c * x.1 + s / m * x.2, -m * s * x.1 + c * x.2)

/-- The displayed finite equation-of-motion step preserves energy exactly. -/
theorem energy_conserved (m c s : ℝ) (hm : m ≠ 0)
    (hcs : c ^ 2 + s ^ 2 = 1) (x : OscillatorState) :
    energy m (step m c s x) = energy m x := by
  simp only [energy, step]
  field_simp
  linear_combination (x.2 ^ 2 + m ^ 2 * x.1 ^ 2) * hcs

/-- If `m^2` is the pair's Pluecker mass, the oscillator energy is conserved
and its potential coefficient is exactly the finite action Hessian. -/
theorem hessian_energy_conserved
    (psi phi : CSpinor) (m c s : ℝ) (hm : m ≠ 0)
    (hms : m ^ 2 = massSq psi phi) (hcs : c ^ 2 + s ^ 2 = 1)
    (x : OscillatorState) (q : Quartet) :
    energy m (step m c s x) = energy m x ∧
      m ^ 2 = action psi phi (q + qe2) + action psi phi (q - qe2) -
        2 * action psi phi q := by
  refine ⟨energy_conserved m c s hm hcs x, ?_⟩
  rw [action_positive_hessian, hms]

/-- A nonzero rational control: Pluecker scale `2/5`, normalized step
`(c,s)=(3/5,4/5)`, and initial state `(1,2)`. -/
theorem rational_plucker_oscillator_control :
    energy (2 / 5) (step (2 / 5) (3 / 5) (4 / 5)
      ((1, 2) : OscillatorState)) =
        energy (2 / 5) ((1, 2) : OscillatorState) ∧
      (2 / 5 : ℝ) ^ 2 = massSq edge0 (edge1 (2 / 5)) ∧
      action edge0 (edge1 (2 / 5)) (qe2 + qe2) +
          action edge0 (edge1 (2 / 5)) (qe2 - qe2) -
          2 * action edge0 (edge1 (2 / 5)) qe2 = 4 / 25 := by
  constructor
  · norm_num [energy, step]
  constructor
  · norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]
  · rw [action_positive_hessian]
    norm_num [massSq, edge0, edge1, spinorWedge, Complex.normSq]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorDynamics.hessian_energy_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hessian_energy_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorDynamics.rational_plucker_oscillator_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_plucker_oscillator_control

end PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorDynamics
