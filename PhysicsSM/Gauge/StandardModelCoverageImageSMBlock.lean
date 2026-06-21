import Mathlib
import PhysicsSM.Gauge.StandardModelUnitZ6QuotientGroup
import PhysicsSM.Gauge.StandardModelGroupStructure
import PhysicsSM.Gauge.GUTSquare

/-!
# Gauge.StandardModelCoverageImageSMBlock

Bridge from the Z₆ covering image subgroup to the S(U(2) × U(3)) predicate.

## Mathematical context

The `StandardModelUnitZ6QuotientGroup` module proves that the quotient
`StandardModelUnitCoveringQuotient ≃* standardModelUnitCoveringImageSubgroup`,
where `standardModelUnitCoveringImageSubgroup` is the image of the covering
group homomorphism into `UnitCoveringImageCodomain` (pairs of invertible
complex matrices).

The Standard Model group `S(U(2) × U(3))` is identified via `SMBlockPredicate`
as block-diagonal matrices `fromBlocks A 0 0 B` where A is 2×2 unitary,
B is 3×3 unitary, and `det(A) * det(B) = 1`.

This file proves the **containment bridge** between these two descriptions:
the image of the covering map preserves the determinant product, and when
restricted to SM covering triples (with unit-norm phase, unitary parts,
and det product = 1), the image lands in `SMBlockPredicate`.

## Claim boundary

This file proves the algebraic bridge between the unit-level covering map
image and the SM block predicate. It does **not** prove surjectivity of
the covering map onto all of `S(U(2) × U(3))`, the full first-isomorphism
group theorem, or any topological quotient structure.

Status: trusted — s o r r y-free.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare

/-! ## GUTMatrix block embedding of the covering image -/

/-- Convert the image of a UnitCoveringTriple to a GUTMatrix block. -/
noncomputable def unitCoveringTripleToGUTMatrix
    (x : UnitCoveringTriple) : GUTMatrix :=
  fromBlocks (x.image.1.val) 0 0 (x.image.2.val)

/-! ## Determinant product identity -/

/-- For any UnitCoveringTriple, the determinant of the image pair
    equals det(su2Part) * det(su3Part).
    The phase cancels: α⁶ · α⁻⁶ = 1. -/
theorem unitCoveringTriple_image_det_product
    (x : UnitCoveringTriple) :
    (x.image.1 : Matrix (Fin 2) (Fin 2) ℂ).det *
    (x.image.2 : Matrix (Fin 3) (Fin 3) ℂ).det =
    (x.su2Part : Matrix (Fin 2) (Fin 2) ℂ).det *
    (x.su3Part : Matrix (Fin 3) (Fin 3) ℂ).det := by
  simp [UnitCoveringTriple.image, Units.val_mul]
  have h : (↑x.phase : ℂ) ≠ 0 := x.phase.ne_zero
  field_simp

/-! ## SM Covering Triple -/

/-- A UnitCoveringTriple is an SM covering triple if the phase has
    unit norm, the su2Part is unitary, the su3Part is unitary, and
    their determinant product = 1. The unit-norm phase condition
    ensures the image components remain unitary under scalar
    multiplication by powers of the phase. -/
structure SMCoveringTriple extends UnitCoveringTriple where
  phase_norm_one : ‖(phase : ℂ)‖ = 1
  su2_unitary : IsUnitary su2Part.val
  su3_unitary : IsUnitary su3Part.val
  det_product_one : su2Part.val.det * su3Part.val.det = 1

/-! ## Image unitarity -/

/-- A scalar matrix `z • 1` is unitary when `‖z‖ = 1`. -/
theorem isUnitary_smul_one {n : Type*} [Fintype n] [DecidableEq n]
    {z : ℂ} (hz : ‖z‖ = 1) :
    IsUnitary (z • (1 : Matrix n n ℂ)) := by
  simp [IsUnitary]
  simp +decide [← smul_assoc,
    Complex.mul_conj, Complex.normSq_eq_norm_sq, hz]

/-- The 2×2 image component of an SMCoveringTriple is unitary. -/
theorem smCoveringTriple_image_fst_unitary
    (x : SMCoveringTriple) :
    IsUnitary (x.image.1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  have hpu : IsUnitary
      ((↑(x.phase ^ 3) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)) := by
    apply isUnitary_smul_one
    have := x.phase_norm_one
    simp_all +decide [pow_succ, mul_assoc]
  convert isUnitary_mul hpu x.su2_unitary using 1
  exact congr_arg (· * x.su2Part.val) (matrixScalarUnit_val _)

/-- The 3×3 image component of an SMCoveringTriple is unitary. -/
theorem smCoveringTriple_image_snd_unitary
    (x : SMCoveringTriple) :
    IsUnitary (x.image.2 : Matrix (Fin 3) (Fin 3) ℂ) := by
  have hpu : IsUnitary
      ((↑(x.phase⁻¹ ^ 2) : ℂ) • (1 : Matrix (Fin 3) (Fin 3) ℂ)) := by
    apply isUnitary_smul_one
    simp +decide [x.phase_norm_one]
  convert isUnitary_mul hpu x.su3_unitary using 1
  exact congr_arg (· * x.su3Part.val) (matrixScalarUnit_val _)

/-! ## Main bridge theorem -/

/-- An SMCoveringTriple maps to an element satisfying SMBlockPredicate. -/
theorem smCoveringTriple_image_satisfiesSMBlock
    (x : SMCoveringTriple) :
    SMBlockPredicate (fromBlocks x.image.1.val 0 0 x.image.2.val) :=
  ⟨x.image.1.val, x.image.2.val, rfl,
    smCoveringTriple_image_fst_unitary x,
    smCoveringTriple_image_snd_unitary x,
    (unitCoveringTriple_image_det_product x.toUnitCoveringTriple).trans
      x.det_product_one⟩

/-! ## Multiplicativity of the GUTMatrix embedding -/

/-- The block embedding of the covering image is compatible with
    matrix multiplication. -/
theorem unitCoveringTripleToGUTMatrix_mul
    (x y : UnitCoveringTriple) :
    unitCoveringTripleToGUTMatrix (x * y) =
      unitCoveringTripleToGUTMatrix x *
        unitCoveringTripleToGUTMatrix y := by
  unfold unitCoveringTripleToGUTMatrix
  simp +decide [UnitCoveringTriple.image_mul,
    fromBlocks_mul_zero_off_diag]

end PhysicsSM.Gauge.StandardModelSubgroup
