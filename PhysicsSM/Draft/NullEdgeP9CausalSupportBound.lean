import Mathlib.Tactic

/-!
# P9 causal support bound for finite response kernels

This draft module records a small finite guardrail for the P9
source-visibility route.

The theorem says that a response kernel supported inside a finite causal
relation cannot send a source outside the discrete causal reach of that source.
Consequently, causally separated source and target supports have zero response.

This is intentionally modest: it is not a gravity theorem. It is a finite
domain-of-dependence check for the source/noise response layer, preventing a
purely algebraic response kernel from carrying signal outside the relation that
is supposed to encode causal reach.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9CausalSupportBound

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
  intro i hi
  unfold applyKernel
  apply Finset.sum_eq_zero
  intro j _hj
  by_cases hs : source j
  case pos =>
    have hrel : Not (rel i j) := by
      intro hij
      exact hi (Exists.intro j (And.intro hs hij))
    rw [hK i j hrel, zero_mul]
  case neg =>
    rw [hx j hs, mul_zero]

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
  unfold response dot
  apply Finset.sum_eq_zero
  intro i _hi
  by_cases ht : target i
  case pos =>
    have hout : Not (Reaches rel source i) := by
      intro hreach
      cases hreach with
      | intro j hj =>
        cases hj with
        | intro hs hij =>
          exact hsep i j ht hs hij
    have hsupp : SupportedIn (Reaches rel source) (applyKernel K x) :=
      applyKernel_vanishes_off_reach rel K source x hK hx
    rw [hsupp i hout, mul_zero]
  case neg =>
    rw [hy i ht, zero_mul]

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
  have hsep : CausallySeparated rel target source := by
    intro i j ht hs hij
    exact hout i ht (Exists.intro j (And.intro hs hij))
  exact response_zero_of_causally_separated_supports rel K source target x y hK hx hy hsep

end PhysicsSM.Draft.NullEdgeP9CausalSupportBound

end
