import CodeLatticeE8.SPL.TheoremIndex

/-!
# CodeLatticeE8SPL

Optional SPL-facing root for the polished Hamming-to-E8 package.

This root imports the `CodeLatticeE8.SPL.*` module cluster, which bridges the
standalone `CodeLatticeE8` package to Sphere-Packing-Lean (`SpherePacking`).
It depends only on the standalone package, Mathlib, and Sphere-Packing-Lean.

## Module structure

* `CodeLatticeE8.SPL.QExpansionBridge`:
  local integer formal power series, the normalized `E4` coefficient function,
  and the coefficientwise cast to SPL's complex q-expansion.

* `CodeLatticeE8.SPL.E8ThetaModular`:
  the analytic E8 theta series as a weight-four level-one modular form, with
  the theorem `thetaE8_MF_eq_E4`.

* `CodeLatticeE8.SPL.BasisBridge` and `CodeLatticeE8.SPL.ShellBridge`:
  the explicit Construction-A-to-SPL lattice bridge and the shell-count
  transport theorem.

* `CodeLatticeE8.SPL.CoefficientBridge`:
  q-expansion extraction and the all-coefficient identity
  `hammingThetaConvolutionCoeff_eq_e4Coeff`.

* `CodeLatticeE8.SPL.MainTheorem`:
  reviewer-facing aggregation of the final theorem chain, including
  `thetaSeries_hammingE8_eq_e4Series`.

## Conventions

The Hamming Construction A integer model uses the unscaled norm
`sqNorm z = sum_i z_i^2`.  Theta coefficient `q^n` corresponds to
`sqNorm z = 4 * n`.  The SPL Euclidean model uses the conventional E8
normalization, so the corresponding shell has squared norm `2 * n`.
-/
