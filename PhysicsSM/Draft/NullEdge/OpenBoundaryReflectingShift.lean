import Mathlib

/-!
# A strictly local unitary shift completed by boundary memory

The state records a site and an oriented propagation channel. In the bulk a
right channel moves right and a left channel moves left. At either open end the
update stays at that endpoint for one substep and flips the channel. The
boundary channel is therefore the finite-dimensional memory that restores
bijectivity without imposing periodic momentum-space folding.

This is a one-dimensional seed. Tensoring three copies and adding a local Pauli
coin is a later theorem; no Weyl, no-doubling, or three-dimensional claim is
made here.
-/

namespace PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

abbrev State (N : Nat) := Bool × Fin (N + 1)

def incClamp {N : Nat} (x : Fin (N + 1)) : Fin (N + 1) :=
  if h : x.val < N then ⟨x.val + 1, by omega⟩ else x

def decClamp {N : Nat} (x : Fin (N + 1)) : Fin (N + 1) :=
  if h : x.val = 0 then x else ⟨x.val - 1, by omega⟩

/-- One reflecting open-boundary substep. `true` is the right-moving channel. -/
def step {N : Nat} (s : State N) : State N :=
  match s with
  | (true, x) => if x.val = N then (false, x) else (true, incClamp x)
  | (false, x) => if x.val = 0 then (true, x) else (false, decClamp x)

/-- Explicit reverse substep. -/
def stepInv {N : Nat} (s : State N) : State N :=
  match s with
  | (true, x) => if x.val = 0 then (false, x) else (true, decClamp x)
  | (false, x) => if x.val = N then (true, x) else (false, incClamp x)

theorem stepInv_step {N : Nat} (s : State N) : stepInv (step s) = s := by
  rcases s with ⟨d, x⟩
  cases d with
  | false =>
      by_cases h0 : x.val = 0
      · simp [step, stepInv, h0]
      · have hxpos : 0 < x.val := Nat.pos_of_ne_zero h0
        have hpredlt : x.val - 1 < N := by omega
        have hpredne : Ne (x.val - 1) N := by omega
        have hsubadd : x.val - 1 + 1 = x.val := by omega
        simp [step, stepInv, incClamp, decClamp, h0, hpredlt, hpredne,
          hsubadd]
  | true =>
      by_cases htop : x.val = N
      · simp [step, stepInv, htop]
      · have hlt : x.val < N := by omega
        simp [step, stepInv, incClamp, decClamp, htop, hlt]

theorem step_stepInv {N : Nat} (s : State N) : step (stepInv s) = s := by
  rcases s with ⟨d, x⟩
  cases d with
  | false =>
      by_cases htop : x.val = N
      · simp [step, stepInv, htop]
      · have hlt : x.val < N := by omega
        simp [step, stepInv, incClamp, decClamp, htop, hlt]
  | true =>
      by_cases h0 : x.val = 0
      · simp [step, stepInv, h0]
      · have hxpos : 0 < x.val := Nat.pos_of_ne_zero h0
        have hpredlt : x.val - 1 < N := by omega
        have hpredne : Ne (x.val - 1) N := by omega
        have hsubadd : x.val - 1 + 1 = x.val := by omega
        simp [step, stepInv, incClamp, decClamp, h0, hpredlt, hpredne,
          hsubadd]

/-- The open-boundary update is a permutation, hence its linear lift is unitary. -/
def stepEquiv (N : Nat) : Equiv.Perm (State N) where
  toFun := step
  invFun := stepInv
  left_inv := stepInv_step
  right_inv := step_stepInv

/-- Every primitive substep changes position by at most one lattice edge. -/
theorem step_local {N : Nat} (s : State N) :
    Int.natAbs ((step s).2.val - s.2.val) <= 1 := by
  rcases s with ⟨d, x⟩
  cases d with
  | false =>
      by_cases h0 : x.val = 0
      · simp [step, h0]
      · simp [step, decClamp, h0]
        omega
  | true =>
      by_cases htop : x.val = N
      · simp [step, htop]
      · have hlt : x.val < N := by omega
        simp [step, incClamp, htop, hlt]

/-- Away from the right boundary, a right channel advances exactly one site. -/
theorem step_right_interior {N : Nat} (x : Fin (N + 1)) (hx : x.val < N) :
    step (true, x) = (true, ⟨x.val + 1, by omega⟩) := by
  have hne : Ne x.val N := by omega
  simp [step, incClamp, hx, hne]

/-- Away from the left boundary, a left channel retreats exactly one site. -/
theorem step_left_interior {N : Nat} (x : Fin (N + 1)) (hx : 0 < x.val) :
    step (false, x) = (false, ⟨x.val - 1, by omega⟩) := by
  have hval : Ne x.val 0 := by omega
  simp [step, decClamp, hval]

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.stepInv_step' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stepInv_step

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.stepEquiv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stepEquiv

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.step_local' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms step_local

/-- info: 'PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.step_right_interior' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms step_right_interior

end PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift
