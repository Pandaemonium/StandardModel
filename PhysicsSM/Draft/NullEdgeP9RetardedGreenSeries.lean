import Mathlib.Tactic

/-!
# P9 finite retarded Green series

This draft module records a finite response-law scaffold for the P9
source-visibility route.

If a finite retarded kernel is nilpotent on a vector after `H` steps, then the
finite Neumann/retarded series terminates and solves the discrete equation
`(I - K) G_H x = x`. This is a finite algebraic response law, not a claim of a
continuum Green function.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries

abbrev Vec (n : Nat) := Fin n -> Real

def applyKernel {n : Nat} (K : Fin n -> Fin n -> Real) (x : Vec n) : Vec n :=
  fun i => Finset.univ.sum fun j => K i j * x j

def iterateApply {n : Nat} (K : Fin n -> Fin n -> Real) :
    Nat -> Vec n -> Vec n
  | 0, x => x
  | Nat.succ m, x => applyKernel K (iterateApply K m x)

def vecAdd {n : Nat} (x y : Vec n) : Vec n :=
  fun i => x i + y i

def vecSub {n : Nat} (x y : Vec n) : Vec n :=
  fun i => x i - y i

def vecZero {n : Nat} : Vec n :=
  fun _ => 0

def retardedSeries {n : Nat}
    (K : Fin n -> Fin n -> Real) (H : Nat) (x : Vec n) : Vec n :=
  fun i => Finset.range H |>.sum fun m => iterateApply K m x i

def oneMinusK {n : Nat} (K : Fin n -> Fin n -> Real) (y : Vec n) : Vec n :=
  vecSub y (applyKernel K y)

theorem applyKernel_vecSum_range
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (H : Nat) (F : Nat -> Vec n) :
    applyKernel K (fun i => Finset.range H |>.sum fun m => F m i) =
      fun i => Finset.range H |>.sum fun m => applyKernel K (F m) i := by
  ext i
  unfold applyKernel
  simp only [Finset.mul_sum]
  rw [Finset.sum_comm]

theorem applyKernel_iterateApply
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (m : Nat) (x : Vec n) :
    applyKernel K (iterateApply K m x) = iterateApply K (m + 1) x := by
  rfl

theorem oneMinusK_retardedSeries_eq_initial_sub_terminal
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (H : Nat) (x : Vec n) :
    oneMinusK K (retardedSeries K H x) = vecSub x (iterateApply K H x) := by
  ext i
  unfold oneMinusK vecSub retardedSeries
  have hlin :=
    congrFun (applyKernel_vecSum_range K H (fun m => iterateApply K m x)) i
  simp only [applyKernel_iterateApply] at hlin
  rw [hlin]
  have hsum :
      (Finset.range H).sum (fun m => iterateApply K m x i) -
          (Finset.range H).sum (fun m => iterateApply K (m + 1) x i) =
        (Finset.range H).sum (fun m =>
          iterateApply K m x i - iterateApply K (m + 1) x i) := by
    exact (Finset.sum_sub_distrib
      (s := Finset.range H)
      (f := fun m => iterateApply K m x i)
      (g := fun m => iterateApply K (m + 1) x i)).symm
  rw [hsum]
  exact Finset.sum_range_sub' (fun m => iterateApply K m x i) H

theorem oneMinusK_retardedSeries_eq_of_nilpotent
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (H : Nat) (x : Vec n)
    (_hH : 0 < H)
    (hNil : iterateApply K H x = 0) :
    oneMinusK K (retardedSeries K H x) = x := by
  rw [oneMinusK_retardedSeries_eq_initial_sub_terminal, hNil]
  ext i
  simp [vecSub]

theorem retardedSeries_is_right_inverse_on_nilpotent_vector
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (H : Nat) (x : Vec n)
    (hH : 0 < H)
    (hNil : iterateApply K H x = 0) :
    vecSub (retardedSeries K H x) (applyKernel K (retardedSeries K H x)) = x := by
  exact oneMinusK_retardedSeries_eq_of_nilpotent K H x hH hNil

end PhysicsSM.Draft.NullEdgeP9RetardedGreenSeries

end
