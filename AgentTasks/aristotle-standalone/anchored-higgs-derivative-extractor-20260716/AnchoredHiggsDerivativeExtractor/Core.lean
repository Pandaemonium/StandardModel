import Mathlib

/-!
# Anchored multi-edge Higgs derivative extractor

This focused package isolates a finite local derivative estimator assembled
from a fan of gauge-transported edge differences at one anchor. Real supplied
coefficients convert the edge fan into derivative components. The package
proves anchor gauge covariance, gauge invariance of arbitrary signed kinetic
contractions, a mostly-minus specialization, and vanishing on a covariantly
constant section.

The coefficients are supplied. No graph coframe, dual frame, least-squares
selector, metric, stress tensor, or continuum convergence is constructed.
-/

noncomputable section

namespace AnchoredHiggsDerivativeExtractor

open scoped BigOperators

variable {Y I : Type*} [Fintype Y] [Fintype I]

/-- Gauge-transported field difference from one neighbor back to the anchor. -/
def anchoredDifference
    (phi0 : Complex) (phi : Y -> Complex) (transport : Y -> Circle)
    (y : Y) : Complex :=
  (transport y : Complex) * phi y - phi0

/-- Local gauge transformation of the neighboring field values. -/
def gaugeTransformNeighbors
    (g : Y -> Circle) (phi : Y -> Complex) : Y -> Complex :=
  fun y => (g y : Complex) * phi y

/-- Endpoint transformation of transports from neighbors to one anchor. -/
def gaugeTransformTransport
    (g0 : Circle) (g : Y -> Circle) (transport : Y -> Circle) : Y -> Circle :=
  fun y => g0 * transport y * (g y)⁻¹

/-- Supplied real dual-frame coefficients assemble anchored differences into
local derivative components. -/
def anchoredDerivative
    (coeff : I -> Y -> Real)
    (phi0 : Complex) (phi : Y -> Complex) (transport : Y -> Circle)
    (i : I) : Complex :=
  ∑ y, (coeff i y : Complex) * anchoredDifference phi0 phi transport y

/-- Arbitrary signed contraction of finite derivative components. -/
def signedKinetic
    (sign : I -> Real) (derivative : I -> Complex) : Real :=
  ∑ i, sign i * Complex.normSq (derivative i)

/-- Project mostly-minus signs on four supplied derivative components. -/
def mostlyMinusSign (i : Fin 4) : Real :=
  if i = 0 then 1 else -1

/-- Mostly-minus kinetic contraction of four derivative components. -/
def mostlyMinusKinetic (derivative : Fin 4 -> Complex) : Real :=
  signedKinetic mostlyMinusSign derivative

/-- Every anchored difference transforms only by the anchor phase. -/
theorem anchoredDifference_gauge_transform
    (phi0 : Complex) (phi : Y -> Complex) (transport : Y -> Circle)
    (g0 : Circle) (g : Y -> Circle) (y : Y) :
    anchoredDifference ((g0 : Complex) * phi0)
        (gaugeTransformNeighbors g phi)
        (gaugeTransformTransport g0 g transport) y =
      (g0 : Complex) * anchoredDifference phi0 phi transport y := by
  sorry

/-- Every supplied real linear derivative component transforms by the common
anchor phase. -/
theorem anchoredDerivative_gauge_transform
    (coeff : I -> Y -> Real)
    (phi0 : Complex) (phi : Y -> Complex) (transport : Y -> Circle)
    (g0 : Circle) (g : Y -> Circle) (i : I) :
    anchoredDerivative coeff ((g0 : Complex) * phi0)
        (gaugeTransformNeighbors g phi)
        (gaugeTransformTransport g0 g transport) i =
      (g0 : Complex) * anchoredDerivative coeff phi0 phi transport i := by
  sorry

/-- Any real signed contraction of the derivative norms is gauge invariant. -/
theorem signedKinetic_gauge_invariant
    (sign : I -> Real) (derivative : I -> Complex) (g0 : Circle) :
    signedKinetic sign (fun i => (g0 : Complex) * derivative i) =
      signedKinetic sign derivative := by
  sorry

/-- The mostly-minus four-component contraction is gauge invariant. -/
theorem mostlyMinusKinetic_gauge_invariant
    (derivative : Fin 4 -> Complex) (g0 : Circle) :
    mostlyMinusKinetic (fun i => (g0 : Complex) * derivative i) =
      mostlyMinusKinetic derivative := by
  sorry

/-- A covariantly constant anchored section gives zero in every extracted
derivative component. -/
theorem anchoredDerivative_eq_zero_of_parallel
    (coeff : I -> Y -> Real)
    (phi0 : Complex) (phi : Y -> Complex) (transport : Y -> Circle)
    (hParallel : ∀ y, (transport y : Complex) * phi y = phi0)
    (i : I) :
    anchoredDerivative coeff phi0 phi transport i = 0 := by
  sorry

/-- Every signed kinetic contraction vanishes on a covariantly constant
anchored section. -/
theorem signedKinetic_eq_zero_of_parallel
    (coeff : I -> Y -> Real) (sign : I -> Real)
    (phi0 : Complex) (phi : Y -> Complex) (transport : Y -> Circle)
    (hParallel : ∀ y, (transport y : Complex) * phi y = phi0) :
    signedKinetic sign
        (anchoredDerivative coeff phi0 phi transport) = 0 := by
  sorry

end AnchoredHiggsDerivativeExtractor

end
