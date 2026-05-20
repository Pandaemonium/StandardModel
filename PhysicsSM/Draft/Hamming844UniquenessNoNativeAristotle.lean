import PhysicsSM.Draft.Hamming844SystematicNoNativeAristotle
import PhysicsSM.Draft.Hamming844PermutationNoNativeAristotle

/-!
# Aristotle target: full Hamming [8,4,4] uniqueness without native_decide

This draft file assembles the non-native uniqueness proof once the two finite
classification bottlenecks have structural replacements:

* `systematic_844_classification_structural`, from
  `Hamming844SystematicNoNativeAristotle`, replacing the 2^16 matrix search.
* `exists_perm_to_first4_constructive`, from
  `Hamming844PermutationNoNativeAristotle`, replacing the information-set
  permutation search.

Aristotle instructions:

* Finish this file after proving `exists_perm_to_first4_constructive`.
* Do not use `systematic_844_classification`.
* Do not use `exists_perm_to_first4`.
* Do not use `native_decide`.
* The final theorem should have the same mathematical statement as
  `extendedHamming8_unique_up_to_equivalence_proof`, but with a proof path
  that avoids both native finite searches.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/--
Structural replacement for `systematic_codeEquiv_hamming`.

The proof is the same Finset-to-submodule bridge as the trusted classifier
uses, but the Finset-level classification comes from
`systematic_844_classification_structural` rather than from
`systematic_844_classification`.
-/
theorem systematic_codeEquiv_hamming_structural
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : forall c : Fin 4 -> ZMod 2,
      c ≠ 0 -> 4 <= hammingWeight (systematicCW P c)) :
    CodeEquivalent (systematicSubmodule P) extendedHamming8 := by
  obtain ⟨sigma, hsigma⟩ := systematic_844_classification_structural P hmin
  refine ⟨sigma, ?_⟩
  ext v
  rw [show (v ∈ permuteCode sigma (systematicSubmodule P)) ↔
      (v ∈ (systematicCodeFinset P).image (permuteBinaryVector sigma)) from
      (mem_image_permute_systematicCodeFinset P sigma v).symm]
  rw [hsigma, mem_extendedHamming8Finset_iff]

/--
No-native target for the full uniqueness theorem.

This has the same statement as `extendedHamming8_unique_up_to_equivalence_proof`,
but its intended dependency chain is:

1. `info_set_exists`
2. `exists_perm_to_first4_constructive`
3. `code_eq_systematic_of_inj_proj`
4. `systematic_codeEquiv_hamming_structural`

None of those steps should call the old native-decide classifiers.
-/
theorem extendedHamming8_unique_up_to_equivalence_no_native
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8 := by
  obtain ⟨I, hI_card, hI_info⟩ := info_set_exists C hC
  obtain ⟨sigma1, hsigma1⟩ := exists_perm_to_first4_constructive I hI_card
  have hC1 : IsLinearCode (permuteCode sigma1 C) 4 4 :=
    CodeEquivalent.isLinearCode ⟨sigma1, rfl⟩ hC
  have hinfo1 : IsInfoSet (permuteCode sigma1 C) {0, 1, 2, 3} := by
    rw [← hsigma1]
    exact isInfoSet_permuteCode C sigma1 I hI_info
  obtain ⟨P, hP_eq, hP_min⟩ :=
    code_eq_systematic_of_inj_proj (permuteCode sigma1 C) hC1 hinfo1
  have hequiv1 : CodeEquivalent C (permuteCode sigma1 C) := ⟨sigma1, rfl⟩
  have hequiv2 : CodeEquivalent (permuteCode sigma1 C) (systematicSubmodule P) :=
    ⟨1, by rw [permuteCode_one]; exact hP_eq⟩
  exact (hequiv1.trans hequiv2).trans
    (systematic_codeEquiv_hamming_structural P hP_min)

end PhysicsSM.Coding
