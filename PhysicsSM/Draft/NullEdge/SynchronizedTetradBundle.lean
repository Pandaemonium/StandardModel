import Mathlib

/-!
# Exact synchronized metric/coframe transition bridge

This module isolates the exact matrix algebra behind the Stage A20 conditional
synchronized metric bundle. Matrices act on row-coordinate gauges:
`zY = zX * A`, metrics factor as `g = e * eta * e^T`, and the induced internal
transition is `eXInv * A * eY`.

Exact metric covariance makes the internal transition Lorentz, and an exact
coordinate-transition cocycle induces the matching internal cocycle. A
nonidentity rational 1+1 boost witnesses that the statements do not collapse to
identity transitions.

The module does not construct charts, metrics, coframes, or spin lifts from a
graph. Properness, time orientation, an `SL(2, C)` lift, a central sign cochain,
spin structure, and continuum convergence remain separate obligations. The
results are draft finite identities with claim grade `M [comp]`.

Provenance: the row-gauge convention and theorem targets come from the Stage
A20 synchronized-tetrad-bundle benchmark. Aristotle supplied the symbolic
proofs; the finite witness was subsequently changed to a kernel-checked
component calculation.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle

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
  unfold rowMetric internalTransition at *
  apply_fun fun x => eXInv * x * eXInvᵀ at hCovariant
  simp_all +decide [Matrix.mul_assoc]
  simp_all +decide [← Matrix.mul_assoc]
  rw [← hCovariant, Matrix.mul_assoc]
  rw [← Matrix.transpose_inj]
  simp +decide [hXLeft]

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
  unfold internalTransition
  calc
    (eXInv * Axy * eY) * (eYInv * Ayz * eZ) =
        eXInv * Axy * (eY * eYInv) * Ayz * eZ := by
          simp only [Matrix.mul_assoc]
    _ = eXInv * (Axy * Ayz) * eZ := by
          rw [hYRight]
          simp only [mul_one, Matrix.mul_assoc]
    _ = eXInv * Axz * eZ := by rw [hAffine]

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
  refine ⟨?_, ?_, ?_, ?_⟩
  · exact internalTransition_lorentz_of_metric_covariant
      eta Axy eX eXInv eY hXLeft hCovXY
  · exact internalTransition_lorentz_of_metric_covariant
      eta Ayz eY eYInv eZ hYLeft hCovYZ
  · exact internalTransition_lorentz_of_metric_covariant
      eta Axz eX eXInv eZ hXLeft hCovXZ
  · exact internalTransition_cocycle
      Axy Ayz Axz eXInv eY eYInv eZ hYRight hAffine

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
  constructor
  · intro h
    have h00 := congrArg (fun M => M 0 0) h
    norm_num [boost11] at h00
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [boost11, eta11, rowMetric, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [boost11, eta11, internalTransition, Matrix.mul_apply,
        Fin.sum_univ_two]

end PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle.MetricCoframeCocycle
