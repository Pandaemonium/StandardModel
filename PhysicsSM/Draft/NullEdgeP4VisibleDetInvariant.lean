import Mathlib

/-!
# P4 visible determinant invariant

This draft module isolates the finite invariant bridge requested by the
null-step Dirac universality conjecture. The dynamic mass target should match
an unnormalized visible determinant `det P_vis`; trace-normalized celestial
mixedness is an observer-frame readout.

Proven by Aristotle project `5b9efeba-acde-470a-9b66-812acb8f488e` on
2026-06-23 from the focused package
`null-edge-p4-visible-det-invariant-20260623`.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant

abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

/-- Visible congruence action on a `2 x 2` complex matrix. -/
def visibleBoost (A P : CMat2) : CMat2 :=
  A * P * A.conjTranspose

/-- Trace-normalized visible matrix, used for observer-conditioned `m / E`. -/
def traceNormalize (P : CMat2) : CMat2 :=
  (P.trace)⁻¹ • P

/-- Determinant-one visible congruence preserves the unnormalized determinant. -/
theorem visibleBoost_det_invariant
    (A P : CMat2) (hA : A.det = 1) :
    (visibleBoost A P).det = P.det := by
  unfold visibleBoost
  simp +decide [hA]

/-- Determinant of the trace-normalized visible matrix, zpower form. -/
theorem traceNormalize_det_eq_det_div_trace_sq
    (P : CMat2) :
    (traceNormalize P).det = (P.trace) ^ (-2 : Int) * P.det := by
  convert Matrix.det_smul (P : CMat2) ((P.trace : ℂ)⁻¹) using 1
  norm_cast
  ring_nf
  norm_num [mul_comm]

/-- Determinant of the trace-normalized visible matrix, inverse-square form. -/
theorem traceNormalize_det_eq_det_inv_trace_sq
    (P : CMat2) :
    (traceNormalize P).det = (P.trace)⁻¹ ^ 2 * P.det := by
  unfold traceNormalize
  norm_num [pow_two]

end PhysicsSM.Draft.NullEdgeP4VisibleDetInvariant
