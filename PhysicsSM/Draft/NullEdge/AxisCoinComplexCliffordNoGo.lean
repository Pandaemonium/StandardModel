import PhysicsSM.Draft.NullEdge.AxisCoinPositiveCliffordNoGo

/-!
# Complex-scalar Clifford-block no-go for the simultaneous axis coin

For the explicit simultaneous six-channel coin, the kernel of `U^2-rI` has
complex dimension at most three for every `r : Complex`. Consequently no
injectively embedded invariant four-dimensional restriction can square to any
scalar.

The dimension bound is sharp: at the complex eigenvalue square
`-7/25 + 24i/25`, the kernel is nonzero. Thus the theorem is a genuine rank
obstruction, not a false assertion that `U^2-rI` is invertible for every complex
scalar. The already-landed anisotropic four-space remains the non-vacuity
control.

This is the strongest coin-specific kill for the simultaneous
`B direct-sum B direct-sum B` architecture. It does not constrain the separate
successive-axis four-component walk or arbitrary quantum-walk coins.

Provenance: proofs completed by Aristotle project
`4deb8628-88a6-44e7-80cb-25db059bfec3`; clean-room integration through the live
coin API on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.AxisCoinComplexCliffordNoGo

open PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk
open PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin
open PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector

/-- The shifted square `U^2-rI`. -/
noncomputable abbrev Msq (r : Complex) : Coin :=
  axisBlockCoin * axisBlockCoin - r • (1 : Coin)

theorem Msq_mulVec_row0 (r : Complex) (v : DirectionSpace) :
    ((Msq r).mulVec v) 0 =
      (((-7 / 25 : ℝ) : Complex) - r) * v 0 +
        (I * ((24 / 25 : ℝ) : Complex)) * v 1 := by
  simp only [Msq, Matrix.mulVec, Matrix.sub_apply, Matrix.smul_apply,
    Matrix.one_apply, axisBlockCoin, Matrix.mul_apply, dotProduct, smul_eq_mul]
  norm_num [Fin.sum_univ_six, Fin.ext_iff]
  linear_combination (16 / 25 * v 0) * Complex.I_sq

theorem Msq_mulVec_row2 (r : Complex) (v : DirectionSpace) :
    ((Msq r).mulVec v) 2 =
      (((-7 / 25 : ℝ) : Complex) - r) * v 2 +
        (I * ((24 / 25 : ℝ) : Complex)) * v 3 := by
  simp only [Msq, Matrix.mulVec, Matrix.sub_apply, Matrix.smul_apply,
    Matrix.one_apply, axisBlockCoin, Matrix.mul_apply, dotProduct, smul_eq_mul]
  norm_num [Fin.sum_univ_six, Fin.ext_iff]
  linear_combination (16 / 25 * v 2) * Complex.I_sq

theorem Msq_mulVec_row4 (r : Complex) (v : DirectionSpace) :
    ((Msq r).mulVec v) 4 =
      (((-7 / 25 : ℝ) : Complex) - r) * v 4 +
        (I * ((24 / 25 : ℝ) : Complex)) * v 5 := by
  simp only [Msq, Matrix.mulVec, Matrix.sub_apply, Matrix.smul_apply,
    Matrix.one_apply, axisBlockCoin, Matrix.mul_apply, dotProduct, smul_eq_mul]
  norm_num [Fin.sum_univ_six, Fin.ext_iff]
  linear_combination (16 / 25 * v 4) * Complex.I_sq

/-- Projection onto the even coordinates `0,2,4`. Its restriction to the
kernel is injective, yielding the dimension bound. -/
noncomputable def proj3 : DirectionSpace →ₗ[Complex] (Fin 3 → Complex) where
  toFun v := fun k => v ⟨2 * k.val, by have := k.isLt; omega⟩
  map_add' := by intro x y; rfl
  map_smul' := by intro c x; rfl

theorem axis_coin_sq_minus_complex_kernel_finrank_le_three (r : Complex) :
    Module.finrank Complex
      (LinearMap.ker
        (axisBlockCoin * axisBlockCoin - r • (1 : Coin)).mulVecLin) ≤ 3 := by
  have hc : (I * ((24 / 25 : ℝ) : Complex)) ≠ 0 := by
    simp [Complex.I_ne_zero]
  have hinj : Function.Injective
      (proj3.comp (LinearMap.ker (Msq r).mulVecLin).subtype) := by
    rw [← LinearMap.ker_eq_bot, LinearMap.ker_eq_bot']
    intro x hx
    have hk : (Msq r).mulVec x.1 = 0 := by
      have hmem := x.2
      rw [LinearMap.mem_ker, Matrix.mulVecLin_apply] at hmem
      exact hmem
    have e0 : x.1 0 = 0 := congrFun hx 0
    have e2 : x.1 2 = 0 := congrFun hx 1
    have e4 : x.1 4 = 0 := congrFun hx 2
    have r0 := Msq_mulVec_row0 r x.1
    have r2 := Msq_mulVec_row2 r x.1
    have r4 := Msq_mulVec_row4 r x.1
    rw [hk] at r0 r2 r4
    simp only [Pi.zero_apply] at r0 r2 r4
    rw [e0] at r0
    rw [e2] at r2
    rw [e4] at r4
    have e1 : x.1 1 = 0 :=
      (mul_eq_zero.1 (by
        linear_combination -r0 :
          (I * ((24 / 25 : ℝ) : Complex)) * x.1 1 = 0)).resolve_left hc
    have e3 : x.1 3 = 0 :=
      (mul_eq_zero.1 (by
        linear_combination -r2 :
          (I * ((24 / 25 : ℝ) : Complex)) * x.1 3 = 0)).resolve_left hc
    have e5 : x.1 5 = 0 :=
      (mul_eq_zero.1 (by
        linear_combination -r4 :
          (I * ((24 / 25 : ℝ) : Complex)) * x.1 5 = 0)).resolve_left hc
    apply Subtype.ext
    funext i
    fin_cases i <;> assumption
  calc
    Module.finrank Complex (LinearMap.ker (Msq r).mulVecLin) ≤
        Module.finrank Complex (Fin 3 → Complex) :=
      LinearMap.finrank_le_finrank_of_injective hinj
    _ = 3 := by simp

/-- Non-vacuity control: one complex eigenvalue square has a genuine nonzero
kernel. -/
theorem complex_square_kernel_nonzero :
    ∃ v : DirectionSpace,
      v ≠ 0 ∧
        Matrix.mulVec
          (axisBlockCoin * axisBlockCoin -
            (((-7 / 25 : ℝ) : Complex) +
              I * ((24 / 25 : ℝ) : Complex)) • (1 : Coin)) v = 0 := by
  refine ⟨fun d => if d.val < 2 then 1 else 0, ?_, ?_⟩
  · intro h
    have h0 := congrFun h 0
    simp at h0
  · funext i
    fin_cases i <;>
      simp only [Matrix.mulVec, Matrix.sub_apply, Matrix.smul_apply,
        Matrix.one_apply, axisBlockCoin, Matrix.mul_apply, dotProduct] <;>
      norm_num [Fin.sum_univ_six, Complex.ext_iff]

/-- No injectively embedded four-dimensional invariant restriction of the
simultaneous axis-block coin has a scalar square, for any complex scalar. -/
theorem axisBlockCoin_has_no_complex_clifford_block :
    ¬ ∃ (inc : FourSpace →ₗ[Complex] DirectionSpace)
        (H : FourSpace →ₗ[Complex] FourSpace) (r : Complex),
      Function.Injective inc ∧
      (∀ v, axisBlockCoin.mulVec (inc v) = inc (H v)) ∧
      (∀ v, H (H v) = r • v) := by
  rintro ⟨inc, H, r, hinj, hcoin, hHH⟩
  have hmem : ∀ v, inc v ∈ LinearMap.ker (Msq r).mulVecLin := by
    intro v
    rw [LinearMap.mem_ker, Matrix.mulVecLin_apply]
    have step :
        axisBlockCoin *ᵥ (axisBlockCoin *ᵥ inc v) = r • inc v := by
      rw [hcoin v, hcoin (H v), hHH v, map_smul]
    change (Msq r) *ᵥ inc v = 0
    rw [Msq, Matrix.sub_mulVec, ← Matrix.mulVec_mulVec, step,
      Matrix.smul_mulVec, Matrix.one_mulVec, sub_self]
  let incK : FourSpace →ₗ[Complex]
      (LinearMap.ker (Msq r).mulVecLin) :=
    LinearMap.codRestrict _ inc hmem
  have hinjK : Function.Injective incK := by
    intro a b hab
    apply hinj
    have hval := congrArg Subtype.val hab
    simpa [incK, LinearMap.codRestrict] using hval
  have h4 : Module.finrank Complex FourSpace ≤
      Module.finrank Complex (LinearMap.ker (Msq r).mulVecLin) :=
    LinearMap.finrank_le_finrank_of_injective hinjK
  have hf : Module.finrank Complex FourSpace = 4 := by
    simp
  have h3 := axis_coin_sq_minus_complex_kernel_finrank_le_three r
  rw [hf] at h4
  have : (4 : ℕ) ≤ 3 := le_trans h4 h3
  omega

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AxisCoinComplexCliffordNoGo.axisBlockCoin_has_no_complex_clifford_block' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axisBlockCoin_has_no_complex_clifford_block

/-- info: 'PhysicsSM.Draft.NullEdge.AxisCoinComplexCliffordNoGo.complex_square_kernel_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complex_square_kernel_nonzero

end PhysicsSM.Draft.NullEdge.AxisCoinComplexCliffordNoGo
