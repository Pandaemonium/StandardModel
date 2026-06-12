import Mathlib
import PhysicsSM.Gauge.StandardModelUnitCoveringTriple

/-!
# Gauge.StandardModelUnitZ6QuotientGroup

Unit-level Z₆ quotient group for the Standard Model gauge group scaffold.

## Mathematical context

Building on `UnitCoveringTriple` (unit-valued phase + matrix components),
this module:

1. Defines a scalar-matrix unit helper `matrixScalarUnit`.
2. Constructs the image map on `UnitCoveringTriple` into the unit-valued
   codomain `Units (Matrix (Fin 2) (Fin 2) ℂ) × Units (Matrix (Fin 3) (Fin 3) ℂ)`.
3. Proves the image map is a group homomorphism.
4. Defines image-equivalence and constructs the quotient.
5. Proves the quotient carries a group structure.
6. Constructs the image group homomorphism on the quotient.
7. Defines the image subgroup (range) and proves the quotient is
   multiplicatively equivalent to the image subgroup.
8. Packages everything into `StandardModelUnitZ6QuotientGroupPackage`.

## Claim boundary

This is an algebraic unit-domain quotient-by-image scaffold. It does not
prove a topological quotient, smooth quotient, compact Lie group theorem,
or the exact `S(U(2) × U(3))` theorem. It does not enforce determinant-one
or unitarity constraints.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Scalar-matrix unit -/

/--
A scalar unit `z : Units ℂ` gives a unit matrix `z • 1` via the algebra map.
-/
noncomputable def matrixScalarUnit
    {n : Type} [Fintype n] [DecidableEq n]
    (z : Units Complex) :
    Units (Matrix n n Complex) :=
  Units.map (algebraMap ℂ (Matrix n n ℂ)).toMonoidHom z

@[simp] theorem matrixScalarUnit_val {n : Type} [Fintype n] [DecidableEq n]
    (z : Units ℂ) :
    (matrixScalarUnit z).val = (z : ℂ) • (1 : Matrix n n ℂ) := by
  simp [matrixScalarUnit, Units.map, Algebra.algebraMap_eq_smul_one]

@[simp] theorem matrixScalarUnit_one {n : Type} [Fintype n] [DecidableEq n] :
    matrixScalarUnit (1 : Units ℂ) = (1 : Units (Matrix n n ℂ)) := by
  exact map_one _

@[simp] theorem matrixScalarUnit_mul {n : Type} [Fintype n] [DecidableEq n]
    (z w : Units ℂ) :
    @matrixScalarUnit n _ _ (z * w) =
      @matrixScalarUnit n _ _ z * @matrixScalarUnit n _ _ w := by
  exact map_mul _ z w

/-
Scalar units commute with all matrix units.
-/
theorem matrixScalarUnit_comm {n : Type} [Fintype n] [DecidableEq n]
    (z : Units ℂ) (A : Units (Matrix n n ℂ)) :
    matrixScalarUnit z * A = A * matrixScalarUnit z := by
  ext i j
  simp [Algebra.mul_smul_comm]

/-! ## Image codomain -/

/--
The codomain for the unit-valued covering image: pairs of invertible matrices.
-/
abbrev UnitCoveringImageCodomain :=
  Units (Matrix (Fin 2) (Fin 2) Complex) ×
    Units (Matrix (Fin 3) (Fin 3) Complex)

/-! ## Image map -/

/--
The image of a `UnitCoveringTriple` under the covering map, in the unit world:
`(α, g, h) ↦ (α³ · g, α⁻² · h)`.
-/
noncomputable def UnitCoveringTriple.image
    (x : UnitCoveringTriple) : UnitCoveringImageCodomain :=
  (matrixScalarUnit (x.phase ^ 3) * x.su2Part,
   matrixScalarUnit (x.phase⁻¹ ^ 2) * x.su3Part)

/-! ## Image preserves group operations -/

@[simp] theorem UnitCoveringTriple.image_one :
    (1 : UnitCoveringTriple).image = 1 := by
  change (matrixScalarUnit ((1 : Units ℂ) ^ 3) * 1,
        matrixScalarUnit ((1 : Units ℂ)⁻¹ ^ 2) * 1) = (1, 1)
  simp

set_option linter.unusedSimpArgs false in
set_option linter.style.longLine false in
theorem UnitCoveringTriple.image_mul (x y : UnitCoveringTriple) :
    (x * y).image = x.image * y.image := by
  simp [UnitCoveringTriple.image]
  constructor <;> simp +decide [mul_pow, mul_assoc, mul_comm, mul_left_comm, matrixScalarUnit_mul]
  · simp +decide [mul_assoc, matrixScalarUnit_comm]
  · simp +decide [← mul_assoc, ← matrixScalarUnit_comm]

theorem UnitCoveringTriple.image_inv (x : UnitCoveringTriple) :
    x⁻¹.image = x.image⁻¹ := by
  ext <;> simp +decide [ UnitCoveringTriple.image ];
  · simp +decide [ Matrix.inv_def, Matrix.smul_eq_diagonal_mul ];
    simp +decide [sq, mul_assoc, mul_comm];
  · simp +decide [ Matrix.inv_def, Matrix.smul_eq_diagonal_mul ];
    grind

/--
The covering-map image as a group homomorphism from `UnitCoveringTriple`
to the unit-valued codomain.
-/
noncomputable def unitCoveringTripleImageGroupHom :
    UnitCoveringTriple →* UnitCoveringImageCodomain where
  toFun := UnitCoveringTriple.image
  map_one' := UnitCoveringTriple.image_one
  map_mul' := UnitCoveringTriple.image_mul

/-! ## Image equivalence -/

/--
Two unit covering triples are image-equivalent when they have the same
image under the covering map.
-/
def UnitCoveringTriple.ImageEquivalent
    (x y : UnitCoveringTriple) : Prop := x.image = y.image

/--
The setoid on `UnitCoveringTriple` given by image equivalence.
-/
instance UnitCoveringTriple.imageSetoid : Setoid UnitCoveringTriple where
  r := UnitCoveringTriple.ImageEquivalent
  iseqv := ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/--
The quotient of `UnitCoveringTriple` by image equivalence.
-/
abbrev StandardModelUnitCoveringQuotient :=
  Quotient UnitCoveringTriple.imageSetoid

/-! ## Group structure on the quotient -/

private theorem imageEquivalent_mul
    {a b c d : UnitCoveringTriple}
    (hab : UnitCoveringTriple.ImageEquivalent a b)
    (hcd : UnitCoveringTriple.ImageEquivalent c d) :
    UnitCoveringTriple.ImageEquivalent (a * c) (b * d) := by
  simp only [UnitCoveringTriple.ImageEquivalent, UnitCoveringTriple.image_mul]
  rw [hab, hcd]

private theorem imageEquivalent_inv
    {a b : UnitCoveringTriple}
    (hab : UnitCoveringTriple.ImageEquivalent a b) :
    UnitCoveringTriple.ImageEquivalent a⁻¹ b⁻¹ := by
  simp only [UnitCoveringTriple.ImageEquivalent, UnitCoveringTriple.image_inv]
  rw [hab]

noncomputable instance : Group StandardModelUnitCoveringQuotient where
  one := ⟦1⟧
  mul := Quotient.lift₂
    (fun x y => (⟦x * y⟧ : StandardModelUnitCoveringQuotient))
    (fun _ _ _ _ hab hcd => Quotient.sound (imageEquivalent_mul hab hcd))
  inv := Quotient.lift
    (fun x => (⟦x⁻¹⟧ : StandardModelUnitCoveringQuotient))
    (fun _ _ hab => Quotient.sound (imageEquivalent_inv hab))
  mul_assoc a b c := by
    induction a using Quotient.ind; induction b using Quotient.ind
    induction c using Quotient.ind
    exact congrArg (Quotient.mk _) (mul_assoc _ _ _)
  one_mul a := by
    induction a using Quotient.ind
    exact congrArg (Quotient.mk _) (one_mul _)
  mul_one a := by
    induction a using Quotient.ind
    exact congrArg (Quotient.mk _) (mul_one _)
  inv_mul_cancel a := by
    induction a using Quotient.ind
    exact congrArg (Quotient.mk _) (inv_mul_cancel _)

/-! ## Quotient image group homomorphism -/

/--
The image map descends to the quotient as a group (monoid) homomorphism.
-/
noncomputable def standardModelUnitCoveringQuotientImageGroupHom :
    StandardModelUnitCoveringQuotient →* UnitCoveringImageCodomain where
  toFun := Quotient.lift UnitCoveringTriple.image (fun _ _ h => h)
  map_one' := UnitCoveringTriple.image_one
  map_mul' a b := by
    induction a using Quotient.ind; induction b using Quotient.ind
    exact UnitCoveringTriple.image_mul _ _

/-! ## Image subgroup -/

/--
The image subgroup: the range of the covering-map image homomorphism.
-/
noncomputable def standardModelUnitCoveringImageSubgroup :
    Subgroup UnitCoveringImageCodomain :=
  standardModelUnitCoveringQuotientImageGroupHom.range

/-! ## Quotient is isomorphic to image subgroup -/

/--
The induced map from the quotient to the image subgroup (range).
-/
private noncomputable def quotientToImageSubgroup :
    StandardModelUnitCoveringQuotient →* standardModelUnitCoveringImageSubgroup :=
  standardModelUnitCoveringQuotientImageGroupHom.rangeRestrict

private theorem quotientToImageSubgroup_bijective :
    Function.Bijective quotientToImageSubgroup := by
  constructor;
  · intro a b hab;
    obtain ⟨x, rfl⟩ := Quotient.exists_rep a
    obtain ⟨y, rfl⟩ := Quotient.exists_rep b
    simp only [quotientToImageSubgroup, MonoidHom.rangeRestrict] at hab
    rw [Subtype.ext_iff] at hab
    exact Quotient.sound hab;
  · intro x;
    exact ⟨Classical.choose x.2,
      Subtype.ext <| Classical.choose_spec x.2⟩

/--
The quotient `StandardModelUnitCoveringQuotient` is multiplicatively
equivalent to the image subgroup of the covering map.
-/
noncomputable def standardModelUnitCoveringQuotientMulEquivImageSubgroup :
    StandardModelUnitCoveringQuotient ≃*
      standardModelUnitCoveringImageSubgroup :=
  MulEquiv.ofBijective quotientToImageSubgroup quotientToImageSubgroup_bijective

/-! ## Bundled package -/

/--
Bundled record collecting the unit-level Z₆ quotient group results.
-/
structure StandardModelUnitZ6QuotientGroupPackage where
  /-- The group structure on the quotient. -/
  quotient_group : Group StandardModelUnitCoveringQuotient
  /-- The image homomorphism on the quotient. -/
  image_hom :
    StandardModelUnitCoveringQuotient →* UnitCoveringImageCodomain
  /-- The image subgroup (range of the hom). -/
  image_subgroup : Subgroup UnitCoveringImageCodomain
  /-- The quotient is isomorphic to the image subgroup. -/
  quotient_equiv_image :
    StandardModelUnitCoveringQuotient ≃* image_subgroup

/--
The unit-level Z₆ quotient group package, instantiated from the proved
declarations.
-/
noncomputable def standardModelUnitZ6QuotientGroupPackage :
    StandardModelUnitZ6QuotientGroupPackage :=
  { quotient_group := inferInstance
    image_hom := standardModelUnitCoveringQuotientImageGroupHom
    image_subgroup := standardModelUnitCoveringImageSubgroup
    quotient_equiv_image := by
      exact standardModelUnitCoveringQuotientMulEquivImageSubgroup
  }

end PhysicsSM.Gauge.StandardModelSubgroup
