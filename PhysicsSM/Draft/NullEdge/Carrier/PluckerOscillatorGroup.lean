import PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorDynamics

/-!
# Reversible group law for the finite Pluecker oscillator

The exact oscillator flow belongs to a determinant-one reversible matrix
family. Normalized parameters preserve energy, negating the sine parameter is
the two-sided inverse, and composing two steps obeys the exact angle-addition
law. The conserved potential coefficient composes with the finite Pluecker
action Hessian.

The flow family remains supplied; the successor module must derive a recurrence
from an adjacent-link variational principle.

Provenance: proofs completed by Aristotle project
`c1093296-8fc9-45ac-9c88-20f1b5856cd3`; clean-room project composition on
2026-07-10.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorGroup

open PhysicsSM.Spinor.PluckerMass
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
open PhysicsSM.Draft.NullEdge.Carrier.PluckerActionHessian

abbrev VectorState := Fin 2 → ℝ

noncomputable def stepMatrix (m c s : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![c, s / m; -m * s, c]

def vectorEnergy (m : ℝ) (x : VectorState) : ℝ :=
  (x 1) ^ 2 + m ^ 2 * (x 0) ^ 2

noncomputable def matrixStep (m c s : ℝ) (x : VectorState) : VectorState :=
  stepMatrix m c s *ᵥ x

theorem step_determinant_one (m c s : ℝ) (hm : m ≠ 0)
    (hcs : c ^ 2 + s ^ 2 = 1) :
    Matrix.det (stepMatrix m c s) = 1 := by
  unfold stepMatrix
  norm_num
  ring_nf
  aesop

theorem step_inverse (m c s : ℝ) (hm : m ≠ 0)
    (hcs : c ^ 2 + s ^ 2 = 1) :
    stepMatrix m c s * stepMatrix m c (-s) = 1 ∧
      stepMatrix m c (-s) * stepMatrix m c s = 1 := by
  constructor <;> ext i j <;> fin_cases i <;> fin_cases j <;>
    norm_num [stepMatrix] <;> ring_nf
  · aesop
  · grind
  · aesop
  · grind

theorem step_composition (m c₁ s₁ c₂ s₂ : ℝ) (hm : m ≠ 0) :
    stepMatrix m c₁ s₁ * stepMatrix m c₂ s₂ =
      stepMatrix m (c₁ * c₂ - s₁ * s₂)
        (s₁ * c₂ + c₁ * s₂) := by
  unfold stepMatrix
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply] <;> ring
  · norm_num [hm]
  · grind

theorem vector_energy_conserved (m c s : ℝ) (hm : m ≠ 0)
    (hcs : c ^ 2 + s ^ 2 = 1) (x : VectorState) :
    vectorEnergy m (matrixStep m c s x) = vectorEnergy m x := by
  unfold vectorEnergy matrixStep
  simp +decide [*, Matrix.mulVec]
  ring
  unfold stepMatrix
  norm_num
  ring
  grind

/-- The reversible flow conserves energy and uses exactly the action Hessian as
its potential coefficient. -/
theorem group_hessian_energy_conserved
    (psi phi : CSpinor) (m c s : ℝ) (hm : m ≠ 0)
    (hms : m ^ 2 = massSq psi phi) (hcs : c ^ 2 + s ^ 2 = 1)
    (x : VectorState) (q : Quartet) :
    vectorEnergy m (matrixStep m c s x) = vectorEnergy m x ∧
      m ^ 2 = action psi phi (q + qe2) + action psi phi (q - qe2) -
        2 * action psi phi q := by
  refine ⟨vector_energy_conserved m c s hm hcs x, ?_⟩
  rw [action_positive_hessian, hms]

theorem rational_reversible_control :
    Matrix.det (stepMatrix (2 / 5) (3 / 5) (4 / 5)) = 1 ∧
      stepMatrix (2 / 5) (3 / 5) (4 / 5) *
        stepMatrix (2 / 5) (3 / 5) (-4 / 5) = 1 := by
  norm_num [stepMatrix, Matrix.det_fin_two, Matrix.mul_apply]
  exact Matrix.one_fin_two.symm

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorGroup.group_hessian_energy_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms group_hessian_energy_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorGroup.rational_reversible_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_reversible_control

end PhysicsSM.Draft.NullEdge.Carrier.PluckerOscillatorGroup
