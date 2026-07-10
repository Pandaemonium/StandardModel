import Mathlib

/-!
# Finite unitary least-residual path action

A finite history is assigned the sum of squared residuals from a selected
unitary one-step evolution. The action is nonnegative, and its zero locus is
exactly the set of histories satisfying the selected evolution equation at
every link. On-shell histories therefore conserve Hilbert norm.

This is a positive least-residual action characterization, not yet a
stationary-action derivation of the unitary step. It does not derive the
Hilbert space, time slicing, action, or evolution from primitive null data and
does not identify this generic shell with the separate Pluecker scalar action.

Provenance: clean-room finite theorem shape informed by Debbasch,
arXiv:1806.02313, and the Feynman-clock variational history architecture. Proofs
completed by Aristotle project `f22d0921-567f-40ed-b410-91a40c1aecf2` and
locally verified on 2026-07-10.
-/

open Finset

namespace PhysicsSM.Draft.NullEdge.FiniteUnitaryPathAction

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-- Residual of one proposed unitary evolution step. -/
def residual {N : ℕ} (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E)
    (t : Fin N) : E :=
  psi t.succ - U (psi t.castSucc)

/-- Positive finite action: total squared failure of the selected evolution
law. -/
def pathAction {N : ℕ} (U : E ≃ₗᵢ[ℂ] E)
    (psi : Fin (N + 1) → E) : ℝ :=
  ∑ t : Fin N, ‖residual U psi t‖ ^ 2

/-- The residual action is nonnegative for every finite history. -/
theorem pathAction_nonnegative {N : ℕ} (U : E ≃ₗᵢ[ℂ] E)
    (psi : Fin (N + 1) → E) :
    0 ≤ pathAction U psi := by
  apply Finset.sum_nonneg
  intro t _
  positivity

/-- Zero action is equivalent to the exact selected equation of motion at
every link. -/
theorem pathAction_eq_zero_iff_evolution {N : ℕ}
    (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E) :
    pathAction U psi = 0 ↔
      ∀ t : Fin N, psi t.succ = U (psi t.castSucc) := by
  rw [pathAction, Finset.sum_eq_zero_iff_of_nonneg (fun t _ => by positivity)]
  constructor
  · intro h t
    have ht := h t (Finset.mem_univ t)
    rw [pow_eq_zero_iff (by norm_num), norm_eq_zero, residual, sub_eq_zero] at ht
    exact ht
  · intro h t _
    rw [residual, h t, sub_self, norm_zero]
    norm_num

/-- Every on-shell finite history conserves Hilbert norm link by link. -/
theorem on_shell_norm_conserved {N : ℕ}
    (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E)
    (hEOM : ∀ t : Fin N, psi t.succ = U (psi t.castSucc))
    (t : Fin N) :
    ‖psi t.succ‖ = ‖psi t.castSucc‖ := by
  rw [hEOM t, LinearIsometryEquiv.norm_map]

/-- The action-zero condition alone implies local norm conservation. -/
theorem zero_action_norm_conserved {N : ℕ}
    (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E)
    (hzero : pathAction U psi = 0) (t : Fin N) :
    ‖psi t.succ‖ = ‖psi t.castSucc‖ :=
  on_shell_norm_conserved U psi
    ((pathAction_eq_zero_iff_evolution U psi).mp hzero) t

/-- A one-step scalar jump under identity evolution has positive action, so the
action is not identically zero. -/
theorem scalar_jump_control :
    let U : ℂ ≃ₗᵢ[ℂ] ℂ := LinearIsometryEquiv.refl ℂ ℂ
    let psi : Fin 2 → ℂ := ![0, 1]
    pathAction U psi = 1 := by
  simp [pathAction, residual]

/-- A constant one-step scalar history is an exact zero-action history. -/
theorem scalar_constant_zero_control :
    let U : ℂ ≃ₗᵢ[ℂ] ℂ := LinearIsometryEquiv.refl ℂ ℂ
    let psi : Fin 2 → ℂ := ![1, 1]
    pathAction U psi = 0 := by
  simp [pathAction, residual]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteUnitaryPathAction.pathAction_eq_zero_iff_evolution' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pathAction_eq_zero_iff_evolution

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteUnitaryPathAction.zero_action_norm_conserved' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_action_norm_conserved

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteUnitaryPathAction.scalar_jump_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalar_jump_control

end PhysicsSM.Draft.NullEdge.FiniteUnitaryPathAction
