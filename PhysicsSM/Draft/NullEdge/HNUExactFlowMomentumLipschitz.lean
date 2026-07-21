import PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
import PhysicsSM.Draft.NullEdge.HNUManyStepContinuumLive
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling

/-!
# Momentum Lipschitz bound for the exact HNU Weyl flow

This module specializes the project's Hermitian-exponential estimate to the
two-component HNU continuum symbol. It is the exact-flow cell-variation rung
needed after the live-versus-cell-center theorem in the changing-cell HNU
continuum composition.

The result is intentionally about the exact two-component momentum multiplier.
It does not perform the cellwise integral, inverse Fourier transform, or
position-space Weyl-generator identification.

Provenance: clean-room composition of `HermitianExpLipschitz`,
`HNUManyStepContinuumLive`, and `ChangingMomentumCellSampling`, July 20, 2026.
Claim grade `M`, `[comp]`.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.HNUExactFlowMomentumLipschitz

open HNUManyStepContinuum
open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling

/-- The difference of two Weyl symbols is the Weyl symbol of the momentum
difference. -/
theorem Hw_sub_Hw_eq (q p : Fin 3 -> Real) :
    Hw q - Hw p = Hw (q - p) := by
  unfold Hw
  ext i j
  simp [Pi.sub_apply]
  ring

/-- The Weyl symbol is Lipschitz in coordinate `L1` momentum distance. -/
theorem norm_Hw_sub_Hw_le_l1 (q p : Fin 3 -> Real) :
    ‖Hw q - Hw p‖ <=
      |q 0 - p 0| + |q 1 - p 1| + |q 2 - p 2| := by
  rw [Hw_sub_Hw_eq]
  simpa [qAbs, Pi.sub_apply] using norm_Hw_le (q - p)

/-- The exact two-component Weyl multiplier is Lipschitz in momentum. The
constant has no dependence on the absolute momentum window. -/
theorem Eflow_momentum_lipschitz (q p : Fin 3 -> Real) (t : Real) :
    ‖Eflow q t - Eflow p t‖ <=
      |t| * (|q 0 - p 0| + |q 1 - p 1| + |q 2 - p 2|) := by
  refine le_trans
    (by
      simpa [Eflow] using
        HermitianExpLipschitz.hermitian_exp_lipschitz_fin
          (Hw q) (Hw p) (Hw_isHermitian q) (Hw_isHermitian p) t)
    (mul_le_mul_of_nonneg_left (norm_Hw_sub_Hw_le_l1 q p) (abs_nonneg t))

/-- Inside one physical momentum cell, the exact HNU Weyl multiplier differs
from its cell-center value by at most `3 * |t| * h / 2`. -/
theorem Eflow_cellCenter_norm_le {h : Real} {k : Mode3} {x : Momentum3}
    (hx : x ∈ momentumCell h k) (t : Real) :
    ‖Eflow x t - Eflow (cellCenter h k) t‖ <= |t| * (3 * h / 2) := by
  have h0 := mem_momentumCell_coord_error hx 0
  have h1 := mem_momentumCell_coord_error hx 1
  have h2 := mem_momentumCell_coord_error hx 2
  refine le_trans (Eflow_momentum_lipschitz x (cellCenter h k) t) ?_
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg t)
  nlinarith

/-- Boundary control: at zero elapsed time the exact HNU flow is the identity
for every momentum. -/
theorem Eflow_zero_time (q : Fin 3 -> Real) : Eflow q 0 = 1 := by
  simp [Eflow]

/-- Nondegeneracy control: the live Weyl generator changes with momentum. -/
theorem Hw_axis_ne_zero : Hw ![1, 0, 0] ≠ 0 :=
  Hw_axis_witness_ne_zero

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactFlowMomentumLipschitz.Eflow_momentum_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Eflow_momentum_lipschitz

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactFlowMomentumLipschitz.Eflow_cellCenter_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Eflow_cellCenter_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.HNUExactFlowMomentumLipschitz.Hw_axis_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms Hw_axis_ne_zero

end PhysicsSM.Draft.NullEdge.HNUExactFlowMomentumLipschitz
