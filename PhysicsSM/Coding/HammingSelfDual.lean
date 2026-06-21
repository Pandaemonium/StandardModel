import Mathlib
import PhysicsSM.Coding.ConstructionA
import PhysicsSM.Coding.HammingE8

/-!
# Self-duality and Type II classification of the extended Hamming code

This module proves that the extended `[8,4,4]` Hamming code is self-dual
(equal to its dual under the binary dot product) and is a Type II code
(self-dual and doubly even).

## Main results

- `extendedHamming8_selfOrthogonal`: every pair of codewords in
  `extendedHamming8` has binary dot product zero (i.e. `C ⊆ C⊥`).
- `extendedHamming8_selfDual`: the code equals its dual (`C = C⊥`).
- `extendedHamming8_typeII`: the code is Type II (self-dual and doubly even).

## Proof strategy

All concrete facts about the `[8,4,4]` code are discharged by `n a t i v e _ d e c i d e`
over the 256-element type `BinaryVector 8`. The definitions (`dualCode`,
`IsSelfDual`, `IsTypeII`) are stated for general binary linear codes so they
are reusable beyond dimension 8.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 3, 7.
- Aristotle job H1 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Dual code -/

/-- The dual code `C⊥` of a binary linear code `C`: the set of vectors
orthogonal (under `binaryDot`) to every codeword of `C`. -/
def dualCode {n : ℕ} (C : BinaryLinearCode n) : BinaryLinearCode n where
  carrier := { v | ∀ w ∈ C, binaryDot v w = 0 }
  add_mem' := by
    intro a b ha hb w hw
    rw [binaryDot_add_left, ha w hw, hb w hw, add_zero]
  zero_mem' := by
    intro w _
    exact binaryDot_zero_left w
  smul_mem' := by
    intro c v hv w hw
    rw [binaryDot_smul_left, hv w hw, mul_zero]

theorem mem_dualCode_iff {n : ℕ} (C : BinaryLinearCode n) (v : BinaryVector n) :
    v ∈ dualCode C ↔ ∀ w ∈ C, binaryDot v w = 0 := Iff.rfl

/-! ## Self-dual and Type II predicates -/

/-- A binary linear code is *self-dual* if it equals its dual code. -/
def IsSelfDual {n : ℕ} (C : BinaryLinearCode n) : Prop :=
  C = dualCode C

/-- A binary linear code is *Type II* (doubly-even self-dual) if it is
both self-dual and doubly even. -/
def IsTypeII {n : ℕ} (C : BinaryLinearCode n) : Prop :=
  IsSelfDual C ∧ IsDoublyEven C

/-! ## Self-orthogonality of the extended Hamming code -/

/-- Auxiliary decidable form: every pair of vectors in the kernel of the
parity-check matrix has binary dot product zero. -/
private theorem extendedHamming8_selfOrthogonal_aux :
    ∀ v w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck v = 0 →
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      binaryDot v w = 0 := by
  native_decide

/-- Every pair of codewords in `extendedHamming8` has binary dot product
zero: the code is self-orthogonal (`C ⊆ C⊥`). -/
theorem extendedHamming8_selfOrthogonal (v w : BinaryVector 8)
    (hv : v ∈ extendedHamming8) (hw : w ∈ extendedHamming8) :
    binaryDot v w = 0 :=
  extendedHamming8_selfOrthogonal_aux v w
    ((extendedHamming8_mem_iff_mulVec v).mp hv)
    ((extendedHamming8_mem_iff_mulVec w).mp hw)

/-- The extended Hamming code is contained in its dual. -/
theorem extendedHamming8_le_dual :
    extendedHamming8 ≤ dualCode extendedHamming8 := by
  intro v hv
  rw [mem_dualCode_iff]
  exact fun w hw => extendedHamming8_selfOrthogonal v w hv hw

/-! ## Self-duality of the extended Hamming code -/

/-- Auxiliary decidable form: every vector orthogonal to all codewords is
itself a codeword. This is the reverse inclusion `C⊥ ⊆ C`. -/
private theorem extendedHamming8_dual_le_aux :
    ∀ v : BinaryVector 8,
      (∀ w : BinaryVector 8,
        Matrix.mulVec extendedHamming8ParityCheck w = 0 →
        binaryDot v w = 0) →
      Matrix.mulVec extendedHamming8ParityCheck v = 0 := by
  native_decide

/-- The dual of `extendedHamming8` is contained in `extendedHamming8`. -/
theorem extendedHamming8_dual_le :
    dualCode extendedHamming8 ≤ extendedHamming8 := by
  intro v hv
  rw [extendedHamming8_mem_iff_mulVec]
  apply extendedHamming8_dual_le_aux
  intro w hw
  exact hv w hw

/-- The extended `[8,4,4]` Hamming code is self-dual: `C = C⊥`. -/
theorem extendedHamming8_selfDual :
    IsSelfDual extendedHamming8 := by
  exact le_antisymm extendedHamming8_le_dual extendedHamming8_dual_le

/-! ## Type II classification -/

/-- The extended `[8,4,4]` Hamming code is Type II: it is both self-dual
and doubly even. -/
theorem extendedHamming8_typeII :
    IsTypeII extendedHamming8 :=
  ⟨extendedHamming8_selfDual,
   fun v hv => extendedHamming8_doublyEven' v hv⟩

end PhysicsSM.Coding
