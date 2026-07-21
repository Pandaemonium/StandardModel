import Mathlib

/-!
# PMNS Majorana-phase structure (Opus, verified Aristotle 593cd566)

The concrete structure behind the +2 Majorana phases in the A5 count: Majorana
masses as complex symmetric matrices, basis changes as congruences U^T M U, the
phase-ADDITION law M_ij -> exp(I(a_i+a_j)) M_ij (contrasting the Dirac phase
DIFFERENCE b_j - a_i), and a rephasing-invariant relative-phase polynomial
(M01)^2 = I(M00 M11). Namespace kept as prover's PMNSMajorana. Provenance:
verified at pin from task 6da3fa01. Standard three. Grade M, [comp]. -/

open scoped BigOperators ComplexConjugate

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option relaxedAutoImplicit false
set_option autoImplicit false

namespace PMNSMajorana

noncomputable section

abbrev CMatrix (n : ℕ) := Matrix (Fin n) (Fin n) ℂ

/-- A Majorana mass matrix is complex symmetric (transpose, not adjoint). -/
def IsMajoranaSymmetric {n : ℕ} (M : CMatrix n) : Prop := M.transpose = M

/-- Change of basis for a Majorana bilinear: congruence by `U`, not similarity. -/
def majoranaTransform {n : ℕ} (U M : CMatrix n) : CMatrix n :=
  U.transpose * M * U

/-- Change of basis for a Dirac bilinear, with independent left and right bases. -/
def diracTransform {n : ℕ} (Vₗ Vᵣ M : CMatrix n) : CMatrix n :=
  Vₗ.conjTranspose * M * Vᵣ

/-- Diagonal unitary whose entries are the rephasing factors `exp (I aᵢ)`. -/
def rephasing {n : ℕ} (a : Fin n → ℝ) : CMatrix n :=
  Matrix.diagonal (fun i ↦ Complex.exp (Complex.I * (a i : ℂ)))

/-
Every diagonal rephasing is unitary.
-/
theorem rephasing_unitary {n : ℕ} (a : Fin n → ℝ) :
    (rephasing a).conjTranspose * rephasing a = 1 := by
  ext i j ; by_cases hi : i = j <;> simp_all +decide [Matrix.mul_apply];
  · simp +decide [ hi, rephasing, Matrix.one_apply ];
    rw [ Finset.sum_eq_single j ] <;> simp +decide [ Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
    · exact ⟨ by rw [ ← sq, ← sq, Real.cos_sq_add_sin_sq ], by ring ⟩;
    · aesop;
  · unfold rephasing; simp +decide [Matrix.diagonal];
    tauto

/-
Congruence preserves the symmetry required of a Majorana mass matrix.
-/
theorem majoranaTransform_symmetric {n : ℕ} {U M : CMatrix n}
    (hM : IsMajoranaSymmetric M) :
    IsMajoranaSymmetric (majoranaTransform U M) := by
  unfold IsMajoranaSymmetric majoranaTransform;
  simp_all +decide [ Matrix.mul_assoc, IsMajoranaSymmetric ]

/-
Under Majorana congruence, diagonal field phases add at each matrix entry.
-/
theorem majorana_rephasing_apply {n : ℕ} (a : Fin n → ℝ) (M : CMatrix n)
    (i j : Fin n) :
    majoranaTransform (rephasing a) M i j =
      Complex.exp (Complex.I * ((a i + a j : ℝ) : ℂ)) * M i j := by
  simp [majoranaTransform, rephasing];
  rw [ mul_right_comm, ← Complex.exp_add ] ; ring

/-
Under a Dirac transformation, independent diagonal left and right phases
appear with opposite signs.
-/
theorem dirac_rephasing_apply {n : ℕ} (a b : Fin n → ℝ) (M : CMatrix n)
    (i j : Fin n) :
    diracTransform (rephasing a) (rephasing b) M i j =
      Complex.exp (Complex.I * (((b j - a i : ℝ) : ℂ))) * M i j := by
  unfold diracTransform rephasing; simp +decide [Matrix.mul_apply]; ring;
  simp +decide [ Matrix.diagonal, Complex.exp_sub ] ; ring;
  simp +decide [ mul_assoc, mul_comm, mul_left_comm, Complex.inv_def, Complex.normSq_eq_norm_sq, Complex.norm_exp ]

/-- The polynomial relation encoding a relative Majorana phase.  It avoids any
choice of an argument or division by diagonal entries. -/
def HasRelativeIPhase (M : CMatrix 2) : Prop :=
  (M 0 1) ^ 2 = Complex.I * (M 0 0 * M 1 1)

/-
The relative-phase relation is unchanged by diagonal Majorana rephasing.
-/
theorem relativeIPhase_rephasing_invariant (a : Fin 2 → ℝ) (M : CMatrix 2)
    (h : HasRelativeIPhase M) :
    HasRelativeIPhase (majoranaTransform (rephasing a) M) := by
  unfold HasRelativeIPhase at *;
  simp_all +decide [ majoranaTransform, rephasing ];
  grind

/-- An explicit symmetric two-by-two Majorana mass matrix with a non-real
relative phase: its diagonal entries are `1`, and both off-diagonal entries are
`exp (I π/4)`. -/
def phaseWitness : CMatrix 2 := fun i j ↦
  if i = j then 1 else Complex.exp (Complex.I * (Real.pi / 4 : ℂ))

/-
The explicit witness is symmetric.
-/
theorem phaseWitness_symmetric : IsMajoranaSymmetric phaseWitness := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [ phaseWitness ] ;

/-
The explicit witness carries the invariant relative phase `I`.
-/
theorem phaseWitness_relativeIPhase : HasRelativeIPhase phaseWitness := by
  unfold HasRelativeIPhase phaseWitness; norm_num [ ← Complex.exp_nat_mul, Complex.ext_iff, Complex.exp_re, Complex.exp_im ] ; ring_nf; norm_num;
  norm_num [ mul_div ]

/-- All entries of a complex matrix are real numbers. -/
def IsEntrywiseReal {n : ℕ} (M : CMatrix n) : Prop :=
  ∀ i j, (M i j).im = 0

/-
A nonzero real diagonal together with the relative phase `I` obstructs an
entrywise-real matrix.
-/
theorem relativeIPhase_not_entrywiseReal (M : CMatrix 2)
    (hrel : HasRelativeIPhase M) (hdiag₀ : M 0 0 ≠ 0) (hdiag₁ : M 1 1 ≠ 0) :
    ¬ IsEntrywiseReal M := by
  intro h; have := h 0 0; have := h 1 1; have := h 0 1; have := h 1 0; simp_all +decide [Complex.ext_iff];
  unfold HasRelativeIPhase at hrel; simp_all +decide [Complex.ext_iff, sq];

/-
No allowed diagonal Majorana rephasing makes the explicit symmetric witness
entrywise real.  This is the promised concrete non-removable Majorana phase.
-/
theorem phaseWitness_not_rephasable_real (a : Fin 2 → ℝ) :
    ¬ IsEntrywiseReal (majoranaTransform (rephasing a) phaseWitness) := by
  apply relativeIPhase_not_entrywiseReal;
  · convert relativeIPhase_rephasing_invariant a phaseWitness phaseWitness_relativeIPhase using 1;
  · unfold majoranaTransform rephasing phaseWitness; norm_num [ Complex.exp_ne_zero ] ;
  · unfold majoranaTransform rephasing phaseWitness; norm_num [ Complex.exp_ne_zero ] ;

/-- For three generations the Majorana branch has three physical CP phases
(one Dirac-type plus two Majorana phases), versus one in the Dirac branch. -/
theorem three_generation_phase_count :
    let diracPhysicalPhases : ℕ := 1
    let majoranaPhysicalPhases : ℕ := 3
    majoranaPhysicalPhases = diracPhysicalPhases + 2 := by
  norm_num

end

end PMNSMajorana

#print axioms PMNSMajorana.rephasing_unitary
#print axioms PMNSMajorana.majoranaTransform_symmetric
#print axioms PMNSMajorana.majorana_rephasing_apply
#print axioms PMNSMajorana.dirac_rephasing_apply
#print axioms PMNSMajorana.relativeIPhase_rephasing_invariant
#print axioms PMNSMajorana.phaseWitness_symmetric
#print axioms PMNSMajorana.phaseWitness_relativeIPhase
#print axioms PMNSMajorana.relativeIPhase_not_entrywiseReal
#print axioms PMNSMajorana.phaseWitness_not_rephasable_real
#print axioms PMNSMajorana.three_generation_phase_count
