import PhysicsSM.Coding.ConstructionAThetaConvolution
import PhysicsSM.Coding.E8ThetaSigmaBridge
import PhysicsSM.Draft.E8ThetaModularAristotle
import SpherePacking.ModularForms.Lv1Lv2Identities

/-!
# SPL bridge for the E8 theta-series identity

This draft module records the shortest currently visible route from the
project's formal Construction A theta series to the `E₄` theorem already proved
in Sphere-Packing-Lean (SPL).

The important SPL fact is:

* `SpherePacking.ModularForms.E₄_eq_thetaE4`

where `thetaE4 = H₂ ^ 2 + H₂ * H₄ + H₄ ^ 2`.  In SPL's conventions the
functions `H₂`, `H₃`, and `H₄` are fourth powers of Jacobi theta constants, so
this is the usual eighth-power theta identity after applying Jacobi's identity.

What this file proves:

1. The project's local formal Eisenstein series `e4Series`, after casting
   coefficients from `Int` to `Complex`, is exactly the SPL q-expansion of `E₄`.
2. The project's local theta coefficients are exactly the Hamming
   weight-distribution convolution already proved in
   `PhysicsSM.Coding.ConstructionAThetaConvolution`.
3. Therefore the remaining bridge needed for the full theorem is a single
   coefficient statement:

   `coeff n (qExpansion thetaE4) =
     extendedHamming8WeightDist 0 * weightContribConvolution 0 (4*n)
   + extendedHamming8WeightDist 4 * weightContribConvolution 4 (4*n)
   + extendedHamming8WeightDist 8 * weightContribConvolution 8 (4*n)`.

That remaining statement is deliberately isolated in
`thetaSeries_eq_e4Series_of_spl_theta_coeff_bridge`, so Aristotle can attack the
Construction A / Jacobi-theta coefficient bridge without also rediscovering
SPL's modular-form argument.

This file is draft-facing because it imports SPL directly.  The default
`PhysicsSM` root stays independent of SPL.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false

open ModularFormClass

namespace PhysicsSM.Coding
namespace E8ThetaSPLBridge

/-! ## Complexification of integer formal power series -/

/--
Cast an integer-valued formal power series coefficientwise to a complex-valued
formal power series.

This intentionally uses `PowerSeries.mk` rather than any heavier algebraic
`map` API: for the theta/Eisenstein comparison we only need transparent
coefficient control.
-/
noncomputable def intSeriesToComplex (f : PowerSeries Int) : PowerSeries Complex :=
  PowerSeries.mk fun n => ((PowerSeries.coeff n f : Int) : Complex)

/--
Coefficientwise casting from `Int` to `Complex` is injective for formal power
series.  This lets us prove an integer series identity by proving the
corresponding complex coefficient identity.
-/
theorem intSeriesToComplex_injective :
    Function.Injective intSeriesToComplex := by
  intro f g hfg
  ext n
  have hcoeff := congrArg (fun p : PowerSeries Complex => PowerSeries.coeff n p) hfg
  simp only [intSeriesToComplex, PowerSeries.coeff_mk] at hcoeff
  exact Int.cast_injective hcoeff

/-- The project theta series, viewed over `Complex`. -/
noncomputable def localThetaSeriesComplex : PowerSeries Complex :=
  intSeriesToComplex E8ThetaAristotle.thetaSeries

/-- The project `E₄` q-series, viewed over `Complex`. -/
noncomputable def localE4SeriesComplex : PowerSeries Complex :=
  intSeriesToComplex E8ThetaAristotle.e4Series

/-! ## SPL q-expansion targets -/

/-- The SPL q-expansion of the normalized weight-four Eisenstein series. -/
noncomputable def splE4Series : PowerSeries Complex :=
  qExpansion (1 : Real) (E₄ : UpperHalfPlane -> Complex)

/-- The SPL q-expansion of the theta-polynomial `H₂^2 + H₂*H₄ + H₄^2`. -/
noncomputable def splThetaE4Series : PowerSeries Complex :=
  qExpansion (1 : Real) SpherePacking.ModularForms.thetaE4

/--
SPL proves the analytic identity `E₄ = thetaE4`; therefore their q-expansions
are definitionally the same after rewriting the underlying function.
-/
theorem splE4Series_eq_splThetaE4Series :
    splE4Series = splThetaE4Series := by
  unfold splE4Series splThetaE4Series
  rw [SpherePacking.ModularForms.E₄_eq_thetaE4]

/-- SPL's explicit q-expansion formula for `E₄`, restated through `splE4Series`. -/
theorem splE4Series_coeff (n : Nat) :
    PowerSeries.coeff n splE4Series =
      if n = 0 then 1 else (240 : Complex) * (ArithmeticFunction.sigma 3 n : Complex) := by
  simpa [splE4Series] using congrFun E4_q_exp n

/--
SPL's theta-polynomial has the Eisenstein `E₄` q-expansion coefficients.

This is the main useful theorem returned by Aristotle job
`9215f082-2baa-4e13-837c-9335ddf88aad`: SPL already proves the analytic
identity `E₄ = thetaE4`, so the q-expansion coefficients of `thetaE4` are the
standard divisor-sum coefficients of `E₄`.  The remaining project-specific
work is therefore only to connect our Hamming/Construction A convolution
coefficients to this theta-polynomial q-expansion.
-/
theorem splThetaE4Series_coeff_eq_e4 (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      if n = 0 then 1 else (240 : Complex) * (ArithmeticFunction.sigma 3 n : Complex) := by
  rw [← splE4Series_eq_splThetaE4Series, splE4Series_coeff]

/--
Same coefficient formula as `splThetaE4Series_coeff_eq_e4`, but rewritten
using the project's local `sigma3` function.

This is the most convenient shape for comparing with
`hammingThetaConvolutionCoeff`, because the local formal Eisenstein series in
`PhysicsSM.Draft.E8ThetaModularAristotle` is stated using `sigma3`.
-/
theorem splThetaE4Series_coeff_eq_local_e4 (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      if n = 0 then 1 else (240 : Complex) * (sigma3 n : Complex) := by
  rw [splThetaE4Series_coeff_eq_e4]
  by_cases hn : n = 0
  · simp [hn]
  · have hsigma :
        ((ArithmeticFunction.sigma 3 n : Nat) : Complex) = (sigma3 n : Complex) := by
      rw [← sigma3_eq_mathlib_sigma n]
    simp [hn, hsigma]

/--
The local integer `e4Series` is the same q-series as SPL's normalized `E₄`,
after coefficientwise casting to `Complex`.

This discharges the Eisenstein side of the bridge: any remaining difficulty is
on the Construction A theta side, not on the divisor-sum coefficient formula.
-/
theorem localE4SeriesComplex_eq_splE4Series :
    localE4SeriesComplex = splE4Series := by
  ext n
  cases n with
  | zero =>
    simp [localE4SeriesComplex, intSeriesToComplex, E8ThetaAristotle.e4Series,
      splE4Series, E4_q_exp_zero]
  | succ n =>
    rw [splE4Series_coeff (Nat.succ n), if_neg (Nat.succ_ne_zero n)]
    simp [localE4SeriesComplex, intSeriesToComplex, E8ThetaAristotle.e4Series,
      PowerSeries.coeff_mk, sigma3_eq_mathlib_sigma (Nat.succ n)]

/-! ## Construction A coefficients as the proved Hamming convolution -/

/--
The Hamming weight-distribution convolution coefficient at theta index `n`.

The project uses the unscaled integer norm `sqNorm`; theta index `n` therefore
corresponds to shell `sqNorm = 4*n`.
-/
def hammingThetaConvolutionCoeff (n : Nat) : Nat :=
  extendedHamming8WeightDist 0 * weightContribConvolution 0 (4 * n) +
  extendedHamming8WeightDist 4 * weightContribConvolution 4 (4 * n) +
  extendedHamming8WeightDist 8 * weightContribConvolution 8 (4 * n)

/--
The unbounded Construction A shell count at `sqNorm = 4*n` is exactly the
Hamming weight-distribution convolution.
-/
theorem constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    Set.ncard (constructionAShellSet (4 * n)) =
      hammingThetaConvolutionCoeff n := by
  simpa [hammingThetaConvolutionCoeff] using
    constructionAShellCount_eq_weight_distribution_convolution (4 * n)

/--
The coefficient of the project's theta series is the Hamming convolution
coefficient, after casting to `Complex`.
-/
theorem localThetaSeriesComplex_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n localThetaSeriesComplex =
      (hammingThetaConvolutionCoeff n : Complex) := by
  simp only [localThetaSeriesComplex, intSeriesToComplex, E8ThetaAristotle.thetaSeries,
    PowerSeries.coeff_mk]
  change ((Set.ncard (constructionAShellSet (4 * n)) : Int) : Complex) =
    (hammingThetaConvolutionCoeff n : Complex)
  rw [constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff n]
  norm_num

/-! ## The remaining bridge, isolated for Aristotle -/

/--
If the SPL theta-polynomial q-expansion has the same coefficients as the
Construction A Hamming convolution, then the project's integer formal theta
series is exactly its local formal `E₄` series.

This is the main reduction theorem in this file.  Its hypothesis is the single
mathematical bridge still missing from the repo: the formal coefficient
identification between the SPL Jacobi theta-polynomial and the Construction A
weight-enumerator convolution.
-/
theorem thetaSeries_eq_e4Series_of_spl_theta_coeff_bridge
    (hbridge : ∀ n : Nat,
      PowerSeries.coeff n splThetaE4Series =
        (hammingThetaConvolutionCoeff n : Complex)) :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series := by
  apply intSeriesToComplex_injective
  ext n
  change PowerSeries.coeff n localThetaSeriesComplex =
    PowerSeries.coeff n localE4SeriesComplex
  rw [localThetaSeriesComplex_coeff_eq_hammingThetaConvolutionCoeff n,
    localE4SeriesComplex_eq_splE4Series,
    splE4Series_eq_splThetaE4Series,
    hbridge n]

/--
The SPL bridge follows from the pure Nat statement that the Hamming
Construction A convolution coefficients equal the local Eisenstein
coefficients.

This theorem records the exact remaining mathematical gap after Aristotle job
`9215f082-2baa-4e13-837c-9335ddf88aad`.  In plain terms, it remains to show
that the number of Construction A E8 lattice vectors with unscaled norm `4*n`
is `1` for `n = 0` and `240 * sigma3 n` for `n > 0`.
-/
theorem thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff
    (hcount : ∀ n : Nat,
      hammingThetaConvolutionCoeff n =
        if n = 0 then 1 else 240 * sigma3 n) :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series :=
  thetaSeries_eq_e4Series_of_spl_theta_coeff_bridge fun n => by
    rw [splThetaE4Series_coeff_eq_local_e4 n, hcount n]
    by_cases hn : n = 0 <;> simp [hn]

/--
Coefficient-level corollary of the SPL bridge.  This is the theorem shape most
downstream files want: for every positive `n`, the Construction A E8 shell
count is `240 * sigma3 n`.
-/
theorem thetaCoeffE8_eq_e4Coeff_of_spl_theta_coeff_bridge
    (hbridge : ∀ n : Nat,
      PowerSeries.coeff n splThetaE4Series =
        (hammingThetaConvolutionCoeff n : Complex))
    (n : Nat) (hn : 0 < n) :
    Set.ncard {z : Fin 8 -> Int |
      (e8IntLattice : Set (Fin 8 -> Int)) z ∧ sqNorm z = 4 * (n : Int)} =
    240 * sigma3 n :=
  E8ThetaAristotle.thetaCoeffE8_eq_e4Coeff_of_series_eq_nat n hn
    (thetaSeries_eq_e4Series_of_spl_theta_coeff_bridge hbridge)

end E8ThetaSPLBridge
end PhysicsSM.Coding
