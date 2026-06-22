import PhysicsSM.Spinor.PluckerMass

noncomputable section

namespace NullEdgeGramWeightedOperator

open BigOperators
open Matrix Complex
open PhysicsSM.Spinor.PluckerMass

/--
Visible momentum obtained by tracing hidden labels with a finite internal Gram
matrix.
-/
def operatorGramWeightedVisibleMomentum {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) : Matrix (Fin 2) (Fin 2) Complex :=
  fun a b =>
    Finset.univ.sum fun i : Fin n =>
      Finset.univ.sum fun j : Fin n =>
        G i j * psi i a * (starRingEnd Complex) (psi j b)

/-- Visible quadratic form `v^dagger P v`. -/
def visibleQuadraticForm
    (P : Matrix (Fin 2) (Fin 2) Complex) (v : CSpinor) : Complex :=
  Finset.univ.sum fun a : Fin 2 =>
    Finset.univ.sum fun b : Fin 2 =>
      (starRingEnd Complex) (v a) * P a b * v b

/-- Hidden Gram quadratic form `c^dagger G c`. -/
def gramQuadraticForm {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex)
    (c : Fin n -> Complex) : Complex :=
  Finset.univ.sum fun i : Fin n =>
    Finset.univ.sum fun j : Fin n =>
      (starRingEnd Complex) (c i) * G i j * c j

/-- Projection of a visible test spinor onto each visible spinor in the family. -/
def spinorProjection {n : Nat}
    (psi : Fin n -> CSpinor) (v : CSpinor) : Fin n -> Complex :=
  fun i =>
    Finset.univ.sum fun a : Fin 2 =>
      (starRingEnd Complex) (psi i a) * v a

/-- Finite positive-semidefiniteness for a hidden Gram form. -/
def GramPositiveSemidefinite {n : Nat}
    (G : Matrix (Fin n) (Fin n) Complex) : Prop :=
  ∀ c : Fin n -> Complex,
    0 ≤ (gramQuadraticForm G c).re ∧
      (gramQuadraticForm G c).im = 0

/-- Finite positive-semidefiniteness for a visible `2 x 2` momentum operator. -/
def VisiblePositiveSemidefinite
    (P : Matrix (Fin 2) (Fin 2) Complex) : Prop :=
  ∀ v : CSpinor,
    0 ≤ (visibleQuadraticForm P v).re ∧
      (visibleQuadraticForm P v).im = 0

/--
The visible quadratic form of the Gram-weighted momentum is exactly the hidden
Gram quadratic form of the projected visible test spinor.
-/
theorem visibleQuadraticForm_gramWeighted_eq_gramQuadraticForm
    {n : Nat} (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor) (v : CSpinor) :
    visibleQuadraticForm (operatorGramWeightedVisibleMomentum G psi) v =
      gramQuadraticForm G (spinorProjection psi v) := by
  sorry

/--
Finite hidden positive-semidefiniteness descends to visible
positive-semidefiniteness after tracing hidden labels.
-/
theorem gramPositiveSemidefinite_implies_visiblePositiveSemidefinite
    {n : Nat} (G : Matrix (Fin n) (Fin n) Complex)
    (psi : Fin n -> CSpinor)
    (hG : GramPositiveSemidefinite G) :
    VisiblePositiveSemidefinite
      (operatorGramWeightedVisibleMomentum G psi) := by
  sorry

end NullEdgeGramWeightedOperator

end
