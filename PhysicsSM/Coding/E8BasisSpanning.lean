import Mathlib
import PhysicsSM.Coding.E8Basis

/-!
# Spanning theorem for the E8 Construction A basis

This module proves that the explicit ℤ-basis `e8CodeBasisInt` defined in
`PhysicsSM.Coding.E8Basis` spans the full Hamming Construction A lattice
`hammingConstructionALattice`. Combined with the Gram-matrix determinant
and linear independence, this upgrades "eight good lattice vectors" to a
genuine ℤ-basis.

## Main results

* `basisLinearCombination` — explicit coefficient function expressing any
  lattice vector as a ℤ-linear combination of the basis.
* `e8CodeBasisInt_span_subset` — the ℤ-span of the basis is contained in
  the lattice.
* `e8CodeBasisInt_spans_hammingConstructionALattice` — every lattice vector
  lies in the ℤ-span of the basis.
* `e8CodeBasisGram_det_eq_sixteen_sq` — the Gram determinant 256 = 16²
  equals the square of the lattice index.
* `e8CodeBasis_scaled_gram_det` — after the conventional 1/√2 scaling the
  Gram determinant becomes 1, confirming unimodularity.

## Proof strategy

The coefficient function `basisLinearCombination` is the explicit inverse of
the basis matrix. Coordinates 0–3 are purely linear in `z`; coordinates 4–7
involve integer division by 2. Exactness of the division follows from parity
conditions implied by Hamming code membership, which are verified by
`native_decide` over the 256-element type `BinaryVector 8`.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
- Aristotle job N1 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.unusedSimpArgs false

namespace PhysicsSM.Coding

/-! ## Coefficient function -/

/-- Explicit coefficients for expressing a lattice vector `z` as an integer
linear combination `z = ∑ i, (basisLinearCombination z i) • e8CodeBasisInt i`.

Coordinates 0–3 are purely linear in `z`. Coordinates 4–7 use integer
division by 2, which is exact when `z ∈ hammingConstructionALattice`
(proved in `basisLinearCombination_reconstruction`). -/
def basisLinearCombination (z : Fin 8 → ℤ) : Fin 8 → ℤ :=
  ![z 2,
    -z 1 + z 2 + z 3,
    -z 0 + z 2 + z 3,
    z 0 + z 1 - 2 * z 2 - z 3,
    (z 4 + z 1 - z 2 - z 3) / 2,
    (z 5 + z 0 - z 2 - z 3) / 2,
    (z 6 - z 0 - z 1 + 2 * z 2 + z 3) / 2,
    (z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3) / 2]

/-! ## Parity conditions from Hamming code membership

Each lemma asserts that a specific 4-coordinate parity vanishes for every
codeword. These are linear consequences of the parity-check rows. -/

private theorem hamming_parity_1234 :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 1 + w 2 + w 3 + w 4 = 0 := by native_decide

private theorem hamming_parity_0235 :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 0 + w 2 + w 3 + w 5 = 0 := by native_decide

private theorem hamming_parity_0136 :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 0 + w 1 + w 3 + w 6 = 0 := by native_decide

private theorem hamming_parity_0127 :
    ∀ w : BinaryVector 8,
      Matrix.mulVec extendedHamming8ParityCheck w = 0 →
      w 0 + w 1 + w 2 + w 7 = 0 := by native_decide

/-! ## Divisibility lemmas

The integer divisions by 2 in `basisLinearCombination` are exact for lattice
members. Each follows from a parity condition on the Hamming code. -/

private theorem lattice_div2_coeff4 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 4 + z 1 - z 2 - z 3) := by
      convert hamming_parity_1234 ( reduceModTwo z ) ( by simpa [ mem_e8IntLattice_iff_parityCheck ] using hz ) using 1;
      erw [ ← ZMod.intCast_zmod_eq_zero_iff_dvd ] ; ring_nf;
      simp +decide [ add_comm, add_left_comm, add_assoc, sub_eq_add_neg ]

private theorem lattice_div2_coeff5 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 5 + z 0 - z 2 - z 3) := by
      have h_parity : (z 5 : ZMod 2) + (z 0 : ZMod 2) + (z 2 : ZMod 2) + (z 3 : ZMod 2) = 0 := by
        have h_parity : Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 := by
          convert hz using 1;
        have := hamming_parity_0235 ( reduceModTwo z ) h_parity; simp_all +decide [ add_comm, add_left_comm, add_assoc ] ;
      erw [ ← ZMod.intCast_zmod_eq_zero_iff_dvd ] ; simp_all +decide [ sub_eq_iff_eq_add ] ;
      grind

set_option linter.flexible false in
private theorem lattice_div2_coeff6 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 6 - z 0 - z 1 + 2 * z 2 + z 3) := by
      unfold hammingConstructionALattice at hz; simp_all +decide [ Fin.sum_univ_eight ] ;
      unfold extendedHamming8 at hz; simp_all +decide [ Fin.sum_univ_eight ] ;
      unfold extendedHamming8ParityCheck at hz; simp_all +decide [ Fin.sum_univ_eight, Matrix.mulVec ] ;
      unfold reduceModTwo at *; simp_all +decide [ Fin.sum_univ_eight, Matrix.vecHead, Matrix.vecTail ] ;
      erw [ ← ZMod.intCast_zmod_eq_zero_iff_dvd ] ; norm_num;
      grind

set_option linter.flexible false in
private theorem lattice_div2_coeff7 (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionALattice) :
    2 ∣ (z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3) := by
      have := hz;
      have := mem_e8IntLattice_iff_parityCheck z |>.1 this;
      simp_all +decide [ funext_iff, Fin.forall_fin_succ, Matrix.mulVec, dotProduct ];
      simp_all +decide [ Fin.sum_univ_eight, extendedHamming8ParityCheck ];
      erw [ ← ZMod.intCast_zmod_eq_zero_iff_dvd ] ; norm_num [ this ] ; ring_nf;
      grind

/-! ## Reconstruction theorem -/

/-
The coefficient function reconstructs the original lattice vector:
`z = ∑ i, (basisLinearCombination z i) • e8CodeBasisInt i`.
-/
set_option linter.flexible false in
theorem basisLinearCombination_reconstruction
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionALattice) :
    ∀ j : Fin 8,
      z j = ∑ i : Fin 8, basisLinearCombination z i * e8CodeBasisInt i j := by
  simp +decide [ Fin.sum_univ_eight, basisLinearCombination, e8CodeBasisInt ];
  simp +decide [ Fin.forall_fin_succ ];
  exact ⟨ by ring, by ring, by ring, by linarith [ Int.ediv_mul_cancel ( show 2 ∣ z 4 + z 1 - z 2 - z 3 from lattice_div2_coeff4 z hz ) ], by linarith [ Int.ediv_mul_cancel ( show 2 ∣ z 5 + z 0 - z 2 - z 3 from lattice_div2_coeff5 z hz ) ], by linarith [ Int.ediv_mul_cancel ( show 2 ∣ z 6 - z 0 - z 1 + 2 * z 2 + z 3 from lattice_div2_coeff6 z hz ) ], by linarith [ Int.ediv_mul_cancel ( show 2 ∣ z 7 + z 0 + z 1 - 3 * z 2 - 2 * z 3 from lattice_div2_coeff7 z hz ) ] ⟩

/-! ## Span inclusion (easy direction) -/

/-
Every ℤ-linear combination of the basis vectors lies in the lattice.
This is the easy direction: span ⊆ lattice.
-/
theorem e8CodeBasisInt_span_subset :
    ∀ z, z ∈ Submodule.span ℤ (Set.range e8CodeBasisInt) →
      z ∈ hammingConstructionALattice := by
    intro z hz
    apply Submodule.span_induction at hz
    rotate_left
    · use fun x _ => x ∈ e8IntLattice
    · rintro _ ⟨i, rfl⟩; exact e8CodeBasisInt_mem i
    · exact AddSubgroup.zero_mem _
    · exact fun _ _ _ _ hx' hy' => AddSubgroup.add_mem _ hx' hy'
    · exact fun a _ _ hx' => AddSubgroup.zsmul_mem _ hx' a
    · exact hz

/-! ## Spanning theorem (hard direction) -/

/-
**Main theorem.** Every vector in `hammingConstructionALattice` is an
integer linear combination of `e8CodeBasisInt`.

Together with the linear independence implied by `e8CodeBasisGram_det_pos`,
this establishes `e8CodeBasisInt` as a ℤ-basis of the lattice.
-/
theorem e8CodeBasisInt_spans_hammingConstructionALattice
    (z : Fin 8 → ℤ) (hz : z ∈ hammingConstructionALattice) :
    z ∈ Submodule.span ℤ (Set.range e8CodeBasisInt) := by
      -- By definition of `basisLinearCombination`, we have that `z` can be written as a linear combination of the basis vectors.
      have h_comb : z = ∑ i : Fin 8, basisLinearCombination z i • e8CodeBasisInt i := by
        exact funext fun j => basisLinearCombination_reconstruction z hz j ▸ by simp +decide [Finset.sum_apply]
      exact h_comb.symm ▸ Submodule.sum_mem _ fun i _ => Submodule.smul_mem _ _ ( Submodule.subset_span ( Set.mem_range_self _ ) )

/-! ## Gram-determinant interpretation -/

/-
The Gram determinant 256 equals 16², confirming the sublattice index
`[ℤ⁸ : Λ] = 16`.
-/
theorem e8CodeBasisGram_det_eq_sixteen_sq :
    e8CodeBasisGram.det = 16 ^ 2 :=
  e8CodeBasisGram_det

/-
After the conventional `1/√2` scaling, the Gram matrix becomes `G/2`
and its determinant is `256 / 2⁸ = 1`, confirming unimodularity of the
scaled lattice.
-/
theorem e8CodeBasis_scaled_gram_det :
    (e8CodeBasisGram.det : ℚ) / (2 ^ 8 : ℚ) = 1 := by
  rw [show e8CodeBasisGram.det = 256 from e8CodeBasisGram_det]; norm_num

end PhysicsSM.Coding
