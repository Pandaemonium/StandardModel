import Mathlib

/-!
# Exact determinant formulas for the ordered 3+1 split walk

Focused symbolic target: prove only the two finite `4 x 4` determinant
expansions.  Generic determinant-to-eigenmode linear algebra is already proved
in the live project as `FloquetDeterminantCriterion`; the body-center control is
closed below.  Do not spend proof-search budget on kernel API or project builds.
-/

noncomputable section

open Matrix Complex

namespace NullEdgeBlochDet

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

def factor (x : Real) (A : Mat4) : Mat4 :=
  (Real.cos x : Complex) • (1 : Mat4) -
    (I * Real.sin x) • A

def splitStep (qx qy qz theta : Real) : Mat4 :=
  factor qx alpha1 * factor qy alpha2 * factor qz alpha3 * factor theta beta

def spectralBase (qx qy qz theta : Real) : Real :=
  let x := Real.cos qx
  let y := Real.cos qy
  let z := Real.cos qz
  let m := Real.cos theta
  4 * m^2 * x^2 * y^2 * z^2
    - 2 * m^2 * x^2 * y^2
    - 2 * m^2 * x^2 * z^2
    + m^2 * x^2
    - 2 * m^2 * y^2 * z^2
    + m^2 * y^2
    + m^2 * z^2
    - 2 * x^2 * y^2 * z^2
    + x^2 * y^2
    + x^2 * z^2
    + y^2 * z^2

def zeroModePolynomial (qx qy qz theta : Real) : Real :=
  spectralBase qx qy qz theta -
    2 * Real.cos theta * Real.cos qx * Real.cos qy * Real.cos qz

def piModePolynomial (qx qy qz theta : Real) : Real :=
  spectralBase qx qy qz theta +
    2 * Real.cos theta * Real.cos qx * Real.cos qy * Real.cos qz

/-- Exact all-momentum determinant formula at eigenvalue `+1`. -/
theorem det_splitStep_sub_one (qx qy qz theta : Real) :
    Matrix.det (splitStep qx qy qz theta - (1 : Mat4)) =
      (4 * zeroModePolynomial qx qy qz theta : Real) := by
  sorry

/-- Exact all-momentum determinant formula at eigenvalue `-1`. -/
theorem det_splitStep_add_one (qx qy qz theta : Real) :
    Matrix.det (splitStep qx qy qz theta + (1 : Mat4)) =
      (4 * piModePolynomial qx qy qz theta : Real) := by
  sorry

/-- Mandatory exact nondegenerate control: both criteria vanish at body center
for every mass angle. -/
theorem body_center_both_polynomials_zero (theta : Real) :
    zeroModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 ∧
      piModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 := by
  simp [zeroModePolynomial, piModePolynomial, spectralBase]

end NullEdgeBlochDet
