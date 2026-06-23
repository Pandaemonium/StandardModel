import Mathlib.Tactic

/-!
# P9 weighted adjoint core

This module integrates Aristotle project
`32a7fb73-8801-453d-8f8c-5c794e4dbe30`.

Scientific role: first Tier-A finite Hodge ingredient for P9. With diagonal
positive finite metrics on adjacent cochain spaces, the explicit
codifferential is the weighted adjoint of the coboundary.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

def dotW {n : Nat} (w x y : Cochain n) : Real :=
  Finset.univ.sum fun i => w i * x i * y i

def coboundary {m n : Nat} (D : Fin n -> Fin m -> Real)
    (x : Cochain m) : Cochain n :=
  fun i => Finset.univ.sum fun a => D i a * x a

def codiff {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real) (y : Cochain n) : Cochain m :=
  fun a => Inv.inv (wM a) * Finset.univ.sum fun i => wN i * D i a * y i

theorem weighted_adjoint_coboundary_codiff
    {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real)
    (x : Cochain m) (y : Cochain n)
    (hwM : forall a, wM a != 0) :
    dotW wN (coboundary D x) y =
      dotW wM x (codiff wM wN D y) := by
  unfold dotW coboundary codiff
  have key :
      forall a i,
        wM a * x a * (Inv.inv (wM a) * (wN i * D i a * y i))
          = wN i * (D i a * x a) * y i := by
    intro a i
    have h : Not (wM a = 0) := by simpa using hwM a
    field_simp
  calc
    Finset.univ.sum (fun i => wN i * (Finset.univ.sum fun a => D i a * x a) * y i)
        = Finset.univ.sum
            (fun i => Finset.univ.sum fun a => wN i * (D i a * x a) * y i) := by
          refine Finset.sum_congr rfl fun i _ => ?_
          rw [Finset.mul_sum, Finset.sum_mul]
    _ = Finset.univ.sum
          (fun a => Finset.univ.sum fun i => wN i * (D i a * x a) * y i) := by
          exact Finset.sum_comm
    _ = Finset.univ.sum
          (fun a => wM a * x a *
            (Inv.inv (wM a) * Finset.univ.sum fun i => wN i * D i a * y i)) := by
          refine Finset.sum_congr rfl fun a _ => ?_
          rw [Finset.mul_sum, Finset.mul_sum]
          exact Finset.sum_congr rfl fun i _ => (key a i).symm

theorem codiff_zero_of_zero_target_metric
    {m n : Nat} (wM : Cochain m) (D : Fin n -> Fin m -> Real)
    (y : Cochain n) :
    codiff wM 0 D y = 0 := by
  funext a
  simp [codiff]

end PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore

end
