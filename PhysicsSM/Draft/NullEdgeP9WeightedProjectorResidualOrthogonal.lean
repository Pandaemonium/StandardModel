import Mathlib.Tactic

/-!
# P9 weighted projector residual orthogonality

This module integrates Aristotle project
`d9318fe9-73b3-4e86-9553-95cbf3b4cc9b`.

Scientific role: this is a finite Hodge/coarse-mode algebra lemma for the P9
source-visibility program. A weighted self-adjoint idempotent projector gives a
weighted orthogonal decomposition: projected observer-channel tests see only
the projected source, while the residual is invisible to those projected tests.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal

abbrev Cochain (n : Nat) := Fin n -> Real

def dotW {n : Nat} (w x y : Cochain n) : Real :=
  Finset.univ.sum fun i => w i * x i * y i

def lin {n : Nat} (Pi : Fin n -> Fin n -> Real) (x : Cochain n) : Cochain n :=
  fun i => Finset.univ.sum fun j => Pi i j * x j

def subCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i - y i

def SelfAdjointW {n : Nat} (w : Cochain n)
    (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x y : Cochain n, dotW w (lin Pi x) y = dotW w x (lin Pi y)

def Idempotent {n : Nat} (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x : Cochain n, lin Pi (lin Pi x) = lin Pi x

/-- Weighted projected tests see the projected source. -/
theorem weighted_projected_pairing_eq
    {n : Nat} (w : Cochain n) (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjointW w Pi)
    (hidemp : Idempotent Pi) :
    dotW w source (lin Pi test) =
      dotW w (lin Pi source) (lin Pi test) := by
  rw [hself source (lin Pi test), hidemp test]

/-- The residual source is weighted-orthogonal to every projected test. -/
theorem weighted_residual_orthogonal_to_projected
    {n : Nat} (w : Cochain n) (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjointW w Pi)
    (hidemp : Idempotent Pi) :
    dotW w (subCochain source (lin Pi source)) (lin Pi test) = 0 := by
  have hpair := weighted_projected_pairing_eq w Pi source test hself hidemp
  have hsub : dotW w (subCochain source (lin Pi source)) (lin Pi test)
      = dotW w source (lin Pi test)
        - dotW w (lin Pi source) (lin Pi test) := by
    simp only [dotW, subCochain]
    rw [<- Finset.sum_sub_distrib]
    apply Finset.sum_congr rfl
    intro i _
    ring
  rw [hsub, hpair, sub_self]

/-- Weighted projected tests decompose a source into projected plus residual parts. -/
theorem weighted_projected_test_pairing_decomposition
    {n : Nat} (w : Cochain n) (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjointW w Pi)
    (hidemp : Idempotent Pi) :
    dotW w source (lin Pi test) =
      dotW w (lin Pi source) (lin Pi test) +
        dotW w (subCochain source (lin Pi source)) (lin Pi test) := by
  rw [weighted_residual_orthogonal_to_projected w Pi source test hself hidemp,
    add_zero, weighted_projected_pairing_eq w Pi source test hself hidemp]

end PhysicsSM.Draft.NullEdgeP9WeightedProjectorResidualOrthogonal

end
