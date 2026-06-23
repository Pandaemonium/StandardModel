import Mathlib.Tactic

/-!
# P9 weighted 1-Laplacian self-adjointness

This module integrates Aristotle project
`bfbb0923-97d7-4966-9051-53e69c3b4d75`.

Scientific role: this extends the explicit finite Hodge scaffold for the P9
source-visibility program. The weighted energy theorem gives the diagonal
sum-of-squares pairing. This module proves the bilinear companion and
self-adjointness of the explicit weighted 1-Laplacian, which is the finite
algebra needed before using its spectral subspaces as observer-channel coarse
modes.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9WeightedLap1SelfAdjoint

abbrev Cochain (n : Nat) := Fin n -> Real

def dotW {n : Nat} (w x y : Cochain n) : Real :=
  Finset.univ.sum fun i => w i * x i * y i

def addCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i + y i

def coboundary {m n : Nat} (D : Fin n -> Fin m -> Real)
    (x : Cochain m) : Cochain n :=
  fun i => Finset.univ.sum fun a => D i a * x a

def codiff {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real) (y : Cochain n) : Cochain m :=
  fun a => Inv.inv (wM a) * Finset.univ.sum fun i => wN i * D i a * y i

def lap1 {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1) : Cochain n1 :=
  addCochain
    (coboundary d0 (codiff w0 w1 d0 x))
    (codiff w1 w2 d1 (coboundary d1 x))

theorem weighted_adjoint_coboundary_codiff
    {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real)
    (x : Cochain m) (y : Cochain n)
    (hwM : forall a, wM a != 0) :
    dotW wN (coboundary D x) y =
      dotW wM x (codiff wM wN D y) := by
  unfold dotW coboundary codiff
  simp only [Finset.sum_mul, Finset.mul_sum]
  rw [Finset.sum_comm]
  refine Finset.sum_congr rfl fun a _ => Finset.sum_congr rfl fun i _ => ?_
  have ha : Not (wM a = 0) := by simpa using hwM a
  field_simp

theorem dotW_comm {k : Nat} (w u v : Cochain k) : dotW w u v = dotW w v u := by
  unfold dotW
  exact Finset.sum_congr rfl fun i _ => by ring

theorem dotW_lap1_bilinear_eq_down_plus_up
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x y : Cochain n1)
    (hw0 : forall a, w0 a != 0)
    (hw1 : forall i, w1 i != 0) :
    dotW w1 (lap1 w0 w1 w2 d0 d1 x) y =
      dotW w0 (codiff w0 w1 d0 x) (codiff w0 w1 d0 y) +
        dotW w2 (coboundary d1 x) (coboundary d1 y) := by
  have hsplit :
      dotW w1 (lap1 w0 w1 w2 d0 d1 x) y =
        dotW w1 (coboundary d0 (codiff w0 w1 d0 x)) y +
          dotW w1 (codiff w1 w2 d1 (coboundary d1 x)) y := by
    unfold lap1 dotW addCochain
    rw [<- Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun i _ => by ring
  rw [hsplit,
    weighted_adjoint_coboundary_codiff w0 w1 d0 (codiff w0 w1 d0 x) y hw0,
    dotW_comm w1 (codiff w1 w2 d1 (coboundary d1 x)) y,
    <- weighted_adjoint_coboundary_codiff w1 w2 d1 y (coboundary d1 x) hw1,
    dotW_comm w2 (coboundary d1 y) (coboundary d1 x)]

/-- The explicit weighted 1-Laplacian is self-adjoint for the weighted pairing. -/
theorem weighted_lap1_selfAdjoint
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x y : Cochain n1)
    (hw0 : forall a, w0 a != 0)
    (hw1 : forall i, w1 i != 0) :
    dotW w1 (lap1 w0 w1 w2 d0 d1 x) y =
      dotW w1 x (lap1 w0 w1 w2 d0 d1 y) := by
  rw [dotW_lap1_bilinear_eq_down_plus_up w0 w1 w2 d0 d1 x y hw0 hw1,
    dotW_comm w1 x (lap1 w0 w1 w2 d0 d1 y),
    dotW_lap1_bilinear_eq_down_plus_up w0 w1 w2 d0 d1 y x hw0 hw1,
    dotW_comm w0 (codiff w0 w1 d0 y) (codiff w0 w1 d0 x),
    dotW_comm w2 (coboundary d1 y) (coboundary d1 x)]

end PhysicsSM.Draft.NullEdgeP9WeightedLap1SelfAdjoint

end
