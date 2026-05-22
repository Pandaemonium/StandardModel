import CodeLatticeE8.SPL.CoefficientBridge

/-!
# Main SPL theorem: the Hamming Construction A E8 theta series is `E4`

This is the reviewer-facing aggregation module for the optional SPL layer.
It imports the complete proof chain:

1. `thetaE8_MF_eq_E4` constructs the analytic E8 theta series as a weight-four
   level-one modular form and identifies it with SPL's normalized Eisenstein
   series `E₄`.
2. `thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff` extracts the
   q-expansion coefficients of that analytic modular form and transports the
   shell counts to the Hamming Construction A integer model.
3. `hammingThetaConvolutionCoeff_eq_e4Coeff` proves the all-coefficient formula.
4. `thetaSeries_hammingE8_eq_e4Series` packages the result as an equality of
   integer-valued formal power series.

The standalone `CodeLatticeE8` package remains independent of SPL.  This module
belongs to `CodeLatticeE8SPL`, where the analytic modular-form and
Sphere-Packing-Lean dependencies are available.
-/

namespace CodeLatticeE8.SPL

/-!
The main declarations are imported from the preceding modules:

* `thetaE8_MF`
* `thetaE8_MF_eq_E4`
* `thetaE8_MF_qExpansion_coeff_eq_hammingThetaConvolutionCoeff`
* `hammingThetaConvolutionCoeff_eq_e4Coeff`
* `thetaSeries_hammingE8_eq_e4Series`
-/

end CodeLatticeE8.SPL
