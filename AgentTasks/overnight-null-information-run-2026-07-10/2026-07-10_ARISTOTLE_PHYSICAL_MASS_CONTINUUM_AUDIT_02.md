# PHYSICAL_MASS_CONTINUUM_AUDIT_02.md

Independent follow-up audit (Codex, 2026-07-10) of the five correction modules
that respond to the prior Hodge audit (`PriorHodgeAudit.md`) and composition
audit (`PriorCompositionAudit.md`).

Modules audited (all under `Audit/Inputs`):

| Module | Prior finding it targets |
|---|---|
| `PositiveHodgePhysicalMass.lean` | degenerate Hodge witness (F3), missing positivity (F4), well-definedness gap |
| `HodgePluckerMassBridge.lean` | supplied-dictionary / mass identification (F5, B-F5) |
| `CanonicalGramTurnDictionary.lean` | hollow-conjunction control (B-F2), scale uniqueness |
| `CheckerboardAmplitudeGluing.lean` | turn-count not checked (B-F4) |
| `BoundedMomentumManyStepContinuum.lean` | pointwise-only continuum convergence |

## Method / reproduction caveat

The five modules import `PhysicsSM.Draft.NullEdge.*` and `PhysicsSM.Spinor.*`
primitives that are **not present in this repository** (verified by `grep`:
`class_cost_constant`, `nilpotent_positive_class_witness`,
`turn_is_mass_squared`, `free_mass_operator_eq_plucker`,
`fixed_time_many_step_bound`, `RadicalProperty`, etc. resolve to nothing here).
They therefore could **not** be elaborated locally; this is a **source-level
audit** of logical shape, plus a reading of each proof term. Each file carries
in-file `#guard_msgs`/`#print a x i o m s` footprint guards asserting exactly
`[propext, Classical.choice, Quot.sound]`; those guards are trusted here but not
re-run. No `s o r r y`, `a d m i t`, or `a x i o m` appears in any of the five files.

---

## 1. Findings, highest severity first

### F1 (HIGH) — The nondegenerate quartet fix is NOT the fixture wired into the mass bridge.
Declarations: `HodgePluckerMassBridge.matched_four_twentyfive_witness`
(uses `witnessB/witnessQ/witnessS` and `nilpotent_positive_class_witness` — the
**old degenerate** `diag(0,1,1)`, `Fin 3 → ℝ` witness from
`PositiveHodgeClassCostNoGo`) versus
`PositiveHodgePhysicalMass.nondegenerate_quartet_witness` (the **new**
`quartetB/quartetQ/quartetS`, `Fin 4 → ℝ`).

The prior F3 failure mode (globally-null exact direction on a degenerate Krein
form) is genuinely repaired *inside* `PositiveHodgePhysicalMass`, but the mass
bridge still shares its `4/25` with the **degenerate** witness. The two "already
landed witness families" the bridge docstring claims to instantiate on one
shared value are (i) the degenerate Hodge witness and (ii) the Pluecker spinor
pair — *not* the repaired quartet. So the improved construction and the physical
(Pluecker/turn) mass are never connected. The `4/25` is numerically shared
(both sides literally equal `4/25`), but the nondegeneracy improvement does not
propagate to the bridge. This is the single most important remaining gap and it
is not disclosed in any docstring.

### F2 (MEDIUM) — `mu2 = m^2` is an assumed bridge hypothesis carrying all the physics; nothing derives it.
Declaration: `HodgePluckerMassBridge.class_cost_eq_canonical_plucker`
(hypothesis `hmu : mu2 = m ^ 2`).

The theorem is honest and correctly proved: given `hmu`, the class-invariant
Hodge cost equals `complexAbsSq (spinorWedge edge0 (edge1 m))`. But the entire
identification "Hodge class eigenvalue = physical mass-squared scale" is the
hypothesis `hmu`; it is inserted, not derived. What remains assumed is exactly:
that the abstract spectral invariant `mu2` of the constraint cohomology is the
same number as the squared turn/Pluecker scale `m^2`. This is disclosed in the
docstring ("remains a displayed bridge hypothesis; it is not derived here"), so
it is honest, but it means the bridge is a **conditional identity keyed on the
central unproved physical assumption**, not a derivation of mass.

### F3 (LOW) — Continuum uniformity is over bounded momentum boxes only; the box constant diverges, so it is not yet integrable to a PDE.
Declarations: `BoundedMomentumManyStepContinuum.Dbox`,
`fixed_time_many_step_bound_on_box`, `box_error_envelope_tendsto_zero`.

The single explicit constant `Dbox K M = 4·Cbox K M + 4(K+M)^2 exp(K+M)`
genuinely bounds every point of the box `|k|≤K, |m|≤M` uniformly (that is the
real upgrade from pointwise). But `Dbox` grows like `K^2` and `exp(K+M)`, so it
is **not** uniform over all momenta and cannot be used to control an
inverse-Fourier integral over `k`. Hence there is no position-space propagator,
no `L^2`/operator statement, no Dirac PDE, and no `3+1` result. This is fully
disclosed in the docstring ("not yet an inverse-Fourier, position-space, full
propagator, PDE, or 3+1 convergence theorem"), so LOW / no overreach — but the
"continuum" language should not be read as a PDE.

### F4 (LOW) — Minor decorative hypotheses / conjuncts (non-minimal statements).
- `PositiveHodgePhysicalMass.class_mass_wellDefined`: `hcl' : Q h' = 0` is
  redundant — with `hQQ : Q ∘ₗ Q = 0` and `hcl`, `h' = h + Q chi` is closed
  automatically; the proof does not use `hcl'`.
- `HodgePluckerMassBridge.matched_four_twentyfive_witness` and
  `CheckerboardAmplitudeGluing.two_segment_turn_gluing_witness` still open with
  a conjunct that is an *instance of the already-proved general law*
  (`class_cost_constant` / `pathAmplitude_append`); the new information is the
  added nondegeneracy/turn-count conjuncts, not that first clause. (This is the
  residue of prior B-F2/B-F4; see closures below — the load-bearing content was
  added, but the decorative first conjunct remains.)

These are cleanliness/minimality issues, not soundness or vacuity bugs.

---

## 2. Prior findings — CLOSED / PARTIALLY CLOSED / OPEN

### Prior Hodge audit (`PriorHodgeAudit.md`)

- **F3 (degenerate Krein witness): CLOSED** by
  `PositiveHodgePhysicalMass.nondegenerate_quartet_witness` and its parts.
  The quartet Gram `quartetBMatrix = [[0,1,0,0],[1,0,0,0],[0,0,1,0],[0,0,0,-1]]`
  is **nondegenerate** (`quartetB_left_nondegenerate`) and **indefinite**
  (`quartet_e2_positive` `= 1`, `quartet_e3_negative` `= -1`). The exact vector
  `e0 = Q e1` is **not** globally null: `quartet_exact_pairs_nonclosed` gives
  `quartetB qe0 qe1 = 1`, `quartetQ qe1 = qe0`, `quartetQ qe0 = 0`, i.e. a
  genuine BRST-style quartet where the exact null direction pairs nontrivially
  with a **non-closed** partner `e1` (non-closed because `Q e1 = e0 ≠ 0`,
  `quartetQ_ne_zero`). Crucially `quartet_radical` proves
  `RadicalProperty quartetB quartetQ` **non-vacuously** — the proof derives
  `y 1 = 0` from the closedness hypothesis `Q y = 0` and uses it, unlike the
  prior witness whose radical held by `simp` without touching `hy`.
  `quartet_e2_eigen` gives eigenvalue `4/25` and the bundled last conjunct gives
  class cost `4/25` for every exact representative via `class_cost_constant`.

- **F4 (missing positivity): PARTIALLY CLOSED** by
  `PositiveHodgePhysicalMass.class_mass_nonneg`. It proves `0 ≤ mu2` from the
  genuine ghost-positivity applied to `h` itself (`hpos : 0 ≤ B h (S h)` with
  `B h h = 1`) — exactly the hypothesis the prior audit said was needed and
  absent. It is CONDITIONAL on `hpos` (as it must be); positivity is still not
  unconditional, and no theorem yet shows the quartet's `S` is
  `B`-positive-semidefinite on all closed vectors. So the mechanism is closed,
  the unconditional claim is not.

- **Well-definedness "next theorem (a)": CLOSED** by
  `PositiveHodgePhysicalMass.class_mass_wellDefined`. Two normalized closed
  eigen-representatives in the same class have equal eigenvalue; proof feeds
  `class_cost_constant` and the `h'`-side cost computation into `linarith`.
  Genuine, non-vacuous. (Minor: `hcl'` decorative, F4 above.)

- **F1 (Rayleigh normalization gap): OPEN / not addressed here.** These modules
  do not touch the Rayleigh quotient `B v (S v) / B v v`; they build on the
  already-corrected `class_cost_constant` story rather than re-stating the
  variational functional. Not a regression, but the normalization defect of the
  Rayleigh module is out of scope of the new code.

- **F5 (one-sided radicality / cosmetic normalization): OPEN (minor).** Same
  cosmetic footprint recurs (F4 above); no cleanup applied.

- **F6 (Rayleigh docstring overclaim): OPEN / out of scope.**

### Prior composition audit (`PriorCompositionAudit.md`)

- **B-F2 (hollow "missing-dictionary control"): CLOSED** by
  `CanonicalGramTurnDictionary.bridge_equality_iff_massSq_eq` (fixed pair at
  `m0` matches turn channel at `m1` **iff** `m0^2 = m1^2`) and
  `bridge_equality_iff_scale_eq_of_nonneg` (on nonnegative scales, **iff**
  `m0 = m1`). This is precisely the stronger control the prior audit demanded
  ("fix the pair `edge0, edge1 m0` and show the bridge forces the turn scale to
  equal `m0`"). `fixed_pair_cannot_encode_two_turn_scales` now derives its
  contradiction *through* the genuine `iff`, so it is no longer a decorated
  `¬P2`. Squared-scale uniqueness and nonnegative-scale uniqueness are both
  present and non-vacuous (`rational_dictionary_witness` at `m=3/5`, coefficient
  `9/25 ≠ 0`, excludes the `m=0` collapse).

- **B-F4 (turn count not checked): CLOSED** by explicit conjuncts in
  `CheckerboardAmplitudeGluing.two_segment_turn_gluing_witness`:
  `turnCount right [right, left] = 1`, `turnCount left [right] = 1`, and
  `turnCount right ([right, left] ++ [right]) = 2` (all `by decide`). This
  verifies the "counts a turn at the gluing boundary exactly once" claim
  concretely: `1 + 1 = 2`, boundary turn `left→right` counted once. The two
  `≠ 0` clauses still exclude `m = 0` and straight-only histories. (First
  conjunct still re-exports `pathAmplitude_append`; see F4.) The general laws
  `pathWeight_append`/`pathAmplitude_append` are clean and unchanged.

- **B-F5 (supplied scale dictionary, not derived arrow): PARTIALLY CLOSED /
  still supplied.** `free_mass_operator_eq_complexified_turn` is unchanged and
  remains a **supplied** dictionary (same `m` inserted on both sides), honestly
  disclosed. The new `iff` theorems sharpen *what the dictionary determines*
  but do not derive it from primitive histories; that derivation remains OPEN
  (disclosed).

- **C continuum (pointwise → uniform): PARTIALLY CLOSED** by
  `BoundedMomentumManyStepContinuum.fixed_time_many_step_bound_on_box`. Genuine
  uniformity of the `Dbox·t^2/n` rate over the bounded box (upgrade from the
  pointwise `Dkm`), via the monotone bound `Dkm_le_Dbox`. Not a PDE (F3 above).

---

## 3. Vacuity / hidden-assumption / false-shape / normalization checks

- **Vacuity.** No new theorem is vacuous. `class_mass_wellDefined` and
  `class_mass_nonneg` have satisfiable hypotheses (the quartet satisfies them:
  `qe2` is closed, eigen `4/25`, `B qe2 qe2 = 1`, `B qe2 (S qe2) = 4/25 ≥ 0`).
  The continuum `iff`/box theorems are guarded by `0 < n`, `|t/n| ≤ 1`,
  `0 ≤ K, M` — all satisfiable and satisfied on the limit tail. The gluing
  witness is a concrete finite computation.
- **Hidden assumptions.** The only substantive hidden/assumed content is
  `hmu : mu2 = m^2` (F2) and the supplied dictionary (B-F5). Both disclosed.
  `RadicalProperty` is an upstream definition not visible here; the quartet's
  `quartet_radical` proof clearly consumes closedness, so the property is used
  in its intended (non-trivial) direction — but the exact upstream statement of
  `RadicalProperty` could not be re-verified locally.
- **False shape.** Conclusions match prose. The quartet Gram is genuinely
  nondegenerate and indefinite; the `iff`s are genuine biconditionals; the box
  bound uses a single constant independent of `(k,m)`; the turn counts are
  literal equalities.
- **Normalization.** `class_mass_wellDefined`/`class_mass_nonneg` correctly
  normalize with `B h h = 1`. `canonical_plucker_mass` correctly yields `m^2`
  (not `m` or `|m|`); the sign ambiguity is honestly flagged and is why
  `bridge_equality_iff_massSq_eq` gives `m0^2 = m1^2` and the `_of_nonneg`
  refinement is needed for `m0 = m1`.
- **Degenerate forms.** The prior degeneracy is repaired in the quartet; but the
  degenerate witness is still the one used by the mass bridge (F1).
- **Docstring overreach.** Continuum and Gram-turn docstrings are honest.
  The bridge docstring's "two already-landed witness families … on one shared
  value" is technically true but obscures that the *nondegenerate* family is
  not the one used (F1). No hard overclaim, but a misleading emphasis.

---

## 4. Strongest manuscript paragraph now supported

> Under the genuine cohomological hypotheses `Q² = 0`, Kugo–Ojima radicality,
> and descent `[S,Q] = 0`, the constraint-cohomology spectral cost is a
> well-defined function of the class: any two normalized closed eigen-
> representatives of the same class carry the same eigenvalue `μ²`
> (`class_mass_wellDefined`), and that eigenvalue is nonnegative whenever the
> decoder is ghost-positive on the harmonic representative
> (`class_mass_nonneg`). These hypotheses are jointly realizable on a genuinely
> nondegenerate, indefinite Krein form: the four-dimensional quartet with Gram
> `diag`-block `[[0,1],[1,0]] ⊕ [1] ⊕ [-1]` exhibits an exact null direction
> `e0 = Q e1` that pairs nontrivially with its non-closed partner `e1`
> (`quartetB e0 e1 = 1`, not globally null), a positive physical class `e2`
> with class cost exactly `4/25`, and a negative Krein direction `e3`
> (`nondegenerate_quartet_witness`). Independently, on the finite `2×2` symbol
> the split-step walk converges to the exact fixed-momentum Dirac flow at rate
> `Dbox(K,M)·t²/n`, uniformly over every bounded momentum–mass box `|k|≤K,
> |m|≤M` (`fixed_time_many_step_bound_on_box`).

Not yet supported (must remain explicitly conditional/assumed): that `μ²` equals
the physical Pluecker/turn mass-squared `m²` (assumed via `hmu`); unconditional
positivity; that the nondegenerate quartet — rather than the degenerate
`diag(0,1,1)` witness — realizes the shared `4/25` mass; and any position-space
or PDE continuum limit.

## 5. Single next exact theorem

Wire the **nondegenerate quartet** (not the degenerate witness) to the Pluecker
mass, so the F3 repair actually reaches the mass bridge and closes F1:

```lean
-- in a module importing PositiveHodgePhysicalMass and CanonicalGramTurnDictionary
theorem quartet_class_cost_eq_canonical_plucker
    (chi : PositiveHodgePhysicalMass.Quartet) :
    ((PositiveHodgePhysicalMass.quartetB
        (PositiveHodgePhysicalMass.qe2 + PositiveHodgePhysicalMass.quartetQ chi)
        (PositiveHodgePhysicalMass.quartetS
          (PositiveHodgePhysicalMass.qe2 + PositiveHodgePhysicalMass.quartetQ chi))
        : ℝ) : ℂ)
      = CanonicalGramTurnDictionary.complexAbsSq
          (spinorWedge CanonicalGramTurnDictionary.edge0
            (CanonicalGramTurnDictionary.edge1 (2 / 5))) := by
  rw [(PositiveHodgePhysicalMass.nondegenerate_quartet_witness).2.2.2.2.2.2.2.2 chi,
      CanonicalGramTurnDictionary.canonical_plucker_mass]; norm_num
```

This is a finite, exact composition of two already-landed identities; proving it
makes the `4/25` fixture genuinely shared by the **nondegenerate** Hodge quartet
and the canonical spinor pair, and is the immediate prerequisite before any
attempt to *derive* (rather than assume) `μ² = m²`.
