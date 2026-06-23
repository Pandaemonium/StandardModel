import Mathlib.Tactic

/-!
# P9 edge-neighbor finite reach scaffold

This draft module records the finite locality scaffold for the P9
source-visibility route.

The program should not assume fundamental bounded point valency. Instead, this
module treats `edgeNeighborN` as an effective link-locality relation: a link is
locally visible when its endpoint diamond contains at most `N` intermediate
events. The core theorem then says that iterated kernels supported on a step
relation cannot propagate a localized source outside exact finite step reach.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach

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
  intro i j h
  exact h.1

theorem edgeNeighborN_induced_of_original
    {n : Nat} (rel : Fin n -> Fin n -> Prop) (S : Fin n -> Prop)
    (N : Nat) :
    forall i j,
      S i -> S j -> edgeNeighborN rel N i j ->
        edgeNeighborN (inducedRel S rel) N i j := by
  intro i j hi hj h
  constructor
  case left =>
    exact And.intro hi (And.intro hj h.1)
  case right =>
    have hcard :
        intervalCard (inducedRel S rel) i j <= intervalCard rel i j := by
      unfold intervalCard
      classical
      apply Finset.card_le_card
      intro k hk
      simp only [Finset.mem_filter, Finset.mem_univ, true_and] at hk
      simp only [Finset.mem_filter, Finset.mem_univ, true_and]
      cases hk with
      | intro hik hkj =>
        exact And.intro hik.2.2 hkj.2.2
    exact le_trans hcard h.2

theorem kernelSupported_edgeNeighborN_to_rel
    {n : Nat} (rel : Fin n -> Fin n -> Prop)
    (N : Nat) (K : Fin n -> Fin n -> Real)
    (hK : KernelSupported (edgeNeighborN rel N) K) :
    KernelSupported rel K := by
  intro i j hrel
  apply hK
  intro hneighbor
  exact hrel hneighbor.1

private theorem applyKernel_supported_in_one_step_reach
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x) :
    SupportedIn (ReachExactly step source 1) (applyKernel K x) := by
  intro i hi
  unfold applyKernel
  apply Finset.sum_eq_zero
  intro j _hj
  by_cases hstep : step i j
  case pos =>
    by_cases hsource : source j
    case pos =>
      exact False.elim (hi (Exists.intro j (And.intro hstep hsource)))
    case neg =>
      rw [hx j hsource, mul_zero]
  case neg =>
    rw [hK i j hstep, zero_mul]

theorem iterateApply_supported_in_exact_reach
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (m : Nat) (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x) :
    SupportedIn (ReachExactly step source m) (iterateApply K m x) := by
  induction m generalizing x with
  | zero =>
      exact hx
  | succ m ih =>
      exact applyKernel_supported_in_one_step_reach step K
        (ReachExactly step source m) (iterateApply K m x) hK (ih x hx)

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
  unfold responseAtStep dot
  apply Finset.sum_eq_zero
  intro i _hi
  by_cases ht : target i
  case pos =>
    have hsupp :
        SupportedIn (ReachExactly step source m) (iterateApply K m x) :=
      iterateApply_supported_in_exact_reach step K source m x hK hx
    rw [hsupp i (hout i ht), mul_zero]
  case neg =>
    rw [hy i ht, zero_mul]

end PhysicsSM.Draft.NullEdgeP9EdgeNeighborReach

end
