import Mathlib

/-!
# Finite no-signaling for a local Kraus channel

This module proves that any finite trace-preserving Kraus operation on register
`B` leaves the reduced matrix on register `A` exactly unchanged. An explicit
nonunitary reset channel supplies the nondegenerate control: it changes the
joint state while preserving the remote marginal.

This is an operational theorem for a supplied tensor factorization. It does not
derive that factorization from graph separation, prove Bell nonlocality, build a
spacetime causal net, or derive quantum probability.

Provenance: clean-room theorem shape informed by the public `lean-quantum`
channel and partial-trace APIs. Proofs were completed by Aristotle project
`17674ce6-b10a-474a-931f-d0237d539f0b` and locally rechecked under the pinned
toolchain.
-/

open scoped BigOperators ComplexConjugate

namespace PhysicsSM.Draft.NullEdge.FiniteNoSignaling

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

/-- Any trace-preserving operation on register `B` leaves the reduced matrix on
register `A` exactly unchanged. -/
theorem partialTraceB_applyLocalKrausB {n m r : Nat}
    (K : Fin r → Matrix (Fin m) (Fin m) ℂ)
    (hK : IsTracePreserving K)
    (rho : Matrix (Fin n × Fin m) (Fin n × Fin m) ℂ) :
    partialTraceB (applyLocalKrausB K rho) = partialTraceB rho := by
  have h_fubini : ∀ a a' : Fin n,
      ∑ b : Fin m, ∑ k : Fin r, ∑ c : Fin m, ∑ d : Fin m,
          K k b c * rho (a, c) (a', d) * star (K k b d) =
        ∑ c : Fin m, ∑ d : Fin m,
          rho (a, c) (a', d) * ∑ k : Fin r, ∑ b : Fin m, star (K k b d) * K k b c := by
    simp +decide only [mul_comm, Finset.mul_sum _ _ _, mul_left_comm]
    simp +decide only [← Finset.sum_product']
    intro a a'
    apply Finset.sum_bij (fun x _ => (x.2.2.1, x.2.2.2, x.2.1, x.1))
    · aesop
    · grind
    · aesop
    · grind
  unfold partialTraceB applyLocalKrausB
  ext a a'
  simp_all +decide [IsTracePreserving]

/-- A nonunitary reset channel on one qubit, with Kraus operators
`|0><0|` and `|0><1|`. -/
noncomputable def resetK : Fin 2 → Matrix (Fin 2) (Fin 2) ℂ :=
  ![!![1, 0; 0, 0], !![0, 1; 0, 0]]

/-- The reset Kraus family is trace preserving. -/
theorem resetK_tracePreserving : IsTracePreserving resetK := by
  unfold IsTracePreserving
  simp +decide [Fin.forall_fin_two, resetK]

/-- A concrete joint input supported on visible state `0` and hidden state `1`. -/
noncomputable def rhoHiddenOne :
    Matrix (Fin 1 × Fin 2) (Fin 1 × Fin 2) ℂ :=
  fun x y => if x.2 = 1 ∧ y.2 = 1 then 1 else 0

/-- The local reset is genuinely nontrivial on the joint state. -/
theorem reset_changes_joint_state :
    applyLocalKrausB resetK rhoHiddenOne ≠ rhoHiddenOne := by
  unfold applyLocalKrausB
  intro h
  have := congr_fun (congr_fun h (0, 1)) (0, 1)
  norm_num [Fin.sum_univ_succ, resetK, rhoHiddenOne] at this

/-- The same nontrivial reset nevertheless leaves the remote marginal fixed. -/
theorem reset_no_signaling_witness :
    applyLocalKrausB resetK rhoHiddenOne ≠ rhoHiddenOne ∧
      partialTraceB (applyLocalKrausB resetK rhoHiddenOne) =
        partialTraceB rhoHiddenOne := by
  exact ⟨reset_changes_joint_state,
    partialTraceB_applyLocalKrausB resetK resetK_tracePreserving rhoHiddenOne⟩

end PhysicsSM.Draft.NullEdge.FiniteNoSignaling
