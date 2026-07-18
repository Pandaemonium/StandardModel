import PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
import Mathlib.Analysis.Normed.Algebra.MatrixExponential

noncomputable section

/-!
# Lorentz Lie-algebra exponentials

This module closes the group-membership side of the canonical link variations.
In the fixed mostly-minus convention, exponentiating a matrix satisfying

`X^T eta + eta X = 0`

preserves `eta` and has determinant exactly `+1`.  The determinant proof does
not assume the unavailable general identity `det(exp X) = exp(trace X)`.
Instead, it writes `exp X` as the square of `exp(X/2)`: eta preservation makes
the half-step determinant square to one, so the full-step determinant is one.

## Scope and provenance

These are exact finite-dimensional matrix identities.  They prove membership
in the proper Lorentz subgroup `SO(1,3)` as represented by the project's
matrix predicates.  They do not yet prove the orthochronous sign condition or
identify the connected identity component.  The Lie exponential argument is
standard `[import/comp]`; the half-step determinant proof is a project-local
formalization choice.  Claim label: finite identity.
-/

open scoped Matrix.Norms.Frobenius

namespace PhysicsSM.Draft.NullEdge.ProperLorentzExponential

open NormedSpace
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge

/-- The mostly-minus metric is a unit in the four-matrix ring. -/
theorem eta_isUnit :
    IsUnit
      (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real) := by
  rw [Matrix.isUnit_iff_isUnit_det, MinkowskiConvention.eta_det]
  exact isUnit_neg_one

/-- The nonsingular matrix inverse of the mostly-minus metric is itself. -/
theorem eta_inv :
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real)⁻¹ =
      MinkowskiConvention.eta := by
  apply eta_isUnit.mul_left_cancel
  rw [Matrix.mul_nonsing_inv MinkowskiConvention.eta]
  · exact MinkowskiConvention.eta_mul_eta.symm
  · rw [MinkowskiConvention.eta_det]
    exact isUnit_neg_one

/-- Eta-Lorentz matrices are closed under multiplication. -/
theorem isEtaLorentz_mul
    (left right : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : IsEtaLorentz left) (hRight : IsEtaLorentz right) :
    IsEtaLorentz (left * right) := by
  unfold IsEtaLorentz at *
  calc
    (left * right).transpose * MinkowskiConvention.eta * (left * right) =
        right.transpose *
          (left.transpose * MinkowskiConvention.eta * left) * right := by
      simp [Matrix.mul_assoc]
    _ = right.transpose * MinkowskiConvention.eta * right := by rw [hLeft]
    _ = MinkowskiConvention.eta := hRight

/-- Determinant-one matrices are closed under multiplication. -/
theorem isProperLorentz_mul
    (left right : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : IsProperLorentz left) (hRight : IsProperLorentz right) :
    IsProperLorentz (left * right) := by
  unfold IsProperLorentz at *
  rw [Matrix.det_mul, hLeft, hRight, mul_one]

/-- Exponentiating a Lorentz Lie-algebra element preserves the mostly-minus
metric for every real parameter. -/
theorem exp_isEtaLorentz
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) (t : Real) :
    IsEtaLorentz (NormedSpace.exp (t • generator)) := by
  let X : Matrix (Fin 4) (Fin 4) Real := t • generator
  have hX : IsLorentzLieAlgebra X := by
    have hScaled := congrArg (fun matrix => t • matrix) hGenerator
    simpa [X, IsLorentzLieAlgebra, Matrix.transpose_smul, Matrix.smul_mul,
      Matrix.mul_smul, smul_add] using hScaled
  have hTranspose :
      X.transpose =
        -(MinkowskiConvention.eta * X * MinkowskiConvention.eta) := by
    have hRight :=
      congrArg (fun matrix => matrix * MinkowskiConvention.eta) hX
    have hSum :
        X.transpose + MinkowskiConvention.eta * X * MinkowskiConvention.eta =
          0 := by
      simpa [IsLorentzLieAlgebra, add_mul, Matrix.mul_assoc,
        MinkowskiConvention.eta_mul_eta] using hRight
    exact eq_neg_of_add_eq_zero_left hSum
  have hExpTranspose :
      NormedSpace.exp X.transpose =
        MinkowskiConvention.eta * NormedSpace.exp (-X) *
          MinkowskiConvention.eta := by
    have hConj := Matrix.exp_conj
      (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real) (-X)
      eta_isUnit
    rw [eta_inv] at hConj
    rw [hTranspose]
    simpa only [neg_mul, mul_neg, neg_neg] using hConj
  have hExpCancel :
      NormedSpace.exp (-X) * NormedSpace.exp X = 1 := by
    simpa using
      (Matrix.exp_add_of_commute (-X) X (Commute.refl X).neg_left).symm
  change IsEtaLorentz (NormedSpace.exp X)
  unfold IsEtaLorentz
  rw [<- Matrix.exp_transpose, hExpTranspose]
  simp only [Matrix.mul_assoc, MinkowskiConvention.eta_mul_eta,
    hExpCancel, Matrix.mul_one]

/-- A Lorentz Lie-algebra exponential has determinant exactly `+1`. -/
theorem exp_isProperLorentz
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) (t : Real) :
    IsProperLorentz (NormedSpace.exp (t • generator)) := by
  let halfGenerator : Matrix (Fin 4) (Fin 4) Real :=
    (t / 2) • generator
  have hHalfLorentz :
      IsEtaLorentz (NormedSpace.exp halfGenerator) := by
    exact exp_isEtaLorentz generator hGenerator (t / 2)
  have hHalfDetSq : (NormedSpace.exp halfGenerator).det ^ 2 = 1 := by
    have hDet := congrArg Matrix.det hHalfLorentz
    rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose,
      MinkowskiConvention.eta_det] at hDet
    nlinarith
  have hSplit : t • generator = halfGenerator + halfGenerator := by
    rw [show halfGenerator = (t / 2) • generator by rfl, <- add_smul]
    congr 1
    ring
  have hExpSplit :
      NormedSpace.exp (t • generator) =
        NormedSpace.exp halfGenerator * NormedSpace.exp halfGenerator := by
    rw [hSplit]
    exact Matrix.exp_add_of_commute halfGenerator halfGenerator (Commute.refl _)
  unfold IsProperLorentz
  rw [hExpSplit, Matrix.det_mul]
  simpa [pow_two] using hHalfDetSq

/-- Every Lorentz Lie-algebra exponential is both eta-Lorentz and proper. -/
theorem exp_isProperEtaLorentz
    (generator : Matrix (Fin 4) (Fin 4) Real)
    (hGenerator : IsLorentzLieAlgebra generator) (t : Real) :
    IsEtaLorentz (NormedSpace.exp (t • generator)) /\
      IsProperLorentz (NormedSpace.exp (t • generator)) := by
  exact And.intro
    (exp_isEtaLorentz generator hGenerator t)
    (exp_isProperLorentz generator hGenerator t)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProperLorentzExponential.exp_isEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exp_isEtaLorentz

/-- info: 'PhysicsSM.Draft.NullEdge.ProperLorentzExponential.exp_isProperLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exp_isProperLorentz

/-- info: 'PhysicsSM.Draft.NullEdge.ProperLorentzExponential.exp_isProperEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exp_isProperEtaLorentz

end PhysicsSM.Draft.NullEdge.ProperLorentzExponential
