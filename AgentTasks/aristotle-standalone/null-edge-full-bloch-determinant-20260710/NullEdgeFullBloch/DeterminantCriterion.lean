import Mathlib

/-!
# Full Bloch determinant criterion for the ordered 3+1 split walk

This standalone package copies only the finite matrix definitions needed to
derive an exact all-momentum criterion for Floquet eigenvalues `+1` and `-1`.
The displayed real polynomial was derived independently from the matrix symbol;
Aristotle must prove it in Lean and connect determinant zero to a nonzero
eigenmode.  The body-center specialization is the required nondegenerate check.
-/

noncomputable section

open Matrix Complex Polynomial

namespace NullEdgeFullBloch

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex
abbrev Vec4 := Fin 4 -> Complex

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

/-- The part of both Floquet determinant criteria even under changing the
target eigenvalue from `+1` to `-1`. -/
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

/-- Candidate exact criterion for a zero-quasienergy (`+1`) mode. -/
def zeroModePolynomial (qx qy qz theta : Real) : Real :=
  spectralBase qx qy qz theta -
    2 * Real.cos theta * Real.cos qx * Real.cos qy * Real.cos qz

/-- Candidate exact criterion for a pi-quasienergy (`-1`) mode. -/
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

/-- The zero-mode polynomial is equivalent to a nonzero exact `+1`
eigenvector, not merely to a sampled numerical crossing. -/
theorem exists_plus_mode_iff (qx qy qz theta : Real) :
    (Exists fun v : Vec4 => v ≠ 0 ∧ splitStep qx qy qz theta *ᵥ v = v) ↔
      zeroModePolynomial qx qy qz theta = 0 := by
  sorry

/-- The pi-mode polynomial is equivalent to a nonzero exact `-1`
eigenvector. -/
theorem exists_minus_mode_iff (qx qy qz theta : Real) :
    (Exists fun v : Vec4 => v ≠ 0 ∧ splitStep qx qy qz theta *ᵥ v = -v) ↔
      piModePolynomial qx qy qz theta = 0 := by
  sorry

/-- Both determinant criteria vanish identically at body-center momentum for
every mass angle. -/
theorem body_center_both_polynomials_zero (theta : Real) :
    zeroModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 /\
      piModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 := by
  simp [zeroModePolynomial, piModePolynomial, spectralBase]

end NullEdgeFullBloch
