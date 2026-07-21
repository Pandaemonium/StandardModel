import Mathlib

/-!
# Stationary-amplitude no-go for a degree-one Dirac Laurent symbol

This module audits the smallest translation-invariant nearest-neighbor symbol

`F(q) = exp(i q) A + B + exp(-i q) C`.

For any Hermitian involution `M`, exact unitarity at every real momentum,
`F(0) = I`, and tangent generator `-i M` force the stationary coefficient `B`
to vanish.  Specializing to the live single-axis Dirac generator gives a
no-go for adding a stationary amplitude inside this degree-one ansatz.

The final construction is a nonvacuity control, not a minimality theorem.  It
exhibits one weaker tangent with a stationary kernel for which exact unitarity,
a nonzero stationary amplitude, and zone-edge separation coexist.

Provenance: proof synthesized by Aristotle project `47b0fbe6` from a
Mathlib-only clean-room target motivated by Gupta--Short, arXiv:2601.15885.
No external implementation text is copied.  The scope is the displayed
degree-one Laurent ansatz, not arbitrary local quantum walks.
-/

noncomputable section

open Matrix Complex
open scoped Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

def alpha : Mat4 :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

/-- Degree-one Laurent symbol.  `A` and `C` are directed hops and `B` is the
stationary amplitude. -/
def laurentStep (A B C : Mat4) (q : Real) : Mat4 :=
  Complex.exp (I * q) • A + B + Complex.exp (-I * q) • C

def UnitaryAllMomenta (F : Real -> Mat4) : Prop :=
  forall q, F q ∈ Matrix.unitaryGroup (Fin 4) Complex

/-- Exact normalization and first-order Dirac tangent at the origin. -/
def HasDiracTangent (F : Real -> Mat4) : Prop :=
  F 0 = 1 ∧ HasDerivAt F ((-I : Complex) • alpha) 0

/-- Exact normalization with a general first-order Hermitian generator. -/
def HasRegulatedTangent (F : Real -> Mat4) (M : Mat4) : Prop :=
  F 0 = 1 ∧ HasDerivAt F ((-I : Complex) • M) 0

/-- The single-axis zone edge is not a scalar Floquet phase. -/
def SeparatesPi (F : Real -> Mat4) : Prop :=
  F Real.pi ≠ 1 ∧ F Real.pi ≠ -(1 : Mat4)

/-- The stationary channel is genuinely present. -/
def HasStationaryAmplitude (B : Mat4) : Prop := B ≠ 0

theorem hasDiracTangent_iff (F : Real -> Mat4) :
    HasDiracTangent F ↔ HasRegulatedTangent F alpha := Iff.rfl

/-! ## Evaluation and derivative identities -/

theorem laurentStep_zero (A B C : Mat4) :
    laurentStep A B C 0 = A + B + C := by
  unfold laurentStep
  norm_num

theorem laurentStep_hasDerivAt (A B C : Mat4) :
    HasDerivAt (laurentStep A B C) (I • A - I • C) 0 := by
  unfold laurentStep
  rw [hasDerivAt_pi]
  intro i
  rw [hasDerivAt_pi]
  norm_num
  intro j
  convert HasDerivAt.add
      (HasDerivAt.add
        (HasDerivAt.mul
          (HasDerivAt.comp _ (Complex.hasDerivAt_exp _)
            (HasDerivAt.const_mul I (hasDerivAt_id _ |> HasDerivAt.ofReal_comp)))
          (hasDerivAt_const _ _))
        (hasDerivAt_const _ _))
      (HasDerivAt.mul
        (HasDerivAt.comp _ (Complex.hasDerivAt_exp _)
          (HasDerivAt.neg
            (HasDerivAt.const_mul I (hasDerivAt_id _ |> HasDerivAt.ofReal_comp))))
        (hasDerivAt_const _ _)) using 1 <;>
    norm_num <;>
    ring

theorem sum_of_regulated (A B C M : Mat4)
    (h : HasRegulatedTangent (laurentStep A B C) M) :
    A + B + C = 1 := by
  have h0 := h.1
  rw [laurentStep_zero] at h0
  exact h0

theorem diff_of_regulated (A B C M : Mat4)
    (h : HasRegulatedTangent (laurentStep A B C) M) :
    A - C = -M := by
  have hderiv := h.2
  ext i j
  simp +decide [Complex.ext_iff]
  have hu := hderiv.unique (laurentStep_hasDerivAt A B C)
  have hij := congrFun (congrFun hu i) j
  norm_num [Complex.ext_iff] at hij
  constructor <;> linarith

/-- Closed residual for `F(q)^* F(q)` after imposing normalization and the
first derivative. -/
theorem unitarity_residual (A B C M : Mat4) (hM : Mᴴ = M)
    (hsum : A + B + C = 1) (hdiff : A - C = -M) (q : Real) :
    star (laurentStep A B C q) * laurentStep A B C q
      = ((Real.cos q ^ 2 : Real) : Complex) • (1 : Mat4)
        + ((Real.sin q ^ 2 : Real) : Complex) • (M * M)
        + ((Real.cos q * (1 - Real.cos q) : Real) : Complex) • (B + Bᴴ)
        + (((1 - Real.cos q) ^ 2 : Real) : Complex) • (Bᴴ * B)
        + (((1 - Real.cos q) * Real.sin q : Real) : Complex)
            • (I • (M * B - Bᴴ * M)) := by
  have hFq :
      laurentStep A B C q =
        (Real.cos q : Complex) • (1 : Mat4)
          + ((1 - Real.cos q) : Complex) • B
          - (Real.sin q * I) • M := by
    convert congr_arg₂ (fun x y => x • A + B + y • C)
      (show (Complex.exp (I * q) : Complex) =
          (Real.cos q : Complex) + (Real.sin q : Complex) * I by
        rw [Complex.exp_eq_exp_re_mul_sin_add_cos]
        norm_num)
      (show (Complex.exp (-I * q) : Complex) =
          (Real.cos q : Complex) - (Real.sin q : Complex) * I by
        rw [Complex.exp_eq_exp_re_mul_sin_add_cos]
        norm_num
        ring) using 1 <;>
      norm_num [Complex.exp_neg] <;>
      ring
    rw [sub_eq_iff_eq_add] at hdiff
    simp_all +decide [add_smul, smul_add, smul_sub, sub_smul]
    rw [← hsum]
    norm_num [add_smul, smul_add, smul_sub, sub_smul]
    abel_nf
  simp_all +decide [sq, mul_assoc, mul_left_comm, mul_add, add_mul, sub_mul, mul_sub]
  simp_all +decide [Complex.ext_iff, Matrix.star_eq_conjTranspose]
  ext i j
  norm_num [Complex.ext_iff, Matrix.mul_apply]
  ring
  norm_num

/-! ## The no-go theorem -/

/-- For a Hermitian involutory tangent generator, exact all-momentum unitarity
forces the stationary amplitude in a degree-one Laurent symbol to vanish. -/
theorem stationary_forces_zero (A B C M : Mat4)
    (hM : Mᴴ = M) (hM2 : M * M = 1)
    (hU : UnitaryAllMomenta (laurentStep A B C))
    (hT : HasRegulatedTangent (laurentStep A B C) M) :
    B = 0 := by
  obtain ⟨hB, hC⟩ :
      Bᴴ * B + I • (M * B - Bᴴ * M) = 0 ∧
        Bᴴ * B - I • (M * B - Bᴴ * M) = 0 := by
    have h1 := hU (Real.pi / 2)
    have h2 := hU (-(Real.pi / 2))
    simp_all +decide [Matrix.mem_unitaryGroup_iff']
    have h1 := unitarity_residual A B C M hM
      (sum_of_regulated A B C M hT) (diff_of_regulated A B C M hT)
      (Real.pi / 2)
    have h2 := unitarity_residual A B C M hM
      (sum_of_regulated A B C M hT) (diff_of_regulated A B C M hT)
      (-(Real.pi / 2))
    simp_all +decide [Real.cos_pi_div_two, Real.sin_pi_div_two,
      Real.cos_neg, Real.sin_neg]
    grind +qlia
  simp_all +decide [← Matrix.ext_iff]
  have hsum : forall i j, (Bᴴ * B) i j = 0 := by
    exact fun i j => by linear_combination' hB i j / 2 + hC i j / 2
  simp_all +decide [Matrix.mul_apply, Complex.ext_iff]
  intro i j
  specialize hsum j j
  simp_all +decide [Finset.sum_eq_zero_iff_of_nonneg, add_nonneg, mul_self_nonneg]
  constructor <;> nlinarith only [hsum.1 i]

theorem alpha_conjTranspose : alphaᴴ = alpha := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp +decide [alpha]

theorem alpha_sq : alpha * alpha = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp +decide [alpha]

/-- No degree-one symbol simultaneously has exact all-momentum unitarity, the
full Dirac tangent, a nonzero stationary amplitude, and zone-edge separation. -/
theorem dirac_no_go :
    ¬ ∃ A B C : Mat4,
      UnitaryAllMomenta (laurentStep A B C) ∧
      HasDiracTangent (laurentStep A B C) ∧
      HasStationaryAmplitude B ∧
      SeparatesPi (laurentStep A B C) := by
  intro h
  obtain ⟨A, B, C, hU, hD, hB, _⟩ := h
  have hzero := stationary_forces_zero A B C alpha alpha_conjTranspose alpha_sq
    hU ((hasDiracTangent_iff _).1 hD)
  exact hB hzero

/-! ## A nonvacuous weaker tangent -/

/-- The Dirac generator restricted to its `0 <-> 3` channel. -/
def wM : Mat4 := !![0, 0, 0, 1; 0, 0, 0, 0; 0, 0, 0, 0; 1, 0, 0, 0]

def wA : Mat4 :=
  !![1/2, 0, 0, -1/2; 0, 0, 0, 0; 0, 0, 0, 0; -1/2, 0, 0, 1/2]

def wC : Mat4 :=
  !![1/2, 0, 0, 1/2; 0, 0, 0, 0; 0, 0, 0, 0; 1/2, 0, 0, 1/2]

/-- Stationary projection onto `span {e1, e2}`. -/
def wB : Mat4 := !![0, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 0]

theorem wsum : wA + wB + wC = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [wA, wB, wC]

theorem wdiff : wA - wC = -wM := by
  exact Matrix.ext fun i j => by
    fin_cases i <;> fin_cases j <;> norm_num [wA, wC, wM]

theorem wM_conjTranspose : wMᴴ = wM := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [wM]

/-- An explicit stationary direction of the relaxed tangent. -/
def stationaryMode : Fin 4 -> Complex := ![0, 1, 0, 0]

theorem stationaryMode_ne_zero : stationaryMode ≠ 0 := by
  intro h
  have h1 := congrFun h 1
  norm_num [stationaryMode] at h1

theorem wM_stationaryMode : wM *ᵥ stationaryMode = 0 := by
  funext i
  fin_cases i <;>
    simp +decide [wM, stationaryMode, Matrix.mulVec, dotProduct, Fin.sum_univ_four]

theorem wM_not_involution : wM * wM ≠ 1 := by
  intro h
  have h11 := congrFun (congrFun h 1) 1
  simp +decide [wM, Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply] at h11

theorem witness_unitary : UnitaryAllMomenta (laurentStep wA wB wC) := by
  intro q
  have hunit : star (laurentStep wA wB wC q) * laurentStep wA wB wC q = 1 := by
    convert unitarity_residual wA wB wC wM wM_conjTranspose wsum wdiff q using 1 <;>
      norm_num [wsum, wdiff, wM_conjTranspose]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [wB, wM, Matrix.mul_apply, Fin.sum_univ_four]
    all_goals repeat erw [Matrix.cons_val_succ']
    all_goals norm_num
    all_goals ring
  grind +suggestions

theorem witness_regulated :
    HasRegulatedTangent (laurentStep wA wB wC) wM := by
  constructor
  · convert wsum using 1
    convert laurentStep_zero wA wB wC
  · convert laurentStep_hasDerivAt wA wB wC using 1
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Complex.ext_iff, wA, wB, wC, wM]

theorem witness_stationary : HasStationaryAmplitude wB := by
  exact ne_of_apply_ne (fun m => m 1 1) (by norm_num [wB])

theorem witness_separates : SeparatesPi (laurentStep wA wB wC) := by
  constructor
  · unfold laurentStep
    intro h
    have h00 := congrFun (congrFun h 0) 0
    norm_num [wA, wB, wC, Complex.ext_iff, Complex.exp_re, Complex.exp_im] at h00
  · intro h
    have h11 := congrFun (congrFun h 1) 1
    norm_num [wA, wB, wC, Complex.ext_iff, laurentStep] at h11

/-- A weaker tangent with a stationary kernel admits an exact unitary witness.
This proves possibility after one relaxation, not minimality of the relaxation. -/
theorem relaxed_witness :
    ∃ A B C M : Mat4,
      Mᴴ = M ∧ M * M ≠ 1 ∧
      UnitaryAllMomenta (laurentStep A B C) ∧
      HasRegulatedTangent (laurentStep A B C) M ∧
      HasStationaryAmplitude B ∧
      SeparatesPi (laurentStep A B C) :=
  ⟨wA, wB, wC, wM, wM_conjTranspose, wM_not_involution, witness_unitary,
    witness_regulated, witness_stationary, witness_separates⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.stationary_forces_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms stationary_forces_zero

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.dirac_no_go' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dirac_no_go

/-- info: 'PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo.relaxed_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relaxed_witness

end PhysicsSM.Draft.NullEdge.StationaryAmplitudeNoGo
