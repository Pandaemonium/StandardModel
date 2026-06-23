import Mathlib.Tactic

/-!
# P9 edge-neighbor finite reach scaffold

Focused Aristotle target for the P9 source-visibility route.

Scientific role: the strengthened program treats finite locality as effective,
not fundamental bounded valency. The finite relation `edgeNeighborN` is a
bounded-link locality predicate: an edge is locally visible when its endpoint
diamond contains at most `N` intermediate events. This file isolates the finite
algebra needed to use such a relation as a response-kernel support guardrail.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9EdgeNeighborReach

abbrev Vec (n : Nat) := Fin n -> Real

def dot {n : Nat} (x y : Vec n) : Real :=
  Finset.univ.sum fun i => x i * y i

def applyKernel {n : Nat} (K : Fin n -> Fin n -> Real) (x : Vec n) : Vec n :=
  fun i => Finset.univ.sum fun j => K i j * x j

def response {n : Nat} (K : Fin n -> Fin n -> Real) (x y : Vec n) : Real :=
  dot y (applyKernel K x)

def KernelSupported {n : Nat}
    (rel : Fin n -> Fin n -> Prop) (K : Fin n -> Fin n -> Real) : Prop :=
  forall i j, Not (rel i j) -> K i j = 0

def SupportedIn {n : Nat} (S : Fin n -> Prop) (x : Vec n) : Prop :=
  forall i, Not (S i) -> x i = 0

def intervalCard {n : Nat} (rel : Fin n -> Fin n -> Prop) (i j : Fin n) : Nat :=
  by
    classical
    exact (Finset.univ.filter fun k => rel i k /\ rel k j).card

def edgeNeighborN {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (N : Nat) (i j : Fin n) : Prop :=
  rel i j /\ intervalCard rel i j <= N

def inducedRel {n : Nat} (S : Fin n -> Prop)
    (rel : Fin n -> Fin n -> Prop) (i j : Fin n) : Prop :=
  S i /\ S j /\ rel i j

def ReachExactly {n : Nat} (step : Fin n -> Fin n -> Prop)
    (source : Fin n -> Prop) : Nat -> Fin n -> Prop
  | 0, i => source i
  | Nat.succ m, i => exists j, step i j /\ ReachExactly step source m j

def iterateApply {n : Nat} (K : Fin n -> Fin n -> Real) :
    Nat -> Vec n -> Vec n
  | 0, x => x
  | Nat.succ m, x => applyKernel K (iterateApply K m x)

def responseAtStep {n : Nat} (K : Fin n -> Fin n -> Real)
    (m : Nat) (x y : Vec n) : Real :=
  dot y (iterateApply K m x)

theorem edgeNeighborN_subrelation
    {n : Nat} (rel : Fin n -> Fin n -> Prop) (N : Nat) :
    forall i j, edgeNeighborN rel N i j -> rel i j := by
  sorry

theorem edgeNeighborN_induced_of_original
    {n : Nat} (rel : Fin n -> Fin n -> Prop) (S : Fin n -> Prop)
    (N : Nat) :
    forall i j,
      S i -> S j -> edgeNeighborN rel N i j ->
        edgeNeighborN (inducedRel S rel) N i j := by
  sorry

theorem kernelSupported_edgeNeighborN_to_rel
    {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (N : Nat) (K : Fin n -> Fin n -> Real)
    (hK : KernelSupported (edgeNeighborN rel N) K) :
    KernelSupported rel K := by
  sorry

theorem iterateApply_supported_in_exact_reach
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (m : Nat) (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x) :
    SupportedIn (ReachExactly step source m) (iterateApply K m x) := by
  sorry

theorem responseAtStep_zero_of_target_outside_exact_reach
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real)
    (source target : Fin n -> Prop)
    (m : Nat) (x y : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x)
    (hy : SupportedIn target y)
    (hout : forall i, target i -> Not (ReachExactly step source m i)) :
    responseAtStep K m x y = 0 := by
  sorry

end NullEdgeP9EdgeNeighborReach

end
