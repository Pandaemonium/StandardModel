import Mathlib.Tactic

/-!
# P9 weighted projector residual orthogonality

This focused file extends the P9 Hodge-projector scaffold. A weighted
self-adjoint idempotent projector gives an actual weighted orthogonal
decomposition: harmonic/coarse tests see only the projected source, and the
residual is invisible to projected tests.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9WeightedProjectorResidualOrthogonal

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
  sorry

/-- The residual source is weighted-orthogonal to every projected test. -/
theorem weighted_residual_orthogonal_to_projected
    {n : Nat} (w : Cochain n) (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjointW w Pi)
    (hidemp : Idempotent Pi) :
    dotW w (subCochain source (lin Pi source)) (lin Pi test) = 0 := by
  sorry

/-- Weighted projected tests decompose a source into projected plus residual parts. -/
theorem weighted_projected_test_pairing_decomposition
    {n : Nat} (w : Cochain n) (Pi : Fin n -> Fin n -> Real)
    (source test : Cochain n)
    (hself : SelfAdjointW w Pi)
    (hidemp : Idempotent Pi) :
    dotW w source (lin Pi test) =
      dotW w (lin Pi source) (lin Pi test) +
        dotW w (subCochain source (lin Pi source)) (lin Pi test) := by
  sorry

end NullEdgeP9WeightedProjectorResidualOrthogonal

end
