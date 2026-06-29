import PhysicsSM.Draft.NullEdge.GateC1.FiniteBlockDiagonalGap

/-!
# Generic finite Fourier Parseval bridge

This draft module isolates the finite linear-algebra part of the Gate C1
Fourier lane.

The main theorem,
`rawFourier_l2NormSq_of_column_orthogonality`, says that any finite character
table whose columns satisfy the orthogonality relation

`sum_m conj (chi m x) * chi m y = coeff * delta_xy`

has the expected raw Parseval identity for spinor-valued fields.  The concrete
equal-side tetrahedral torus should later instantiate this theorem using the
`SiteN`/`MomN` additive-character orthogonality lemmas.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace FiniteFourierParseval

open scoped BigOperators
open TetraScalarWilsonSymbol
open FiniteBlockDiagonalGap

/-- Matrix whose rows are momentum labels and whose columns are site labels. -/
def characterMatrix {Site Mom : Type*} (chi : Mom -> Site -> ℂ) :
    Matrix Mom Site ℂ :=
  fun m x => chi m x

/-- Generic unnormalized finite Fourier transform with kernel `chi`. -/
def rawFourierGeneric {Site Mom Spin : Type*} [Fintype Site]
    (chi : Mom -> Site -> ℂ)
    (Psi : Site -> Spin -> ℂ) : Mom -> Spin -> ℂ :=
  fun m s => ∑ x : Site, chi m x * Psi x s

/--
Rectangular finite L2 bridge.

If `A^* A = coeff I`, then applying the rectangular matrix `A` multiplies the
finite L2 norm square by `coeff`.  This is the non-square version of the
matrix-vector bridge used in the scalar Wilson symbol file.
-/
theorem l2NormSq_mulVec_of_star_mul_eq_smul_one_rect
    {rows cols : Type*} [Fintype rows] [Fintype cols] [DecidableEq cols]
    (A : Matrix rows cols ℂ) (coeff : ℝ)
    (hA : Matrix.conjTranspose A * A =
      ((coeff : ℝ) : ℂ) • (1 : Matrix cols cols ℂ))
    (v : cols -> ℂ) :
    l2NormSq (A.mulVec v) = coeff * l2NormSq v := by
  apply Complex.ofReal_injective
  calc
    ((l2NormSq (A.mulVec v) : ℝ) : ℂ)
        = star (A.mulVec v) ⬝ᵥ A.mulVec v := l2NormSq_complex (A.mulVec v)
    _ = Matrix.vecMul (star v) (Matrix.conjTranspose A) ⬝ᵥ
          A.mulVec v := by
          rw [Matrix.star_mulVec]
    _ = Matrix.vecMul (Matrix.vecMul (star v) (Matrix.conjTranspose A)) A ⬝ᵥ
          v := by
          rw [Matrix.dotProduct_mulVec]
    _ = Matrix.vecMul (star v) (Matrix.conjTranspose A * A) ⬝ᵥ v := by
          rw [Matrix.vecMul_vecMul]
    _ = Matrix.vecMul (star v) (((coeff : ℝ) : ℂ) •
          (1 : Matrix cols cols ℂ)) ⬝ᵥ v := by
          rw [hA]
    _ = (((coeff : ℝ) : ℂ) • star v) ⬝ᵥ v := by
          simp [Matrix.vecMul_smul, Matrix.vecMul_one]
    _ = ((coeff * l2NormSq v : ℝ) : ℂ) := by
          unfold dotProduct l2NormSq
          simp [Complex.normSq_eq_conj_mul_self, Finset.mul_sum, mul_assoc]

/-- Column orthogonality, packaged as `A^* A = coeff I`. -/
theorem characterMatrix_star_mul_of_column_orthogonality
    {Site Mom : Type*} [Fintype Mom] [DecidableEq Site]
    (chi : Mom -> Site -> ℂ) (coeff : ℝ)
    (horth :
      ∀ x y : Site,
        ∑ m : Mom, star (chi m x) * chi m y =
          if x = y then ((coeff : ℝ) : ℂ) else 0) :
    Matrix.conjTranspose (characterMatrix chi) * characterMatrix chi =
      ((coeff : ℝ) : ℂ) • (1 : Matrix Site Site ℂ) := by
  ext x y
  rw [Matrix.mul_apply]
  change (∑ m : Mom, star (chi m x) * chi m y) =
    ((((coeff : ℝ) : ℂ) • (1 : Matrix Site Site ℂ)) x y)
  rw [horth]
  by_cases hxy : x = y
  · simp [characterMatrix, Matrix.conjTranspose, hxy]
  · simp [characterMatrix, Matrix.conjTranspose, hxy]

/-- Scalar raw Parseval from finite column orthogonality. -/
theorem scalarRawFourier_l2NormSq_of_column_orthogonality
    {Site Mom : Type*} [Fintype Site] [Fintype Mom] [DecidableEq Site]
    (chi : Mom -> Site -> ℂ) (coeff : ℝ)
    (horth :
      ∀ x y : Site,
        ∑ m : Mom, star (chi m x) * chi m y =
          if x = y then ((coeff : ℝ) : ℂ) else 0)
    (f : Site -> ℂ) :
    l2NormSq (fun m : Mom => ∑ x : Site, chi m x * f x) =
      coeff * l2NormSq f := by
  simpa [characterMatrix, Matrix.mulVec, dotProduct] using
    l2NormSq_mulVec_of_star_mul_eq_smul_one_rect
      (characterMatrix chi) coeff
      (characterMatrix_star_mul_of_column_orthogonality chi coeff horth) f

/--
Spinor-valued raw Parseval from finite column orthogonality.

This is the generic theorem intended for the concrete tetrahedral Fourier
adapter: once the `SiteN`/`MomN` kernel proves the column-orthogonality
hypothesis with `coeff = Fintype.card (SiteN N)`, raw Parseval follows by a
coordinatewise application over the finite spin index.
-/
theorem rawFourier_l2NormSq_of_column_orthogonality
    {Site Mom Spin : Type*}
    [Fintype Site] [Fintype Mom] [Fintype Spin] [DecidableEq Site]
    (chi : Mom -> Site -> ℂ) (coeff : ℝ)
    (horth :
      ∀ x y : Site,
        ∑ m : Mom, star (chi m x) * chi m y =
          if x = y then ((coeff : ℝ) : ℂ) else 0)
    (Psi : Site -> Spin -> ℂ) :
    blockL2NormSq (rawFourierGeneric chi Psi) =
      coeff * ∑ x : Site, l2NormSq (Psi x) := by
  unfold blockL2NormSq rawFourierGeneric l2NormSq
  calc
    ∑ m : Mom, ∑ s : Spin,
        Complex.normSq (∑ x : Site, chi m x * Psi x s)
        = ∑ s : Spin, ∑ m : Mom,
            Complex.normSq (∑ x : Site, chi m x * Psi x s) := by
          rw [Finset.sum_comm]
    _ = ∑ s : Spin, coeff * ∑ x : Site, Complex.normSq (Psi x s) := by
          apply Finset.sum_congr rfl
          intro s _hs
          simpa [l2NormSq] using
            scalarRawFourier_l2NormSq_of_column_orthogonality
              chi coeff horth (fun x : Site => Psi x s)
    _ = coeff * ∑ s : Spin, ∑ x : Site, Complex.normSq (Psi x s) := by
          rw [Finset.mul_sum]
    _ = coeff * ∑ x : Site, ∑ s : Spin, Complex.normSq (Psi x s) := by
          rw [Finset.sum_comm]

end FiniteFourierParseval
end GateC1
end NullEdge
end Draft
end PhysicsSM
