import PhysicsSM.Draft.NullEdge.MixedPseudoDiracBranch

/-!
# Physical masses for the two-state mixed pseudo-Dirac branch

For a complex symmetric Majorana/Dirac mass matrix `M`, the ordinary complex
eigenvalues of `M` are not, in general, the physical nonnegative masses.  The
squared physical masses are the eigenvalues of the positive-semidefinite
Hermitian matrix `Mᴴ * M`; equivalently, the masses are the singular values of
`M`.

This file proves that distinction exactly for the two-state branch.  It gives
the trace, determinant, discriminant, and both squared singular masses, proves
the real-symmetric specialization, and includes a mandatory semantic control:
a nonzero complex symmetric nilpotent matrix whose ordinary eigenvalues all
vanish while `Mᴴ * M` is nonzero.

The file does not prove the arbitrary-dimensional Autonne-Takagi factorization,
select neutrino couplings or scales, or reconstruct a propagator pole.

Provenance: clean-room formalization of the finite singular-mass prescription
described in Borisov and Isaev, arXiv:2312.17714, Appendix C.  Proofs returned
by Aristotle project `b54d5226-12a2-42cd-b85d-bb0697880d99` and adapted to the
existing `MixedPseudoDirac.massMatrix` declaration.  Claim grade `M`, `[comp]`.
-/

open scoped BigOperators Matrix ComplexConjugate
open Matrix Complex

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace MixedPseudoDirac

abbrev Two := Fin 2

/-- The Hermitian squared-mass matrix.  Its eigenvalues are the squared
physical masses of the finite two-state branch. -/
noncomputable def squaredMassMatrix (ML mD MR : ℂ) : Matrix Two Two ℂ :=
  (massMatrix ML mD MR)ᴴ * massMatrix ML mD MR

theorem squaredMassMatrix_hermitian (ML mD MR : ℂ) :
    (squaredMassMatrix ML mD MR)ᴴ = squaredMassMatrix ML mD MR := by
  unfold squaredMassMatrix
  aesop

/-- Explicit positive-semidefiniteness of the squared-mass quadratic form. -/
theorem squaredMassMatrix_quadratic_nonneg (ML mD MR : ℂ) (x : Two → ℂ) :
    0 ≤ ((star x) ⬝ᵥ ((squaredMassMatrix ML mD MR).mulVec x)).re := by
  set y : Two → ℂ := (massMatrix ML mD MR).mulVec x
  have h_y_yH :
      star x ⬝ᵥ squaredMassMatrix ML mD MR *ᵥ x = star y ⬝ᵥ y := by
    simp +zetaDelta at *
    unfold squaredMassMatrix
    simp +decide [Matrix.mulVec, dotProduct]
    ring
    simp +decide [Matrix.mul_apply, Fin.sum_univ_succ]
    ring!
  simp_all +decide [Complex.ext_iff, dotProduct]
  nlinarith

/-- Exact trace invariant of `Mᴴ * M`. -/
theorem trace_squaredMassMatrix (ML mD MR : ℂ) :
    Matrix.trace (squaredMassMatrix ML mD MR) =
      ((Complex.normSq ML + 2 * Complex.normSq mD + Complex.normSq MR : ℝ) : ℂ) := by
  unfold squaredMassMatrix massMatrix
  norm_num [Complex.ext_iff, Matrix.mul_apply, Matrix.trace]
  ring
  norm_num [Complex.normSq_apply, sq]
  ring

/-- Exact determinant invariant of `Mᴴ * M`. -/
theorem det_squaredMassMatrix (ML mD MR : ℂ) :
    Matrix.det (squaredMassMatrix ML mD MR) =
      ((Complex.normSq (ML * MR - mD ^ 2) : ℝ) : ℂ) := by
  unfold squaredMassMatrix
  norm_num [Matrix.det_fin_two, Complex.normSq, massMatrix]
  ring
  norm_num [Complex.ext_iff, sq]
  ring
  norm_num

/-- The real trace invariant used to package the two squared masses. -/
def traceInvariant (ML mD MR : ℂ) : ℝ :=
  Complex.normSq ML + 2 * Complex.normSq mD + Complex.normSq MR

/-- The real determinant invariant used to package the two squared masses. -/
def detInvariant (ML mD MR : ℂ) : ℝ :=
  Complex.normSq (ML * MR - mD ^ 2)

/-- Discriminant of the real quadratic for the squared singular masses. -/
def massDiscriminant (ML mD MR : ℂ) : ℝ :=
  traceInvariant ML mD MR ^ 2 - 4 * detInvariant ML mD MR

/-- A manifestly nonnegative form of the discriminant. -/
theorem massDiscriminant_eq (ML mD MR : ℂ) :
    massDiscriminant ML mD MR =
      (Complex.normSq ML - Complex.normSq MR) ^ 2 +
        4 * Complex.normSq (conj ML * mD + conj mD * MR) := by
  unfold massDiscriminant traceInvariant detInvariant
  norm_num [Complex.normSq, sq]
  ring

theorem massDiscriminant_nonneg (ML mD MR : ℂ) :
    0 ≤ massDiscriminant ML mD MR := by
  rw [massDiscriminant_eq]
  exact add_nonneg (sq_nonneg _) (mul_nonneg zero_le_four (Complex.normSq_nonneg _))

/-- The smaller squared physical mass. -/
noncomputable def squaredMassMinus (ML mD MR : ℂ) : ℝ :=
  (traceInvariant ML mD MR - Real.sqrt (massDiscriminant ML mD MR)) / 2

/-- The larger squared physical mass. -/
noncomputable def squaredMassPlus (ML mD MR : ℂ) : ℝ :=
  (traceInvariant ML mD MR + Real.sqrt (massDiscriminant ML mD MR)) / 2

theorem squaredMassMinus_nonneg (ML mD MR : ℂ) :
    0 ≤ squaredMassMinus ML mD MR := by
  refine div_nonneg (sub_nonneg_of_le ?_) zero_le_two
  convert Real.sqrt_le_iff.mpr ?_
  exact ⟨
    add_nonneg
      (add_nonneg (Complex.normSq_nonneg _)
        (mul_nonneg zero_le_two (Complex.normSq_nonneg _)))
      (Complex.normSq_nonneg _),
    sub_le_self _ (mul_nonneg zero_le_four (Complex.normSq_nonneg _))⟩

theorem squaredMassPlus_nonneg (ML mD MR : ℂ) :
    0 ≤ squaredMassPlus ML mD MR := by
  refine div_nonneg ?_ zero_le_two
  exact add_nonneg
    (add_nonneg
      (add_nonneg (Complex.normSq_nonneg _)
        (mul_nonneg zero_le_two (Complex.normSq_nonneg _)))
      (Complex.normSq_nonneg _))
    (Real.sqrt_nonneg _)

/-- The characteristic polynomial of the Hermitian squared-mass matrix. -/
theorem squaredMass_characteristic (ML mD MR : ℂ) (z : ℂ) :
    Matrix.det (z • (1 : Matrix Two Two ℂ) - squaredMassMatrix ML mD MR) =
      z ^ 2 - (traceInvariant ML mD MR : ℂ) * z +
        (detInvariant ML mD MR : ℂ) := by
  convert congr_arg
    (fun x : ℂ => z ^ 2 - Matrix.trace (squaredMassMatrix ML mD MR) * z + x)
    (det_squaredMassMatrix ML mD MR) using 1
  · norm_num [Matrix.det_fin_two, Matrix.trace_fin_two]
    ring
  · unfold traceInvariant detInvariant squaredMassMatrix massMatrix
    norm_num [Matrix.trace_fin_two, Matrix.det_fin_two]
    ring
    norm_num [Complex.ext_iff, Matrix.mul_apply]
    ring
    exact Or.inl ⟨by simpa [Complex.normSq_apply, sq] using by ring, trivial⟩

theorem squaredMassMinus_is_root (ML mD MR : ℂ) :
    Matrix.det ((squaredMassMinus ML mD MR : ℂ) • (1 : Matrix Two Two ℂ) -
      squaredMassMatrix ML mD MR) = 0 := by
  convert squaredMass_characteristic ML mD MR (squaredMassMinus ML mD MR) using 1
  unfold squaredMassMinus
  norm_num [Complex.ext_iff, sq]
  linarith [
    Real.mul_self_sqrt (massDiscriminant_nonneg ML mD MR),
    show massDiscriminant ML mD MR =
        traceInvariant ML mD MR ^ 2 - 4 * detInvariant ML mD MR by rfl]

theorem squaredMassPlus_is_root (ML mD MR : ℂ) :
    Matrix.det ((squaredMassPlus ML mD MR : ℂ) • (1 : Matrix Two Two ℂ) -
      squaredMassMatrix ML mD MR) = 0 := by
  convert squaredMass_characteristic ML mD MR (squaredMassPlus ML mD MR) using 1
  norm_num [squaredMassPlus]
  ring
  norm_cast
  rw [Real.sq_sqrt (massDiscriminant_nonneg ML mD MR)]
  push_cast [traceInvariant, detInvariant, massDiscriminant]
  ring

/-- Every real eigenvalue of `Mᴴ * M` is one of the two packaged squared
physical masses. -/
theorem real_eigenvalue_eq_squaredMass (ML mD MR : ℂ) (r : ℝ)
    (hr : Matrix.det ((r : ℂ) • (1 : Matrix Two Two ℂ) -
      squaredMassMatrix ML mD MR) = 0) :
    r = squaredMassMinus ML mD MR ∨ r = squaredMassPlus ML mD MR := by
  have h_quad :
      r ^ 2 - traceInvariant ML mD MR * r + detInvariant ML mD MR = 0 := by
    convert congr_arg Complex.re
      (squaredMass_characteristic ML mD MR r |>.symm ▸ hr) using 1
    norm_num [Complex.normSq, Complex.ext_iff]
    ring
    norm_cast
  unfold squaredMassMinus squaredMassPlus
  ring_nf at *
  exact Classical.or_iff_not_imp_left.2 fun h =>
    mul_left_cancel₀ (sub_ne_zero_of_ne h) <| by
      linarith [
        Real.mul_self_sqrt (massDiscriminant_nonneg ML mD MR),
        show massDiscriminant ML mD MR =
            traceInvariant ML mD MR ^ 2 - 4 * detInvariant ML mD MR by rfl]

/-- In the pure-Dirac limit, the squared-mass matrix is scalar. -/
theorem pureDirac_squaredMassMatrix (mD : ℂ) :
    squaredMassMatrix 0 mD 0 =
      (Complex.normSq mD : ℂ) • (1 : Matrix Two Two ℂ) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [Complex.ext_iff, normSq, squaredMassMatrix, massMatrix,
      Matrix.mul_apply] <;> ring

@[simp] theorem pureDirac_squaredMassMinus (mD : ℂ) :
    squaredMassMinus 0 mD 0 = Complex.normSq mD := by
  unfold squaredMassMinus
  norm_num [traceInvariant, detInvariant, massDiscriminant]
  ring
  norm_num

@[simp] theorem pureDirac_squaredMassPlus (mD : ℂ) :
    squaredMassPlus 0 mD 0 = Complex.normSq mD := by
  unfold squaredMassPlus traceInvariant massDiscriminant detInvariant
  unfold traceInvariant
  norm_num
  ring
  norm_num

/-! ## Real-symmetric specialization

The signed ordinary roots are not called physical masses.  Their absolute
values are the singular masses; the next two theorems preserve that distinction.
-/

noncomputable def signedRootMinus (ML mD MR : ℝ) : ℝ :=
  (ML + MR - Real.sqrt ((ML - MR) ^ 2 + 4 * mD ^ 2)) / 2

noncomputable def signedRootPlus (ML mD MR : ℝ) : ℝ :=
  (ML + MR + Real.sqrt ((ML - MR) ^ 2 + 4 * mD ^ 2)) / 2

/-- For real parameters, the unordered squared singular masses are the squares
of the two signed real-symmetric roots. -/
theorem real_specialization_squared_masses (ML mD MR : ℝ) :
    ({squaredMassMinus (ML : ℂ) (mD : ℂ) (MR : ℂ),
        squaredMassPlus (ML : ℂ) (mD : ℂ) (MR : ℂ)} : Multiset ℝ) =
      {signedRootMinus ML mD MR ^ 2, signedRootPlus ML mD MR ^ 2} := by
  unfold squaredMassMinus squaredMassPlus signedRootMinus signedRootPlus
    massDiscriminant traceInvariant detInvariant
  norm_num [Complex.normSq, sq]
  ring
  rw [Real.sq_sqrt (by nlinarith [sq_nonneg (ML - MR)])]
  ring
  rw [show
      ML * mD ^ 2 * MR * 8 + (ML ^ 2 * mD ^ 2 * 4 - ML ^ 2 * MR ^ 2 * 2) +
          ML ^ 4 + mD ^ 2 * MR ^ 2 * 4 + MR ^ 4 =
        (ML + MR) ^ 2 * (- (ML * MR * 2) + ML ^ 2 + mD ^ 2 * 4 + MR ^ 2) by
      ring]
  rw [Real.sqrt_mul (by positivity), Real.sqrt_sq_eq_abs]
  cases abs_cases (ML + MR) <;> simp +decide [*] <;> ring
  exact Multiset.cons_swap ..

/-- The nonnegative singular masses are the absolute values of the signed
roots, as an unordered pair. -/
theorem real_specialization_singular_masses (ML mD MR : ℝ) :
    ({Real.sqrt (squaredMassMinus (ML : ℂ) (mD : ℂ) (MR : ℂ)),
        Real.sqrt (squaredMassPlus (ML : ℂ) (mD : ℂ) (MR : ℂ))} : Multiset ℝ) =
      {|signedRootMinus ML mD MR|, |signedRootPlus ML mD MR|} := by
  convert congr_arg (fun x : Multiset ℝ => x.map Real.sqrt)
    (real_specialization_squared_masses ML mD MR) using 1
  norm_num [Real.sqrt_sq_eq_abs]

/-! ## Mandatory semantic counterexample -/

/-- A nonzero complex symmetric nilpotent matrix whose singular data are
nonzero. -/
def nilpotentControl : Matrix Two Two ℂ := !![1, I; I, -1]

@[simp] theorem nilpotentControl_transpose :
    nilpotentControlᵀ = nilpotentControl := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

theorem nilpotentControl_ne_zero : nilpotentControl ≠ 0 := by
  exact ne_of_apply_ne (fun m => m 0 0) one_ne_zero

@[simp] theorem nilpotentControl_sq :
    nilpotentControl * nilpotentControl = 0 := by
  convert Matrix.ext _
  norm_num [nilpotentControl, Matrix.mul_apply]

/-- Every ordinary algebraic eigenvalue of the nilpotent control is zero. -/
theorem nilpotentControl_only_eigenvalue_zero (z : ℂ) (v : Two → ℂ)
    (hv : v ≠ 0) (heig : nilpotentControl.mulVec v = z • v) : z = 0 := by
  simp_all +decide [funext_iff, Fin.forall_fin_two, Matrix.mulVec]
  by_cases h : v 0 = 0 <;> simp_all +decide [nilpotentControl]
  grind +suggestions

theorem nilpotentControl_star_mul_ne_zero :
    nilpotentControlᴴ * nilpotentControl ≠ 0 := by
  intro h
  have h00 := congr_fun (congr_fun h 0) 0
  norm_num [nilpotentControl, Matrix.mul_apply] at h00

@[simp] theorem nilpotentControl_star_mul_trace :
    Matrix.trace (nilpotentControlᴴ * nilpotentControl) = 4 := by
  norm_num [nilpotentControl, Matrix.trace, Matrix.mul_apply]

end MixedPseudoDirac
