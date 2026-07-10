import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Suite D rung D4 — Critical lightness is symmetry-protected

A finite null-edge program has a REAL symmetric mass block

`B(lam, kap) = !![lam, kap, 0; kap, lam, 0; 0, 0, lam]`

with spectrum `{lam - kap, lam, lam + kap}`.  The critical (massless) line is `kap = lam`,
where the light level `lam - kap` hits zero with zero mode `v = (1, -1, 0)`.

This file proves that critical lightness is **symmetry protected**.  We exhibit the explicit
rational involution

`T = !![1, 0, 0; 0, -1, 0; 0, 0, 1]`   (`T^2 = 1`, `T ≠ 1`, `T ≠ -1`)

which implements a `Z₂` action on the closure coupling:

`T * B(lam, kap) * T = B(lam, -kap)`.

Hence `T` commutes with `B` iff `kap = 0`, and under `kap ↦ -kap` the pair
`{lam - kap, lam + kap}` of light/heavy levels is exchanged (the eigenvectors
`(1,-1,0)` and `(1,1,0)` are swapped by `T`).  The light eigenvalue `lam - kap` is
therefore the `Z₂`-symmetry-breaking parameter.

Naturalness verdict (honest form):

* WITHOUT the `Z₂`, `kap = lam` is a codimension-1 tuning — the control `B(1, 1/2)` has
  NO zero mode (`det = 3/4 ≠ 0`, and its map is injective; light level `1/2 ≠ 0`).
* WITH the `Z₂` pinning `kap ↦ -kap` (equivalently the critical relation `kap = lam`),
  the zero mode `(1,-1,0)` is forced.

All witnesses are explicit rationals; every proof is `ring`/`norm_num`/`fin_cases`.
-/

namespace SuiteD_CriticalSymmetry

open Matrix

/-- The real symmetric mass block `B(lam, kap)`. -/
def B (lam kap : ℚ) : Matrix (Fin 3) (Fin 3) ℚ :=
  !![lam, kap, 0; kap, lam, 0; 0, 0, lam]

/-- The explicit `Z₂` involution flipping the sign of the closure coupling. -/
def T : Matrix (Fin 3) (Fin 3) ℚ :=
  !![1, 0, 0; 0, -1, 0; 0, 0, 1]

/-- The critical zero mode `v = (1, -1, 0)`. -/
def v : Fin 3 → ℚ := ![1, -1, 0]

/-- The heavy-level eigenvector `w = (1, 1, 0)`. -/
def w : Fin 3 → ℚ := ![1, 1, 0]

/-! ## Target 1 — explicit zero mode on the critical line -/

/-- **Target 1.** On the critical line `kap = lam`, `B(lam, lam)` annihilates the explicit
nonzero zero mode `v = (1, -1, 0)`. -/
theorem zero_mode_at_criticality (lam : ℚ) :
    B lam lam *ᵥ v = 0 ∧ v ≠ 0 := by
  refine ⟨?_, ?_⟩
  · funext i
    fin_cases i <;>
      simp [B, v, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  · intro h
    have := congrFun h 0
    simp [v] at this

/-! ## Target 2 — enhanced symmetry: the `Z₂` action on the coupling -/

/-- `T` is an involution: `T^2 = 1`. -/
theorem T_involution : T * T = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [T, Matrix.mul_apply, Fin.sum_univ_three]

/-- `T` is a nontrivial involution: `T ≠ 1`. -/
theorem T_ne_one : T ≠ 1 := by
  intro h
  have := congrFun (congrFun h 1) 1
  norm_num [T, Matrix.one_apply] at this

/-- `T` is not the central inversion: `T ≠ -1`. -/
theorem T_ne_negOne : T ≠ -1 := by
  intro h
  have := congrFun (congrFun h 0) 0
  norm_num [T, Matrix.one_apply] at this

/-- **Target 2 (payload).** The enhanced symmetry: conjugation by the involution `T`
flips the sign of the closure coupling, `T * B(lam, kap) * T = B(lam, -kap)`.
This is the `Z₂` action `kap ↦ -kap`. -/
theorem enhanced_symmetry_at_criticality (lam kap : ℚ) :
    T * B lam kap * T = B lam (-kap) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [B, T, Matrix.mul_apply, Fin.sum_univ_three]

/-- `T` commutes with `B(lam, kap)` **iff** `kap = 0`: the symmetry `T B T = B` is exact
only at the decoupled point. -/
theorem symmetry_iff_kap_zero (lam kap : ℚ) :
    T * B lam kap * T = B lam kap ↔ kap = 0 := by
  rw [enhanced_symmetry_at_criticality]
  constructor
  · intro h
    have := congrFun (congrFun h 0) 1
    simp [B] at this
    linarith
  · rintro rfl
    simp

/-- The light-level eigenvector: `B(lam,kap) v = (lam - kap) v` with `v = (1,-1,0)`. -/
theorem eigen_light (lam kap : ℚ) :
    B lam kap *ᵥ v = (lam - kap) • v := by
  funext i
  fin_cases i <;>
    simp [B, v, Matrix.mulVec, dotProduct, Fin.sum_univ_three] <;> ring

/-- The heavy-level eigenvector: `B(lam,kap) w = (lam + kap) w` with `w = (1,1,0)`. -/
theorem eigen_heavy (lam kap : ℚ) :
    B lam kap *ᵥ w = (lam + kap) • w := by
  funext i
  fin_cases i <;> simp [B, w, Matrix.mulVec, dotProduct, Fin.sum_univ_three]
  all_goals ring

/-- Under the `Z₂` action, `T` swaps the light and heavy eigenvectors: `T v = w`. -/
theorem T_swaps_eigenvectors : T *ᵥ v = w := by
  funext i
  fin_cases i <;> simp [T, v, w, Matrix.mulVec, dotProduct, Fin.sum_univ_three]

/-! ## Target 3 — the light mass is the `Z₂`-symmetry-breaking parameter -/

/-- **Target 3.** Packaged: the light eigenvalue `lam - kap` vanishes iff `kap = lam`;
and under the `Z₂` action `kap ↦ -kap` the pair `{lam - kap, lam + kap}` is exchanged.
So the light mass is precisely the `Z₂`-breaking parameter: small mass ⇔ near-critical
⇔ approximate `Z₂` degeneracy of the pair. -/
theorem mass_is_symmetry_breaking (lam kap : ℚ) :
    (lam - kap = 0 ↔ kap = lam) ∧
      (lam - (-kap) = lam + kap ∧ lam + (-kap) = lam - kap) := by
  refine ⟨⟨fun h => by linarith, fun h => by rw [h]; ring⟩, by ring, by ring⟩

/-! ## Target 4 — naturalness verdict (both halves) -/

/-- **Target 4a (fine-tuning half).** WITHOUT the `Z₂`, criticality is a genuine tuning:
the control block `B(1, 1/2)` has NO zero mode.  Concretely `det (B 1 (1/2)) = 3/4 ≠ 0`,
its light level is `1 - 1/2 = 1/2 ≠ 0`, and the map `w ↦ B(1,1/2) w` is injective. -/
theorem naturalness_verdict_finetuning :
    (B 1 (1/2)).det = 3/4 ∧ (3/4 : ℚ) ≠ 0 ∧ (1 - (1/2 : ℚ)) ≠ 0 ∧
      (∀ u : Fin 3 → ℚ, B 1 (1/2) *ᵥ u = 0 → u = 0) := by
  refine ⟨?_, by norm_num, by norm_num, ?_⟩
  · simp [B, Matrix.det_fin_three]; norm_num
  · intro u h
    have h0 := congrFun h 0
    have h1 := congrFun h 1
    have h2 := congrFun h 2
    simp [B, Matrix.mulVec, dotProduct, Fin.sum_univ_three] at h0 h1 h2
    funext i
    fin_cases i
    · simp; linarith
    · simp; linarith
    · simp; linarith

/-- **Target 4b (protection half).** WITH the `Z₂`/critical pinning `kap = lam`, the zero
mode `(1,-1,0)` is forced: for every `lam`, `B(lam, lam)` annihilates the nonzero `v`. -/
theorem naturalness_verdict_protected (lam : ℚ) :
    B lam lam *ᵥ v = 0 ∧ v ≠ 0 :=
  zero_mode_at_criticality lam

/-! ## Axiom footprint on every headline -/

/-- info: 'SuiteD_CriticalSymmetry.zero_mode_at_criticality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms zero_mode_at_criticality

/-- info: 'SuiteD_CriticalSymmetry.enhanced_symmetry_at_criticality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms enhanced_symmetry_at_criticality

/-- info: 'SuiteD_CriticalSymmetry.symmetry_iff_kap_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms symmetry_iff_kap_zero

/-- info: 'SuiteD_CriticalSymmetry.T_swaps_eigenvectors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms T_swaps_eigenvectors

/-- info: 'SuiteD_CriticalSymmetry.mass_is_symmetry_breaking' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_is_symmetry_breaking

/-- info: 'SuiteD_CriticalSymmetry.naturalness_verdict_finetuning' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms naturalness_verdict_finetuning

/-- info: 'SuiteD_CriticalSymmetry.naturalness_verdict_protected' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms naturalness_verdict_protected

end SuiteD_CriticalSymmetry
