import Mathlib.Tactic

/-!
# P11 normalized state equality is scale equality up to trace

This package sharpens the calibrated-readout point: normalization alone loses
scale, and equality of normalized momentum blocks means the unnormalized blocks
are trace-scaled versions of each other.
-/

noncomputable section

namespace NullEdgeP11NormalizeSameIffScale

abbrev MomentumBlock := Matrix (Fin 2) (Fin 2) Real

noncomputable def normalize (P : MomentumBlock) : MomentumBlock :=
  (P.trace)⁻¹ • P

theorem trace_smul_normalize (P : MomentumBlock) (h : P.trace ≠ 0) :
    P.trace • normalize P = P := by
  sorry

theorem same_normalize_iff_trace_scaled
    (P Q : MomentumBlock) (hP : P.trace ≠ 0) (hQ : Q.trace ≠ 0) :
    normalize P = normalize Q <->
      Q.trace • P = P.trace • Q := by
  sorry

theorem same_normalize_of_scalar_multiple
    (P : MomentumBlock) (r : Real) (hP : P.trace ≠ 0) (hr : r ≠ 0) :
    normalize (r • P) = normalize P := by
  sorry

end NullEdgeP11NormalizeSameIffScale
