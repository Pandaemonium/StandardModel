# D-R3 arbitrary-`L2` regularity and sampler boundary — focused audit report

Review-only audit. No source files were edited and no broad build was run.
The only verification actions taken were lightweight signature/type checks
against the pinned Mathlib to confirm the exact API used by the sources.

Sources reviewed:

- `PhysicsSM/Draft/NullEdge/ChangingMomentumCellSampling.lean` (landed sampler).
- `PhysicsSM/Draft/NullEdge/ChangingMomentumL2Density.lean` (landed regularity bridge).
- `AgentTasks/aristotle-targets/codex_24h_d_point_sampler_l2_nogo.lean` (no-go **target**, all `sorry`).
- `AgentTasks/24h-publication-run-2026-07-12/D_R3_SHANNON_BRIDGE_PROGRAM.md`, §D-R3-4.
- `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`,
  paragraph around `\label{eq:cellsamplingrate}` (lines ~1195–1232).

Environment facts confirmed by focused type checks (pinned Mathlib):

- `ContDiff : … → WithTop ℕ∞ → (E → F) → Prop`.
- In `WithTop ℕ∞`, `↑(⊤ : ENat) < (⊤ : WithTop ℕ∞)` (checked by `decide`); they are
  distinct.
- `MeasureTheory.MemLp.exist_eLpNorm_sub_le` returns `HasCompactSupport g ∧ ContDiff ℝ (↑⊤) g ∧ eLpNorm (f - g) p μ ≤ ENNReal.ofReal ε`, i.e. the **C^∞** order `↑⊤`, not analytic `⊤`.
- `MeasureTheory.MemLp.exists_hasCompactSupport_integral_rpow_sub_le` returns
  `HasCompactSupport g ∧ ∫ ‖f x - g x‖^p ≤ ε ∧ Continuous g ∧ MemLp g …`.
- `ContDiff.lipschitzWith_of_hasCompactSupport : HasCompactSupport f → ContDiff 𝕂 n f → n ≠ 0 → ∃ C, LipschitzWith C f`.

---

## Verdict 1 — Is `↑(⊤ : ENat)` correctly distinguished from outer `⊤`?

**YES — correctly distinguished, and the labeling is accurate.**

`ContDiff`'s smoothness parameter has type `WithTop ℕ∞ = WithTop (WithTop ℕ)`.
Here `ENat = ℕ∞ = WithTop ℕ`, so:

- `↑(⊤ : ENat)` is the image of `∞ : ℕ∞` under the coercion into `WithTop ℕ∞`;
  this is the **C^∞ (infinitely differentiable)** order — the standard notion of
  smoothness.
- `(⊤ : WithTop ℕ∞)` is the top of the outer `WithTop`, i.e. the **C^ω
  (analytic)** order — strictly stronger.

The strict inequality `↑(⊤ : ENat) < (⊤ : WithTop ℕ∞)` holds (`decide`), so these
are genuinely different orders. The file uses each correctly:

- `compactSupport_contDiff_infty_exists_global_lipschitz` takes
  `ContDiff Real (↑(⊤ : ENat)) g` and its docstring calls it "standard smoothness
  (`C^infinity`)". **Accurate.**
- `memLp_exists_contDiff_compact_eLpNorm_approx` returns `ContDiff Real (↑(⊤ : ENat)) g`,
  which is exactly the order Mathlib's `exist_eLpNorm_sub_le` produces (`↑⊤`).
  **Faithful to the underlying theorem** — no silent strengthening.
- `quadraticAxis_contDiff : ContDiff Real ⊤ quadraticAxis` uses the outer analytic
  `⊤`; this is *true* (a polynomial is analytic) and strictly stronger than needed,
  so it is sound, though the boundary lemma only consumes C^∞. It is not
  mislabeled because it carries no "standard smoothness" docstring claim; it is a
  legitimately stronger statement of a fact about a polynomial.

The separate helper `compactSupport_contDiff_exists_global_lipschitz` (with outer
`⊤`) coexists with the `↑(⊤ : ENat)` version; both are true and used for the two
different orders. No confusion between the two orders is present.

---

## Verdict 2 — Does the composed approximant theorem return one C.S. smooth globally-Lipschitz function with the stated `eLpNorm` error?

**YES.** `memLp_exists_compact_global_lipschitz_eLpNorm_approx` returns a single
witness `g` (and one constant `L`) carrying **all** of:

- `HasCompactSupport g`,
- `ContDiff Real (↑(⊤ : ENat)) g` (C^∞),
- `0 ≤ L`,
- `∀ x y, ‖g x - g y‖ ≤ L * ‖x - y‖` (a **global** Lipschitz bound, quantified over
  all `x y`, not a neighborhood/local statement),
- `eLpNorm (f - g) 2 volume ≤ ENNReal.ofReal ε`.

The proof obtains `g` once from `memLp_exists_contDiff_compact_eLpNorm_approx`
(compact support, C^∞, `eLpNorm` error) and extracts `L` from *that same* `g` via
`compactSupport_contDiff_infty_exists_global_lipschitz`. It is genuinely one
function satisfying every property simultaneously — not two different approximants
glued in the statement. The `eLpNorm` error is the exact `eLpNorm (f - g) 2 ≤ ofReal ε`
form, matching the manuscript's "arbitrarily small `L2` error" claim.

Load-bearing hypotheses are satisfiable (`MemLp f 2 volume`, `0 < ε`), so the
existential has content. **No defect.**

---

## Verdict 3 — Is the noncompact quadratic control valid and load-bearing?

**YES on both counts.**

`quadraticAxis x = (x 0 : Complex)^2`.

- *Valid.* `quadraticAxis_contDiff` (C^ω, hence C^∞) is correct — a coordinate
  polynomial is smooth. `quadraticAxis_not_global_lipschitz` is a correct disproof:
  for any candidate `(L, 0 ≤ L)` it picks `t = L + 1 > 0`, `x = t·e₀`, computes
  `‖x‖ = t` (sup norm) and `‖q(x) - q(0)‖ = t²`, so the hypothesized bound forces
  `t² ≤ L·t`, i.e. `t ≤ L = t - 1`, a contradiction. The `nlinarith` closes it.
  The norm computations (`pi_norm_le_iff_of_nonneg`, `norm_le_pi_norm`,
  `Complex.norm_real`) are used correctly.
- *Load-bearing.* It exhibits a smooth (indeed analytic) function that has **no**
  global Lipschitz constant, so the `HasCompactSupport` hypothesis in
  `compactSupport_contDiff_infty_exists_global_lipschitz` (and hence in the composed
  theorem) is not decorative: smoothness alone does not yield the global Lipschitz
  constant the cell sampler consumes. This exactly substantiates the manuscript /
  program sentence "Compact support is load-bearing." **Correct and non-redundant.**

---

## Verdict 4 — Does any landed theorem imply point sampling is bounded or AE-invariant on arbitrary `L2`? Flag every suggesting sentence.

**NO landed theorem implies this.** The landed results are confined to:

- (sampling module) point/center sampling of a **fixed compact-support Lipschitz**
  field, with an explicit squared-`L2` rate and a squeeze-to-zero limit under a
  *uniformly bounded represented volume* hypothesis; and
- (density module) existence of compact-support smooth globally-Lipschitz
  **approximants** to arbitrary `L2` data in `eLpNorm`.

Neither asserts that the point/center sampler is a bounded operator on `L2`, nor
that it is invariant under a.e. equality of arbitrary `L2` representatives. In fact
the intended no-go target proves the opposite (point sampling is *not* AE-invariant).

Sentences that could be **misread** as such a claim, flagged for wording care (none
are actual theorem statements, and each is elsewhere correctly qualified):

1. Program §D-R3-4 header: *"dense-core sampler and arbitrary-`L2` regularity bridge
   landed"*. Safe only because the same paragraph immediately restricts scope
   ("operator/live-flow composition still open") and later states the remaining gap
   is precisely "uniform `L2` boundedness of the finite-cell sampling operators."
   The word "arbitrary-`L2`" attaches to the *regularity/approximation* bridge, not
   to the sampler acting on `L2`.
2. No-go target file header: *"Close the analytic hinge between the landed
   compact-support Lipschitz sampler and arbitrary complex `L2(R^3)` momentum data."*
   Read literally this suggests the sampler extends to `L2`; the file's own content
   *refutes* an `L2` point sampler, so the header is describing the density bridge,
   not a sampler extension. Recommend rewording to avoid implying the sampler itself
   descends to `L2`.
3. Manuscript, `eq:cellsamplingrate` paragraph: *"This is strong `L^2(\mathbb R^3)`
   convergence for a compact-support Lipschitz dense core."* Correct as written — the
   qualifier "for a compact-support Lipschitz dense core" prevents overreach. The
   following sentence explicitly lists uniform `L2` boundedness of the sampler as
   *remaining* work, so no overclaim.

**Conclusion:** no landed theorem overreaches; the only risk is header prose in
the no-go target and the program that could be tightened. Flagged above.

---

## Verdict 5 — Are all seven point-sampler no-go target statements true as written?

**Status caveat (important):** all seven declarations in
`codex_24h_d_point_sampler_l2_nogo.lean` are currently `sorry`. They are therefore
**not yet kernel-checked**; the assessment below is of their *mathematical truth as
stated*, which is what "true as written" asks. Each is provable; none is false.

1. `pointSpike_ae_zero` — `pointSpike c =ᵐ[volume] 0`. **True.** `pointSpike c` is
   the indicator of the singleton `{c}`, which is Lebesgue-null in `R^3`, so it
   vanishes a.e.
2. `sampleFinite_pointSpike_center` (needs `0 < h`) — sampler at the cell center
   returns `1`. **True.** With `0 < h` the center lies in its own half-open cell
   (`cellCenter_mem`), so the single-cell indicator picks the sampled value
   `pointSpike (cellCenter h k) (cellCenter h k) = 1`.
3. `sampleFinite_zero_center` — sampler of the zero field is `0`. **True.** The
   sampled value is `0`, so the indicator sum is `0` (independent of `x`).
4. `sampleFinite_not_ae_invariant` (needs `0 < h`) — ∃ `f =ᵐ g` with different
   sampler outputs. **True.** Take `f = pointSpike (cellCenter h k)`, `g = 0`:
   a.e. equal by (1), yet outputs `1 ≠ 0` by (2),(3). This is the core obstruction.
5. `cellAverage_congr_ae` — `f =ᵐ g ⇒ cellAverage h k f = cellAverage h k g`.
   **True.** `cellAverage` is a normalized set integral over the cell; set integrals
   respect a.e. equality (`setIntegral_congr_ae` / `integral_congr_ae`), and scaling
   preserves this. This is the "cell averaging respects `L2` representatives" claim.
6. `cellAverage_pointSpike_zero` (no `0 < h` hypothesis) — average of the spike is
   `0`. **True.** The spike is a.e. `0`, so its integral over the cell is `0`, and
   `c • 0 = 0` for any normalization scalar `c`; truth does not require `0 < h`.
7. `cellAverage_const_one` (needs `0 < h`) — **normalized complex cell averaging.**
   `cellAverage h k (fun _ => 1) = 1`. **True.** With `0 < h`,
   `volume (momentumCell h k)` is finite and nonzero (`= h^3` via
   `volume_momentumCell_toReal`), and `∫_{cell} 1 = (volume cell).toReal`, so the
   normalization `(volume cell).toReal⁻¹ • (volume cell).toReal = 1`. The `0 < h`
   hypothesis is genuinely needed here (it is the nonzero/finite normalization
   witness); without it the factor could be `0` or `∞` and the identity would fail.

**Verdict:** all seven are true as written, including the normalized complex
cell-average normalization (item 7), which is the delicate one and is correctly
guarded by `0 < h`. They remain to be discharged (currently `sorry`).

---

## Verdict 6 — Smallest exact successor theorem for the cell-average finite projection

Define the finite cell-average projection (mirroring `sampleFinite`, but with the
`L2`-safe `cellAverage` in place of point evaluation):

```lean
def projectFinite (h : Real) (s : Finset Mode3) (f : Momentum3 → Complex) :
    Momentum3 → Complex :=
  fun x => ∑ k ∈ s, (momentumCell h k).indicator (fun _ => cellAverage h k f) x
```

The smallest exact successor theorem bundling (a) `L2`-representative invariance,
(b) a **nonzero normalization witness**, and (c) a **wrong-scaling control** is:

```lean
theorem projectFinite_ae_invariant_normalized_no_wrong_scaling
    {h : Real} (hh : 0 < h) (s : Finset Mode3) :
    -- (a) AE-invariance: the projection is well defined on L2 classes
    (∀ f g : Momentum3 → Complex, f =ᵐ[volume] g →
        projectFinite h s f = projectFinite h s g)
    -- (b) nonzero normalization witness: constants are reproduced exactly
    ∧ (∀ k ∈ s, cellAverage h k (fun _ => (1 : Complex)) = 1)
    -- (c) wrong-scaling control: the UNnormalized cell integral is NOT the
    --     normalization unless h = 1, so the volume⁻¹ factor is load-bearing
    ∧ (h ≠ 1 → ∀ k, (∫ x in momentumCell h k, (1 : Complex)) ≠ 1)
```

Justification of each conjunct, all reducing to already-stated no-go facts:

- (a) follows from `cellAverage_congr_ae` applied cellwise (finite sum of
  indicators of a common representative-independent scalar).
- (b) is exactly `cellAverage_const_one`; the value `1` is the nonzero
  normalization witness, valid because `volume (momentumCell h k) = h^3 ≠ 0` for
  `0 < h`.
- (c) is the wrong-scaling control analogous to the noncompact-quadratic
  load-bearing lemma: `∫_{cell} 1 = (volume cell).toReal = h^3`, which equals `1`
  iff `h = 1`; hence omitting the `(volume)⁻¹` normalization (or using the plain
  integral) fails to reproduce constants at any mesh `h ≠ 1`. This certifies that
  the normalization factor is not decorative.

This is the minimal theorem: it is the direct cell-average successor of
`sampleFinite_not_ae_invariant` (repairs invariance), it embeds the nonzero
normalization witness, and it pins the correct scaling by exhibiting the failure of
the unnormalized variant. Nothing smaller simultaneously certifies all three
required properties.

---

## Verdict 7 — Four overclaim checks

**Scope:** the landed modules
(`ChangingMomentumCellSampling`, `ChangingMomentumL2Density`) are complete and
carry `#print axioms` pins showing only `propext, Classical.choice, Quot.sound`.
The no-go file is a **target with all `sorry`**; that status materially affects
checks below.

### 7a. Vacuity
**Pass (no vacuity)** for the landed modules. Every hypothesis set is satisfiable:
`MemLp f 2 volume`/`0 < ε` (density theorems), `0 < h`, `0 ≤ L`, a Lipschitz field,
covering finite cells, uniformly bounded volume (sampler theorems). The Lipschitz
existentials have honest content (bump functions realize the hypotheses), and
`quadraticAxis_not_global_lipschitz` is a genuine negation, not a vacuous
implication. `sampleFinite_tendsto_sq_error_zero` is nonvacuous on the schedule
noted in its docstring. No theorem is true merely because its hypotheses are
unsatisfiable.

### 7b. Hollow telescoping
**Pass.** The composed theorem
`memLp_exists_compact_global_lipschitz_eLpNorm_approx` is not a re-export: it adds
the global Lipschitz conclusion to the Mathlib approximation output by threading the
*same* `g` through `compactSupport_contDiff_infty_exists_global_lipschitz`. The
sampler chain (`sampleFinite_pointwise_error → integral_sq_error_cellUnion_le →
integral_sq_error_global_le → sampleFinite_tendsto_sq_error_zero`) each step adds
real content (pointwise bound → local integral bound → global via support cover →
limit). No lemma merely restates its hypothesis.

### 7c. Docstring-outruns-kernel
**Pass for landed modules; FLAG for the no-go target and one program-prose point.**
- Landed docstrings match their kernel statements: "one global Lipschitz constant",
  "compactly supported smooth approximant in `eLpNorm`", "compact support is
  load-bearing", and the explicit squared-`L2` rate all correspond to the actual
  statements. The manuscript `eq:cellsamplingrate` bound matches
  `integral_sq_error_global_le` exactly.
- **FLAG:** the no-go target file's docstrings assert finished facts ("The point
  spike must remain zero almost everywhere while sampling to one", "The cell average
  must remain AE-invariant and normalize the constant-one function exactly") while
  **every declaration is `sorry`**. Here the docstring/prose *outruns the kernel*:
  the claims are true (Verdict 5) but not yet machine-checked. Any manuscript/program
  sentence citing these no-go results as "kernel-checked" would be premature until
  the `sorry`s are discharged. The program §D-R3-4 and the manuscript currently
  restrict their "kernel-checked" wording to the landed sampler/density results, so
  they are consistent; keep it that way and do not cite the no-go file as closed.

### 7d. False shape
**Pass.** Logical shapes match the intended claims:
- Global (not local) Lipschitz: `∀ x y, ‖g x - g y‖ ≤ L * ‖x - y‖`, correctly
  quantified over all points.
- One function, not two: the composed theorem binds a single `g` (Verdict 2).
- The `eLpNorm` error uses the genuine `eLpNorm (f - g) 2 ≤ ofReal ε` shape; the
  squared-integral theorem uses `∫ ‖·‖^2 ≤ card·h³·(Lh/2)²`, i.e. the shape printed
  in `eq:cellsamplingrate`.
- The load-bearing lemma is a true negation `¬ ∃ L, …`, not a weakened positive.
- Smoothness order carried is `↑(⊤ : ENat)` (C^∞), the honest order returned by
  Mathlib — no shape inflation to analytic `⊤` in the density chain.

---

## Summary

| # | Item | Verdict |
|---|------|---------|
| 1 | `↑(⊤:ENat)` vs outer `⊤` distinction | Correct; labeling accurate |
| 2 | Composed approximant: one C.S. smooth global-Lipschitz `g` with `eLpNorm` error | Yes, genuine |
| 3 | Noncompact quadratic control | Valid and load-bearing |
| 4 | Any landed theorem ⇒ point sampling bounded/AE-invariant on arbitrary `L2` | No; 3 prose sentences flagged for wording only |
| 5 | Seven no-go statements true as written | All true (incl. normalized cell average); but all currently `sorry` |
| 6 | Smallest cell-average finite-projection successor | Stated: AE-invariance + nonzero normalization witness + wrong-scaling control |
| 7a | Vacuity | Pass |
| 7b | Hollow telescoping | Pass |
| 7c | Docstring-outruns-kernel | Pass (landed); FLAG (no-go target is all `sorry`) |
| 7d | False shape | Pass |

**Overall:** the two landed modules are sound, faithfully labeled, and free of the
four overclaim failure modes; their axiom pins are clean. The single actionable item
is that the point-sampler no-go file is a target with all statements `sorry`: the
statements are mathematically true as written, but must be discharged before any
manuscript/program text cites the no-go/cell-average results as kernel-checked.
Header prose in the no-go target and program §D-R3-4 should avoid implying the point
sampler itself extends to arbitrary `L2` (it does not; that is the whole point of the
no-go).
