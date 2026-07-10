import Mathlib

/-!
# Local Kraus channels preserve the remote marginal

Standalone Aristotle target for the first finite no-signaling rung. The theorem
is pure finite matrix algebra and does not assume positivity of the input.
-/

open scoped BigOperators ComplexConjugate

namespace FiniteNoSignaling

/-- Partial trace over the second finite register. -/
noncomputable def partialTraceB {n m : Nat}
    (rho : Matrix (Fin n × Fin m) (Fin n × Fin m) ℂ) :
    Matrix (Fin n) (Fin n) ℂ :=
  fun a a' => ∑ b : Fin m, rho (a, b) (a', b)

/-- Apply a finite Kraus family to the second register only. -/
noncomputable def applyLocalKrausB {n m r : Nat}
    (K : Fin r → Matrix (Fin m) (Fin m) ℂ)
    (rho : Matrix (Fin n × Fin m) (Fin n × Fin m) ℂ) :
    Matrix (Fin n × Fin m) (Fin n × Fin m) ℂ :=
  fun x y =>
    ∑ k : Fin r, ∑ c : Fin m, ∑ d : Fin m,
      K k x.2 c * rho (x.1, c) (y.1, d) * star (K k y.2 d)

/-- Kraus trace preservation in matrix-entry form: `sum_k K_k^* K_k = I`. -/
def IsTracePreserving {m r : Nat}
    (K : Fin r → Matrix (Fin m) (Fin m) ℂ) : Prop :=
  ∀ c d : Fin m,
    (∑ k : Fin r, ∑ b : Fin m, star (K k b d) * K k b c) =
      if c = d then 1 else 0

/-- **Finite quantum no-signaling.** Any trace-preserving operation on register
`B` leaves the reduced matrix on register `A` exactly unchanged. -/
theorem partialTraceB_applyLocalKrausB {n m r : Nat}
    (K : Fin r → Matrix (Fin m) (Fin m) ℂ)
    (hK : IsTracePreserving K)
    (rho : Matrix (Fin n × Fin m) (Fin n × Fin m) ℂ) :
    partialTraceB (applyLocalKrausB K rho) = partialTraceB rho := by
  sorry

/-- A nonunitary reset channel on one qubit, with Kraus operators
`|0><0|` and `|0><1|`. -/
noncomputable def resetK : Fin 2 → Matrix (Fin 2) (Fin 2) ℂ :=
  ![!![1, 0; 0, 0], !![0, 1; 0, 0]]

/-- The reset Kraus family is trace preserving. -/
theorem resetK_tracePreserving : IsTracePreserving resetK := by
  sorry

/-- A concrete joint input supported on visible state `0` and hidden state `1`. -/
noncomputable def rhoHiddenOne :
    Matrix (Fin 1 × Fin 2) (Fin 1 × Fin 2) ℂ :=
  fun x y => if x.2 = 1 ∧ y.2 = 1 then 1 else 0

/-- The local reset is genuinely nontrivial on the joint state. -/
theorem reset_changes_joint_state :
    applyLocalKrausB resetK rhoHiddenOne ≠ rhoHiddenOne := by
  sorry

/-- The same nontrivial reset nevertheless leaves the remote marginal fixed. -/
theorem reset_no_signaling_witness :
    applyLocalKrausB resetK rhoHiddenOne ≠ rhoHiddenOne ∧
      partialTraceB (applyLocalKrausB resetK rhoHiddenOne) =
        partialTraceB rhoHiddenOne := by
  sorry

end FiniteNoSignaling
