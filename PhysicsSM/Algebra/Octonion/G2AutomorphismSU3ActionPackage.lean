import Mathlib
import PhysicsSM.Algebra.Octonion.G2AutomorphismStabilizerBridge
import PhysicsSM.Algebra.Octonion.G2FixingE111SU3Package
import PhysicsSM.Algebra.Octonion.G2FixingE111DetOne
import PhysicsSM.Algebra.Octonion.G2FixingE111GUTSquare

/-!
# Algebra.Octonion.G2AutomorphismSU3ActionPackage

Paper-facing package assembling the Baez headline theorem:
choosing a complex octonion line (the `e111` direction) leaves an
SU(3) color action on the complementary `ℂ³`.

## Main results

1. **Group structure on `OctonionMulAutFixingE111`**: transported from the
   group structure on `FixingE111MulLinear` via the canonical bijection.

2. **Multiplicative bijection to SU(3)**: the composite equivalence
   `OctonionMulAutFixingE111 ≃* su3Submonoid` is a group isomorphism.

3. **SU(3) action on `ℂ³`**: every automorphism fixing `e111` induces a
   unitary matrix with determinant 1 on the complement, preserving the
   Hermitian form and the GUT-square block predicates.

4. **`G2AutomorphismSU3ActionPackage`**: a single bundled record collecting
   all the above, suitable for citation from `FureyBaezDVTMainTheorem`.

## Claim boundary

This file uses the project's algebraic automorphism/fixing structures.
It does **not** claim the full topological Lie group `G₂`, connectedness,
or smooth isomorphism. The XOR/Fano octonion convention is preserved.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Status: trusted theorem package; no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Part 1: Group structure on `OctonionMulAutFixingE111` -/

/-- The group structure on `OctonionMulAutFixingE111`, transported from
    `FixingE111MulLinear` via the canonical bijection
    `octonionMulAutFixingE111EquivFixingE111MulLinear`. -/
noncomputable instance OctonionMulAutFixingE111.instGroup :
    Group OctonionMulAutFixingE111 :=
  letI e := octonionMulAutFixingE111EquivFixingE111MulLinear
  { mul := fun f g => e.symm (e f * e g)
    mul_assoc := fun a b c => by
      change e.symm (e (e.symm (e a * e b)) * e c) =
        e.symm (e a * e (e.symm (e b * e c)))
      simp [mul_assoc]
    one := e.symm 1
    one_mul := fun a => by
      change e.symm (e (e.symm 1) * e a) = a
      simp
    mul_one := fun a => by
      change e.symm (e a * e (e.symm 1)) = a
      simp
    inv := fun f => e.symm (e f)⁻¹
    inv_mul_cancel := fun a => by
      change e.symm (e (e.symm (e a)⁻¹) * e a) = e.symm 1
      simp }

/-! ## Part 2: Multiplicative equivalence to SU(3) -/

/-- The map `OctonionMulAutFixingE111 → FixingE111MulLinear` is a group
    homomorphism with respect to the transported group structure. -/
theorem OctonionMulAutFixingE111.toFixingE111MulLinear_mul
    (f g : OctonionMulAutFixingE111) :
    (f * g).toFixingE111MulLinear =
      f.toFixingE111MulLinear * g.toFixingE111MulLinear := by
  change octonionMulAutFixingE111EquivFixingE111MulLinear
    (octonionMulAutFixingE111EquivFixingE111MulLinear.symm
      (octonionMulAutFixingE111EquivFixingE111MulLinear f *
       octonionMulAutFixingE111EquivFixingE111MulLinear g)) =
    octonionMulAutFixingE111EquivFixingE111MulLinear f *
    octonionMulAutFixingE111EquivFixingE111MulLinear g
  simp

/-- The map `OctonionMulAutFixingE111 → FixingE111MulLinear` preserves
    the identity. -/
theorem OctonionMulAutFixingE111.toFixingE111MulLinear_one :
    (1 : OctonionMulAutFixingE111).toFixingE111MulLinear =
      (1 : FixingE111MulLinear) := by
  change octonionMulAutFixingE111EquivFixingE111MulLinear
    (octonionMulAutFixingE111EquivFixingE111MulLinear.symm 1) = 1
  simp

/-- The multiplicative equivalence
    `OctonionMulAutFixingE111 ≃* FixingE111MulLinear`. -/
noncomputable def octonionMulAutFixingE111MulEquivFixingE111 :
    OctonionMulAutFixingE111 ≃* FixingE111MulLinear where
  toEquiv := octonionMulAutFixingE111EquivFixingE111MulLinear
  map_mul' := OctonionMulAutFixingE111.toFixingE111MulLinear_mul

/-- The multiplicative equivalence
    `OctonionMulAutFixingE111 ≃* su3Submonoid`, composing the two
    group isomorphisms. -/
noncomputable def octonionMulAutFixingE111MulEquivSU3 :
    OctonionMulAutFixingE111 ≃* su3Submonoid :=
  octonionMulAutFixingE111MulEquivFixingE111.trans
    fixingE111MulLinearGroupEquivSU3

/-! ## Part 3: SU(3) action on the complement ℂ³ -/

/-- The `3 × 3` complex matrix induced by an `OctonionMulAutFixingE111`
    automorphism on the complement `ℂ³`. -/
noncomputable def OctonionMulAutFixingE111.onComplexVecMatrix
    (f : OctonionMulAutFixingE111) :
    Matrix (Fin 3) (Fin 3) ℂ :=
  f.toFixingE111MulLinear.onComplexVecMatrix

/-- The matrix of an automorphism fixing `e111` is unitary with
    determinant 1 (acts as SU(3) on `ℂ³`). -/
theorem OctonionMulAutFixingE111.onComplexVecMatrix_actsAsSU3
    (f : OctonionMulAutFixingE111) :
    MatrixActsAsSU3OnC3 f.onComplexVecMatrix :=
  f.toFixingE111MulLinear.onComplexVecMatrix_actsAsSU3

/-- The matrix of an automorphism fixing `e111` preserves the Hermitian
    inner product on `ComplexTriple`. -/
theorem OctonionMulAutFixingE111.preservesHermitian
    (f : OctonionMulAutFixingE111) :
    PreservesComplexTripleHermitian f.toFixingE111MulLinear :=
  fixingE111MulLinear_preservesHermitian f.toFixingE111MulLinear

/-- The determinant of the complement matrix is exactly 1. -/
theorem OctonionMulAutFixingE111.det_eq_one
    (f : OctonionMulAutFixingE111) :
    f.onComplexVecMatrix.det = 1 :=
  fixingE111MulLinear_det_eq_one f.toFixingE111MulLinear

/-- The identity automorphism has matrix 1. -/
theorem OctonionMulAutFixingE111.one_onComplexVecMatrix :
    (1 : OctonionMulAutFixingE111).onComplexVecMatrix = 1 := by
  unfold onComplexVecMatrix
  rw [toFixingE111MulLinear_one]
  exact FixingE111MulLinear.one_onComplexVecMatrix

/-- Composition of automorphisms corresponds to matrix multiplication. -/
theorem OctonionMulAutFixingE111.mul_onComplexVecMatrix
    (f g : OctonionMulAutFixingE111) :
    (f * g).onComplexVecMatrix =
      f.onComplexVecMatrix * g.onComplexVecMatrix := by
  unfold onComplexVecMatrix
  rw [toFixingE111MulLinear_mul]
  exact FixingE111MulLinear.mul_onComplexVecMatrix
    f.toFixingE111MulLinear g.toFixingE111MulLinear

/-- The matrix agrees with the SU(3) equivalence image. -/
theorem OctonionMulAutFixingE111.onComplexVecMatrix_eq_su3
    (f : OctonionMulAutFixingE111) :
    f.onComplexVecMatrix =
      (octonionMulAutFixingE111MulEquivSU3 f :
        Matrix (Fin 3) (Fin 3) ℂ) := by
  rfl

/-! ## Part 4: GUT-square block predicates -/

/-- The block embedding of an automorphism fixing `e111` satisfies the
    Pati-Salam predicate. -/
theorem OctonionMulAutFixingE111.gutBlock_patiSalam
    (f : OctonionMulAutFixingE111) :
    PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
      (c3MatrixAsGUTBlock f.onComplexVecMatrix) :=
  fixingE111MulLinear_gutBlock_patiSalam f.toFixingE111MulLinear

/-- The block embedding satisfies the SM block predicate (using det = 1). -/
theorem OctonionMulAutFixingE111.gutBlock_smBlock
    (f : OctonionMulAutFixingE111) :
    PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
      (c3MatrixAsGUTBlock f.onComplexVecMatrix) :=
  fixingE111MulLinear_gutBlock_smBlock_of_det
    f.toFixingE111MulLinear f.det_eq_one

/-- The block embedding satisfies the SU(5) predicate (using det = 1). -/
theorem OctonionMulAutFixingE111.gutBlock_su5
    (f : OctonionMulAutFixingE111) :
    PhysicsSM.Gauge.GUTSquare.SU5Predicate
      (c3MatrixAsGUTBlock f.onComplexVecMatrix) :=
  fixingE111MulLinear_gutBlock_su5_of_det
    f.toFixingE111MulLinear f.det_eq_one

/-! ## Part 5: Paper-facing package -/

/-- Bundled paper-facing package for the Baez headline theorem:
    octonion automorphisms fixing the chosen complex line `e111` act as
    SU(3) on the complementary `ℂ³`, preserving the Hermitian form,
    having determinant 1, and satisfying the GUT-square block predicates.

    This record is designed to be imported by `FureyBaezDVTMainTheorem`
    for citation in the formalization paper. -/
structure G2AutomorphismSU3ActionPackage where
  /-- The group isomorphism `OctonionMulAutFixingE111 ≃* su3Submonoid`. -/
  group_equiv : OctonionMulAutFixingE111 ≃* su3Submonoid
  /-- Every automorphism fixing `e111` acts as SU(3) on `ℂ³`. -/
  acts_as_su3 :
    ∀ f : OctonionMulAutFixingE111,
      MatrixActsAsSU3OnC3 f.onComplexVecMatrix
  /-- The complement matrix has determinant 1. -/
  det_eq_one :
    ∀ f : OctonionMulAutFixingE111,
      f.onComplexVecMatrix.det = 1
  /-- Identity automorphism maps to the identity matrix. -/
  matrix_one :
    (1 : OctonionMulAutFixingE111).onComplexVecMatrix = 1
  /-- Composition maps to matrix multiplication. -/
  matrix_mul :
    ∀ f g : OctonionMulAutFixingE111,
      (f * g).onComplexVecMatrix =
        f.onComplexVecMatrix * g.onComplexVecMatrix
  /-- The block embedding satisfies the GUT-square Pati-Salam predicate. -/
  gutBlock_patiSalam :
    ∀ f : OctonionMulAutFixingE111,
      PhysicsSM.Gauge.GUTSquare.PatiSalamPredicate
        (c3MatrixAsGUTBlock f.onComplexVecMatrix)
  /-- The block embedding satisfies the GUT-square SM block predicate. -/
  gutBlock_smBlock :
    ∀ f : OctonionMulAutFixingE111,
      PhysicsSM.Gauge.GUTSquare.SMBlockPredicate
        (c3MatrixAsGUTBlock f.onComplexVecMatrix)
  /-- The block embedding satisfies the GUT-square SU(5) predicate. -/
  gutBlock_su5 :
    ∀ f : OctonionMulAutFixingE111,
      PhysicsSM.Gauge.GUTSquare.SU5Predicate
        (c3MatrixAsGUTBlock f.onComplexVecMatrix)

/-- The canonical `G2AutomorphismSU3ActionPackage`, built entirely from
    previously verified project declarations. -/
noncomputable def g2AutomorphismSU3ActionPackage :
    G2AutomorphismSU3ActionPackage where
  group_equiv := octonionMulAutFixingE111MulEquivSU3
  acts_as_su3 := OctonionMulAutFixingE111.onComplexVecMatrix_actsAsSU3
  det_eq_one := OctonionMulAutFixingE111.det_eq_one
  matrix_one := OctonionMulAutFixingE111.one_onComplexVecMatrix
  matrix_mul := OctonionMulAutFixingE111.mul_onComplexVecMatrix
  gutBlock_patiSalam := OctonionMulAutFixingE111.gutBlock_patiSalam
  gutBlock_smBlock := OctonionMulAutFixingE111.gutBlock_smBlock
  gutBlock_su5 := OctonionMulAutFixingE111.gutBlock_su5

end PhysicsSM.Algebra.Octonion.G2ComplexLine
