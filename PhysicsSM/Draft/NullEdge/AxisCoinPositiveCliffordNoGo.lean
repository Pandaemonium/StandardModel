import PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector

/-!
# Positive-real Clifford-block no-go for the simultaneous axis coin

The explicit six-channel simultaneous coin has a genuine anisotropic invariant
four-dimensional sector. Nevertheless, no injectively embedded invariant
four-dimensional restriction of this coin can square to `r I` for a positive
real scalar `r`.

The proof uses the stronger real-scalar fact that `U^2 - r I` is injective for
every real `r`; each `2x2` block has determinant
`(-7/25-r)^2 + (24/25)^2 > 0`. The companion sector witness prevents the result
from becoming a vacuous absence-of-subspaces statement.

This is a no-go for the landed simultaneous `B direct-sum B direct-sum B` coin.
It is not a no-go for all quantum-walk coins, for complex scalar squares, or for
the separate successive-axis four-component construction.

Provenance: proofs completed by Aristotle project
`1881e9fc-6204-45eb-90aa-e3115a1dadb3`; clean-room integration through the
live coin and invariant-sector APIs on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.AxisCoinPositiveCliffordNoGo

open PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk
open PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin
open PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector

/-- Positive control: the actual simultaneous coin has a genuine rank-four
anisotropic invariant sector. -/
theorem anisotropic_four_sector_witness :
    Function.Injective includeFour ∧
      ∀ v : FourSpace,
        matrixAction axisBlockCoin (includeFour v) =
          includeFour (matrixAction fourCoin v) :=
  ⟨include_four_injective, concrete_coin_intertwines_four_sector⟩

/-- For every real scalar, `U^2-rI` has trivial kernel. In particular this
holds for every positive-real Clifford square. -/
theorem axis_coin_sq_minus_real_injective (r : ℝ) :
    Function.Injective
      (matrixAction (axisBlockCoin * axisBlockCoin -
        (r : Complex) • (1 : Coin))) := by
  unfold matrixAction
  simp +decide [Fin.sum_univ_succ, Matrix.mul_apply, axisBlockCoin]
  intro v w h
  simp +decide [Fin.forall_fin_succ, funext_iff] at h ⊢
  norm_num [Complex.ext_iff] at *
  have hdet : (-(7 / 25) - r) ^ 2 + (24 / 25) ^ 2 ≠ 0 := by
    positivity
  grind

/-- The actual simultaneous axis-block coin has no injectively embedded
four-dimensional invariant restriction whose square is a positive real
scalar. -/
theorem axisBlockCoin_has_no_positive_clifford_block :
    ¬ ∃ (inc : FourSpace →ₗ[Complex] DirectionSpace)
        (H : FourSpace →ₗ[Complex] FourSpace) (r : ℝ),
      Function.Injective inc ∧
      (∀ v, matrixAction axisBlockCoin (inc v) = inc (H v)) ∧
      (∀ v, H (H v) = (r : Complex) • v) ∧
      0 < r := by
  intro h
  obtain ⟨inc, H, r, h_inj, h_eq, h_pos⟩ := h
  have h_zero : ∀ v : FourSpace, inc v = 0 := by
    intro v
    have h_eq_zero :
        matrixAction
            (axisBlockCoin * axisBlockCoin -
              (r : Complex) • (1 : Coin)) (inc v) = 0 := by
      have h_apply :
          matrixAction (axisBlockCoin * axisBlockCoin) (inc v) =
            inc (H (H v)) := by
        rw [← h_eq, ← h_eq]
        unfold matrixAction
        simp +decide [Matrix.mul_apply, Fin.sum_univ_succ]
        ext
        ring
      unfold matrixAction at *
      simp_all +decide [funext_iff]
      simp_all +decide [sub_mul, Matrix.one_apply]
      simp_all +decide [show H (H v) = r • v from by
        ext x
        exact h_pos.1 v x]
    convert axis_coin_sq_minus_real_injective r _
    convert h_eq_zero using 1
    unfold matrixAction
    norm_num
    rfl
  exact absurd (@h_inj (Pi.single 0 1) 0) (by simp +decide [h_zero])

theorem axis_block_square_control :
    (axisBlockCoin * axisBlockCoin) (0 : Direction) (0 : Direction) =
        ((-7 / 25 : ℝ) : Complex) ∧
      (axisBlockCoin * axisBlockCoin) (0 : Direction) (1 : Direction) =
        I * ((24 / 25 : ℝ) : Complex) := by
  unfold axisBlockCoin
  norm_num [Fin.sum_univ_succ, Matrix.mul_apply]
  ring_nf
  norm_num

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AxisCoinPositiveCliffordNoGo.axisBlockCoin_has_no_positive_clifford_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axisBlockCoin_has_no_positive_clifford_block

/-- info: 'PhysicsSM.Draft.NullEdge.AxisCoinPositiveCliffordNoGo.anisotropic_four_sector_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms anisotropic_four_sector_witness

end PhysicsSM.Draft.NullEdge.AxisCoinPositiveCliffordNoGo
