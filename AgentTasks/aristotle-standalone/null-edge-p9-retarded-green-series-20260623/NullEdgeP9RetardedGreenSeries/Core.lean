import Mathlib.Tactic

/-!
# P9 finite retarded Green series scaffold

Focused Aristotle target for the P9 source-visibility route.

Scientific role: once a finite retarded kernel is nilpotent on a diamond, the
formal retarded response series terminates. This is the finite algebraic
prototype of a retarded Green operator: `(I - K) (sum_{m < H} K^m x) = x` when
`K^H x = 0`.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9RetardedGreenSeries

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
  sorry

theorem applyKernel_iterateApply
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (m : Nat) (x : Vec n) :
    applyKernel K (iterateApply K m x) = iterateApply K (m + 1) x := by
  sorry

theorem oneMinusK_retardedSeries_eq_of_nilpotent
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (H : Nat) (x : Vec n)
    (hH : 0 < H)
    (hNil : iterateApply K H x = 0) :
    oneMinusK K (retardedSeries K H x) = x := by
  sorry

theorem retardedSeries_is_right_inverse_on_nilpotent_vector
    {n : Nat} (K : Fin n -> Fin n -> Real)
    (H : Nat) (x : Vec n)
    (hH : 0 < H)
    (hNil : iterateApply K H x = 0) :
    vecSub (retardedSeries K H x) (applyKernel K (retardedSeries K H x)) = x := by
  sorry

end NullEdgeP9RetardedGreenSeries

end
