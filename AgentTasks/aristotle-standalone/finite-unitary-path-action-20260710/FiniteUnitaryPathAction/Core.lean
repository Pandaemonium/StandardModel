import Mathlib

/-!
# Finite unitary path action

A clean-room finite variational target inspired by the action/Euler-Lagrange
architecture of PhysLean. A history is assigned the sum of squared residuals
from a selected unitary one-step evolution. The intended theorem is that the
minimum value zero is attained exactly by histories satisfying the evolution
equation at every step, and that those histories conserve norm.

This target does not claim that the step operator or action has been derived
from primitive data. It characterizes the exact selected unitary dynamics by a
positive action and supplies a reusable theorem shape for the null-edge Dirac
walk.
-/

open scoped ComplexConjugate
open Finset

namespace FiniteUnitaryPathAction

variable {E : Type*} [NormedAddCommGroup E] [InnerProductSpace ℂ E]

/-- Residual of one proposed unitary evolution step. -/
def residual {N : ℕ} (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E)
    (t : Fin N) : E :=
  psi t.succ - U (psi t.castSucc)

/-- Positive finite action: total squared failure of the evolution law. -/
def pathAction {N : ℕ} (U : E ≃ₗᵢ[ℂ] E)
    (psi : Fin (N + 1) → E) : ℝ :=
  ∑ t : Fin N, ‖residual U psi t‖ ^ 2

/-- The residual action is nonnegative for every finite history. -/
theorem pathAction_nonnegative {N : ℕ} (U : E ≃ₗᵢ[ℂ] E)
    (psi : Fin (N + 1) → E) :
    0 ≤ pathAction U psi := by
  sorry

/-- Zero action is equivalent to the exact equation of motion at every link. -/
theorem pathAction_eq_zero_iff_evolution {N : ℕ}
    (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E) :
    pathAction U psi = 0 ↔
      ∀ t : Fin N, psi t.succ = U (psi t.castSucc) := by
  sorry

/-- Every on-shell finite history conserves the Hilbert norm link by link. -/
theorem on_shell_norm_conserved {N : ℕ}
    (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E)
    (hEOM : ∀ t : Fin N, psi t.succ = U (psi t.castSucc))
    (t : Fin N) :
    ‖psi t.succ‖ = ‖psi t.castSucc‖ := by
  sorry

/-- The action-zero condition alone therefore implies local norm
conservation. -/
theorem zero_action_norm_conserved {N : ℕ}
    (U : E ≃ₗᵢ[ℂ] E) (psi : Fin (N + 1) → E)
    (hzero : pathAction U psi = 0) (t : Fin N) :
    ‖psi t.succ‖ = ‖psi t.castSucc‖ := by
  sorry

/-- A one-step scalar jump under identity evolution has strictly positive
action, proving that the action is not identically zero. -/
theorem scalar_jump_control :
    let U : ℂ ≃ₗᵢ[ℂ] ℂ := LinearIsometryEquiv.refl ℂ ℂ
    let psi : Fin 2 → ℂ := ![0, 1]
    pathAction U psi = 1 := by
  sorry

/-- A constant one-step scalar history is an exact zero-action history. -/
theorem scalar_constant_zero_control :
    let U : ℂ ≃ₗᵢ[ℂ] ℂ := LinearIsometryEquiv.refl ℂ ℂ
    let psi : Fin 2 → ℂ := ![1, 1]
    pathAction U psi = 0 := by
  sorry

end FiniteUnitaryPathAction
