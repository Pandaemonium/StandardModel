import Mathlib

/-!
# P11 calibrated readout core

This is the first proof package recommended by the P11 strategy job. It makes
the scale warning precise: normalization by trace can preserve the celestial
state while losing the determinant-mass scale, so P11 must use either the
unnormalized momentum block `P` or a calibrated readout `(normalize P, Tr P)`.
-/

namespace NullEdgeP11ReadoutCore

abbrev MomentumBlock := Matrix (Fin 2) (Fin 2) Complex

def massSq (P : MomentumBlock) : Complex :=
  P.det

noncomputable def normalize (P : MomentumBlock) : MomentumBlock :=
  (P.trace)⁻¹ • P

structure Readout where
  state : MomentumBlock
  scale : Complex

noncomputable def readout (P : MomentumBlock) : Readout :=
  { state := normalize P, scale := P.trace }

def Readout.reconstruct (r : Readout) : MomentumBlock :=
  r.scale • r.state

theorem det_normalize_eq_det_div_trace_sq (P : MomentumBlock) :
    (normalize P).det = P.det / (P.trace) ^ 2 := by
  sorry

theorem reconstruct_readout (P : MomentumBlock) (h : P.trace ≠ 0) :
    (readout P).reconstruct = P := by
  sorry

theorem normalized_channel_loses_energy_scale :
    _root_.Exists fun P : MomentumBlock =>
      _root_.Exists fun Q : MomentumBlock =>
        normalize P = normalize Q ∧ massSq P ≠ massSq Q := by
  sorry

end NullEdgeP11ReadoutCore
