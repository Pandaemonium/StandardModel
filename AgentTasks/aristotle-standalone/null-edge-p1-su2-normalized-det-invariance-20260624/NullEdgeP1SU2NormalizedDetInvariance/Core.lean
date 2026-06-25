import Mathlib

/-!
# P1 SU(2) invariance of trace-normalized determinant

This standalone target connects the P1 observer spin-frame stabilizer to the
P1 observer scalar bridge.

Physics context: after fixing an observer/rest Hermitian block, residual spin
frame freedom is `SU(2)`. The observer scalar `det rho` must be independent of
that residual frame choice. In finite matrix language, a unitary determinant-one
congruence preserves both the trace and determinant of a `2 x 2` visible block,
and therefore preserves the trace-normalized determinant.
-/

noncomputable section

namespace NullEdgeP1SU2NormalizedDetInvariance.Core

open Matrix

abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

/-- Visible action of a residual spin frame on a `2 x 2` block. -/
def observerConjugate (U P : CMat2) : CMat2 :=
  U * P * U.conjTranspose

/-- Determinant of the trace-normalized visible block. -/
def traceNormalizedDet (P : CMat2) : Complex :=
  (P.trace)⁻¹ ^ 2 * P.det

/--
Trace is invariant under a unitary residual spin-frame congruence. We assume
both left and right unitary identities explicitly so the theorem is a small
finite matrix statement rather than an API hunt.
-/
theorem trace_observerConjugate_eq
    (U P : CMat2)
    (hleft : U.conjTranspose * U = 1) :
    (observerConjugate U P).trace = P.trace := by
  unfold observerConjugate
  rw [Matrix.trace_mul_comm]
  rw [← Matrix.mul_assoc, hleft, Matrix.one_mul]

/--
Determinant is invariant under a determinant-one residual spin-frame
congruence.
-/
theorem det_observerConjugate_eq
    (U P : CMat2)
    (hdet : U.det = 1) :
    (observerConjugate U P).det = P.det := by
  unfold observerConjugate
  simp +decide [hdet, mul_assoc]

/--
The trace-normalized observer determinant is invariant under residual `SU(2)`
spin-frame freedom.

This is the finite gauge-invariance bridge: the scalar `det rho` used in the
observer mass readout is a function of the observer block, not of the particular
spin frame chosen to present it.
-/
theorem traceNormalizedDet_observerConjugate_eq
    (U P : CMat2)
    (hleft : U.conjTranspose * U = 1)
    (hdet : U.det = 1) :
    traceNormalizedDet (observerConjugate U P) = traceNormalizedDet P := by
  convert congr_arg₂ (fun x y : Complex => x⁻¹ ^ 2 * y)
    (trace_observerConjugate_eq U P hleft)
    (det_observerConjugate_eq U P hdet) using 1

end NullEdgeP1SU2NormalizedDetInvariance.Core
