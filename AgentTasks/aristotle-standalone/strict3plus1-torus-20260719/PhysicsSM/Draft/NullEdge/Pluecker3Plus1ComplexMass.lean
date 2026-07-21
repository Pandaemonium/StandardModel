import PhysicsSM.Draft.NullEdge.SuccessiveAxisDiracWalk

/-!
# Complex Pluecker mass in the live 3+1 Clifford representation

The two-spinor Pluecker coordinate is complex, whereas the first live `3+1`
walk used only its modulus as a scalar coefficient of `beta`.  This module
retains the full phase.  Its real and imaginary parts multiply two Hermitian,
anticommuting mass generators, producing a four-component operator `mass4 z`
whose square is exactly `|z|^2 I`.  The resulting Dirac symbol has the exact
relativistic square and transforms covariantly under a chiral phase rotation.

The displayed spatial and real-mass generators are definitionally the ones in
`SuccessiveAxisDiracWalk`; this is a lift of the live representation rather
than an unrelated matrix fixture.  A derived mass-coin one-parameter group is
the remaining successor theorem and is not asserted here.

Provenance: clean-room integration of the completed core of Aristotle project
`64ead89b-7476-41c9-abb6-fd2ed10cc639`, checked under Lean 4.28.0.
-/

noncomputable section

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

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

def alpha : Fin 3 -> Mat4
  | 0 => alpha1
  | 1 => alpha2
  | 2 => alpha3

/-- Four-component rest operator carrying the full complex Pluecker phase. -/
def mass4 (z : Complex) : Mat4 :=
  (z.re : Complex) • beta + (z.im : Complex) • beta5

/-- The `3+1` Dirac Hamiltonian with no independent scalar mass slot. -/
def H4 (kx ky kz : Real) (z : Complex) : Mat4 :=
  (kx : Complex) • alpha1 + (ky : Complex) • alpha2 +
    (kz : Complex) • alpha3 + mass4 z

/-- The spatial and real-mass generators are exactly the live walk's
generators. -/
theorem agrees_with_live_generators :
    alpha1 = SuccessiveAxisDiracWalk.alpha1 ∧
      alpha2 = SuccessiveAxisDiracWalk.alpha2 ∧
      alpha3 = SuccessiveAxisDiracWalk.alpha3 ∧
      beta = SuccessiveAxisDiracWalk.beta := by
  exact ⟨rfl, rfl, rfl, rfl⟩

theorem mass_generators_clifford :
    beta.IsHermitian ∧ beta5.IsHermitian ∧
      beta * beta = 1 ∧ beta5 * beta5 = 1 ∧
      beta * beta5 + beta5 * beta = 0 := by
  refine' ⟨_, _, _, _, _⟩
  · unfold beta
    ext i j
    fin_cases i <;> fin_cases j <;> norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Complex.ext_iff, Matrix.mul_apply]
    all_goals unfold beta5
    all_goals norm_num [beta, gamma5]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ, beta]
  · ext i j
    fin_cases i <;> fin_cases j <;> simp +decide [beta5, beta, gamma5]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_succ, beta, beta5, gamma5]

theorem spatial_anticommutes_mass_generators (j : Fin 3) :
    alpha j * beta + beta * alpha j = 0 ∧
      alpha j * beta5 + beta5 * alpha j = 0 := by
  fin_cases j <;> unfold alpha <;> simp +decide [*, Fin.sum_univ_four]
  · simp +decide [alpha1, beta, beta5, gamma5]
    exact Matrix.ext fun i j => by fin_cases i <;> fin_cases j <;> rfl
  · simp [alpha2, beta, beta5]
    simp +decide [<- Matrix.ext_iff, Fin.forall_fin_succ, vecHead, vecTail,
      Matrix.vecMul, gamma5] at *
  · unfold alpha3 beta beta5
    norm_num [<- List.ofFn_inj]
    unfold beta gamma5
    norm_num [<- List.ofFn_inj]
    exact Matrix.ext fun i j => by fin_cases i <;> fin_cases j <;> rfl

theorem spatial_generators_clifford :
    (forall j, (alpha j).IsHermitian ∧ alpha j * alpha j = 1) ∧
      (forall i j, i ≠ j -> alpha i * alpha j + alpha j * alpha i = 0) := by
  simp +decide [Fin.forall_fin_succ, IsHermitian]
  simp +decide [alpha, alpha1, alpha2, alpha3]
  simp +decide [<- Matrix.ext_iff, Fin.forall_fin_succ]

/-- The full complex phase changes the operator but not its scalar square. -/
theorem mass4_hermitian_sq (z : Complex) :
    (mass4 z).IsHermitian ∧
      mass4 z * mass4 z =
        (Complex.normSq z : Complex) • (1 : Mat4) := by
  simp_all +decide [Complex.normSq, Complex.ext_iff, Matrix.IsHermitian]
  unfold mass4
  simp +decide [beta, beta5, alpha1, alpha2, alpha3, gamma5]
  simp +decide [<- Matrix.ext_iff, Fin.forall_fin_succ]
  ring_nf
  norm_num

/-- The complex mass operator vanishes exactly on the collinear boundary. -/
theorem mass4_eq_zero_iff (z : Complex) : mass4 z = 0 ↔ z = 0 := by
  constructor <;> intro h <;> simp_all +decide [Complex.ext_iff, mass4]
  unfold beta beta5 at h
  have h0 := congr_fun (congr_fun h 0) 0
  have h1 := congr_fun (congr_fun h 1) 0
  have h2 := congr_fun (congr_fun h 2) 0
  have h3 := congr_fun (congr_fun h 3) 0
  simp_all +decide [Complex.ext_iff]
  unfold beta gamma5 at *
  simp_all +decide [Complex.ext_iff]

/-- Exact `3+1` relativistic square with mass derived from `z`. -/
theorem H4_sq (kx ky kz : Real) (z : Complex) :
    H4 kx ky kz z * H4 kx ky kz z =
      (((kx ^ 2 + ky ^ 2 + kz ^ 2 + Complex.normSq z : Real) : Complex)) •
        (1 : Mat4) := by
  unfold H4
  simp +decide [mul_assoc, Finset.sum_add_distrib, Finset.mul_sum,
    Finset.sum_mul, mul_add, add_mul, pow_two, mul_comm, mul_left_comm,
    add_assoc]
  ring
  have hcross :
      alpha1 * alpha2 + alpha2 * alpha1 = 0 ∧
      alpha1 * alpha3 + alpha3 * alpha1 = 0 ∧
      alpha2 * alpha3 + alpha3 * alpha2 = 0 ∧
      alpha1 * mass4 z + mass4 z * alpha1 = 0 ∧
      alpha2 * mass4 z + mass4 z * alpha2 = 0 ∧
      alpha3 * mass4 z + mass4 z * alpha3 = 0 := by
    have hm : forall j : Fin 3,
        alpha j * mass4 z + mass4 z * alpha j = 0 := by
      unfold mass4
      intro j
      have h := spatial_anticommutes_mass_generators j
      simp_all +decide [mul_add, add_mul]
      simp_all +decide [<- eq_sub_iff_add_eq', <- Matrix.ext_iff]
    exact ⟨by simpa using spatial_generators_clifford.2 0 1 (by decide),
      by simpa using spatial_generators_clifford.2 0 2 (by decide),
      by simpa using spatial_generators_clifford.2 1 2 (by decide),
      hm 0, hm 1, hm 2⟩
  have hsquares :
      alpha1 * alpha1 = 1 ∧ alpha2 * alpha2 = 1 ∧
      alpha3 * alpha3 = 1 ∧
      mass4 z * mass4 z = (Complex.normSq z : Complex) • (1 : Mat4) := by
    exact ⟨by
      unfold alpha1
      ext i j
      fin_cases i <;> fin_cases j <;>
        norm_num [Matrix.mul_apply, Fin.sum_univ_succ],
      by
        unfold alpha2
        ext i j
        fin_cases i <;> fin_cases j <;>
          norm_num [Matrix.mul_apply, Fin.sum_univ_succ],
      by
        unfold alpha3
        ext i j
        fin_cases i <;> fin_cases j <;>
          norm_num [Matrix.mul_apply, Fin.sum_univ_succ],
      (mass4_hermitian_sq z).2⟩
  simp_all +decide [<- eq_sub_iff_add_eq', <- mul_assoc, <- add_mul,
    <- mul_add, <- smul_assoc]
  ext i j
  norm_num
  ring

/-- On the real axis, the complex operator reduces to the live `m beta` mass
term. -/
theorem real_mass_reduces (m : Real) :
    mass4 (m : Complex) = (m : Complex) • beta := by
  unfold mass4
  aesop

/-- Chiral phase rotation. -/
def chiralUnitary (theta : Real) : Mat4 :=
  (Real.cos (theta / 2) : Complex) • (1 : Mat4) -
    (I * (Real.sin (theta / 2) : Complex)) • gamma5

theorem chiralUnitary_is_unitary (theta : Real) :
    chiralUnitary theta ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  unfold chiralUnitary
  simp +decide [mul_eq_one_comm]
  constructor <;> norm_num [<- Matrix.ext_iff, Fin.forall_fin_succ]
  · simp +decide [Matrix.mul_apply, Fin.sum_univ_succ, Fin.sum_univ_zero,
      gamma5]
    simp +decide [Complex.ext_iff, Matrix.one_apply]
    norm_cast
    ring_nf
    norm_num
    norm_num [Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin]
  · simp +decide [Matrix.mul_apply, Fin.sum_univ_succ, gamma5]
    simp +decide [Complex.ext_iff, Matrix.one_apply]
    ring_nf
    norm_num [Real.sin_sq, Real.cos_sq]
    norm_num [Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin]

theorem chiralUnitary_commutes_spatial (theta : Real) (j : Fin 3) :
    chiralUnitary theta * alpha j = alpha j * chiralUnitary theta := by
  have hcomm : forall j : Fin 3, gamma5 * alpha j = alpha j * gamma5 := by
    simp +decide [Fin.forall_fin_succ, alpha]
    simp +decide [alpha1, alpha2, alpha3, gamma5]
  unfold chiralUnitary
  simp +decide [*, mul_sub, sub_mul]

/-- The full complex Pluecker phase is a chiral basis rotation, while every
spatial generator is fixed. -/
theorem complex_phase_covariance (z : Complex) (theta : Real) :
    chiralUnitary theta * mass4 z * (chiralUnitary theta)ᴴ =
      mass4 (Complex.exp (I * theta) * z) := by
  unfold mass4 chiralUnitary
  ext i j
  simp_all +decide [Complex.exp_re, Complex.exp_im, Matrix.mul_apply,
    Fin.sum_univ_four]
  simp +decide [beta, beta5, gamma5, Matrix.one_apply]
  fin_cases i <;> fin_cases j <;>
    simp +decide [Complex.ext_iff, Real.cos_two_mul', Real.sin_two_mul] <;>
      ring
  all_goals
    norm_num [Complex.exp_re, Complex.exp_im, Complex.cos, Complex.sin] at *
  all_goals
    rw [show theta = 2 * (theta / 2) by ring, Real.sin_two_mul,
      Real.cos_two_mul']
    ring

/-- Exact mass-only evolution generated by the complex Pluecker rest
operator. -/
def massCoin4 (z : Complex) (a : Real) : Mat4 :=
  (Complex.cos (a * ‖z‖)) • (1 : Mat4) -
    (I * Complex.sin (a * ‖z‖) / (‖z‖ : Complex)) • mass4 z

/-- Away from the collinear boundary, the derived mass coin is unitary and
obeys the exact one-parameter group law. -/
theorem massCoin4_unitary_group (z : Complex) (hz : z ≠ 0) (a b : Real) :
    massCoin4 z a ∈ Matrix.unitaryGroup (Fin 4) Complex ∧
      massCoin4 z a * massCoin4 z b = massCoin4 z (a + b) := by
  have hmass := mass4_hermitian_sq z
  unfold massCoin4
  constructor
  · constructor
    · simp_all +decide [IsHermitian, mul_sub, sub_mul, mul_assoc,
        mul_left_comm, div_eq_mul_inv]
      simp_all +decide [mul_add, add_mul, mul_assoc, mul_left_comm,
        smul_smul, Complex.ext_iff]
      simp_all +decide [Complex.ext_iff, Matrix.mul_apply, star]
      norm_cast
      simp_all +decide [Complex.normSq_eq_norm_sq, Complex.norm_exp]
      ext i j
      norm_num [Complex.ext_iff, Matrix.mul_apply]
      ring
      norm_cast
      simp_all +decide [Matrix.one_apply]
      split_ifs <;>
        simp_all +decide [Real.sin_sq, mul_assoc, mul_comm, mul_left_comm]
      rw [<- mul_assoc,
        mul_inv_cancel₀ (pow_ne_zero 2
          (norm_ne_zero_iff.mpr (show z ≠ 0 by aesop))),
        one_mul, add_sub_cancel]
    · simp_all +decide [mul_sub, sub_mul, mul_assoc, mul_left_comm,
        div_eq_mul_inv]
      simp_all +decide [mul_add, add_mul, mul_assoc, mul_left_comm,
        smul_smul, IsHermitian]
      simp_all +decide [Complex.ext_iff, Matrix.IsHermitian, star]
      norm_cast
      simp_all +decide [Complex.normSq_eq_norm_sq, Complex.norm_exp]
      ext i j
      norm_num [Complex.ext_iff, Matrix.mul_apply]
      ring
      norm_cast
      simp_all +decide [Matrix.one_apply]
      split_ifs <;>
        simp_all +decide [Real.sin_sq, mul_assoc, mul_comm, mul_left_comm]
      rw [<- mul_assoc,
        mul_inv_cancel₀ (pow_ne_zero 2
          (norm_ne_zero_iff.mpr (show z ≠ 0 by aesop))),
        one_mul, add_sub_cancel]
  · simp_all +decide [Complex.normSq_eq_norm_sq, Complex.norm_exp, mul_assoc,
      mul_left_comm, add_mul, mul_add, mul_sub, sub_mul, div_eq_mul_inv]
    ext i j
    norm_num [Complex.cos_add, Complex.sin_add]
    ring
    norm_num [mul_assoc, mul_comm, mul_left_comm, hz]
    ring

/-- A nondegenerate rational complex control with both mass directions active. -/
theorem control_three_four_I :
    mass4 (3 + 4 * I) * mass4 (3 + 4 * I) =
      (25 : Complex) • (1 : Mat4) ∧ mass4 (3 + 4 * I) ≠ 0 := by
  constructor
  · convert (mass4_hermitian_sq (3 + 4 * I)).2 using 1
    norm_num [Complex.normSq]
  · intro h
    have h00 := congr_fun (congr_fun h 0) 0
    norm_num [mass4, beta, beta5, gamma5] at h00

theorem zero_boundary_control : mass4 0 = 0 ∧ H4 0 0 0 0 = 0 := by
  simp [mass4, H4]

end PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.mass4_hermitian_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.mass4_hermitian_sq

/-- info: 'PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.H4_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.H4_sq

/-- info: 'PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.complex_phase_covariance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.complex_phase_covariance

/-- info: 'PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4_unitary_group' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4_unitary_group

/-- info: 'PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.control_three_four_I' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.control_three_four_I
