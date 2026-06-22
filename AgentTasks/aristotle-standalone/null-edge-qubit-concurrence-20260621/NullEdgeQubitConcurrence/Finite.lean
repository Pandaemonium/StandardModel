import Mathlib

noncomputable section

namespace NullEdgeQubitConcurrence

open Matrix Complex

/-- Trace of a `2 x 2` complex matrix. -/
def trace2 (rho : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  rho 0 0 + rho 1 1

/-- Complexified linear entropy numerator for a trace-one qubit density. -/
def linearEntropyComplex (rho : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  2 * (1 - trace2 (rho * rho))

/-- Complexified concurrence squared, represented as `4 det rho`. -/
def concurrenceSqComplex (rho : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  4 * rho.det

/-- Real normalized mass-ratio expression read from a nonnegative determinant. -/
def normalizedMassRatioFromDet (d : ℝ) : ℝ :=
  2 * Real.sqrt d

/-- Real qubit concurrence expression read from a nonnegative determinant. -/
def qubitConcurrenceFromDet (d : ℝ) : ℝ :=
  2 * Real.sqrt d

/--
For any `2 x 2` matrix, `Tr(rho^2) = Tr(rho)^2 - 2 det(rho)`.
-/
theorem trace2_mul_self_eq_trace_sq_sub_two_det
    (rho : Matrix (Fin 2) (Fin 2) Complex) :
    trace2 (rho * rho) = trace2 rho * trace2 rho - 2 * rho.det := by
  sorry

/--
For a trace-one `2 x 2` density matrix, the complexified linear entropy equals
concurrence squared.
-/
theorem linearEntropyComplex_eq_concurrenceSq_of_trace_one
    (rho : Matrix (Fin 2) (Fin 2) Complex)
    (htrace : trace2 rho = 1) :
    linearEntropyComplex rho = concurrenceSqComplex rho := by
  sorry

/--
The normalized mass-ratio expression and qubit concurrence expression are the
same determinant square-root.
-/
theorem normalized_mass_ratio_eq_concurrence (d : ℝ) :
    normalizedMassRatioFromDet d = qubitConcurrenceFromDet d := by
  rfl

/-- The normalized mass ratio squared is `4 det` for a nonnegative determinant. -/
theorem normalized_mass_ratio_sq_eq_four_det
    (d : ℝ) (hd : 0 ≤ d) :
    normalizedMassRatioFromDet d ^ 2 = 4 * d := by
  sorry

/-- The qubit concurrence squared is `4 det` for a nonnegative determinant. -/
theorem qubitConcurrence_sq_eq_four_det
    (d : ℝ) (hd : 0 ≤ d) :
    qubitConcurrenceFromDet d ^ 2 = 4 * d := by
  sorry

end NullEdgeQubitConcurrence

end
