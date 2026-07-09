/-
# The `n`-edge Plücker mass IS the G-concurrenceⁿ (M, general `n`)

Kernel-clean generalization of `TwoEdgeMassConcurrence.lean` from **two** null
spinors to a bundle of **`n`** null spinors of dimension `d = n` (the square /
"maximal Plücker coordinate" case).

## Setup

Let `M : Matrix (Fin n) (Fin n) ℂ` have columns `ψ₁,…,ψₙ ∈ ℂⁿ` (the `n` null
spinors). The momentum / Gram matrix is `P = M * Mᴴ` and the top Plücker mass is
`det P`. The single top Plücker coordinate is the wedge `ψ₁ ∧ … ∧ ψₙ = det M`.

## Results

* `det_gram_eq_normSq_wedge` (Deliverable 1): `det (M * Mᴴ) = normSq (det M)`
  for arbitrary `n` — the mass is the squared magnitude of the top wedge
  `|ψ₁ ∧ … ∧ ψₙ|²`, real and nonnegative. This is the verbatim generalization of
  the two-edge `det_gram_eq_normSq_wedge`.
* `gConcurrence` (Deliverable 3): the **G-concurrence** of the bundle read as a
  bipartite `n × n` pure state,
  `G(M) = n · (det ρ)^{1/n} = n · (normSq (det M))^{1/n}`,
  where `ρ = P = M Mᴴ` is the reduced density data. This is Gour's G-concurrence
  (`G_N` in the program's notes), the standard multi-party generalization of the
  Wootters concurrence.
* `gConcurrence_pow_eq_det_gram` (Deliverable 3): `(G(M) / n)ⁿ = det P`. The
  `n`-edge Plücker mass literally *is* the `n`-th normalized power of the
  G-concurrence — the clean generalization of `det P = (C/2)²`.
* `gConcurrence_two_eq` / `four_mul_det_gram_eq_gConcurrence_two_sq`: at `n = 2`
  the G-concurrence collapses to the Wootters concurrence `C = 2‖det M‖` and the
  identity collapses to the two-edge `4 · det P = C²`, so the two-edge theorem is
  recovered as a special case (nothing is weakened).

So "mass = concurrence²" generalizes *cleanly*: `det P = (G/n)ⁿ`, with the
Wootters `C²/4` being the `n = 2` instance. See `ARISTOTLE_SUMMARY.md`.
-/

import Mathlib

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence

/-- **Deliverable 1.** The `n`-edge Gram determinant equals the squared magnitude
of the top wedge `det M` (`= |ψ₁ ∧ … ∧ ψₙ|²`): `det (M * Mᴴ) = normSq (det M)`.
This is the `n`-edge Plücker mass, real and nonnegative. Verbatim generalization
of the two-edge statement to arbitrary `n`. -/
theorem det_gram_eq_normSq_wedge {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ) :
    (M * Mᴴ).det = (Complex.normSq M.det : ℂ) := by
  rw [Matrix.det_mul, Matrix.det_conjTranspose, Complex.star_def,
    Complex.mul_conj]

/-- The `n`-edge Gram determinant is real (imaginary part zero). -/
theorem det_gram_im_zero {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ) :
    (M * Mᴴ).det.im = 0 := by
  rw [det_gram_eq_normSq_wedge, Complex.ofReal_im]

/-- The `n`-edge Gram determinant is real and nonnegative. -/
theorem det_gram_re_nonneg {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ) :
    0 ≤ (M * Mᴴ).det.re := by
  rw [det_gram_eq_normSq_wedge, Complex.ofReal_re]
  exact Complex.normSq_nonneg _

/-- **Deliverable 3 (the measure).** The **G-concurrence** of the null bundle read
as a bipartite `n × n` pure state with amplitude matrix `M`:
`G(M) = n · (det ρ)^{1/n}`, where `det ρ = normSq (det M)` is the determinant of
the reduced density data `ρ = P = M Mᴴ`. This is Gour's G-concurrence, the
standard multi-party generalization of the Wootters concurrence (which it recovers
at `n = 2`). -/
noncomputable def gConcurrence {n : ℕ} (M : Matrix (Fin n) (Fin n) ℂ) : ℝ :=
  n * (Complex.normSq M.det) ^ ((1 : ℝ) / n)

/-- **Deliverable 3 (the identification).** `(G(M) / n)ⁿ = det P`. The `n`-edge
Plücker mass is exactly the `n`-th normalized power of the G-concurrence — the
clean generalization of the two-edge `det P = (C/2)²`. -/
theorem gConcurrence_pow_eq_det_gram {n : ℕ} (hn : 0 < n)
    (M : Matrix (Fin n) (Fin n) ℂ) :
    (gConcurrence M / n) ^ n = (M * Mᴴ).det.re := by
  rw [det_gram_eq_normSq_wedge, Complex.ofReal_re]
  unfold gConcurrence
  have hn' : (n : ℝ) ≠ 0 := by positivity
  rw [mul_div_cancel_left₀ _ hn',
    ← Real.rpow_natCast ((Complex.normSq M.det) ^ ((1 : ℝ) / n)) n,
    ← Real.rpow_mul (Complex.normSq_nonneg _), one_div,
    inv_mul_cancel₀ hn', Real.rpow_one]

/-- At `n = 2` the G-concurrence is exactly the Wootters concurrence
`C = 2‖det M‖`. -/
theorem gConcurrence_two_eq (M : Matrix (Fin 2) (Fin 2) ℂ) :
    gConcurrence M = 2 * ‖M.det‖ := by
  unfold gConcurrence
  push_cast
  congr 1
  rw [Complex.normSq_eq_norm_sq, show ((1 : ℝ) / 2) = ((2 : ℝ)⁻¹) by norm_num,
    ← Real.rpow_natCast ‖M.det‖ 2, ← Real.rpow_mul (norm_nonneg _)]
  norm_num

/-- The two-edge identity `4 · det P = C²` recovered from the general
G-concurrence identity at `n = 2` (with `C = 2‖det M‖`), showing the original
two-edge theorem is a special case. -/
theorem four_mul_det_gram_eq_gConcurrence_two_sq (M : Matrix (Fin 2) (Fin 2) ℂ) :
    (4 : ℝ) * (M * Mᴴ).det.re = gConcurrence M ^ 2 := by
  have h := gConcurrence_pow_eq_det_gram (by norm_num : (0 : ℕ) < 2) M
  rw [div_pow] at h
  push_cast at h
  nlinarith [h]

end PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence.det_gram_eq_normSq_wedge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence.det_gram_eq_normSq_wedge

/-- info: 'PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence.gConcurrence_pow_eq_det_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence.gConcurrence_pow_eq_det_gram

/-- info: 'PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence.four_mul_det_gram_eq_gConcurrence_two_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NEdgeMassConcurrence.four_mul_det_gram_eq_gConcurrence_two_sq
