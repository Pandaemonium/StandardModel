import Mathlib.Tactic

/-!
# P9 retarded nilpotent reach scaffold

This draft module records a finite retarded-support theorem for the P9
source-visibility route.

If a response kernel is supported on a finite relation that strictly decreases
a rank function, then exact propagation has a finite horizon: after more steps
than the available rank height, no point is reachable and the iterated response
kernel vanishes.

This is a discrete-first theorem. It does not require a microscopic continuum
interpretation; it supplies a finite acyclic-retarded guardrail for later
causal-diamond response models.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach

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
      exact applyKernel_vanishes_off_reach step K
        (ReachExactly step source m) (iterateApply K m x) hK (ih x hx)

theorem no_reach_beyond_rank
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (source : Fin n -> Prop) (rank : Fin n -> Nat)
    (hr : RankDecreases rank step) :
    forall m i, rank i < m -> Not (ReachExactly step source m i) := by
  intro m
  induction m with
  | zero =>
      intro i hi _hreach
      exact Nat.not_lt_zero (rank i) hi
  | succ m ih =>
      intro i hi hreach
      cases hreach with
      | intro j hj =>
          cases hj with
          | intro hstep htail =>
              have hj_lt_i : rank j < rank i := hr i j hstep
              have hi_le_m : rank i <= m := Nat.lt_succ_iff.mp hi
              have hj_lt_m : rank j < m := Nat.lt_of_lt_of_le hj_lt_i hi_le_m
              exact ih j hj_lt_m htail

theorem iterateApply_eq_zero_beyond_rank
    {n : Nat} (step : Fin n -> Fin n -> Prop)
    (K : Fin n -> Fin n -> Real) (source : Fin n -> Prop)
    (rank : Fin n -> Nat) (H : Nat) (x : Vec n)
    (hK : KernelSupported step K)
    (hx : SupportedIn source x)
    (hr : RankDecreases rank step)
    (hH : forall i, rank i < H) :
    iterateApply K H x = 0 := by
  ext i
  have hsupp :
      SupportedIn (ReachExactly step source H) (iterateApply K H x) :=
    iterateApply_supported_in_exact_reach step K source H x hK hx
  exact hsupp i (no_reach_beyond_rank step source rank hr H i (hH i))

end PhysicsSM.Draft.NullEdgeP9RetardedNilpotentReach

end
