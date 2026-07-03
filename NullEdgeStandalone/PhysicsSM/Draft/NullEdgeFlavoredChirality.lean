import Mathlib
import PhysicsSM.Draft.TetrahedralHighMomentumNullBranch

/-!
# Flavored chirality `Γ_f = Γ_s · T` and the high-momentum null-branch index (Gate C / C16)

This module turns the Wave 7 Gate C proposal (`AgentTasks__null-edge-c17-c18-gate-c-audit.md`,
§5, §9 targets `C18-1`/`C18-2`) into a concrete, kernel-checked finite theorem.

## Provenance and non-duplication

The *existence and classification* of the four high-momentum null branches is
already proven in stronger Lorentzian form in
`PhysicsSM__Draft__TetrahedralHighMomentumNullBranch.lean`
(`TetrahedralNullBranch.threePi_null`, `count_highMomentumNull = 4`,
`pSq_mink_eq_qform`).  **We do not duplicate that proof.**  We *reuse* it: the
taste index of `Γ_f` is exactly the species label of those four corners (the
position of the unique non-`π` edge), and `tasteCorner_high_momentum_null` ties
the taste index back to the already-proven null corners.

## The new content: a flavored chirality and its index

The audit (§4) records that ordinary spacetime chirality `Γ_s` is *blind* at
minimally-doubled / graph-native nodes: paired nodes of opposite `Γ_s` make the
naive index `tr(Γ_s P_null)` vanish (BCK 2501.10336 mirror cancellation), even
when a genuine species imbalance exists.  The cure (§5) is a **flavored
chirality**
```text
Γ_f := Γ_s · T,
```
where `T` is a **taste involution** on the four-corner species index.

We build the smallest faithful finite model that exhibits this phenomenon and
keeps the five gradings of the architecture **distinct** (Deliverable 5):

* `GammaS` — *spacetime* chirality `γ₅ ⊗ I_taste` (acts on the Dirac factor),
* `tasteT` — the *taste* involution `I_Dirac ⊗ τ` (acts on the species factor),
* `GammaF = GammaS * tasteT` — the flavored chirality,
* `chiE`   — the *internal* grading (a separate diagonal involution),
* `kdParity` — the Kähler–Dirac *cochain-degree* parity,
* `kreinJ` — the *Krein* metric used for retarded/advanced doubling.

The carrier is the finite tensor space `Fin 4 × Fin 4 = (Dirac) × (taste)`.

## Model input vs theorem (honest scope)

The *sign patterns* `g5`, `tau`, and the null-mode selector `Pnull` are model
inputs realizing the BCK minimally-doubled scenario: the four corners pair into
two `+` and two `−` spacetime-chirality modes (so the naive index cancels),
while the taste involution is aligned with the chirality grading (so the
flavored index does not).  Given those explicit matrices, the index identities
are kernel-checked finite facts, exactly as the audit anticipated ("the `Γ_f`
index theorems become finite `decide` facts once `Γ_f` is given as an explicit
matrix").  Which physical sign pattern is forced on the *full* operator is the
remaining blocker recorded in the module docstring conclusion below.

## Conclusion for Gate C

`naive_index_zero` together with `flavored_index_ne_zero` is the finite witness
of the audit's §10 verdict: a `Γ_s`-only "index `= 0`, therefore no doubling"
argument is rejectable, because the flavored index is nonzero on the very same
null set.  Hence **Gate C remains a genuine kill switch**: release of the four
high-momentum null branches requires the flavored index / Krein-residue data,
not the naive chirality index.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeFlavoredChirality

open Matrix

/-! ## Sign patterns (model inputs) -/

/-- Spacetime chirality eigenvalue `γ₅ = diag(1,1,-1,-1)` on the Dirac factor. -/
def g5 (d : Fin 4) : ℝ := if d.val < 2 then 1 else -1

/-- Taste involution eigenvalue `τ = diag(1,1,-1,-1)` on the species factor,
aligned with `g5` so the flavored index does not cancel. -/
def tau (a : Fin 4) : ℝ := if a.val < 2 then 1 else -1

/-- Internal grading eigenvalue `χ_E = diag(1,-1,1,-1)` on the Dirac factor:
a *distinct* involution (even/odd component), not equal to `g5`. -/
def chiEsign (d : Fin 4) : ℝ := if d.val % 2 = 0 then 1 else -1

/-! ## The five distinct gradings on `(Dirac) × (taste) = Fin 4 × Fin 4` -/

abbrev Idx := Fin 4 × Fin 4
abbrev RMat := Matrix Idx Idx ℝ

/-- Spacetime chirality `Γ_s = γ₅ ⊗ I_taste`. -/
def GammaS : RMat := Matrix.diagonal (fun p => g5 p.1)

/-- Taste involution `T = I_Dirac ⊗ τ`. -/
def tasteT : RMat := Matrix.diagonal (fun p => tau p.2)

/-- Flavored chirality `Γ_f = γ₅ ⊗ τ`. -/
def GammaF : RMat := Matrix.diagonal (fun p => g5 p.1 * tau p.2)

/-- Internal grading `χ_E = (diag(1,-1,1,-1)) ⊗ I_taste`, distinct from all the
chirality operators. -/
def chiE : RMat := Matrix.diagonal (fun p => chiEsign p.1)

/-- Kähler–Dirac cochain-degree parity `(-1)^deg`, modeled here on the taste
factor as a distinct involution `diag(1,-1,-1,1)`. -/
def kdParity : RMat := Matrix.diagonal (fun p => if p.2.val = 0 ∨ p.2.val = 3 then 1 else -1)

/-- Krein metric `J = I_Dirac ⊗ diag(1,-1,1,-1)` used for retarded/advanced
doubling; a distinct involution. -/
def kreinJ : RMat := Matrix.diagonal (fun p => if p.2.val % 2 = 0 then 1 else -1)

/-- The null-branch projector `P_null`: for each taste corner `a` it selects the
single Dirac component `d = a`, i.e. the would-be zero mode of that corner.  This
realizes the minimally-doubled pairing: corners `a = 0,1` carry `γ₅ = +1`,
corners `a = 2,3` carry `γ₅ = -1`. -/
def Pnull : RMat := Matrix.diagonal (fun p => if p.1 = p.2 then (1 : ℝ) else 0)

/-! ## `Γ_f = Γ_s · T` and involutivity -/

/-
The flavored chirality is the product of spacetime chirality and the taste
involution: `Γ_f = Γ_s · T`.
-/
theorem GammaF_eq_GammaS_mul_tasteT : GammaF = GammaS * tasteT := by
  convert Matrix.ext _;
  intro i j; by_cases hi : i = j <;> simp +decide [ hi, GammaF, GammaS, tasteT ] ;

/-
`Γ_s² = 1`.
-/
theorem GammaS_involutive : GammaS * GammaS = 1 := by
  ext i j; by_cases hi : i = j <;> simp +decide [ hi, GammaS ] ; fin_cases j <;> simp +decide [ g5 ] ;
  all_goals subst hi; rfl;

/-
`T² = 1`.
-/
theorem tasteT_involutive : tasteT * tasteT = 1 := by
  ext i j;
  -- By definition of `tasteT`, we know that it is a diagonal matrix with entries ±1.
  simp [tasteT, Matrix.mul_apply, Matrix.diagonal];
  unfold tau; aesop;

/-
`Γ_f² = 1` (target `C18-1`).
-/
theorem GammaF_involutive : GammaF * GammaF = 1 := by
  ext i j ; by_cases hi : i = j <;> simp +decide [ hi, GammaF ] ;
  fin_cases j <;> simp +decide [ g5, tau ] at hi ⊢;
  all_goals subst hi; rfl;

/-
Spacetime chirality and taste commute (they act on different factors).
-/
theorem GammaS_tasteT_comm : GammaS * tasteT = tasteT * GammaS := by
  unfold GammaS tasteT; ext i j; by_cases hi : i = j <;> simp +decide [ hi ] ; ring;

/-
The flavored chirality commutes with the internal grading `χ_E`
(distinct gradings on distinct factors).
-/
theorem GammaF_chiE_comm : GammaF * chiE = chiE * GammaF := by
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; simp +decide [ GammaF, chiE ];
  by_cases hij : i = k <;> by_cases hjl : j = l <;> simp +decide [ hij, hjl ];
  ring

/-! ## Distinctness of the five gradings (Deliverable 5) -/

/-
Spacetime chirality and taste are different operators.
-/
theorem GammaS_ne_tasteT : GammaS ≠ tasteT := by
  intro h; have := congrFun ( congrFun h ( 0, 2 ) ) ( 0, 2 ) ; simp +decide [ GammaS, tasteT, g5, tau, Matrix.diagonal ] at this;
  norm_num at this

/-
The flavored chirality is not the internal grading.
-/
theorem GammaF_ne_chiE : GammaF ≠ chiE := by
  intro h; have := congr_fun ( congr_fun h ( 0, 0 ) ) ; norm_num [ GammaF, chiE, g5, tau, chiEsign, Matrix.diagonal ] at this;
  have := congr_fun ( congr_fun h ( 1, 1 ) ) ; norm_num [ GammaF, chiE, g5, tau, chiEsign, Matrix.diagonal ] at this;
  exact absurd ( this 1 1 ) ( by norm_num )

/-
The flavored chirality is not the cochain-degree parity.
-/
theorem GammaF_ne_kdParity : GammaF ≠ kdParity := by
  -- By definition of GammaF and kdParity, we can see that they are not equal by comparing their entries.
  intro h_eq
  have := congr_fun (congr_fun h_eq (0, 1)) (0, 1)
  simp [GammaF, kdParity, g5, tau] at this;
  norm_num at this

/-
Spacetime chirality is not the Krein metric.
-/
theorem GammaS_ne_kreinJ : GammaS ≠ kreinJ := by
  intro h; have := congr_fun ( congr_fun h ( 0, 1 ) ) ( 0, 1 ) ; norm_num at this;
  unfold GammaS kreinJ at this ; norm_num at this;
  unfold g5 at this ; norm_num at this

/-! ## The decisive index theorems (targets `C18-2`) -/

/-
**Naive chirality is blind.**  The ordinary spacetime-chirality index
`tr(Γ_s P_null)` vanishes by mirror cancellation: the four null corners pair
into two `γ₅ = +1` and two `γ₅ = -1` modes.
-/
theorem naive_index_zero : (GammaS * Pnull).trace = 0 := by
  unfold GammaS Pnull;
  unfold g5; norm_num [ Fin.sum_univ_four, Matrix.trace ] ;
  norm_cast

/-
**Flavored chirality is not blind.**  The flavored index
`tr(Γ_f P_null) = 4 ≠ 0`: the taste involution realigns the signs so the four
null modes contribute coherently, exposing the species imbalance invisible to
`Γ_s`.
-/
theorem flavored_index_eq_four : (GammaF * Pnull).trace = 4 := by
  unfold GammaF Pnull;
  simp +decide [ Matrix.trace, g5, tau ];
  norm_cast

/-
The flavored index is nonzero.
-/
theorem flavored_index_ne_zero : (GammaF * Pnull).trace ≠ 0 := by
  convert flavored_index_eq_four.symm ▸ show ( 4 : ℝ ) ≠ 0 by norm_num

/-- **Gate C release-criterion witness.**  On the four high-momentum null
branches the naive chirality index is zero while the flavored chirality index is
nonzero.  Therefore a `Γ_s`-only "index `= 0` ⇒ no doubling" argument is
invalid, and Gate C cannot be released by the naive index alone. -/
theorem gateC_naive_blind_flavored_sees :
    (GammaS * Pnull).trace = 0 ∧ (GammaF * Pnull).trace ≠ 0 :=
  ⟨naive_index_zero, flavored_index_ne_zero⟩

/-! ## Linkage to the already-proven high-momentum null corners

The taste index `a : Fin 4` of `Γ_f` is the species label of the four
high-momentum null corners: corner `a` is the `{0,π}^4` corner whose unique
non-`π` (`0`) edge is at position `a`.  We reuse — not re-prove — the Lorentzian
classification from `TetrahedralHighMomentumNullBranch`. -/

open PhysicsSM.Draft.TetrahedralNullBranch in
/-- The `{0,π}^4` corner attached to taste index `a`: all edges are `π` except
edge `a`. -/
def tasteCorner (a : Fin 4) : Fin 4 → Bool := fun b => decide (b ≠ a)

open PhysicsSM.Draft.TetrahedralNullBranch in
/-- Each taste corner has exactly three `π` edges. -/
theorem tasteCorner_count (a : Fin 4) : cornerCount (tasteCorner a) = 3 := by
  fin_cases a <;> rfl

open PhysicsSM.Draft.TetrahedralNullBranch in
/-- **Linkage.**  Each taste index `a` labels a genuine high-momentum null
branch: the Lorentzian quadratic form vanishes while the retarded symbol vector
is nonzero.  This reuses `threePi_null` from the existing branch file. -/
theorem tasteCorner_high_momentum_null (a : Fin 4) :
    qform (cornerU (tasteCorner a)) = 0 ∧ cornerU (tasteCorner a) ≠ 0 :=
  threePi_null (tasteCorner a) (tasteCorner_count a)

end PhysicsSM.Draft.NullEdgeFlavoredChirality
