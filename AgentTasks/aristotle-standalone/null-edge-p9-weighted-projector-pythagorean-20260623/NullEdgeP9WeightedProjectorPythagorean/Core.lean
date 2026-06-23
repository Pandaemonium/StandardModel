import Mathlib.Tactic

/-!
# P9 weighted projector Pythagorean identity

This focused file follows the weighted projector residual-orthogonality result.
For a weighted self-adjoint idempotent projector, the source norm splits into a
projected/coarse part and an orthogonal residual part. In P9 language this is
the finite noise/energy decomposition behind observer-channel source
visibility.
-/

noncomputable section

open scoped BigOperators

namespace NullEdgeP9WeightedProjectorPythagorean

abbrev Cochain (n : Nat) := Fin n -> Real

def dotW {n : Nat} (w x y : Cochain n) : Real :=
  Finset.univ.sum fun i => w i * x i * y i

def lin {n : Nat} (Pi : Fin n -> Fin n -> Real) (x : Cochain n) : Cochain n :=
  fun i => Finset.univ.sum fun j => Pi i j * x j

def subCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i - y i

def addCochain {n : Nat} (x y : Cochain n) : Cochain n :=
  fun i => x i + y i

def SelfAdjointW {n : Nat} (w : Cochain n)
    (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x y : Cochain n, dotW w (lin Pi x) y = dotW w x (lin Pi y)

def Idempotent {n : Nat} (Pi : Fin n -> Fin n -> Real) : Prop :=
  forall x : Cochain n, lin Pi (lin Pi x) = lin Pi x

theorem dotW_comm {n : Nat} (w x y : Cochain n) :
    dotW w x y = dotW w y x := by
  unfold dotW
  apply Finset.sum_congr rfl
  intro i _
  ring

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
  sorry

/-- A source is the sum of its projected component and residual. -/
theorem source_eq_projected_plus_residual
    {n : Nat} (Pi : Fin n -> Fin n -> Real) (source : Cochain n) :
    source = addCochain (lin Pi source) (subCochain source (lin Pi source)) := by
  sorry

/--
Weighted Pythagorean identity for the projected source plus residual
decomposition.
-/
theorem weighted_projector_pythagorean
    {n : Nat} (w : Cochain n) (Pi : Fin n -> Fin n -> Real)
    (source : Cochain n)
    (hself : SelfAdjointW w Pi)
    (hidemp : Idempotent Pi) :
    dotW w source source =
      dotW w (lin Pi source) (lin Pi source) +
        dotW w (subCochain source (lin Pi source))
          (subCochain source (lin Pi source)) := by
  sorry

end NullEdgeP9WeightedProjectorPythagorean

end
