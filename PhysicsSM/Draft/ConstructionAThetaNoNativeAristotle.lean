import PhysicsSM.Coding.ConstructionAThetaConvolution

/-!
# Aristotle provenance: structural Hamming weight grouping

Aristotle job `38c802a4-5b9d-4637-a6b6-f818f8506452` returned with status
`COMPLETE_WITH_ERRORS`.  The error status came from job-output handling rather
than from this target proof: the extracted file typechecked locally and proved
the requested Hamming weight-grouping lemmas without using a fresh
`n a t i v e _ d e c i d e` enumeration.

The useful declarations have been reviewed and promoted to
`PhysicsSM.Coding.ConstructionAThetaConvolution`:

* `hammingCodewords_filter_weight_card`;
* `hammingCodewords_sum_by_weight_classes`;
* `constructionAShellCount_eq_weight_distribution_convolution_grouped`.

This draft file is intentionally just a provenance wrapper.  Keeping these
aliases here makes the Aristotle result discoverable from the draft root while
ensuring downstream code uses the promoted trusted declarations.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-- Provenance alias for the first theorem returned by Aristotle job
`38c802a4-5b9d-4637-a6b6-f818f8506452`. -/
theorem hammingCodewords_filter_weight_card_aristotle (w : Nat) :
    (hammingCodewords.filter (fun c => hammingWeight c = w)).card =
      extendedHamming8WeightDist w :=
  hammingCodewords_filter_weight_card w

/-- Provenance alias for the structural Hamming weight-grouping theorem
returned by Aristotle job `38c802a4-5b9d-4637-a6b6-f818f8506452`. -/
theorem hammingCodewords_sum_by_weight_classes_aristotle (F : Nat → Nat) :
    hammingCodewords.sum (fun c => F (hammingWeight c)) =
      extendedHamming8WeightDist 0 * F 0 +
      extendedHamming8WeightDist 4 * F 4 +
      extendedHamming8WeightDist 8 * F 8 :=
  hammingCodewords_sum_by_weight_classes F

/-- Provenance alias for the grouped Construction A shell-count theorem
returned by Aristotle job `38c802a4-5b9d-4637-a6b6-f818f8506452`. -/
theorem constructionAShellCount_eq_weight_distribution_convolution_grouped_aristotle
    (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      extendedHamming8WeightDist 0 * weightContribConvolution 0 s +
      extendedHamming8WeightDist 4 * weightContribConvolution 4 s +
      extendedHamming8WeightDist 8 * weightContribConvolution 8 s :=
  constructionAShellCount_eq_weight_distribution_convolution_grouped s

end PhysicsSM.Coding
