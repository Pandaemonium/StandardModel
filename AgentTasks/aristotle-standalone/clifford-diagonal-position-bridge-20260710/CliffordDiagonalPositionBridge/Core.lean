import Mathlib

open Matrix Complex
open scoped BigOperators

namespace CliffordDiagonalPositionBridge

abbrev Axis := Fin 3
abbrev Internal := Fin 4
abbrev Mat4 := Matrix Internal Internal ℂ
abbrev Position (L : ℕ) := Axis → ZMod L
abbrev State (L : ℕ) := Position L → Internal → ℂ

def alpha1 : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

def generator (axis : Axis) : Mat4 :=
  match axis with
  | 0 => alpha1
  | 1 => alpha2
  | 2 => alpha3

/-- Component signs used by the existing finite position-register walk. -/
def tetraVelocity (axis : Axis) (a : Internal) : Bool :=
  match axis, a with
  | 0, 0 => true | 0, 1 => true | 0, 2 => false | 0, 3 => false
  | 1, 0 => true | 1, 1 => false | 1, 2 => true | 1, 3 => false
  | 2, 0 => true | 2, 1 => false | 2, 2 => false | 2, 3 => true

def velocitySign (axis : Axis) (a : Internal) : ℂ :=
  if tetraVelocity axis a then -1 else 1

def velocityDiag (axis : Axis) : Mat4 :=
  diagonal (velocitySign axis)

noncomputable def s : ℝ := Real.sqrt 2 / 2

/-- Explicit columns are ordered eigenvectors with eigenvalues matching
`velocitySign`. -/
noncomputable def axisBasis (axis : Axis) : Mat4 :=
  match axis with
  | 0 => !![s, 0, s, 0; 0, s, 0, s; 0, -s, 0, s; -s, 0, s, 0]
  | 1 => !![s, s, 0, 0; 0, 0, s, s; 0, 0, I * s, -I * s;
      -I * s, I * s, 0, 0]
  | 2 => !![s, s, 0, 0; 0, 0, s, s; -s, s, 0, 0; 0, 0, -s, s]

def IsUnitary (U : Mat4) : Prop :=
  Uᴴ * U = 1 ∧ U * Uᴴ = 1

theorem velocityDiag_zero : velocityDiag 0 =
    !![-1, 0, 0, 0; 0, -1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    rfl

theorem velocityDiag_one : velocityDiag 1 =
    !![-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, 1] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    rfl

theorem velocityDiag_two : velocityDiag 2 =
    !![-1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, -1] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    rfl

theorem s_sq : (s : ℂ) * s = 1 / 2 := by
  have hsqrt : (Real.sqrt 2) ^ 2 = (2 : ℝ) :=
    Real.sq_sqrt (by norm_num)
  apply Complex.ext <;> norm_num [s]
  nlinarith

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
    by_cases hsign : tetraVelocity axis i <;>
      simp [velocityDiag, velocitySign, hsign]
  · simp [velocityDiag, velocitySign, hij]

theorem axisBasis_zero_conjugates :
    axisBasis 0 * velocityDiag 0 * (axisBasis 0)ᴴ = alpha1 := by
  rw [velocityDiag_zero]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [axisBasis, alpha1, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_one_conjugates :
    axisBasis 1 * velocityDiag 1 * (axisBasis 1)ᴴ = alpha2 := by
  rw [velocityDiag_one]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [axisBasis, alpha2, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

theorem axisBasis_two_conjugates :
    axisBasis 2 * velocityDiag 2 * (axisBasis 2)ᴴ = alpha3 := by
  rw [velocityDiag_two]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [axisBasis, alpha3, Matrix.mul_apply, Matrix.conjTranspose,
      Fin.sum_univ_succ, Complex.ext_iff] <;>
    nlinarith [s_mul_s_real]

/-- Decisive dictionary: the diagonal component velocities become the three
off-diagonal Clifford generators in their explicit eigenbases. -/
theorem axisBasis_conjugates_velocity (axis : Axis) :
    axisBasis axis * velocityDiag axis * (axisBasis axis)ᴴ = generator axis := by
  fin_cases axis
  · simpa [generator] using axisBasis_zero_conjugates
  · simpa [generator] using axisBasis_one_conjugates
  · simpa [generator] using axisBasis_two_conjugates

/-- Negative control: the raw diagonal table is not already the first spatial
Clifford generator. The basis change is load-bearing. -/
theorem identity_basis_fails_axis_zero : velocityDiag 0 ≠ alpha1 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [velocityDiag, velocitySign, tetraVelocity, alpha1] at h00

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
  simp [Matrix.mul_sub, Matrix.sub_mul, Matrix.mul_smul,
    Matrix.smul_mul, mul_assoc, (axisBasis_unitary axis).2,
    axisBasis_conjugates_velocity axis]

theorem axisSymbol_at_zero (axis : Axis) : axisSymbol axis 0 = 1 := by
  have hphase : phaseDiag axis 0 = 1 := by
    ext i j
    simp [phaseDiag]
  simp [axisSymbol, hphase, (axisBasis_unitary axis).2]

/-- The local conditional-shift symbol has the exact infinitesimal spatial
Dirac generator after the explicit basis dictionary. -/
theorem axisSymbol_entry_hasDerivAt (axis : Axis) (i j : Internal) :
    HasDerivAt (fun eps : ℝ => axisSymbol axis eps i j)
      ((-I) * generator axis i j) 0 := by
  have hcos :
      HasDerivAt (fun eps : ℝ => (Real.cos eps : ℂ)) 0 0 := by
    convert (Real.hasDerivAt_cos 0).ofReal_comp using 1 <;> norm_num
  have hsin :
      HasDerivAt (fun eps : ℝ => (Real.sin eps : ℂ)) 1 0 := by
    convert (Real.hasDerivAt_sin 0).ofReal_comp using 1 <;> norm_num
  have hentry := (hcos.mul_const ((1 : Mat4) i j)).sub
    ((HasDerivAt.const_mul I hsin).mul_const (generator axis i j))
  simpa [axisSymbol_closed_form, mul_comm, mul_left_comm, mul_assoc] using hentry

noncomputable def inner {L : ℕ} [NeZero L] (psi phi : State L) : ℂ :=
  ∑ p, ∑ a, star (psi p a) * phi p a

def sourcePosition {L : ℕ} (axis : Axis) (a : Internal)
    (p : Position L) : Position L :=
  fun j => if j = axis then
    p j + if tetraVelocity axis a then -1 else 1
  else p j

noncomputable def conditionalShift {L : ℕ} (axis : Axis)
    (psi : State L) : State L :=
  fun p a => psi (sourcePosition axis a p) a

noncomputable def pointwise (U : Mat4) {L : ℕ}
    (psi : State L) : State L :=
  fun p => U.mulVec (psi p)

theorem sourcePosition_bijective {L : ℕ} [NeZero L]
    (axis : Axis) (a : Internal) :
    Function.Bijective (sourcePosition (L := L) axis a) := by
  constructor
  · intro p q h
    ext j
    have hj := congr_fun h j
    have ha := congr_fun h axis
    unfold sourcePosition at *
    aesop
  · intro p
    use fun j => if j = axis then
      p j - if tetraVelocity axis a then -1 else 1 else p j
    ext j
    unfold sourcePosition
    aesop

theorem conditionalShift_inner {L : ℕ} [NeZero L]
    (axis : Axis) (psi phi : State L) :
    inner (conditionalShift axis psi) (conditionalShift axis phi) =
      inner psi phi := by
  unfold inner conditionalShift
  rw [Finset.sum_comm]
  conv_rhs => rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro a _
  exact Equiv.sum_comp
    (Equiv.ofBijective (sourcePosition (L := L) axis a)
      (sourcePosition_bijective axis a))
    (fun p => star (psi p a) * phi p a)

theorem pointwise_inner {L : ℕ} [NeZero L]
    (U : Mat4) (hU : IsUnitary U) (psi phi : State L) :
    inner (pointwise U psi) (pointwise U phi) = inner psi phi := by
  unfold inner
  simp [pointwise]
  have h_fubini : ∀ x : Position L,
      ∑ a, star (U.mulVec (psi x) a) * U.mulVec (phi x) a =
        ∑ a, star (psi x a) * phi x a := by
    intro x
    have h_unitary : Uᴴ * U = 1 := hU.1
    have h_simp :
        ∑ a, star ((U *ᵥ psi x) a) * (U *ᵥ phi x) a =
          ∑ a, star (psi x a) *
            (U.conjTranspose *ᵥ (U *ᵥ phi x)) a := by
      simp +decide [Matrix.mulVec, dotProduct, mul_assoc, mul_comm,
        mul_left_comm, Finset.mul_sum _ _ _]
      exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ =>
        Finset.sum_congr rfl fun _ _ =>
          Finset.sum_congr rfl fun _ _ => by ring)
    simp_all +decide
  simp_all +decide

theorem conjTranspose_unitary (U : Mat4) (hU : IsUnitary U) :
    IsUnitary Uᴴ := by
  constructor
  · simpa using hU.2
  · simpa using hU.1

/-- The component shift conjugated into the physical Clifford basis. -/
noncomputable def cliffordAxisShift {L : ℕ} (axis : Axis)
    (psi : State L) : State L :=
  pointwise (axisBasis axis)
    (conditionalShift axis (pointwise ((axisBasis axis)ᴴ) psi))

theorem cliffordAxisShift_inner {L : ℕ} [NeZero L]
    (axis : Axis) (psi phi : State L) :
    inner (cliffordAxisShift axis psi) (cliffordAxisShift axis phi) =
      inner psi phi := by
  unfold cliffordAxisShift
  rw [pointwise_inner _ (axisBasis_unitary axis), conditionalShift_inner,
    pointwise_inner _ (conjTranspose_unitary _ (axisBasis_unitary axis))]

noncomputable def spatialStep {L : ℕ} (psi : State L) : State L :=
  cliffordAxisShift 2 (cliffordAxisShift 1 (cliffordAxisShift 0 psi))

theorem spatialStep_preserves_norm {L : ℕ} [NeZero L]
    (psi : State L) :
    inner (spatialStep psi) (spatialStep psi) = inner psi psi := by
  unfold spatialStep
  rw [cliffordAxisShift_inner, cliffordAxisShift_inner,
    cliffordAxisShift_inner]

end CliffordDiagonalPositionBridge
