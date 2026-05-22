import CodeLatticeE8.SPL.CoefficientBridge

/-!
# Theta bridge convenience aliases

This module keeps a few short, discoverable bridge names for downstream files.
The full theorem chain is now closed in `CodeLatticeE8.SPL.CoefficientBridge`
and reexported by `CodeLatticeE8.SPL.MainTheorem`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.SPL

/-- SPL's `E4` q-expansion coefficients match the package's `e4Coeff` function. -/
theorem splE4_coeff_eq_e4Coeff' (n : ℕ) :
    (splE4QExp).coeff n = (Theta.e4Coeff n : ℂ) :=
  splE4_coeff_eq_e4Coeff n

/-- The integer formal `E4` series matches SPL's analytic q-expansion after
coefficientwise casting to `C`. -/
theorem intSeriesToComplex_e4Series_eq_splE4' :
    intSeriesToComplex e4Series = splE4QExp :=
  intSeriesToComplex_e4Series_eq_splE4

/-- Coefficient identity packaged as a formal power-series identity. -/
theorem thetaSeries_eq_e4Series_of_coeff
    (hcount : ∀ n : ℕ, hammingThetaConvolutionCoeff n = Theta.e4Coeff n) :
    thetaSeries = e4Series :=
  thetaSeries_hammingE8_eq_e4Series_of_coeff hcount

end CodeLatticeE8.SPL
