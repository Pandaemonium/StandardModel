import Mathlib

/-!
# P11 readout rescaling core

The calibrated readout must carry scale: normalization forgets nonzero scalar
rescalings, while determinant mass scales quadratically.
-/

namespace NullEdgeP11ReadoutRescale

abbrev MomentumBlock :=
  Matrix (Fin 2) (Fin 2) Complex

def massSq (P : MomentumBlock) : Complex :=
  P.det

noncomputable def normalize (P : MomentumBlock) : MomentumBlock :=
  (P.trace)⁻¹ • P

theorem trace_smul (c : Complex) (P : MomentumBlock) :
    (c • P).trace = c * P.trace := by
  sorry

theorem normalize_smul_eq_normalize
    (c : Complex) (P : MomentumBlock) (hc : c ≠ 0) :
    normalize (c • P) = normalize P := by
  sorry

theorem massSq_smul_eq_sq_mul (c : Complex) (P : MomentumBlock) :
    massSq (c • P) = c ^ 2 * massSq P := by
  sorry

theorem scaled_same_normalized_state_different_mass
    (P : MomentumBlock) (hdet : massSq P ≠ 0) :
    normalize (2 • P) = normalize P ∧ massSq (2 • P) ≠ massSq P := by
  sorry

end NullEdgeP11ReadoutRescale
