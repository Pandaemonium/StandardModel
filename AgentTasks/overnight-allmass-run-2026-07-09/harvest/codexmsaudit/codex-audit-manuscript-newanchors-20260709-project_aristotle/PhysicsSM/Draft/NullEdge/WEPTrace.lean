import Mathlib

/-!
# Goal IV WEP trace identity

This draft module records the cheapest finite rung of Goal IV: if the
gravitational coupling operator is channel-blind, then the source
`Tr(K rho)` depends only on the total budget `Tr rho`.

This is a finite matrix trace identity and a pair of guards. It does not prove
the full E-slot field equation, stationarity of a soldering action, or the
Clausius/Jacobson rung.

Provenance: clean-room port of the Aristotle standalone seed returned by
`codex-goalIV-WEP-action-strategy-20260709`
(`21bd9c4d-c787-47ee-8287-f9ba3392791f`,
`RequestProject/GoalIV/WEP.lean`).
-/

namespace WEPTrace

open Matrix

variable {n : ℕ}

/-- Gravitational source of a finite budget operator under a coupling operator. -/
noncomputable def Source (K rho : Matrix (Fin n) (Fin n) ℂ) : ℂ := (K * rho).trace

/-- A coupling is channel-blind when it is a scalar multiple of the identity. -/
def ChannelBlind (K : Matrix (Fin n) (Fin n) ℂ) (kappa : ℂ) : Prop :=
  K = kappa • (1 : Matrix (Fin n) (Fin n) ℂ)

/--
WEP as a finite trace identity: a channel-blind source is `kappa` times the
total budget.
-/
theorem wep_trace_identity {K rho : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (h : ChannelBlind K kappa) : Source K rho = kappa * rho.trace := by
  unfold Source ChannelBlind at *
  rw [h, smul_mul_assoc, one_mul, Matrix.trace_smul, smul_eq_mul]

/-- Equal total budgets have equal sources under a channel-blind coupling. -/
theorem wep_universality {K rho1 rho2 : Matrix (Fin n) (Fin n) ℂ} {kappa : ℂ}
    (h : ChannelBlind K kappa) (ht : rho1.trace = rho2.trace) :
    Source K rho1 = Source K rho2 := by
  rw [wep_trace_identity h, wep_trace_identity h, ht]

/--
Nonvacuity fixture: there is a nonzero channel-blind coupling and two distinct
equal-trace budget matrices with a common source.
-/
theorem wep_source_nonvacuous :
    ∃ (K rho1 rho2 : Matrix (Fin 2) (Fin 2) ℂ) (kappa : ℂ),
      ChannelBlind K kappa ∧ kappa ≠ 0 ∧ rho1 ≠ rho2 ∧ rho1.trace = rho2.trace ∧
      Source K rho1 = Source K rho2 := by
  refine ⟨(1 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ),
    Matrix.diagonal ![(1 : ℂ), 0], Matrix.diagonal ![(0 : ℂ), 1], 1,
    rfl, one_ne_zero, ?_, ?_, ?_⟩
  · intro hcontra
    have h00 := congrFun (congrFun hcontra 0) 0
    simp [Matrix.diagonal] at h00
  · simp [Matrix.trace_diagonal, Fin.sum_univ_two]
  · exact wep_universality (kappa := 1) rfl
      (by simp [Matrix.trace_diagonal, Fin.sum_univ_two])

/--
Channel-stress guard: without channel-blindness, two equal-trace budgets can
have different sources.
-/
theorem wep_violation_of_channel_stress :
    ∃ (K rho1 rho2 : Matrix (Fin 2) (Fin 2) ℂ),
      rho1.trace = rho2.trace ∧ Source K rho1 ≠ Source K rho2 := by
  refine ⟨Matrix.diagonal ![(1 : ℂ), 0], Matrix.diagonal ![(1 : ℂ), 0],
    Matrix.diagonal ![(0 : ℂ), 1], ?_, ?_⟩
  · simp [Matrix.trace_diagonal, Fin.sum_univ_two]
  · simp [Source, Matrix.diagonal_mul_diagonal, Matrix.trace_diagonal, Fin.sum_univ_two]

end WEPTrace

/-! ## Axiom audit (build-enforced guard pin) -/

/-- info: 'WEPTrace.wep_trace_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPTrace.wep_trace_identity

/-- info: 'WEPTrace.wep_universality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPTrace.wep_universality

/-- info: 'WEPTrace.wep_source_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPTrace.wep_source_nonvacuous

/-- info: 'WEPTrace.wep_violation_of_channel_stress' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms WEPTrace.wep_violation_of_channel_stress
