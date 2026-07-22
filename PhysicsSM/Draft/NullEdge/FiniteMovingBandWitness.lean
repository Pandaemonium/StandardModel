import Mathlib

/-!
# Exact gapped moving-band control

This module constructs a two-level Hermitian family with a fixed gap and an
explicitly moving rank-one low-energy projector. The projector mismatch is
nonzero at every finite regulator. A deliberately shrinking schedule has a
vanishing summed mismatch budget, while a separate exact parallel transporter
crosses the fixed path from `0` to `1` with zero dynamical cross-band leakage.

The schedule moves only a total parameter distance `1 / N` over `N` steps.
Consequently, its vanishing budget is a useful exact control but is not a
nonvacuity witness for adiabatic transport across a fixed macroscopic path.
The exact fixed-path transporter is a nonvacuity control that keeps projector
motion distinct from dynamical leakage. This file does not instantiate HNU
evolution, derive the transporter from slow physical dynamics, prove an
adiabatic theorem, prove quasi-locality, or produce an interacting continuum
result.

Provenance: proofs returned by Aristotle project
`a46bd268-cf90-4173-b904-a82d5d596218`, tasks
`74f3357b-00b7-4b75-8fac-0005bac8076d` and
`8c569d24-62fd-43aa-9311-19bc9fe9bb88`, then semantically reviewed and rebuilt
under the project toolchain. The fixed-path design follows Kato's
projector-intertwining viewpoint. No external code was copied.
-/

noncomputable section

open Matrix
open scoped BigOperators Topology

namespace PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness

abbrev Vec2 := Fin 2 -> Real
abbrev Mat2 := Matrix (Fin 2) (Fin 2) Real

/-- Rational stereographic unit vector. -/
def lowVec (t : Real) : Vec2 :=
  ![(1 - t ^ 2) / (1 + t ^ 2), 2 * t / (1 + t ^ 2)]

/-- Its displayed orthogonal unit complement. -/
def highVec (t : Real) : Vec2 :=
  ![-2 * t / (1 + t ^ 2), (1 - t ^ 2) / (1 + t ^ 2)]

def dot (x y : Vec2) : Real := Finset.univ.sum fun i => x i * y i

def outer (x y : Vec2) : Mat2 := fun i j => x i * y j

/-- Rank-one low-energy projector. -/
def lowProjector (t : Real) : Mat2 := outer (lowVec t) (lowVec t)

/-- A two-level Hamiltonian with target eigenvalues `-1` and `+1`. -/
def gappedHamiltonian (t : Real) : Mat2 := 1 - 2 • lowProjector t

/-- Selected-to-complement overlap between two displayed bands. -/
def defectAmplitude (s t : Real) : Real := dot (highVec t) (lowVec s)

theorem one_add_sq_pos (t : Real) : 0 < 1 + t ^ 2 := by
  positivity

theorem lowVec_unit (t : Real) : dot (lowVec t) (lowVec t) = 1 := by
  unfold dot lowVec
  rw [Fin.sum_univ_two]
  norm_num
  ring
  nlinarith [mul_inv_cancel₀ (by positivity : (1 + t ^ 2) ≠ 0),
    mul_inv_cancel_left₀ (by positivity : (1 + t ^ 2) ≠ 0) (t ^ 2)]

theorem highVec_unit (t : Real) : dot (highVec t) (highVec t) = 1 := by
  unfold highVec dot
  norm_num [Fin.sum_univ_succ]
  ring
  field_simp
  ring

theorem low_high_orthogonal (t : Real) : dot (highVec t) (lowVec t) = 0 := by
  unfold dot lowVec highVec
  norm_num [Fin.sum_univ_succ]
  ring

theorem lowProjector_idempotent (t : Real) :
    lowProjector t * lowProjector t = lowProjector t := by
  ext i j
  simp [lowProjector, outer]
  fin_cases i <;> fin_cases j <;>
    simp +decide [outer, Matrix.mul_apply, lowVec] <;> grind

theorem lowProjector_symmetric (t : Real) :
    (lowProjector t).transpose = lowProjector t := by
  ext i j
  simp +decide [lowProjector, outer]
  ring

theorem gappedHamiltonian_low_eigenvector (t : Real) :
    gappedHamiltonian t *ᵥ lowVec t = -lowVec t := by
  ext i
  fin_cases i <;>
    norm_num [gappedHamiltonian, lowProjector, lowVec, outer]
  · norm_num [Matrix.mulVec, dotProduct, outer]
    norm_num [two_mul, outer]
    ring
    field_simp
    ring
  · norm_num [Matrix.mulVec, dotProduct, outer]
    norm_num [two_mul, outer]
    ring
    grind

theorem gappedHamiltonian_high_eigenvector (t : Real) :
    gappedHamiltonian t *ᵥ highVec t = highVec t := by
  unfold gappedHamiltonian
  ext i
  fin_cases i <;> norm_num [Matrix.mulVec, dot]
  · unfold lowProjector highVec
    norm_num [Matrix.mul_apply]
    ring
    unfold outer lowVec
    norm_num [Fin.sum_univ_succ]
    ring
  · unfold lowProjector highVec
    norm_num [Matrix.mul_apply]
    ring
    unfold outer lowVec
    norm_num
    ring

/-- The family has an exact, parameter-independent two-level gap. -/
theorem exact_uniform_gap (t : Real) :
    gappedHamiltonian t *ᵥ lowVec t = (-1 : Real) • lowVec t /\
      gappedHamiltonian t *ᵥ highVec t = (1 : Real) • highVec t /\
      (1 : Real) - (-1 : Real) = 2 := by
  norm_num [gappedHamiltonian_low_eigenvector,
    gappedHamiltonian_high_eigenvector]

theorem defectAmplitude_formula (s t : Real) :
    defectAmplitude s t =
      2 * (s - t) * (1 + s * t) /
        ((1 + s ^ 2) * (1 + t ^ 2)) := by
  unfold defectAmplitude dot highVec lowVec
  simpa [Fin.sum_univ_succ] using by
    rw [div_mul_div_comm, div_mul_div_comm]
    rw [← add_div, div_eq_div_iff] <;> ring <;> positivity

/-- Exact matrix factorization of one moving-projector mismatch. -/
theorem moving_projector_defect_factorization (s t : Real) :
    (1 - lowProjector t) * lowProjector s =
      defectAmplitude s t • outer (highVec t) (lowVec s) := by
  ext i j
  unfold lowProjector highVec lowVec outer defectAmplitude
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, dot] <;> ring
  all_goals
    unfold highVec lowVec
    norm_num
    ring
    field_simp
    ring

/-- Slow schedule with `N` steps and total parameter displacement `1 / N`. -/
def slowParameter (N k : Nat) : Real := (k : Real) / (N : Real) ^ 2

/-- Each finite step moves the band nontrivially. -/
theorem finite_step_defect_nonzero (N k : Nat) (hN : 0 < N) (hk : k < N) :
    Ne (defectAmplitude (slowParameter N k) (slowParameter N (k + 1))) 0 := by
  simp [defectAmplitude_formula, slowParameter]
  exact ⟨⟨by ring_nf; norm_num [hN.ne'], by positivity⟩, by positivity, by positivity⟩

/-- Uniform local budget for the explicit shrinking schedule. -/
theorem finite_step_defect_bound (N k : Nat) (hN : 0 < N) (hk : k < N) :
    |defectAmplitude (slowParameter N k) (slowParameter N (k + 1))| <=
      4 / (N : Real) ^ 2 := by
  rw [defectAmplitude_formula, slowParameter, slowParameter]
  rw [abs_le]
  field_simp
  constructor <;> push_cast <;>
    nlinarith [show (N : ℝ) ^ 4 > 0 by positivity,
      show (k : ℝ) ^ 2 <= (N : ℝ) ^ 2 by gcongr,
      show (k : ℝ) * (N : ℝ) ^ 2 >= 0 by positivity,
      show (k : ℝ) ^ 3 >= 0 by positivity,
      show (k : ℝ) ^ 4 >= 0 by positivity]

/-- The scalar mismatch budget for the shrinking schedule vanishes. -/
theorem accumulated_budget_tendsto_zero :
    Filter.Tendsto
      (fun n : Nat =>
        ((n + 1 : Nat) : Real) * (4 / ((n + 1 : Nat) : Real) ^ 2))
      Filter.atTop (nhds 0) := by
  field_simp
  exact tendsto_const_nhds.div_atTop
    (tendsto_natCast_atTop_atTop.comp (Filter.tendsto_add_atTop_nat 1))

/-! ## Exact fixed-path parallel transport -/

/-- Exact change of basis carrying the displayed band basis at `s` to that at `t`. -/
def bandTransport (s t : Real) : Mat2 :=
  outer (lowVec t) (lowVec s) + outer (highVec t) (highVec s)

theorem bandTransport_lowVec (s t : Real) :
    bandTransport s t *ᵥ lowVec s = lowVec t := by
  unfold bandTransport outer
  ext i
  simp [Matrix.mulVec]
  unfold lowVec highVec
  fin_cases i <;> norm_num <;> ring
  · field_simp
    ring
  · field_simp
    ring

theorem bandTransport_highVec (s t : Real) :
    bandTransport s t *ᵥ highVec s = highVec t := by
  ext i
  fin_cases i <;>
    norm_num [mul_comm, Fin.sum_univ_succ, Matrix.mulVec, dot, outer,
      lowVec, highVec, bandTransport] <;> ring
  · norm_num [vecHead, vecTail]
    ring
    field_simp
    ring
  · norm_num [vecHead, vecTail]
    ring
    field_simp
    ring

theorem bandTransport_transpose (s t : Real) :
    (bandTransport s t).transpose = bandTransport t s := by
  unfold bandTransport
  ext i j
  simp +decide [outer]
  ring

theorem bandTransport_self (t : Real) : bandTransport t t = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [bandTransport, outer, lowVec, highVec]
  · field_simp
    ring
  · ring
  · ring
  · field_simp
    ring

theorem bandTransport_comp (r s t : Real) :
    bandTransport s t * bandTransport r s = bandTransport r t := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp +decide [bandTransport, lowVec, highVec, outer]
  · unfold outer
    norm_num [Matrix.mul_apply]
    ring
    field_simp
    ring
  · norm_num [outer, Matrix.mul_apply]
    field_simp
    ring
  · norm_num [Matrix.mul_apply, outer]
    field_simp
    ring
  · norm_num [Matrix.mul_apply, outer]
    field_simp
    ring

/-- The reverse transport is both a left and right inverse. -/
theorem bandTransport_orthogonal (s t : Real) :
    bandTransport t s * bandTransport s t = 1 /\
      bandTransport s t * bandTransport t s = 1 := by
  constructor <;>
    convert bandTransport_comp _ _ _ <;> norm_num [bandTransport_self]

/-- In transpose form, the exact transport is an orthogonal matrix. -/
theorem bandTransport_transpose_orthogonal (s t : Real) :
    (bandTransport s t).transpose * bandTransport s t = 1 /\
      bandTransport s t * (bandTransport s t).transpose = 1 := by
  rw [bandTransport_transpose, bandTransport_orthogonal s t |>.1,
    bandTransport_orthogonal s t |>.2]
  grobner

theorem bandTransport_intertwines (s t : Real) :
    bandTransport s t * lowProjector s =
      lowProjector t * bandTransport s t := by
  unfold lowProjector bandTransport outer lowVec highVec
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply] <;> ring
  · grind
  · grind
  · field_simp
    ring
  · grind

theorem bandTransport_exact_cross_band_zero (s t : Real) :
    (1 - lowProjector t) * bandTransport s t * lowProjector s = 0 := by
  rw [mul_assoc, bandTransport_intertwines]
  rw [← mul_assoc, sub_mul, one_mul, lowProjector_idempotent, sub_self]
  grind

/-- A schedule that traverses the fixed parameter interval from `0` to `1`. -/
def fixedParameter (N k : Nat) : Real := (k : Real) / (N : Real)

theorem fixedParameter_start (N : Nat) : fixedParameter N 0 = 0 := by
  unfold fixedParameter
  norm_num

theorem fixedParameter_endpoint (N : Nat) (hN : 0 < N) :
    fixedParameter N N = 1 := by
  unfold fixedParameter
  simp +decide [hN.ne']

/-- Adjacent scheduled projectors differ along every nonempty fixed path. -/
theorem fixedParameter_adjacent_projectors_ne (N k : Nat)
    (hN : 0 < N) (hk : k < N) :
    lowProjector (fixedParameter N k) ≠
      lowProjector (fixedParameter N (k + 1)) := by
  unfold lowProjector fixedParameter
  norm_num [← Matrix.ext_iff]
  unfold outer lowVec
  norm_num [Fin.sum_univ_succ]
  ring_nf
  field_simp
  intro h1 h2 h3
  nlinarith [show (k : Real) ^ 2 < N ^ 2 by norm_cast; nlinarith,
    show (k : Real) ^ 3 >= 0 by positivity,
    show (k : Real) ^ 4 >= 0 by positivity,
    show (N : Real) ^ 4 > 0 by positivity]

/-- Ordered product of exact transports along the fixed-path schedule. -/
def scheduledProduct (N : Nat) : Nat → Mat2
  | 0 => 1
  | k + 1 =>
      bandTransport (fixedParameter N k) (fixedParameter N (k + 1)) *
        scheduledProduct N k

theorem scheduledProduct_eq_transport (N k : Nat) :
    scheduledProduct N k =
      bandTransport (fixedParameter N 0) (fixedParameter N k) := by
  induction' k with k ih
  · exact Eq.symm (bandTransport_self _)
  · rw [show scheduledProduct N (k + 1) =
      bandTransport (fixedParameter N k) (fixedParameter N (k + 1)) *
        scheduledProduct N k from rfl, ih, bandTransport_comp]

/-- The complete fixed-path schedule has exactly zero final cross-band leakage. -/
theorem scheduledProduct_final_cross_band_zero (N : Nat) (hN : 0 < N) :
    (1 - lowProjector 1) * scheduledProduct N N * lowProjector 0 = 0 := by
  rw [scheduledProduct_eq_transport, fixedParameter_endpoint N hN]
  convert bandTransport_exact_cross_band_zero 0 1 using 1
  unfold fixedParameter
  norm_num

/-- The exact schedule reaches the fixed endpoint with zero cross-band leakage. -/
theorem scheduledProduct_fixed_endpoint_and_zero_leakage
    (N : Nat) (hN : 0 < N) :
    fixedParameter N N = 1 /\
      (1 - lowProjector (fixedParameter N N)) * scheduledProduct N N *
        lowProjector (fixedParameter N 0) = 0 := by
  exact ⟨fixedParameter_endpoint N hN, by
    simpa [fixedParameter_endpoint N hN, fixedParameter_start N] using
      scheduledProduct_final_cross_band_zero N hN⟩

/-- The exact transport is genuinely nonidentity for a nontrivial path. -/
theorem bandTransport_zero_one_ne_identity : bandTransport 0 1 ≠ 1 := by
  unfold bandTransport lowVec highVec outer
  intro h
  have h01 := congr_fun (congr_fun h 0) 1
  norm_num at h01

end PhysicsSM.Draft.NullEdge.FiniteMovingBandWitness
