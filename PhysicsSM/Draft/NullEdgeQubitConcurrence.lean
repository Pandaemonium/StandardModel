import Mathlib

/-!
# Null-edge qubit concurrence wrapper

This draft module integrates Aristotle project
`097cc326-5ae4-46b2-8786-de2975ac8103`.

It proves the finite `2 x 2` complex matrix algebra behind the
proper-time-as-concurrence reading of the null-edge program.  The physics-facing
claim is deliberately narrow: after a visible celestial qubit has been
normalized to trace one, the determinant expression used for the normalized
mass ratio has the same square as the standard two-level concurrence/linear
entropy expression.

Claim boundary:

* no positivity, Hermiticity, or density-matrix axioms are bundled into
  `trace2`; those hypotheses belong in downstream wrappers;
* no LOCC monotonicity or time-arrow statement is asserted here;
* the theorem is finite algebra only, intended as a small reusable bridge for
  the reduced-celestial-density part of the research program.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeQubitConcurrence

open Matrix Complex

/-! ## Trace, entropy, and concurrence wrappers -/

/-- Trace of a `2 x 2` complex matrix, written entrywise for small algebra. -/
def trace2 (rho : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  rho 0 0 + rho 1 1

/--
Complexified linear-entropy numerator for a trace-one qubit density:
`2 * (1 - tr(rho^2))`.
-/
def linearEntropyComplex (rho : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  2 * (1 - trace2 (rho * rho))

/--
Complexified concurrence squared, represented by the determinant expression
`4 * det rho`.

Audit note (naming/positivity convention): "concurrence" here is the
single-qubit linear-entropy / tangle form `4 det rho`, i.e. the squared
concurrence of the two-qubit pure state whose reduced density is `rho`; it is
not the Wootters two-qubit concurrence formula. This wrapper deliberately
bundles no Hermiticity, positivity, or trace-one axioms (those are factored
into the `htrace` hypothesis where needed and into downstream wrappers), so the
physical reading as an entanglement measure only holds for a genuine
nonnegative-eigenvalue density matrix.
-/
def concurrenceSqComplex (rho : Matrix (Fin 2) (Fin 2) Complex) : Complex :=
  4 * rho.det

/--
Real normalized mass-ratio expression read from a nonnegative determinant.
For a normalized visible qubit this is the program's `m / E` wrapper.
-/
def normalizedMassRatioFromDet (d : Real) : Real :=
  2 * Real.sqrt d

/--
Real qubit concurrence expression read from a nonnegative determinant.  The
definition is intentionally the same as `normalizedMassRatioFromDet`; the point
of the wrapper theorem below is to record the physics identification in Lean.
-/
def qubitConcurrenceFromDet (d : Real) : Real :=
  2 * Real.sqrt d

/-! ## Finite determinant identities -/

/--
For any `2 x 2` matrix, `Tr(rho^2) = Tr(rho)^2 - 2 det(rho)`.

This is the small algebraic identity that makes the concurrence, determinant,
and linear-entropy presentations interchangeable in the trace-one case.
-/
theorem trace2_mul_self_eq_trace_sq_sub_two_det
    (rho : Matrix (Fin 2) (Fin 2) Complex) :
    trace2 (rho * rho) = trace2 rho * trace2 rho - 2 * rho.det := by
  simp only [trace2, Matrix.mul_apply, Fin.sum_univ_two, Matrix.det_fin_two]
  ring

/--
For a trace-one `2 x 2` density matrix, the complexified linear entropy equals
the complexified concurrence squared.
-/
theorem linearEntropyComplex_eq_concurrenceSq_of_trace_one
    (rho : Matrix (Fin 2) (Fin 2) Complex)
    (htrace : trace2 rho = 1) :
    linearEntropyComplex rho = concurrenceSqComplex rho := by
  unfold linearEntropyComplex concurrenceSqComplex
  rw [trace2_mul_self_eq_trace_sq_sub_two_det, htrace]
  ring

/--
The normalized mass-ratio expression and qubit concurrence expression are the
same determinant square root.
-/
theorem normalized_mass_ratio_eq_concurrence (d : Real) :
    normalizedMassRatioFromDet d = qubitConcurrenceFromDet d := by
  rfl

/-- The normalized mass ratio squared is `4 * d` for a nonnegative determinant. -/
theorem normalized_mass_ratio_sq_eq_four_det
    (d : Real) (hd : 0 <= d) :
    normalizedMassRatioFromDet d ^ 2 = 4 * d := by
  unfold normalizedMassRatioFromDet
  nlinarith [Real.mul_self_sqrt hd]

/-- The qubit concurrence squared is `4 * d` for a nonnegative determinant. -/
theorem qubitConcurrence_sq_eq_four_det
    (d : Real) (hd : 0 <= d) :
    qubitConcurrenceFromDet d ^ 2 = 4 * d := by
  unfold qubitConcurrenceFromDet
  nlinarith [Real.mul_self_sqrt hd]

end PhysicsSM.Draft.NullEdgeQubitConcurrence

end
