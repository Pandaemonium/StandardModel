import Mathlib
import PhysicsSM.Algebra.Jordan.H3OComplexMatrix
import PhysicsSM.Algebra.Jordan.Derivation

/-!
# Algebra.Jordan.H3OComplexMatrixLinear

Complex scalar multiplication on the orthogonal complement of `h₃(ℂ)` in
`h₃(𝕆)`, transported from the ordinary scalar multiplication on
`Matrix (Fin 3) (Fin 3) ℂ` via the coordinate equivalence
`complementEquivM3C`.

## Main declarations

- `complexSmulComplement` — complex scalar multiplication on `H3O` elements,
  defined by transporting through `M₃(ℂ)`.
- `complexSmulComplement_inComplementOfB` — the result stays in the complement.
- `complexSmulComplement_m3CToComplement` — interaction with `m3CToComplement`.
- `complementToM3C_complexSmulComplement` — interaction with `complementToM3C`.
- Module-law theorems: identity, associativity, distributivity over scalars
  and vectors.
- `complementAddSubgroup` — the complement as an `AddSubgroup` of `H3O`.
- `complementLinearEquivM3C` — complex-linear equivalence between the
  complement subtype and `M₃(ℂ)`.

## Claim boundary

This is only a vector-space/coordinate API. It does not claim the DVT
stabilizer theorem `(SU(3) × SU(3)) / ℤ₃`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Octonion

/-! ## Complex scalar multiplication on the complement -/

/-- Complex scalar multiplication on the complement, transported from `M₃(ℂ)`. -/
noncomputable def complexSmulComplement (z : ℂ) (a : H3O) : H3O :=
  m3CToComplement (z • complementToM3C a)

/-! ## Basic interaction lemmas -/

/-- Complex-scaling a complement element stays in the complement. -/
theorem complexSmulComplement_inComplementOfB
    (z : ℂ) (a : H3O) :
    InComplementOfB (complexSmulComplement z a) :=
  m3CToComplement_inComplementOfB _

/-- Complex-scaling an element built from a matrix is the same as scaling the matrix. -/
theorem complexSmulComplement_m3CToComplement
    (z : ℂ) (M : Matrix (Fin 3) (Fin 3) ℂ) :
    complexSmulComplement z (m3CToComplement M) =
      m3CToComplement (z • M) := by
  simp [complexSmulComplement, complementToM3C_m3CToComplement]

/-- Extracting coordinates after complex-scaling gives the scaled coordinates. -/
theorem complementToM3C_complexSmulComplement
    (z : ℂ) (a : H3O) :
    complementToM3C (complexSmulComplement z a) =
      z • complementToM3C a := by
  simp [complexSmulComplement, complementToM3C_m3CToComplement]

/-! ## Module laws on complement elements -/

/-- Scaling by `1` is the identity on complement elements. -/
theorem complexSmulComplement_one_of_inComplementOfB
    {a : H3O} (ha : InComplementOfB a) :
    complexSmulComplement 1 a = a := by
  simp [complexSmulComplement, one_smul,
    m3CToComplement_complementToM3C_of_inComplementOfB ha]

/-- Scaling is associative on complement elements.

Note: the hypothesis `ha` is not strictly needed for this identity
(it holds for all `a : H3O`), but is kept for API symmetry with
`complexSmulComplement_one_of_inComplementOfB`. -/
theorem complexSmulComplement_mul_of_inComplementOfB
    (z w : ℂ) {a : H3O} (_ha : InComplementOfB a) :
    complexSmulComplement z (complexSmulComplement w a) =
      complexSmulComplement (z * w) a := by
  simp [complexSmulComplement, complementToM3C_m3CToComplement, mul_smul]

/-- Complex scalar multiplication distributes over scalar addition. -/
theorem complexSmulComplement_add_scalar
    (z w : ℂ) (a : H3O) :
    complexSmulComplement (z + w) a =
      complexSmulComplement z a + complexSmulComplement w a := by
  simp [complexSmulComplement, add_smul, m3CToComplement_add]

/-- Complex scalar multiplication distributes over vector addition. -/
theorem complexSmulComplement_add_vector
    (z : ℂ) (a b : H3O) :
    complexSmulComplement z (a + b) =
      complexSmulComplement z a + complexSmulComplement z b := by
  simp [complexSmulComplement, complementToM3C_add, smul_add, m3CToComplement_add]

/-! ## AddSubgroup and Module instances -/

/-- The complement of `h₃(ℂ)` in `h₃(𝕆)` as an additive subgroup. -/
def complementAddSubgroup : AddSubgroup H3O where
  carrier := {a | InComplementOfB a}
  zero_mem' := zero_inComplementOfB
  add_mem' := add_mem_complementOfB
  neg_mem' := neg_mem_complementOfB

theorem mem_complementAddSubgroup_iff {a : H3O} :
    a ∈ complementAddSubgroup ↔ InComplementOfB a := Iff.rfl

/-- Complex `SMul` on the complement subgroup, transported from `M₃(ℂ)`. -/
noncomputable instance : SMul ℂ complementAddSubgroup where
  smul z a := ⟨complexSmulComplement z a.val,
    complexSmulComplement_inComplementOfB z a.val⟩

@[simp]
theorem complementSubgroup_smul_val (z : ℂ) (a : complementAddSubgroup) :
    (z • a).val = complexSmulComplement z a.val := rfl

/-- The complement subgroup is a complex module via transported structure. -/
noncomputable instance : Module ℂ complementAddSubgroup where
  one_smul a := Subtype.ext <|
    complexSmulComplement_one_of_inComplementOfB a.property
  mul_smul z w a := Subtype.ext <|
    (complexSmulComplement_mul_of_inComplementOfB z w (a := a.val) a.property).symm
  smul_zero z := Subtype.ext <| by
    simp [complexSmulComplement, complementToM3C_zero, smul_zero]
  smul_add z a b := Subtype.ext <|
    complexSmulComplement_add_vector z a.val b.val
  add_smul z w a := Subtype.ext <|
    complexSmulComplement_add_scalar z w a.val
  zero_smul a := Subtype.ext <| by
    simp [complexSmulComplement, zero_smul]

/-! ## Complex-linear equivalence -/

/-- The complement subgroup is complex-linearly equivalent to `M₃(ℂ)`. -/
noncomputable def complementLinearEquivM3C :
    complementAddSubgroup ≃ₗ[ℂ]
      Matrix (Fin 3) (Fin 3) ℂ where
  toFun a := complementToM3C a.val
  invFun M := ⟨m3CToComplement M, m3CToComplement_inComplementOfB M⟩
  left_inv a := by
    ext1
    exact m3CToComplement_complementToM3C_of_inComplementOfB a.property
  right_inv M := complementToM3C_m3CToComplement M
  map_add' a b := by
    simp [complementToM3C_add]
  map_smul' z a := by
    simp [complementToM3C_complexSmulComplement]

end PhysicsSM.Algebra.Jordan.H3O
