import CodeLatticeE8.E8.ThetaSeries
import CodeLatticeE8.ConstructionA.ThetaLift
import SpherePacking.ModularForms.Lv1Lv2Identities

/-!
# Q-expansion coefficient bridge: SPL E₄ ↔ project coefficients

This module connects SPL's formal `E₄` q-expansion (via `E4_q_exp`) with
the project's local Eisenstein coefficient function `e4Coeff` and the
Hamming Construction A convolution coefficients.

## Main results

* `splE4_coeff_eq_e4Coeff` — SPL's complex q-expansion coefficients of `E₄`
  match the project's natural-number `e4Coeff` function after casting.
* `thetaSeries_hammingE8_eq_e4Series_of_coeff` — if the convolution
  coefficients equal `e4Coeff`, then the integer formal theta series equals the
  integer formal `E₄` series.

## Conventions

The project uses the unscaled integer norm `sqNorm z = ∑ zᵢ²`.  Theta index
`n` corresponds to `sqNorm = 4 * n`.

The Hamming Construction A weight distribution is `(1, 0, 0, 0, 14, 0, 0, 0, 1)`
for weights `(0, 1, 2, 3, 4, 5, 6, 7, 8)`.
-/

set_option linter.style.longLine false

open scoped CongruenceSubgroup ArithmeticFunction

namespace CodeLatticeE8.SPL

/-! ## Unbounded weight-contribution convolution -/

/--
Coefficient formula for the product of one-dimensional lift series.

For a codeword pattern with `w` odd-residue coordinates (and `8 - w` even-residue
coordinates), `weightContribConvolution w s` counts the number of integer
8-tuples whose coordinates individually have the right parity and whose sum of
squares equals `s`.
-/
noncomputable abbrev weightContribConvolution (w s : Nat) : Nat :=
  CodeLatticeE8.weightContribConvolution w s

/--
The Hamming weight-distribution convolution coefficient at theta index `n`.

Combines the three nonzero weight classes of the extended `[8,4,4]` code
(weights `0`, `4`, `8` with multiplicities `1`, `14`, `1`) with the
one-dimensional lift convolution at unscaled shell `4 * n`.
-/
noncomputable def hammingThetaConvolutionCoeff (n : Nat) : Nat :=
  Code.extendedHamming8WeightDist 0 * weightContribConvolution 0 (4 * n) +
  Code.extendedHamming8WeightDist 4 * weightContribConvolution 4 (4 * n) +
  Code.extendedHamming8WeightDist 8 * weightContribConvolution 8 (4 * n)

/-! ## Integer formal power series -/

/--
The integer formal theta series for the Hamming Construction A E8 lattice.

The coefficient of `q^n` is the number of lattice vectors with
`sqNorm = 4 * n`, expressed via the Hamming weight-distribution convolution.
-/
noncomputable def thetaSeries : PowerSeries ℤ :=
  PowerSeries.mk fun n => (hammingThetaConvolutionCoeff n : ℤ)

/--
The integer formal `E₄` Eisenstein series.

This is the standard normalization: constant term `1`, and for `n > 0`
the coefficient is `240 * σ₃(n)`.
-/
noncomputable def e4Series : PowerSeries ℤ :=
  PowerSeries.mk fun n => (Theta.e4Coeff n : ℤ)

/-! ## Complex casting -/

/--
Cast an integer-valued formal power series coefficientwise to a complex-valued
formal power series.
-/
noncomputable def intSeriesToComplex (f : PowerSeries ℤ) : PowerSeries ℂ :=
  PowerSeries.mk fun n => ((PowerSeries.coeff n f : ℤ) : ℂ)

theorem intSeriesToComplex_injective :
    Function.Injective intSeriesToComplex := by
  intro f g hfg
  ext n
  have hcoeff := congrArg (fun p : PowerSeries ℂ => PowerSeries.coeff n p) hfg
  simp only [intSeriesToComplex, PowerSeries.coeff_mk] at hcoeff
  exact Int.cast_injective hcoeff

/-! ## SPL q-expansion targets -/

/-- The SPL q-expansion of the normalized weight-four Eisenstein series `E₄`. -/
noncomputable def splE4QExp : PowerSeries ℂ :=
  ModularFormClass.qExpansion (1 : ℝ) (E₄ : UpperHalfPlane → ℂ)

/--
SPL's `E₄` q-expansion coefficients are exactly the project's `e4Coeff`, after
casting to `ℂ`.
-/
theorem splE4_coeff_eq_e4Coeff (n : ℕ) :
    (splE4QExp).coeff n = (Theta.e4Coeff n : ℂ) := by
  unfold splE4QExp
  have h := congrFun E4_q_exp n
  simp only at h
  rw [h]
  unfold Theta.e4Coeff
  by_cases hn : n = 0
  · subst hn; simp
  · rw [if_neg hn, if_neg hn]
    push_cast; congr 1

/--
The integer formal `E₄` series, after casting to `ℂ`, equals SPL's q-expansion
of `E₄`.
-/
theorem intSeriesToComplex_e4Series_eq_splE4 :
    intSeriesToComplex e4Series = splE4QExp := by
  ext n
  simp only [intSeriesToComplex, PowerSeries.coeff_mk, e4Series]
  rw [splE4_coeff_eq_e4Coeff]
  simp

/-! ## Formal series comparison -/

/--
If the Hamming convolution coefficients agree with the `e4Coeff` function for
all `n`, then the integer formal theta series equals the integer formal `E₄`
series.

This is a pure formal-power-series argument.  The hypothesis is the
all-coefficient identity; the conclusion is the series-level identity.
-/
theorem thetaSeries_hammingE8_eq_e4Series_of_coeff
    (hcount : ∀ n : ℕ, hammingThetaConvolutionCoeff n = Theta.e4Coeff n) :
    thetaSeries = e4Series := by
  ext n
  simp only [thetaSeries, e4Series, PowerSeries.coeff_mk]
  exact congrArg (Int.ofNat ·) (hcount n)

/--
The converse: if the formal series are equal, the coefficients are equal.
-/
theorem coeff_of_thetaSeries_hammingE8_eq_e4Series
    (heq : thetaSeries = e4Series)
    (n : ℕ) : hammingThetaConvolutionCoeff n = Theta.e4Coeff n := by
  have h := congrArg (fun s => PowerSeries.coeff n s) heq
  simp only [thetaSeries, e4Series, PowerSeries.coeff_mk] at h
  exact Nat.cast_injective h

end CodeLatticeE8.SPL
