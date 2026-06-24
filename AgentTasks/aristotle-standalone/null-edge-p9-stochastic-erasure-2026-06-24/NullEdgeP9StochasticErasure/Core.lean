import Mathlib.Tactic

/-!
# Concrete Stochastic Erasure is Not Exactly Recoverable

We define a concrete stochastic channel `T_erase` from `Fin 2` to `Fin 1`
and two distinct distributions `pDist` and `qDist` on `Fin 2`.
Since `T_erase` erases the difference (both map to the unique distribution on `Fin 1`),
we prove using `erased_pair_not_exactRecoverable` that this pair is not exactly recoverable.
-/

namespace NullEdgeP9StochasticErasure.Core

open BigOperators

structure FinDist (Omega : Type*) [Fintype Omega] where
  p : Omega -> Real
  nonneg : forall x, 0 <= p x
  sum_one : Finset.univ.sum p = 1

@[ext] theorem FinDist.ext {Omega : Type*} [Fintype Omega] :
    ∀ {d1 d2 : FinDist Omega}, d1.p = d2.p → d1 = d2
  | ⟨_, _, _⟩, ⟨_, _, _⟩, h => by cases h; rfl

structure Stoch (Omega Kappa : Type*) [Fintype Omega] [Fintype Kappa] where
  M : Kappa -> Omega -> Real
  nonneg : forall y x, 0 <= M y x
  col_sum : forall x, Finset.univ.sum (fun y => M y x) = 1

noncomputable def Stoch.apply {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (d : FinDist Omega) : FinDist Kappa where
  p := fun y => Finset.univ.sum fun x => T.M y x * d.p x
  nonneg := by
    intro y
    exact Finset.sum_nonneg fun x _ => mul_nonneg (T.nonneg y x) (d.nonneg x)
  sum_one := by
    calc
      Finset.univ.sum (fun y => Finset.univ.sum fun x => T.M y x * d.p x)
          = Finset.univ.sum (fun x => Finset.univ.sum fun y => T.M y x * d.p x) := by
            rw [Finset.sum_comm]
      _ = Finset.univ.sum (fun x => d.p x) := by
            refine Finset.sum_congr rfl ?_
            intro x _
            rw [<- Finset.sum_mul, T.col_sum x, one_mul]
      _ = 1 := d.sum_one

def PairExactRecoverable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega) : Prop :=
  exists R : Stoch Kappa Omega,
    R.apply (T.apply p) = p /\ R.apply (T.apply q) = q

theorem erased_pair_not_exactRecoverable {Omega Kappa : Type*}
    [Fintype Omega] [Fintype Kappa]
    (T : Stoch Omega Kappa) (p q : FinDist Omega)
    (herase : T.apply p = T.apply q) (hneq : p = q -> False) :
    PairExactRecoverable T p q -> False := by
  intro hrec
  cases hrec with
  | intro R h =>
  cases h with
  | intro hp hq =>
  apply hneq
  rw [<- hp, <- hq, herase]

def pDist : FinDist (Fin 2) where
  p := fun x => if x.val = 0 then 1 else 0
  nonneg := by
    intro x
    split_ifs <;> linarith
  sum_one := by
    rw [Fin.sum_univ_two]
    norm_num

def qDist : FinDist (Fin 2) where
  p := fun x => if x.val = 1 then 1 else 0
  nonneg := by
    intro x
    split_ifs <;> linarith
  sum_one := by
    rw [Fin.sum_univ_two]
    norm_num

theorem p_ne_q : pDist = qDist -> False := by
  intro h
  have heq : pDist.p 0 = qDist.p 0 := by rw [h]
  unfold pDist qDist at heq
  dsimp at heq
  simp at heq

def T_erase : Stoch (Fin 2) (Fin 1) where
  M := fun _ _ => 1
  nonneg := fun _ _ => by linarith
  col_sum := by
    intro x
    have h : (Finset.univ : Finset (Fin 1)) = {0} := rfl
    rw [h]
    simp

theorem T_erase_app_p_eq_q : T_erase.apply pDist = T_erase.apply qDist := by
  ext y
  unfold Stoch.apply
  dsimp
  rw [Fin.sum_univ_two, Fin.sum_univ_two]
  simp [pDist, qDist, T_erase]

theorem erased_pair_concrete_not_exactRecoverable :
    PairExactRecoverable T_erase pDist qDist -> False :=
  erased_pair_not_exactRecoverable T_erase pDist qDist T_erase_app_p_eq_q p_ne_q

end NullEdgeP9StochasticErasure.Core
