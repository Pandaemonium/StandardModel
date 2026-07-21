import PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
import PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling

/-!
# Momentum Lipschitz bound for the exact massive HNU Dirac flow

The Pluecker mass matrix is independent of momentum. It therefore cancels
exactly when two massive Dirac generators are compared, leaving the same
coordinate-L1 momentum bound as in the massless Weyl sector. Combining that
identity with the dimension-generic Hermitian-exponential estimate gives the
cell-variation bound needed by the massive changing-lattice composition.

The bound is uniform in the fixed complex mass parameter. This module does
not perform the cell integral, construct a projection, or claim a
position-space continuum limit.

Provenance: clean-room composition of `HermitianExpLipschitz`,
`HNUMassiveContinuumReduction`, and `ChangingMomentumCellSampling`, July 20,
2026. Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz

open HNUManyStepContinuum
open HNUPlueckerMassiveStay
open HNUMassiveContinuumReduction
open Pluecker3Plus1ComplexMass
open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling

/-- The doubled kinetic symbol is linear in momentum differences. -/
theorem kinetic4_sub_kinetic4_eq (q p : Fin 3 -> Real) :
    kinetic4 q - kinetic4 p = kinetic4 (q - p) := by
  unfold kinetic4
  ext i j
  simp [Pi.sub_apply]
  ring

/-- The constant mass term cancels from a momentum difference. -/
theorem massiveGenerator_sub_eq (z : Complex) (q p : Fin 3 -> Real) :
    massiveGenerator z q - massiveGenerator z p = kinetic4 (q - p) := by
  rw [massiveGenerator, massiveGenerator]
  rw [← kinetic4_sub_kinetic4_eq]
  abel

/-- The massive generator is Lipschitz in coordinate-L1 momentum distance,
with no dependence on the fixed mass parameter. -/
theorem norm_massiveGenerator_sub_le_l1 (z : Complex)
    (q p : Fin 3 -> Real) :
    norm (massiveGenerator z q - massiveGenerator z p) <=
      |q 0 - p 0| + |q 1 - p 1| + |q 2 - p 2| := by
  rw [massiveGenerator_sub_eq]
  simpa [qAbs, Pi.sub_apply] using norm_kinetic4_le_qAbs (q - p)

/-- The exact massive Dirac multiplier is Lipschitz in momentum. The constant
is independent of the fixed Pluecker mass because that lower-order term
cancels from the generator difference. -/
theorem massiveEflow_momentum_lipschitz (z : Complex)
    (q p : Fin 3 -> Real) (t : Real) :
    norm (massiveEflow z q t - massiveEflow z p t) <=
      |t| * (|q 0 - p 0| + |q 1 - p 1| + |q 2 - p 2|) := by
  refine le_trans
    (by
      simpa [massiveEflow] using
        HermitianExpLipschitz.hermitian_exp_lipschitz_fin
          (massiveGenerator z q) (massiveGenerator z p)
          (massiveGenerator_isHermitian z q)
          (massiveGenerator_isHermitian z p) t)
    (mul_le_mul_of_nonneg_left
      (norm_massiveGenerator_sub_le_l1 z q p) (abs_nonneg t))

/-- Inside one physical momentum cell, the exact massive multiplier differs
from its cell-center value by at most `3 * |t| * h / 2`, uniformly in mass. -/
theorem massiveEflow_cellCenter_norm_le (z : Complex)
    {h : Real} {k : Mode3} {x : Momentum3}
    (hx : x ∈ momentumCell h k) (t : Real) :
    norm (massiveEflow z x t - massiveEflow z (cellCenter h k) t) <=
      |t| * (3 * h / 2) := by
  have h0 := mem_momentumCell_coord_error hx 0
  have h1 := mem_momentumCell_coord_error hx 1
  have h2 := mem_momentumCell_coord_error hx 2
  refine le_trans
    (massiveEflow_momentum_lipschitz z x (cellCenter h k) t) ?_
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg t)
  nlinarith

/-- At zero elapsed time the exact massive flow is the identity. -/
theorem massiveEflow_zero_time (z : Complex) (q : Fin 3 -> Real) :
    massiveEflow z q 0 = 1 := by
  simp [massiveEflow]

/-- Nondegenerate control: the live kinetic and Pluecker mass generators are
both active on the existing exact witness. -/
theorem kinetic_and_mass_control_nonzero :
    Not (kinetic4 ![1, 0, 0] = 0) /\ Not (mass4 (3 + 4 * I) = 0) :=
  massive_control_nonzero

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz.massiveEflow_momentum_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveEflow_momentum_lipschitz

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz.massiveEflow_cellCenter_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massiveEflow_cellCenter_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz.kinetic_and_mass_control_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kinetic_and_mass_control_nonzero

end PhysicsSM.Draft.NullEdge.HNUMassiveExactFlowMomentumLipschitz
