import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 1000000

namespace SuiteD_EntropyMonotoneReal

open Matrix

/-!
# Suite D — rung D2 (real re-derivation)

Entropy / mass² monotonicity under a decohering "pinch" channel, worked entirely over
`ℝ` with real symmetric `2×2` matrices (no `Complex`, no `conj`, no transcendentals).

A *mixed direction state* is a real symmetric PSD trace-`1` matrix
`rho = !![p, x; x, 1-p]`, valid when `0 ≤ p`, `p ≤ 1`, `x² ≤ p(1-p)`.
The mass² invariant is `det rho = p(1-p) - x²` (half the linear entropy).
The pinching channel damps the off-diagonal coherence by a factor `1-t`.

Note: the single validity inequality `x² ≤ p(1-p)` already forces `0 ≤ p ≤ 1`
(since `x² ≥ 0` implies `p(1-p) ≥ 0`), so the `p`-range bounds are recorded in the prose
but need not be assumed separately; the lemmas below take only the sharp condition.
-/

/-- Real symmetric density-like matrix `!![p, x; x, 1-p]`. -/
def rhoM (p x : ℝ) : Matrix (Fin 2) (Fin 2) ℝ := !![p, x; x, 1 - p]

/-- Pinching channel: damps the off-diagonal coherence of `M` by a factor `1 - t`. -/
def Pinch (t : ℝ) (M : Matrix (Fin 2) (Fin 2) ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![M 0 0, (1 - t) * (M 0 1); (1 - t) * (M 1 0), M 1 1]

/-- A `2×2` real matrix is a *state*: symmetric, trace one, positive semidefinite. -/
def IsState (M : Matrix (Fin 2) (Fin 2) ℝ) : Prop :=
  M.IsSymm ∧ M.trace = 1 ∧ M.PosSemidef

/-- The real `3-4-5` rotation used for the signed-closure exception. -/
noncomputable def Urot : Matrix (Fin 2) (Fin 2) ℝ := !![3/5, -4/5; 4/5, 3/5]

/-! ## Basic evaluations -/

@[simp] theorem rhoM_00 (p x : ℝ) : rhoM p x 0 0 = p := rfl
@[simp] theorem rhoM_01 (p x : ℝ) : rhoM p x 0 1 = x := rfl
@[simp] theorem rhoM_10 (p x : ℝ) : rhoM p x 1 0 = x := rfl
@[simp] theorem rhoM_11 (p x : ℝ) : rhoM p x 1 1 = 1 - p := rfl

/-- Pinching `rhoM p x` just scales the coherence: `Pinch t (rhoM p x) = rhoM p ((1-t) x)`. -/
theorem pinch_rhoM (p x t : ℝ) : Pinch t (rhoM p x) = rhoM p ((1 - t) * x) := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [Pinch, rhoM]

/-- Positive-semidefiniteness of a valid `rhoM` (the sharp condition `x² ≤ p(1-p)`). -/
theorem rhoM_posSemidef (p x : ℝ) (hx : x ^ 2 ≤ p * (1 - p)) : (rhoM p x).PosSemidef := by
  rw [Matrix.posSemidef_iff_dotProduct_mulVec]
  refine ⟨?_, ?_⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp [rhoM]
  · intro v
    simp only [dotProduct, mulVec, Fin.sum_univ_two, rhoM_00, rhoM_01, rhoM_10, rhoM_11,
      Pi.star_apply, star_trivial]
    nlinarith [sq_nonneg (p * v 0 + x * v 1), sq_nonneg ((1 - p) * v 1 + x * v 0),
      mul_nonneg (sub_nonneg.2 hx) (sq_nonneg (v 1)),
      mul_nonneg (sub_nonneg.2 hx) (sq_nonneg (v 0))]

/-- A valid `rhoM` is a state. -/
theorem isState_rhoM (p x : ℝ) (hx : x ^ 2 ≤ p * (1 - p)) : IsState (rhoM p x) := by
  refine ⟨?_, ?_, rhoM_posSemidef p x hx⟩
  · ext i j; fin_cases i <;> fin_cases j <;> simp [rhoM]
  · simp [Matrix.trace_fin_two, rhoM]

/-! ## Target 1 -/

/-- `Pinch t rho` is a state whenever `rho = rhoM p x` is valid and `t ∈ [0,1]`. -/
theorem pinch_is_state (p x t : ℝ) (hx : x ^ 2 ≤ p * (1 - p))
    (ht0 : 0 ≤ t) (ht1 : t ≤ 1) : IsState (Pinch t (rhoM p x)) := by
  rw [pinch_rhoM]
  refine isState_rhoM p ((1 - t) * x) ?_
  have h1 : (1 - t) ^ 2 ≤ 1 := by nlinarith
  nlinarith [sq_nonneg x, mul_nonneg (sub_nonneg.2 hx) (sq_nonneg (1 - t))]

/-! ## Target 2 -/

/-- Closed form for the determinant after pinching. -/
theorem det_pinch (p x t : ℝ) :
    (Pinch t (rhoM p x)).det = (rhoM p x).det + (2 * t - t ^ 2) * x ^ 2 := by
  simp only [Matrix.det_fin_two, Pinch, rhoM]
  simp only [Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.empty_val', Matrix.cons_val_fin_one]
  ring

/-! ## Target 3 -/

/-- Decohering coherence can only increase mass²/entropy: the post-pinch determinant is
monotone in `t` on `[0,1]` and never below the un-pinched determinant. -/
theorem mass_monotone_under_pinch (p x : ℝ) :
    MonotoneOn (fun t => (Pinch t (rhoM p x)).det) (Set.Icc (0 : ℝ) 1) ∧
      ∀ t, 0 ≤ t → t ≤ 1 → (rhoM p x).det ≤ (Pinch t (rhoM p x)).det := by
  refine ⟨?_, ?_⟩
  · intro a ha b hb hab
    simp only [det_pinch]
    obtain ⟨ha0, _ha1⟩ := ha
    obtain ⟨_hb0, hb1⟩ := hb
    nlinarith [sq_nonneg x, mul_nonneg (sub_nonneg.2 hab) (sq_nonneg x)]
  · intro t ht0 ht1
    rw [det_pinch]
    nlinarith [sq_nonneg x, mul_nonneg (mul_nonneg ht0 (by linarith : (0:ℝ) ≤ 2 - t)) (sq_nonneg x)]

/-! ## Mandatory non-degeneracy -/

/-- The maximally-coherent state `!![1/2,1/2;1/2,1/2]` is massless (`det = 0`), yet full
pinching (`t = 1`) yields `det = 1/4 > 0`: monotonicity is non-vacuous. -/
theorem massless_pinch_gains_mass :
    (rhoM (1/2) (1/2)).det = 0 ∧ (Pinch 1 (rhoM (1/2) (1/2))).det = 1/4 := by
  refine ⟨?_, ?_⟩
  · simp only [Matrix.det_fin_two, rhoM_00, rhoM_01, rhoM_10, rhoM_11]; norm_num
  · rw [det_pinch]
    simp only [Matrix.det_fin_two, rhoM_00, rhoM_01, rhoM_10, rhoM_11]; norm_num

/-! ## Target 4 -/

/-- Evaluated congruence `U ρ Uᵀ` for the specific rational state. -/
theorem Ucong_eval :
    Urot * rhoM (1/2) (1/2) * Urotᵀ = !![1/50, -7/50; -7/50, 49/50] := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Urot, rhoM, Matrix.mul_apply, Fin.sum_univ_two, Matrix.transpose_apply] <;> norm_num

/-- **Signed-closure exception.** A real `3-4-5` rotation applied by congruence *before*
pinching can *lower* the post-pinch determinant compared with naive pinching: closure is not
noise; it can reorganize coherence and reduce mass². -/
theorem signed_closure_exception :
    (Pinch 1 (Urot * rhoM (1/2) (1/2) * Urotᵀ)).det
      < (Pinch 1 (rhoM (1/2) (1/2))).det := by
  rw [Ucong_eval]
  simp only [Matrix.det_fin_two, Pinch]
  norm_num [rhoM]

/-! ## Axiom footprint -/

/-- info: 'SuiteD_EntropyMonotoneReal.pinch_is_state' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms pinch_is_state

/-- info: 'SuiteD_EntropyMonotoneReal.det_pinch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms det_pinch

/-- info: 'SuiteD_EntropyMonotoneReal.mass_monotone_under_pinch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms mass_monotone_under_pinch

/-- info: 'SuiteD_EntropyMonotoneReal.signed_closure_exception' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms signed_closure_exception

/-- info: 'SuiteD_EntropyMonotoneReal.massless_pinch_gains_mass' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms massless_pinch_gains_mass

end SuiteD_EntropyMonotoneReal
