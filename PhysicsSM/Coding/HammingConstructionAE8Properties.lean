import Mathlib
import PhysicsSM.Coding.HammingConstructionAE8

/-!
# Publication property package: rank, evenness, and unimodularity

This module provides citation-friendly, s o r r y-free theorem statements for the
three classical lattice-theoretic properties that characterize the E8 lattice
as an *even unimodular lattice* of rank 8.

The three properties, proved here for the concrete Construction A model built
from the extended `[8,4,4]` Hamming code, are:

1. **Full rank (rank 8)**: the Construction A lattice equals the ℤ-span of
   eight explicitly given ℤ-linearly independent vectors.

2. **Scaled evenness**: after the standard `1/√2` normalization, every
   lattice vector has even integer squared norm. In the unscaled integer
   model this amounts to `4 ∣ sqNorm z` for every lattice vector `z`.

3. **Scaled unimodularity**: the Gram matrix of the scaled lattice has
   determinant 1. In the unscaled integer model this amounts to
   `det(e8CodeBasisGram) / 2⁸ = 1` over ℚ.

## Why these three properties matter

By Milnor's 1958 classification theorem, an even unimodular positive-definite
lattice of rank 8 is unique up to isometry, and it is E8. Our Construction A
lattice is therefore *the* E8 lattice — but we state this conclusion
carefully, as the classification theorem itself is not yet formalized in Lean.
The present module provides the three properties without invoking
classification.

Formally, the lattice `Λ(C)` (Construction A from a binary code `C`) is
even unimodular if and only if `C` is doubly even and self-dual. Both
properties have been proved for `extendedHamming8` in this repository:
- `extendedHamming8_doublyEven'` — every codeword has weight divisible by 4.
- `extendedHamming8_selfDual` — the code equals its own dual.

The present module packages the consequences for the lattice.

## Claim boundary

These results identify the Construction A model as an even unimodular lattice
of rank 8. They do **not**:
- Invoke or prove Milnor's classification of even unimodular lattices.
- Prove that the lattice is isometric to E8 (that would require the classification).
- Make any claims about sphere-packing density.

The `hammingConstructionA_publication_property_package` theorem is intended
as a single-theorem citation target for publication use.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7 (Construction A),
  Ch. 8 (classification of even unimodular lattices, rank 8 uniqueness).
- Milnor, "On the relation between differentiable manifolds and simply
  connected four-dimensional manifolds", Ann. Math. 64 (1956), for the
  uniqueness theorem (invoked by name but not formalized here).
- Aristotle job P2 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding.HammingConstructionAE8Properties

open PhysicsSM.Coding

/-! ## Full rank / rank 8

The Construction A lattice for the extended Hamming code is a full-rank
sublattice of ℤ⁸: it spans ℝ⁸ and has rank 8. We prove this concretely
using the explicit basis `e8CodeBasisInt` from `E8Basis.lean`.

The two components of full rank are:
- **Spanning**: every lattice vector is an integer linear combination of the
  basis vectors. This uses `e8CodeBasisInt_spans_hammingConstructionALattice`.
- **Linear independence**: the Gram matrix `e8CodeBasisGram` has positive
  determinant (256 > 0), which implies the basis vectors are ℤ-linearly
  independent by the theory of Gram matrices.
-/

/-- **Full rank (rank 8).** The Hamming Construction A lattice equals the
ℤ-span of the eight vectors `e8CodeBasisInt 0, …, e8CodeBasisInt 7`, and the
Gram determinant `det(e8CodeBasisGram) = 256 > 0` witnesses ℤ-linear
independence.

Together these two facts express that the lattice has rank exactly 8:
it is not contained in any proper subgroup of ℤ⁸, and its eight given
generators are independent.
-/
theorem hammingConstructionA_fullRank_by_e8CodeBasisInt :
    (∀ z : Fin 8 → ℤ, z ∈ hammingConstructionALattice ↔
      z ∈ Submodule.span ℤ (Set.range e8CodeBasisInt)) ∧
    (0 < e8CodeBasisGram.det) :=
  ⟨fun z => ⟨e8CodeBasisInt_spans_hammingConstructionALattice z,
             e8CodeBasisInt_span_subset z⟩,
   e8CodeBasisGram_det_pos⟩

/-! ## Scaled evenness

An integer lattice Λ ⊆ ℤⁿ is *even* (in the scaled sense) when, after the
`1/√2` normalization, every vector has integer squared norm divisible by 2.
In the unscaled integer model, this is equivalent to `4 ∣ sqNorm z` for all
`z ∈ Λ`.

The source of this divisibility is the doubly-even property of the code:
every codeword has weight divisible by 4. For a vector `z ∈ Λ(C)`:
- If `reduceModTwo z = 0`: all coordinates of `z` are even, so each `zᵢ²` is
  divisible by 4.
- If `reduceModTwo z ≠ 0`: the codeword has weight divisible by 4, contributing
  an odd number of ±1 contributions to `sqNorm z mod 4` equal to 0.

This is the concrete content of `hammingConstructionALattice_sqNorm_dvd_four`
from `ConstructionALatticeProperties.lean`, which is used here directly.
-/

/-- **Scaled evenness.** Every vector in the Hamming Construction A lattice
has unscaled squared norm divisible by 4.

Equivalently, after the `1/√2` scaling the squared norm
`⟨v, v⟩ = (∑ zᵢ²)/2` is an *even* integer, i.e. lies in `2ℤ`.

This is the concrete form of the statement "the lattice Λ(C)/√2 is even"
for the doubly-even code `C = extendedHamming8`. -/
theorem hammingConstructionA_scaled_even
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionALattice) :
    ∃ m : ℤ, sqNorm z = 4 * m :=
  hammingConstructionALattice_sqNorm_dvd_four z hz

/-! ## Scaled unimodularity

A lattice Λ with an explicit basis `b₀, …, b₇` is *unimodular* when the
Gram matrix `G[i,j] = ⟨bᵢ, bⱼ⟩` has determinant ±1. For the E8 lattice
in the standard normalization (root squared norm 2), the Gram matrix is the
E8 Cartan matrix with `det = 1`.

Our Construction A model uses integer coordinates with minimum squared norm 4
(root squared norm 2 after `1/√2` scaling). The unscaled Gram matrix
`e8CodeBasisGram` therefore has all entries twice the scaled values, and
`det(e8CodeBasisGram) = 2⁸ · det(scaled Gram) = 256 · 1 = 256`.

Equivalently, `det(e8CodeBasisGram) / 2⁸ = 1` over ℚ, which is
`e8CodeBasis_scaled_gram_det` from `HammingConstructionAE8.lean`.
-/

/-- **Scaled unimodularity.** The Gram determinant of `e8CodeBasisInt`,
after dividing by `2⁸` to account for the `1/√2` scaling on all 8 basis
vectors, equals 1 over ℚ.

Geometric interpretation: the scaled lattice `e8IntLattice / √2` has
covolume 1 in ℝ⁸ with the standard Euclidean metric. This means the lattice
equals its own dual lattice (it is self-dual). -/
theorem hammingConstructionA_scaled_unimodular :
    (e8CodeBasisGram.det : ℚ) / (2 ^ 8 : ℚ) = 1 :=
  e8CodeBasis_scaled_gram_det

/-! ## Combined publication property package

The three properties above together certify that the Hamming Construction A
lattice is an even unimodular lattice of rank 8. By Milnor's classification
(not yet formalized in Lean), this uniquely identifies it as E8.

The `hammingConstructionA_publication_property_package` theorem is intended
as a convenient single-citation theorem in the publication. Each component
is proved elsewhere in the repo and assembled here.
-/

/-- **Publication property package for the Hamming Construction A E8 lattice.**

The Construction A lattice from the extended `[8,4,4]` Hamming code is:

1. **Rank 8**: it equals the ℤ-span of 8 linearly independent vectors
   (witnessed by `e8CodeBasisInt` and positive Gram determinant).

2. **Even (after `1/√2` scaling)**: every vector has scaled squared norm
   in `2ℤ`, equivalently `4 ∣ sqNorm z` in the integer model.

3. **Unimodular (after `1/√2` scaling)**: the scaled Gram determinant is 1,
   equivalently `det(e8CodeBasisGram) / 2⁸ = 1` over ℚ.

These are the three defining properties of an even unimodular lattice of
rank 8, proved here without invoking the uniqueness classification theorem.

By Milnor (1958), any even unimodular positive-definite lattice of rank 8 is
isometric to E8. The present module supplies the lattice-theoretic hypothesis
for that conclusion; the classification itself is not yet in Lean. -/
theorem hammingConstructionA_publication_property_package :
    -- (1) Full rank: Λ = span(e8CodeBasisInt), with positive Gram determinant
    ((∀ z : Fin 8 → ℤ, z ∈ hammingConstructionALattice ↔
        z ∈ Submodule.span ℤ (Set.range e8CodeBasisInt)) ∧
      0 < e8CodeBasisGram.det) ∧
    -- (2) Evenness: 4 | sqNorm(z) for all z ∈ Λ
    (∀ z : Fin 8 → ℤ, z ∈ hammingConstructionALattice → (4 : ℤ) ∣ sqNorm z) ∧
    -- (3) Unimodularity: scaled Gram determinant = 1 over ℚ
    ((e8CodeBasisGram.det : ℚ) / (2 ^ 8 : ℚ) = 1) :=
  ⟨hammingConstructionA_fullRank_by_e8CodeBasisInt,
   hammingConstructionALattice_sqNorm_dvd_four,
   hammingConstructionA_scaled_unimodular⟩

end PhysicsSM.Coding.HammingConstructionAE8Properties
