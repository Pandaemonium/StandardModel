import Mathlib.Tactic

/-!
# P9 retarded nilpotent reach scaffold

Focused Aristotle target for the P9 source-visibility route.

Scientific role: causal-set response operators are often retarded and nonlocal.
On a finite diamond, a genuinely acyclic retarded support relation should have a
finite propagation horizon: after more steps than the available rank height, no
signal can remain. This file isolates that finite support theorem independently
of any continuum interpretation.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9RetardedNilpotentReach

abbrev Vec (n : Nat) := Fin n -> Real

def applyKernel {n : Nat} (K : Fin n -> Fin n -> Real) (x : Vec n) : Vec n :=
  fun i => Finset.univ.sum fun j => K i j * x j

def KernelSupported {n : Nat}
    (rel : Fin n -> Fin n -> Prop) (K : Fin n -> Fin n -> Real) : Prop :=
  forall i j, Not (rel i j) -> K i j = 0

def SupportedIn {n : Nat} (S : Fin n -> Prop) (x : Vec n) : Prop :=
  forall i, Not (S i) -> x i = 0

def ReachExactly {n : Nat} (step : Fin n -> Fin n -> Prop)
    (source : Fin n -> Prop) : Nat -> Fin n -> Prop
  | 0, i => source i
  | Nat.succ m, i => exists j, step i j /\ ReachExactly step source m j

def iterateApply {n : Nat} (K : Fin n -> Fin n -> Real) :
    Nat -> Vec n -> Vec n
  | 0, x => x
  | Nat.succ m, x => applyKernel K (iterateApply K m x)

def RankDecreases {n : Nat} (rank : Fin n -> Nat)
    (step : Fin n -> Fin n -> Prop) : Prop :=
  forall i j, step i j -> rank j < rank i

theorem applyKernel_vanishes_off_reach
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x) :
    SupportedIn (ReachExactly step source 1) (applyKernel K x) := by
  sorry

theorem iterateApply_supported_in_exact_reach
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (m : Nat) (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x) :
    SupportedIn (ReachExactly step source m) (iterateApply K m x) := by
  sorry

theorem no_reach_beyond_rank
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (source : Fin n -> Prop) (rank : Fin n -> Nat)
    (hr : RankDecreases rank step) :
    forall m i, rank i < m -> Not (ReachExactly step source m i) := by
  sorry

theorem iterateApply_eq_zero_beyond_rank
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (rank : Fin n -> Nat) (H : Nat) (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x)
    (hr : RankDecreases rank step)
    (hH : forall i, rank i < H) :
    iterateApply K H x = 0 := by
  sorry

end NullEdgeP9RetardedNilpotentReach

end
