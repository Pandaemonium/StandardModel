import PhysicsSM.Draft.NullEdge.SuccessiveAxisPositionWalk

/-!
# Explicit Clifford eigenbases for the finite position walk

The componentwise tetrahedral sign table is diagonal, whereas the project
spatial Clifford generators are off-diagonal. This module supplies the missing
constructive dictionary. For each axis, an explicit unitary matrix conjugates
the sign diagonal to exactly `alpha1`, `alpha2`, or `alpha3`. The corresponding
finite-torus conditional shift is conjugated into the Clifford basis, remains
exactly norm preserving, and has Fourier-symbol derivative `-i alpha_j`.

The identity basis fails explicitly, so the basis dictionary is load-bearing.
This closes the finite position-walk-to-Dirac-tangent seam. The frame, lattice
spacing, action selecting this walk, compact-momentum rate, and continuum/PDE
limit remain separate obligations.

Provenance: clean-room construction informed by the complementary-projector
successive-axis walk in Mlodinow-Brun, arXiv:1802.03910. Mathlib's Hermitian
spectral theorem was consulted as an API reference; the displayed bases and
all identities here are explicit.
-/

open Matrix Complex
open scoped BigOperators

namespace PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge

abbrev Axis := SuccessiveAxisPositionWalk.Axis
abbrev Internal := SuccessiveAxisPositionWalk.Internal
abbrev Mat4 := SuccessiveAxisDiracWalk.Mat4
abbrev Position (L : ℕ) := SuccessiveAxisPositionWalk.Position L
abbrev State (L : ℕ) := SuccessiveAxisPositionWalk.State L
abbrev IsUnitary := SuccessiveAxisDiracWalk.IsUnitary

def generator (axis : Axis) : Mat4 :=
  match axis with
  | 0 => SuccessiveAxisDiracWalk.alpha1
  | 1 => SuccessiveAxisDiracWalk.alpha2
  | 2 => SuccessiveAxisDiracWalk.alpha3

def velocitySign (axis : Axis) (a : Internal) : ℂ :=
  if SuccessiveAxisPositionWalk.tetraVelocity axis a then -1 else 1

def velocityDiag (axis : Axis) : Mat4 :=
  diagonal (velocitySign axis)

noncomputable def s : ℝ := Real.sqrt 2 / 2

/-- Columns are ordered eigenvectors with eigenvalues matching the existing
component sign table. -/
noncomputable def axisBasis (axis : Axis) : Mat4 :=
  match axis with
  | 0 => !![s, 0, s, 0; 0, s, 0, s; 0, -s, 0, s; -s, 0, s, 0]
  | 1 => !![s, s, 0, 0; 0, 0, s, s; 0, 0, I * s, -I * s;
      -I * s, I * s, 0, 0]
  | 2 => !![s, s, 0, 0; 0, 0, s, s; -s, s, 0, 0; 0, 0, -s, s]

theorem velocityDiag_zero : velocityDiag 0 =
    !![-1, 0, 0, 0; 0, -1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

theorem velocityDiag_one : velocityDiag 1 =
    !![-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

theorem velocityDiag_two : velocityDiag 2 =
    !![-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, -1] := by
  ext i j
  fin_cases i <;> fin_cases j <;> rfl

theorem s_mul_s_real : s * s = (1 / 2 : ℝ) := by
  have hsqrt : (Real.sqrt 2) ^ 2 = (2 : ℝ) :=
    Real.sq_sqrt (by norm_num)
  norm_num [s]
  nlinarith

theorem axisBasis_zero_unitary : IsUnitary (axisBasis 0) := by
  constructor <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [axisBasis, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_one_unitary : IsUnitary (axisBasis 1) := by
  constructor <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [axisBasis, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_two_unitary : IsUnitary (axisBasis 2) := by
  constructor <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
    simp [axisBasis, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_unitary (axis : Axis) : IsUnitary (axisBasis axis) := by
  fin_cases axis
  · simpa using axisBasis_zero_unitary
  · simpa using axisBasis_one_unitary
  · simpa using axisBasis_two_unitary

theorem velocityDiag_square_one (axis : Axis) :
    velocityDiag axis * velocityDiag axis = 1 := by
  ext i j
  by_cases hij : i = j
  · subst j
    by_cases hsign : SuccessiveAxisPositionWalk.tetraVelocity axis i <;>
      simp [velocityDiag, velocitySign, hsign]
  · simp [velocityDiag, velocitySign, hij]

theorem axisBasis_zero_conjugates :
    axisBasis 0 * velocityDiag 0 * (axisBasis 0)ᴴ =
      SuccessiveAxisDiracWalk.alpha1 := by
  rw [velocityDiag_zero]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [axisBasis, SuccessiveAxisDiracWalk.alpha1, Matrix.mul_apply,
      Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_one_conjugates :
    axisBasis 1 * velocityDiag 1 * (axisBasis 1)ᴴ =
      SuccessiveAxisDiracWalk.alpha2 := by
  rw [velocityDiag_one]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [axisBasis, SuccessiveAxisDiracWalk.alpha2, Matrix.mul_apply,
      Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_two_conjugates :
    axisBasis 2 * velocityDiag 2 * (axisBasis 2)ᴴ =
      SuccessiveAxisDiracWalk.alpha3 := by
  rw [velocityDiag_two]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [axisBasis, SuccessiveAxisDiracWalk.alpha3, Matrix.mul_apply,
      Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

/-- The diagonal component velocities become the three live off-diagonal
Clifford generators in explicit eigenbases. -/
theorem axisBasis_conjugates_velocity (axis : Axis) :
    axisBasis axis * velocityDiag axis * (axisBasis axis)ᴴ = generator axis := by
  fin_cases axis
  · simpa [generator] using axisBasis_zero_conjugates
  · simpa [generator] using axisBasis_one_conjugates
  · simpa [generator] using axisBasis_two_conjugates

/-- Negative control: the raw diagonal table is not already the first spatial
Clifford generator. -/
theorem identity_basis_fails_axis_zero :
    velocityDiag 0 ≠ SuccessiveAxisDiracWalk.alpha1 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [velocityDiag, velocitySign,
    SuccessiveAxisPositionWalk.tetraVelocity,
    SuccessiveAxisDiracWalk.alpha1] at h00

noncomputable def phaseDiag (axis : Axis) (eps : ℝ) : Mat4 :=
  diagonal fun a =>
    (Real.cos eps : ℂ) - I * velocitySign axis a * Real.sin eps

noncomputable def axisSymbol (axis : Axis) (eps : ℝ) : Mat4 :=
  axisBasis axis * phaseDiag axis eps * (axisBasis axis)ᴴ

theorem phaseDiag_eq (axis : Axis) (eps : ℝ) :
    phaseDiag axis eps =
      (Real.cos eps : ℂ) • (1 : Mat4) -
        (I * (Real.sin eps : ℂ)) • velocityDiag axis := by
  ext i j
  by_cases hij : i = j
  · subst j
    simp [phaseDiag, velocityDiag, velocitySign]
  · simp [phaseDiag, velocityDiag, hij]

theorem axisSymbol_closed_form (axis : Axis) (eps : ℝ) :
    axisSymbol axis eps =
      (Real.cos eps : ℂ) • (1 : Mat4) -
        (I * (Real.sin eps : ℂ)) • generator axis := by
  rw [axisSymbol, phaseDiag_eq]
  simp [Matrix.mul_sub, Matrix.sub_mul, (axisBasis_unitary axis).2,
    axisBasis_conjugates_velocity axis]

theorem axisSymbol_at_zero (axis : Axis) : axisSymbol axis 0 = 1 := by
  simp [axisSymbol_closed_form]

/-- The conjugated conditional-shift symbol has the exact infinitesimal
spatial Dirac generator. -/
theorem axisSymbol_entry_hasDerivAt (axis : Axis) (i j : Internal) :
    HasDerivAt (fun eps : ℝ => axisSymbol axis eps i j)
      ((-I) * generator axis i j) 0 := by
  have hcos :
      HasDerivAt (fun eps : ℝ => (Real.cos eps : ℂ)) 0 0 := by
    convert (Real.hasDerivAt_cos 0).ofReal_comp using 1
    all_goals norm_num
  have hsin :
      HasDerivAt (fun eps : ℝ => (Real.sin eps : ℂ)) 1 0 := by
    convert (Real.hasDerivAt_sin 0).ofReal_comp using 1
    all_goals norm_num
  have hentry := (hcos.mul_const ((1 : Mat4) i j)).sub
    ((HasDerivAt.const_mul I hsin).mul_const (generator axis i j))
  simpa [axisSymbol_closed_form, mul_comm, mul_left_comm, mul_assoc] using hentry

theorem conjTranspose_unitary (U : Mat4) (hU : IsUnitary U) :
    IsUnitary Uᴴ := by
  constructor
  · simpa using hU.2
  · simpa using hU.1

/-- Component shift conjugated into the live physical Clifford basis. -/
noncomputable def cliffordAxisShift {L : ℕ} (axis : Axis)
    (psi : State L) : State L :=
  SuccessiveAxisPositionWalk.pointwiseCoin (axisBasis axis)
    (SuccessiveAxisPositionWalk.conditionalShift
      SuccessiveAxisPositionWalk.tetraVelocity axis
      (SuccessiveAxisPositionWalk.pointwiseCoin ((axisBasis axis)ᴴ) psi))

theorem cliffordAxisShift_inner {L : ℕ} [NeZero L]
    (axis : Axis) (psi phi : State L) :
    SuccessiveAxisPositionWalk.inner (cliffordAxisShift axis psi)
        (cliffordAxisShift axis phi) =
      SuccessiveAxisPositionWalk.inner psi phi := by
  unfold cliffordAxisShift
  rw [SuccessiveAxisPositionWalk.pointwiseCoin_inner _
      (axisBasis_unitary axis),
    SuccessiveAxisPositionWalk.conditionalShift_inner,
    SuccessiveAxisPositionWalk.pointwiseCoin_inner _
      (conjTranspose_unitary _ (axisBasis_unitary axis))]

noncomputable def spatialStep {L : ℕ} (psi : State L) : State L :=
  cliffordAxisShift 2 (cliffordAxisShift 1 (cliffordAxisShift 0 psi))

theorem spatialStep_preserves_norm {L : ℕ} [NeZero L]
    (psi : State L) :
    SuccessiveAxisPositionWalk.inner (spatialStep psi) (spatialStep psi) =
      SuccessiveAxisPositionWalk.inner psi psi := by
  unfold spatialStep
  rw [cliffordAxisShift_inner, cliffordAxisShift_inner,
    cliffordAxisShift_inner]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge.axisBasis_conjugates_velocity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axisBasis_conjugates_velocity

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge.axisSymbol_entry_hasDerivAt' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axisSymbol_entry_hasDerivAt

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge.spatialStep_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms spatialStep_preserves_norm

/-- info: 'PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge.identity_basis_fails_axis_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identity_basis_fails_axis_zero

end PhysicsSM.Draft.NullEdge.CliffordDiagonalPositionBridge
