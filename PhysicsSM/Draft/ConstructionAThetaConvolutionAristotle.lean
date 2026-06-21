import PhysicsSM.Coding.ConstructionAThetaConvolution

/-!
# Aristotle integration: Construction A theta convolution

This draft wrapper records the result of Aristotle job
`1bbfa658-04ab-427e-9402-c42653ac88a5` from 2026-05-15.

The useful proof has now been promoted into the trusted source module
`PhysicsSM.Coding.ConstructionAThetaConvolution`.  The promoted version reuses
the existing definitions from `PhysicsSM.Coding.ConstructionAThetaWeightBridge`
instead of keeping the local copies that appeared in the raw Aristotle output.

What was integrated:

* `residueShellCount_eq_weightContribConvolution`: a residue shell is counted
  by the product-of-sums convolution determined by the Hamming weight of the
  residue;
* `constructionAShellCount_eq_codeword_convolution`: the Construction A shell
  count is the sum of those residue contributions over Hamming codewords;
* `constructionAShellCount_eq_weight_distribution_convolution`: the same count
  collapses to the three Hamming weight classes `0`, `4`, and `8`.

Trust note: the partition and fiber-counting statements are kernel-checked
ordinary Lean proofs.  The final grouping into Hamming weight classes still
uses a small finite `n a t i v e _ d e c i d e` certificate saying that every extended
Hamming `[8,4,4]` codeword has weight `0`, `4`, or `8`.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-- Job-E wrapper for the integrated residue-shell convolution theorem. -/
theorem residueShellCount_eq_weightContribConvolution_aristotle
    (c : BinaryVector 8) (s : Nat) :
    Set.ncard (residueShellSet c s) =
      weightContribConvolution (hammingWeight c) s :=
  residueShellCount_eq_weightContribConvolution c s

/-- Job-E wrapper for the integrated codeword-sum convolution theorem. -/
theorem constructionAShellCount_eq_codeword_convolution_aristotle (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      hammingCodewords.sum
        (fun c => weightContribConvolution (hammingWeight c) s) :=
  constructionAShellCount_eq_codeword_convolution s

/-- Job-E wrapper for the integrated Hamming weight-distribution convolution. -/
theorem constructionAShellCount_eq_weight_distribution_convolution_aristotle
    (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      extendedHamming8WeightDist 0 * weightContribConvolution 0 s +
      extendedHamming8WeightDist 4 * weightContribConvolution 4 s +
      extendedHamming8WeightDist 8 * weightContribConvolution 8 s :=
  constructionAShellCount_eq_weight_distribution_convolution s

end PhysicsSM.Coding
