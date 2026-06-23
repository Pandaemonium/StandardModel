import Mathlib.Tactic

/-!
# P9 weighted Laplacian energy core

This module integrates Aristotle project
`23a1472a-e255-48b5-9314-6b13b6286af1`.

Scientific role: Tier-A finite Hodge energy identity for P9. For diagonal
finite metrics, the weighted 1-Laplacian pairing splits into the down-energy
and up-energy squares. This is the finite sum-of-squares identity needed before
the harmonic statement `ker L1 = ker d1 cap ker d0star` is meaningful.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9WeightedLaplacianEnergy

open BigOperators

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

theorem dotW_self_nonneg {k : Nat} (w v : Cochain k) (hw : forall i, 0 <= w i) :
    0 <= dotW w v v := by
  unfold dotW
  refine Finset.sum_nonneg fun i _ => ?_
  have := hw i
  nlinarith [mul_self_nonneg (v i)]

theorem weighted_lap1_energy_eq_down_plus_up
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1)
    (hw0 : forall a, w0 a != 0)
    (hw1 : forall i, w1 i != 0) :
    dotW w1 (lap1 w0 w1 w2 d0 d1 x) x =
      dotW w0 (codiff w0 w1 d0 x) (codiff w0 w1 d0 x) +
        dotW w2 (coboundary d1 x) (coboundary d1 x) := by
  have hadd : dotW w1 (lap1 w0 w1 w2 d0 d1 x) x
      = dotW w1 (coboundary d0 (codiff w0 w1 d0 x)) x
        + dotW w1 (codiff w1 w2 d1 (coboundary d1 x)) x := by
    unfold lap1 dotW addCochain
    rw [<- Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun i _ => by ring
  rw [hadd, weighted_adjoint_coboundary_codiff w0 w1 d0 _ x hw0,
    dotW_comm w1 (codiff w1 w2 d1 (coboundary d1 x)) x,
    <- weighted_adjoint_coboundary_codiff w1 w2 d1 x (coboundary d1 x) hw1]

theorem weighted_lap1_energy_nonneg
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1)
    (hw0 : forall a, w0 a != 0)
    (hw1 : forall i, w1 i != 0)
    (h0nonneg : forall a, 0 <= w0 a)
    (h2nonneg : forall f, 0 <= w2 f) :
    0 <= dotW w1 (lap1 w0 w1 w2 d0 d1 x) x := by
  rw [weighted_lap1_energy_eq_down_plus_up w0 w1 w2 d0 d1 x hw0 hw1]
  exact add_nonneg (dotW_self_nonneg _ _ h0nonneg) (dotW_self_nonneg _ _ h2nonneg)

end PhysicsSM.Draft.NullEdgeP9WeightedLaplacianEnergy

end
