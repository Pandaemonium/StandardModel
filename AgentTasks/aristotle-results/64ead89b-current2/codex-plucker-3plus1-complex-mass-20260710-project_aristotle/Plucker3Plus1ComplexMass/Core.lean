import Mathlib

/-!
# A complex Pluecker mass operator for a 3+1 Dirac walk

This focused target promotes the complex two-spinor wedge `z` to a concrete
four-component Dirac rest operator. The real and imaginary parts multiply two
Hermitian Clifford generators, so the square is `|z|^2 I`; a chiral unitary
rotates the phase of `z` while leaving the spatial generators fixed.

The target is finite matrix algebra. It does not claim a field theory,
topological index, or continuum limit.
-/

noncomputable section

open Matrix Complex

namespace Plucker3Plus1ComplexMass

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- The standard Dirac-basis chirality matrix. -/
def gamma5 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, 1; 1, 0, 0, 0; 0, 1, 0, 0]

/-- The second Hermitian mass direction `i beta gamma5`. -/
def beta5 : Mat4 := I • (beta * gamma5)

def alpha : Fin 3 → Mat4
  | 0 => alpha1
  | 1 => alpha2
  | 2 => alpha3

/-- Four-component rest operator carrying the full complex wedge phase. -/
def mass4 (z : ℂ) : Mat4 :=
  (z.re : ℂ) • beta + (z.im : ℂ) • beta5

def H4 (kx ky kz : ℝ) (z : ℂ) : Mat4 :=
  (kx : ℂ) • alpha1 + (ky : ℂ) • alpha2 +
    (kz : ℂ) • alpha3 + mass4 z

theorem mass_generators_clifford :
    beta.IsHermitian ∧ beta5.IsHermitian ∧
      beta * beta = 1 ∧ beta5 * beta5 = 1 ∧
      beta * beta5 + beta5 * beta = 0 := by
  refine' ⟨ _, _, _, _, _ ⟩;
  · unfold beta;
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Complex.ext_iff, Matrix.mul_apply ];
    all_goals unfold beta5; norm_num [ beta, gamma5 ] ;
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, beta ];
  · ext i j ; fin_cases i <;> fin_cases j <;> simp +decide [ beta5, beta, gamma5 ];
  · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ, beta, beta5, gamma5 ]

theorem spatial_anticommutes_mass_generators (j : Fin 3) :
    alpha j * beta + beta * alpha j = 0 ∧
      alpha j * beta5 + beta5 * alpha j = 0 := by
  fin_cases j <;> unfold alpha <;> simp +decide [ *, Fin.sum_univ_four ];
  · simp +decide [ alpha1, beta, beta5, gamma5 ];
    exact Matrix.ext fun i j => by fin_cases i <;> fin_cases j <;> rfl;
  · simp [alpha2, beta, beta5];
    simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, vecHead, vecTail, Matrix.vecMul, gamma5 ] at *;
  · unfold alpha3 beta beta5; norm_num [ ← List.ofFn_inj ] ;
    unfold beta gamma5; norm_num [ ← List.ofFn_inj ] ;
    exact Matrix.ext fun i j => by fin_cases i <;> fin_cases j <;> rfl;

theorem spatial_generators_clifford :
    (∀ j, (alpha j).IsHermitian ∧ alpha j * alpha j = 1) ∧
      (∀ i j, i ≠ j → alpha i * alpha j + alpha j * alpha i = 0) := by
  simp +decide [ Fin.forall_fin_succ, IsHermitian ];
  simp +decide [ alpha, alpha1, alpha2, alpha3 ];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ]

/-
The full complex phase changes the operator, but not its scalar square.
-/
theorem mass4_hermitian_sq (z : ℂ) :
    (mass4 z).IsHermitian ∧
      mass4 z * mass4 z =
        (Complex.normSq z : ℂ) • (1 : Mat4) := by
  simp_all +decide [ Complex.normSq, Complex.ext_iff, Matrix.IsHermitian ];
  unfold mass4;
  simp +decide [ beta, beta5, alpha1, alpha2, alpha3, gamma5 ];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
  ring_nf; norm_num

theorem mass4_eq_zero_iff (z : ℂ) : mass4 z = 0 ↔ z = 0 := by
  constructor <;> intro h <;> simp_all +decide [ Complex.ext_iff, mass4 ];
  unfold beta beta5 at h; have := congr_fun ( congr_fun h 0 ) 0; have := congr_fun ( congr_fun h 1 ) 0; have := congr_fun ( congr_fun h 2 ) 0; have := congr_fun ( congr_fun h 3 ) 0; simp_all +decide [ Complex.ext_iff ] ;
  unfold beta gamma5 at *; simp_all +decide [ Complex.ext_iff ] ;

/-
Exact 3+1 Dirac square with no independent scalar mass slot.
-/
theorem H4_sq (kx ky kz : ℝ) (z : ℂ) :
    H4 kx ky kz z * H4 kx ky kz z =
      (((kx ^ 2 + ky ^ 2 + kz ^ 2 + Complex.normSq z : ℝ) : ℂ)) •
        (1 : Mat4) := by
  unfold H4; simp +decide [ mul_assoc, Finset.sum_add_distrib, Finset.mul_sum, Finset.sum_mul, mul_add, add_mul, pow_two, mul_comm, mul_left_comm, add_assoc ] ; ring;
  -- By combining like terms and using the properties of the generators, we can simplify the expression.
  have h_simplify : alpha1 * alpha2 + alpha2 * alpha1 = 0 ∧ alpha1 * alpha3 + alpha3 * alpha1 = 0 ∧ alpha2 * alpha3 + alpha3 * alpha2 = 0 ∧ alpha1 * mass4 z + mass4 z * alpha1 = 0 ∧ alpha2 * mass4 z + mass4 z * alpha2 = 0 ∧ alpha3 * mass4 z + mass4 z * alpha3 = 0 := by
    have h_anticommutator : ∀ j : Fin 3, alpha j * mass4 z + mass4 z * alpha j = 0 := by
      unfold mass4;
      intro j; have := spatial_anticommutes_mass_generators j; simp_all +decide [ mul_add, add_mul ] ;
      simp_all +decide [ ← eq_sub_iff_add_eq', ← Matrix.ext_iff ];
    exact ⟨ by simpa using spatial_generators_clifford.2 0 1 ( by decide ), by simpa using spatial_generators_clifford.2 0 2 ( by decide ), by simpa using spatial_generators_clifford.2 1 2 ( by decide ), h_anticommutator 0, h_anticommutator 1, h_anticommutator 2 ⟩;
  have h_simplify : alpha1 * alpha1 = 1 ∧ alpha2 * alpha2 = 1 ∧ alpha3 * alpha3 = 1 ∧ mass4 z * mass4 z = (Complex.normSq z : ℂ) • (1 : Mat4) := by
    exact ⟨ by unfold alpha1; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ], by unfold alpha2; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ], by unfold alpha3; ext i j; fin_cases i <;> fin_cases j <;> norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ], by exact mass4_hermitian_sq z |>.2 ⟩;
  simp_all +decide [ ← eq_sub_iff_add_eq', ← mul_assoc, ← add_mul, ← mul_add, ← smul_assoc ];
  ext i j ; norm_num ; ring

/-
On the real axis, the complex operator reduces to the existing `m beta`
mass term.
-/
theorem real_mass_reduces (m : ℝ) :
    mass4 (m : ℂ) = (m : ℂ) • beta := by
  unfold mass4; aesop;

/-- Chiral phase rotation. The sign is selected so conjugation implements
`z -> exp(i theta) z`. -/
def chiralUnitary (theta : ℝ) : Mat4 :=
  (Real.cos (theta / 2) : ℂ) • (1 : Mat4) -
    (I * (Real.sin (theta / 2) : ℂ)) • gamma5

theorem chiralUnitary_is_unitary (theta : ℝ) :
    chiralUnitary theta ∈ Matrix.unitaryGroup (Fin 4) ℂ := by
  unfold chiralUnitary; simp +decide [ mul_eq_one_comm ] ;
  constructor <;> norm_num [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
  · simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ, Fin.sum_univ_zero, gamma5 ];
    simp +decide [ Complex.ext_iff, Matrix.one_apply ];
    norm_cast; ring_nf; norm_num;
    norm_num [ Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ];
  · simp +decide [ Matrix.mul_apply, Fin.sum_univ_succ, gamma5 ];
    simp +decide [ Complex.ext_iff, Matrix.one_apply ] ; ring_nf ; norm_num [ Real.sin_sq, Real.cos_sq ] ;
    norm_num [ Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ]

theorem chiralUnitary_commutes_spatial (theta : ℝ) (j : Fin 3) :
    chiralUnitary theta * alpha j = alpha j * chiralUnitary theta := by
  have h_comm : ∀ j : Fin 3, gamma5 * alpha j = alpha j * gamma5 := by
    simp +decide [ Fin.forall_fin_succ, alpha ];
    simp +decide [ alpha1, alpha2, alpha3, gamma5 ];
  unfold chiralUnitary; simp +decide [ *, mul_sub, sub_mul ] ;

theorem complex_phase_covariance (z : ℂ) (theta : ℝ) :
    chiralUnitary theta * mass4 z * (chiralUnitary theta)ᴴ =
      mass4 (Complex.exp (I * theta) * z) := by
  unfold mass4 chiralUnitary;
  ext i j;
  simp_all +decide [ Complex.exp_re, Complex.exp_im, Matrix.mul_apply, Fin.sum_univ_four ];
  simp +decide [ beta, beta5, gamma5, Matrix.one_apply ];
  fin_cases i <;> fin_cases j <;> simp +decide [ Complex.ext_iff, Real.cos_two_mul', Real.sin_two_mul ] <;> ring;
  all_goals norm_num [ Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin ] at *;
  all_goals rw [ show theta = 2 * ( theta / 2 ) by ring, Real.sin_two_mul, Real.cos_two_mul' ] ; ring

/-- Exact mass-only evolution generated by `mass4 z`. -/
def massCoin4 (z : ℂ) (a : ℝ) : Mat4 :=
  (Complex.cos (a * ‖z‖)) • (1 : Mat4) -
    (I * Complex.sin (a * ‖z‖) / (‖z‖ : ℂ)) • mass4 z

theorem massCoin4_unitary_group (z : ℂ) (hz : z ≠ 0) (a b : ℝ) :
    massCoin4 z a ∈ Matrix.unitaryGroup (Fin 4) ℂ ∧
      massCoin4 z a * massCoin4 z b = massCoin4 z (a + b) := by
  have := @mass4_hermitian_sq z;
  unfold massCoin4;
  constructor;
  · constructor;
    · simp_all +decide [ IsHermitian, mul_sub, sub_mul, mul_assoc, mul_left_comm, div_eq_mul_inv ];
      simp_all +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul, Complex.ext_iff ];
      simp_all +decide [ Complex.ext_iff, Matrix.mul_apply, star ];
      norm_cast ; simp_all +decide [ Complex.normSq_eq_norm_sq, Complex.norm_exp ];
      ext i j ; norm_num [ Complex.ext_iff, Matrix.mul_apply ] ; ring;
      norm_cast ; simp_all +decide [ Matrix.one_apply ];
      split_ifs <;> simp_all +decide [ Real.sin_sq, mul_assoc, mul_comm, mul_left_comm ];
      rw [ ← mul_assoc, mul_inv_cancel₀ ( pow_ne_zero 2 ( norm_ne_zero_iff.mpr ( show z ≠ 0 by aesop ) ) ), one_mul, add_sub_cancel ];
    · simp_all +decide [ mul_sub, sub_mul, mul_assoc, mul_left_comm, div_eq_mul_inv ];
      simp_all +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, smul_smul, IsHermitian ];
      simp_all +decide [ Complex.ext_iff, Matrix.IsHermitian, star ];
      norm_cast ; simp_all +decide [ Complex.normSq_eq_norm_sq, Complex.norm_exp ];
      ext i j ; norm_num [ Complex.ext_iff, Matrix.mul_apply ] ; ring;
      norm_cast ; simp_all +decide [ Matrix.one_apply ];
      split_ifs <;> simp_all +decide [ Real.sin_sq, mul_assoc, mul_comm, mul_left_comm ];
      rw [ ← mul_assoc, mul_inv_cancel₀ ( pow_ne_zero 2 ( norm_ne_zero_iff.mpr ( show z ≠ 0 by aesop ) ) ), one_mul, add_sub_cancel ];
  · simp_all +decide [ Complex.normSq_eq_norm_sq, Complex.norm_exp, mul_assoc, mul_left_comm, add_mul, mul_add, mul_sub, sub_mul, div_eq_mul_inv ];
    ext i j ; norm_num [ Complex.cos_add, Complex.sin_add ] ; ring;
    norm_num [ mul_assoc, mul_comm, mul_left_comm, hz ] ; ring

/-
A nondegenerate rational complex control with both mass directions active.
-/
theorem control_three_four_I :
    mass4 (3 + 4 * I) * mass4 (3 + 4 * I) =
      (25 : ℂ) • (1 : Mat4) ∧ mass4 (3 + 4 * I) ≠ 0 := by
  constructor;
  · convert mass4_hermitian_sq ( 3 + 4 * I ) |>.2 using 1 ; norm_num [ Complex.normSq ];
  · intro h; have := congr_fun ( congr_fun h 0 ) 0; norm_num [ mass4, beta, beta5, gamma5 ] at this;

theorem zero_boundary_control : mass4 0 = 0 ∧ H4 0 0 0 0 = 0 := by
  -- By definition of mass4 and H4, we have mass4 0 = 0 and H4 0 0 0 0 = 0.
  simp [mass4, H4]

end Plucker3Plus1ComplexMass
