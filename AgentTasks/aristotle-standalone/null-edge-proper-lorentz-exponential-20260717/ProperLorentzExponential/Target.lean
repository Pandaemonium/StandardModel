import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.SpecialFunctions.Exponential
import Mathlib.Tactic

noncomputable section

open NormedSpace
open scoped Matrix.Norms.Frobenius

namespace ProperLorentzExponential

/-- Mostly-minus spacetime metric in basis order `(0,1,2,3)`. -/
def eta : Matrix (Fin 4) (Fin 4) Real :=
  !![1, 0, 0, 0;
     0, -1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

/-- Matrix-level membership in `O(1,3)` for the mostly-minus metric. -/
def IsEtaLorentz (matrix : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  matrix.transpose * eta * matrix = eta

/-- Matrix-level membership in the Lorentz Lie algebra. -/
def IsLorentzLieAlgebra
    (generator : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  generator.transpose * eta + eta * generator = 0

/-- Proper eta-Lorentz membership. -/
def IsProperEtaLorentz
    (matrix : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  IsEtaLorentz matrix ∧ matrix.det = 1

/-- The mostly-minus metric is its own inverse. -/
theorem eta_sq : eta * eta = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [eta, Matrix.mul_apply, Fin.sum_univ_four]

/-- The mostly-minus metric is nonsingular. -/
theorem eta_det : eta.det = -1 := by
  have hEta : eta = Matrix.diagonal ![1, -1, -1, -1] := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp [eta, Matrix.diagonal]
  rw [hEta, Matrix.det_diagonal]
  simp +decide [Fin.prod_univ_four]

/-- The mostly-minus metric is a unit in the matrix ring. -/
theorem eta_isUnit : IsUnit eta := by
  rw [Matrix.isUnit_iff_isUnit_det, eta_det]
  exact isUnit_neg_one

/-- The nonsingular matrix inverse of the mostly-minus metric is itself. -/
theorem eta_inv : eta⁻¹ = eta := by
  apply eta_isUnit.mul_left_cancel
  rw [Matrix.mul_nonsing_inv eta]
  · exact eta_sq.symm
  · rw [eta_det]
    exact isUnit_neg_one

/-- Exponentiating a Lorentz Lie-algebra element stays eta-Lorentz. -/
theorem exp_isEtaLorentz
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) (t : Real) :
    IsEtaLorentz (NormedSpace.exp (t • generator)) := by
  let X : Matrix (Fin 4) (Fin 4) Real := t • generator
  have hX : IsLorentzLieAlgebra X := by
    have hScaled := congrArg (fun matrix => t • matrix) hGenerator
    simpa [X, IsLorentzLieAlgebra, Matrix.transpose_smul, Matrix.smul_mul,
      Matrix.mul_smul, smul_add] using hScaled
  have hTranspose : X.transpose = -(eta * X * eta) := by
    have hRight := congrArg (fun matrix => matrix * eta) hX
    have hSum : X.transpose + eta * X * eta = 0 := by
      simpa [IsLorentzLieAlgebra, add_mul, Matrix.mul_assoc, eta_sq] using hRight
    exact eq_neg_of_add_eq_zero_left hSum
  have hExpTranspose :
      NormedSpace.exp X.transpose =
        eta * NormedSpace.exp (-X) * eta := by
    have hConj := Matrix.exp_conj eta (-X) eta_isUnit
    rw [eta_inv] at hConj
    rw [hTranspose]
    simpa only [neg_mul, mul_neg, neg_neg] using hConj
  have hExpCancel :
      NormedSpace.exp (-X) * NormedSpace.exp X = 1 := by
    simpa using
      (Matrix.exp_add_of_commute (-X) X (Commute.refl X).neg_left).symm
  change IsEtaLorentz (NormedSpace.exp X)
  unfold IsEtaLorentz
  rw [← Matrix.exp_transpose, hExpTranspose]
  simp only [Matrix.mul_assoc, eta_sq, Matrix.one_mul, hExpCancel, Matrix.mul_one]

/-- The Lorentz exponential lies in the determinant-positive component. -/
theorem exp_det_eq_one
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) (t : Real) :
    (NormedSpace.exp (t • generator)).det = 1 := by
  let halfGenerator : Matrix (Fin 4) (Fin 4) Real := (t / 2) • generator
  have hHalfLorentz :
      IsEtaLorentz (NormedSpace.exp halfGenerator) := by
    exact exp_isEtaLorentz generator hGenerator (t / 2)
  have hHalfDetSq : (NormedSpace.exp halfGenerator).det ^ 2 = 1 := by
    have hDet := congrArg Matrix.det hHalfLorentz
    rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose, eta_det] at hDet
    nlinarith
  have hSplit : t • generator = halfGenerator + halfGenerator := by
    rw [show halfGenerator = (t / 2) • generator by rfl, ← add_smul]
    congr 1
    ring
  have hExpSplit :
      NormedSpace.exp (t • generator) =
        NormedSpace.exp halfGenerator * NormedSpace.exp halfGenerator := by
    rw [hSplit]
    exact Matrix.exp_add_of_commute halfGenerator halfGenerator (Commute.refl _)
  rw [hExpSplit, Matrix.det_mul]
  simpa [pow_two] using hHalfDetSq

/-- The exponential of every Lorentz Lie-algebra element is proper
eta-Lorentz. -/
theorem exp_isProperEtaLorentz
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) (t : Real) :
    IsProperEtaLorentz (NormedSpace.exp (t • generator)) := by
  exact ⟨exp_isEtaLorentz generator hGenerator t,
    exp_det_eq_one generator hGenerator t⟩

end ProperLorentzExponential
