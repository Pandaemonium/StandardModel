import PhysicsSM.Draft.NullEdge.HNUExactCore

/-!
# Antiperiodic auxiliary motion versus the full HNU schedule

This module audits a concrete proposed escape from the held-sector problem in
the null-edge `3+1` program. The two-site antiperiodic shift
`T = !![0, -1; 1, 0]` moves both site basis states and obeys `T^2 = -I`.
At the decoded HNU-substep level, the same pi phase inserts the sector
reflection `s` for a plus substep and `-s` for a minus substep.

The exact depth-eight calculation gives the scoped no-go: the eight
interleaved reflections multiply to `-I`, so the origin is relocated from a
zero-quasienergy return point to a pi point. Thus this symmetric placement
changes the physical endpoint rather than faithfully refining it.

Provenance: clean-room integration of Aristotle project
`e9a3645d-b658-46fe-b761-5b260df7ddad`, independently reviewed by
interactive Claude/Opus.

Scope: this rules out the symmetric antiperiodic placement tested here. It is
not a universal no-go for enlarged registers, transported selectors, anomaly
inflow, or other antiperiodic schedules.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore

namespace PhysicsSM.Draft.NullEdge.AntiperiodicHNU

noncomputable section

/-! ## A concrete all-moving antiperiodic auxiliary shift -/

/-- The two-site antiperiodic shift: site zero moves to site one and site one
moves to minus site zero. -/
def Tshift : Matrix (Fin 2) (Fin 2) ℂ := !![0, -1; 1, 0]

/-- Two antiperiodic auxiliary moves give the pi phase. -/
theorem Tshift_sq : Tshift * Tshift = -1 := by
  unfold Tshift
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two]

/-- The antiperiodic shift is exactly unitary. -/
theorem Tshift_unitary : Tshift ∈ unitary (Matrix (Fin 2) (Fin 2) ℂ) := by
  rw [Unitary.mem_iff]
  constructor <;>
    ext i j <;> fin_cases i <;> fin_cases j <;>
      simp [Tshift, Matrix.mul_apply, Fin.sum_univ_two]

/-- The first auxiliary site is genuinely moved. -/
theorem Tshift_moves_e0 : Tshift *ᵥ ![1, 0] = ![0, 1] := by
  ext i
  fin_cases i <;> simp [Tshift, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-- The second auxiliary site is genuinely moved, with the antiperiodic sign. -/
theorem Tshift_moves_e1 : Tshift *ᵥ ![0, 1] = ![-1, 0] := by
  ext i
  fin_cases i <;> simp [Tshift, Matrix.mulVec, dotProduct, Fin.sum_univ_two]

/-! ## Decoded sector reflections -/

/-- Antiperiodic-twisted plus substep. -/
def UtwPlus (s : M2) (theta : ℝ) : M2 := Uplus s theta * s

/-- Antiperiodic-twisted minus substep. -/
def UtwMinus (s : M2) (theta : ℝ) : M2 := Uminus s theta * (-s)

/-- A plus substep acquires a pi phase on its held minus sector. -/
theorem UtwPlus_decode {s : M2} (hs : s * s = 1) (theta : ℝ) :
    UtwPlus s theta =
      Complex.exp (-(Complex.I * theta)) • Pplus s - Pminus s := by
  have hP : Pplus s * s = Pplus s := by
    unfold Pplus
    rw [Matrix.smul_mul, add_mul, one_mul, hs]
    module
  have hM : Pminus s * s = -Pminus s := by
    unfold Pminus
    rw [Matrix.smul_mul, sub_mul, one_mul, hs]
    module
  unfold UtwPlus Uplus
  rw [add_mul, smul_mul_assoc, hP, hM, sub_eq_add_neg]

/-- A minus substep acquires a pi phase on its held plus sector. -/
theorem UtwMinus_decode {s : M2} (hs : s * s = 1) (theta : ℝ) :
    UtwMinus s theta =
      Complex.exp (Complex.I * theta) • Pminus s - Pplus s := by
  have hP : Pplus s * s = Pplus s := by
    unfold Pplus
    rw [Matrix.smul_mul, add_mul, one_mul, hs]
    module
  have hM : Pminus s * s = -Pminus s := by
    unfold Pminus
    rw [Matrix.smul_mul, sub_mul, one_mul, hs]
    module
  unfold UtwMinus Uminus
  rw [add_mul, smul_mul_assoc, mul_neg, hM, neg_neg, mul_neg, hP,
    ← sub_eq_add_neg]

/-- At zero momentum, a twisted plus substep is its sector reflection. -/
theorem UtwPlus_zero (s : M2) : UtwPlus s 0 = s := by
  have h : Uplus s 0 = 1 := by
    unfold Uplus
    simp [Pplus_add_Pminus]
  unfold UtwPlus
  rw [h, one_mul]

/-- At zero momentum, a twisted minus substep is the opposite reflection. -/
theorem UtwMinus_zero (s : M2) : UtwMinus s 0 = -s := by
  have h : Uminus s 0 = 1 := by
    unfold Uminus
    simp only [Complex.ofReal_zero, mul_zero, Complex.exp_zero, one_smul]
    rw [add_comm]
    exact Pplus_add_Pminus s
  unfold UtwMinus
  rw [h, one_mul]

/-! ## Full depth-eight schedule -/

/-- The fully twisted endpoint in the same ordered schedule as `endpoint`. -/
def twEndpoint (k : Fin 3 → ℝ) : M2 :=
  UtwMinus σ1 (k 0) * UtwMinus σ3 (k 2 / 2) * UtwMinus σ2 (k 1) *
    UtwPlus σ3 (k 2 / 2) * UtwPlus σ1 (k 0) *
    UtwMinus σ3 (k 2 / 2) * UtwPlus σ2 (k 1) * UtwPlus σ3 (k 2 / 2)

/-- The eight interleaved sector reflections multiply to minus the identity. -/
theorem reflection_product_eq_neg_one :
    (-σ1) * (-σ3) * (-σ2) * σ3 * σ1 * (-σ3) * σ2 * σ3 = (-1 : M2) := by
  simp only [σ1, σ2, σ3]
  norm_num [Matrix.mul_fin_two]
  ext i j
  fin_cases i <;> fin_cases j <;> simp

/-- The symmetrically twisted origin is a pi point. -/
theorem twEndpoint_zero : twEndpoint (0 : Fin 3 → ℝ) = -1 := by
  unfold twEndpoint
  simp only [Pi.zero_apply, zero_div, UtwPlus_zero, UtwMinus_zero]
  exact reflection_product_eq_neg_one

/-- Scoped no-go: symmetric antiperiodic twisting relocates the HNU origin
from quasienergy zero to quasienergy pi. -/
theorem twist_relocates_zero_to_pi :
    twEndpoint (0 : Fin 3 → ℝ) = -1 ∧
      endpoint (0 : Fin 3 → ℝ) = 1 ∧
      twEndpoint (0 : Fin 3 → ℝ) ≠ endpoint (0 : Fin 3 → ℝ) := by
  refine ⟨twEndpoint_zero, endpoint_zero, ?_⟩
  rw [twEndpoint_zero, endpoint_zero]
  intro h
  have h00 := congrFun (congrFun h 0) 0
  simp only [Matrix.neg_apply, Matrix.one_apply_eq] at h00
  norm_num at h00

/-- Axis-one and axis-three plus projectors do not commute, so one fixed
rank-one selector cannot align with every HNU substep. -/
theorem selector_noncommute : ¬ Commute (Pplus σ1) (Pplus σ3) := by
  intro h
  have h01 := congrFun (congrFun h.eq 0) 1
  simp [Pplus, σ1, σ3, Matrix.mul_apply, Fin.sum_univ_two,
    Matrix.add_apply, Matrix.smul_apply, Matrix.one_apply] at h01

end

end PhysicsSM.Draft.NullEdge.AntiperiodicHNU

/-! ## Build-enforced standard-three axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicHNU.Tshift_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicHNU.Tshift_sq

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicHNU.Tshift_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicHNU.Tshift_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicHNU.twist_relocates_zero_to_pi' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicHNU.twist_relocates_zero_to_pi

/-- info: 'PhysicsSM.Draft.NullEdge.AntiperiodicHNU.selector_noncommute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AntiperiodicHNU.selector_noncommute
