import Mathlib.Tactic

/-!
# P9 harmonic-kernel core

This module integrates Aristotle project
`0a6aa9da-d023-4af4-a70a-d966975b8b84`.

Scientific role: Tier-B finite Hodge ingredient for P9. Once the weighted
adjoint and weighted 1-Laplacian energy identities are available, the kernel of
the finite weighted 1-Laplacian is exactly the intersection of the closed and
coclosed 1-cochains. This is the first theorem that makes the P9
`ker d cap ker delta` slogan a precise finite statement rather than generic
vocabulary.

Convention notes:

* `codiff w0 w1 d0` is the codifferential adjacent to the degree-0/degree-1
  coboundary `d0`; it is the object called `delta1` in the P9 prose.
* No chain-complex law `d1 d0 = 0` is required for this algebraic kernel
  theorem. It should be added in the later topological/Hodge interpretation.
* Strict positivity of the source and face weights is required to turn a
  weighted square norm equal to zero into coordinatewise vanishing.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore

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
  fun a => (1 / wM a) * Finset.univ.sum fun i => wN i * D i a * y i

def lap1 {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1) : Cochain n1 :=
  addCochain
    (coboundary d0 (codiff w0 w1 d0 x))
    (codiff w1 w2 d1 (coboundary d1 x))

def Closed {n1 n2 : Nat} (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1) : Prop :=
  coboundary d1 x = 0

def Coclosed {n0 n1 : Nat} (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real) (x : Cochain n1) : Prop :=
  codiff w0 w1 d0 x = 0

def Harmonic {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1) : Prop :=
  lap1 w0 w1 w2 d0 d1 x = 0

theorem dotW_self_eq_zero_iff_of_pos
    {n : Nat} (w x : Cochain n)
    (hw : forall i, 0 < w i) :
    dotW w x x = 0 <-> x = 0 := by
  constructor
  next =>
    intro h
    ext i
    simp_all +decide [dotW]
    rw [Finset.sum_eq_zero_iff_of_nonneg
      fun i _ => by nlinarith only [hw i, mul_self_nonneg (x i)]] at h
    simpa [ne_of_gt (hw i)] using h i (Finset.mem_univ i)
  next =>
    intro _h
    unfold dotW
    aesop

theorem weighted_adjoint_coboundary_codiff
    {m n : Nat} (wM : Cochain m) (wN : Cochain n)
    (D : Fin n -> Fin m -> Real)
    (x : Cochain m) (y : Cochain n)
    (hwM : forall a, wM a != 0) :
    dotW wN (coboundary D x) y =
      dotW wM x (codiff wM wN D y) := by
  unfold dotW coboundary codiff
  simp +decide [Finset.mul_sum _ _ _, mul_assoc, mul_comm, mul_left_comm, div_eq_inv_mul]
  rw [Finset.sum_comm]
  grind

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
  unfold lap1
  simp +decide [dotW]
  unfold addCochain coboundary codiff
  simp +decide [
    Finset.sum_add_distrib, mul_add, mul_assoc, mul_comm, mul_left_comm,
    Finset.mul_sum _ _ _]
  congr! 1
  next =>
    rw [Finset.sum_comm]
    grind
  next =>
    rw [Finset.sum_comm]
    grind

theorem harmonic_iff_closed_and_coclosed
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1) (w2 : Cochain n2)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1)
    (hw0 : forall a, 0 < w0 a)
    (hw1 : forall i, 0 < w1 i)
    (hw2 : forall f, 0 < w2 f) :
    Harmonic w0 w1 w2 d0 d1 x <->
      Coclosed w0 w1 d0 x /\ Closed d1 x := by
  constructor
  next =>
    intro h_harmonic
    have h_dotW_zero : dotW w1 (lap1 w0 w1 w2 d0 d1 x) x = 0 := by
      convert congr_arg (fun y => dotW w1 y x) h_harmonic using 1
      unfold dotW
      norm_num
    have h_dotW_zero_sum :
        dotW w0 (codiff w0 w1 d0 x) (codiff w0 w1 d0 x) = 0 /\
          dotW w2 (coboundary d1 x) (coboundary d1 x) = 0 := by
      rw [weighted_lap1_energy_eq_down_plus_up] at h_dotW_zero
      next =>
        unfold dotW at *
        constructor <;> linarith [
          show 0 <= Finset.univ.sum
              (fun i => w0 i * codiff w0 w1 d0 x i * codiff w0 w1 d0 x i) from
            Finset.sum_nonneg fun i _ => by
              nlinarith only [hw0 i, mul_self_nonneg (codiff w0 w1 d0 x i)],
          show 0 <= Finset.univ.sum
              (fun i => w2 i * coboundary d1 x i * coboundary d1 x i) from
            Finset.sum_nonneg fun i _ => by
              nlinarith only [hw2 i, mul_self_nonneg (coboundary d1 x i)]]
      next =>
        exact fun a => by simpa using ne_of_gt (hw0 a)
      next =>
        exact fun i => by simpa using ne_of_gt (hw1 i)
    exact And.intro
      ((dotW_self_eq_zero_iff_of_pos w0 _ hw0).1 h_dotW_zero_sum.1)
      ((dotW_self_eq_zero_iff_of_pos w2 _ hw2).1 h_dotW_zero_sum.2)
  next =>
    intro h
    unfold Harmonic Coclosed Closed at *
    unfold lap1
    simp_all +decide [funext_iff]
    unfold addCochain
    simp_all +decide [coboundary, codiff]
    exact fun _ => Finset.sum_eq_zero fun j _ => by
      cases h.1 j <;> simp_all +decide [ne_of_gt]

end PhysicsSM.Draft.NullEdgeP9HarmonicKernelCore

end
