import PhysicsSM.Draft.NullEdge.FloquetTaggedCrossingBalance

/-!
# Finite Floquet micromotion schedules

This module starts the anomalous-Floquet 3+1 route with the structure that an
endpoint-only description omits: the ordered substep history through one
period. A schedule is a finite list of square complex matrices. Its endpoint
uses physical time ordering, so the first listed substep acts first.

The main algebraic result is deliberately elementary but load-bearing:
unitarity of every substep implies unitarity of the ordered endpoint. The
two-step witness then proves that endpoint evaluation is not injective: a
nontrivial flip-flip history and an idle-idle history have the same endpoint.
Thus a future winding invariant must inspect micromotion rather than only the
one-period matrix.

Scope: finite matrix algebra only. This module defines no winding number,
crossing charge, Brillouin-zone family, null-support factorization, continuum
limit, or single-Weyl theorem.

Provenance: clean-room finite-schedule API. The scientific route is informed by
Higashikawa--Nakagawa--Ueda, arXiv:1806.06868, and Bessho--Sato,
arXiv:2006.04204; no external code was copied.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule

open Matrix Complex

/-- Two-sided unitarity, kept explicit because later finite schedules will be
used both as evolution operators and as reversible changes of timeframe. -/
def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop :=
  Uᴴ * U = 1 ∧ U * Uᴴ = 1

/-- The ordered endpoint of a finite schedule. The head acts first, so
`endpoint [U0, U1] = U1 * U0`. -/
def endpoint {n : Type*} [Fintype n] [DecidableEq n] :
    List (Matrix n n Complex) → Matrix n n Complex
  | [] => 1
  | U :: steps => endpoint steps * U

/-- The micromotion endpoint after at most `s` listed substeps. -/
def partialEndpoint {n : Type*} [Fintype n] [DecidableEq n]
    (steps : List (Matrix n n Complex)) (s : Nat) : Matrix n n Complex :=
  endpoint (steps.take s)

/-- The identity matrix is unitary. -/
theorem isUnitary_one {n : Type*} [Fintype n] [DecidableEq n] :
    IsUnitary (1 : Matrix n n Complex) := by
  simp [IsUnitary]

/-- Products of two-sided unitary matrices are two-sided unitary. -/
theorem IsUnitary.mul {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n Complex} (hA : IsUnitary A) (hB : IsUnitary B) :
    IsUnitary (A * B) := by
  rcases hA with ⟨hAleft, hAright⟩
  rcases hB with ⟨hBleft, hBright⟩
  constructor
  · rw [conjTranspose_mul, mul_assoc, ← mul_assoc Aᴴ A B, hAleft,
      one_mul, hBleft]
  · rw [conjTranspose_mul, mul_assoc, ← mul_assoc B Bᴴ Aᴴ, hBright,
      one_mul, hAright]

/-- A schedule of unitary substeps has a unitary ordered endpoint. -/
theorem endpoint_unitary {n : Type*} [Fintype n] [DecidableEq n]
    (steps : List (Matrix n n Complex))
    (hsteps : ∀ U ∈ steps, IsUnitary U) :
    IsUnitary (endpoint steps) := by
  induction steps with
  | nil => exact isUnitary_one
  | cons U steps ih =>
      apply IsUnitary.mul
      · exact ih (fun V hV => hsteps V (by simp [hV]))
      · exact hsteps U (by simp)

/-- Every partial micromotion endpoint is unitary when every full-schedule
substep is unitary. -/
theorem partialEndpoint_unitary {n : Type*} [Fintype n] [DecidableEq n]
    (steps : List (Matrix n n Complex))
    (hsteps : ∀ U ∈ steps, IsUnitary U) (s : Nat) :
    IsUnitary (partialEndpoint steps s) := by
  apply endpoint_unitary
  intro U hU
  exact hsteps U (List.mem_of_mem_take hU)

/-! ## Endpoint non-injectivity fixture -/

/-- Exact two-channel flip used as a nontrivial unitary pulse. -/
def flip : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]

/-- A nontrivial two-pulse history. -/
def pulseSchedule : List (Matrix (Fin 2) (Fin 2) Complex) := [flip, flip]

/-- A pointwise idle history of the same length. -/
def idleSchedule : List (Matrix (Fin 2) (Fin 2) Complex) := [1, 1]

theorem flip_unitary : IsUnitary flip := by
  constructor <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [flip, Matrix.mul_apply, Fin.sum_univ_two]

theorem pulseSchedule_unitary :
    ∀ U ∈ pulseSchedule, IsUnitary U := by
  intro U hU
  have hUflip : U = flip := by
    simpa [pulseSchedule] using hU
  simpa [hUflip] using flip_unitary

/-- The pulse and idle histories are genuinely different. -/
theorem pulseSchedule_ne_idleSchedule : pulseSchedule ≠ idleSchedule := by
  intro h
  have hhead := congrArg List.head? h
  have hflip : flip = (1 : Matrix (Fin 2) (Fin 2) Complex) := by
    simpa [pulseSchedule, idleSchedule] using hhead
  have h00 := congr_fun (congr_fun hflip 0) 0
  norm_num [flip, Matrix.one_apply] at h00

/-- Two distinct micromotion histories can have exactly the same endpoint. -/
theorem endpoint_not_injective_witness :
    pulseSchedule ≠ idleSchedule ∧
      endpoint pulseSchedule = endpoint idleSchedule := by
  refine ⟨pulseSchedule_ne_idleSchedule, ?_⟩
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pulseSchedule, idleSchedule, endpoint, flip, Matrix.mul_apply,
      Fin.sum_univ_two]

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule.endpoint_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule.partialEndpoint_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms partialEndpoint_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule.endpoint_not_injective_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms endpoint_not_injective_witness

end PhysicsSM.Draft.NullEdge.FloquetMicromotionSchedule
