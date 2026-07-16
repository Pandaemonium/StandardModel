import Mathlib

/-!
# Exact metric/coframe transition bridge

This standalone target isolates the exact matrix algebra behind the Stage A20
conditional synchronized metric bundle. Matrices act on row-coordinate gauges:
`zY = zX * A`, metrics factor as `g = e * eta * e^T`, and the induced internal
transition is `eXInv * A * eY`.

The target does not construct charts, metrics, coframes, or spin lifts from a
graph. It states what follows once exact covariance, inverse, and cocycle data
have been established. The rational 1+1 boost is a nonidentity witness.
-/

open Matrix

namespace SynchronizedTetradBundle.MetricCoframeCocycle

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Metric represented in a row-coordinate gauge by a coframe factor. -/
def rowMetric (eta e : Matrix n n ℚ) : Matrix n n ℚ :=
  e * eta * eᵀ

/-- Internal frame transition induced by a coordinate transition and two
coframe representatives. -/
def internalTransition
    (eXInv A eY : Matrix n n ℚ) : Matrix n n ℚ :=
  eXInv * A * eY

/-- Exact coordinate-metric covariance makes the coframe-induced internal
transition `eta`-orthogonal. -/
theorem internalTransition_lorentz_of_metric_covariant
    (eta A eX eXInv eY : Matrix n n ℚ)
    (hXLeft : eXInv * eX = 1)
    (hCovariant : rowMetric eta eX = A * rowMetric eta eY * Aᵀ) :
    internalTransition eXInv A eY * eta *
        (internalTransition eXInv A eY)ᵀ = eta := by
  sorry

/-- Exact affine-coordinate cocycles induce exact internal-transition
cocycles when the intermediate coframe inverse is two-sided in the required
order. -/
theorem internalTransition_cocycle
    (Axy Ayz Axz eXInv eY eYInv eZ : Matrix n n ℚ)
    (hYRight : eY * eYInv = 1)
    (hAffine : Axy * Ayz = Axz) :
    internalTransition eXInv Axy eY *
        internalTransition eYInv Ayz eZ =
      internalTransition eXInv Axz eZ := by
  sorry

/-- Three exact metric-covariant coordinate transitions with an affine cocycle
give three Lorentz internal transitions and their exact cocycle. -/
theorem exact_metric_bundle_gives_lorentz_cocycle
    (eta Axy Ayz Axz eX eXInv eY eYInv eZ : Matrix n n ℚ)
    (hXLeft : eXInv * eX = 1)
    (hYLeft : eYInv * eY = 1)
    (hYRight : eY * eYInv = 1)
    (hCovXY : rowMetric eta eX = Axy * rowMetric eta eY * Axyᵀ)
    (hCovYZ : rowMetric eta eY = Ayz * rowMetric eta eZ * Ayzᵀ)
    (hCovXZ : rowMetric eta eX = Axz * rowMetric eta eZ * Axzᵀ)
    (hAffine : Axy * Ayz = Axz) :
    internalTransition eXInv Axy eY * eta *
          (internalTransition eXInv Axy eY)ᵀ = eta ∧
      internalTransition eYInv Ayz eZ * eta *
          (internalTransition eYInv Ayz eZ)ᵀ = eta ∧
      internalTransition eXInv Axz eZ * eta *
          (internalTransition eXInv Axz eZ)ᵀ = eta ∧
      internalTransition eXInv Axy eY *
          internalTransition eYInv Ayz eZ =
        internalTransition eXInv Axz eZ := by
  sorry

/-- Mostly-minus rational form in 1+1 dimensions. -/
def eta11 : Matrix (Fin 2) (Fin 2) ℚ := !![1, 0; 0, -1]

/-- A nonidentity determinant-one rational Lorentz boost. -/
def boost11 : Matrix (Fin 2) (Fin 2) ℚ :=
  !![5 / 3, 4 / 3; 4 / 3, 5 / 3]

/-- The exact bridge has a nonidentity metric-covariant transition witness. -/
theorem nonidentity_metric_covariant_lorentz_witness :
    boost11 ≠ 1 ∧
      rowMetric eta11 (1 : Matrix (Fin 2) (Fin 2) ℚ) =
        boost11 * rowMetric eta11 1 * boost11ᵀ ∧
      internalTransition 1 boost11 1 * eta11 *
          (internalTransition 1 boost11 1)ᵀ = eta11 := by
  sorry

end SynchronizedTetradBundle.MetricCoframeCocycle
