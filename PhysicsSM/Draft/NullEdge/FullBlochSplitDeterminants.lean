import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-!
# Exact determinant formulas for the ordered 3+1 split walk

This module gives the exact entry expansion and the two real trigonometric
polynomials that control `+1` and `-1` Floquet modes of the live ordered
successive-axis walk.  The companion `FullBlochSplitPlus` and
`FullBlochSplitMinus` modules prove the determinant identities themselves.

The result is an all-momentum criterion, not a claim that the regulator is
alias-free.  Its body-center control instead confirms that both mode
polynomials vanish there for every mass angle.

The definitions are propositionally and definitionally tied below to
`Compact3Plus1DiracRate.splitStep`; they are not a disconnected oracle model.

Provenance: Aristotle projects `d13856aa-98ef-466e-8284-42ef850b9dc0` and
`5337cc9e-bf1d-4ed4-8660-9aadf5ec8164`, with independent local compilation of
the repaired helper and both determinant branches.  The formulas were also
checked by the repository SymPy oracle, which is not part of the proof.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants

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

-- The trigonometric-polynomial identities below expand a finite `4 x 4`
-- determinant, so the default heartbeat / recursion budgets are raised.
set_option maxHeartbeats 8000000
set_option maxRecDepth 8000

/-- Cofactor (Laplace) expansion of a `4 x 4` complex determinant. -/
lemma det_fin_four (M : Mat4) : M.det =
      M 0 0*M 1 1*M 2 2*M 3 3 - M 0 0*M 1 1*M 2 3*M 3 2 - M 0 0*M 1 2*M 2 1*M 3 3
    + M 0 0*M 1 2*M 2 3*M 3 1 + M 0 0*M 1 3*M 2 1*M 3 2 - M 0 0*M 1 3*M 2 2*M 3 1
    - M 0 1*M 1 0*M 2 2*M 3 3 + M 0 1*M 1 0*M 2 3*M 3 2 + M 0 1*M 1 2*M 2 0*M 3 3
    - M 0 1*M 1 2*M 2 3*M 3 0 - M 0 1*M 1 3*M 2 0*M 3 2 + M 0 1*M 1 3*M 2 2*M 3 0
    + M 0 2*M 1 0*M 2 1*M 3 3 - M 0 2*M 1 0*M 2 3*M 3 1 - M 0 2*M 1 1*M 2 0*M 3 3
    + M 0 2*M 1 1*M 2 3*M 3 0 + M 0 2*M 1 3*M 2 0*M 3 1 - M 0 2*M 1 3*M 2 1*M 3 0
    - M 0 3*M 1 0*M 2 1*M 3 2 + M 0 3*M 1 0*M 2 2*M 3 1 + M 0 3*M 1 1*M 2 0*M 3 2
    - M 0 3*M 1 1*M 2 2*M 3 0 - M 0 3*M 1 2*M 2 0*M 3 1 + M 0 3*M 1 2*M 2 1*M 3 0 := by
  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Matrix.submatrix_apply,
    Matrix.cons_val_zero, Matrix.cons_val_one, Fin.succAbove, Fin.succ,
    Matrix.cons_val_fin_one, Matrix.cons_val]
  ring

lemma factor_alpha1 (qx : Real) : factor qx alpha1 =
    !![(Real.cos qx:ℂ),0,0,-(I*Real.sin qx); 0,(Real.cos qx:ℂ),-(I*Real.sin qx),0;
       0,-(I*Real.sin qx),(Real.cos qx:ℂ),0; -(I*Real.sin qx),0,0,(Real.cos qx:ℂ)] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [factor, alpha1]

lemma factor_alpha2 (qy : Real) : factor qy alpha2 =
    !![(Real.cos qy:ℂ),0,0,-(Real.sin qy); 0,(Real.cos qy:ℂ),(Real.sin qy),0;
       0,-(Real.sin qy),(Real.cos qy:ℂ),0; (Real.sin qy),0,0,(Real.cos qy:ℂ)] := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [factor, alpha2] <;> ring_nf <;> simp [Complex.I_sq]

lemma factor_alpha3 (qz : Real) : factor qz alpha3 =
    !![(Real.cos qz:ℂ),0,-(I*Real.sin qz),0; 0,(Real.cos qz:ℂ),0,(I*Real.sin qz);
       -(I*Real.sin qz),0,(Real.cos qz:ℂ),0; 0,(I*Real.sin qz),0,(Real.cos qz:ℂ)] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [factor, alpha3]

lemma factor_beta (theta : Real) : factor theta beta =
    !![(Real.cos theta:ℂ)-I*Real.sin theta,0,0,0; 0,(Real.cos theta:ℂ)-I*Real.sin theta,0,0;
       0,0,(Real.cos theta:ℂ)+I*Real.sin theta,0; 0,0,0,(Real.cos theta:ℂ)+I*Real.sin theta] := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [factor, beta] <;> ring

/-- Explicit entrywise form of one Floquet step as a single `4 x 4` matrix. -/
lemma splitStep_eq (qx qy qz theta : Real) : splitStep qx qy qz theta =
    !![I^2*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ) + (Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ),
       I^3*(Real.cos qy:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) - I^2*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ),
       I^3*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) - I^2*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qz:ℂ),
       -I^2*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ) - (Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ);
       -I^3*(Real.cos qy:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ),
       -I^2*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin theta:ℂ) + I*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ) + (Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ),
       -I^2*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin theta:ℂ) + I*(Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ) + (Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ),
       I^3*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ) + I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qz:ℂ);
       -I^3*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qz:ℂ),
       I^2*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin theta:ℂ) + I*(Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ) - (Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ),
       -I^2*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) + I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ) + (Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ),
       -I^3*(Real.cos qy:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) - I^2*(Real.cos qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) - I^2*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ);
       I^2*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) - I*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ) + (Real.cos qx:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ),
       -I^3*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) - I^2*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ) + I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qz:ℂ),
       I^3*(Real.cos qy:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) - I^2*(Real.cos qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ)*(Real.sin theta:ℂ) + I^2*(Real.cos qy:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qz:ℂ) - I*(Real.cos qx:ℂ)*(Real.cos theta:ℂ)*(Real.sin qy:ℂ)*(Real.sin qz:ℂ),
       I^2*(Real.cos qz:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ)*(Real.sin theta:ℂ) + I*(Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.sin theta:ℂ) + I*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)*(Real.sin qx:ℂ)*(Real.sin qy:ℂ) + (Real.cos qx:ℂ)*(Real.cos qy:ℂ)*(Real.cos qz:ℂ)*(Real.cos theta:ℂ)]  := by
  rw [splitStep, factor_alpha1, factor_alpha2, factor_alpha3, factor_beta]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [Matrix.mul_apply, Fin.sum_univ_four, Fin.reduceFinMk, Fin.mk_zero, Fin.mk_one,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons, Matrix.cons_val,
      Matrix.of_apply, Matrix.head_fin_const, Matrix.cons_val_fin_one, mul_zero, zero_mul,
      add_zero, zero_add, mul_one, one_mul, neg_zero] <;> ring

/-- Mandatory exact nondegenerate control: both criteria vanish at body center
for every mass angle. -/
theorem body_center_both_polynomials_zero (theta : Real) :
    zeroModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 ∧
      piModePolynomial (Real.pi / 2) (Real.pi / 2) (Real.pi / 2) theta = 0 := by
  simp [zeroModePolynomial, piModePolynomial, spectralBase]

/-- The standalone-angle symbol is exactly the live successive-axis symbol at
unit step size. -/
theorem splitStep_eq_live (qx qy qz theta : Real) :
    splitStep qx qy qz theta =
      Compact3Plus1DiracRate.splitStep qx qy qz theta 1 := by
  simp [splitStep, factor, alpha1, alpha2, alpha3, beta,
    Compact3Plus1DiracRate.splitStep, Compact3Plus1DiracRate.factor,
    Compact3Plus1DiracRate.alpha1, Compact3Plus1DiracRate.alpha2,
    Compact3Plus1DiracRate.alpha3, Compact3Plus1DiracRate.beta]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants.splitStep_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms splitStep_eq

/-- info: 'PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants.body_center_both_polynomials_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_both_polynomials_zero

end PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants
