import PhysicsSM.Draft.NullEdge.HermitianExpLipschitz
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling

/-!
# Momentum Lipschitz bound for the exact 3+1 Dirac flow

This module specializes the sharp Hermitian exponential estimate to the live
four-by-four Dirac symbol. The exact multiplier changes across one physical
momentum cell by at most `3 * |t| * h / 2` in L2 operator norm.

This is the local analytic rung needed by `CONT-MULT-001`. It does not yet sum
the cellwise estimate against an arbitrary L2 field, apply inverse Fourier
transform, or identify a position-space PDE solution.

Provenance: in-project composition of `HermitianExpLipschitz`,
`Compact3Plus1DiracRate`, and `ChangingMomentumCellSampling`, July 12, 2026.
-/

noncomputable section

open Matrix Complex Real
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz

open Compact3Plus1DiracRate
open ChangingMomentumCellIsometry
open ChangingMomentumCellSampling

/-- The difference of two equal-mass Dirac symbols is the symbol of the
momentum difference with zero mass. -/
theorem H_sub_H_eq (kx ky kz qx qy qz m : Real) :
    H kx ky kz m - H qx qy qz m =
      H (kx - qx) (ky - qy) (kz - qz) 0 := by
  unfold H
  push_cast
  module

/-- The Dirac symbol is Lipschitz in the coordinate L1 momentum distance. -/
theorem norm_H_sub_H_le_l1 (kx ky kz qx qy qz m : Real) :
    ‖H kx ky kz m - H qx qy qz m‖ <=
      |kx - qx| + |ky - qy| + |kz - qz| := by
  rw [H_sub_H_eq]
  exact le_trans (norm_H_le_B4 _ _ _ _) (by simp [B4])

/-- The exact Dirac multiplier is sharply Lipschitz in momentum, with no
growth in the absolute momentum window. -/
theorem exactFlow_momentum_lipschitz
    (kx ky kz qx qy qz m t : Real) :
    ‖exactFlow kx ky kz m t - exactFlow qx qy qz m t‖ <=
      |t| * (|kx - qx| + |ky - qy| + |kz - qz|) := by
  refine le_trans
    (by
      simpa [exactFlow] using
        HermitianExpLipschitz.hermitian_exp_lipschitz
          (H kx ky kz m) (H qx qy qz m)
          (H_isHermitian _ _ _ _) (H_isHermitian _ _ _ _) t)
    (mul_le_mul_of_nonneg_left
      (norm_H_sub_H_le_l1 kx ky kz qx qy qz m) (abs_nonneg t))

/-- Inside one physical momentum cell, the exact multiplier differs from its
cell-center value by at most `3 |t| h / 2`. -/
theorem exactFlow_cellCenter_norm_le {h : Real}
    {k : Mode3} {x : Momentum3} (hx : x ∈ momentumCell h k)
    (m t : Real) :
    ‖exactFlow (x 0) (x 1) (x 2) m t -
        exactFlow (cellCenter h k 0) (cellCenter h k 1)
          (cellCenter h k 2) m t‖ <=
      |t| * (3 * h / 2) := by
  have h0 := mem_momentumCell_coord_error hx 0
  have h1 := mem_momentumCell_coord_error hx 1
  have h2 := mem_momentumCell_coord_error hx 2
  refine le_trans
    (exactFlow_momentum_lipschitz
      (x 0) (x 1) (x 2)
      (cellCenter h k 0) (cellCenter h k 1) (cellCenter h k 2) m t) ?_
  apply mul_le_mul_of_nonneg_left _ (abs_nonneg t)
  nlinarith

/-- Boundary control: at zero elapsed time, the exact multiplier is the
identity for every momentum. -/
theorem exactFlow_zero_time (kx ky kz m : Real) :
    exactFlow kx ky kz m 0 = 1 := by
  simp [exactFlow]

/-- Nonconstant control: changing the x momentum changes the live Hermitian
generator. -/
theorem H_x_witness_ne : H 1 0 0 0 ≠ H 0 0 0 0 := by
  intro h
  have h03 := congrFun (congrFun h 0) 3
  norm_num [H, alpha1, alpha2, alpha3, beta] at h03
  simp at h03

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.exactFlow_momentum_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_momentum_lipschitz

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.exactFlow_cellCenter_norm_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exactFlow_cellCenter_norm_le

/-- info: 'PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz.H_x_witness_ne' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H_x_witness_ne

end PhysicsSM.Draft.NullEdge.ExactFlowMomentumLipschitz
