import CodeLatticeE8.Code.Binary

/-!
# The concrete extended Hamming `[8,4,4]` code

This module defines the extended Hamming code of length eight as the kernel of
its parity-check matrix over `ZMod 2`.

Coordinate convention:

- row 0 is the overall parity check;
- rows 1--3 are the seven nonzero Hamming parity columns, followed by the
  zero column for the parity coordinate;
- columns are ordered as
  `(001), (010), (011), (100), (101), (110), (111), (000)`.

The theorem that this code has parameters `[8,4,4]` is proved in
`CodeLatticeE8.Code.Hamming844`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace CodeLatticeE8.Code

/-- The parity-check matrix for the extended binary Hamming `[8,4,4]` code. -/
def extendedHamming8ParityCheck : Matrix (Fin 4) (Fin 8) (ZMod 2) :=
  !![1,1,1,1,1,1,1,1;
     0,0,0,1,1,1,1,0;
     0,1,1,0,0,1,1,0;
     1,0,1,0,1,0,1,0]

/-- The extended Hamming `[8,4,4]` code as a submodule of `(ZMod 2)^8`. -/
def extendedHamming8 : BinaryLinearCode 8 :=
  LinearMap.ker (Matrix.mulVecLin extendedHamming8ParityCheck)

/-- A vector belongs to `extendedHamming8` iff it satisfies the parity checks. -/
theorem extendedHamming8_mem_iff_mulVec (v : BinaryVector 8) :
    v ∈ extendedHamming8 ↔
      Matrix.mulVec extendedHamming8ParityCheck v = 0 :=
  Iff.rfl

/-- Membership in the concrete Hamming code is decidable. -/
instance extendedHamming8_decidableMem : DecidablePred (· ∈ extendedHamming8) := by
  intro v
  change Decidable (v ∈ extendedHamming8)
  rw [extendedHamming8_mem_iff_mulVec]
  infer_instance

/-- The concrete Hamming code is finite because the ambient vector space is finite. -/
instance extendedHamming8_fintype : Fintype ↥extendedHamming8 := by
  infer_instance

/-- Finset of codewords, used for finite weight-distribution statements. -/
def extendedHamming8Finset : Finset (BinaryVector 8) :=
  Finset.univ.filter fun v =>
    Matrix.mulVec extendedHamming8ParityCheck v = 0

/-- Finset/submodule membership bridge for the concrete Hamming code. -/
theorem mem_extendedHamming8Finset_iff (v : BinaryVector 8) :
    v ∈ extendedHamming8Finset ↔ v ∈ extendedHamming8 := by
  simp [extendedHamming8Finset, extendedHamming8_mem_iff_mulVec]

/-- The number of codewords of a given Hamming weight. -/
def extendedHamming8WeightDist (w : ℕ) : ℕ :=
  (Finset.univ.filter fun v : BinaryVector 8 =>
    Matrix.mulVec extendedHamming8ParityCheck v = 0 ∧ hammingWeight v = w).card

end CodeLatticeE8.Code
