import Mathlib
import PhysicsSM.Algebra.Octonion.G2ComplexLine
import PhysicsSM.Algebra.Octonion.ComplexTripleModule

/-!
# Algebra.Octonion.G2ComplexTripleAction

Induced action of a multiplication-preserving real-linear map fixing `e111`
on the complement coordinates `ℂ³`, and proof that this action is
complex-linear.

## Mathematical context

In Baez's 2021 talk "Can We Understand the Standard Model Using Octonions?",
maps fixing the chosen imaginary unit `e111` (among multiplicative linear maps)
act complex-linearly on the complement `ℂ³` in the splitting `𝕆 = ℂ ⊕ ℂ³`.

This file defines the induced action of a `FixingE111MulLinear` map on
`ComplexTriple` and proves:
- The action reconstructs correctly at the octonion level.
- The action is real-linear (additive and ℝ-homogeneous).
- The action is complex-linear (commutes with `ComplexTriple.complexSmul`).

## Claim boundary

This file does **not** claim `Stab_{G₂}(e111) ≅ SU(3)`. It only proves the
coordinate and linearity theorems about the induced action on `ComplexTriple`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Complement projection helper -/

/-
If an octonion is in the chosen complex complement (`c0 = 0`, `c7 = 0`),
    then projecting to `ComplexTriple` and embedding back recovers the
    original octonion.
-/
theorem toComplexTriple_toOctonion_of_inComplement
    {x : Octonion} (hx : InChosenComplexComplement x) :
    x.toComplexTriple.toOctonion = x := by
  cases hx ; aesop

/-! ## Induced complement action -/

/-- The induced action of a `FixingE111MulLinear` map on `ComplexTriple`.
    Apply `g` to the octonion embedding, then project back to `ComplexTriple`.

    This is well-defined because `g` preserves the complement
    (`preserves_chosen_complex_complement`). -/
noncomputable def FixingE111MulLinear.onComplexTriple
    (g : FixingE111MulLinear) (w : ComplexTriple) : ComplexTriple :=
  (g.toFun w.toOctonion).toComplexTriple

/-
The induced action on `ComplexTriple` reconstructs the action on the
    octonion complement: embedding the result gives `g(w.toOctonion)`.
-/
theorem FixingE111MulLinear.onComplexTriple_toOctonion
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    (g.onComplexTriple w).toOctonion = g.toFun w.toOctonion := by
  apply toComplexTriple_toOctonion_of_inComplement;
  exact preserves_chosen_complex_complement g ( ComplexTriple.toOctonion_complement w )

/-! ## Real-linearity of the induced action -/

/-
Helper: `ComplexTriple.toOctonion` is additive.
-/
theorem ComplexTriple.toOctonion_add (u v : ComplexTriple) :
    (u + v).toOctonion = u.toOctonion + v.toOctonion := by
  cases u ; cases v ; aesop

/-
Helper: `ComplexTriple.toOctonion` respects real scalar multiplication.
-/
theorem ComplexTriple.toOctonion_smul (r : ℝ) (w : ComplexTriple) :
    (r • w).toOctonion = r • w.toOctonion := by
  ext <;> simp +decide;
  all_goals rfl;

/-
Helper: `Octonion.toComplexTriple` is additive.
-/
theorem Octonion.toComplexTriple_add (a b : Octonion) :
    (a + b).toComplexTriple = a.toComplexTriple + b.toComplexTriple := by
  exact ComplexTriple.ext rfl rfl rfl rfl rfl rfl

/-
Helper: `Octonion.toComplexTriple` respects real scalar multiplication.
-/
theorem Octonion.toComplexTriple_smul (r : ℝ) (a : Octonion) :
    (r • a).toComplexTriple = r • a.toComplexTriple := by
  exact ComplexTriple.ext rfl rfl rfl rfl rfl rfl

/-
The induced action is additive:
    `g.onComplexTriple (u + v) = g.onComplexTriple u + g.onComplexTriple v`.
-/
theorem FixingE111MulLinear.onComplexTriple_add
    (g : FixingE111MulLinear) (u v : ComplexTriple) :
    g.onComplexTriple (u + v) =
      g.onComplexTriple u + g.onComplexTriple v := by
  convert Octonion.toComplexTriple_add ( g.toFun u.toOctonion ) ( g.toFun v.toOctonion ) using 1;
  rw [ ← g.map_add, ← ComplexTriple.toOctonion_add ];
  rfl

/-
The induced action is ℝ-homogeneous:
    `g.onComplexTriple (r • w) = r • g.onComplexTriple w`.
-/
theorem FixingE111MulLinear.onComplexTriple_real_smul
    (g : FixingE111MulLinear) (r : ℝ) (w : ComplexTriple) :
    g.onComplexTriple (r • w) =
      r • g.onComplexTriple w := by
  simp +decide [FixingE111MulLinear.onComplexTriple, ComplexTriple.toOctonion_smul]
  rw [ g.map_smul, Octonion.toComplexTriple_smul ]

/-! ## Complex-linearity of the induced action -/

/-
Decomposition of complex scalar multiplication into real and imaginary
    parts: `z • w = z.re • w + z.im • (I • w)`.
-/
theorem ComplexTriple.complexSmul_eq_real_add_I
    (z : ℂ) (w : ComplexTriple) :
    ComplexTriple.complexSmul z w =
      z.re • w + z.im • ComplexTriple.complexSmul Complex.I w := by
  -- By definition of ComplexTriple.complexSmul, we can expand both sides.
  obtain ⟨w1_re, w1_im, w2_re, w2_im, w3_re, w3_im⟩ := w;
  unfold ComplexTriple.complexSmul;
  congr <;> norm_num <;> ring_nf;
  · exact show z.re * w1_re - z.im * w1_im = z.re * w1_re + z.im * -w1_im by ring_nf;
  · exact show z.re * w2_re - z.im * w2_im = z.re * w2_re + z.im * (-w2_im) by ring_nf;
  · exact show z.re * w3_re - z.im * w3_im = z.re * w3_re + z.im * (-w3_im) by ring_nf;

/-
The induced action commutes with multiplication by `Complex.I`:
    `g.onComplexTriple (I • w) = I • g.onComplexTriple w`.

    This is the key step for complex-linearity. It uses:
    - `complexSmul_I_eq_J`: `(I • w).toOctonion = e111 * w.toOctonion`
    - `commutes_with_left_e111`: `g(e111 * x) = e111 * g(x)`
    - `onComplexTriple_toOctonion`: reconstruction lemma
-/
theorem FixingE111MulLinear.onComplexTriple_I_smul
    (g : FixingE111MulLinear) (w : ComplexTriple) :
    g.onComplexTriple (ComplexTriple.complexSmul Complex.I w) =
      ComplexTriple.complexSmul Complex.I (g.onComplexTriple w) := by
  unfold FixingE111MulLinear.onComplexTriple;
  rw [ ComplexTriple.complexSmul_I_eq_J, commutes_with_left_e111 ];
  convert ComplexTriple.toComplexVec_J ( g.onComplexTriple w ) |> Eq.symm using 1;
  constructor <;> intro h <;> simp_all +decide [ funext_iff, Complex.ext_iff ];
  · simp +decide [ Fin.forall_fin_succ, ComplexTriple.toComplexVec ];
  · ext <;> simp +decide [ ComplexTriple.complexSmul ]

/-
The induced action is complex-linear: it commutes with
    `ComplexTriple.complexSmul` for all `z : ℂ`.

    **Proof.** Decompose `z = z.re + z.im · I` via `complexSmul_eq_real_add_I`,
    then use `onComplexTriple_add`, `onComplexTriple_real_smul`, and
    `onComplexTriple_I_smul`.
-/
theorem FixingE111MulLinear.onComplexTriple_complex_smul
    (g : FixingE111MulLinear) (z : ℂ) (w : ComplexTriple) :
    g.onComplexTriple (ComplexTriple.complexSmul z w) =
      ComplexTriple.complexSmul z (g.onComplexTriple w) := by
  rw [ComplexTriple.complexSmul_eq_real_add_I z w,
      ComplexTriple.complexSmul_eq_real_add_I z (g.onComplexTriple w),
      g.onComplexTriple_add, g.onComplexTriple_real_smul,
      g.onComplexTriple_real_smul, g.onComplexTriple_I_smul]

end PhysicsSM.Algebra.Octonion.G2ComplexLine
