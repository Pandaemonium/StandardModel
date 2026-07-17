import Mathlib

/-!
# Finite gauge-invariant radial FMS observable

This focused package isolates the finite algebra behind the scalar
Froehlich-Morchio-Strocchi expansion. For a complex unitary multiplet, the
physical local scalar candidate is the gauge-invariant radial observable

```text
O(H; H0) = ||H||^2 - ||H0||^2.
```

Writing `H = H0 + eta`, the package asks for the exact split

```text
O = 2 Re(H0^dagger eta) + ||eta||^2,
```

the induced four-term weighted two-point decomposition, and the finite
nonzero-residue transfer from an elementary radial response kernel to its FMS
leading kernel.

No continuum limit, spectral measure, pole existence, perturbative hierarchy,
or observed Higgs mass is claimed.
-/

noncomputable section

namespace HiggsFMSRadialObservable

open scoped BigOperators ComplexConjugate

variable {N Omega V : Type*} [Fintype N] [Fintype Omega]

/-- Real part of the finite Hermitian pairing. -/
def realHermitianBilinear (left right : N -> Complex) : Real :=
  ∑ n, (star (left n) * right n).re

/-- Squared Hermitian norm of a finite complex multiplet vector. -/
def vectorNormSq (field : N -> Complex) : Real :=
  realHermitianBilinear field field

/-- Apply one internal unitary transformation. -/
def unitaryTransform [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (field : N -> Complex) : N -> Complex :=
  Matrix.mulVec (g : Matrix N N Complex) field

/-- Gauge-invariant radial observable relative to a supplied vacuum norm. -/
def radialObservable (vacuumNormSq : Real) (field : N -> Complex) : Real :=
  vectorNormSq field - vacuumNormSq

/-- Linear term in the FMS radial expansion. -/
def linearRadialObservable (vacuum fluctuation : N -> Complex) : Real :=
  2 * realHermitianBilinear vacuum fluctuation

/-- Real radial fluctuation along a supplied vacuum direction. -/
def radialFluctuation (vacuum : N -> Complex) (h : Real) : N -> Complex :=
  fun n => (h : Complex) * vacuum n

/-- Unnormalised finite weighted expectation. -/
def weightedMean (weight : Omega -> Real) (observable : Omega -> Real) : Real :=
  ∑ omega, weight omega * observable omega

/-- Finite weighted connected-form expression. It is a connected correlator
when the supplied weights are normalized to unit total weight. -/
def weightedConnectedForm
    (weight : Omega -> Real) (left right : Omega -> Real) : Real :=
  weightedMean weight (fun omega => left omega * right omega) -
    weightedMean weight left * weightedMean weight right

/-- The real Hermitian bilinear is symmetric. -/
theorem realHermitianBilinear_symm (left right : N -> Complex) :
    realHermitianBilinear left right = realHermitianBilinear right left := by
  sorry

/-- A unitary transformation preserves the squared norm. -/
theorem vectorNormSq_unitary [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (field : N -> Complex) :
    vectorNormSq (unitaryTransform g field) = vectorNormSq field := by
  sorry

/-- A common unitary transformation preserves the full real bilinear. -/
theorem realHermitianBilinear_unitary [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (left right : N -> Complex) :
    realHermitianBilinear (unitaryTransform g left)
        (unitaryTransform g right) =
      realHermitianBilinear left right := by
  sorry

/-- The radial observable is exactly invariant under internal unitary gauge
transformations. -/
theorem radialObservable_unitary [DecidableEq N]
    (g : Matrix.unitaryGroup N Complex) (vacuumNormSq : Real)
    (field : N -> Complex) :
    radialObservable vacuumNormSq (unitaryTransform g field) =
      radialObservable vacuumNormSq field := by
  sorry

/-- Exact pointwise FMS expansion around an arbitrary supplied vacuum. -/
theorem radialObservable_add_expansion
    (vacuum fluctuation : N -> Complex) :
    radialObservable (vectorNormSq vacuum) (vacuum + fluctuation) =
      linearRadialObservable vacuum fluctuation +
        vectorNormSq fluctuation := by
  sorry

/-- Weighted covariance is exactly additive in both observable slots. -/
theorem weightedConnectedForm_add_add
    (weight : Omega -> Real)
    (leftLinear leftQuadratic rightLinear rightQuadratic : Omega -> Real) :
    weightedConnectedForm weight (leftLinear + leftQuadratic)
        (rightLinear + rightQuadratic) =
      weightedConnectedForm weight leftLinear rightLinear +
        weightedConnectedForm weight leftLinear rightQuadratic +
        weightedConnectedForm weight leftQuadratic rightLinear +
        weightedConnectedForm weight leftQuadratic rightQuadratic := by
  sorry

/-- Exact finite two-point FMS decomposition: leading-linear, two mixed, and
quadratic-quadratic connected terms. -/
theorem radialObservable_covariance_expansion
    (weight : Omega -> Real) (vacuum : N -> Complex)
    (leftFluctuation rightFluctuation : Omega -> N -> Complex) :
    weightedConnectedForm weight
        (fun omega => radialObservable (vectorNormSq vacuum)
          (vacuum + leftFluctuation omega))
        (fun omega => radialObservable (vectorNormSq vacuum)
          (vacuum + rightFluctuation omega)) =
      weightedConnectedForm weight
          (fun omega => linearRadialObservable vacuum (leftFluctuation omega))
          (fun omega => linearRadialObservable vacuum (rightFluctuation omega)) +
        weightedConnectedForm weight
          (fun omega => linearRadialObservable vacuum (leftFluctuation omega))
          (fun omega => vectorNormSq (rightFluctuation omega)) +
        weightedConnectedForm weight
          (fun omega => vectorNormSq (leftFluctuation omega))
          (fun omega => linearRadialObservable vacuum (rightFluctuation omega)) +
        weightedConnectedForm weight
          (fun omega => vectorNormSq (leftFluctuation omega))
          (fun omega => vectorNormSq (rightFluctuation omega)) := by
  sorry

/-- Along the real radial direction, the FMS linear term is a nonzero scalar
multiple of the radial coordinate whenever the vacuum norm is nonzero. -/
theorem linearRadialObservable_radialFluctuation
    (vacuum : N -> Complex) (h : Real) :
    linearRadialObservable vacuum (radialFluctuation vacuum h) =
      2 * vectorNormSq vacuum * h := by
  sorry

/-- Squared leading FMS residue for the radial coordinate. -/
def fmsRadialResidue (vacuum : N -> Complex) : Real :=
  (2 * vectorNormSq vacuum) ^ 2

/-- A nonzero vacuum gives strictly positive leading radial residue. -/
theorem fmsRadialResidue_pos
    (vacuum : N -> Complex) (hVacuum : vacuum != 0) :
    0 < fmsRadialResidue vacuum := by
  sorry

/-- Leading gauge-invariant FMS response kernel. -/
def fmsLeadingKernel [Fintype V]
    (vacuum : N -> Complex) (kernel : Matrix V V Real) : Matrix V V Real :=
  fmsRadialResidue vacuum • kernel

/-- Multiplication by the nonzero FMS residue preserves every zero/nonzero
entry of a finite response kernel. -/
theorem fmsLeadingKernel_entry_eq_zero_iff
    [Fintype V] (vacuum : N -> Complex) (kernel : Matrix V V Real)
    (hVacuum : vacuum != 0) (i j : V) :
    fmsLeadingKernel vacuum kernel i j = 0 <-> kernel i j = 0 := by
  sorry

/-- The leading FMS residue scales, but does not move, a finite resolvent
identity. -/
theorem fmsLeadingKernel_resolvent
    [Fintype V] [DecidableEq V]
    (vacuum : N -> Complex) (operator kernel source : Matrix V V Real)
    (hResolvent : operator * kernel = source) :
    operator * fmsLeadingKernel vacuum kernel =
      fmsLeadingKernel vacuum source := by
  sorry

end HiggsFMSRadialObservable

end
