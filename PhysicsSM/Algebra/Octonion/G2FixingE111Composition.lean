import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111Determinant

/-!
# Algebra.Octonion.G2FixingE111Composition

Composition monoid structure on `FixingE111MulLinear` and compatibility of the
`ℂ³` matrix representation with composition. The determinant unit is packaged
as a monoid homomorphism.

## Mathematical context

The maps `g : FixingE111MulLinear` are real-linear, multiplicative,
unit-preserving, conjugation-preserving maps on the octonions that fix the
chosen imaginary unit `e111`. These maps are closed under composition:
composing two such maps yields another. The identity map is also such a map.

The matrix representation `g.onComplexVecMatrix` is a 3×3 complex matrix
representing the action on the complement `ℂ³`. Composition of maps
corresponds to matrix multiplication:
  `(g * h).onComplexVecMatrix = g.onComplexVecMatrix * h.onComplexVecMatrix`

where `(g * h).toFun x = g.toFun (h.toFun x)`, so `g * h` means "apply `h`
first, then `g`".

## Claim boundary

This proves functoriality of the current multiplicative-linear fixing-`e111`
record. It does **not** prove that this record is exactly `G₂`, that every
element has determinant one, connectedness, or a Lie group isomorphism with
`SU(3)`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Identity and composition -/

/-- The identity `FixingE111MulLinear` map. -/
def FixingE111MulLinear.id : FixingE111MulLinear where
  toFun := fun x => x
  map_add := fun _ _ => rfl
  map_smul := fun _ _ => rfl
  map_one := rfl
  map_mul := fun _ _ => rfl
  fixes_e111 := rfl
  map_conj := fun _ => rfl

/-- Composition of two `FixingE111MulLinear` maps. The convention is
    `(g.comp h).toFun x = g.toFun (h.toFun x)`. -/
def FixingE111MulLinear.comp
    (g h : FixingE111MulLinear) : FixingE111MulLinear where
  toFun := fun x => g.toFun (h.toFun x)
  map_add := fun x y => by rw [h.map_add, g.map_add]
  map_smul := fun r x => by rw [h.map_smul, g.map_smul]
  map_one := by rw [h.map_one, g.map_one]
  map_mul := fun x y => by rw [h.map_mul, g.map_mul]
  fixes_e111 := by rw [h.fixes_e111, g.fixes_e111]
  map_conj := fun x => by rw [h.map_conj, g.map_conj]

instance : One FixingE111MulLinear := ⟨FixingE111MulLinear.id⟩
instance : Mul FixingE111MulLinear := ⟨FixingE111MulLinear.comp⟩

/-! ## Basic apply lemmas -/

@[simp] theorem FixingE111MulLinear.one_apply (x : Octonion) :
    (1 : FixingE111MulLinear).toFun x = x := rfl

@[simp] theorem FixingE111MulLinear.mul_apply
    (g h : FixingE111MulLinear) (x : Octonion) :
    (g * h).toFun x = g.toFun (h.toFun x) := rfl

/-! ## Extensionality -/

theorem FixingE111MulLinear.ext {g h : FixingE111MulLinear}
    (hfun : ∀ x, g.toFun x = h.toFun x) : g = h := by
  cases g; cases h; simp only [mk.injEq]; funext x; exact hfun x

/-! ## Matrix compatibility -/

@[simp] theorem FixingE111MulLinear.one_onComplexVecMatrix :
    (1 : FixingE111MulLinear).onComplexVecMatrix = 1 := by
  ext i j; simp +decide [ FixingE111MulLinear.onComplexVecMatrix ] ;
  fin_cases i <;> fin_cases j <;> rfl

theorem FixingE111MulLinear.mul_onComplexVecMatrix
    (g h : FixingE111MulLinear) :
    (g * h).onComplexVecMatrix =
      g.onComplexVecMatrix * h.onComplexVecMatrix := by
  -- By definition of matrix multiplication, we can expand the right-hand side.
  have h_mul : ∀ v : Fin 3 → ℂ,
      (g * h).onComplexVecMatrix.mulVec v =
        g.onComplexVecMatrix.mulVec
          (h.onComplexVecMatrix.mulVec v) := by
    intros v
    simp [onComplexVecMatrix_mulVec, onComplexVecLinear]
    congr! 1
    simp +decide [onComplexTriple]
    congr! 2
    exact Eq.symm (toComplexTriple_toOctonion_of_inComplement
      (preserves_chosen_complex_complement h
        (ComplexTriple.toOctonion_complement
          (ComplexTriple.ofComplexVec v))))
  exact Matrix.toLin'.injective
    (LinearMap.ext fun x => by simpa using h_mul x)

/-! ## Monoid instance -/

instance FixingE111MulLinear.instMonoid : Monoid FixingE111MulLinear where
  mul_assoc a b c := FixingE111MulLinear.ext fun _ => rfl
  one_mul a := FixingE111MulLinear.ext fun _ => rfl
  mul_one a := FixingE111MulLinear.ext fun _ => rfl

/-! ## Determinant unit as monoid homomorphism -/

noncomputable def fixingE111MulLinearDetUnitMonoidHom :
    FixingE111MulLinear →* Units ℂ where
  toFun := FixingE111MulLinear.detUnit
  map_one' := by
    exact Units.ext ( by simp [ FixingE111MulLinear.detUnit ] )
  map_mul' := fun g h => by
    simp +decide [FixingE111MulLinear.detUnit,
      FixingE111MulLinear.mul_onComplexVecMatrix,
      Matrix.det_mul]

@[simp] theorem fixingE111MulLinearDetUnitMonoidHom_apply
    (g : FixingE111MulLinear) :
    fixingE111MulLinearDetUnitMonoidHom g = g.detUnit := rfl

/-! ## Bundled package -/

/-- A bundled record of the composition and determinant homomorphism results. -/
structure G2FixingE111CompositionPackage where
  fixing_monoid : Monoid FixingE111MulLinear
  matrix_mul :
    ∀ g h : FixingE111MulLinear,
      (g * h).onComplexVecMatrix =
        g.onComplexVecMatrix * h.onComplexVecMatrix
  det_unit_hom : FixingE111MulLinear →* Units ℂ

/-- The canonical `G2FixingE111CompositionPackage`. -/
noncomputable def g2FixingE111CompositionPackage :
    G2FixingE111CompositionPackage where
  fixing_monoid := FixingE111MulLinear.instMonoid
  matrix_mul := FixingE111MulLinear.mul_onComplexVecMatrix
  det_unit_hom := fixingE111MulLinearDetUnitMonoidHom

end PhysicsSM.Algebra.Octonion.G2ComplexLine
