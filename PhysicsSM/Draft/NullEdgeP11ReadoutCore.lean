import Mathlib

/-!
# P11 calibrated readout core

This draft module makes the P11 scale warning precise. Normalizing a momentum
block by its trace can preserve the celestial state while losing the determinant
mass scale, so a particle-sector channel needs either the unnormalized momentum
block or a calibrated readout `(normalize P, Tr P)`.
-/

namespace PhysicsSM.Draft.NullEdgeP11ReadoutCore

abbrev MomentumBlock :=
  Matrix (Fin 2) (Fin 2) Complex

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
  rw [normalize, Matrix.det_smul]
  simp [Fintype.card_fin, inv_pow, div_eq_mul_inv, mul_comm]

theorem reconstruct_readout (P : MomentumBlock) (h : P.trace ≠ 0) :
    (readout P).reconstruct = P := by
  rw [readout, Readout.reconstruct, normalize, smul_smul, mul_inv_cancel₀ h,
    one_smul]

theorem normalized_channel_loses_energy_scale :
    Exists fun P : MomentumBlock =>
      Exists fun Q : MomentumBlock =>
        normalize P = normalize Q ∧ massSq P ≠ massSq Q := by
  refine ⟨!![1, 1; -1, 1], !![2, 2; -2, 2], ?_, ?_⟩
  · unfold normalize
    norm_num [Matrix.trace_fin_two]
  · unfold massSq
    norm_num [Matrix.det_fin_two]

end PhysicsSM.Draft.NullEdgeP11ReadoutCore
