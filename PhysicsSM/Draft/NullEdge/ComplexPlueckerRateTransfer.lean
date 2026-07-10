import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate
import PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass
import Mathlib.Analysis.SpecialFunctions.Complex.Arg

/-!
# Uniform continuum rate for the full complex Pluecker mass

The quantitative `3+1` continuum theorem was first proved for a nonnegative
real mass coefficient.  The live Pluecker mass, however, is complex.  This
module closes that mismatch without adding an independent mass parameter:
the complex phase is removed by the already-landed chiral unitary, the real
theorem is applied at mass `|z|`, and the result is conjugated back.

The central output is `complex_fixed_time_many_step_bound_on_box`.  It is an
operator-norm `O(1/n)` estimate, uniform on a compact momentum box and a bounded
Pluecker-mass disk.  The accompanying Hamiltonian conjugacy theorem identifies
the limiting generator with the actual complex operator `H4`, not merely with
an abstract unitarily equivalent fixture.

This is a finite-dimensional transfer argument.  It does not by itself prove
the later position-space/PDE convergence or a full Brillouin-zone statement.

Provenance: clean-room composition of the project modules
`Compact3Plus1DiracRate` and `Pluecker3Plus1ComplexMass`; the polar identity is
Mathlib's `Complex.norm_mul_exp_arg_mul_I`.  Lean 4.28.0.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer

open PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

abbrev realH := PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.H
abbrev realSplitStep :=
  PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.splitStep
abbrev realFactor := PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.factor
abbrev realExactFlow :=
  PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.exactFlow
abbrev realD4 := PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.D4
abbrev realDbox := PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.Dbox

/-- The polar phase used to rotate a real nonnegative mass into `z`. -/
def phase (z : Complex) : Mat4 := chiralUnitary z.arg

/-- Polar reconstruction in the multiplication order used by
`complex_phase_covariance`. -/
theorem polar_reconstruction (z : Complex) :
    Complex.exp (I * z.arg) * (‖z‖ : Complex) = z := by
  simpa [mul_comm] using Complex.norm_mul_exp_arg_mul_I z

theorem phase_mem_unitary (z : Complex) :
    phase z ∈ Matrix.unitaryGroup (Fin 4) Complex := by
  exact chiralUnitary_is_unitary z.arg

theorem phase_mul_star (z : Complex) : phase z * (phase z)ᴴ = 1 := by
  exact Matrix.mem_unitaryGroup_iff.mp (phase_mem_unitary z)

theorem phase_star_mul (z : Complex) : (phase z)ᴴ * phase z = 1 := by
  exact Matrix.mem_unitaryGroup_iff'.mp (phase_mem_unitary z)

/-- Chiral conjugation fixes each spatial Clifford generator. -/
theorem conjugates_spatial (z : Complex) (j : Fin 3) :
    phase z * alpha j * (phase z)ᴴ = alpha j := by
  change chiralUnitary z.arg * alpha j * (chiralUnitary z.arg)ᴴ = alpha j
  rw [chiralUnitary_commutes_spatial]
  rw [Matrix.mul_assoc]
  have hunit := phase_mul_star z
  change chiralUnitary z.arg * (chiralUnitary z.arg)ᴴ = 1 at hunit
  rw [hunit, Matrix.mul_one]

/-- The real-mass Hamiltonian at `|z|` is exactly conjugate to the complex
Pluecker Hamiltonian. -/
theorem conjugates_H (kx ky kz : Real) (z : Complex) :
    phase z * realH kx ky kz ‖z‖ * (phase z)ᴴ = H4 kx ky kz z := by
  have hx : phase z * alpha1 * (phase z)ᴴ = alpha1 := by
    simpa [alpha] using conjugates_spatial z 0
  have hy : phase z * alpha2 * (phase z)ᴴ = alpha2 := by
    simpa [alpha] using conjugates_spatial z 1
  have hz : phase z * alpha3 * (phase z)ᴴ = alpha3 := by
    simpa [alpha] using conjugates_spatial z 2
  have hm := complex_phase_covariance (‖z‖ : Complex) z.arg
  rw [polar_reconstruction] at hm
  have hm' :
      phase z * ((‖z‖ : Complex) • beta) * (phase z)ᴴ = mass4 z := by
    rw [← real_mass_reduces]
    exact hm
  have hm'' :
      (‖z‖ : Complex) • (phase z * beta * (phase z)ᴴ) = mass4 z := by
    simpa only [Matrix.mul_smul, Matrix.smul_mul] using hm'
  change phase z *
      ((kx : Complex) • alpha1 + (ky : Complex) • alpha2 +
        (kz : Complex) • alpha3 + (‖z‖ : Complex) • beta) *
      (phase z)ᴴ =
    (kx : Complex) • alpha1 + (ky : Complex) • alpha2 +
      (kz : Complex) • alpha3 + mass4 z
  simp only [Matrix.mul_add, Matrix.add_mul, Matrix.mul_smul,
    Matrix.smul_mul]
  rw [hx, hy, hz, hm'']

/-- On the positive real axis, the explicit complex mass coin is exactly the
real split factor used by the quantitative theorem. -/
theorem real_massCoin4_eq_factor (m eps : Real) (hm : 0 < m) :
    massCoin4 (m : Complex) eps = realFactor (m * eps) beta := by
  have hnorm : ‖(m : Complex)‖ = m := by
    simp [norm_real, abs_of_pos hm]
  unfold massCoin4
  rw [real_mass_reduces]
  unfold realFactor PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.factor
  rw [hnorm]
  ext i j
  simp [Complex.ofReal_mul, Complex.ofReal_cos, Complex.ofReal_sin]
  have hmC : (m : Complex) ≠ 0 := Complex.ofReal_ne_zero.mpr hm.ne'
  field_simp [hmC]

/-- The explicit phase-retaining coin is the chiral conjugate of the real
mass factor at `|z|`. -/
theorem conjugates_real_factor_to_massCoin4
    (z : Complex) (hz : z ≠ 0) (eps : Real) :
    phase z * realFactor (‖z‖ * eps) beta * (phase z)ᴴ =
      massCoin4 z eps := by
  have hpositive : 0 < ‖z‖ := norm_pos_iff.mpr hz
  have hcoin := complex_phase_covariance (‖z‖ : Complex) z.arg
  rw [polar_reconstruction] at hcoin
  rw [← real_massCoin4_eq_factor ‖z‖ eps hpositive]
  have hnormReal : ‖(‖z‖ : Complex)‖ = ‖z‖ := by simp
  unfold massCoin4
  rw [hnormReal]
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul,
    Matrix.smul_mul, Matrix.mul_assoc]
  simp only [Matrix.one_mul]
  simp_rw [← Matrix.mul_assoc]
  change phase z * mass4 (‖z‖ : Complex) * (phase z)ᴴ = mass4 z at hcoin
  rw [phase_mul_star, hcoin]

/-- Chiral conjugation fixes every real spatial factor. -/
theorem conjugates_spatial_factor (z : Complex) (q : Real) (j : Fin 3) :
    phase z * realFactor q (alpha j) * (phase z)ᴴ =
      realFactor q (alpha j) := by
  unfold realFactor PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.factor
  simp only [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul,
    Matrix.smul_mul, Matrix.mul_assoc]
  simp only [Matrix.one_mul]
  simp_rw [← Matrix.mul_assoc]
  rw [phase_mul_star, conjugates_spatial]

/-- Conjugation is multiplicative because the chiral phase is unitary. -/
theorem phase_conjugate_mul (z : Complex) (A B : Mat4) :
    phase z * (A * B) * (phase z)ᴴ =
      (phase z * A * (phase z)ᴴ) *
        (phase z * B * (phase z)ᴴ) := by
  calc
    phase z * (A * B) * (phase z)ᴴ =
        phase z * A * ((phase z)ᴴ * phase z) * B * (phase z)ᴴ := by
      rw [phase_star_mul]
      simp [Matrix.mul_assoc]
    _ = (phase z * A * (phase z)ᴴ) *
        (phase z * B * (phase z)ᴴ) := by
      simp [Matrix.mul_assoc]

/-- Explicit product form of the complex split step used by the finite local
walk. -/
def explicitComplexSplitStep
    (kx ky kz : Real) (z : Complex) (eps : Real) : Mat4 :=
  realFactor (kx * eps) alpha1 * realFactor (ky * eps) alpha2 *
    realFactor (kz * eps) alpha3 * massCoin4 z eps

/-- The complex split step is the chiral transport of the landed real-mass
split step at mass `|z|`.  Because the chiral unitary fixes all spatial
generators, only the rest coin is rotated. -/
def complexSplitStep (kx ky kz : Real) (z : Complex) (eps : Real) : Mat4 :=
  phase z * realSplitStep kx ky kz ‖z‖ eps * (phase z)ᴴ

/-- The conjugacy-defined complex step in the rate theorem is exactly the
phase-retaining product implemented by the local walk. -/
theorem complexSplitStep_eq_explicit
    (kx ky kz : Real) (z : Complex) (hz : z ≠ 0) (eps : Real) :
    complexSplitStep kx ky kz z eps =
      explicitComplexSplitStep kx ky kz z eps := by
  unfold complexSplitStep realSplitStep
  unfold PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.splitStep
  rw [phase_conjugate_mul, phase_conjugate_mul, phase_conjugate_mul]
  rw [show PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha1 = alpha 0 by rfl,
    show PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha2 = alpha 1 by rfl,
    show PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.alpha3 = alpha 2 by rfl]
  rw [conjugates_spatial_factor, conjugates_spatial_factor,
    conjugates_spatial_factor]
  rw [show PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.beta = beta by rfl]
  rw [conjugates_real_factor_to_massCoin4 z hz]
  rfl

/-- The complex exact flow is the same transport applied to the landed exact
real-mass flow. -/
def complexExactFlow (kx ky kz : Real) (z : Complex) (t : Real) : Mat4 :=
  phase z * realExactFlow kx ky kz ‖z‖ t * (phase z)ᴴ

theorem phase_conjugate_pow (z : Complex) (A : Mat4) (n : Nat) :
    (phase z * A * (phase z)ᴴ) ^ n =
      phase z * A ^ n * (phase z)ᴴ := by
  induction n with
  | zero =>
      simp [phase_mul_star]
  | succ n ih =>
      rw [pow_succ, pow_succ, ih]
      simp only [Matrix.mul_assoc]
      rw [← Matrix.mul_assoc (phase z)ᴴ (phase z)]
      rw [phase_star_mul, Matrix.one_mul]

/-- Conjugation by the chiral unitary cannot increase the operator norm. -/
theorem norm_phase_conjugate_le (z : Complex) (A : Mat4) :
    ‖phase z * A * (phase z)ᴴ‖ ≤ ‖A‖ := by
  have hphase : ‖phase z‖ = 1 :=
    CStarRing.norm_of_mem_unitary (phase_mem_unitary z)
  have hphaseStarMem :
      (phase z)ᴴ ∈ Matrix.unitaryGroup (Fin 4) Complex := by
    rw [Matrix.mem_unitaryGroup_iff]
    change (phase z)ᴴ * (phase z)ᴴᴴ = 1
    rw [Matrix.conjTranspose_conjTranspose]
    exact phase_star_mul z
  have hphaseStar : ‖(phase z)ᴴ‖ = 1 :=
    CStarRing.norm_of_mem_unitary hphaseStarMem
  calc
    ‖phase z * A * (phase z)ᴴ‖
        ≤ ‖phase z * A‖ * ‖(phase z)ᴴ‖ := norm_mul_le _ _
    _ ≤ (‖phase z‖ * ‖A‖) * ‖(phase z)ᴴ‖ := by
      gcongr
      exact norm_mul_le _ _
    _ = ‖A‖ := by rw [hphase, hphaseStar]; ring

/-- The complex flow is the matrix exponential generated by the actual
complex Pluecker Hamiltonian `H4`. -/
theorem complexExactFlow_eq_exp_H4
    (kx ky kz : Real) (z : Complex) (t : Real) :
    complexExactFlow kx ky kz z t =
      NormedSpace.exp ((-(t : Complex)) • (I • H4 kx ky kz z)) := by
  let U := phase z
  let A : Mat4 := (-(t : Complex)) • (I • realH kx ky kz ‖z‖)
  have hUstar : U * Uᴴ = 1 := phase_mul_star z
  have hUunit : IsUnit U := isUnit_iff_exists_inv.mpr ⟨Uᴴ, hUstar⟩
  have hUinv : U⁻¹ = Uᴴ := Matrix.inv_eq_right_inv hUstar
  have hconj := Matrix.exp_conj U A hUunit
  rw [hUinv] at hconj
  rw [complexExactFlow, realExactFlow,
    PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.exactFlow]
  rw [← hconj]
  congr 1
  dsimp [U, A]
  simp only [Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_assoc]
  rw [← Matrix.mul_assoc, conjugates_H]

/-- Exact complex-mass fixed-time rate at one momentum. -/
theorem complex_fixed_time_many_step_bound
    (kx ky kz : Real) (z : Complex) (t : Real) (n : Nat)
    (hn : 0 < n) (hsmall : |t / (n : Real)| ≤ 1) :
    ‖(complexSplitStep kx ky kz z (t / (n : Real))) ^ n -
        complexExactFlow kx ky kz z t‖ ≤
      realD4 kx ky kz ‖z‖ * t ^ 2 / n := by
  rw [complexSplitStep, complexExactFlow, phase_conjugate_pow]
  have hdiff :
      phase z * (realSplitStep kx ky kz ‖z‖ (t / (n : Real))) ^ n *
          (phase z)ᴴ -
        phase z * realExactFlow kx ky kz ‖z‖ t * (phase z)ᴴ =
      phase z *
          ((realSplitStep kx ky kz ‖z‖ (t / (n : Real))) ^ n -
            realExactFlow kx ky kz ‖z‖ t) *
        (phase z)ᴴ := by
    simp [Matrix.mul_sub, Matrix.sub_mul]
  rw [hdiff]
  exact le_trans (norm_phase_conjugate_le z _)
    (PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.fixed_time_many_step_bound
      kx ky kz ‖z‖ t n hn hsmall)

/-- Uniform complex-mass `O(1/n)` estimate on a compact momentum box and a
bounded Pluecker-mass disk. -/
theorem complex_fixed_time_many_step_bound_on_box
    (kx ky kz K M t : Real) (z : Complex) (n : Nat)
    (hn : 0 < n) (hsmall : |t / (n : Real)| ≤ 1)
    (hK : 0 ≤ K) (hM : 0 ≤ M)
    (hx : |kx| ≤ K) (hy : |ky| ≤ K) (hz : |kz| ≤ K)
    (hm : ‖z‖ ≤ M) :
    ‖(complexSplitStep kx ky kz z (t / (n : Real))) ^ n -
        complexExactFlow kx ky kz z t‖ ≤
      realDbox K M * t ^ 2 / n := by
  rw [complexSplitStep, complexExactFlow, phase_conjugate_pow]
  have hdiff :
      phase z * (realSplitStep kx ky kz ‖z‖ (t / (n : Real))) ^ n *
          (phase z)ᴴ -
        phase z * realExactFlow kx ky kz ‖z‖ t * (phase z)ᴴ =
      phase z *
          ((realSplitStep kx ky kz ‖z‖ (t / (n : Real))) ^ n -
            realExactFlow kx ky kz ‖z‖ t) *
        (phase z)ᴴ := by
    simp [Matrix.mul_sub, Matrix.sub_mul]
  rw [hdiff]
  exact le_trans (norm_phase_conjugate_le z _)
    (PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate.fixed_time_many_step_bound_on_box
      kx ky kz ‖z‖ K M t n hn hsmall hK hM hx hy hz
      (by simpa [abs_of_nonneg (norm_nonneg z)] using hm))

end PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.conjugates_H' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.conjugates_H

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexExactFlow_eq_exp_H4' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexExactFlow_eq_exp_H4

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexSplitStep_eq_explicit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complexSplitStep_eq_explicit

/-- info: 'PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complex_fixed_time_many_step_bound_on_box' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ComplexPlueckerRateTransfer.complex_fixed_time_many_step_bound_on_box
