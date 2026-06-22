# Relative-entropy observer-channel design note

Date: 2026-06-22
Scope: design + readiness triage for the information-theoretic spine shared by
P7 (visible/internal reduction, mass-as-celestial-mixedness) and P9
(causal-diamond source visibility, ANEC/QNEC-style positivity, recoverability).

Companion artifact (checked):
`PhysicsSM/Draft/NullEdgeRelativeEntropyObserverRoadmap.lean` — a non-imported
standalone scaffold over Mathlib only. **Every classical-finite theorem in this
note is already proved there** (checked with `lake env lean`; axioms
`propext, Classical.choice, Quot.sound` only; no `s o r r y`). The note therefore
records what is now *banked at the scaffold level*, what is *definition-risky*,
and what must stay continuum motivation.

Primary inputs read: the strengthened program, publication plan (P7, P9),
research plan, bibliography (cluster E2), the overnight/loop/grand-strategy task
notes, the physics audit, and the three context drafts
(`NullEdgeQubitConcurrence`, `NullEdgeDecoherenceChannelAristotle`,
`NullEdgeQuantumMeasureFiniteAristotle`).

---

## 0. Executive recommendation (read this first)

The single instruction the program already identified — *"define the observer
channel first"* — is the right one, and it is cheap to satisfy honestly in the
**classical finite (commutative / diagonal) layer**. We did it:

* The observer channel is a finite **column-stochastic matrix** `FinObs ι κ`.
* Relative entropy is the finite **nat-log KL divergence** `klDiv`.
* The four load-bearing facts — Gibbs nonnegativity, the equality case, the
  **data-processing inequality (DPI)**, and **exact recoverability saturates
  DPI** — are all proved in the scaffold.

Therefore the next two-to-three finite theorems to prove are **not** the
classical KL facts (done), but the *bridges* that turn this spine into program
content, in this order:

1. **`visibleMixedness_monotone_under_classical_observer`** — the P7 bridge:
   single-qubit linear entropy `4 det ρ_vis`, read as the *classical* mixedness
   of the eigenvalue distribution, is monotone under a *classical* (diagonal /
   pinching) observer channel. Hypotheses to bundle: `ρ` PSD, trace 1, and the
   channel acts in the eigenbasis. (Confidence 8.)
2. **`closedVisibleFan_pushesForward_to_pointMass`** / the P9 diamond-observer
   specialization `relativeEntropyDataProcessing_for_diamondObserver` — a
   *definitional instance* of the proven `klDiv_dataProcessing` with the diamond
   screen as `FinObs` and an SJ-style reference distribution as `σ`. (Confidence
   on DPI reuse: 9; on the SJ reference *physics*: 4.)
3. **`recoverabilityGap` ⇒ source-visibility diagnostic** — keep as a *defined*
   real-valued gap (done) and a *conjectural* inequality against a source
   functional; do **not** assert it as a theorem yet. (Confidence as definition:
   8; as physics theorem: 3.)

Slogans **not yet justified** and which must not appear as theorems: "mass is an
asymmetry/coherence monotone"; "diamond relative entropy second difference ≥ 0
reproduces QNEC"; "Petz recovery reconstructs hidden bookkeeping"; "the SJ
diamond state gives an area law". These are continuum/operator-algebra imports
or open conjectures.

---

## 1. Minimal finite observer / coarse-graining API

All four objects below are in the scaffold and type-check.

```lean
structure FinDist (ι : Type*) [Fintype ι] where
  p : ι → ℝ
  nonneg  : ∀ i, 0 ≤ p i
  sum_one : ∑ i, p i = 1

/-- Observer / coarse-graining channel `ι → κ`, a COLUMN-stochastic matrix
    `M j i = P(observe j | underlying state i)`. -/
structure FinObs (ι κ : Type*) [Fintype ι] [Fintype κ] where
  M : κ → ι → ℝ
  nonneg      : ∀ j i, 0 ≤ M j i
  col_sum_one : ∀ i, ∑ j, M j i = 1

def applyObs    (T : FinObs ι κ) (d : FinDist ι) : κ → ℝ   -- ∑ i, M j i * d.p i
def pushforward (T : FinObs ι κ) (d : FinDist ι) : FinDist κ
def FinObs.comp (S : FinObs κ μ) (T : FinObs ι κ) : FinObs ι μ
```

Design choices and why they matter:

* **Column-stochastic, not doubly stochastic.** A general observer/coarse-
  graining (pinching, partition merge, partial trace in the diagonal case) is
  column-stochastic. Doubly-stochastic is the special "unital" subclass; bundle
  it as a separate predicate `IsUnital T := ∀ j, ∑ i, T.M j i = 1` only where a
  *unitality*-dependent statement is wanted (e.g. uniform-reference monotonicity
  ≈ the Bloch contraction story of grand-strategy Cluster B). Do not bake
  unitality into `FinObs`.
* **Deterministic partition as a sub-case.** A coarse-graining map `f : ι → κ`
  is `FinObs` with `M j i = if f i = j then 1 else 0`. Provide it as a
  constructor `FinObs.ofFun f`; it is the cleanest object for the P9 "screen"
  reduction and for `closed_visibleFan_mass_eq_restEnergy`-style merges.
* **Composition is closed** (`FinObs.comp` proved column-stochastic). This is
  what licenses the recoverability argument (apply DPI to `R ∘ T`).

Confidence scores:

| object | conf | note |
|---|---|---|
| `FinDist` | 9 | standard; only risk is forgetting `nonneg`+`sum_one` are both needed. |
| `FinObs` (column-stochastic) | 9 | correct general observer; resist doubly-stochastic temptation. |
| `applyObs` / `pushforward` | 9 | proved to land back in `FinDist`. |
| `FinObs.comp` | 9 | proved; needed for recoverability. |
| `FinObs.ofFun` (partition) | 8 | recommended addition; trivial. |
| `IsUnital` predicate | 7 | only for the uniform-reference / Bloch-contraction sub-story. |

---

## 2. Staged proof route — classical finite KL first (DONE), quantum later

The grand strategy correctly warned that full quantum matrix relative entropy is
heavy. The staging below puts the entire weight on the classical layer, which we
have now closed, and isolates exactly what the quantum layer would add.

### Stage 0 (DONE): classical finite KL spine

```lean
def AbsCont (p q : FinDist ι) : Prop := ∀ i, q.p i = 0 → p.p i = 0   -- support inclusion
def klDiv (p q : FinDist ι) : ℝ := ∑ i, p.p i * Real.log (p.p i / q.p i)

theorem klDiv_self        (p)            : klDiv p p = 0
theorem klDiv_nonneg      (hac : AbsCont p q) : 0 ≤ klDiv p q          -- Gibbs
theorem klDiv_eq_zero_iff (hac : AbsCont p q) : klDiv p q = 0 ↔ p.p = q.p
theorem klDiv_dataProcessing (T) (hac : AbsCont p q) :                 -- HEADLINE
    klDiv (pushforward T p) (pushforward T q) ≤ klDiv p q
```

All proved. `klDiv_dataProcessing` is the **finite log-sum inequality**
specialised fiberwise and summed; it is not in Mathlib (Mathlib has
`InformationTheory.klDiv` over measures in `ℝ≥0∞` but **no** DPI). The proof
rests only on `Real.log_le_sub_one_of_pos` and `Real.log_lt_sub_one_of_pos`.

**Hypothesis that must be bundled:** `AbsCont p q` (support inclusion). Without
it the finite formula silently drops the `+∞` terms (`p i > 0, q i = 0` gives a
spurious `0` because Lean's `log 0 = 0`), so every nonnegativity / monotonicity
statement is false-as-written without it. This is the single most important
"definition-risk" lesson: the support-inclusion hypothesis is not optional
decoration, it is load-bearing.

### Stage 1 (DONE): observer loss + exact recoverability

```lean
def observerLoss (T) (p q) : ℝ := klDiv p q - klDiv (pushforward T p) (pushforward T q)
theorem observerLoss_nonneg (T) (hac : AbsCont p q) : 0 ≤ observerLoss T p q

def ExactRecovery (T : FinObs ι κ) (R : FinObs κ ι) (p q) : Prop :=
  pushforward R (pushforward T p) = p ∧ pushforward R (pushforward T q) = q
theorem observerLoss_zero_of_exactRecovery
    (T) (R) (hac : AbsCont p q) (hR : ExactRecovery T R p q) : observerLoss T p q = 0

def recoverabilityGap (T : FinObs ι κ) (R : FinObs κ ι) (p q) : ℝ :=
  klDiv p q - klDiv (pushforward R (pushforward T p)) (pushforward R (pushforward T q))
```

`observerLoss_zero_of_exactRecovery` is the finite **exact** Petz analogue: a
recovery channel forces DPI saturation. Proved by applying `klDiv_dataProcessing`
to `R` on `(Tp, Tq)` and `le_antisymm` against `observerLoss_nonneg`.

### Stage 2 (NEXT, classical): partition / deterministic refinements

Cheap specializations to bank for P9 plumbing:

* `klDiv_dataProcessing_for_finitePartition` := `klDiv_dataProcessing (FinObs.ofFun f)`.
  *Decision: keep, but as a one-line specialization, not a separate proof job.*
* `observerLoss_ofFun_eq_conditional_divergence` (optional, the grouped-by-fiber
  identity) — only if a downstream proof actually needs the closed form.

### Stage 3 (LATER, quantum — gated): matrix relative entropy

Only attempt once a concrete program need forces it. Explicit hypotheses that
**must** be bundled (the prompt's checklist), and why the classical layer dodges
each:

| quantum hypothesis | needed because | classical analogue (already handled) |
|---|---|---|
| finite-dim Hilbert space `Fin d`, `Matrix (Fin d) (Fin d) ℂ` | `Tr`, eigen-decomposition exist | finite `ι` |
| `ρ.PosSemidef`, `σ.PosSemidef` | `log` of operator defined; entropy real | `nonneg` |
| `ρ.trace = 1`, `σ.trace = 1` | normalization, `S(ρ‖ρ)=0` | `sum_one` |
| support inclusion `ker σ ⊆ ker ρ` (i.e. `ρ ≪ σ`) | otherwise `S = +∞` | `AbsCont` |
| channel is **CPTP** (`Φ` completely positive, trace preserving) | DPI needs *complete* positivity, not just positivity | column-stochastic = CPTP for diagonal/classical channels |

The hard part of the quantum DPI (Lindblad/Uhlmann monotonicity, operator
convexity of `t ↦ t log t`, Lieb concavity) has **no Mathlib support** and is a
large independent formalization. Recommendation: do **not** open this gate for
P7/P9. The classical layer is the honest "Type-I matrix analogue" the
publication plan already says is the safe claim. If a quantum statement is ever
needed, restrict first to **commuting** `ρ, σ` (simultaneously diagonalizable),
which reduces *exactly* to the proven classical `klDiv` on shared eigenvalues —
no new analysis required.

Staging confidence:

| stage | conf | status |
|---|---|---|
| 0 classical KL spine | 9 | DONE (proved) |
| 1 observer loss + exact recovery | 9 | DONE (proved) |
| 2 partition specializations | 9 | trivial reuse |
| 3 quantum matrix RE | 3 | gated; only via commuting-operator reduction |

---

## 3. Exact statement sketches: data processing & recoverability

Data processing (general observer), **proved**:

```lean
theorem klDiv_dataProcessing (T : FinObs ι κ) (p q : FinDist ι)
    (hac : AbsCont p q) :
    klDiv (pushforward T p) (pushforward T q) ≤ klDiv p q
```

Diamond-observer instance (P9 gate), **definitional** once `Screen`/`σ` exist:

```lean
-- T_screen : FinObs (Microstate D) (ScreenCell D)   -- the diamond coarse-graining
-- σ_diamond : FinDist (Microstate D)                -- SJ-style reference
theorem relativeEntropyDataProcessing_for_diamondObserver
    (D) (ρ : FinDist (Microstate D)) (hac : AbsCont ρ σ_diamond) :
    klDiv (pushforward (T_screen D) ρ) (pushforward (T_screen D) σ_diamond)
      ≤ klDiv ρ σ_diamond
  := klDiv_dataProcessing _ _ _ hac      -- NOT new mathematics; a named instance
```

Exact recoverability (finite Petz), **proved**:

```lean
theorem observerLoss_zero_of_exactRecovery
    (T : FinObs ι κ) (R : FinObs κ ι) (p q : FinDist ι)
    (hac : AbsCont p q) (hR : ExactRecovery T R p q) :
    observerLoss T p q = 0
```

Approximate recoverability (the quantitative source-visibility diagnostic),
kept honest as a **definition + conjecture**, not a theorem:

```lean
def recoverabilityGap (T) (R) (p q) : ℝ := …      -- proved well-defined, ≥ 0 under AbsCont
-- CONJECTURE (do not submit as a theorem yet):
-- sourceVisibilityDefect D ρ ≤ recoverabilityGap (T_screen D) R_petz ρ σ_diamond
```

The Fawzi–Renner statement (CMI lower-bounds the regularized relative-entropy
gap) is the continuum target. The honest finite move is: *define* the gap (done)
and *state* the inequality against a future `sourceVisibilityDefect` as a named
conjecture. No finite proof should claim the Petz map reconstructs anything until
`R_petz` is constructed and `ExactRecovery`/`recoverabilityGap` is computed in a
concrete toy.

---

## 4. Interface with the qubit concurrence theorem (P7)

The audit already flagged the trap; the API must respect it.

**The fact.** `NullEdgeQubitConcurrence.concurrenceSqComplex ρ = 4 det ρ` is the
**single-qubit linear entropy / tangle** `2(1 − Tr ρ²) = 4 det ρ` (proved there
via `Tr ρ² = (Tr ρ)² − 2 det ρ`). It is **not** the Wootters two-qubit
concurrence `max(0, λ₁−λ₂−λ₃−λ₄)` with spin-flip and eigenvalue ordering.

**How the relative-entropy API connects without confusing the two.** For a
genuine qubit density (PSD, trace 1) with eigenvalues `(λ, 1−λ)`:

* `4 det ρ = 4 λ(1−λ)` is a *symmetric concave mixedness functional* of the
  classical eigenvalue distribution `eigDist ρ := ⟨λ, 1−λ⟩ : FinDist (Fin 2)`.
* The proper-time wrapper `m/E = 2√det ρ_vis` is `√(4λ(1−λ))`, a function of
  `eigDist ρ` only.
* The correct monotonicity statement is therefore: *under a classical
  (eigenbasis-diagonal / pinching) observer channel `T : FinObs (Fin 2) (Fin 2)`,
  the mixedness `4 det` and hence `m/E` does not decrease* — because such `T`
  pushes `eigDist ρ` toward uniform, and `λ(1−λ)` is Schur-concave. This is the
  **same DPI principle** restated for a concave functional; it is honestly LOCC/
  classical-channel-only, matching the program's stated boundary that entangling
  hidden channels can *increase* concurrence (so a bare monotonicity claim is
  false).

Recommended bridge declarations (NEXT job, see ranking):

```lean
def eigDist (ρ : QubitDensity) (h : ρ.PosSemidef) (htr : ρ.trace = 1) : FinDist (Fin 2)
def visibleMixedness (ρ) : ℝ := 4 * (Matrix.det ρ).re          -- = 4 λ(1−λ)
theorem visibleMixedness_eq_concurrenceSq (ρ) (htr : trace2 ρ = 1) :
    visibleMixedness ρ = (concurrenceSqComplex ρ).re             -- ties to the banked wrapper
theorem visibleMixedness_monotone_under_classical_observer
    (ρ) (hρ : ρ.PosSemidef) (htr) (T : FinObs (Fin 2) (Fin 2)) (hUnital : IsUnital T) :
    visibleMixedness ρ ≤ visibleMixedness (eigbasis-pushforward of ρ by T)
```

Hypotheses that **must** be bundled (and are missing in the current
`concurrenceSqComplex` wrapper): `ρ.PosSemidef`, `trace = 1`, and — for
monotonicity — `IsUnital T` (doubly stochastic / pinching). The audit's
recommendation to add `HermitianMatrix.PosSemidef` carriers is exactly right;
the relative-entropy API gives those carriers a purpose.

`concurrenceSqComplex` confidence: 7 (correct algebra, wrong-name risk; keep the
docstring caveat). `visibleMixedness` + monotonicity bridge confidence: 8.

Slogan **not yet justified**: "visible proper-time concurrence is an entanglement
monotone." It is a *single-qubit linear-entropy* monotone under unital classical
channels only. Say that.

---

## 5. Interface with P9 source visibility (no premature continuum claims)

The proven spine plugs into P9 *only* through named instances. The discipline:

* The observer channel is the diamond **screen coarse-graining** `T_screen`
  (a `FinObs`, ideally `FinObs.ofFun` of a microstate→cell map). Define it before
  any positivity claim — this satisfies the program's gate-2 requirement.
* The reference `σ` is a finite SJ-style correlation distribution
  `sjDiamondReferenceState`. **Define it as a finite `FinDist` only**; do not
  attach the area law. The SJ literature needs Pauli–Jordan spectral truncation
  to get an area law, so any reference state used here must be flagged as
  *pre-truncation / pre-area-law*.
* `relativeEntropyDataProcessing_for_diamondObserver` is then a one-line instance
  of `klDiv_dataProcessing` (Section 3). It is the **finite ANEC/QNEC-positivity
  analogue**, and must be advertised as an analogue, never as ANEC/QNEC.

What stays continuum motivation (NOT theorems here): ANEC from modular-
Hamiltonian relative-entropy monotonicity (Faulkner et al. `1605.08072`); QNEC
recovery (Ceyhan–Faulkner `1812.04683`); the relative-entropy Bekenstein bound
(Casini `0804.2182`); Fawzi–Renner approximate-Markov recoverability
(`1410.0664`); SJ diamond entropy area law (`1311.7146`, `1611.10281`). These are
cited as the targets the finite analogues *gesture at*, with conventions
unchecked against ours.

The crucial separation the P9 gate demands (and which the spine respects):

```text
visible momentum closure  C = Σ wᵢ nᵢ = 0     ← rest-frame, NOT invisibility
BF / surface closure      Σ_f B_f = 0          ← candidate invisibility
observer invisibility     source functional vanishes / boundary-only
```

`klDiv_dataProcessing` says nothing about which of these holds; it only provides
the *positivity / monotonicity guardrail* once `T_screen` and `σ` are fixed.
Keep `diamondRelativeEntropy_secondDifference_nonnegative` and
`petzRecoverabilityGap_controls_sourceVisibility` as **definitions + conjectures**
until the source functional exists.

P9 interface confidence: DPI reuse 9; `sjDiamondReferenceState` as a finite
`FinDist` 5 (definition is fine, *physics content* of the choice is the risk);
second-difference / QNEC-analogue 4; recoverability-controls-visibility 3.

---

## 6. Verdict on the candidate theorem targets

| candidate | verdict | rationale |
|---|---|---|
| `klDataProcessing_for_finitePartition` | **KEEP, downgrade to instance** | `klDiv_dataProcessing (FinObs.ofFun f)`; not a separate proof job. Conf 9. |
| `relativeEntropyDataProcessing_for_finiteObserver` | **DONE** | this *is* `klDiv_dataProcessing` (general observer). Conf 9. |
| `observerLoss_nonneg` | **DONE** | proved from DPI. Conf 9. |
| `loss_zero_if_exactObserverRecovery` | **DONE** | proved as `observerLoss_zero_of_exactRecovery`. Conf 9. |
| `visibleObserver_concurrenceMonotonicity_boundary` | **KEEP, RESTATE** | must be *linear-entropy/mixedness* monotonicity under a *unital classical* channel, with PSD+trace-1+`IsUnital` bundled. Not Wootters. Conf 8. |
| `diamondObserver_monotonicity_handoff` | **KEEP as instance** | `relativeEntropyDataProcessing_for_diamondObserver` once `T_screen` exists. Conf 9 (math) / 4 (screen physics). |
| `sjDiamondReferenceState_def` | **KEEP as definition only** | finite `FinDist`; flag pre-area-law / pre-truncation. Conf 5. |
| `petzRecoverabilityGap_controls_sourceVisibility` | **REJECT as theorem; KEEP as conjecture** | `recoverabilityGap` is defined and ≥ 0; the inequality against a source defect is unproven and the source defect undefined. Conf 8 (def) / 3 (theorem). |

Two further splits worth recording:

* Split any "monotonicity" target into (i) the *channel-class predicate*
  (`IsUnital` / `IsLOCC` / `FinObs.ofFun`) and (ii) the inequality. The program's
  repeated bug is stating monotonicity without the class.
* Split `sjDiamondReferenceState` into the *state definition* (safe) and the
  *area-law property* (gated on truncation, do not bundle).

---

## 7. Ranked proof jobs ready for Aristotle

Banked already (scaffold, proved): `applyObs_*`, `pushforward`, `FinObs.comp`,
`klDiv_self`, `klDiv_nonneg`, `klDiv_eq_zero_iff`, `klDiv_dataProcessing`,
`observerLoss_nonneg`, `observerLoss_zero_of_exactRecovery`, `recoverabilityGap`
(def).

Next, in priority order:

1. **`visibleMixedness_monotone_under_classical_observer`** (P7 bridge).
   Decompose: (a) `eigDist` well-defined from PSD+trace-1; (b) `4 det = 4λ(1−λ)`
   in eigenbasis; (c) Schur-concavity / DPI of `klDiv` against uniform ⇒ mixedness
   monotone under unital `T`. Reuse the proven `klDiv_dataProcessing`. Ready.
   Conf 8.
2. **`FinObs.ofFun` + `klDataProcessing_for_finitePartition`** (P9 plumbing).
   Trivial constructor + one-line instance. Ready. Conf 9.
3. **`visibleMixedness_eq_concurrenceSq`** (ties bridge to the banked qubit
   wrapper). Pure algebra over `trace2_mul_self_eq_trace_sq_sub_two_det`. Ready.
   Conf 9.
4. **A concrete recoverability toy**: a 2→1 merge `T` with an explicit
   non-recovering `R`, computing `recoverabilityGap > 0`, plus a reversible
   embedding with gap `= 0`. This *validates* the recoverability story before any
   P9 claim. Ready (needs only the proven API + `decide`/`norm_num`). Conf 8.
5. **`relativeEntropyDataProcessing_for_diamondObserver`** — blocked on the P9
   `DiamondData`/`Screen`/`Microstate` definitions, then a one-line instance.
   *Not ready* until that API lands; the math is free. Conf 9 (math) / 4 (defs).

Do **not** queue: quantum matrix relative-entropy DPI (Stage 3); any
second-difference/QNEC-analogue theorem; any `petz…controls…sourceVisibility`
*theorem* (conjecture only).

---

## 8. Confidence summary (definitions and theorems)

| declaration | kind | conf | status |
|---|---|---|---|
| `FinDist`, `FinObs` | def | 9 | banked |
| `applyObs`, `pushforward`, `FinObs.comp` | def/thm | 9 | banked (proved) |
| `AbsCont` (support inclusion) | def | 9 | banked; load-bearing hypothesis |
| `klDiv` | def | 9 | banked |
| `klDiv_self` | thm | 9 | proved |
| `klDiv_nonneg` (Gibbs) | thm | 9 | proved |
| `klDiv_eq_zero_iff` | thm | 9 | proved |
| `klDiv_dataProcessing` (DPI) | thm | 9 | proved (headline) |
| `observerLoss`, `observerLoss_nonneg` | def/thm | 9 | proved |
| `ExactRecovery`, `observerLoss_zero_of_exactRecovery` | def/thm | 9 | proved |
| `recoverabilityGap` | def | 8 | proved well-defined; diagnostic |
| `FinObs.ofFun`, partition DPI | def/thm | 9 | ready (trivial) |
| `eigDist`, `visibleMixedness`, monotonicity bridge | def/thm | 8 | next job |
| `visibleMixedness_eq_concurrenceSq` | thm | 9 | ready |
| `sjDiamondReferenceState` (state only) | def | 5 | gated; pre-area-law |
| diamond-observer DPI instance | thm | 9 / 4 | math free; defs gated |
| quantum matrix RE + DPI | thm | 3 | do not open; commuting-case only |
| `…recoverabilityGap_controls_sourceVisibility` | thm | 3 | conjecture only |

---

## 9. Honest boundary statement (for any paper that cites this)

* What is proved: a finite, kernel-checked classical relative-entropy spine —
  observer channels, KL divergence, Gibbs, the data-processing inequality,
  observer loss, and exact finite recoverability. (Scaffold:
  `PhysicsSM/Draft/NullEdgeRelativeEntropyObserverRoadmap.lean`, no `s o r r y`,
  standard axioms only.)
* What is a disciplined analogue: the diamond-observer DPI and the
  recoverability gap, once the P9 screen/reference definitions exist — finite
  Type-I analogues of ANEC/QNEC positivity and Petz recoverability.
* What is imported continuum physics, not reproved: ANEC, QNEC, modular
  Hamiltonians, the Bekenstein bound, Fawzi–Renner recoverability, and the SJ
  diamond-entropy area law.
* What is not yet justified at all: "mass is an asymmetry/coherence monotone",
  a quantum (non-commuting) DPI in this repo, and any theorem asserting that the
  recoverability gap *controls* a source-visibility defect.
