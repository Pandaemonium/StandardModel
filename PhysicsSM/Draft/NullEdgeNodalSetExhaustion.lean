import Mathlib
import PhysicsSM.Draft.TetrahedralHighMomentumNullBranch
import PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet
import PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine
import PhysicsSM.Draft.NullEdgeProjectedGateCRelease

/-!
# C64: Full nodal-set exhaustion audit for the tetrahedral bare/split symbol

Aristotle Gate C Route B deliverable.

## Background

* `NullEdgeSpectralGraphNodalSet` (C43/C44) proved that each high branch lies on
  an **exact** one-parameter determinant-zero curve `branchLineU a t`
  (`q_a = 0`, `q_b = π + t`), with `t = 0` the three-`π` corner and `t = π` the
  origin.  These four curves, together with the origin `u = 0`, are the
  *certified* nodal components.
* `NullEdgeSpeciesSplitNodalLine` (C60) proved that the modeled species-splitting
  term `M_split = r · T_lin`, with the literature pattern `g5 = (+,+,−,−)`, is
  nonzero everywhere on each branch line except the origin endpoint — i.e. it
  *gaps the four certified branch curves away from the origin*.

The **open question** (this task): do the certified components — the origin and
the four branch lines — *exhaust* the scalar determinant-zero locus
`{ q : 𝕋⁴ | qform (phaseU q) = 0 }`?  And does the species-split term `M_split`
control (gap) the *whole* zero locus, not merely the four certified curves?

## Verdict: exhaustion is FALSE, and the split does not control the full locus

The honest answer is **negative on both counts**, witnessed by one explicit,
fully kernel-checked nodal point

```text
q⋆ = (2π/3, 0, 0, 4π/3),   u⋆ = phaseU q⋆ = (ω−1, 0, 0, ω²−1),
```

where `ω = exp(2πi/3)` is a primitive cube root of unity (`ω² + ω + 1 = 0`).

* `extra_qform_zero` / `extra_mink_zero`: `q⋆` is a genuine scalar *and*
  Lorentzian (Clifford-determinant) nodal point: `qform u⋆ = 0` and
  `mink (pCov u⋆) = 0`.
* `extra_ne_origin`: `u⋆ ≠ 0` (its `0`-component is `ω − 1 ≠ 0`).
* `extra_not_on_branchLine`: `u⋆` lies on **none** of the four certified branch
  lines.  (A branch line has *exactly one* vanishing component; `u⋆` has *two*
  vanishing components — edges `1` and `2` — and two distinct nonzero ones.)
* `exhaustion_false` (**main obstruction**): the certified components do not
  exhaust the zero locus.
* `extra_Tlin_g5_zero` / `extra_Msplit_g5_zero`: the modeled species-splitting
  term `M_split = r · T_lin` with the `g5` pattern **vanishes** at `q⋆` for every
  coefficient `r` — so the lift of C60 does *not* gap this off-branch nodal
  point.
* `g5_split_not_full_nodal_control` (**split obstruction**): hence `M_split[g5]`
  does not gap the full determinant-zero locus, only the four certified branch
  curves.

## Distinguished zero notions (kept separate, per the task)

* **scalar q-form zero** — `qform (phaseU q) = 0`;
* **full Clifford-symbol determinant zero** — `mink (pCov (phaseU q)) = 0`, which
  equals the scalar form via `pSq_mink_eq_qform` (the `4`-component null slash has
  `det D ∝ (p²)²`, same locus);
* **projected physical-sector zero** — the zero of the operator *after* the
  species/Krein/Weyl projection of C21/C59; this is a strictly smaller locus and
  is **not** the object classified here.

## Alignment with the C59 projected Gate C release API

This module is stated against
`PhysicsSM.Draft.NullEdgeProjectedGateCRelease` (the seven-clause release API).
The clause it speaks to is **Clause 1, `NodalSetControlled`**
(`∀ a, 0 < d.nodalGap a`), whose `nodalGap : Fin 4 → ℝ` data is indexed by the
*four branches only*.

* `nodalSetControlled_does_not_imply_full_control` (the reported result): there
  is a dataset satisfying `NodalSetControlled` whose underlying symbol
  nevertheless has an off-branch determinant-zero point that the `g5`
  species-split term does not gap.  So **Clause 1, as currently scoped to the
  four branches, is not enough to certify control of the full nodal set** — it is
  exactly the clause that remains *blocked* for the bare/split tetrahedral
  symbol.

The remaining six clauses are untouched by this audit; this report blocks only
Clause 1 (and only in its *faithful, full-locus* reading — the literal
four-branch predicate is of course still satisfiable, which is the content of the
guardrail).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeNodalSetExhaustion

open Complex
open PhysicsSM.Draft.TetrahedralNullBranch (qform qform_eq pCov mink pSq_mink_eq_qform)
open PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet (phaseU branchLineU branchLineU_apply)

/-! ## The extra nodal point `q⋆ = (2π/3, 0, 0, 4π/3)` -/

/-- The off-branch nodal phase vector `q⋆ = (2π/3, 0, 0, 4π/3)`.  Its retarded
phase vector is `u⋆ = (ω−1, 0, 0, ω²−1)` with `ω = exp(2πi/3)` a primitive cube
root of unity. -/
def extraPhase : Fin 4 → ℝ := ![2 * Real.pi / 3, 0, 0, 4 * Real.pi / 3]

/-- Component values of `u⋆ = phaseU extraPhase`. -/
theorem extraPhase_phaseU_apply :
    phaseU extraPhase =
      ![Complex.exp (Complex.I * ((2 * Real.pi / 3 : ℝ) : ℂ)) - 1, 0, 0,
        Complex.exp (Complex.I * ((4 * Real.pi / 3 : ℝ) : ℂ)) - 1] := by
  funext a
  fin_cases a <;>
    simp [phaseU, extraPhase] <;>
    simp [Complex.exp_eq_one_iff]

/-! ## `q⋆` is a scalar and Clifford-determinant nodal point -/

/-
**Scalar q-form zero at `q⋆`.**  `qform u⋆ = 0`: the explicit point is a
genuine zero of the scalar Lorentzian symbol square `p(q)²`.

Mechanism: with `ω = exp(2πi/3)` (so `ω³ = 1`, `ω² + ω + 1 = 0`),
`u⋆ = (ω−1, 0, 0, ω²−1)`, hence `Σ u⋆ = ω + ω² − 2 = −3`, `(Σ u⋆)² = 9`, and
`Σ u⋆² = (ω−1)² + (ω²−1)² = 3`, so `qform u⋆ = −¾·3 + ¼·9 = 0`.
-/
theorem extra_qform_zero : qform (phaseU extraPhase) = 0 := by
  norm_num [ qform_eq, extraPhase ];
  norm_num [ Fin.sum_univ_succ, phaseU ] ; ring_nf;
  norm_num [ Complex.ext_iff, sq, Complex.exp_re, Complex.exp_im, ( by ring : Real.pi * ( 2 / 3 ) = Real.pi - Real.pi / 3 ), ( by ring : Real.pi * ( 4 / 3 ) = Real.pi + Real.pi / 3 ), Real.cos_add, Real.sin_add ] ; ring_nf ; norm_num

/-- **Full Clifford-symbol determinant zero at `q⋆`.**  The mostly-minus
Minkowski square of the spacetime symbol covector vanishes, `mink (pCov u⋆) = 0`
(via `pSq_mink_eq_qform`).  So `q⋆` is a zero of the full null-slash determinant,
not merely a scalar coincidence. -/
theorem extra_mink_zero : mink (pCov (phaseU extraPhase)) = 0 := by
  rw [pSq_mink_eq_qform]; exact extra_qform_zero

/-! ## `q⋆` is off every certified component -/

/-
The `0`-component of `u⋆` is `ω − 1 ≠ 0`, so `u⋆ ≠ 0`: `q⋆` is not the origin
component.
-/
theorem extra_ne_origin : phaseU extraPhase ≠ 0 := by
  unfold phaseU extraPhase;
  norm_num [ funext_iff, Complex.ext_iff, Complex.exp_re, Complex.exp_im ];
  exact ⟨ 0, by norm_num [ Real.cos_two_mul, Real.sin_two_mul, mul_div_assoc ] ⟩

/-- The `1`- and `2`-components of `u⋆` vanish. -/
theorem extra_comp1_zero : phaseU extraPhase 1 = 0 := by
  rw [extraPhase_phaseU_apply]; rfl

theorem extra_comp2_zero : phaseU extraPhase 2 = 0 := by
  rw [extraPhase_phaseU_apply]; rfl

/-
**`q⋆` is on no certified branch line.**  A branch line `branchLineU a t` has
*exactly one* vanishing component (the distinguished edge `a`), or is the origin
(when the common value vanishes).  But `u⋆` has *two* vanishing components (edges
`1` and `2`) and is nonzero, so it cannot equal any `branchLineU a t`.
-/
theorem extra_not_on_branchLine :
    ∀ (a : Fin 4) (t : ℝ), phaseU extraPhase ≠ branchLineU a t := by
  intros a t h;
  -- By `extra_comp1_zero : phaseU extraPhase 1 = 0` and `extra_comp2_zero : phaseU extraPhase 2 = 0`, we know that `branchLineU a t 1 = 0` and `branchLineU a t 2 = 0`.
  have h_branchLineU_zero : branchLineU a t 1 = 0 ∧ branchLineU a t 2 = 0 := by
    exact ⟨ h ▸ extra_comp1_zero, h ▸ extra_comp2_zero ⟩;
  -- By `extra_comp1_zero : phaseU extraPhase 1 = 0` and `extra_comp2_zero : phaseU extraPhase 2 = 0`, we know that `branchLineU a t = 0`.
  have h_branchLineU_zero : branchLineU a t = 0 := by
    fin_cases a <;> simp_all +decide [ branchLineU_apply ]; all_goals ext b; fin_cases b <;> simp_all +decide [ branchLineU_apply ] ;
  exact absurd h ( by rw [ h_branchLineU_zero ] ; exact extra_ne_origin )

/-! ## Main obstruction: the certified components do not exhaust the zero locus -/

/-- **Exhaustion is FALSE.**  There is a determinant-zero point of the bare
tetrahedral symbol that is neither the origin component nor any of the four
certified branch-line components.  Hence the certified nodal components proved in
C43/C44 do **not** exhaust the scalar (equivalently Clifford-determinant) zero
locus. -/
theorem exhaustion_false :
    ∃ q : Fin 4 → ℝ,
      qform (phaseU q) = 0 ∧
      mink (pCov (phaseU q)) = 0 ∧
      phaseU q ≠ 0 ∧
      (∀ (a : Fin 4) (t : ℝ), phaseU q ≠ branchLineU a t) :=
  ⟨extraPhase, extra_qform_zero, extra_mink_zero, extra_ne_origin,
    extra_not_on_branchLine⟩

/-! ## The species-split term does not control the off-branch zero -/

open PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine (Tlin Msplit)

/-
**`T_lin[g5]` vanishes at `q⋆`.**  With `g5 = (+,+,−,−)`,
`T_lin(q⋆) = ½(cos(2π/3) + cos 0 − cos 0 − cos(4π/3)) = ½(−½ + 1 − 1 + ½) = 0`,
because `cos(2π/3) = cos(4π/3) = −½`.
-/
theorem extra_Tlin_g5_zero :
    Tlin PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine.g5 extraPhase = 0 := by
  unfold Tlin NullEdgeSpeciesSplitNodalLine.g5 extraPhase;
  norm_num [ Fin.sum_univ_succ, show 2 * Real.pi / 3 = Real.pi - Real.pi / 3 by ring, show 4 * Real.pi / 3 = Real.pi + Real.pi / 3 by ring, Real.cos_add, Real.cos_sub ]

/-- **`M_split[g5]` vanishes at `q⋆` for every coefficient `r`.**  The modeled
species-splitting mass term is `r · T_lin`, so it inherits the vanishing of
`T_lin[g5]` at `q⋆`.  The C60 lift therefore does *not* gap this off-branch nodal
point. -/
theorem extra_Msplit_g5_zero (r : ℝ) :
    Msplit r PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine.g5 extraPhase = 0 := by
  unfold Msplit
  rw [extra_Tlin_g5_zero, mul_zero]

/-- The faithful "full nodal-set control" predicate: the species-split term gaps
**every** scalar determinant-zero point (not merely the four certified branch
curves). -/
def FullNodalControlBySplit (r : ℝ) (s : Fin 4 → ℝ) : Prop :=
  ∀ q : Fin 4 → ℝ, qform (phaseU q) = 0 → Msplit r s q ≠ 0

/-- **Split obstruction.**  For every coefficient `r`, the `g5` species-split
term does **not** control the full nodal set: `q⋆` is a scalar determinant-zero
point at which `M_split[g5]` vanishes.  (Contrast C60: it *does* gap the four
certified branch curves away from the origin.) -/
theorem g5_split_not_full_nodal_control (r : ℝ) :
    ¬ FullNodalControlBySplit r PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine.g5 := by
  intro h
  exact h extraPhase extra_qform_zero (extra_Msplit_g5_zero r)

/-! ## Alignment with the C59 projected Gate C release API (Clause 1) -/

open PhysicsSM.Draft.NullEdgeProjectedGateCRelease (ProjData NodalSetControlled releasedData)

/-- **Reported blocked clause — Clause 1 (`NodalSetControlled`).**  The C59
release predicate's nodal clause `NodalSetControlled d := ∀ a, 0 < d.nodalGap a`
is indexed by the four branches only.  This is satisfiable (e.g. by
`releasedData`), yet the underlying bare/split tetrahedral symbol has an
off-branch determinant-zero point `q⋆` that the `g5` species-split term does not
gap.  Therefore the literal four-branch clause does *not* certify control of the
*full* nodal set: Clause 1, in its faithful full-locus reading, remains blocked
for the bare/split symbol. -/
theorem nodalSetControlled_does_not_imply_full_control :
    ∃ d : ProjData,
      NodalSetControlled d ∧
      ∃ q : Fin 4 → ℝ,
        qform (phaseU q) = 0 ∧
        phaseU q ≠ 0 ∧
        (∀ (a : Fin 4) (t : ℝ), phaseU q ≠ branchLineU a t) ∧
        (∀ r : ℝ,
          Msplit r PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine.g5 q = 0) := by
  refine ⟨releasedData, ?_, extraPhase, extra_qform_zero, extra_ne_origin,
    extra_not_on_branchLine, extra_Msplit_g5_zero⟩
  intro a; simp [releasedData]

/-! ## Summary -/

/-- **C64 exhaustion-audit summary.**

1. the certified components (origin + four branch lines) do **not** exhaust the
   determinant-zero locus (`exhaustion_false`), witnessed by the explicit
   off-branch nodal point `q⋆ = (2π/3, 0, 0, 4π/3)`;
2. that point is a genuine scalar **and** Clifford-determinant zero
   (`extra_qform_zero`, `extra_mink_zero`), is nonzero, and lies on no branch
   line (`extra_ne_origin`, `extra_not_on_branchLine`);
3. the `g5` species-split term of C60 does **not** gap it
   (`extra_Msplit_g5_zero`), so it does not control the full nodal set
   (`g5_split_not_full_nodal_control`);
4. consequently the C59 release Clause 1 `NodalSetControlled` (four-branch gap)
   does not certify full nodal control
   (`nodalSetControlled_does_not_imply_full_control`) — the reported blocked
   clause. -/
theorem c64_exhaustion_summary :
    (∃ q : Fin 4 → ℝ,
      qform (phaseU q) = 0 ∧ mink (pCov (phaseU q)) = 0 ∧ phaseU q ≠ 0 ∧
        (∀ (a : Fin 4) (t : ℝ), phaseU q ≠ branchLineU a t)) ∧
    (∀ r : ℝ,
      ¬ FullNodalControlBySplit r PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine.g5) ∧
    (∃ d : ProjData, NodalSetControlled d ∧
      ∃ q : Fin 4 → ℝ,
        qform (phaseU q) = 0 ∧ phaseU q ≠ 0 ∧
          (∀ (a : Fin 4) (t : ℝ), phaseU q ≠ branchLineU a t) ∧
          (∀ r : ℝ,
            Msplit r PhysicsSM.Draft.NullEdgeSpeciesSplitNodalLine.g5 q = 0)) :=
  ⟨exhaustion_false, g5_split_not_full_nodal_control,
    nodalSetControlled_does_not_imply_full_control⟩

end PhysicsSM.Draft.NullEdgeNodalSetExhaustion
