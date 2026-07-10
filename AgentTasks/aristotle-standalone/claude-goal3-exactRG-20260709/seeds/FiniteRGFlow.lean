/-
# Finite RG flow scaffold

DRAFT (kernel-clean). This module is the D4 dynamics seed: once a one-step
blocking/Schur-decimation map has been kernelized, simulations need a theorem
shape for many steps. The module is intentionally generic: any finite blocking
step `step : State -> State` generates an orbit, and one-step invariants or
monotone observables propagate along every iterate.

This is the bridge from the existing one-step `RGSchurMassWitness` theorem to
multi-step rigorous RG simulations. It does not itself identify the physical
carrier state space, prove convergence, prove a thermodynamic limit, or prove a
mass gap. Those are later D4/D5 targets.

Provenance: in-repo clean-room D4 formalization from the 2026-07-08 dynamics
guidance. PhysLean provides the model of mature dynamical-system APIs; this file
keeps the finite RG iteration scaffold local and elementary.
-/

import Mathlib

namespace PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow

variable {State Value : Type*}

/-- The trajectory produced by repeatedly applying a finite RG/blocking step. -/
def orbit (step : State → State) (x : State) : ℕ → State
  | 0 => x
  | n + 1 => step (orbit step x n)

@[simp] theorem orbit_zero (step : State → State) (x : State) :
    orbit step x 0 = x := rfl

@[simp] theorem orbit_succ (step : State → State) (x : State) (n : ℕ) :
    orbit step x (n + 1) = step (orbit step x n) := rfl

/-- A predicate that is preserved by one RG/blocking step. -/
def StepPreserves (step : State → State) (P : State → Prop) : Prop :=
  ∀ x, P x → P (step x)

/-- **D4 invariant propagation.** Any one-step invariant holds along the entire
finite RG orbit. -/
theorem invariant_orbit (step : State → State) (P : State → Prop)
    (hstep : StepPreserves step P) {x : State} (hx : P x) (n : ℕ) :
    P (orbit step x n) := by
  induction n with
  | zero => simpa
  | succ n ih => simpa [orbit_succ] using hstep (orbit step x n) ih

/-- A numerical or symbolic observable that is exactly preserved by one RG step. -/
def ObservableInvariant (step : State → State) (obs : State → Value) : Prop :=
  ∀ x, obs (step x) = obs x

/-- **D4 conserved observable propagation.** One-step conservation implies
conservation along all finite RG iterates. -/
theorem observable_invariant_orbit (step : State → State) (obs : State → Value)
    (hobs : ObservableInvariant step obs) (x : State) (n : ℕ) :
    obs (orbit step x n) = obs x := by
  induction n with
  | zero => simp
  | succ n ih =>
      rw [orbit_succ, hobs, ih]

/-- A preorder-valued observable that never increases under one RG step. -/
def ObservableAntitone [Preorder Value] (step : State → State)
    (obs : State → Value) : Prop :=
  ∀ x, obs (step x) ≤ obs x

/-- **D4 monotone observable propagation.** One-step monotonicity controls the
observable along all finite RG iterates. -/
theorem observable_antitone_orbit [Preorder Value] (step : State → State)
    (obs : State → Value) (hobs : ObservableAntitone step obs) (x : State)
    (n : ℕ) :
    obs (orbit step x n) ≤ obs x := by
  induction n with
  | zero => simp
  | succ n ih =>
      exact le_trans (hobs (orbit step x n)) ih

/-! ## Local axiom guard (self-contained) -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow.invariant_orbit' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms invariant_orbit

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow.observable_antitone_orbit' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms observable_antitone_orbit

end PhysicsSM.Draft.NullEdge.Carrier.FiniteRGFlow
