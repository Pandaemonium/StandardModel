import Mathlib

/-!
# A basis-invariant observable of equal-endpoint micromotion

Endpoint equality alone forgets an ordered Floquet history. This module defines
the trace of the first partial endpoint. It is invariant under a simultaneous
unitary basis change, yet distinguishes a flip-flip loop from an idle-idle loop
even though both complete periods end at the identity.

This observable is not a topological winding number and is not invariant under
a change of Floquet time frame. It is the smallest exact anti-collapse fixture
that a future winding invariant must refine.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FloquetMicromotionObservable

open Matrix Complex

def IsUnitary {n : Type*} [Fintype n] [DecidableEq n]
    (U : Matrix n n Complex) : Prop := Uᴴ * U = 1 ∧ U * Uᴴ = 1

def endpoint {n : Type*} [Fintype n] [DecidableEq n] :
    List (Matrix n n Complex) -> Matrix n n Complex
  | [] => 1
  | U :: steps => endpoint steps * U

def firstPulseTrace {n : Type*} [Fintype n] [DecidableEq n]
    (steps : List (Matrix n n Complex)) : Complex :=
  match steps with
  | [] => 0
  | U :: _ => Matrix.trace U

def conjugateSchedule {n : Type*} [Fintype n] [DecidableEq n]
    (S : Matrix n n Complex) (steps : List (Matrix n n Complex)) :
    List (Matrix n n Complex) :=
  steps.map fun U => S * U * Sᴴ

/-- The first-pulse trace is independent of a simultaneous unitary basis. -/
theorem firstPulseTrace_conjugate {n : Type*} [Fintype n] [DecidableEq n]
    (S : Matrix n n Complex) (hS : IsUnitary S)
    (steps : List (Matrix n n Complex)) :
    firstPulseTrace (conjugateSchedule S steps) = firstPulseTrace steps := by
  cases steps with
  | nil => simp [conjugateSchedule, firstPulseTrace]
  | cons U steps =>
      rcases hS with ⟨hSleft, _⟩
      simp only [conjugateSchedule, List.map_cons, firstPulseTrace]
      calc
        Matrix.trace (S * U * Sᴴ) = Matrix.trace (Sᴴ * S * U) :=
          Matrix.trace_mul_cycle S U Sᴴ
        _ = Matrix.trace U := by rw [hSleft, one_mul]

def flip : Matrix (Fin 2) (Fin 2) Complex := !![0, 1; 1, 0]

def pulseLoop : List (Matrix (Fin 2) (Fin 2) Complex) := [flip, flip]

def idleLoop : List (Matrix (Fin 2) (Fin 2) Complex) := [1, 1]

theorem equal_endpoints : endpoint pulseLoop = endpoint idleLoop := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [pulseLoop, idleLoop, endpoint, flip, Matrix.mul_apply,
      Fin.sum_univ_two]

theorem firstPulseTrace_pulse : firstPulseTrace pulseLoop = 0 := by
  simp [firstPulseTrace, pulseLoop, flip, Matrix.trace, Fin.sum_univ_two]

theorem firstPulseTrace_idle : firstPulseTrace idleLoop = 2 := by
  simp [firstPulseTrace, idleLoop, Matrix.trace]

/-- Equal Floquet endpoints do not determine this basis-invariant observable. -/
theorem equal_endpoint_distinct_micromotion :
    endpoint pulseLoop = endpoint idleLoop ∧
      Ne (firstPulseTrace pulseLoop) (firstPulseTrace idleLoop) := by
  refine ⟨equal_endpoints, ?_⟩
  rw [firstPulseTrace_pulse, firstPulseTrace_idle]
  norm_num

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetMicromotionObservable.firstPulseTrace_conjugate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms firstPulseTrace_conjugate

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetMicromotionObservable.equal_endpoint_distinct_micromotion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms equal_endpoint_distinct_micromotion

end PhysicsSM.Draft.NullEdge.FloquetMicromotionObservable
