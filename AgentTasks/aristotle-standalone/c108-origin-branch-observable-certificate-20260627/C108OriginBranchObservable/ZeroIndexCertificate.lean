import Mathlib

/-!
# C108 origin branch-observable certificate

This standalone Aristotle target formalizes the finite algebra trap for the
Gate C1 non-ultralocal branch:

If a candidate origin branch observable `B` commutes with the chirality-flipping
balance symmetry `J`, then every polynomial selector `p(B)` also commutes with
`J`.  Consequently its chiral trace against `Gamma` vanishes when `J`
anti-commutes with `Gamma`.

This is not a physical release theorem and does not construct a branch
observable. It is a rejection certificate for non-polarizing candidate
observables.
-/

namespace C108OriginBranchObservable

open Matrix

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Finite chiral trace/index proxy used in the origin-fiber test. -/
noncomputable def ChiralTrace (Gamma P : Matrix n n Complex) : Complex :=
  trace (Gamma * P)

/--
If `J` is an involution, `J` anti-commutes with `Gamma`, and `P` commutes with
`J`, then the chiral trace of `P` is zero.
-/
theorem chiralTrace_zero_of_balance_commuting_projector
    (Gamma J P : Matrix n n Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J))
    (hCommP : J * P = P * J) :
    ChiralTrace Gamma P = 0 := by
  -- By the properties of the trace, `trace (J * Gamma * P * J) = trace (Gamma * P)`.
  have h_trace : trace (J * (Gamma * P) * J) = trace (Gamma * P) := by
    rw [← Matrix.trace_mul_comm]
    simp +decide [← mul_assoc, hJ2]
  simp_all +decide [← mul_assoc, ChiralTrace]
  grind

/--
If a matrix `B` commutes with `J`, then every polynomial in `B` also commutes
with `J`.
-/
theorem polynomial_aeval_commutes_of_commutes
    (B J : Matrix n n Complex) (p : Polynomial Complex)
    (hCommB : J * B = B * J) :
    J * Polynomial.aeval B p = Polynomial.aeval B p * J := by
  induction' p using Polynomial.induction_on' with p q hp hq
  · simp +decide [*, mul_add, add_mul]
  · induction' ‹ℕ› with n ih <;> simp_all +decide [pow_succ, ← mul_assoc]
    · simp +decide [Algebra.commutes]
    · simp +decide [mul_assoc, hCommB]

/--
Origin branch-observable rejection certificate: if a candidate branch
observable `B` commutes with the balance symmetry `J`, then every polynomial
selector `p(B)` has zero chiral trace.
-/
theorem polynomial_selector_chiralTrace_zero_of_balance_commuting_observable
    (Gamma J B : Matrix n n Complex) (p : Polynomial Complex)
    (hJ2 : J * J = 1)
    (hAnti : J * Gamma = -(Gamma * J))
    (hCommB : J * B = B * J) :
    ChiralTrace Gamma (Polynomial.aeval B p) = 0 := by
  apply chiralTrace_zero_of_balance_commuting_projector
  exacts [hJ2, hAnti, polynomial_aeval_commutes_of_commutes B J p hCommB]

end C108OriginBranchObservable
