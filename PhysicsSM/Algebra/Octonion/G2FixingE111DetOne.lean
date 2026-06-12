import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111Determinant

/-!
# Algebra.Octonion.G2FixingE111DetOne

Proof that any `FixingE111MulLinear` map has determinant exactly 1 on the
complement `ℂ³`, strengthening the determinant-norm result `|det|² = 1`
to `det = 1`.

## Mathematical context

The key ingredient is the octonion multiplication relation on complement
basis elements. In the XOR basis:

  `e001 * e010 = e011`

Since a `FixingE111MulLinear` map `g` preserves multiplication, applying `g`
to both sides gives a cross-product relation among the columns of the action
matrix `g.onComplexVecMatrix`. Combined with the unitarity
`M.conjTranspose * M = 1`, this forces `det(M) = 1`.

## Proof outline

1. **Multiplication identity**: `e001 * e010 = e011` (coordinate computation).
2. **Cross-product relation**: Apply `g.map_mul` to get an equation relating
   the images of the basis vectors under g.
3. **Coordinate extraction**: Extract specific polynomial identities among
   the matrix entries from the cross-product relation.
4. **Determinant conclusion**: The extracted identities, combined with the
   unitarity `M^H * M = 1`, algebraically force `det(M) = 1`.

## Claim boundary

This proves `det = 1` for the local record `FixingE111MulLinear`. It does
**not** prove `Stab_{G₂}(e111) ≅ SU(3)`, connectedness, or Lie group structure.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Basis multiplication identity -/

/-- The complement basis element `e001` as a `ComplexTriple`. -/
noncomputable def basisTriple1 : ComplexTriple := ⟨1, 0, 0, 0, 0, 0⟩

/-- The complement basis element `e010` as a `ComplexTriple`. -/
noncomputable def basisTriple2 : ComplexTriple := ⟨0, 0, 1, 0, 0, 0⟩

/-- The complement basis element `e100` as a `ComplexTriple`. -/
noncomputable def basisTriple3 : ComplexTriple := ⟨0, 0, 0, 0, 1, 0⟩

@[simp] theorem basisTriple1_toOctonion :
    basisTriple1.toOctonion = ⟨0, 1, 0, 0, 0, 0, 0, 0⟩ := rfl

@[simp] theorem basisTriple2_toOctonion :
    basisTriple2.toOctonion = ⟨0, 0, 1, 0, 0, 0, 0, 0⟩ := rfl

@[simp] theorem basisTriple3_toOctonion :
    basisTriple3.toOctonion = ⟨0, 0, 0, 0, 1, 0, 0, 0⟩ := rfl

/-- The octonion product `e001 * e010 = e011`. -/
theorem e001_mul_e010 :
    basisTriple1.toOctonion * basisTriple2.toOctonion =
    (⟨0, 0, 0, 1, 0, 0, 0, 0⟩ : Octonion) := by
  apply Eq.symm; exact (by congr; all_goals norm_num)

theorem e011_eq_I_smul_basisTriple3 :
    (⟨0, 0, 0, 1, 0, 0, 0, 0⟩ : Octonion) =
    (ComplexTriple.complexSmul Complex.I basisTriple3).toOctonion := by
  convert rfl
  all_goals norm_num [ComplexTriple.complexSmul, ComplexTriple.toOctonion]
  all_goals rfl

/-! ## Key relation from multiplication preservation -/

/-- For any `FixingE111MulLinear` map, the product of the images of the first
    two basis vectors equals `i` times the image of the third. -/
theorem onComplexTriple_cross_product_relation
    (g : FixingE111MulLinear) :
    (g.onComplexTriple basisTriple1).toOctonion *
    (g.onComplexTriple basisTriple2).toOctonion =
    (ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion := by
  have h1 : basisTriple1.toOctonion * basisTriple2.toOctonion =
    (ComplexTriple.complexSmul Complex.I basisTriple3).toOctonion :=
    e001_mul_e010.trans e011_eq_I_smul_basisTriple3
  convert congr_arg (fun x => g.toFun x) h1 using 1
  · rw [g.map_mul, g.onComplexTriple_toOctonion, g.onComplexTriple_toOctonion]
  · rw [← g.onComplexTriple_toOctonion, g.onComplexTriple_complex_smul]

/-! ## Coordinate extraction from cross-product relation -/

/-- Extract the c3 coordinate equation from the cross-product relation. -/
theorem cross_product_coord_c3 (g : FixingE111MulLinear) :
    ((g.onComplexTriple basisTriple1).toOctonion *
     (g.onComplexTriple basisTriple2).toOctonion).c3 =
    ((ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion).c3 :=
  congr_arg Octonion.c3 (onComplexTriple_cross_product_relation g)

/-- Extract the c4 coordinate equation. -/
theorem cross_product_coord_c4 (g : FixingE111MulLinear) :
    ((g.onComplexTriple basisTriple1).toOctonion *
     (g.onComplexTriple basisTriple2).toOctonion).c4 =
    ((ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion).c4 :=
  congr_arg Octonion.c4 (onComplexTriple_cross_product_relation g)

/-- Extract the c1 coordinate equation. -/
theorem cross_product_coord_c1 (g : FixingE111MulLinear) :
    ((g.onComplexTriple basisTriple1).toOctonion *
     (g.onComplexTriple basisTriple2).toOctonion).c1 =
    ((ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion).c1 :=
  congr_arg Octonion.c1 (onComplexTriple_cross_product_relation g)

/-- Extract the c6 coordinate equation. -/
theorem cross_product_coord_c6 (g : FixingE111MulLinear) :
    ((g.onComplexTriple basisTriple1).toOctonion *
     (g.onComplexTriple basisTriple2).toOctonion).c6 =
    ((ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion).c6 :=
  congr_arg Octonion.c6 (onComplexTriple_cross_product_relation g)

/-- Extract the c2 coordinate equation. -/
theorem cross_product_coord_c2 (g : FixingE111MulLinear) :
    ((g.onComplexTriple basisTriple1).toOctonion *
     (g.onComplexTriple basisTriple2).toOctonion).c2 =
    ((ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion).c2 :=
  congr_arg Octonion.c2 (onComplexTriple_cross_product_relation g)

/-- Extract the c5 coordinate equation. -/
theorem cross_product_coord_c5 (g : FixingE111MulLinear) :
    ((g.onComplexTriple basisTriple1).toOctonion *
     (g.onComplexTriple basisTriple2).toOctonion).c5 =
    ((ComplexTriple.complexSmul Complex.I
      (g.onComplexTriple basisTriple3)).toOctonion).c5 :=
  congr_arg Octonion.c5 (onComplexTriple_cross_product_relation g)

/-! ## Matrix determinant equals one -/

/-
The determinant of `g.onComplexVecMatrix` is exactly 1.

    **Proof sketch.** From `onComplexTriple_cross_product_relation` and the
    unitarity `M.conjTranspose * M = 1`, we derive `det(M) = 1`.

    The cross-product relation expresses specific quadratic identities among
    the matrix entries (relating the adjugate to the conjugate). Combined
    with the column orthonormality from unitarity, these identities force
    `det(M) = 1`.
-/
theorem fixingE111MulLinear_det_eq_one
    (g : FixingE111MulLinear) :
    g.onComplexVecMatrix.det = 1 := by
  have h_det : g.onComplexVecMatrix.det = 1 ∨ g.onComplexVecMatrix.det = -1 := by
    -- Since the determinant is real and its norm squared is 1, it must be ±1.
    have h_det_real : (g.onComplexVecMatrix.det).im = 0 := by
      have := @cross_product_coord_c3 g;
      simp_all +decide [ FixingE111MulLinear.onComplexVecMatrix, Matrix.det_fin_three ];
      simp_all +decide [ ComplexTriple.ofComplexVec, ComplexTriple.toComplexVec ];
      have := cross_product_coord_c4 g
      have := cross_product_coord_c1 g
      have := cross_product_coord_c6 g
      have := cross_product_coord_c2 g
      have := cross_product_coord_c5 g
      unfold ComplexTriple.complexSmul at *
      simp_all +decide
      grind +locals;
    have h_det_real : (g.onComplexVecMatrix.det).re ^ 2 = 1 := by
      have := fixingE111MulLinear_det_normSq_eq_one g; simp_all +decide [ Complex.normSq, sq ] ;
    simp_all +decide [ Complex.ext_iff ];
  apply Or.resolve_right h_det;
  intro h_det_neg
  have h_suppose :
      ∀ i, g.onComplexVecMatrix.adjugate 2 i =
        starRingEnd ℂ (g.onComplexVecMatrix i 2) := by
    have := onComplexTriple_cross_product_relation g;
    unfold basisTriple1 basisTriple2 basisTriple3 at this; simp_all +decide [ Complex.ext_iff ] ;
    unfold ComplexTriple.toOctonion at this; simp_all +decide [ ComplexTriple.complexSmul ] ;
    unfold FixingE111MulLinear.onComplexVecMatrix
    simp +decide [Fin.forall_fin_succ,
      Matrix.adjugate_apply, Matrix.det_fin_three]
    simp_all +decide [ComplexTriple.toComplexVec,
      ComplexTriple.ofComplexVec]
    injection this;
    grind;
  -- nolint: the following lines are machine-generated and exceed 100 chars
  have h_suppose :
    ∑ i, g.onComplexVecMatrix.adjugate 2 i * g.onComplexVecMatrix i 2 =
      g.onComplexVecMatrix.det := by
    convert congr_arg (
      fun x : Matrix (Fin 3) (Fin 3) ℂ => x 2 2) (
      Matrix.adjugate_mul g.onComplexVecMatrix) using 1
    simp +decide
  simp_all +decide [Complex.ext_iff]
  exact absurd h_suppose.1 (by
    exact ne_of_gt (lt_of_lt_of_le (by norm_num) (
      Finset.sum_nonneg fun _ _ =>
        add_nonneg (mul_self_nonneg _)
          (mul_self_nonneg _))))

/-! ## Bundled package -/

/-- A bundled record of the determinant-one consequences. -/
structure G2FixingE111DetOnePackage where
  det_eq_one :
    ∀ g : FixingE111MulLinear, g.onComplexVecMatrix.det = 1
  det_unit_eq_one :
    ∀ g : FixingE111MulLinear, g.detUnit = 1

/-- The canonical `G2FixingE111DetOnePackage`. -/
noncomputable def g2FixingE111DetOnePackage :
    G2FixingE111DetOnePackage := by
  constructor;
  · exact fun g ↦ fixingE111MulLinear_det_eq_one g
  · intro g
    ext
    simp [FixingE111MulLinear.detUnit_val, fixingE111MulLinear_det_eq_one]

end PhysicsSM.Algebra.Octonion.G2ComplexLine
