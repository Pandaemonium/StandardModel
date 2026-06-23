import Mathlib.Tactic

/-!
# P9 weighted adjoint core

Standalone Aristotle target. The intended live-repo destination is
`PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore`.

Scientific role: first Tier-A finite Hodge ingredient for P9. With diagonal
positive finite metrics on adjacent cochain spaces, the explicit codifferential
is the weighted adjoint of the coboundary.
-/

noncomputable section

namespace NullEdgeP9WeightedAdjointCore

open BigOperators

abbrev Cochain (n : Nat) := Fin n -> Real

def dotW {n : Nat} (w x y : Cochain n) : Real :=
  Finset.univ.sum fun i => w i * x i * y i

def coboundary {m n : Nat} (D : Fin n -> Fin m -> Real)
    (x : Cochain m) : Cochain n :=
  fun i => Finset.univ.sum fun a => D i a * x a

def codiff {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real) (y : Cochain n) : Cochain m :=
  fun a => (wM a)⁻¹ * Finset.univ.sum fun i => wN i * D i a * y i

theorem weighted_adjoint_coboundary_codiff
    {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real)
    (x : Cochain m) (y : Cochain n)
    (hwM : forall a, wM a != 0) :
    dotW wN (coboundary D x) y =
      dotW wM x (codiff wM wN D y) := by
  sorry

theorem codiff_zero_of_zero_target_metric
    {m n : Nat} (wM : Cochain m) (D : Fin n -> Fin m -> Real)
    (y : Cochain n) :
    codiff wM 0 D y = 0 := by
  sorry

end NullEdgeP9WeightedAdjointCore
