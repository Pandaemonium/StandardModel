import Mathlib
import PhysicsSM.Draft.NullEdgeFlavoredChirality

/-!
# Gate C release criterion: forcing the flavored-chirality signs from the operator (C19)

This module addresses the remaining Gate C blocker recorded in
`PhysicsSM/Draft/NullEdgeFlavoredChirality.lean` and in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` §23, §25.3:

> The current Gate C mechanism proves that a **modeled** flavor/taste sign `T`
> gives `tr(Γ_s P_null) = 0` and `tr(Γ_f P_null) = 4`.  The missing step is
> whether the **actual** flat tetrahedral null-edge operator *forces* the
> BCK / minimally-doubled aligned taste signs, rather than letting us choose
> them by hand.

## What is reused, not duplicated

* The four high-momentum null branches (`{0,π}^4` corners with exactly three
  `π` edges) and their Lorentzian classification come from
  `PhysicsSM.Draft.TetrahedralNullBranch` (`threePi_null`,
  `count_highMomentumNull = 4`).
* The finite five-grading model, the spacetime chirality `GammaS`, the null
  projector `Pnull`, the modeled taste involution `tasteT`/`tau`, and the naive
  vs. flavored index witnesses come from
  `PhysicsSM.Draft.NullEdgeFlavoredChirality`
  (`naive_index_zero`, `flavored_index_eq_four`).

## The new content: operator-forced taste signs (§25.3 formula)

Section 25.3 of the working plan prescribes the minimally-doubled flavored
chirality
```text
Γ_flav = Σ_ρ ε_ρ · P_ρ Γ_s P_ρ ,
```
where `P_ρ` are the per-branch null projectors and `ε_ρ` are signs **determined
by the operator** (the spacetime-chirality / Krein eigenvalue of the zero mode
on branch `ρ`), not chosen by hand.

Here we:

1. Decompose the modeled null projector into its four per-branch projectors
   (`Pnull_eq_sum_Pbranch`), one for each high-momentum null branch.
2. Build `GammaFlavOp s` from an abstract operator-sign vector `s : Fin 4 → ℝ`
   using exactly the §25.3 formula.
3. Reduce its index to the closed form `tr(GammaFlavOp s · P_null) = Σ_a s a · g5 a`
   (`flavoredOp_index`), so the index depends *only* on the operator branch
   signs `s`.
4. State the **release criterion** `Releases s` and prove the **conditional
   release theorem** `gateC_conditional_release`: if the operator's branch
   chirality is aligned, `s = g5`, then the naive index vanishes but the
   flavored index is `4 ≠ 0`.
5. Prove the **forcing / uniqueness theorem** `aligned_signs_forced`: among all
   `±1`-valued branch-sign assignments, the *coherent* release index `±4` is
   attained **iff** `s = ±g5`.  Thus the taste signs are not a free model
   choice: once the operator supplies `±1` branch chirality eigenvalues, a
   genuine (maximal) release forces them to coincide with `g5` up to a global
   sign.
6. Record that the existing hand-modeled taste involution already realizes this
   forced alignment (`model_taste_eq_chirality`, `model_realizes_alignment`),
   so the Wave-8 witness is the `s = g5` instance of the forced family.

## Honest scope (the residual operator-level obligation)

What is **proved** here: *given* operator branch signs `s`, the flavored index
is `Σ_a s a · g5 a`; release holds iff that sum is nonzero; and a maximal
coherent release forces `s = ±g5`.

What is **not** proved here, and is the precise remaining Gate C blocker
(`OperatorForcesAlignment`): that the actual flat tetrahedral null-edge Clifford
symbol `c(p(q))` assigns spacetime-chirality eigenvalue `g5 a` to the zero mode
on branch `a`.  Discharging that statement requires the Clifford symbol, its
per-branch kernel, and the chirality/Krein eigenvalue on each kernel — data not
present in the current Lean files (only the scalar quadratic form `qform` and
its null corners are).  `OperatorForcesAlignment` is stated below as the exact
hypothesis a future operator-level module must supply; `gateC_conditional_release`
shows it is sufficient, and `aligned_signs_forced` shows the alignment it asserts
is the only coherent possibility.

**Verdict (per §23.6 / §25.3 one-line verdict): PENDING on
`OperatorForcesAlignment`.**  The taste signs are forced *up to a global sign by
any ±1 operator branch chirality*, but the identification of that branch
chirality with `g5` is the open operator-level theorem.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGateCReleaseCriterion

open Matrix
open PhysicsSM.Draft.NullEdgeFlavoredChirality

/-! ## Per-branch null projectors -/

/-- The per-branch null projector `P_a`: the rank-one projector onto the diagonal
corner `(a, a)` of `Fin 4 × Fin 4`.  Branch `a` is the high-momentum null corner
whose unique non-`π` edge sits at position `a` (`tasteCorner a`). -/
def Pbranch (a : Fin 4) : RMat :=
  Matrix.diagonal (fun p => if p.1 = a ∧ p.2 = a then (1 : ℝ) else 0)

/-
The modeled null projector is the sum of the four per-branch projectors:
`P_null = Σ_a P_a`.
-/
theorem Pnull_eq_sum_Pbranch : Pnull = ∑ a, Pbranch a := by
  unfold Pnull Pbranch; ext i j; simp +decide [ Matrix.sum_apply, Matrix.diagonal_apply ] ;
  split_ifs <;> simp_all +decide [ Finset.filter_and ];
  · rw [ Finset.card_filter ] ; aesop;
  · rw [ Finset.card_eq_zero.mpr ] <;> aesop

/-! ## The operator-built flavored chirality `Γ_flav = Σ_a s a · P_a Γ_s P_a` -/

/-- The minimally-doubled flavored chirality built from **operator** branch signs
`s : Fin 4 → ℝ`, exactly the §25.3 formula `Γ_flav = Σ_ρ ε_ρ P_ρ Γ_s P_ρ`.
Here `s a = ε_a` is the chirality/Krein sign the operator assigns to branch `a`. -/
def GammaFlavOp (s : Fin 4 → ℝ) : RMat :=
  ∑ a, s a • (Pbranch a * GammaS * Pbranch a)

/-
Per-branch reduction: `P_a Γ_s P_a = g5 a • P_a` (the spacetime chirality is
diagonal, so it acts on branch `a` by the scalar `g5 a`).
-/
theorem Pbranch_GammaS_Pbranch (a : Fin 4) :
    Pbranch a * GammaS * Pbranch a = g5 a • Pbranch a := by
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; simp +decide [ Pbranch, GammaS ] ;
  simp +decide [ diagonal ];
  grind

/-
**Closed form of the operator flavored index.**  The flavored index depends
only on the operator branch signs `s`:
`tr(Γ_flav(s) · P_null) = Σ_a s a · g5 a`.
-/
theorem flavoredOp_index (s : Fin 4 → ℝ) :
    (GammaFlavOp s * Pnull).trace = ∑ a, s a * g5 a := by
  unfold GammaFlavOp Pnull;
  simp +decide [ Pbranch_GammaS_Pbranch, Matrix.trace, Finset.sum_mul ];
  simp +decide [ Matrix.sum_apply, Pbranch ];
  simp +decide [ Finset.sum_ite, Finset.filter_eq, Finset.filter_and ];
  refine' Finset.sum_bij ( fun x hx => x.1 ) _ _ _ _ <;> simp +decide

/-! ## Release criterion and conditional release -/

/-- **Gate C release criterion.**  The operator branch signs `s` *release* the
four high-momentum null branches when the naive spacetime-chirality index
vanishes while the operator-built flavored index does not. -/
def Releases (s : Fin 4 → ℝ) : Prop :=
  (GammaS * Pnull).trace = 0 ∧ (GammaFlavOp s * Pnull).trace ≠ 0

/-- The residual operator-level obligation (the precise remaining Gate C
blocker): the actual flat tetrahedral null-edge Clifford operator assigns
spacetime-chirality eigenvalue `g5 a` to the zero mode on branch `a`.  This is
the hypothesis a future operator module must discharge; it is *not* proved here. -/
def OperatorForcesAlignment (branchChirality : Fin 4 → ℝ) : Prop :=
  branchChirality = g5

/-
The aligned flavored index is `4`.
-/
theorem aligned_index_eq_four : (GammaFlavOp g5 * Pnull).trace = 4 := by
  rw [ flavoredOp_index ];
  norm_num [ Fin.sum_univ_four, g5 ]

/-
**Conditional Gate C release.**  If the operator forces the branch chirality
to be aligned (`branchChirality = g5`), then those branch signs release Gate C:
the naive index is `0` and the flavored index is `4 ≠ 0`.
-/
theorem gateC_conditional_release (bc : Fin 4 → ℝ)
    (h : OperatorForcesAlignment bc) : Releases bc := by
  -- Unfold OperatorForcesAlignment at h, so h : bc = g5; subst h. The goal Releases is Releases bc, which is Releases g5.
  unfold Releases OperatorForcesAlignment at *; subst h;
  exact ⟨ naive_index_zero, by rw [ aligned_index_eq_four ] ; norm_num ⟩

/-! ## Forcing / uniqueness: the coherent release signs are `±g5` -/

/-
**Forcing theorem.**  Among all `±1`-valued operator branch-sign assignments,
the *coherent / maximal* flavored release index `4` is attained **iff** the signs
coincide with the spacetime chirality, `s = g5`.  Hence the taste signs are not a
free model choice: a maximal release forces `s = g5`.
-/
theorem aligned_signs_forced (s : Fin 4 → ℝ) (hs : ∀ a, s a = 1 ∨ s a = -1) :
    (GammaFlavOp s * Pnull).trace = 4 ↔ s = g5 := by
  constructor;
  · rw [ flavoredOp_index ];
    intro h;
    ext a; fin_cases a <;> norm_num [ Fin.sum_univ_four, g5 ] at h ⊢ <;> cases hs 0 <;> cases hs 1 <;> cases hs 2 <;> cases hs 3 <;> simp_all +decide only ;
    all_goals norm_num at h; all_goals assumption;
  · exact fun h => h ▸ aligned_index_eq_four

/-
The mirror statement: the index is `-4` iff `s = -g5`.  Together with
`aligned_signs_forced` this shows the coherent release signs are exactly `±g5`.
-/
theorem antialigned_signs_forced (s : Fin 4 → ℝ) (hs : ∀ a, s a = 1 ∨ s a = -1) :
    (GammaFlavOp s * Pnull).trace = -4 ↔ s = fun a => -g5 a := by
  rw [ flavoredOp_index ];
  unfold g5 at *; simp_all +decide [ Fin.sum_univ_four ] ;
  grind

/-
The flavored release index is bounded in magnitude by `4` for `±1` branch
signs, with the bound saturated only by `±g5` (quantitative forcing).
-/
theorem flavoredOp_index_le_four (s : Fin 4 → ℝ) (hs : ∀ a, s a = 1 ∨ s a = -1) :
    |(GammaFlavOp s * Pnull).trace| ≤ 4 := by
  rw [ flavoredOp_index ];
  rw [ Finset.sum_congr rfl fun i hi => by rw [ show g5 i = if i.val < 2 then 1 else -1 from rfl ] ];
  rw [ Fin.sum_univ_four ] ; rcases hs 0 with ha | ha <;> rcases hs 1 with hb | hb <;> rcases hs 2 with hc | hc <;> rcases hs 3 with hd | hd <;> norm_num [ ha, hb, hc, hd ]

/-! ## The existing hand-model is the `s = g5` instance of the forced family -/

/-
The hand-modeled taste involution sign `tau` of
`NullEdgeFlavoredChirality` coincides with the spacetime chirality `g5`: the
Wave-8 model already chose the operator-forced alignment.
-/
theorem model_taste_eq_chirality : tau = g5 := by
  funext a; fin_cases a <;> rfl;

/-
The hand-modeled flavored chirality realizes the forced alignment: its index
equals the operator-built aligned index, both `4`.
-/
theorem model_realizes_alignment :
    (GammaF * Pnull).trace = (GammaFlavOp g5 * Pnull).trace := by
  rw [PhysicsSM.Draft.NullEdgeFlavoredChirality.flavored_index_eq_four, aligned_index_eq_four]

/-- **Summary release statement (conditional).**  Modulo the single operator-level
obligation `OperatorForcesAlignment`, Gate C is released by branch signs that are
forced — up to a global sign — by any `±1` operator branch chirality:

* the naive index vanishes (`naive_index_zero`);
* under the forced alignment the flavored index is `4 ≠ 0`
  (`gateC_conditional_release`);
* and any maximal `±1` release necessarily uses `s = ±g5`
  (`aligned_signs_forced`, `antialigned_signs_forced`).
-/
theorem gateC_release_conditional_summary :
    (∀ bc, OperatorForcesAlignment bc → Releases bc) ∧
    (∀ s, (∀ a, s a = 1 ∨ s a = -1) →
      ((GammaFlavOp s * Pnull).trace = 4 ↔ s = g5)) := by
  exact ⟨gateC_conditional_release, aligned_signs_forced⟩

end PhysicsSM.Draft.NullEdgeGateCReleaseCriterion
