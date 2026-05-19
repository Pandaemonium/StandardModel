# Codex handoff context: Hamming Construction A E8

Date: 2026-05-16.

Purpose: preserve the working context for the Hamming `[8,4,4]` to E8
Construction A manuscript and Lean formalization so a future Codex session can
resume quickly.

## Current high-level state

The project has a working Lean route from the extended Hamming code through
Construction A shell counts toward the E8 theta-series identity.  The most
recent work focused on the theta-series endpoint:

```text
Theta_E8 = E4
```

in the project-local formal power series model.

The important current split is:

1. The Sphere-Packing-Lean/SPL modular-form side is now connected to the
   normalized `E4` q-expansion.
2. The project Construction A/Hamming side has a formal convolution expression
   for the coefficients.
3. The remaining gap is the all-coefficient theorem saying that this Hamming
   Construction A convolution equals the classical `E4` coefficient formula
   `1` at `n = 0` and `240 * sigma3 n` for `n > 0`.

In Lean, the remaining target is:

```lean
theorem PhysicsSM.Coding.E8ThetaSPLBridge
    .hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

This theorem currently lives in draft/handoff code with one intentional
`sorry`.

## Key files

Core and draft Lean files:

- `PhysicsSM/Coding/ConstructionAThetaConvolution.lean`
- `PhysicsSM/Draft/ConstructionAThetaBoundedShellAristotle.lean`
- `PhysicsSM/Draft/ConstructionAThetaNoNativeAristotle.lean`
- `PhysicsSM/Draft/E8ThetaModularAristotle.lean`
- `PhysicsSM/Draft/E8ThetaSPLBridge.lean`
- `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean`
- `PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean`
- `PhysicsSMDraft.lean`
- `PhysicsSMSPL.lean`

Task/provenance notes:

- `AgentTasks/hamming-e8-spl-theta-bridge-aristotle-2026-05-15.md`
- `AgentTasks/hamming-e8-theta-coeff-gap-aristotle-2026-05-16.md`
- `AgentTasks/hamming-e8-theta-weight-enumerator-bridge-aristotle-2026-05-16.md`
- `AgentTasks/hamming-e8-strengthening-retry-2026-05-15.md`
- `AgentTasks/hamming-e8-structural-AE-aristotle-2026-05-15.md`
- `Sources/Hamming_E8_Zotero_Source_Map.md`
- `Sources/Hamming_ConstructionA_E8_Manuscript_Draft.md`

The optional SPL root is `PhysicsSMSPL.lean`.  The default trusted root
`PhysicsSM.lean` remains separate from the direct SPL bridge.

## Recent integrated Aristotle output

### Job `9215f082-2baa-4e13-837c-9335ddf88aad`

Status: `COMPLETE_WITH_ERRORS`.

Output downloaded to:

```text
AgentTasks/aristotle-output/hamming-e8-spl-theta-bridge-20260516-result
AgentTasks/aristotle-output/hamming-e8-spl-theta-bridge-20260516-extracted/
```

Useful theorem integrated into `PhysicsSM/Draft/E8ThetaSPLBridge.lean`:

```lean
theorem splThetaE4Series_coeff_eq_e4 (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      if n = 0 then 1 else (240 : Complex) * (ArithmeticFunction.sigma 3 n : Complex)
```

Also added locally:

```lean
theorem splThetaE4Series_coeff_eq_local_e4 (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      if n = 0 then 1 else (240 : Complex) * (sigma3 n : Complex)

theorem thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff
    (hcount : forall n : Nat,
      hammingThetaConvolutionCoeff n =
        if n = 0 then 1 else 240 * sigma3 n) :
    E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series
```

Interpretation: SPL and the local bridge now know that the SPL theta-polynomial
has the right Eisenstein coefficients.  What remains is not the modular-form
side; it is the project-local all-coefficient Construction A count.

### Follow-up job `a9a170c1-b4ec-4a0e-8468-ca2db69e6f75`

Status: `COMPLETE_WITH_ERRORS`.

Submitted from:

```text
AgentTasks/aristotle-submit/hamming-e8-theta-coeff-gap-20260516-project
```

Target file:

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

Main target:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

Fallback requested from Aristotle if the full theorem is too hard:

- prove a conditional theorem isolating the needed one-dimensional even/odd
  theta q-expansion facts; or
- prove a formal power-series theorem that the Hamming weight-enumerator
  convolution is the q-expansion of `SpherePacking.ModularForms.thetaE4`.

To check status later:

```powershell
aristotle list
aristotle result a9a170c1-b4ec-4a0e-8468-ca2db69e6f75 --destination AgentTasks/aristotle-output/hamming-e8-theta-coeff-gap-20260516-result
```

Useful returned output has now been integrated into
`PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean`:

```lean
theorem hammingThetaConvolutionCoeff_two :
    hammingThetaConvolutionCoeff 2 = 240 * sigma3 2

theorem hammingThetaConvolutionCoeff_three :
    hammingThetaConvolutionCoeff 3 = 240 * sigma3 3

theorem hammingThetaConvolutionCoeff_le_three (n : Nat) (hn : n <= 3) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n

theorem hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq
    (heq : E8ThetaAristotle.thetaSeries = E8ThetaAristotle.e4Series) (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

The main all-`n` theorem still has one intentional draft `sorry`.

### New weight-enumerator bridge job `bf905d04-b40c-43b1-9449-8cebc7fbe995`

Status at handoff: `IN_PROGRESS`, 1%.

Submitted from:

```text
AgentTasks/aristotle-submit/hamming-e8-theta-weight-enumerator-bridge-20260516-project
```

Task note:

```text
AgentTasks/hamming-e8-theta-weight-enumerator-bridge-aristotle-2026-05-16.md
```

Target file:

```text
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
```

Primary target:

```lean
theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex)
```

Fallback target:

```lean
theorem weightContribFormalSeries_coeff (w s : Nat) :
    PowerSeries.coeff s (weightContribFormalSeries w) =
      weightContribConvolution w s
```

The new file already proves:

```lean
theorem hammingWeightEnumeratorFormalSeries_coeff (n : Nat) :
    PowerSeries.coeff (4 * n) hammingWeightEnumeratorFormalSeries =
      hammingThetaConvolutionCoeff n
```

The job prompt includes the literature route: Construction A theta series as
weight-enumerator substitution, the extended Hamming weight enumerator
`x^8 + 14*x^4*y^4 + y^8`, and the SPL theta polynomial already identified
with `E4`.

## Current Lean theorem picture

In `PhysicsSM/Draft/E8ThetaSPLBridge.lean`:

- `intSeriesToComplex` casts `PowerSeries Int` coefficientwise to
  `PowerSeries Complex`.
- `intSeriesToComplex_injective` lets us prove integer series equality by
  proving complex coefficient equality.
- `localE4SeriesComplex_eq_splE4Series` proves the project local `e4Series`
  matches SPL's `E4` q-expansion after casting.
- `splE4Series_eq_splThetaE4Series` uses SPL's analytic identity
  `SpherePacking.ModularForms.E4_eq_thetaE4` (Unicode in source:
  `E4_eq_thetaE4`).
- `splThetaE4Series_coeff_eq_local_e4` gives the SPL theta-polynomial
  coefficients in project-local `sigma3` form.
- `hammingThetaConvolutionCoeff` is the Hamming/Construction A coefficient
  expression:

```lean
extendedHamming8WeightDist 0 * weightContribConvolution 0 (4 * n) +
extendedHamming8WeightDist 4 * weightContribConvolution 4 (4 * n) +
extendedHamming8WeightDist 8 * weightContribConvolution 8 (4 * n)
```

- `constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff` identifies the
  unbounded Construction A shell count at unscaled norm `4*n` with that
  convolution.
- `thetaSeries_eq_e4Series_of_hammingThetaConvolutionCoeff_eq_e4Coeff` is the
  clean reduction theorem for the full theta identity.

In `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean`:

- `hammingThetaConvolutionCoeff_zero` is proved.
- `hammingThetaConvolutionCoeff_one` is proved.
- `hammingThetaConvolutionCoeff_two` is proved.
- `hammingThetaConvolutionCoeff_three` is proved.
- `hammingThetaConvolutionCoeff_le_three` is proved.
- `hammingThetaConvolutionCoeff_eq_e4Coeff_of_series_eq` is proved.
- `hammingThetaConvolutionCoeff_eq_e4Coeff` is intentionally `sorry`.
- `thetaSeries_eq_e4Series_from_hammingThetaConvolutionCoeff` closes once that
  theorem is filled.

In `PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean`:

- `parityLiftCoeff`, `parityLiftSeries`, and `weightContribFormalSeries` define
  the formal one-dimensional parity theta series product.
- `hammingWeightEnumeratorFormalSeries` encodes
  `even^8 + 14*even^4*odd^4 + odd^8` through the existing Hamming weight
  distribution.
- `hammingWeightEnumeratorFormalSeries_coeff` is proved.
- `weightContribFormalSeries_coeff` and
  `splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff` are intentionally
  `sorry` in draft code for Aristotle.

## Literature and public Lean search

Most recent search result:

- No public Lean proof was found for the exact all-coefficient Hamming
  Construction A formula.
- Sphere-Packing-Lean already has the modular-form/theta-polynomial identity
  we need on the analytic side.
- Mathlib has useful modular-form q-expansion infrastructure, but no ready-made
  Construction A weight-enumerator theorem for this specific bridge.

Useful public references recorded in `Sources/Hamming_E8_Zotero_Source_Map.md`:

- Error Correction Zoo E8 page:
  `https://errorcorrectionzoo.org/c/eeight`.
- Nebe-Sloane E8 code catalogue:
  `https://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/E8_code.html`.
- OEIS A004009:
  `https://oeis.org/A004009`.
- Sphere-Packing-Lean blueprint:
  `https://thefundamentaltheor3m.github.io/Sphere-Packing-Lean/blueprint.pdf`.
- Mathlib Eisenstein q-expansion docs:
  `https://leanprover-community.github.io/mathlib4_docs/Mathlib/NumberTheory/ModularForms/EisensteinSeries/QExpansion.html`.

Zotero searches on 2026-05-16 for:

- `Conway Sloane Sphere Packings Lattices Groups E8 theta series`
- `Ebeling Lattices Codes E8 theta series`
- `Serre Course Arithmetic Eisenstein E4 theta E8`
- `Jacobi eight squares theorem E8 sigma_3`

found no new local Zotero items.  The existing source map is still the
bibliography baseline; exact page/theorem references are still needed before
final manuscript submission.

## Build and verification status

Recent successful commands from the live checkout:

```powershell
lake env lean PhysicsSM/Draft/E8ThetaSPLBridge.lean
lake env lean PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
lake build PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
lake env lean PhysicsSMDraft.lean
lake env lean PhysicsSMSPL.lean
lake build
lake build PhysicsSMSPL
pre-commit run --all-files
```

Notes:

- `lake env lean PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean` passes with the
  expected draft `sorry` warning.
- `lake build PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle` passes
  with the two expected draft `sorry` warnings in the new bridge file.
- `lake env lean PhysicsSMDraft.lean` passes after importing the new bridge
  file.
- `lake build` passed.
- `lake build PhysicsSMSPL` passed.
- `pre-commit run --all-files` passed.
- A clean build inside the source-only Aristotle submission package tried to
  rebuild mathlib from scratch and was stopped; this is not a live-check
  failure.

`lakefile.toml` now gives all three local Lean libraries a larger stack:

```toml
moreLeanArgs = ["-s65536"]
```

This was copied from the Aristotle result because heavy certified finite
enumerations and the SPL theta bridge can overflow Lean's default stack.

## Worktree caution

The worktree is intentionally dirty with many files from recent Aristotle
integrations and draft scaffolds.  Do not revert unrelated changes.  Recent
untracked/draft files include:

- `PhysicsSM/Coding/ConstructionAThetaConvolution.lean`
- `PhysicsSM/Draft/E8ThetaSPLBridge.lean`
- `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean`
- `PhysicsSMDraft.lean`
- `PhysicsSMSPL.lean`
- multiple `AgentTasks/hamming-e8-*.md` notes

Future sessions should inspect `git status --short` before editing and should
avoid broad cleanup unless explicitly requested.

## Suggested next steps

1. Check Aristotle job `a9a170c1-b4ec-4a0e-8468-ca2db69e6f75`.
2. If it completed, review the result before integrating.
3. If it proves `hammingThetaConvolutionCoeff_eq_e4Coeff`, insert the proof in
   `PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean` or promote the theorem to
   the appropriate bridge file, then run:

```powershell
lake env lean PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
lake build PhysicsSMSPL
lake build
pre-commit run --all-files
```

4. If Aristotle only returns a partial theorem, integrate the partial theorem
   if it is clean and use it to scaffold the next smaller job.  The most useful
   partial result would be a power-series/product theorem connecting the
   Hamming weight-enumerator convolution to `splThetaE4Series`.
5. Update `Sources/Hamming_ConstructionA_E8_Manuscript_Draft.md` after the Lean
   status changes.  The manuscript should state the current theorem boundary
   honestly: the finite Hamming/Construction A bridge is strong, the SPL `E4`
   side is connected, and the all-coefficient formula is still draft until the
   final `sorry` is removed.

## Important convention reminder

The project theta index `n` corresponds to unscaled integer Construction A
shell `sqNorm = 4*n`.  This normalization is easy to get wrong.  The bridge
lemmas deliberately phrase the Construction A shell count at `4 * n` before
comparing it with the local formal `E4` coefficients.
