import Mathlib

/-!
# Exact rank-four polynomial selector from isolated finite spectrum

This focused target supplies the missing constructive half of the intrinsic
probe-sector interface. For a finite diagonalizable operator with pairwise
distinct real eigenvalues, Lagrange interpolation should produce an exact
polynomial projector onto any selected eigenvalue set. A four-element set then
has a four-dimensional, basis-free polynomial-filter range.

The result does not prove that a causal-order operator has the required simple
spectrum, a quantitative gap, Lorentzian inertia on the selected range, or
refinement stability. It makes those assumptions explicit and gives the exact
selector they imply.
-/

open Polynomial

noncomputable section

namespace RankFourSelector

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Coordinate-diagonal real-linear endomorphism with eigenvalue table
`eigenvalue`. -/
def diagonalOperator (eigenvalue : ι → Real) :
    Module.End Real (ι → Real) where
  toFun v i := eigenvalue i * v i
  map_add' v w := by
    funext i
    simp [mul_add]
  map_smul' r v := by
    funext i
    simp [mul_assoc, mul_left_comm]

/-- Evaluate a real polynomial at an endomorphism. -/
def polynomialFilter (A : Module.End Real (ι → Real)) (p : Real[X]) :
    Module.End Real (ι → Real) :=
  aeval A p

/-- Lagrange basis polynomial equal to one at `eigenvalue i` and zero at all
other eigenvalues. -/
def lagrangeBasis (eigenvalue : ι → Real) (i : ι) : Real[X] :=
  ∏ j ∈ Finset.univ.erase i,
    C ((eigenvalue i - eigenvalue j)⁻¹) * (X - C (eigenvalue j))

/-- Polynomial indicator of a finite selected eigenvalue set. -/
def selectorPolynomial (eigenvalue : ι → Real) (selected : Finset ι) :
    Real[X] :=
  ∑ i ∈ selected, lagrangeBasis eigenvalue i

/-- Coordinate projector onto the selected indices. -/
def coordinateProjector (selected : Finset ι) :
    Module.End Real (ι → Real) where
  toFun v i := if i ∈ selected then v i else 0
  map_add' v w := by
    funext i
    by_cases hi : i ∈ selected <;> simp [hi]
  map_smul' r v := by
    funext i
    by_cases hi : i ∈ selected <;> simp [hi]

/-- Scalar Lagrange interpolation at the listed eigenvalues. -/
theorem eval_lagrangeBasis
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (i j : ι) :
    (lagrangeBasis eigenvalue i).eval (eigenvalue j) =
      if j = i then 1 else 0 := by
  sorry

/-- The selector polynomial is the characteristic function of `selected` on
the finite spectrum. -/
theorem eval_selectorPolynomial
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) (j : ι) :
    (selectorPolynomial eigenvalue selected).eval (eigenvalue j) =
      if j ∈ selected then 1 else 0 := by
  sorry

/-- Polynomial functional calculus of a coordinate-diagonal operator acts
pointwise by scalar polynomial evaluation. -/
theorem polynomialFilter_diagonal_apply
    (eigenvalue : ι → Real) (p : Real[X]) (v : ι → Real) (j : ι) :
    polynomialFilter (diagonalOperator eigenvalue) p v j =
      p.eval (eigenvalue j) * v j := by
  sorry

/-- **Exact selector.** The Lagrange polynomial filter is exactly the
coordinate projector onto the selected eigenspaces. -/
theorem polynomialFilter_selector_eq_coordinateProjector
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) :
    polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected) =
      coordinateProjector selected := by
  sorry

/-- Coordinate selection is idempotent. -/
theorem coordinateProjector_idempotent (selected : Finset ι) :
    (coordinateProjector selected).comp (coordinateProjector selected) =
      coordinateProjector selected := by
  sorry

/-- The selected coordinate range has dimension equal to the number of
selected eigenvalues. -/
theorem finrank_range_coordinateProjector (selected : Finset ι) :
    Module.finrank Real (LinearMap.range (coordinateProjector selected)) =
      selected.card := by
  sorry

/-- The polynomial selector is idempotent. -/
theorem polynomialFilter_selector_idempotent
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) :
    (polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected)).comp
          (polynomialFilter (diagonalOperator eigenvalue)
            (selectorPolynomial eigenvalue selected)) =
      polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected) := by
  sorry

/-- **Rank-four capstone.** Four isolated selected eigenvalues give an exact
idempotent polynomial filter with four-dimensional range. -/
theorem rankFour_polynomial_selector
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) (hcard : selected.card = 4) :
    (polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected)).comp
          (polynomialFilter (diagonalOperator eigenvalue)
            (selectorPolynomial eigenvalue selected)) =
        polynomialFilter (diagonalOperator eigenvalue)
          (selectorPolynomial eigenvalue selected) ∧
      Module.finrank Real
          (LinearMap.range
            (polynomialFilter (diagonalOperator eigenvalue)
              (selectorPolynomial eigenvalue selected))) = 4 := by
  sorry

end RankFourSelector
