import RankFourSelector.IntrinsicRankFourLagrangeSelector

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
  sorry

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
  sorry

end PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector
