import Mathlib
import PhysicsSM.Coding.ConstructionA

/-!
# Extended Hamming code and a Construction A lattice candidate

This module defines the extended `[8,4,4]` binary Hamming code and proves that
applying Construction A yields an additive subgroup of `Z^8` whose minimum
nonzero squared norm is `4`.

Mathematically, this Construction A object is the usual unscaled integer model
that becomes the E8 root lattice after scaling by `1 / sqrt 2`. This file does
not yet prove the structural bridge to E8. In particular, it does not prove a
Gram-matrix identification, unimodularity, a 240-shortest-vector theorem, or an
isometry with Sphere-Packing-Lean's E8 definition. Those are separate proof
targets.

## The extended Hamming code

The extended `[8,4,4]` Hamming code is the kernel of the `4 × 8` parity-check
matrix `H₈` over `F₂`. Its columns encode:

- Row 0: the overall parity check (`∑ vᵢ = 0`).
- Rows 1-3: the seven nonzero Hamming parity columns, followed by the zero
  column for the parity-bit position.

The row 1-3 column triples, in the displayed coordinate order, are:

```text
(0,0,1), (0,1,0), (0,1,1), (1,0,0),
(1,0,1), (1,1,0), (1,1,1), (0,0,0)
```

This is a concrete ordering of the standard seven nonzero columns, not a claim
that the columns are in binary numeric order.

The code has 16 codewords, all of weight 0, 4, or 8, and is doubly even.
Self-duality is a planned theorem in `PhysicsSM.Coding.HammingSelfDual`, not a
result of this file.

## Construction A and the E8 bridge target

The Construction A subgroup `Lambda(H_8) = { z in Z^8 : z mod 2 in H_8 }`
is the usual integer preimage of the extended Hamming code. We prove:

1. Every nonzero vector in `Lambda(H_8)` has squared norm at least `4`.
2. There exists a vector in `Lambda(H_8)` with squared norm exactly `4`.

Under the conventional scaling by `1 / sqrt 2`, this minimum-norm statement
becomes the expected E8 root normalization. Minimum norm alone does not
identify the lattice as E8.

## Finite-computation trust note

Several concrete finite facts in this file are proved with `native_decide`.
This is appropriate for the small finite searches here, but it means
`#print axioms` may report Lean's `trustCompiler` axiom for those theorems.
The publication should acknowledge this explicitly or replace these proofs with
kernel-normalized certificates before making a "minimal axiom" claim.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
- Error Correction Zoo, E8 entry: <https://errorcorrectionzoo.org/c/eeight>.
- Aristotle job for PhysicsSM, 2026-05-06.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Parity-check matrix and code definition -/

/-- The parity-check matrix for the extended `[8,4,4]` Hamming code.

Row 0 is the overall parity check. Rows 1-3 use the column triples
`(0,0,1), (0,1,0), (0,1,1), (1,0,0), (1,0,1), (1,1,0), (1,1,1)`,
followed by a zero column at position 7 for the parity-bit coordinate.

A binary vector `v : Fin 8 → ZMod 2` is a codeword iff `H₈ v = 0`. -/
def extendedHamming8ParityCheck : Matrix (Fin 4) (Fin 8) (ZMod 2) :=
  !![1,1,1,1,1,1,1,1;
     0,0,0,1,1,1,1,0;
     0,1,1,0,0,1,1,0;
     1,0,1,0,1,0,1,0]

/-- The extended `[8,4,4]` Hamming code, defined as the kernel of
`extendedHamming8ParityCheck`. -/
def extendedHamming8 : BinaryLinearCode 8 :=
  LinearMap.ker (Matrix.mulVecLin extendedHamming8ParityCheck)

/-- A binary vector is in `extendedHamming8` iff the parity-check matrix
sends it to zero. -/
theorem mem_extendedHamming8_iff (v : BinaryVector 8) :
    v ∈ extendedHamming8 ↔
      Matrix.mulVec extendedHamming8ParityCheck v = 0 := Iff.rfl

/-! ## Basic code properties -/

/-- The extended Hamming code has exactly 16 codewords. -/
theorem extendedHamming8_card :
    (Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0)).card = 16 := by
  native_decide

/-- Every nonzero codeword of the extended Hamming code has Hamming weight
at least 4. This is the minimum-distance property `d = 4`. -/
theorem extendedHamming8_minWeight (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0)
    (hne : v ≠ 0) : 4 ≤ hammingWeight v := by
  revert hv hne; revert v; native_decide

/-- The extended Hamming code is doubly even: every codeword has weight
divisible by 4. -/
theorem extendedHamming8_doublyEven (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    4 ∣ hammingWeight v := by
  revert hv; revert v; native_decide

/-- Membership in `extendedHamming8` (the `Submodule`) is equivalent to
the parity-check condition. -/
theorem extendedHamming8_mem_iff_mulVec (v : BinaryVector 8) :
    v ∈ extendedHamming8 ↔
      Matrix.mulVec extendedHamming8ParityCheck v = 0 :=
  Iff.rfl

/-- Every codeword of `extendedHamming8` (as a `Submodule`) has weight
divisible by 4. -/
theorem extendedHamming8_doublyEven' (v : BinaryVector 8)
    (hv : v ∈ extendedHamming8) : 4 ∣ hammingWeight v :=
  extendedHamming8_doublyEven v ((extendedHamming8_mem_iff_mulVec v).mp hv)

/-- Every nonzero codeword of `extendedHamming8` (as a `Submodule`) has
Hamming weight at least 4. -/
theorem extendedHamming8_minWeight' (v : BinaryVector 8)
    (hv : v ∈ extendedHamming8) (hne : v ≠ 0) :
    4 ≤ hammingWeight v :=
  extendedHamming8_minWeight v ((extendedHamming8_mem_iff_mulVec v).mp hv) hne

/-! ## Construction A for the extended Hamming code -/

/-- The Construction A additive subgroup of `Z^8` associated to the extended
Hamming code.

This is the preferred neutral name. It records exactly what is proved here:
membership is defined by reduction modulo 2 into `extendedHamming8`. The usual
mathematical identification with E8 still requires structural bridge theorems
such as a Gram matrix, unimodularity, 240 shortest vectors, or an isometry to
another E8 model. -/
def hammingConstructionALattice : AddSubgroup (Fin 8 → ℤ) :=
  constructionA extendedHamming8

/-- Compatibility abbreviation for older downstream theorem names.

Despite the historical name, this declaration should not be read as a proved
E8 identification. Use `hammingConstructionALattice` in new statements unless
the theorem is specifically part of the E8-bridge layer. -/
abbrev e8IntLattice : AddSubgroup (Fin 8 → ℤ) :=
  hammingConstructionALattice

/-- Membership criterion for the Hamming Construction A subgroup: `z` belongs
iff its mod-2 reduction is an extended Hamming codeword. -/
theorem mem_e8IntLattice_iff (z : Fin 8 → ℤ) :
    z ∈ e8IntLattice ↔ reduceModTwo z ∈ extendedHamming8 := Iff.rfl

/-- Equivalent membership criterion via the parity-check matrix. -/
theorem mem_e8IntLattice_iff_parityCheck (z : Fin 8 → ℤ) :
    z ∈ e8IntLattice ↔
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 := Iff.rfl

/-! ## Minimum squared norm -/

/-- Every nonzero vector in the Hamming Construction A subgroup has squared
norm at least `4`.

**Proof strategy**: Split on whether `reduceModTwo z = 0`:
- If yes, all coordinates are even; any nonzero even integer has square `≥ 4`.
- If no, the code has min weight 4, so at least 4 coordinates are odd,
  each contributing `≥ 1` to the squared norm.
-/
theorem e8IntLattice_sqNorm_ge_four (z : Fin 8 → ℤ)
    (hz : z ∈ e8IntLattice) (hne : z ≠ 0) :
    4 ≤ sqNorm z :=
  constructionA_sqNorm_ge_four extendedHamming8
    (fun v hv hvne => extendedHamming8_minWeight' v hv hvne) z hz hne

/-- A specific vector in the Hamming Construction A subgroup with squared norm exactly 4.
The vector `(0,0,0,1,1,1,1,0)` is a weight-4 codeword of the extended Hamming
code; lifting it to `ℤ⁸` gives squared norm `4`. -/
theorem e8IntLattice_achieves_sqNorm_four :
    ∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ z ≠ 0 ∧ sqNorm z = 4 := by
  refine ⟨![0, 0, 0, 1, 1, 1, 1, 0], ?_, ?_, ?_⟩
  · -- membership: reduceModTwo gives a codeword
    change reduceModTwo ![0, 0, 0, 1, 1, 1, 1, 0] ∈ extendedHamming8
    rw [extendedHamming8_mem_iff_mulVec]
    native_decide
  · -- nonzero
    intro h
    have : (![0, 0, 0, 1, 1, 1, 1, 0] : Fin 8 → ℤ) 3 = 0 := congr_fun h 3
    simp at this
  · -- squared norm = 4
    native_decide

/-- The minimum nonzero squared norm of the Hamming Construction A subgroup is
exactly 4.

After the conventional `1 / sqrt 2` scaling this matches the expected E8 root
minimum norm, but this theorem alone does not identify the subgroup as E8. -/
theorem e8IntLattice_minSqNorm :
    (∀ z : Fin 8 → ℤ, z ∈ e8IntLattice → z ≠ 0 → 4 ≤ sqNorm z) ∧
    (∃ z : Fin 8 → ℤ, z ∈ e8IntLattice ∧ z ≠ 0 ∧ sqNorm z = 4) :=
  ⟨e8IntLattice_sqNorm_ge_four, e8IntLattice_achieves_sqNorm_four⟩

end PhysicsSM.Coding
