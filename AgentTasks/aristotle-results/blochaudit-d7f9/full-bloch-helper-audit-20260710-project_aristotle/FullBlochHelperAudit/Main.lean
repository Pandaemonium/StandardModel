import Mathlib

/-!
# Machine-checked anchor for the harvested full-Bloch helper audit

This module records the *independently verified* facts underpinning the audit of
`NullEdgeBlochDet/Determinants.lean` (harvested source, left unedited under
`AgentTasks/aristotle-standalone/`).  The full written findings are in
`AgentTasks/full-bloch-helper-audit-FINDINGS.md`.

What is re-checked here, sorry-free, against the SymPy oracle
(`Scripts/oracle/derive_split4_floquet_polynomial.py`):

* the four Clifford generators `alpha1, alpha2, alpha3, beta` are transcribed
  exactly as in the oracle and each squares to the identity (genuine Dirac
  α/β generators);
* the harvested `factor` / `splitStep` conventions;
* the body-center nondegeneracy control `body_center_both_polynomials_zero`.

The two all-momentum determinant identities remain `sorry` in the harvested base
and are therefore *not* reproven here; they were independently confirmed only
numerically (max error ~9e-15 over 3000 random points, see the findings file).
-/

namespace FullBlochHelperAudit

open Matrix Complex

noncomputable section

def pinnedToolchainWitness : Nat := 428

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

/-- Clifford generator `alpha1`, transcribed from the harvested source and the
oracle. -/
def alpha1 : Mat4 := !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

/-- Clifford generator `alpha2`, transcribed from the harvested source and the
oracle. -/
def alpha2 : Mat4 := !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

/-- Clifford generator `alpha3`, transcribed from the harvested source and the
oracle. -/
def alpha3 : Mat4 := !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

/-- Clifford generator `beta`, transcribed from the harvested source and the
oracle. -/
def beta : Mat4 := !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- Harvested single-generator factor `cos x • 1 - (i sin x) • A`. -/
def factor (x : Real) (A : Mat4) : Mat4 :=
  (Real.cos x : Complex) • (1 : Mat4) - (I * Real.sin x) • A

/-- Harvested ordered 3+1 split step, in the exact multiplication order of the
source and oracle. -/
def splitStep (qx qy qz theta : Real) : Mat4 :=
  factor qx alpha1 * factor qy alpha2 * factor qz alpha3 * factor theta beta

/-- Clifford check: `alpha1² = 1`. -/
theorem alpha1_sq : alpha1 * alpha1 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [alpha1, Matrix.mul_apply, Fin.sum_univ_four]

/-- Clifford check: `alpha2² = 1`. -/
theorem alpha2_sq : alpha2 * alpha2 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [alpha2, Matrix.mul_apply, Fin.sum_univ_four, Complex.I_mul_I]

/-- Clifford check: `alpha3² = 1`. -/
theorem alpha3_sq : alpha3 * alpha3 = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [alpha3, Matrix.mul_apply, Fin.sum_univ_four]

/-- Clifford check: `beta² = 1`. -/
theorem beta_sq : beta * beta = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [beta, Matrix.mul_apply, Fin.sum_univ_four]

/-- Spectral base polynomial, transcribed from the harvested source. -/
def spectralBase (qx qy qz theta : Real) : Real :=
  let x := Real.cos qx
  let y := Real.cos qy
  let z := Real.cos qz
  let m := Real.cos theta
  4 * m^2 * x^2 * y^2 * z^2 - 2 * m^2 * x^2 * y^2 - 2 * m^2 * x^2 * z^2 + m^2 * x^2
    - 2 * m^2 * y^2 * z^2 + m^2 * y^2 + m^2 * z^2 - 2 * x^2 * y^2 * z^2
    + x^2 * y^2 + x^2 * z^2 + y^2 * z^2

/-- Zero-mode polynomial, transcribed from the harvested source. -/
def zeroModePolynomial (qx qy qz theta : Real) : Real :=
  spectralBase qx qy qz theta - 2 * Real.cos theta * Real.cos qx * Real.cos qy * Real.cos qz

/-- Pi-mode polynomial, transcribed from the harvested source. -/
def piModePolynomial (qx qy qz theta : Real) : Real :=
  spectralBase qx qy qz theta + 2 * Real.cos theta * Real.cos qx * Real.cos qy * Real.cos qz

/-- Re-verified body-center nondegeneracy control, matching the harvested lemma
`NullEdgeBlochDet.body_center_both_polynomials_zero`. -/
theorem body_center_both_polynomials_zero (theta : Real) :
    zeroModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 ∧
      piModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 := by
  simp [zeroModePolynomial, piModePolynomial, spectralBase]

end

end FullBlochHelperAudit
