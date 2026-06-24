import Mathlib.Tactic

/-!
# P2/P4 walk coherence equals chiral-projector coherence in the continuum

This package connects the null-step walk's continuum coherence ratio to the
two-level positive-energy chiral projector coherence.
-/

noncomputable section

namespace NullEdgeP2WalkProjectorCoherenceBridge

def positiveProjectorLR (m E : Real) : Real :=
  m / (2 * E)

def chiralityCoherence (offdiag : Real) : Real :=
  2 * |offdiag|

theorem chiralityCoherence_positiveProjectorLR_sq
    (m E : Real) (hE : 0 < E) :
    chiralityCoherence (positiveProjectorLR m E) ^ 2 = m ^ 2 / E ^ 2 := by
  unfold chiralityCoherence positiveProjectorLR
  rw [mul_pow, sq_abs]
  field_simp

theorem walk_limit_ratio_eq_projector_coherence_sq
    (k m : Real) (hpos : 0 < k ^ 2 + m ^ 2) :
    m ^ 2 / (k ^ 2 + m ^ 2)
      =
    chiralityCoherence
      (positiveProjectorLR m (Real.sqrt (k ^ 2 + m ^ 2))) ^ 2 := by
  rw [chiralityCoherence_positiveProjectorLR_sq]
  · rw [Real.sq_sqrt hpos.le]
  · positivity


end NullEdgeP2WalkProjectorCoherenceBridge
