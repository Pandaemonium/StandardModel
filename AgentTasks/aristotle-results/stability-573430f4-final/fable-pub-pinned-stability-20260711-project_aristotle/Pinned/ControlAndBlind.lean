/-
# Deliverable 2 (part 2) — Control (no-mode) certificate and blind-field modes

Companion Lean file for `PINNED_STABILITY_DESIGN.md`.  Builds on the landed
context and on `Pinned.MirrorChart`.  Two parts of the taxonomy:

* **Zero/four-wall controls have no modes.**  Every zero- and four-wall walk
  satisfies the same degree-`4` control annihilator `W⁴ - (14/25)W² + 1 = 0`
  (`control_annihilator`), whose value at `±1` is `36/25 ≠ 0`, giving explicit
  polynomial inverses of `W ∓ 1` (`control_Wpm_invertible`) and hence no `±1`
  eigenvector over `ℂ` (`control_no_pos_mode`, `control_no_neg_mode`).

* **Blind-field modes via the mirror chart.**  Exact `±1` eigenvector witnesses
  for a blind fixed singleton `+++-` (`bBlind`), supported on the `{0,2}`-fixed
  sites with the same exact `1/2`-per-step / `1/4`-per-site localization as
  deliverable 1 — now on the mirror chart.  Plus the engine composition
  `mirror_modes`: every mirror-protected field (in particular all 4 blind
  fixed singletons) carries exact `±1` modes forced by its `{0,2}`-fixed-leg
  self-adjoint compression.

Draft-trust disclosure: the `ℚ` facts use `native_decide` (adds
`Lean.ofReduceBool` / `Lean.trustCompiler`); the engine-composition results are
kernel-only on top of those.
-/
import Mathlib
import context.HalfPeriodInvariant
import Pinned.MirrorChart

noncomputable section

namespace PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved

open Matrix
open PhysicsSM.Draft.NullEdge.ModeInvariantHalfWinding
open PhysicsSM.Draft.NullEdge.HalfPeriodInvariant

/-! ## 1.  Zero/four-wall controls: no certificate and no modes -/

/-- **The exact control annihilator.**  Every zero- and four-wall walk satisfies
the same degree-`4` polynomial `W⁴ - (14/25)W² + 1 = 0` (the `3-4-5` control
dispersion), whose value at `±1` is `p(±1) = 36/25 ≠ 0` — so neither `+1` nor
`-1` is an eigenvalue. -/
theorem control_annihilator :
    ∀ b, (wallCount b = 0 ∨ wallCount b = 4) →
      Wof b * Wof b * Wof b * Wof b - (14/25 : ℚ) • (Wof b * Wof b) + 1 = 0 := by
  native_decide

/-- Explicit polynomial inverse of `W - 1` on the controls
(`q(x) = x³ + x² + (11/25)x + 11/25`, scaled by `-25/36 = -1/p(1)`). -/
def ctrlKplus (b : Fin 4 → Bool) : Matrix V8 V8 ℚ :=
  (-25/36 : ℚ) • (Wof b * Wof b * Wof b + Wof b * Wof b
    + (11/25 : ℚ) • Wof b + (11/25 : ℚ) • 1)

/-- Explicit polynomial inverse of `W + 1` on the controls
(`q(x) = x³ - x² + (11/25)x - 11/25`, scaled by `-25/36 = -1/p(-1)`). -/
def ctrlKminus (b : Fin 4 → Bool) : Matrix V8 V8 ℚ :=
  (-25/36 : ℚ) • (Wof b * Wof b * Wof b - Wof b * Wof b
    + (11/25 : ℚ) • Wof b - (11/25 : ℚ) • 1)

/-- **`W ∓ 1` is invertible on the controls** (two-sided explicit inverses),
so zero- and four-wall walks have **no `±1` mode**. -/
theorem control_Wpm_invertible :
    ∀ b, (wallCount b = 0 ∨ wallCount b = 4) →
      (Wof b - 1) * ctrlKplus b = 1 ∧ ctrlKplus b * (Wof b - 1) = 1 ∧
      (Wof b + 1) * ctrlKminus b = 1 ∧ ctrlKminus b * (Wof b + 1) = 1 := by
  native_decide

/-- `toC` preserves subtraction. -/
theorem toC_sub {p q : Type*} [Fintype p] [Fintype q] (A B : Matrix p q ℚ) :
    toC (A - B) = toC A - toC B := by
  unfold toC; ext i j; simp [Matrix.map_apply, Matrix.sub_apply, map_sub]

/-- `toC` preserves addition. -/
theorem toC_add {p q : Type*} [Fintype p] [Fintype q] (A B : Matrix p q ℚ) :
    toC (A + B) = toC A + toC B := by
  unfold toC; ext i j; simp [Matrix.map_apply, Matrix.add_apply, map_add]

/-- **No `+1` mode on the controls** (over `ℂ`): `W v = v ⇒ v = 0`. -/
theorem control_no_pos_mode (b : Fin 4 → Bool) (h : wallCount b = 0 ∨ wallCount b = 4)
    (v : V8 → ℂ) (hv : (toC (Wof b)).mulVec v = v) : v = 0 := by
  obtain ⟨_, h2, _, _⟩ := control_Wpm_invertible b h
  have key : toC (ctrlKplus b) * (toC (Wof b) - 1) = 1 := by
    have := congrArg toC h2
    rw [toC_mul, toC_sub, toC_one] at this; exact this
  have hz : (toC (Wof b) - 1).mulVec v = 0 := by
    rw [Matrix.sub_mulVec, Matrix.one_mulVec, hv, sub_self]
  calc v = (1 : Matrix V8 V8 ℂ).mulVec v := (Matrix.one_mulVec v).symm
    _ = (toC (ctrlKplus b) * (toC (Wof b) - 1)).mulVec v := by rw [key]
    _ = (toC (ctrlKplus b)).mulVec ((toC (Wof b) - 1).mulVec v) := by
        rw [Matrix.mulVec_mulVec]
    _ = 0 := by rw [hz, Matrix.mulVec_zero]

/-- **No `-1` mode on the controls** (over `ℂ`): `W v = -v ⇒ v = 0`. -/
theorem control_no_neg_mode (b : Fin 4 → Bool) (h : wallCount b = 0 ∨ wallCount b = 4)
    (v : V8 → ℂ) (hv : (toC (Wof b)).mulVec v = -v) : v = 0 := by
  obtain ⟨_, _, _, h4⟩ := control_Wpm_invertible b h
  have key : toC (ctrlKminus b) * (toC (Wof b) + 1) = 1 := by
    have := congrArg toC h4
    rw [toC_mul, toC_add, toC_one] at this; exact this
  have hz : (toC (Wof b) + 1).mulVec v = 0 := by
    rw [Matrix.add_mulVec, Matrix.one_mulVec, hv, neg_add_cancel]
  calc v = (1 : Matrix V8 V8 ℂ).mulVec v := (Matrix.one_mulVec v).symm
    _ = (toC (ctrlKminus b) * (toC (Wof b) + 1)).mulVec v := by rw [key]
    _ = (toC (ctrlKminus b)).mulVec ((toC (Wof b) + 1).mulVec v) := by
        rw [Matrix.mulVec_mulVec]
    _ = 0 := by rw [hz, Matrix.mulVec_zero]

/-! ## 2.  Blind-field mode witnesses (chart `{0,2}`, kernel-checkable) -/

/-- The blind field `+++-` (lone flip at site `3`). -/
def bBlind : Fin 4 → Bool := ![true, true, true, false]

/-- Exact `+1` mode of the blind walk: site-0 amplitude `(2,2)`, site-2 amplitude
`(1,1) = (1/2)·` it; vanishes on the non-fixed sites `1,3`. -/
def psiBlindPlus : V8 → ℚ := fun x =>
  if x.1 = 0 then 2 else if x.1 = 2 then 1 else 0

/-- Exact `-1` mode of the blind walk: site-0 amplitude `(-2,2)`, site-2
amplitude `(1,-1) = (-1/2)·` it. -/
def psiBlindMinus : V8 → ℚ := fun x =>
  if x.1 = 0 then (if x.2 = 0 then -2 else 2)
  else if x.1 = 2 then (if x.2 = 0 then 1 else -1) else 0

theorem Wblind_psiBlindPlus : (Wof bBlind).mulVec psiBlindPlus = psiBlindPlus := by native_decide
theorem Wblind_psiBlindMinus : (Wof bBlind).mulVec psiBlindMinus = -psiBlindMinus := by native_decide
theorem psiBlindPlus_ne_zero : psiBlindPlus ≠ 0 := by native_decide
theorem psiBlindMinus_ne_zero : psiBlindMinus ≠ 0 := by native_decide

/-- The blind modes vanish on the non-fixed sites `1,3` and show exact `1/4`
per-site localization across the bulk step `site 0 → site 2`. -/
theorem psiBlindPlus_localized :
    (psiBlindPlus (1,0) = 0 ∧ psiBlindPlus (1,1) = 0 ∧
     psiBlindPlus (3,0) = 0 ∧ psiBlindPlus (3,1) = 0) ∧
    (∀ c : Fin 2, psiBlindPlus (2, c) = (1/2) * psiBlindPlus (0, c)) := by native_decide

/-! ## 3.  Engine composition: blind modes exist via the mirror chart (kernel) -/

/-- `Mfix0 b ≠ 1` and `≠ -1` for every field (traceless). -/
theorem Mfix0_ne_one (b : Fin 4 → Bool) : Mfix0 b ≠ 1 := by
  intro h; have := Mfix0_trace_zero b; rw [h] at this; simp [Matrix.trace_one] at this
theorem Mfix0_ne_neg_one (b : Fin 4 → Bool) : Mfix0 b ≠ -1 := by
  intro h; have := Mfix0_trace_zero b
  rw [h] at this; simp [Matrix.trace_neg, Matrix.trace_one] at this

/-- Every derived walk is orthogonal (reuse of the landed fact). -/
theorem Wof_unitary (b : Fin 4 → Bool) : (Wof b)ᵀ * Wof b = 1 :=
  PhysicsSM.Draft.NullEdge.HalfPeriodInvariant.allFields_unitary b

/-- **The mirror-chart involutive compression** for a mirror-protected field. -/
theorem involutiveCompression0_of_mirror (b : Fin 4 → Bool)
    (hb : mirrorProtected b = true) :
    InvolutiveCompression (toC (Wof b)) (toC Bfix0) (toC (Mfix0 b)) where
  iso := by rw [toC_conjTranspose, ← toC_mul, Bfix0_isometry, toC_one]
  intertwine := by rw [← toC_mul, ← toC_mul, Bfix0_intertwine]
  selfadj := by rw [toC_conjTranspose, ← ((selfadj0_iff_mirrorProtected b).2 hb)]
  unit := by rw [toC_conjTranspose, ← toC_mul, Wof_unitary, toC_one]

/-- **Blind-field mode existence via the mirror chart.**  Every mirror-protected
field (in particular the 4 blind fixed singletons) has an exact `-1` mode and an
exact `+1` mode, forced by the self-adjointness of its `{0,2}`-fixed-leg
compression — the mirror of the landed `protected_modes`. -/
theorem mirror_modes (b : Fin 4 → Bool) (hb : mirrorProtected b = true) :
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC (Wof b)).mulVec V = -V) ∧
    (∃ V : V8 → ℂ, V ≠ 0 ∧ (toC (Wof b)).mulVec V = V) := by
  have ic := involutiveCompression0_of_mirror b hb
  refine ⟨?_, ?_⟩
  · exact involutive_compression_flip_mode ic
      (fun h => Mfix0_ne_one b (toC_injective (by rw [h, toC_one])))
  · exact involutive_compression_fixed_mode ic
      (fun h => Mfix0_ne_neg_one b (toC_injective (by rw [toC_neg, toC_one, h])))

end PhysicsSM.Draft.NullEdge.PinnedSymmetryResolved
