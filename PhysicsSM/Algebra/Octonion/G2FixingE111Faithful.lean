import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111MonoidHom
import PhysicsSM.Algebra.Octonion.ComplexSplitting

/-!
# Algebra.Octonion.G2FixingE111Faithful

Faithfulness of the matrix representation of `FixingE111MulLinear` maps.

## Mathematical context

The file `G2FixingE111MonoidHom` packages the assignment
`g ↦ g.onComplexVecMatrix` as a monoid homomorphism from
`FixingE111MulLinear` to 3×3 complex matrices. This file proves that the
homomorphism is injective: the matrix on the `ℂ³` complement determines
the whole map.

The proof strategy is:
1. Every octonion decomposes as `x = x.toChosenComplex.toOctonion +
   x.toComplexTriple.toOctonion` (the splitting `𝕆 = ℂ ⊕ ℂ³`).
2. On the chosen complex line `ℂ = span_ℝ {1, e111}`, every
   `FixingE111MulLinear` acts as the identity (since it fixes both `1`
   and `e111`, and is real-linear).
3. On the complement `ℂ³`, the action is determined by `onComplexVecMatrix`.
4. Therefore, if two maps agree on their matrices, they agree everywhere.

## Claim boundary

This proves faithfulness of the current matrix representation of
`FixingE111MulLinear`. It does not prove surjectivity onto all of `SU(3)`,
connectedness of `G₂`, or the full isomorphism `Stab_G₂(e111) ≅ SU(3)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Action on the chosen complex line -/

/-- A `FixingE111MulLinear` map acts as the identity on the chosen complex
    line: for any `z : ChosenComplex`, `g(z.toOctonion) = z.toOctonion`.

    **Proof.** `z.toOctonion = z.re • 1 + z.im • e111`, and `g` is
    real-linear with `g(1) = 1` and `g(e111) = e111`. -/
theorem FixingE111MulLinear.map_chosenComplex_eq
    (g : FixingE111MulLinear) (z : ChosenComplex) :
    g.toFun z.toOctonion = z.toOctonion := by
  have h_decomp : z.toOctonion =
      z.re • (1 : Octonion) + z.im • e111 := by
    exact Eq.symm (by ext <;> simp +decide [ChosenComplex.toOctonion])
  rw [h_decomp, g.map_add, g.map_smul, g.map_smul,
      g.map_one, g.fixes_e111]

/-! ## Matrix equality implies action equality on ComplexTriple -/

/-- If two `FixingE111MulLinear` maps have the same `onComplexVecMatrix`,
    then they agree on all `ComplexTriple` elements.

    **Proof.** The matrix determines `onComplexVecLinear` (via `mulVec`),
    which determines `onComplexTriple` (via the coordinate equivalence). -/
theorem FixingE111MulLinear.eq_onComplexTriple_of_matrix_eq
    {g h : FixingE111MulLinear}
    (hm : g.onComplexVecMatrix = h.onComplexVecMatrix)
    (w : ComplexTriple) :
    g.onComplexTriple w = h.onComplexTriple w := by
  have h1 : g.onComplexVecLinear w.toComplexVec =
      h.onComplexVecLinear w.toComplexVec := by
    rw [← FixingE111MulLinear.onComplexVecMatrix_mulVec g,
        ← FixingE111MulLinear.onComplexVecMatrix_mulVec h, hm]
  exact ComplexTriple.linearEquivComplexVec.injective (by aesop)

/-! ## Main extensionality theorem -/

/-- If two `FixingE111MulLinear` maps have the same `onComplexVecMatrix`,
    then they are equal.

    **Proof.** Use `FixingE111MulLinear.ext`. For any octonion `x`,
    decompose as line part + complement part. The line parts agree by
    `map_chosenComplex_eq`; the complement parts agree by
    `eq_onComplexTriple_of_matrix_eq` via `onComplexTriple_toOctonion`. -/
theorem FixingE111MulLinear.ext_of_onComplexVecMatrix_eq
    {g h : FixingE111MulLinear}
    (hm : g.onComplexVecMatrix = h.onComplexVecMatrix) :
    g = h := by
  apply FixingE111MulLinear.ext
  intro x
  have h_decomp : x = x.toChosenComplex.toOctonion +
      x.toComplexTriple.toOctonion := by
    exact octonion_decomp x
  conv_lhs =>
    rw [h_decomp, g.map_add,
        FixingE111MulLinear.map_chosenComplex_eq,
        ← FixingE111MulLinear.onComplexTriple_toOctonion g]
  conv_rhs =>
    rw [h_decomp, h.map_add,
        FixingE111MulLinear.map_chosenComplex_eq,
        ← FixingE111MulLinear.onComplexTriple_toOctonion h]
  rw [FixingE111MulLinear.eq_onComplexTriple_of_matrix_eq hm]

/-! ## Injectivity of the monoid homomorphisms -/

/-- The monoid homomorphism `fixingE111MulLinearToMatrixHom` is
    injective. -/
theorem fixingE111MulLinearToMatrixHom_injective :
    Function.Injective fixingE111MulLinearToMatrixHom :=
  fun _ _ hgh => FixingE111MulLinear.ext_of_onComplexVecMatrix_eq hgh

/-- The monoid homomorphism `fixingE111MulLinearToSU3Hom` is injective. -/
theorem fixingE111MulLinearToSU3Hom_injective :
    Function.Injective fixingE111MulLinearToSU3Hom := by
  intro g h hgh
  exact FixingE111MulLinear.ext_of_onComplexVecMatrix_eq
    (by injection hgh)

/-! ## Bundled package -/

/-- Bundled record collecting the faithfulness results. -/
structure G2FixingE111FaithfulPackage where
  /-- Matrix equality implies map equality. -/
  matrix_ext :
    ∀ g h : FixingE111MulLinear,
      g.onComplexVecMatrix = h.onComplexVecMatrix → g = h
  /-- The matrix homomorphism is injective. -/
  matrix_hom_injective :
    Function.Injective fixingE111MulLinearToMatrixHom

/-- The canonical faithfulness package. -/
noncomputable def g2FixingE111FaithfulPackage :
    G2FixingE111FaithfulPackage where
  matrix_ext _ _ hm :=
    FixingE111MulLinear.ext_of_onComplexVecMatrix_eq hm
  matrix_hom_injective := fixingE111MulLinearToMatrixHom_injective

end PhysicsSM.Algebra.Octonion.G2ComplexLine
