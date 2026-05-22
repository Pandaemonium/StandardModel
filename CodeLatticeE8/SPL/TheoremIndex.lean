import CodeLatticeE8.SPL.MainTheorem

/-!
# SPL theorem index

Reviewer-facing index for the optional `CodeLatticeE8SPL` root.

The SPL layer depends only on the standalone package, Mathlib, and
Sphere-Packing-Lean.  It supplies the analytic and Sphere-Packing-Lean bridge
needed to upgrade the standalone Construction A theta-series results to the
full all-coefficient theorem.

## Main theorem chain

* `CodeLatticeE8.SPL.thetaE8_MF`:
  the analytic E8 theta series as a modular form of weight `4`.

* `CodeLatticeE8.SPL.thetaE8_MF_eq_E4`:
  the analytic modular-form identity `Theta_E8 = E4`.

* `CodeLatticeE8.SPL.thetaE8_MF_qExpansion_coeff_eq_e8Shell`:
  q-expansion coefficients of the analytic theta modular form are SPL
  `E8Lattice` shell counts.

* `CodeLatticeE8.SPL.constructionAShellSet_ncard_eq_e8Shell`:
  the Hamming Construction A shell `sqNorm = 4n` has the same cardinality as
  the SPL shell `||w||^2 = 2n`.

* `CodeLatticeE8.SPL.thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff`:
  analytic coefficients equal Hamming Construction A convolution coefficients.

* `CodeLatticeE8.SPL.hammingThetaConvolutionCoeff_eq_e4Coeff`:
  every Hamming Construction A E8 theta coefficient equals the normalized
  Eisenstein coefficient.

* `CodeLatticeE8.SPL.thetaSeries_hammingE8_eq_e4Series`:
  the integer formal Hamming Construction A theta series equals the integer
  formal `E4` series.

## Supporting bridge declarations

* `CodeLatticeE8.SPL.weightContribConvolution`
* `CodeLatticeE8.SPL.hammingThetaConvolutionCoeff`
* `CodeLatticeE8.SPL.thetaSeries`
* `CodeLatticeE8.SPL.e4Series`
* `CodeLatticeE8.SPL.splE4_coeff_eq_e4Coeff`
* `CodeLatticeE8.SPL.intSeriesToComplex_e4Series_eq_splE4`
* `CodeLatticeE8.SPL.constructionAToE8`
* `CodeLatticeE8.SPL.sqNorm_eq_two_mul_norm_sq`
* `CodeLatticeE8.SPL.e8LatticeShell`
-/

private noncomputable abbrev theoremIndexGuard_thetaE8_MF :=
  CodeLatticeE8.SPL.thetaE8_MF
private noncomputable abbrev theoremIndexGuard_thetaE8_MF_eq_E4 :=
  CodeLatticeE8.SPL.thetaE8_MF_eq_E4
private noncomputable abbrev theoremIndexGuard_qExpansion_e8Shell :=
  CodeLatticeE8.SPL.thetaE8_MF_qExpansion_coeff_eq_e8Shell
private noncomputable abbrev theoremIndexGuard_constructionAShell_e8Shell :=
  CodeLatticeE8.SPL.constructionAShellSet_ncard_eq_e8Shell
private noncomputable abbrev theoremIndexGuard_qExpansion_hamming :=
  CodeLatticeE8.SPL.thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff
private noncomputable abbrev theoremIndexGuard_hamming_e4 :=
  CodeLatticeE8.SPL.hammingThetaConvolutionCoeff_eq_e4Coeff
private noncomputable abbrev theoremIndexGuard_thetaSeries_e4 :=
  CodeLatticeE8.SPL.thetaSeries_hammingE8_eq_e4Series
private noncomputable abbrev theoremIndexGuard_weightContribConvolution :=
  CodeLatticeE8.SPL.weightContribConvolution
private noncomputable abbrev theoremIndexGuard_hammingThetaConvolutionCoeff :=
  CodeLatticeE8.SPL.hammingThetaConvolutionCoeff
private noncomputable abbrev theoremIndexGuard_thetaSeries :=
  CodeLatticeE8.SPL.thetaSeries
private noncomputable abbrev theoremIndexGuard_e4Series := CodeLatticeE8.SPL.e4Series
private noncomputable abbrev theoremIndexGuard_splE4_coeff :=
  CodeLatticeE8.SPL.splE4_coeff_eq_e4Coeff
private noncomputable abbrev theoremIndexGuard_e4Series_splE4 :=
  CodeLatticeE8.SPL.intSeriesToComplex_e4Series_eq_splE4
private noncomputable abbrev theoremIndexGuard_constructionAToE8 :=
  CodeLatticeE8.SPL.constructionAToE8
private noncomputable abbrev theoremIndexGuard_sqNorm_norm :=
  CodeLatticeE8.SPL.sqNorm_eq_two_mul_norm_sq
private noncomputable abbrev theoremIndexGuard_e8LatticeShell :=
  CodeLatticeE8.SPL.e8LatticeShell

namespace CodeLatticeE8.SPL

end CodeLatticeE8.SPL
