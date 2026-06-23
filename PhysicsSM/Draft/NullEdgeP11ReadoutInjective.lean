import Mathlib

/-!
# P11 calibrated readout injectivity

The normalized state plus the trace scale reconstructs the unnormalized momentum
block when the trace is nonzero.
-/

namespace PhysicsSM.Draft.NullEdgeP11ReadoutInjective

abbrev MomentumBlock :=
  Matrix (Fin 2) (Fin 2) Complex

noncomputable def normalize (P : MomentumBlock) : MomentumBlock :=
  (P.trace)⁻¹ • P

theorem trace_smul_normalize (P : MomentumBlock) (h : P.trace ≠ 0) :
    P.trace • normalize P = P := by
  simp +decide [ h, normalize ]

theorem eq_of_same_normalize_and_trace
    (P Q : MomentumBlock) (hP : P.trace ≠ 0)
    (hstate : normalize P = normalize Q) (hscale : P.trace = Q.trace) :
    P = Q := by
  have hQ : Q.trace ≠ 0 := hscale ▸ hP
  calc P = P.trace • normalize P := (trace_smul_normalize P hP).symm
    _ = Q.trace • normalize Q := by rw [hstate, hscale]
    _ = Q := trace_smul_normalize Q hQ

end PhysicsSM.Draft.NullEdgeP11ReadoutInjective
