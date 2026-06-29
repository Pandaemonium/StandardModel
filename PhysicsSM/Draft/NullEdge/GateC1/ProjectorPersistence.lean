/-
# C202 maintained spectral-island projector persistence

Local Draft promotion copied from Aristotle output on 2026-06-28.
Source artifact: AgentTasks/aristotle-output/c3f8e471-46ec-49dd-80e4-e74d6c125ded/extracted/e7cdc0ae-3bf9-49df-b6c9-2588b3951642_aristotle/RequestProject/GateC1.lean

Status: Draft artifact, locally checked and targeted-built on 2026-06-28.
Claim boundary: this is not a proof of full GateC1_NU.
-/

import Mathlib

/-!
# Gate C1 — branch-line lift of the physical (Riesz) projector

This file provides a **Lean-facing abstraction** for the persistence of the *physical
projector* of Gate C1 under a maintained spectral gap, after the free-reference sign
split.

Informally the physical projector is the Riesz / spectral-island projector

```
Pi_phys(q) = (1 / 2πi) ∮_C (z - H_ne(q))⁻¹ dz
```

where `C` is a contour enclosing the *physical spectral island* and `H_ne(q)` is the
null-edge endpoint operator at parameter `q`.

The deliverable deliberately **separates two kinds of fact**:

* *Finite-dimensional matrix / operator facts* (Section 1–2): trace = rank for an
  idempotent, local constancy of the rank of a continuous family of idempotents, and
  the chiral index as a difference of two ranks.  These are proved here, in full, with
  no complex integration.

* *Analytic contour-integration facts* (Section 3, the `MaintainedIsland` record):
  that a maintained spectral gap turns the resolvent contour integral into a
  **continuous (indeed analytic) family of idempotents** commuting with `H_ne`.  This
  is exactly the data that the actual null-edge endpoint must supply; here it is taken
  as a hypothesis (`Pcont`), so that the persistence theorem does not depend on any
  heavy integration machinery.

The two key user-facing predicates are:

* `SpectralIslandSeparated H physIsland gap` — the spectral island stays separated by
  `gap` and a genuine idempotent Riesz projector exists for it;
* `ProjectorRankStable P` — the projector rank is locally constant in `q`;
* `ChiralIndexStable Γ P` — the chiral index `tr (Γ · P)` is locally constant in `q`.

**Scope warning (success criterion).**  The branch-line lift proved here is *only* the
statement that the physical projector persists *because the spectral island stays
separated*.  It is **not** a proof of the mass window, and persistence here is obtained
from a maintained gap, never from a mirror branch being replaced by a propagator zero.
See `Section 5` for the no-go examples that make this distinction precise.
-/

open scoped BigOperators
open Matrix

namespace GateC1

variable {n : Type*} [Fintype n] [DecidableEq n]
variable {Q : Type*} [TopologicalSpace Q]

/-! ## Section 1.  Finite-dimensional / operator facts: trace, rank, persistence. -/

/-- **Core operator fact.**  The (complex-cast) rank of an idempotent matrix equals its
trace.  This is the algebraic substitute for "a projector's rank is read off its trace"
and is what makes the rank an *integer* invariant that contour integration cannot move
continuously. -/
theorem trace_eq_rank_of_idem (P : Matrix n n ℂ) (hP : IsIdempotentElem P) :
    (P.rank : ℂ) = P.trace := by
  have hproj : LinearMap.IsProj (LinearMap.range (toLin' P)) (toLin' P) := by
    refine ⟨fun x => LinearMap.mem_range_self _ x, ?_⟩
    intro x hx; obtain ⟨y, rfl⟩ := hx; rw [← Matrix.toLin'_mul_apply, hP]
  have htr := hproj.trace
  rw [Matrix.trace_toLin'_eq] at htr
  have hrank : P.rank = Module.finrank ℂ (LinearMap.range (toLin' P)) := by
    rw [Matrix.rank, toLin'_apply']
  rw [hrank, ← htr]

/-- **Pairwise rank stability.**  Two idempotents whose traces differ by less than `1`
have equal rank.  (The rank is integer-valued, so a sub-unit perturbation of the trace
cannot change it.)  This is the discrete heart of "the projector rank cannot jump while
the island stays separated". -/
theorem rank_eq_of_trace_close (P R : Matrix n n ℂ)
    (hP : IsIdempotentElem P) (hR : IsIdempotentElem R)
    (h : ‖P.trace - R.trace‖ < 1) : P.rank = R.rank := by
  rw [← trace_eq_rank_of_idem P hP, ← trace_eq_rank_of_idem R hR] at h
  have key : ‖(((P.rank : ℤ) - (R.rank : ℤ) : ℤ) : ℂ)‖ < 1 := by
    have he : (((P.rank : ℤ) - (R.rank : ℤ) : ℤ) : ℂ) = (P.rank : ℂ) - (R.rank : ℂ) := by
      push_cast; ring
    rw [he]; exact h
  rw [Complex.norm_intCast] at key
  have hh : |((P.rank : ℤ) - (R.rank : ℤ))| < 1 := by exact_mod_cast key
  rw [abs_lt] at hh
  omega

/-- The projector rank is **locally constant** in the parameter `q`. -/
def ProjectorRankStable (P : Q → Matrix n n ℂ) : Prop :=
  ∀ q₀ : Q, ∀ᶠ q in nhds q₀, (P q).rank = (P q₀).rank

/-- **Finite-dimensional persistence theorem.**  A continuous family of idempotent
matrices has locally constant rank.  This is the minimal, integration-free statement of
projector persistence: continuity (which the maintained gap supplies analytically) plus
idempotency forces the integer rank to stay put. -/
theorem projectorRankStable_of_continuous (P : Q → Matrix n n ℂ)
    (hcont : Continuous P) (hidem : ∀ q, IsIdempotentElem (P q)) :
    ProjectorRankStable P := by
  intro q₀
  have hclose : ∀ᶠ q in nhds q₀, ‖(P q).trace - (P q₀).trace‖ < 1 := by
    have hc : Continuous (fun q => ‖(P q).trace - (P q₀).trace‖) := by fun_prop
    have hlt : (fun q => ‖(P q).trace - (P q₀).trace‖) q₀ < 1 := by simp
    exact hc.continuousAt.eventually_lt continuousAt_const hlt
  filter_upwards [hclose] with q hq
  exact rank_eq_of_trace_close (P q) (P q₀) (hidem q) (hidem q₀) hq

/-! ## Section 2.  Chirality: the chiral index as a difference of ranks. -/

/-- A *chirality* / grading operator is an involution `Γ * Γ = 1`. -/
def IsInvolution (Γ : Matrix n n ℂ) : Prop := Γ * Γ = 1

/-- Positive-chirality part of the physical projector: the image of `P` inside the
`+1`-eigenspace of `Γ`. -/
noncomputable def chiralPlus (Γ P : Matrix n n ℂ) : Matrix n n ℂ :=
  (2⁻¹ : ℂ) • (1 + Γ) * P

/-- Negative-chirality part of the physical projector. -/
noncomputable def chiralMinus (Γ P : Matrix n n ℂ) : Matrix n n ℂ :=
  (2⁻¹ : ℂ) • (1 - Γ) * P

/-- The positive-chirality part is idempotent. -/
theorem chiralPlus_idem (Γ P : Matrix n n ℂ) (hΓ : IsInvolution Γ)
    (hc : Commute Γ P) (hP : IsIdempotentElem P) :
    IsIdempotentElem (chiralPlus Γ P) := by
  simp_all +decide [ IsIdempotentElem, chiralPlus, IsInvolution ];
  simp_all +decide [ mul_add, add_mul, mul_assoc, Commute ];
  simp_all +decide [ ← mul_assoc,SemiconjBy ];
  simp_all +decide [ mul_assoc, ← smul_assoc ];
  ext i j ; norm_num ; ring

/-- The negative-chirality part is idempotent. -/
theorem chiralMinus_idem (Γ P : Matrix n n ℂ) (hΓ : IsInvolution Γ)
    (hc : Commute Γ P) (hP : IsIdempotentElem P) :
    IsIdempotentElem (chiralMinus Γ P) := by
  convert chiralPlus_idem (-Γ) P ?_ ?_ ?_ using 1 <;> norm_num at *;
  · simp_all +decide [ IsInvolution ];
  · exact hc;
  · exact hP

/-- The **chiral index** of the physical projector: the number of positive-chirality
states in the island minus the number of negative-chirality states.  It is an honest
integer, defined as a difference of two ranks. -/
noncomputable def chiralIndex (Γ P : Matrix n n ℂ) : ℤ :=
  ((chiralPlus Γ P).rank : ℤ) - ((chiralMinus Γ P).rank : ℤ)

/-- The chiral index equals `tr (Γ · P)`, the usual analytic expression. -/
theorem chiralIndex_eq_trace (Γ P : Matrix n n ℂ) (hΓ : IsInvolution Γ)
    (hc : Commute Γ P) (hP : IsIdempotentElem P) :
    ((chiralIndex Γ P : ℤ) : ℂ) = (Γ * P).trace := by
  unfold chiralIndex
  push_cast
  rw [trace_eq_rank_of_idem _ (chiralPlus_idem _ _ hΓ hc hP),
      trace_eq_rank_of_idem _ (chiralMinus_idem _ _ hΓ hc hP)]
  unfold chiralPlus chiralMinus
  rw [smul_mul_assoc, smul_mul_assoc, Matrix.trace_smul, Matrix.trace_smul,
      add_mul, sub_mul, one_mul, Matrix.trace_add, Matrix.trace_sub]
  simp only [smul_eq_mul]
  ring

-- The chiral index is locally constant in the parameter `q`.
/-- Balanced rank form of the C21 obstruction: if the positive- and
negative-chirality projector parts have equal rank, the chiral index is zero. -/
theorem chiralIndex_zero_of_rank_balanced (Γ P : Matrix n n ℂ)
    (hbal : (chiralPlus Γ P).rank = (chiralMinus Γ P).rank) :
    chiralIndex Γ P = 0 := by
  unfold chiralIndex
  omega

/-- Trace form of the same obstruction: an idempotent chirality-commuting
projector with zero chirality trace has zero chiral index. -/
theorem chiralIndex_zero_of_trace_zero (Γ P : Matrix n n ℂ)
    (hΓ : IsInvolution Γ) (hc : Commute Γ P) (hP : IsIdempotentElem P)
    (htr : (Γ * P).trace = 0) : chiralIndex Γ P = 0 := by
  have h := chiralIndex_eq_trace Γ P hΓ hc hP
  rw [htr] at h
  exact_mod_cast h

def ChiralIndexStable (Γ : Matrix n n ℂ) (P : Q → Matrix n n ℂ) : Prop :=
  ∀ q₀ : Q, ∀ᶠ q in nhds q₀, chiralIndex Γ (P q) = chiralIndex Γ (P q₀)

/-- **Chiral-index persistence.**  For a continuous family of idempotents commuting with
a fixed chirality `Γ`, the chiral index is locally constant.  Each chirality part is a
continuous family of idempotents, so each rank is locally constant, hence so is their
difference. -/
theorem chiralIndexStable_of_continuous (Γ : Matrix n n ℂ) (hΓ : IsInvolution Γ)
    (P : Q → Matrix n n ℂ) (hcont : Continuous P)
    (hidem : ∀ q, IsIdempotentElem (P q)) (hcomm : ∀ q, Commute Γ (P q)) :
    ChiralIndexStable Γ P := by
  have hcp : Continuous (fun q => chiralPlus Γ (P q)) := by
    unfold chiralPlus; fun_prop
  have hcm : Continuous (fun q => chiralMinus Γ (P q)) := by
    unfold chiralMinus; fun_prop
  have hrp : ProjectorRankStable (fun q => chiralPlus Γ (P q)) :=
    projectorRankStable_of_continuous _ hcp
      (fun q => chiralPlus_idem Γ (P q) hΓ (hcomm q) (hidem q))
  have hrm : ProjectorRankStable (fun q => chiralMinus Γ (P q)) :=
    projectorRankStable_of_continuous _ hcm
      (fun q => chiralMinus_idem Γ (P q) hΓ (hcomm q) (hidem q))
  intro q₀
  filter_upwards [hrp q₀, hrm q₀] with q hp hm
  unfold chiralIndex
  rw [hp, hm]

/-! ## Section 3.  The analytic interface: a maintained spectral island.

The following records bundle exactly the data that a Riesz contour-integral construction
provides.  No integration is performed here; instead the *outcomes* of the construction
(an idempotent commuting with `H`, varying continuously, attached to a spectral island
separated by a gap) are recorded as fields.  This is the practical abstraction asked for
in the task. -/

/-- **`SpectralIslandSeparated H physIsland gap`** — the spectral island `physIsland` of
`H` is separated from the rest of the spectrum by `gap`, and carries a genuine idempotent
Riesz projector `P` commuting with `H`.

The `separated` field is the load-bearing *geometric* hypothesis (the island stays a
gap away from the rest of the spectrum); the analytic Riesz construction then produces
the idempotent `P`. -/
structure SpectralIslandSeparated (H : Matrix n n ℂ) (physIsland : Set ℂ) (gap : ℝ) where
  /-- The physical (Riesz) projector for the island. -/
  P : Matrix n n ℂ
  /-- It is a genuine projector. -/
  idem : IsIdempotentElem P
  /-- It commutes with the endpoint operator (it is a spectral projector of `H`). -/
  commutesH : Commute H P
  /-- The separation gap is positive. -/
  gap_pos : 0 < gap
  /-- The island is part of the spectrum. -/
  island_subset : physIsland ⊆ spectrum ℂ H
  /-- The island is separated from the rest of the spectrum by `gap`. -/
  separated : ∀ z ∈ physIsland, ∀ w ∈ spectrum ℂ H \ physIsland, gap ≤ ‖z - w‖

/-- **`MaintainedIsland`** — a parametrized family in which the spectral island stays
separated by a *uniform* positive gap `g0`, and the Riesz projector varies continuously.

`Pcont` (continuity of `q ↦ P q`) is precisely the analytic output of the contour
integral: away from the spectrum the resolvent `(z - H q)⁻¹` is analytic, so as long as
the contour can be kept inside the maintained gap, the projector depends continuously
(indeed analytically) on `q`.  Supplying `Pcont` is what the actual null-edge endpoint
`H_ne` must do. -/
structure MaintainedIsland (Q : Type*) [TopologicalSpace Q]
    (n : Type*) [Fintype n] [DecidableEq n] where
  /-- The endpoint operator family `H_ne`. -/
  H : Q → Matrix n n ℂ
  /-- The (parameter-independent) physical spectral island. -/
  physIsland : Set ℂ
  /-- The Riesz projector family. -/
  P : Q → Matrix n n ℂ
  /-- Each member is a projector. -/
  idem : ∀ q, IsIdempotentElem (P q)
  /-- Each member commutes with the endpoint operator. -/
  commutesH : ∀ q, Commute (H q) (P q)
  /-- **Analytic input:** the projector family is continuous in `q`. -/
  Pcont : Continuous P
  /-- The uniform maintained gap. -/
  g0 : ℝ
  /-- The maintained gap is positive. -/
  g0_pos : 0 < g0
  /-- The island stays inside the spectrum. -/
  island_subset : ∀ q, physIsland ⊆ spectrum ℂ (H q)
  /-- The island stays separated by the uniform gap `g0` at every parameter. -/
  separated : ∀ q, ∀ z ∈ physIsland, ∀ w ∈ spectrum ℂ (H q) \ physIsland, g0 ≤ ‖z - w‖

namespace MaintainedIsland

variable (M : MaintainedIsland Q n)

/-- At each parameter, the family does present a separated spectral island. -/
def toSpectralIslandSeparated (q : Q) :
    SpectralIslandSeparated (M.H q) M.physIsland M.g0 where
  P := M.P q
  idem := M.idem q
  commutesH := M.commutesH q
  gap_pos := M.g0_pos
  island_subset := M.island_subset q
  separated := M.separated q

/-- **Main persistence theorem (projector rank).**  In a maintained separated island the
physical projector rank is locally constant. -/
theorem projectorRankStable : ProjectorRankStable M.P :=
  projectorRankStable_of_continuous M.P M.Pcont M.idem

/-- **Main persistence theorem (chiral index).**  In a maintained separated island, with
a fixed chirality `Γ` commuting with the projector, the chiral index is locally
constant. -/
theorem chiralIndexStable (Γ : Matrix n n ℂ) (hΓ : IsInvolution Γ)
    (hcomm : ∀ q, Commute Γ (M.P q)) : ChiralIndexStable Γ M.P :=
  chiralIndexStable_of_continuous Γ hΓ M.P M.Pcont M.idem hcomm

/-- **Packaged persistence.**  Both invariants persist simultaneously. -/
theorem persistence (Γ : Matrix n n ℂ) (hΓ : IsInvolution Γ)
    (hcomm : ∀ q, Commute Γ (M.P q)) :
    ProjectorRankStable M.P ∧ ChiralIndexStable Γ M.P :=
  ⟨M.projectorRankStable, M.chiralIndexStable Γ hΓ hcomm⟩

end MaintainedIsland

/-! ## Section 4.  The `gamma_free` / `κ`–`α`–`β` error budget.

C193 supplies a free-reference spectral gap lower bound `gamma_free > 0` (the gap of the
free reference operator after the sign split).  The later error budget bounds the
perturbation of that gap by the endpoint corrections through coefficients `κ`, `α`, `β`.
The *maintained* gap is the lifted gap `gamma_free − (κ·α + β)`; as long as the budget
keeps this positive, the spectral island stays separated and the persistence theorems of
Section 3 apply. -/

/-- The **lifted gap**: free-reference gap minus the budgeted perturbation. -/
def gapLift (gamma_free kappa alpha beta : ℝ) : ℝ := gamma_free - (kappa * alpha + beta)

/-- **Gap-lift lemma.**  If the budgeted perturbation stays below the free-reference gap,
the lifted gap is positive — the spectral island remains separated. -/
theorem gapLift_pos (gamma_free kappa alpha beta : ℝ)
    (hbudget : kappa * alpha + beta < gamma_free) :
    0 < gapLift gamma_free kappa alpha beta := by
  unfold gapLift; linarith

/-- **From budget to persistence.**  Given a candidate maintained-island family whose
uniform gap is the lifted gap, once the error budget keeps that gap positive the
projector rank persists.  (This is the bridge between the C193 gap accounting and the
finite-dimensional persistence theorem.) -/
theorem persistence_of_budget
    (H : Q → Matrix n n ℂ) (physIsland : Set ℂ) (P : Q → Matrix n n ℂ)
    (gamma_free kappa alpha beta : ℝ)
    (hbudget : kappa * alpha + beta < gamma_free)
    (idem : ∀ q, IsIdempotentElem (P q))
    (commutesH : ∀ q, Commute (H q) (P q))
    (Pcont : Continuous P)
    (island_subset : ∀ q, physIsland ⊆ spectrum ℂ (H q))
    (separated : ∀ q, ∀ z ∈ physIsland, ∀ w ∈ spectrum ℂ (H q) \ physIsland,
      gapLift gamma_free kappa alpha beta ≤ ‖z - w‖) :
    ProjectorRankStable P :=
  let M : MaintainedIsland Q n :=
    { H := H, physIsland := physIsland, P := P, idem := idem, commutesH := commutesH,
      Pcont := Pcont, g0 := gapLift gamma_free kappa alpha beta,
      g0_pos := gapLift_pos gamma_free kappa alpha beta hbudget,
      island_subset := island_subset, separated := separated }
  M.projectorRankStable

/-! ## Section 5.  No-go / failure cases.

These examples make precise the success criterion: the projector persists *because the
island stays separated*, and the rank genuinely jumps when separation (hence continuity)
is lost.  None of this proves anything about the mass window. -/

/-- **Rank can jump when the gap closes.**  There are idempotents `1` and `0` of
different rank.  In a `1`-dimensional space, `1` has rank `1` and `0` has rank `0`: any
family interpolating an island that *merges* with the rest of the spectrum (gap closing)
loses continuity and the rank is free to drop.  This is the failure mode that the
maintained-gap hypothesis rules out. -/
theorem rank_jump_without_gap :
    ∃ P R : Matrix (Fin 1) (Fin 1) ℂ,
      IsIdempotentElem P ∧ IsIdempotentElem R ∧ P.rank ≠ R.rank := by
  refine ⟨1, 0, ?_, ?_, ?_⟩
  · exact IsIdempotentElem.one
  · exact IsIdempotentElem.zero
  · simp [Matrix.rank_one, Matrix.rank_zero]

/-- The hypothesis of `rank_eq_of_trace_close` is sharp: with two idempotents whose
traces differ by exactly `1`, the conclusion fails.  Persistence is therefore *not*
automatic — it relies on the trace staying within a unit ball, which the maintained gap
guarantees via continuity. -/
theorem trace_close_hypothesis_sharp :
    ∃ P R : Matrix (Fin 1) (Fin 1) ℂ,
      IsIdempotentElem P ∧ IsIdempotentElem R ∧
      ‖P.trace - R.trace‖ = 1 ∧ P.rank ≠ R.rank := by
  refine ⟨1, 0, IsIdempotentElem.one, IsIdempotentElem.zero, ?_, ?_⟩
  · simp [Matrix.trace_one, Matrix.trace_zero]
  · simp [Matrix.rank_one, Matrix.rank_zero]

end GateC1
