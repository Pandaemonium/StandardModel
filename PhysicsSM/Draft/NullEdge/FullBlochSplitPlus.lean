import PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants

namespace PhysicsSM.Draft.NullEdge.FullBlochSplitPlus

open Matrix Complex
open FullBlochSplitDeterminants

/-! Focused `+1` Floquet determinant target using the harvested expansion. -/

set_option maxHeartbeats 20000000
set_option maxRecDepth 10000

/-- Exact all-momentum determinant formula at eigenvalue `+1`. -/
theorem det_splitStep_sub_one (qx qy qz theta : Real) :
    Matrix.det (splitStep qx qy qz theta - (1 : Mat4)) =
      (4 * zeroModePolynomial qx qy qz theta : Real) := by
  -- Expand the `4 × 4` determinant and substitute the closed forms of every entry.
  have hI3 : (I : ℂ) ^ 3 = -I := by rw [pow_succ, Complex.I_sq]; ring
  rw [det_fin_four]
  simp only [Matrix.sub_apply, splitStep_eq, Matrix.one_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val,
    Matrix.of_apply, Fin.reduceEq, if_true, if_false, Complex.I_sq, hI3]
  -- Reduce the complex identity to its real and imaginary parts.
  rw [Complex.ext_iff]
  constructor <;>
    simp only [Complex.add_re, Complex.add_im, Complex.sub_re, Complex.sub_im, Complex.mul_re,
      Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im, Complex.I_re, Complex.I_im,
      Complex.one_re, Complex.one_im, Complex.neg_re, Complex.neg_im,
      mul_zero, zero_mul, one_mul, sub_zero, zero_sub, add_zero, zero_add, neg_zero]
  · -- Real part: a trigonometric polynomial identity closed via `sin² + cos² = 1`.
    rw [zeroModePolynomial, spectralBase]
    ring_nf
    have h2 : ∀ x : ℝ, Real.sin x ^ 2 = 1 - Real.cos x ^ 2 := fun x => by
      linarith [Real.sin_sq_add_cos_sq x]
    have h4 : ∀ x : ℝ, Real.sin x ^ 4 = (1 - Real.cos x ^ 2) ^ 2 := fun x => by
      rw [show (4 : ℕ) = 2 * 2 from rfl, pow_mul, h2]
    simp only [h2, h4]
    ring
  · -- Imaginary part: vanishes identically.
    ring

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochSplitPlus.det_splitStep_sub_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_splitStep_sub_one

end PhysicsSM.Draft.NullEdge.FullBlochSplitPlus
