import CodeLatticeE8.E8.ThetaTable
import CodeLatticeE8.E8.ThetaCoefficients

/-!
# Reviewer-facing theta-series summary for Hamming Construction A E8

This module collects the standalone theta-series statements promoted to the
clean package.

## Promoted results

1. `hammingThetaTableCoeff_eq_e4Coeff_of_le_six`: the finite Hamming
   weight-contribution table agrees with the normalized `E4` coefficients
   through `q^6`.

2. `thetaShellCount_eq_convolution`: the semantic Construction A shell count
   equals the Hamming weight-distribution convolution, for **all** shells.

The finite table check is intentionally separate from the semantic all-shell
convolution theorem below.  The full analytic theorem identifying the unbounded
theta series with `E4` is in the SPL companion package because it needs
analytic modular-form infrastructure and the q-expansion/shell-count bridge.
-/

namespace CodeLatticeE8.E8

open CodeLatticeE8

/--
The promoted finite theta statement: the Hamming weight-convolution
coefficients agree with the normalized `E4` coefficients through `q^6`.
-/
theorem thetaTableCoeff_eq_e4Coeff_of_le_six
    (n : ℕ) (hn : n ≤ 6) :
    hammingThetaTableCoeff n = CodeLatticeE8.Theta.e4Coeff n :=
  hammingThetaTableCoeff_eq_e4Coeff_of_le_six n hn

/--
The promoted all-shell convolution theorem: the semantic Construction A shell
count decomposes as a Hamming weight-distribution convolution.
-/
theorem thetaShellCount_eq_convolution (s : ℕ) :
    Set.ncard (constructionAShellSet s) =
      Code.extendedHamming8WeightDist 0 * weightContribConvolution 0 s +
      Code.extendedHamming8WeightDist 4 * weightContribConvolution 4 s +
      Code.extendedHamming8WeightDist 8 * weightContribConvolution 8 s :=
  constructionAShellCount_eq_weight_distribution_convolution s

end CodeLatticeE8.E8
