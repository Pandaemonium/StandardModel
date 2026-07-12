import Mathlib

/-!
# Reality of the zero-gap determinant under paired spectral phase

A sign-change argument for `det (U - I)` is meaningful only when that
determinant is real.  This module records the exact finite gate needed by the
reciprocal-regulator program: a unitary `4 x 4` matrix with determinant one has
real zero-gap determinant.

The even dimension is load-bearing.  For a general `n`, conjugating the
determinant introduces the parity factor `(-1)^n` when `I - U` is changed to
`U - I`.

Provenance: clean-room formalization of the determinant-reality condition
identified by Aristotle hostile audit
`f19c0fa2-f31d-476f-a2e9-eaeca1e7dad9`, July 11, 2026.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PairedDeterminantReality

open Matrix

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

lemma conjTranspose_sub_one (U : M4) :
    (U - 1)ᴴ = Uᴴ - 1 := by
  simp

/-- Unitarity rewrites the adjoint zero-gap matrix as a product. -/
lemma conjTranspose_sub_one_factor (U : M4) (hU : Uᴴ * U = 1) :
    Uᴴ - 1 = Uᴴ * (1 - U) := by
  rw [mul_sub, mul_one, hU]

/-- In four dimensions, changing `I-U` to `U-I` does not change the
determinant. -/
lemma det_one_sub_eq_det_sub_one (U : M4) :
    (1 - U).det = (U - 1).det := by
  rw [show (1 : M4) - U = -(U - 1) by abel, Matrix.det_neg]
  norm_num

/-- **Paired-determinant reality gate.**  If a four-component step is unitary
and its two spectral sectors have paired determinant, so the full determinant
is one, then its zero-quasienergy determinant is fixed by complex conjugation. -/
theorem star_det_sub_one_eq (U : M4) (hU : Uᴴ * U = 1)
    (hdet : U.det = 1) :
    star ((U - 1).det) = (U - 1).det := by
  calc
    star ((U - 1).det) = ((U - 1)ᴴ).det := by
      rw [Matrix.det_conjTranspose]
    _ = (Uᴴ - 1).det := by rw [conjTranspose_sub_one]
    _ = (Uᴴ * (1 - U)).det := by rw [conjTranspose_sub_one_factor U hU]
    _ = (Uᴴ).det * (1 - U).det := by rw [Matrix.det_mul]
    _ = star U.det * (1 - U).det := by rw [Matrix.det_conjTranspose]
    _ = (1 - U).det := by rw [hdet]; simp
    _ = (U - 1).det := det_one_sub_eq_det_sub_one U

/-- Therefore the zero-gap determinant has zero imaginary part and supports a
real intermediate-value argument. -/
theorem det_sub_one_im_eq_zero (U : M4) (hU : Uᴴ * U = 1)
    (hdet : U.det = 1) :
    ((U - 1).det).im = 0 := by
  have h := congrArg Complex.im (star_det_sub_one_eq U hU hdet)
  simp only [Complex.star_def, Complex.conj_im] at h
  linarith

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.PairedDeterminantReality.star_det_sub_one_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms star_det_sub_one_eq

/-- info: 'PhysicsSM.Draft.NullEdge.PairedDeterminantReality.det_sub_one_im_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_sub_one_im_eq_zero

end PhysicsSM.Draft.NullEdge.PairedDeterminantReality
