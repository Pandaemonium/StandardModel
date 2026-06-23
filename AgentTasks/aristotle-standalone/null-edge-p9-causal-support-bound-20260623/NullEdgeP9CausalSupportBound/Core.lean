import Mathlib.Tactic

/-!
# P9 causal support bound for finite response kernels

Focused Aristotle target for the P9 source-visibility route.

Scientific role: the C4 noise-kernel and Hodge-projector theorems are still
mostly finite linear algebra unless the response object respects causal
support. This file isolates the smallest finite guardrail: a kernel supported
inside a chosen causal relation cannot send a localized source outside the
discrete causal reach of that source.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9CausalSupportBound

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

def Reaches {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (S : Fin n -> Prop) (i : Fin n) : Prop :=
  exists j, S j /\ rel i j

def CausallySeparated {n : Nat}
    (rel : Fin n -> Fin n -> Prop)
    (target source : Fin n -> Prop) : Prop :=
  forall i j, target i -> source j -> Not (rel i j)

theorem applyKernel_vanishes_off_reach
    {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (x : Vec n)
    (hK : KernelSupported rel K)
    (hx : SupportedIn source x) :
    SupportedIn (Reaches rel source) (applyKernel K x) := by
  sorry

theorem response_zero_of_causally_separated_supports
    {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real)
    (source target : Fin n -> Prop)
    (x y : Vec n)
    (hK : KernelSupported rel K)
    (hx : SupportedIn source x)
    (hy : SupportedIn target y)
    (hsep : CausallySeparated rel target source) :
    response K x y = 0 := by
  sorry

theorem response_eq_zero_of_target_outside_reach
    {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real)
    (source target : Fin n -> Prop)
    (x y : Vec n)
    (hK : KernelSupported rel K)
    (hx : SupportedIn source x)
    (hy : SupportedIn target y)
    (hout : forall i, target i -> Not (Reaches rel source i)) :
    response K x y = 0 := by
  sorry

end NullEdgeP9CausalSupportBound

end
