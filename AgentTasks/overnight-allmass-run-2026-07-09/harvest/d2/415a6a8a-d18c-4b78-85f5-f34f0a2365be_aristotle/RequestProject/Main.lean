import Mathlib

open scoped BigOperators
open scoped Classical
open scoped ComplexConjugate ComplexOrder

open Matrix

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

namespace SuiteD_EntropyMonotone

/-!
# Suite D · rung D2 — entropy monotonicity under decoherence / compression

A finite null-edge program reads "mass" as the mixedness of a 2×2 *direction* density
state `ρ` (Hermitian, PSD, trace 1).  With `ρ = !![p, z; conj z, 1-p]` the two invariants
are the *linear entropy* `S_lin ρ = 1 - tr(ρ²)` and the *mass²* `det ρ`, and for a
trace-1 state `det ρ = S_lin ρ / 2`, so they move together.

Coarse-graining the hidden structure is a **pinching** channel
`Pinch t ρ = (1-t)·ρ + t·diag ρ` (damping off-diagonal coherence toward the decohered
diagonal, `t = 1` = full decoherence, `t = 0` = identity).  Everything below is exact
rational / `ring` / `nlinarith` arithmetic — no transcendentals.
-/

/-- The 2×2 Hermitian state `ρ = !![p, z; conj z, 1-p]`. -/
noncomputable def rhoM (p : ℝ) (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(p : ℂ), z; conj z, (1 - p : ℝ)]

/-- The pinching channel `Pinch t M = (1-t)·M + t·diag M`. -/
noncomputable def Pinch (t : ℝ) (M : Matrix (Fin 2) (Fin 2) ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  ((1 - t : ℝ) : ℂ) • M + ((t : ℝ) : ℂ) • Matrix.diagonal (fun i => M i i)

/-- `Pinch` acts on `ρ` by damping the off-diagonal coherence `z ↦ (1-t)·z`. -/
theorem pinch_rhoM (p t : ℝ) (z : ℂ) :
    Pinch t (rhoM p z)
      = !![(p : ℂ), ((1 - t : ℝ) : ℂ) * z; ((1 - t : ℝ) : ℂ) * conj z, ((1 - p : ℝ) : ℂ)] := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Pinch, rhoM, Matrix.diagonal] <;> ring

/-- A 2×2 Hermitian matrix `!![a, b; conj b, d]` with nonnegative diagonal and
nonnegative determinant (`‖b‖² ≤ a·d`) is positive semidefinite. -/
theorem psd_two (a d : ℝ) (b : ℂ) (ha : 0 ≤ a) (hd : 0 ≤ d) (hbd : ‖b‖ ^ 2 ≤ a * d) :
    (!![(a : ℂ), b; conj b, (d : ℝ)] : Matrix (Fin 2) (Fin 2) ℂ).PosSemidef := by
  rw [Matrix.posSemidef_iff_dotProduct_mulVec]
  refine ⟨?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]
  · intro x
    simp only [dotProduct, mulVec, Fin.sum_univ_two, star, Matrix.cons_val',
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val',
      Matrix.cons_val_fin_one, Matrix.of_apply]
    rw [Complex.le_def]
    have hb : ‖b‖ ^ 2 = b.re ^ 2 + b.im ^ 2 := by
      rw [← Complex.normSq_eq_norm_sq, Complex.normSq_apply]; ring
    refine ⟨?_, by
      simp only [Complex.add_im, Complex.mul_im, Complex.mul_re, Complex.add_re,
        Complex.ofReal_re, Complex.ofReal_im, Complex.conj_re, Complex.conj_im, Complex.zero_im]
      ring⟩
    simp only [Complex.add_re, Complex.mul_re, Complex.mul_im, Complex.add_im, Complex.ofReal_re,
      Complex.ofReal_im, Complex.conj_re, Complex.conj_im, Complex.zero_re]
    rcases eq_or_lt_of_le ha with ha0 | hapos
    · have hb0 : b.re ^ 2 + b.im ^ 2 ≤ 0 := by rw [← hb]; nlinarith [ha0]
      have hbr : b.re = 0 := by nlinarith [sq_nonneg b.re, sq_nonneg b.im]
      have hbi : b.im = 0 := by nlinarith [sq_nonneg b.re, sq_nonneg b.im]
      rw [← ha0, hbr, hbi]
      nlinarith [sq_nonneg (x 1).re, sq_nonneg (x 1).im, mul_nonneg hd (sq_nonneg (x 1).re),
        mul_nonneg hd (sq_nonneg (x 1).im)]
    · have key : a * (((x 0).re * (a * (x 0).re - 0 * (x 0).im + (b.re * (x 1).re - b.im * (x 1).im)) -
          -(x 0).im * (a * (x 0).im + 0 * (x 0).re + (b.re * (x 1).im + b.im * (x 1).re))) +
        ((x 1).re * (b.re * (x 0).re - -b.im * (x 0).im + (d * (x 1).re - 0 * (x 1).im)) -
          -(x 1).im * (b.re * (x 0).im + -b.im * (x 0).re + (d * (x 1).im + 0 * (x 1).re)))) =
        (a * (x 0).re + b.re * (x 1).re - b.im * (x 1).im) ^ 2
          + (a * (x 0).im + b.re * (x 1).im + b.im * (x 1).re) ^ 2
          + (a * d - (b.re ^ 2 + b.im ^ 2)) * ((x 1).re ^ 2 + (x 1).im ^ 2) := by ring
      nlinarith [key, sq_nonneg (a * (x 0).re + b.re * (x 1).re - b.im * (x 1).im),
        sq_nonneg (a * (x 0).im + b.re * (x 1).im + b.im * (x 1).re),
        mul_nonneg (by nlinarith [hbd, hb] : (0 : ℝ) ≤ a * d - (b.re ^ 2 + b.im ^ 2))
          (by positivity : (0 : ℝ) ≤ (x 1).re ^ 2 + (x 1).im ^ 2), hapos]

/-! ## Target 1 — `Pinch t ρ` is a valid density operator -/

/-- **`pinch_is_state`.**  For a valid state `ρ = !![p, z; conj z, 1-p]`
(`0 ≤ p ≤ 1`, `‖z‖² ≤ p(1-p)`) and `t ∈ [0,1]`, the pinched matrix `Pinch t ρ`
is Hermitian, positive semidefinite, and has trace `1`: a valid density operator. -/
theorem pinch_is_state (p t : ℝ) (z : ℂ) (hp0 : 0 ≤ p) (hp1 : p ≤ 1)
    (hdet : ‖z‖ ^ 2 ≤ p * (1 - p)) (ht0 : 0 ≤ t) (ht1 : t ≤ 1) :
    (Pinch t (rhoM p z)).IsHermitian ∧ (Pinch t (rhoM p z)).PosSemidef
      ∧ (Pinch t (rhoM p z)).trace = 1 := by
  -- The pinched determinant bound: `‖(1-t)z‖² ≤ p(1-p)`.
  have hnorm : ‖((1 - t : ℝ) : ℂ) * z‖ ^ 2 = (1 - t) ^ 2 * ‖z‖ ^ 2 := by
    rw [norm_mul, mul_pow, Complex.norm_real, Real.norm_eq_abs, sq_abs]
  have hbound : ‖((1 - t : ℝ) : ℂ) * z‖ ^ 2 ≤ p * (1 - p) := by
    rw [hnorm]
    nlinarith [hdet, sq_nonneg ‖z‖,
      mul_nonneg (mul_nonneg ht0 (by linarith : (0:ℝ) ≤ 2 - t)) (sq_nonneg ‖z‖)]
  have hconj : ((1 - t : ℝ) : ℂ) * conj z = conj (((1 - t : ℝ) : ℂ) * z) := by
    rw [map_mul, Complex.conj_ofReal]
  have hpsd : (Pinch t (rhoM p z)).PosSemidef := by
    rw [pinch_rhoM, hconj]
    exact psd_two p (1 - p) (((1 - t : ℝ) : ℂ) * z) hp0 (by linarith) hbound
  refine ⟨hpsd.1, hpsd, ?_⟩
  rw [pinch_rhoM, Matrix.trace_fin_two]
  simp only [Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.empty_val', Matrix.cons_val_fin_one]
  push_cast; ring

/-! ## Target 2 — closed form of the pinched determinant -/

/-- Closed form of the pinched determinant as a real cast. -/
theorem det_pinch_cast (p t : ℝ) (z : ℂ) :
    Matrix.det (Pinch t (rhoM p z)) = ((p * (1 - p) - (1 - t) ^ 2 * ‖z‖ ^ 2 : ℝ) : ℂ) := by
  have hz : z * conj z = ((‖z‖ ^ 2 : ℝ) : ℂ) := by
    rw [Complex.mul_conj, Complex.normSq_eq_norm_sq]
  rw [pinch_rhoM, Matrix.det_fin_two]
  simp only [Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_fin_one, Matrix.empty_val']
  rw [show (((1 - t : ℝ) : ℂ) * z) * (((1 - t : ℝ) : ℂ) * conj z)
      = ((1 - t : ℝ) : ℂ) ^ 2 * (z * conj z) by ring, hz]
  push_cast; ring

/-- Closed form of the *undamped* determinant `det ρ = p(1-p) - ‖z‖²`. -/
theorem det_rhoM_cast (p : ℝ) (z : ℂ) :
    Matrix.det (rhoM p z) = ((p * (1 - p) - ‖z‖ ^ 2 : ℝ) : ℂ) := by
  have h := det_pinch_cast p 0 z
  simp only [Pinch, sub_zero, one_smul,
    Complex.ofReal_zero, zero_smul, add_zero, Complex.ofReal_one] at h
  rw [h]; norm_num

/-- **`det_pinch`.**  `det (Pinch t ρ) = det ρ + (2t - t²)·‖z‖²`: the pinched mass² equals
the original mass² plus the (nonnegative) coherence that was decohered. -/
theorem det_pinch (p t : ℝ) (z : ℂ) :
    Matrix.det (Pinch t (rhoM p z))
      = Matrix.det (rhoM p z) + ((2 * t - t ^ 2) * ‖z‖ ^ 2 : ℝ) := by
  rw [det_pinch_cast, det_rhoM_cast]; push_cast; ring

/-! ## Target 3 — mass² / linear entropy is monotone under pinching -/

/-- The mass² invariant `det (Pinch t ρ)` as a real number. -/
noncomputable def massSq (p : ℝ) (z : ℂ) (t : ℝ) : ℝ :=
  (Matrix.det (Pinch t (rhoM p z))).re

/-- Closed form of the mass² invariant. -/
theorem massSq_eq (p t : ℝ) (z : ℂ) :
    massSq p z t = p * (1 - p) - (1 - t) ^ 2 * ‖z‖ ^ 2 := by
  rw [massSq, det_pinch_cast, Complex.ofReal_re]

/-- **`mass_monotone_under_pinch`.**  The mass² invariant `t ↦ det (Pinch t ρ)` is monotone
on `[0,1]` and dominates its `t = 0` value `det ρ`: decohering hidden coherence can only
**increase** the mass² / linear entropy. -/
theorem mass_monotone_under_pinch (p : ℝ) (z : ℂ) :
    MonotoneOn (massSq p z) (Set.Icc (0 : ℝ) 1)
      ∧ ∀ t ∈ Set.Icc (0 : ℝ) 1, massSq p z 0 ≤ massSq p z t := by
  constructor
  · intro s hs t ht hst
    rw [massSq_eq, massSq_eq]
    have hz : (0 : ℝ) ≤ ‖z‖ ^ 2 := sq_nonneg _
    obtain ⟨hs0, hs1⟩ := hs
    obtain ⟨ht0, ht1⟩ := ht
    nlinarith [mul_nonneg (mul_nonneg (by linarith : (0:ℝ) ≤ t - s)
      (by linarith : (0:ℝ) ≤ 2 - s - t)) hz]
  · intro t ht
    rw [massSq_eq, massSq_eq]
    obtain ⟨ht0, ht1⟩ := ht
    nlinarith [mul_nonneg (mul_nonneg ht0 (by linarith : (0:ℝ) ≤ 2 - t)) (sq_nonneg ‖z‖)]

/-! ## Target 4 — the signed closure exception -/

/-- A rational (3-4-5) rotation acting by congruence: a genuine coherent closure move. -/
noncomputable def Urot : Matrix (Fin 2) (Fin 2) ℂ := !![(3 / 5 : ℂ), -4 / 5; 4 / 5, 3 / 5]

/-- **`signed_closure_exception`.**  A coherent closure rotation `U` applied *before* pinching
can **lower** the post-pinch determinant relative to naive pinching.  With the explicit
rational witness `ρ = !![1/2, 1/2; 1/2, 1/2]`, the rational rotation `Urot`, and `t = 1`,

`det (Pinch 1 (U ρ Uᴴ)) = 49/2500 < 1/4 = det (Pinch 1 ρ)`:

closure is not noise — it can reorganize coherence and reduce mass. -/
theorem signed_closure_exception :
    (Matrix.det (Pinch 1 (Urot * rhoM (1 / 2) (1 / 2) * Urotᴴ))).re
      < (Matrix.det (Pinch 1 (rhoM (1 / 2) (1 / 2)))).re := by
  simp only [Urot, rhoM, Pinch, Matrix.det_fin_two, Matrix.mul_apply, Matrix.conjTranspose_apply,
    Fin.sum_univ_two, Matrix.diagonal, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
    Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one, map_div₀, map_ofNat, star]
  norm_num [Complex.ext_iff, Complex.add_re, Complex.mul_re, Complex.sub_re, Complex.div_re]

/-! ## Mandatory non-degeneracy fixture -/

/-- **Non-degeneracy fixture.**  For `p = 1/2`, `z = 1/2` the state is *massless*
(`det ρ = 1/4 - 1/4 = 0`) yet full decoherence produces strictly positive mass²
(`det (Pinch 1 ρ) = 1/4 > 0`): coherence hides real mass, so the monotonicity is
genuinely non-vacuous. -/
theorem nondegeneracy :
    massSq (1 / 2) (1 / 2) 0 = 0 ∧ massSq (1 / 2) (1 / 2) 1 = 1 / 4 := by
  constructor <;>
  · rw [massSq_eq]
    norm_num [Complex.norm_real]

/-! ## Axiom footprint checks -/

/-- info: 'SuiteD_EntropyMonotone.pinch_is_state' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pinch_is_state

/-- info: 'SuiteD_EntropyMonotone.det_pinch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_pinch

/-- info: 'SuiteD_EntropyMonotone.mass_monotone_under_pinch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_monotone_under_pinch

/-- info: 'SuiteD_EntropyMonotone.signed_closure_exception' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms signed_closure_exception

/-- info: 'SuiteD_EntropyMonotone.nondegeneracy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegeneracy

end SuiteD_EntropyMonotone
