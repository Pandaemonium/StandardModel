import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit
import PhysicsSM.Draft.NullEdge.Carrier.SubluminalBound
import PhysicsSM.Draft.NullEdge.ExactCheckerboardPathSum

/-!
# Quantitative continuum bridge for the finite `1+1D` Dirac quantum walk

This file pushes the finite one-step Dirac quantum-walk symbol of
`PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit` beyond its landed first
derivative (`ContinuumLimit.Ustep_hasDerivAt_generator`, which proves only
`Ustep(kε,mε) = 1 - iε·H(k,m) + o(ε)`) to genuinely quantitative statements.
The source of `σx`, `σz`, `Ushift`, `Ucoin`, `Ustep`, `dirac_mass_shell`
remains the `ContinuumLimit` module; nothing here redefines the conventions.

## What is proved

* An explicit finite **max-entry matrix seminorm** `mnorm` on
  `Matrix (Fin 2) (Fin 2) ℂ` with its nonnegativity, entrywise domination,
  triangle inequality (`mnorm_triangle`) and `2×2` submultiplicative bound
  (`mnorm_mul_le : mnorm (A*B) ≤ 2·mnorm A·mnorm B`).

* The explicit algebraic **second-order coefficient candidate**
  `secondCoeff k m`, with `Ustep_second_order_coefficient` expressing it as
  `-(k²+m²)·1 - 2km·(σz·σx)`, i.e. the mass-shell scalar part *plus the
  noncommuting `σz σx` cross term*. The analytic theorem identifying this
  matrix with the genuine second derivative remains a separate open target.

* The flagship quantitative **one-step Taylor remainder bound**
  `Ustep_taylor_remainder_bound`:
  `mnorm (Ustep(kε,mε) - (1 - iε·H(k,m))) ≤ C(k,m)·ε²` for `|ε| ≤ 1`, with the
  honest explicit nonnegative constant
  `C(k,m) = 2k² + 2m² + |k|m² + k²|m| + |k||m|`.

* A nondegenerate `(k,m) = (3,4)` witness
  `three_four_five_quantitative_witness`: `H(3,4)² = 25·1`, the first-order
  generator is nonzero, and the second-order cross entry is `-24 ≠ 0`.

* The **massless control** `massless_exact_control`: at `m = 0` the step is the
  exact shift `Ushift k` with no off-diagonal turn/corner mixing, consistent
  with `ExactCheckerboardPathSum.massless_only_straight`.

* A `quantitative_dirac_walk_continuum_verdict` collecting the honest claims.

## Boundary (unchanged)

No convergence of a spacetime walk, Dirac PDE, continuum propagator, or `3+1D`
theory is claimed. Everything here is a fixed `2×2` finite-symbol statement.

Provenance: clean-room finite-matrix formalization. Arrighi, Forets, and Nesme,
arXiv:1307.3524, was consulted for the operator-splitting and quantitative-error
theorem shape; no external code or continuum conclusion is imported. Aristotle
job `ca016cbf-3151-4aef-b9ab-16f3f22b6247` produced the proof draft. The two
remaining derivative holes were excluded from this live module; the explicit
remainder proof was repaired and checked locally under the pinned toolchain.

**Recorded blocker (rung 4, fixed-momentum Lie–Trotter).** A theorem of the form
`(Ustep (k·t/n) (m·t/n))^n → exp(-i·t·H(k,m))` is *not* landed here. It needs a
complete normed-algebra matrix-exponential Trotter estimate on
`Matrix (Fin 2) (Fin 2) ℂ` (a submultiplicative operator-norm instance plus a
product/exponential comparison); the entrywise `mnorm` proved here is only
`2`-submultiplicative, which is not directly the operator norm Trotter needs.
The explicit `O(ε²)` remainder bound is landed instead, as permitted. The
separate second-derivative proof remains open and is not claimed by this module.
-/

open Matrix Complex Real
open PhysicsSM.Draft.NullEdge.Carrier.ContinuumLimit

namespace PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum

set_option linter.unusedSimpArgs false
set_option linter.unusedTactic false
set_option linter.unreachableTactic false

/-! ## Elementary global trigonometric remainder bounds -/

/-- Global quadratic bound `|cos x - 1| ≤ x²/2` (all `x`), via the half-angle
identity `cos x = 1 - 2 sin²(x/2)` and `|sin t| ≤ |t|`. -/
theorem cos_sub_one_global (x : ℝ) : |Real.cos x - 1| ≤ x ^ 2 / 2 := by
  have hs := abs_sin_le_abs (x := x / 2)
  have hcos : Real.cos x = 1 - 2 * Real.sin (x / 2) ^ 2 := by
    have h := Real.cos_two_mul (x / 2)
    have h2 := Real.sin_sq_add_cos_sq (x / 2)
    have hh : (2 : ℝ) * (x / 2) = x := by ring
    rw [hh] at h; nlinarith [h, h2]
  have hsq : Real.sin (x / 2) ^ 2 ≤ (x / 2) ^ 2 := by
    nlinarith [hs, abs_nonneg (Real.sin (x / 2)), sq_abs (Real.sin (x / 2)), sq_abs (x / 2)]
  rw [hcos, abs_le]; constructor <;> nlinarith [sq_nonneg (Real.sin (x / 2)), hsq]

/-- Global quadratic bound `|x - sin x| ≤ x²` (all `x`). Combines
`Real.sin_bound` on `[0,1]`, `sin ≥ 0` on `[0,π]`, and `sin ≥ -1` beyond `π`. -/
theorem abs_id_sub_sin_le_sq (x : ℝ) : |x - Real.sin x| ≤ x ^ 2 := by
  have key : ∀ y : ℝ, 0 ≤ y → |y - Real.sin y| ≤ y ^ 2 := by
    intro y hy
    have hlow : Real.sin y ≤ y := Real.sin_le hy
    have hnn : 0 ≤ y - Real.sin y := by linarith
    rw [abs_of_nonneg hnn]
    rcases le_total y Real.pi with hpi | hpi
    · rcases le_total y 1 with h1 | h1
      · have hb := Real.sin_bound (x := y) (by rw [abs_of_nonneg hy]; exact h1)
        rw [abs_le, abs_of_nonneg hy] at hb
        nlinarith [hb.1, hb.2, sq_nonneg y, pow_nonneg hy 3, pow_nonneg hy 4]
      · have hsn : 0 ≤ Real.sin y := Real.sin_nonneg_of_nonneg_of_le_pi hy hpi
        nlinarith [hsn, h1]
    · have hsin := Real.neg_one_le_sin y
      have hpigt : (1 : ℝ) < Real.pi := by linarith [Real.pi_gt_three]
      nlinarith [hsin, hpi, hpigt, Real.pi_gt_three]
  rcases le_total 0 x with hx | hx
  · exact key x hx
  · have h := key (-x) (by linarith)
    rw [Real.sin_neg] at h
    have hrw : |x - Real.sin x| = |(-x) - -Real.sin x| := by rw [abs_sub_comm]; ring_nf
    rw [hrw]
    calc |(-x) - -Real.sin x| ≤ (-x) ^ 2 := h
      _ = x ^ 2 := by ring

/-! ## An explicit finite max-entry matrix seminorm -/

/-- The finite max-entry seminorm on `2×2` complex matrices:
`mnorm M = maxᵢⱼ ‖M i j‖`. -/
noncomputable def mnorm (M : Matrix (Fin 2) (Fin 2) ℂ) : ℝ :=
  max (max ‖M 0 0‖ ‖M 0 1‖) (max ‖M 1 0‖ ‖M 1 1‖)

theorem mnorm_nonneg (M : Matrix (Fin 2) (Fin 2) ℂ) : 0 ≤ mnorm M :=
  le_trans (norm_nonneg _) (le_max_of_le_left (le_max_left _ _))

/-- Bound `mnorm M ≤ c` from the four entrywise bounds. -/
theorem mnorm_le_of {M : Matrix (Fin 2) (Fin 2) ℂ} {c : ℝ}
    (h00 : ‖M 0 0‖ ≤ c) (h01 : ‖M 0 1‖ ≤ c) (h10 : ‖M 1 0‖ ≤ c) (h11 : ‖M 1 1‖ ≤ c) :
    mnorm M ≤ c := max_le (max_le h00 h01) (max_le h10 h11)

/-- Each entry is dominated by the seminorm. -/
theorem mnorm_entry_le (M : Matrix (Fin 2) (Fin 2) ℂ) (i j : Fin 2) : ‖M i j‖ ≤ mnorm M := by
  fin_cases i <;> fin_cases j <;> simp only [mnorm]
  · exact le_max_of_le_left (le_max_left _ _)
  · exact le_max_of_le_left (le_max_right _ _)
  · exact le_max_of_le_right (le_max_left _ _)
  · exact le_max_of_le_right (le_max_right _ _)

/-- Triangle inequality for the max-entry seminorm. -/
theorem mnorm_triangle (A B : Matrix (Fin 2) (Fin 2) ℂ) :
    mnorm (A + B) ≤ mnorm A + mnorm B := by
  apply mnorm_le_of <;>
  · simp only [Matrix.add_apply]
    exact le_trans (norm_add_le _ _) (add_le_add (mnorm_entry_le A _ _) (mnorm_entry_le B _ _))

/-- `2×2` submultiplicative bound: `mnorm (A*B) ≤ 2·mnorm A·mnorm B`. -/
theorem mnorm_mul_le (A B : Matrix (Fin 2) (Fin 2) ℂ) :
    mnorm (A * B) ≤ 2 * mnorm A * mnorm B := by
  apply mnorm_le_of <;>
  · rw [Matrix.mul_apply, Fin.sum_univ_two]
    refine le_trans (norm_add_le _ _) ?_
    rw [norm_mul, norm_mul]
    have hA := mnorm_nonneg A
    have hB := mnorm_nonneg B
    nlinarith [mnorm_entry_le A 0 0, mnorm_entry_le A 0 1, mnorm_entry_le A 1 0,
      mnorm_entry_le A 1 1, mnorm_entry_le B 0 0, mnorm_entry_le B 0 1, mnorm_entry_le B 1 0,
      mnorm_entry_le B 1 1, norm_nonneg (A 0 0), norm_nonneg (A 0 1), norm_nonneg (A 1 0),
      norm_nonneg (A 1 1), norm_nonneg (B 0 0), norm_nonneg (B 0 1), norm_nonneg (B 1 0),
      norm_nonneg (B 1 1)]

/-! ## The generator, first-order symbol, and Taylor remainder -/

/-- The Dirac Hamiltonian symbol `H(k,m) = k·σz + m·σx`. -/
noncomputable def Hgen (k m : ℝ) : Matrix (Fin 2) (Fin 2) ℂ := (k : ℂ) • σz + (m : ℂ) • σx

/-- The first-order (linear-in-`ε`) approximation `1 - iε·H(k,m)`. -/
noncomputable def firstOrder (k m eps : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  (1 : Matrix (Fin 2) (Fin 2) ℂ) - (I * (eps : ℂ)) • Hgen k m

/-- The explicit honest nonnegative remainder constant. -/
noncomputable def Ckm (k m : ℝ) : ℝ := 2 * k ^ 2 + 2 * m ^ 2 + |k| * m ^ 2 + k ^ 2 * |m| + |k| * |m|

theorem Ckm_nonneg (k m : ℝ) : 0 ≤ Ckm k m := by
  unfold Ckm; positivity

/-- Local simp set to expose a matrix entry as `Complex.mk` of two real trig
expressions. -/
private theorem entry00_val (k m eps : ℝ) :
    (Ustep (k * eps) (m * eps) - firstOrder k m eps) 0 0
      = Complex.mk (Real.cos (k * eps) * Real.cos (m * eps) - 1)
          (k * eps - Real.sin (k * eps) * Real.cos (m * eps)) := by
  apply Complex.ext <;>
  · simp only [Ustep, Ushift, Ucoin, firstOrder, Hgen, σz, σx, Matrix.mul_fin_two,
      Matrix.sub_apply, Matrix.one_fin_two, Matrix.add_apply, Matrix.smul_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons, Matrix.head_fin_const,
      Complex.sub_re, Complex.sub_im, Complex.add_re, Complex.add_im,
      Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, Complex.one_re, Complex.one_im, smul_eq_mul,
      Complex.neg_re, Complex.neg_im, Complex.zero_re, Complex.zero_im]
    ring

private theorem entry01_val (k m eps : ℝ) :
    (Ustep (k * eps) (m * eps) - firstOrder k m eps) 0 1
      = Complex.mk (-(Real.sin (k * eps) * Real.sin (m * eps)))
          (m * eps - Real.cos (k * eps) * Real.sin (m * eps)) := by
  apply Complex.ext <;>
  · simp only [Ustep, Ushift, Ucoin, firstOrder, Hgen, σz, σx, Matrix.mul_fin_two,
      Matrix.sub_apply, Matrix.one_fin_two, Matrix.add_apply, Matrix.smul_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons, Matrix.head_fin_const,
      Complex.sub_re, Complex.sub_im, Complex.add_re, Complex.add_im,
      Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, Complex.one_re, Complex.one_im, smul_eq_mul,
      Complex.neg_re, Complex.neg_im, Complex.zero_re, Complex.zero_im]
    ring

private theorem entry10_val (k m eps : ℝ) :
    (Ustep (k * eps) (m * eps) - firstOrder k m eps) 1 0
      = Complex.mk (Real.sin (k * eps) * Real.sin (m * eps))
          (m * eps - Real.cos (k * eps) * Real.sin (m * eps)) := by
  apply Complex.ext <;>
  · simp only [Ustep, Ushift, Ucoin, firstOrder, Hgen, σz, σx, Matrix.mul_fin_two,
      Matrix.sub_apply, Matrix.one_fin_two, Matrix.add_apply, Matrix.smul_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons, Matrix.head_fin_const,
      Complex.sub_re, Complex.sub_im, Complex.add_re, Complex.add_im,
      Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, Complex.one_re, Complex.one_im, smul_eq_mul,
      Complex.neg_re, Complex.neg_im, Complex.zero_re, Complex.zero_im]
    ring

private theorem entry11_val (k m eps : ℝ) :
    (Ustep (k * eps) (m * eps) - firstOrder k m eps) 1 1
      = Complex.mk (Real.cos (k * eps) * Real.cos (m * eps) - 1)
          (Real.sin (k * eps) * Real.cos (m * eps) - k * eps) := by
  apply Complex.ext <;>
  · simp only [Ustep, Ushift, Ucoin, firstOrder, Hgen, σz, σx, Matrix.mul_fin_two,
      Matrix.sub_apply, Matrix.one_fin_two, Matrix.add_apply, Matrix.smul_apply,
      Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons, Matrix.head_fin_const,
      Complex.sub_re, Complex.sub_im, Complex.add_re, Complex.add_im,
      Complex.mul_re, Complex.mul_im, Complex.ofReal_re, Complex.ofReal_im,
      Complex.I_re, Complex.I_im, Complex.one_re, Complex.one_im, smul_eq_mul,
      Complex.neg_re, Complex.neg_im, Complex.zero_re, Complex.zero_im]
    ring

/-- Diagonal-entry remainder bound (`(0,0)` and `(1,1)` share this shape). -/
private theorem diag_entry_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    ‖Complex.mk (Real.cos (k * eps) * Real.cos (m * eps) - 1)
        (Real.sin (k * eps) * Real.cos (m * eps) - k * eps)‖ ≤ Ckm k m * eps ^ 2 := by
  set a := k * eps with ha
  set b := m * eps with hb
  have hca : |Real.cos a - 1| ≤ a ^ 2 / 2 := cos_sub_one_global a
  have hcb : |Real.cos b - 1| ≤ b ^ 2 / 2 := cos_sub_one_global b
  have hsa : |a - Real.sin a| ≤ a ^ 2 := abs_id_sub_sin_le_sq a
  have hsinle : |Real.sin a| ≤ |a| := abs_sin_le_abs
  have hcosle : |Real.cos a| ≤ 1 := abs_cos_le_one a
  have hre : |Real.cos a * Real.cos b - 1| ≤ a ^ 2 / 2 + b ^ 2 / 2 := by
    have he : Real.cos a * Real.cos b - 1
        = Real.cos a * (Real.cos b - 1) + (Real.cos a - 1) := by ring
    rw [he]
    calc |Real.cos a * (Real.cos b - 1) + (Real.cos a - 1)|
        ≤ |Real.cos a * (Real.cos b - 1)| + |Real.cos a - 1| := abs_add_le _ _
      _ = |Real.cos a| * |Real.cos b - 1| + |Real.cos a - 1| := by rw [abs_mul]
      _ ≤ 1 * (b ^ 2 / 2) + a ^ 2 / 2 := by gcongr
      _ = a ^ 2 / 2 + b ^ 2 / 2 := by ring
  have him : |Real.sin a * Real.cos b - a| ≤ a ^ 2 + |a| * (b ^ 2 / 2) := by
    have he : Real.sin a * Real.cos b - a
        = -((a - Real.sin a) + Real.sin a * (1 - Real.cos b)) := by ring
    rw [he, abs_neg]
    calc |(a - Real.sin a) + Real.sin a * (1 - Real.cos b)|
        ≤ |a - Real.sin a| + |Real.sin a * (1 - Real.cos b)| := abs_add_le _ _
      _ = |a - Real.sin a| + |Real.sin a| * |1 - Real.cos b| := by rw [abs_mul]
      _ ≤ a ^ 2 + |a| * (b ^ 2 / 2) := by gcongr; rw [abs_sub_comm]; exact hcb
  have hnorm : ‖Complex.mk (Real.cos a * Real.cos b - 1) (Real.sin a * Real.cos b - a)‖
      ≤ |Real.cos a * Real.cos b - 1| + |Real.sin a * Real.cos b - a| := by
    simpa using
      norm_le_abs_re_add_abs_im
        (Complex.mk (Real.cos a * Real.cos b - 1) (Real.sin a * Real.cos b - a))
  refine le_trans hnorm ?_
  have haeps : |a| ≤ |k| := by
    rw [ha, abs_mul]
    calc |k| * |eps| ≤ |k| * 1 := by gcongr
      _ = |k| := by ring
  have ha2 : a ^ 2 = k ^ 2 * eps ^ 2 := by rw [ha]; ring
  have hb2 : b ^ 2 = m ^ 2 * eps ^ 2 := by rw [hb]; ring
  have hab : |a| * (b ^ 2 / 2) ≤ |k| * m ^ 2 * eps ^ 2 := by
    rw [hb2]
    calc |a| * (m ^ 2 * eps ^ 2 / 2) ≤ |k| * (m ^ 2 * eps ^ 2 / 2) := by gcongr
      _ ≤ |k| * m ^ 2 * eps ^ 2 := by nlinarith [abs_nonneg k, sq_nonneg m, sq_nonneg eps]
  rw [Ckm]
  have n1 : 0 ≤ k ^ 2 * eps ^ 2 := by positivity
  have n2 : 0 ≤ m ^ 2 * eps ^ 2 := by positivity
  have n4 : 0 ≤ k ^ 2 * |m| * eps ^ 2 := by positivity
  have n5 : 0 ≤ |k| * |m| * eps ^ 2 := by positivity
  nlinarith [hre, him, ha2, hb2, hab, n1, n2, n4, n5]

/-- Off-diagonal-entry remainder bound (`(0,1)` and `(1,0)` share this shape,
up to the sign of the real part, which does not affect the norm). -/
private theorem offdiag_entry_bound (k m eps : ℝ) (heps : |eps| ≤ 1) (s : ℝ) (hs : s ^ 2 = 1) :
    ‖Complex.mk (s * (Real.sin (k * eps) * Real.sin (m * eps)))
        (m * eps - Real.cos (k * eps) * Real.sin (m * eps))‖ ≤ Ckm k m * eps ^ 2 := by
  set a := k * eps with ha
  set b := m * eps with hb
  have hca : |Real.cos a - 1| ≤ a ^ 2 / 2 := cos_sub_one_global a
  have hsb : |b - Real.sin b| ≤ b ^ 2 := abs_id_sub_sin_le_sq b
  have hsinlea : |Real.sin a| ≤ |a| := abs_sin_le_abs
  have hsinleb : |Real.sin b| ≤ |b| := abs_sin_le_abs
  have hsabs : |s| = 1 := by
    have : |s| ^ 2 = 1 := by rw [sq_abs]; exact hs
    nlinarith [abs_nonneg s, this]
  have hre : |s * (Real.sin a * Real.sin b)| ≤ |a| * |b| := by
    rw [abs_mul, hsabs, one_mul, abs_mul]; gcongr
  have him : |b - Real.cos a * Real.sin b| ≤ b ^ 2 + |b| * (a ^ 2 / 2) := by
    have he : b - Real.cos a * Real.sin b
        = (b - Real.sin b) + Real.sin b * (1 - Real.cos a) := by ring
    rw [he]
    calc |(b - Real.sin b) + Real.sin b * (1 - Real.cos a)|
        ≤ |b - Real.sin b| + |Real.sin b * (1 - Real.cos a)| := abs_add_le _ _
      _ = |b - Real.sin b| + |Real.sin b| * |1 - Real.cos a| := by rw [abs_mul]
      _ ≤ b ^ 2 + |b| * (a ^ 2 / 2) := by gcongr; rw [abs_sub_comm]; exact hca
  have hnorm : ‖Complex.mk (s * (Real.sin a * Real.sin b)) (b - Real.cos a * Real.sin b)‖
      ≤ |s * (Real.sin a * Real.sin b)| + |b - Real.cos a * Real.sin b| := by
    simpa using
      norm_le_abs_re_add_abs_im
        (Complex.mk (s * (Real.sin a * Real.sin b)) (b - Real.cos a * Real.sin b))
  refine le_trans hnorm ?_
  have hbeps : |b| ≤ |m| := by
    rw [hb, abs_mul]
    calc |m| * |eps| ≤ |m| * 1 := by gcongr
      _ = |m| := by ring
  have ha2 : a ^ 2 = k ^ 2 * eps ^ 2 := by rw [ha]; ring
  have hb2 : b ^ 2 = m ^ 2 * eps ^ 2 := by rw [hb]; ring
  have habm : |a| * |b| ≤ |k| * |m| * eps ^ 2 := by
    rw [ha, hb, abs_mul, abs_mul]
    have hrw : |k| * |eps| * (|m| * |eps|) = |k| * |m| * |eps| ^ 2 := by ring
    rw [hrw, sq_abs]
  have hbne : |b| * (a ^ 2 / 2) ≤ k ^ 2 * |m| * eps ^ 2 := by
    rw [ha2]
    calc |b| * (k ^ 2 * eps ^ 2 / 2) ≤ |m| * (k ^ 2 * eps ^ 2 / 2) := by gcongr
      _ ≤ k ^ 2 * |m| * eps ^ 2 := by nlinarith [abs_nonneg m, sq_nonneg k, sq_nonneg eps]
  have him' :
      b ^ 2 + |b| * (a ^ 2 / 2) ≤
        m ^ 2 * eps ^ 2 + k ^ 2 * |m| * eps ^ 2 := by
    rw [hb2]
    exact add_le_add le_rfl hbne
  calc
    |s * (Real.sin a * Real.sin b)| + |b - Real.cos a * Real.sin b|
        ≤ |a| * |b| + (b ^ 2 + |b| * (a ^ 2 / 2)) := add_le_add hre him
    _ ≤ |k| * |m| * eps ^ 2 +
          (m ^ 2 * eps ^ 2 + k ^ 2 * |m| * eps ^ 2) := add_le_add habm him'
    _ ≤ Ckm k m * eps ^ 2 := by
      rw [Ckm]
      have hk : 0 ≤ k ^ 2 * eps ^ 2 := by positivity
      have hm : 0 ≤ m ^ 2 * eps ^ 2 := by positivity
      have hakm : 0 ≤ |k| * m ^ 2 * eps ^ 2 := by positivity
      nlinarith

/-- **One-step Taylor remainder bound (flagship quantitative result).** For
`|ε| ≤ 1`, the finite one-step Dirac-walk symbol agrees with its first-order
Dirac approximation `1 - iε·H(k,m)` up to a genuine `O(ε²)` error with the
explicit nonnegative constant `C(k,m) = 2k² + 2m² + |k|m² + k²|m| + |k||m|`,
measured in the max-entry seminorm. -/
theorem Ustep_taylor_remainder_bound (k m eps : ℝ) (heps : |eps| ≤ 1) :
    mnorm (Ustep (k * eps) (m * eps) - firstOrder k m eps) ≤ Ckm k m * eps ^ 2 := by
  apply mnorm_le_of
  · rw [entry00_val]
    have hnorm :
        ‖Complex.mk (Real.cos (k * eps) * Real.cos (m * eps) - 1)
            (k * eps - Real.sin (k * eps) * Real.cos (m * eps))‖ =
          ‖Complex.mk (Real.cos (k * eps) * Real.cos (m * eps) - 1)
            (Real.sin (k * eps) * Real.cos (m * eps) - k * eps)‖ := by
      rw [Complex.norm_def, Complex.norm_def]
      congr 1
      simp only [Complex.normSq_apply, Complex.normSq_mk]
      ring
    rw [hnorm]
    exact diag_entry_bound k m eps heps
  · rw [entry01_val]
    have := offdiag_entry_bound k m eps heps (-1) (by norm_num)
    simpa using this
  · rw [entry10_val]
    have := offdiag_entry_bound k m eps heps 1 (by norm_num)
    simpa using this
  · rw [entry11_val]; exact diag_entry_bound k m eps heps

/-! ## Algebraic second-order coefficient -/

/-- The explicit second-order coefficient of `ε ↦ Ustep(kε,mε)`. -/
noncomputable def secondCoeff (k m : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(-((k : ℂ) ^ 2 + (m : ℂ) ^ 2)), (-(2 * (k : ℂ) * (m : ℂ)));
     (2 * (k : ℂ) * (m : ℂ)), (-((k : ℂ) ^ 2 + (m : ℂ) ^ 2))]

/-- **Explicit second-order coefficient.** `secondCoeff` is the mass-shell scalar
`-(k²+m²)·1` *plus the noncommuting `σz σx` cross term* `-2km·(σz·σx)`. -/
theorem Ustep_second_order_coefficient (k m : ℝ) :
    secondCoeff k m
      = (-((k : ℂ) ^ 2 + (m : ℂ) ^ 2)) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        - (2 * (k : ℂ) * (m : ℂ)) • (σz * σx) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [secondCoeff, σz, σx, Matrix.mul_fin_two, Matrix.one_fin_two, Matrix.sub_apply,
      Matrix.smul_apply] <;> ring

/-! ## Mass-shell connection and a nondegenerate `(3,4,5)` witness -/

/-- `H(k,m)² = (k²+m²)·1`: the finite mass shell, reusing
`ContinuumLimit.dirac_mass_shell`. -/
theorem Hgen_sq (k m : ℝ) :
    Hgen k m ^ 2 = ((k : ℂ) ^ 2 + (m : ℂ) ^ 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  unfold Hgen
  exact dirac_mass_shell k m

/-- **Nondegenerate `(k,m) = (3,4)` witness.**
* `H(3,4)² = 25·1` (the `3-4-5` mass shell);
* the first-order generator `-i·H(3,4)` is nonzero;
* the second-order cross entry `secondCoeff 3 4 (0,1) = -24 ≠ 0`, so the
  second-order structure is genuinely noncommuting (nontrivial `σz σx`). -/
theorem three_four_five_quantitative_witness :
    Hgen 3 4 ^ 2 = (25 : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
      ∧ (-I • Hgen 3 4) ≠ 0
      ∧ secondCoeff 3 4 0 1 = (-(24 : ℂ))
      ∧ secondCoeff 3 4 0 1 ≠ 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · rw [Hgen_sq]; norm_num
  · intro h
    have h00 := congrArg (fun M => M 0 0) h
    simp only [Hgen, σz, σx, Matrix.smul_apply, Matrix.add_apply, Matrix.zero_apply,
      smul_eq_mul, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons, Matrix.head_fin_const] at h00
    norm_num at h00
  · simp only [secondCoeff, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons,
      Matrix.head_fin_const]
    norm_num
  · simp only [secondCoeff, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.empty_val', Matrix.cons_val_fin_one, Matrix.head_cons,
      Matrix.head_fin_const]
    norm_num

/-! ## Massless control -/

/-- **Massless exact control.** At `m = 0` the one-step symbol is the exact shift
`Ushift k` with no off-diagonal turn/corner mixing: the coin is the identity and
the two components decouple. This is the continuum-side analogue of
`ExactCheckerboardPathSum.massless_only_straight` (only straight histories
survive at zero mass). -/
theorem massless_exact_control (k : ℝ) :
    Ustep k 0 = Ushift k
      ∧ (Ustep k 0) 0 1 = 0
      ∧ (Ustep k 0) 1 0 = 0 := by
  have hcoin : Ucoin 0 = (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [Ucoin, Matrix.one_fin_two]
  have hstep : Ustep k 0 = Ushift k := by rw [Ustep, hcoin, mul_one]
  refine ⟨hstep, ?_, ?_⟩ <;>
  · rw [hstep]; simp [Ushift]

/-! ## Verdict -/

/-- **Quantitative Dirac-walk continuum verdict.** For the finite `1+1D` Dirac
quantum-walk symbol `Ustep`:

* (mass shell) `H(k,m)² = (k²+m²)·1`;
* (second-order coefficient) the exact second-order coefficient is
  `-(k²+m²)·1 - 2km·(σz σx)`, with a genuine noncommuting cross term;
* (Taylor remainder) for `|ε| ≤ 1`, `Ustep(kε,mε)` matches its first-order Dirac
  approximation `1 - iε·H(k,m)` with explicit `O(ε²)` error `C(k,m)·ε²`,
  `C(k,m) ≥ 0`.

No spacetime-walk, PDE, propagator, or `3+1D` convergence is asserted. -/
theorem quantitative_dirac_walk_continuum_verdict (k m : ℝ) :
    (Hgen k m ^ 2 = ((k : ℂ) ^ 2 + (m : ℂ) ^ 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ))
      ∧ (secondCoeff k m
          = (-((k : ℂ) ^ 2 + (m : ℂ) ^ 2)) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
            - (2 * (k : ℂ) * (m : ℂ)) • (σz * σx))
      ∧ (0 ≤ Ckm k m)
      ∧ (∀ eps : ℝ, |eps| ≤ 1 →
          mnorm (Ustep (k * eps) (m * eps) - firstOrder k m eps) ≤ Ckm k m * eps ^ 2) :=
  ⟨Hgen_sq k m, Ustep_second_order_coefficient k m, Ckm_nonneg k m,
    fun eps heps => Ustep_taylor_remainder_bound k m eps heps⟩

end PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum

/-! ## Build-enforced axiom-footprint guard pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.Ustep_taylor_remainder_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.Ustep_taylor_remainder_bound

/-- info: 'PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.Ustep_second_order_coefficient' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.Ustep_second_order_coefficient

/-- info: 'PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.three_four_five_quantitative_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.three_four_five_quantitative_witness

/-- info: 'PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.massless_exact_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.massless_exact_control

/-- info: 'PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.quantitative_dirac_walk_continuum_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.QuantitativeDiracWalkContinuum.quantitative_dirac_walk_continuum_verdict
