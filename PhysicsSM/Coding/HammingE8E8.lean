import PhysicsSM.Coding.HammingSelfDual
import PhysicsSM.Coding.E8ThetaSeries
import PhysicsSM.Coding.HammingE8E8Helpers

/-!
# E8 × E8: the 16-dimensional gauge lattice from two Hamming codes

This module constructs the `[16, 8, 4]` binary code `hamming16E8E8` as the
direct sum of two copies of the extended `[8,4,4]` Hamming code, and begins
the development of its Construction A lattice as the E8 ⊕ E8 gauge lattice.

## Mathematical content

The code `hamming16E8E8` consists of all binary vectors `v : BinaryVector 16`
whose first 8 coordinates lie in `extendedHamming8` and whose last 8 coordinates
also lie in `extendedHamming8`.

Draft status: this file is a frontier module and is not part of the trusted
theorem index yet. It still contains proof handoffs for self-duality and the
structural 480-minimal-vector theorem.

It is expected to be:

- **Type II** (self-dual and doubly even), because each factor is Type II
  and the direct sum of two Type II codes is Type II.
- **Rank 8 + 8 = 16** as an F₂-vector space.
- **16-dimensional**: its Construction A lattice lives in ℤ¹⁶.

The Construction A lattice of `hamming16E8E8` is isomorphic to
`e8IntLattice × e8IntLattice` (the product of two E8 integer lattices).
Its minimal vectors in the unscaled model have squared norm 4 and there
are exactly **480 = 2 × 240** of them.

## Role in string theory

In the E8×E8 heterotic string, the left-moving internal 16 bosonic dimensions
are compactified on the E8⊕E8 root lattice (rank 16, even, self-dual).
This file provides the formal lattice built from coding theory.
The physics conclusions are in `PhysicsSM.Draft.HeteroticAnomalyFromHamming`.

**Important**: E8⊕E8 here is the positive-definite 16D gauge lattice, NOT
a Lorentzian Narain lattice. After toroidal compactification on T^d, the full
Narain lattice has signature (d+16, d).

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7.
- Mizoguchi-Oikawa, arXiv:2602.16269, App. (Hamming → E8 → heterotic).
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Coordinate projections for Fin 16 → Fin 8 + Fin 8 -/

/-- Project a 16-bit binary vector onto its **left** 8 coordinates (positions 0–7). -/
def projLeft16 (v : BinaryVector 16) : BinaryVector 8 :=
  fun i => v ⟨i.val, by omega⟩

/-- Project a 16-bit binary vector onto its **right** 8 coordinates (positions 8–15). -/
def projRight16 (v : BinaryVector 16) : BinaryVector 8 :=
  fun i => v ⟨8 + i.val, by omega⟩

/-- Reassemble a 16-bit vector from two 8-bit halves. -/
def joinVec16 (u v : BinaryVector 8) : BinaryVector 16 :=
  fun i => if h : i.val < 8 then u ⟨i.val, h⟩ else v ⟨i.val - 8, by omega⟩

@[simp] theorem projLeft16_apply (v : BinaryVector 16) (i : Fin 8) :
    projLeft16 v i = v ⟨i.val, by omega⟩ := rfl
@[simp] theorem projRight16_apply (v : BinaryVector 16) (i : Fin 8) :
    projRight16 v i = v ⟨8 + i.val, by omega⟩ := rfl
@[simp] theorem projLeft16_zero : projLeft16 (0 : BinaryVector 16) = 0 := by ext; simp [projLeft16]
@[simp] theorem projRight16_zero : projRight16 (0 : BinaryVector 16) = 0 := by ext; simp [projRight16]

theorem projLeft16_add (u v : BinaryVector 16) :
    projLeft16 (u + v) = projLeft16 u + projLeft16 v := by ext; simp [projLeft16, Pi.add_apply]
theorem projRight16_add (u v : BinaryVector 16) :
    projRight16 (u + v) = projRight16 u + projRight16 v := by ext; simp [projRight16, Pi.add_apply]

/-- The left and right projections are left-inverses of `joinVec16`. -/
@[simp] theorem projLeft16_joinVec16 (u v : BinaryVector 8) : projLeft16 (joinVec16 u v) = u := by
  ext i; simp [projLeft16, joinVec16, i.isLt]
@[simp] theorem projRight16_joinVec16 (u v : BinaryVector 8) : projRight16 (joinVec16 u v) = v := by
  ext i; simp [projRight16, joinVec16]

/-! ## Direct sum of binary linear codes -/

/-- The **direct sum** of two binary linear codes of length 8.

A vector `v : BinaryVector 16` is in `directSumCode C₁ C₂` iff its first 8
coordinates are a codeword of `C₁` and its last 8 coordinates are a codeword
of `C₂`. This is the standard code direct sum `C₁ × C₂ ⊆ F₂⁸ × F₂⁸ = F₂¹⁶`.
-/
def directSumCode (C₁ C₂ : BinaryLinearCode 8) : BinaryLinearCode 16 where
  carrier := { v | projLeft16 v ∈ C₁ ∧ projRight16 v ∈ C₂ }
  zero_mem' := ⟨by simp [C₁.zero_mem], by simp [C₂.zero_mem]⟩
  add_mem'  {u v} hu hv :=
    ⟨by rw [projLeft16_add];  exact C₁.add_mem hu.1 hv.1,
     by rw [projRight16_add]; exact C₂.add_mem hu.2 hv.2⟩
  smul_mem' c v hv :=
    ⟨by simpa [projLeft16, Pi.smul_apply] using C₁.smul_mem c hv.1,
     by simpa [projRight16, Pi.smul_apply] using C₂.smul_mem c hv.2⟩

@[simp]
theorem mem_directSumCode_iff (C₁ C₂ : BinaryLinearCode 8) (v : BinaryVector 16) :
    v ∈ directSumCode C₁ C₂ ↔ projLeft16 v ∈ C₁ ∧ projRight16 v ∈ C₂ := Iff.rfl

/-! ## The 16-bit Hamming code -/

/-- The direct sum of two copies of the extended `[8,4,4]` Hamming code,
giving a `[16, 8, 4]` Type II code.

This is the unique (up to equivalence) even self-dual binary code of length 16
that produces the E8⊕E8 lattice via Construction A. -/
def hamming16E8E8 : BinaryLinearCode 16 :=
  directSumCode extendedHamming8 extendedHamming8

@[simp]
theorem mem_hamming16E8E8_iff (v : BinaryVector 16) :
    v ∈ hamming16E8E8 ↔
    projLeft16 v ∈ extendedHamming8 ∧ projRight16 v ∈ extendedHamming8 := Iff.rfl

/-! ## Doubly-even property

A codeword of `C₁ ⊕ C₂` has Hamming weight equal to the sum of the weights
of its two halves. Since each factor is doubly even, the sum is divisible by 4.
-/

/-- The Hamming weight of a 16-bit vector is the sum of its two 8-bit halves' weights.

Proved by partitioning `Fin 16` into positions 0–7 and 8–15, establishing
a bijection with `Fin 8` for each half. -/
theorem hammingWeight_directSum16 (v : BinaryVector 16) :
    hammingWeight v =
      hammingWeight (projLeft16 v) + hammingWeight (projRight16 v) := by
  -- Aristotle job 6b24bf9e proved this as a pure `Fin.sum_univ_add`
  -- reindexing.  Keeping the proof in the helper file avoids importing this
  -- frontier module while proving the foundational split.
  exact hammingWeight_split16 v

/-- `hamming16E8E8` is doubly even: every codeword has Hamming weight divisible by 4.

Proof: by `hammingWeight_directSum16`, the weight equals the sum of the weights
of the two 8-bit halves. Each is a codeword of `extendedHamming8` (doubly even),
so each weight is divisible by 4 and their sum is also divisible by 4. -/
theorem hamming16E8E8_doublyEven (v : BinaryVector 16)
    (hv : v ∈ hamming16E8E8) : 4 ∣ hammingWeight v := by
  rw [hammingWeight_directSum16]
  exact Dvd.dvd.add
    (extendedHamming8_doublyEven' _ hv.1)
    (extendedHamming8_doublyEven' _ hv.2)

/-! ## Self-duality and Type II

The direct sum of two self-dual codes is self-dual:
`(C₁ ⊕ C₂)⊥ = C₁⊥ ⊕ C₂⊥`. Since each factor is self-dual, the direct sum is too.

The binaryDot product splits: `dot(v, w) = dot(left v, left w) + dot(right v, right w)`.
This is the key algebraic fact; a full Lean proof is an Aristotle target below.
-/

/-- The `binaryDot` of two 16-bit vectors splits into the sum of the `binaryDot`
products of their 8-bit halves. -/
theorem binaryDot16_split (v w : BinaryVector 16) :
    binaryDot v w =
      binaryDot (projLeft16 v) (projLeft16 w) +
      binaryDot (projRight16 v) (projRight16 w) := by
  -- As with the weight split, this is ordinary finite-sum reindexing rather
  -- than a truth-table or `native_decide` computation.
  exact binaryDot_split16 v w

/-- Self-orthogonality of `hamming16E8E8`: any two codewords have zero `binaryDot`.

Proof: by `binaryDot16_split`, the dot product equals the sum of the dot
products of the two halves. Each half is a pair of codewords of `extendedHamming8`
(which is self-orthogonal), so each term vanishes. -/
theorem hamming16E8E8_selfOrthogonal (v w : BinaryVector 16)
    (hv : v ∈ hamming16E8E8) (hw : w ∈ hamming16E8E8) :
    binaryDot v w = 0 := by
  rw [binaryDot16_split]
  have hl := extendedHamming8_selfOrthogonal _ _ hv.1 hw.1
  have hr := extendedHamming8_selfOrthogonal _ _ hv.2 hw.2
  simp [hl, hr]

/-- If a length-16 vector is orthogonal to every word of `hamming16E8E8`,
then its left half is orthogonal to every word of `extendedHamming8`.

The test words are `joinVec16 u 0`: a codeword in the left copy and the zero
word in the right copy.  The dot-product split discards the zero right half and
leaves the desired left-half orthogonality condition. -/
private theorem projLeft16_mem_dual_of_mem_dual_hamming16
    (v : BinaryVector 16)
    (hv : ∀ w ∈ hamming16E8E8, binaryDot v w = 0) :
    ∀ u ∈ extendedHamming8, binaryDot (projLeft16 v) u = 0 := by
  intro u hu
  convert hv (joinVec16 u 0) _ using 1
  exact ⟨hu, by simp⟩

/-- If a length-16 vector is orthogonal to every word of `hamming16E8E8`,
then its right half is orthogonal to every word of `extendedHamming8`.

This is the symmetric test against `joinVec16 0 u`. -/
private theorem projRight16_mem_dual_of_mem_dual_hamming16
    (v : BinaryVector 16)
    (hv : ∀ w ∈ hamming16E8E8, binaryDot v w = 0) :
    ∀ u ∈ extendedHamming8, binaryDot (projRight16 v) u = 0 := by
  intro u hu
  have h_w : joinVec16 0 u ∈ hamming16E8E8 := by
    exact ⟨by simp, hu⟩
  have h_dot : binaryDot v (joinVec16 0 u) = binaryDot (projRight16 v) u := by
    convert binaryDot16_split v (joinVec16 0 u) using 1
    simp
  rw [← h_dot, hv _ h_w]

/-- `hamming16E8E8` is self-dual.

The forward inclusion is self-orthogonality.  The reverse inclusion uses the
two test families `joinVec16 u 0` and `joinVec16 0 u`: if a length-16 vector is
orthogonal to the whole direct-sum code, then each 8-coordinate half is
orthogonal to every word of the corresponding `extendedHamming8` factor.  The
self-duality theorem for `extendedHamming8` then puts both halves back in the
factor code.
-/
theorem hamming16E8E8_selfDual : IsSelfDual hamming16E8E8 := by
  apply le_antisymm
  · -- hamming16E8E8 ⊆ dualCode hamming16E8E8
    intro v hv
    rw [mem_dualCode_iff]
    intro w hw
    exact hamming16E8E8_selfOrthogonal v w hv hw
  · -- dualCode hamming16E8E8 ⊆ hamming16E8E8
    intro v hv
    rw [mem_hamming16E8E8_iff]
    have hv' : ∀ w ∈ hamming16E8E8, binaryDot v w = 0 := hv
    exact
      ⟨extendedHamming8_dual_le
          (projLeft16_mem_dual_of_mem_dual_hamming16 v hv'),
       extendedHamming8_dual_le
          (projRight16_mem_dual_of_mem_dual_hamming16 v hv')⟩

/-- `hamming16E8E8` is Type II (self-dual and doubly even). -/
theorem hamming16E8E8_typeII : IsTypeII hamming16E8E8 :=
  ⟨hamming16E8E8_selfDual, hamming16E8E8_doublyEven⟩

/-! ## Minimal vectors: 480 = 2 × 240

The minimal vectors of the Construction A lattice of `hamming16E8E8` have
unscaled squared norm 4. There are 480 of them: 240 from the first E8 factor
(paired with zero on the right) and 240 from the second E8 factor (paired
with zero on the left).

Important implementation note: do not verify this by a direct `native_decide`
over a 16-dimensional coordinate box. The useful proof is structural: a
minimal vector in an orthogonal product has one E8 component of norm 4 and the
other component zero, giving `240 + 240 = 480`.
-/

/-- There are exactly **480** minimal vectors (squared norm 4) in the
Construction A lattice of `hamming16E8E8`.

Proof handoff: prove this structurally from the E8 shell count
`e8ShellCount_four = 240`, not by exhaustive 16-dimensional enumeration.

The 480 split as 240+240:
- 240 vectors with nonzero only in positions 0–7 (first E8 factor)
- 240 vectors with nonzero only in positions 8–15 (second E8 factor) -/
theorem hamming16_minimal_vectors_card :
    (Finset.univ.filter (fun fg : (Fin 8 → Fin 5) × (Fin 8 → Fin 5) =>
      let v₁ := fun i => coordVals5 (fg.1 i)
      let v₂ := fun i => coordVals5 (fg.2 i)
      sqNorm v₁ + sqNorm v₂ = 4 ∧
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v₁) = 0 ∧
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo v₂) = 0)).card = 480 := by
  exact hamming16_480_structural

/-! ## Construction A isomorphism (Aristotle target) -/

/-- The lattice embedding: pair two 8-dimensional integer vectors into a
16-dimensional vector by concatenation. -/
def joinLattice16 (p : (Fin 8 → ℤ) × (Fin 8 → ℤ)) : Fin 16 → ℤ :=
  fun i => if h : i.val < 8 then p.1 ⟨i.val, h⟩ else p.2 ⟨i.val - 8, by omega⟩

/-- Every pair `(z₁, z₂)` with `z₁, z₂ ∈ e8IntLattice` gives a vector
in the Construction A lattice of `hamming16E8E8`.

This is the forward direction of the isomorphism. -/
theorem mem_constructionA_hamming16_of_product (z₁ z₂ : Fin 8 → ℤ)
    (h₁ : z₁ ∈ e8IntLattice) (h₂ : z₂ ∈ e8IntLattice) :
    joinLattice16 (z₁, z₂) ∈ constructionA hamming16E8E8 := by
  rw [mem_constructionA_iff, mem_hamming16E8E8_iff]
  -- Left half: projLeft16 (reduceModTwo (joinLattice16 (z₁, z₂))) = reduceModTwo z₁
  have heq_l : projLeft16 (reduceModTwo (joinLattice16 (z₁, z₂))) = reduceModTwo z₁ := by
    ext i; simp [projLeft16, reduceModTwo, joinLattice16, i.isLt]
  -- Right half: projRight16 (reduceModTwo (joinLattice16 (z₁, z₂))) = reduceModTwo z₂
  have heq_r : projRight16 (reduceModTwo (joinLattice16 (z₁, z₂))) = reduceModTwo z₂ := by
    ext i; simp [projRight16, reduceModTwo, joinLattice16]
  exact ⟨heq_l ▸ (mem_e8IntLattice_iff z₁).mp h₁,
         heq_r ▸ (mem_e8IntLattice_iff z₂).mp h₂⟩

/-!
### Aristotle handoff: full Construction A isomorphism

**Target**:
```lean
noncomputable def constructionA_hamming16_equiv :
    constructionA hamming16E8E8 ≃+ e8IntLattice × e8IntLattice
```

**Forward map** (done above): `z ↦ (projLeft16 z, projRight16 z)`

**Proof that forward map lands in `e8IntLattice × e8IntLattice`**:
For `z ∈ constructionA hamming16E8E8`, we have
`projLeft16 (reduceModTwo z) ∈ extendedHamming8`, which means
`projLeft16 z ∈ e8IntLattice` (because `e8IntLattice = constructionA extendedHamming8`
and `reduceModTwo (projLeft16 z) = projLeft16 (reduceModTwo z)`). Similarly right.

**Key lemma needed**:
```lean
theorem projLeft16_reduceModTwo_comm (z : Fin 16 → ℤ) :
    reduceModTwo (projLeft16 z) = projLeft16 (reduceModTwo z)
```

**Bijectivity**: joinLattice16 and (projLeft16, projRight16) are mutual inverses.
-/

end PhysicsSM.Coding
