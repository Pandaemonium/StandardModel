import PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector

/-!
# Quantitative stability of the intrinsic rank-four selector

A uniform spectral gap survives diagonal perturbations smaller than half the
gap. Consequently, the exact Lagrange polynomial continues to select a
four-dimensional range after perturbation.

This theorem is finite and algebraic. It does not establish a uniform gap for
the causal operator, control non-diagonal perturbations, or prove stability
under graph refinement.

Provenance: Aristotle project `6a0ba28d-c030-41d5-a2e2-a92f8c8004d5`,
clean-room formalization under the project conventions.
-/

open Polynomial

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- A uniform spectral gap and a perturbation smaller than half that gap
preserve simplicity of the diagonal spectrum. -/
theorem perturbed_injective_of_uniform_gap
    (eigenvalue perturbation : ι → Real) (delta : Real)
    (hdelta : 0 < delta)
    (hgap : ∀ i j, i ≠ j → delta ≤ |eigenvalue i - eigenvalue j|)
    (hpert : ∀ i, |perturbation i| < delta / 2) :
    Function.Injective (fun i => eigenvalue i + perturbation i) := by
  intro i j hij
  by_contra hne
  have heq : eigenvalue i - eigenvalue j = perturbation j - perturbation i := by
    linarith
  have hlower : delta ≤ |perturbation j - perturbation i| := by
    rw [← heq]
    exact hgap i j hne
  have hupper : |perturbation j - perturbation i| ≤
      |perturbation j| + |perturbation i| := abs_sub _ _
  linarith [hdelta, hpert i, hpert j]

/-- Quantitative stability of the rank-four polynomial selector under a
uniformly sub-gap diagonal perturbation. -/
theorem rankFour_polynomial_selector_stable
    (eigenvalue perturbation : ι → Real) (delta : Real)
    (hdelta : 0 < delta)
    (hgap : ∀ i j, i ≠ j → delta ≤ |eigenvalue i - eigenvalue j|)
    (hpert : ∀ i, |perturbation i| < delta / 2)
    (selected : Finset ι) (hcard : selected.card = 4) :
    (polynomialFilter (diagonalOperator (fun i => eigenvalue i + perturbation i))
        (selectorPolynomial (fun i => eigenvalue i + perturbation i) selected)).comp
          (polynomialFilter (diagonalOperator (fun i => eigenvalue i + perturbation i))
            (selectorPolynomial (fun i => eigenvalue i + perturbation i) selected)) =
        polynomialFilter (diagonalOperator (fun i => eigenvalue i + perturbation i))
          (selectorPolynomial (fun i => eigenvalue i + perturbation i) selected) ∧
      Module.finrank Real
          (LinearMap.range
            (polynomialFilter
              (diagonalOperator (fun i => eigenvalue i + perturbation i))
              (selectorPolynomial (fun i => eigenvalue i + perturbation i) selected))) = 4 := by
  exact rankFour_polynomial_selector
    (fun i => eigenvalue i + perturbation i)
    (perturbed_injective_of_uniform_gap eigenvalue perturbation delta hdelta hgap hpert)
    selected hcard

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.perturbed_injective_of_uniform_gap' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms perturbed_injective_of_uniform_gap

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rankFour_polynomial_selector_stable' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankFour_polynomial_selector_stable

end PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector
