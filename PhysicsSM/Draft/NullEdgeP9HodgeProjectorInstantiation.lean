import Mathlib.Tactic

/-!
# P9 Hodge-projector instantiation

This module integrates Aristotle project
`8f067f6a-5b77-47ed-be85-0bbe9c22b7db`.

Scientific role: previous P9 modules proved useful facts about abstract
self-adjoint projectors and about the weighted finite Hodge kernel. This file
bridges them: if a projector is self-adjoint, idempotent, and has range in the
finite Hodge harmonic sector, then it annihilates exact boundary bookkeeping.

This is the algebraic heart of the source-visibility claim: boundary-exact
source perturbations disappear after the harmonic observer-channel projection.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation

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

def lin {n : Nat} (Pi : Fin n -> Fin n -> Real) (x : Cochain n) : Cochain n :=
  fun i => Finset.univ.sum fun j => Pi i j * x j

def response {n : Nat} (K : Fin n -> Fin n -> Real) (x : Cochain n) : Real :=
  Finset.univ.sum fun i => Finset.univ.sum fun j => x i * K i j * x j

def Coclosed {n0 n1 : Nat} (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real) (x : Cochain n1) : Prop :=
  codiff w0 w1 d0 x = 0

def Closed {n1 n2 : Nat} (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1) : Prop :=
  coboundary d1 x = 0

def Harmonic {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (x : Cochain n1) : Prop :=
  Coclosed w0 w1 d0 x /\ Closed d1 x

def SelfAdjointW {n : Nat} (w : Cochain n)
    (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x y : Cochain n, dotW w (lin Pi x) y = dotW w x (lin Pi y)

def Idempotent {n : Nat} (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x : Cochain n, lin Pi (lin Pi x) = lin Pi x

def RangeHarmonic {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (Pi : Fin n1 -> Fin n1 -> Real) : Prop :=
  forall x : Cochain n1, Harmonic w0 w1 d0 d1 (lin Pi x)

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

theorem hodgeProjector_annihilates_exact
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (PiH : Fin n1 -> Fin n1 -> Real)
    (a : Cochain n0)
    (hw0 : forall v, w0 v != 0)
    (hw1pos : forall e, 0 < w1 e)
    (hself : SelfAdjointW w1 PiH)
    (hidemp : Idempotent PiH)
    (hrange : RangeHarmonic w0 w1 d0 d1 PiH) :
    lin PiH (coboundary d0 a) = 0 := by
  have h_coclosed :
      dotW w1 (lin PiH (coboundary d0 a)) (lin PiH (coboundary d0 a)) = 0 := by
    convert weighted_adjoint_coboundary_codiff w0 w1 d0 a
        (lin PiH (coboundary d0 a)) ?_ using 1
    next =>
      grind +locals
    next =>
      exact Eq.symm (by
        rw [show codiff w0 w1 d0 (lin PiH (coboundary d0 a)) = 0 from (hrange _).1]
        unfold dotW
        simp +decide)
    next =>
      assumption
  exact (dotW_self_eq_zero_iff_of_pos w1 (lin PiH (coboundary d0 a)) hw1pos).mp
    h_coclosed

theorem hodgeProjector_boundary_invariant
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (PiH : Fin n1 -> Fin n1 -> Real)
    (source : Cochain n1) (a : Cochain n0)
    (hw0 : forall v, w0 v != 0)
    (hw1pos : forall e, 0 < w1 e)
    (hself : SelfAdjointW w1 PiH)
    (hidemp : Idempotent PiH)
    (hrange : RangeHarmonic w0 w1 d0 d1 PiH) :
    lin PiH (addCochain source (coboundary d0 a)) = lin PiH source := by
  convert congr_arg (fun x => addCochain (lin PiH source) x)
      (hodgeProjector_annihilates_exact w0 w1 d0 d1 PiH a hw0 hw1pos
        hself hidemp hrange) using 1
  next =>
    ext i
    simp +decide [lin, addCochain, Finset.sum_add_distrib, mul_add]
  next =>
    exact funext fun _ => by simp +decide [addCochain]

theorem hodgeProjector_projectedResponse_boundary_invariant
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (PiH : Fin n1 -> Fin n1 -> Real)
    (K : Fin n1 -> Fin n1 -> Real)
    (source : Cochain n1) (a : Cochain n0)
    (hw0 : forall v, w0 v != 0)
    (hw1pos : forall e, 0 < w1 e)
    (hself : SelfAdjointW w1 PiH)
    (hidemp : Idempotent PiH)
    (hrange : RangeHarmonic w0 w1 d0 d1 PiH) :
    response K (lin PiH (addCochain source (coboundary d0 a))) =
      response K (lin PiH source) := by
  rw [hodgeProjector_boundary_invariant w0 w1 d0 d1 PiH source a hw0 hw1pos
    hself hidemp hrange]

theorem hodgeProjector_pairing_boundary_invariant
    {n0 n1 n2 : Nat}
    (w0 : Cochain n0) (w1 : Cochain n1)
    (d0 : Fin n1 -> Fin n0 -> Real)
    (d1 : Fin n2 -> Fin n1 -> Real)
    (PiH : Fin n1 -> Fin n1 -> Real)
    (source test : Cochain n1) (a : Cochain n0)
    (hw0 : forall v, w0 v != 0)
    (hw1pos : forall e, 0 < w1 e)
    (hself : SelfAdjointW w1 PiH)
    (hidemp : Idempotent PiH)
    (hrange : RangeHarmonic w0 w1 d0 d1 PiH) :
    dotW w1 (lin PiH (addCochain source (coboundary d0 a))) test =
      dotW w1 (lin PiH source) test := by
  have h_boundary_invariance :
      lin PiH (addCochain source (coboundary d0 a)) = lin PiH source := by
    apply hodgeProjector_boundary_invariant w0 w1 d0 d1 PiH source a hw0 hw1pos
      hself hidemp hrange
  rw [h_boundary_invariance]

end PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation

end
