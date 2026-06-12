import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientMonoidLaws

/-!
# Gauge.StandardModelUnitCoveringTriple

Unit-level covering triple for the Standard Model gauge group scaffold.

Replaces the raw `CoveringTriple` (whose phase and matrix components are
arbitrary complex numbers / matrices) with `UnitCoveringTriple`, whose
components are **units** in their respective rings. This is a safe algebraic
bridge toward the true `U(1) × SU(2) × SU(3)` domain, with unitarity and
determinant-one constraints are *not* imposed here.

## Main declarations

* `UnitCoveringTriple` - structure with unit-valued phase and matrix parts.
* `UnitCoveringTriple.instGroup` - group instance (componentwise).
* `UnitCoveringTriple.toCoveringTriple` - forgetful map to raw triples.
* `unitCoveringTripleToCoveringTripleMonoidHom` - the forgetful map as a
  `MonoidHom`.
* `StandardModelUnitCoveringTriplePackage` - bundled record of the above.

## Claim boundary

This is a unit-level algebraic scaffold. It does not impose unitarity,
determinant one, special-unitary constraints, quotient topology, or a Lie
group isomorphism with `S(U(2) × U(3))`.

Status: trusted theorem package; all proofs are complete.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix

/-! ## Unit-level covering triple -/

/--
A covering triple whose components are units in their respective rings.
This is a stepping stone from the raw `CoveringTriple` toward the true
`U(1) × SU(2) × SU(3)` domain.
-/
structure UnitCoveringTriple where
  /-- The U(1) phase, as a unit of ℂ. -/
  phase : Units ℂ
  /-- The SU(2) matrix, as a unit of `Matrix (Fin 2) (Fin 2) ℂ`. -/
  su2Part : Units (Matrix (Fin 2) (Fin 2) ℂ)
  /-- The SU(3) matrix, as a unit of `Matrix (Fin 3) (Fin 3) ℂ`. -/
  su3Part : Units (Matrix (Fin 3) (Fin 3) ℂ)

/-! ## Ext lemma -/

@[ext]
theorem UnitCoveringTriple.ext {x y : UnitCoveringTriple}
    (h1 : x.phase = y.phase)
    (h2 : x.su2Part = y.su2Part)
    (h3 : x.su3Part = y.su3Part) :
    x = y := by
  cases x; cases y; simp_all

/-! ## Group structure -/

instance : One UnitCoveringTriple :=
  ⟨⟨1, 1, 1⟩⟩

instance : Mul UnitCoveringTriple :=
  ⟨fun x y => ⟨x.phase * y.phase, x.su2Part * y.su2Part, x.su3Part * y.su3Part⟩⟩

instance : Inv UnitCoveringTriple :=
  ⟨fun x => ⟨x.phase⁻¹, x.su2Part⁻¹, x.su3Part⁻¹⟩⟩

@[simp] theorem UnitCoveringTriple.mul_phase (x y : UnitCoveringTriple) :
    (x * y).phase = x.phase * y.phase := rfl

@[simp] theorem UnitCoveringTriple.mul_su2Part (x y : UnitCoveringTriple) :
    (x * y).su2Part = x.su2Part * y.su2Part := rfl

@[simp] theorem UnitCoveringTriple.mul_su3Part (x y : UnitCoveringTriple) :
    (x * y).su3Part = x.su3Part * y.su3Part := rfl

@[simp] theorem UnitCoveringTriple.one_phase :
    (1 : UnitCoveringTriple).phase = 1 := rfl

@[simp] theorem UnitCoveringTriple.one_su2Part :
    (1 : UnitCoveringTriple).su2Part = 1 := rfl

@[simp] theorem UnitCoveringTriple.one_su3Part :
    (1 : UnitCoveringTriple).su3Part = 1 := rfl

@[simp] theorem UnitCoveringTriple.inv_phase (x : UnitCoveringTriple) :
    x⁻¹.phase = x.phase⁻¹ := rfl

@[simp] theorem UnitCoveringTriple.inv_su2Part (x : UnitCoveringTriple) :
    x⁻¹.su2Part = x.su2Part⁻¹ := rfl

@[simp] theorem UnitCoveringTriple.inv_su3Part (x : UnitCoveringTriple) :
    x⁻¹.su3Part = x.su3Part⁻¹ := rfl

instance UnitCoveringTriple.instGroup : Group UnitCoveringTriple where
  mul_assoc x y z := by ext <;> simp [mul_assoc]
  one_mul x := by ext <;> simp
  mul_one x := by ext <;> simp
  inv_mul_cancel x := by ext <;> simp [inv_mul_cancel]

/-! ## Forgetful map to CoveringTriple -/

/--
Forget the unit structure and produce a raw `CoveringTriple`.
-/
noncomputable def UnitCoveringTriple.toCoveringTriple
    (x : UnitCoveringTriple) : CoveringTriple :=
  { phase := (x.phase : ℂ)
    su2Part := (x.su2Part : Matrix (Fin 2) (Fin 2) ℂ)
    su3Part := (x.su3Part : Matrix (Fin 3) (Fin 3) ℂ) }

/-! ## Projection lemmas -/

@[simp] theorem UnitCoveringTriple.toCoveringTriple_phase
    (x : UnitCoveringTriple) :
    x.toCoveringTriple.phase = (x.phase : ℂ) := rfl

@[simp] theorem UnitCoveringTriple.toCoveringTriple_su2Part
    (x : UnitCoveringTriple) :
    x.toCoveringTriple.su2Part = (x.su2Part : Matrix (Fin 2) (Fin 2) ℂ) := rfl

@[simp] theorem UnitCoveringTriple.toCoveringTriple_su3Part
    (x : UnitCoveringTriple) :
    x.toCoveringTriple.su3Part = (x.su3Part : Matrix (Fin 3) (Fin 3) ℂ) := rfl

@[simp] theorem UnitCoveringTriple.toCoveringTriple_one :
    (1 : UnitCoveringTriple).toCoveringTriple = 1 := by
  apply CoveringTriple.ext' <;> rfl

@[simp] theorem UnitCoveringTriple.toCoveringTriple_mul
    (x y : UnitCoveringTriple) :
    (x * y).toCoveringTriple =
      x.toCoveringTriple * y.toCoveringTriple := by
  apply CoveringTriple.ext' <;>
    simp [CoveringTriple.mul_phase, CoveringTriple.mul_su2Part,
      CoveringTriple.mul_su3Part, Units.val_mul]

/-! ## Monoid homomorphism -/

/--
The forgetful map from `UnitCoveringTriple` to `CoveringTriple`, packaged
as a monoid homomorphism.
-/
noncomputable def unitCoveringTripleToCoveringTripleMonoidHom :
    UnitCoveringTriple →* CoveringTriple :=
  { toFun := UnitCoveringTriple.toCoveringTriple
    map_one' := UnitCoveringTriple.toCoveringTriple_one
    map_mul' := UnitCoveringTriple.toCoveringTriple_mul }

@[simp] theorem unitCoveringTripleToCoveringTripleMonoidHom_apply
    (x : UnitCoveringTriple) :
    unitCoveringTripleToCoveringTripleMonoidHom x =
      x.toCoveringTriple := rfl

/-! ## Bundled package -/

/--
Bundled record collecting the unit-level group instance and the forgetful
monoid homomorphism to raw `CoveringTriple`.
-/
structure StandardModelUnitCoveringTriplePackage where
  /-- The group structure on `UnitCoveringTriple`. -/
  unit_group : Group UnitCoveringTriple
  /-- The forgetful monoid homomorphism. -/
  forget_hom : UnitCoveringTriple →* CoveringTriple
  /-- The forgetful map is multiplicative. -/
  forget_mul :
    ∀ x y : UnitCoveringTriple,
      (x * y).toCoveringTriple =
        x.toCoveringTriple * y.toCoveringTriple

/--
The unit-level covering triple package, instantiated from the proved
declarations.
-/
noncomputable def standardModelUnitCoveringTriplePackage :
    StandardModelUnitCoveringTriplePackage :=
  { unit_group := UnitCoveringTriple.instGroup
    forget_hom := unitCoveringTripleToCoveringTripleMonoidHom
    forget_mul := UnitCoveringTriple.toCoveringTriple_mul
  }

end PhysicsSM.Gauge.StandardModelSubgroup
