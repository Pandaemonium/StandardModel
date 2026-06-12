import Mathlib
import PhysicsSM.Algebra.Octonion.G2SU3Bridge
import PhysicsSM.Algebra.Octonion.G2ComplexLine

/-!
# Algebra.Octonion.G2HermitianPreservation

Proof that any `FixingE111MulLinear` map preserves the Hermitian inner product
on `ComplexTriple`, hence acts as an element of U(3) on ℂ³.

## Mathematical context

The key steps are:
1. The octonion norm restricted to complement elements equals the
   `ComplexTriple.normSq` (sum of squared complex moduli).
2. Since `FixingE111MulLinear` preserves `Octonion.normSq` (via `map_conj`),
   it preserves `ComplexTriple.normSq`.
3. By polarization, it preserves the real part of the Hermitian form.
4. By complex-linearity (`onComplexTriple_I_smul`), it preserves the
   imaginary part of the Hermitian form.
5. Combining, it preserves the full Hermitian form.

## Claim boundary

This file proves that any `FixingE111MulLinear` map preserves the Hermitian
inner product on `ComplexTriple`. It does **not** prove determinant = 1 or
the full isomorphism `Stab_{G₂}(e111) ≅ SU(3)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Step 1: Octonion norm = ComplexTriple norm on complement -/

/-
The octonion squared norm of a complement element equals the
    `ComplexTriple` squared norm.
-/
theorem octonion_normSq_eq_complexTriple_normSq (w : ComplexTriple) :
    Octonion.normSq w.toOctonion = ComplexTriple.normSq w := by
  unfold Octonion.normSq
  simp [ComplexTriple.toOctonion, ComplexTriple.normSq];
  unfold ComplexTriple.toComplexVec; simp +decide [ Complex.normSq, Fin.sum_univ_three ] ; ring;

/-! ## Step 2: g preserves ComplexTriple.normSq -/

/-
A `FixingE111MulLinear` map preserves `ComplexTriple.normSq`.
-/
theorem FixingE111MulLinear.preserves_complexTriple_normSq
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    ComplexTriple.normSq (g.onComplexTriple w) = ComplexTriple.normSq w := by
  have := g.normSq_preserved w.toOctonion;
  rw [ ← octonion_normSq_eq_complexTriple_normSq, ← octonion_normSq_eq_complexTriple_normSq, ← this, ← FixingE111MulLinear.onComplexTriple_toOctonion ]

/-! ## Step 3: g preserves the real bilinear form (polarization of normSq) -/

/-- The real bilinear form obtained by polarizing `ComplexTriple.normSq`:
    `realInner u v = ∑ₖ (uₖ_re * vₖ_re + uₖ_im * vₖ_im)`.
    This equals `Re(hermitian u v)`. -/
noncomputable def ComplexTriple.realInner (u v : ComplexTriple) : ℝ :=
  u.w1_re * v.w1_re + u.w1_im * v.w1_im +
  u.w2_re * v.w2_re + u.w2_im * v.w2_im +
  u.w3_re * v.w3_re + u.w3_im * v.w3_im

/-
`realInner u v` equals the real part of the Hermitian form.
-/
theorem ComplexTriple.realInner_eq_hermitian_re (u v : ComplexTriple) :
    ComplexTriple.realInner u v = (ComplexTriple.hermitian u v).re := by
  -- By definition of `hermitian`, we have:
  simp [ComplexTriple.realInner, ComplexTriple.hermitian];
  rw [ Fin.sum_univ_three ] ; ring!;

/-
Polarization identity: `realInner u v = (normSq(u+v) - normSq u - normSq v) / 2`.
-/
theorem ComplexTriple.realInner_polarization (u v : ComplexTriple) :
    ComplexTriple.realInner u v =
      (ComplexTriple.normSq (u + v) - ComplexTriple.normSq u - ComplexTriple.normSq v) / 2 := by
  unfold realInner; unfold ComplexTriple.normSq; ring;
  unfold ComplexTriple.toComplexVec; norm_num [ Fin.sum_univ_three ] ; ring;

/-
A `FixingE111MulLinear` map preserves the real bilinear form.
-/
theorem FixingE111MulLinear.preserves_realInner
    (g : FixingE111MulLinear) (u v : ComplexTriple) :
    ComplexTriple.realInner (g.onComplexTriple u) (g.onComplexTriple v) =
      ComplexTriple.realInner u v := by
  convert ComplexTriple.realInner_polarization _ _ using 1;
  rw [ ← FixingE111MulLinear.onComplexTriple_add ];
  rw [ FixingE111MulLinear.preserves_complexTriple_normSq, FixingE111MulLinear.preserves_complexTriple_normSq, FixingE111MulLinear.preserves_complexTriple_normSq, ComplexTriple.realInner_polarization ]

/-! ## Step 4: The imaginary symplectic form -/

/-- The imaginary part of the Hermitian form:
    `sympForm u v = ∑ₖ (uₖ_re * vₖ_im - uₖ_im * vₖ_re)`.
    This equals `Im(hermitian u v)`. -/
noncomputable def ComplexTriple.sympForm (u v : ComplexTriple) : ℝ :=
  u.w1_re * v.w1_im - u.w1_im * v.w1_re +
  u.w2_re * v.w2_im - u.w2_im * v.w2_re +
  u.w3_re * v.w3_im - u.w3_im * v.w3_re

/-
`sympForm u v` equals the imaginary part of the Hermitian form.
-/
theorem ComplexTriple.sympForm_eq_hermitian_im (u v : ComplexTriple) :
    ComplexTriple.sympForm u v = (ComplexTriple.hermitian u v).im := by
  unfold ComplexTriple.sympForm ComplexTriple.hermitian; norm_num [ Fin.sum_univ_three ] ; ring;
  rfl

/-
Key identity: `sympForm u v = -realInner u (complexSmul I v)`.
-/
theorem ComplexTriple.sympForm_eq_neg_realInner_I (u v : ComplexTriple) :
    ComplexTriple.sympForm u v =
      -ComplexTriple.realInner u (ComplexTriple.complexSmul Complex.I v) := by
  unfold sympForm realInner ComplexTriple.complexSmul;
  norm_num ; ring

/-
A `FixingE111MulLinear` map preserves the symplectic form,
    using complex-linearity and real-inner-product preservation.
-/
theorem FixingE111MulLinear.preserves_sympForm
    (g : FixingE111MulLinear) (u v : ComplexTriple) :
    ComplexTriple.sympForm (g.onComplexTriple u) (g.onComplexTriple v) =
      ComplexTriple.sympForm u v := by
  have h_symm :
      ComplexTriple.sympForm (g.onComplexTriple u) (g.onComplexTriple v) =
        -ComplexTriple.realInner (g.onComplexTriple u)
          (ComplexTriple.complexSmul Complex.I (g.onComplexTriple v)) := by
    exact ComplexTriple.sympForm_eq_neg_realInner_I
      (g.onComplexTriple u) (g.onComplexTriple v)
  rw [ h_symm, ← FixingE111MulLinear.onComplexTriple_I_smul ];
  rw [show ComplexTriple.sympForm u v = -ComplexTriple.realInner u (ComplexTriple.complexSmul Complex.I v) from ComplexTriple.sympForm_eq_neg_realInner_I u v];
  exact congr_arg Neg.neg ( FixingE111MulLinear.preserves_realInner g u ( ComplexTriple.complexSmul Complex.I v ) )

/-! ## Step 5: Full Hermitian preservation -/

/-
The Hermitian form decomposes as `hermitian u v = realInner u v + I * sympForm u v`.
-/
theorem ComplexTriple.hermitian_eq_realInner_add_I_sympForm (u v : ComplexTriple) :
    ComplexTriple.hermitian u v =
      ↑(ComplexTriple.realInner u v) + Complex.I * ↑(ComplexTriple.sympForm u v) := by
  unfold ComplexTriple.hermitian ComplexTriple.realInner ComplexTriple.sympForm; norm_num [ Complex.ext_iff ] ; ring;
  simp +decide [ ComplexTriple.toComplexVec, Fin.sum_univ_three ] ; ring ; aesop

/-
A `FixingE111MulLinear` map preserves the Hermitian inner product on
    `ComplexTriple`, hence acts as an element of U(3) on ℂ³.
-/
theorem fixingE111MulLinear_preservesHermitian
    (g : FixingE111MulLinear) :
    PreservesComplexTripleHermitian g := by
  intro u v;
  rw [ ComplexTriple.hermitian_eq_realInner_add_I_sympForm, ComplexTriple.hermitian_eq_realInner_add_I_sympForm ];
  rw [ FixingE111MulLinear.preserves_realInner g u v, FixingE111MulLinear.preserves_sympForm g u v ]

/-- Any `FixingE111MulLinear` acts as an element of U(3) on ℂ³. -/
theorem fixingE111MulLinear_actsAsSU3
    (g : FixingE111MulLinear) :
    ActsAsSU3OnC3 g :=
  ⟨fixingE111MulLinear_preservesHermitian g⟩

end PhysicsSM.Algebra.Octonion.G2ComplexLine
