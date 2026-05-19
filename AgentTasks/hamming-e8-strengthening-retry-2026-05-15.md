# Hamming E8 strengthening retry jobs - 2026-05-15

Status: three completed jobs integrated; one retry failed; one separate SPL
theta bridge job is still running.

Purpose: retry the two internal-error failures from the previous Aristotle
wave, and submit two focused follow-up jobs made possible by the promoted
theta-convolution theorem.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-strengthening-retry-20260515-project
```

This is a fresh source-only package containing:

- `PhysicsSM/`
- `PhysicsSM.lean`
- `PhysicsSMDraft.lean`
- `PhysicsSMSPL.lean`
- `lean-toolchain`
- the SPL-free Aristotle `lakefile.toml`
- `lake-manifest.json`
- `AGENTS.md`
- `README.md`

The package intentionally excludes `.lake`, `.git`, `AgentTasks`, and old
Aristotle output. A package-local `.lake` was created only for smoke testing
and removed before submission.

## Local package verification

The following package-local checks passed. Warnings were expected draft `sorry`
warnings and preexisting linter noise.

```text
lake build PhysicsSM
lake build PhysicsSM.Draft.E8RootSemanticAristotle \
  PhysicsSM.Draft.E8WeylSemanticAristotle \
  PhysicsSM.Draft.E8ThetaModularAristotle \
  PhysicsSM.Draft.ConstructionAThetaNoNativeAristotle \
  PhysicsSM.Draft.ConstructionAThetaBoundedShellAristotle
```

## Submitted jobs and results

| Job | Primary file | Aristotle ID | Current status |
|-----|--------------|--------------|----------------|
| C retry: semantic Weyl-reflection closure | `PhysicsSM/Draft/E8WeylSemanticAristotle.lean` | `1af5acbe-09e1-4371-b225-273181ee0655` | failed |
| Full theta retry: modular route | `PhysicsSM/Draft/E8ThetaModularAristotle.lean` | `d2f72efe-37e7-461f-8c11-a2b2383cb508` | complete, integrated |
| Theta grouping: remove final finite grouping step | `PhysicsSM/Draft/ConstructionAThetaNoNativeAristotle.lean` | `38c802a4-5b9d-4637-a6b6-f818f8506452` | complete with errors; useful proof integrated |
| Theta bounded-shell bridge | `PhysicsSM/Draft/ConstructionAThetaBoundedShellAristotle.lean` | `fabe95d3-e213-4533-b479-13db27092d76` | complete, integrated |

## Result retrieval and integration

Results downloaded on 2026-05-15:

```text
aristotle result fabe95d3-e213-4533-b479-13db27092d76 \
  --destination AgentTasks/aristotle-output/hamming-e8-strengthening-bounded-shell-20260515-result

aristotle result d2f72efe-37e7-461f-8c11-a2b2383cb508 \
  --destination AgentTasks/aristotle-output/hamming-e8-strengthening-theta-full-retry-20260515-result

aristotle result 38c802a4-5b9d-4637-a6b6-f818f8506452 \
  --destination AgentTasks/aristotle-output/hamming-e8-strengthening-theta-grouping-20260515-result
```

The bounded-shell job proved all four primary shell-cardinality bridges.  The
raw result locally copied `constructionAShellSet`; during integration the proof
was adapted to reuse the canonical definition from
`PhysicsSM.Coding.ConstructionAThetaConvolution`.

The full-theta retry did not prove the unconditional theorem.  It confirmed the
expected Mathlib blockers and replaced the `sorry` scaffold with a sorry-free
conditional theorem:

```lean
thetaSeries_eq_e4Series
    (h_modular : exists P, P thetaSeries /\ P e4Series /\ ...)
```

It also proved the constant coefficient comparison
`const_coeff_eq : coeff 0 thetaSeries = coeff 0 e4Series`, so the remaining
gap is exactly the analytic modular-forms input.

The theta-grouping job returned `COMPLETE_WITH_ERRORS`; the CLI reported that
it had trouble parsing the input, but the result archive still contained a
useful sorry-free proof of the requested Hamming weight-grouping targets.  The
proof was integrated into `PhysicsSM.Coding.ConstructionAThetaConvolution`, and
`PhysicsSM.Draft.ConstructionAThetaNoNativeAristotle` is now only a provenance
wrapper pointing back to the promoted declarations.

The Aristotle sandbox also changed
`PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean` by truncating later
range-7 material to avoid a stack-overflow issue in that environment.  That
sandbox-only workaround was not integrated: it would discard existing theta
coefficient material, and the live checkout builds the convolution module
without needing that truncation.

## Target summaries

### C retry: Weyl semantic closure

Original main target:

```lean
theorem PhysicsSM.Algebra.Octonion.E8Root.reflectD_preserves_IsE8RootD_structural
    (r v : Fin 8 -> Int) (hr : IsE8RootD r) (hv : IsE8RootD v) :
    IsE8RootD (reflectD r v)
```

Retry improvement: the package now imports the successful semantic root
classification theorem `isE8RootD_iff_type1_or_type2_structural`, giving
Aristotle a type-I/type-II case-split route in addition to the direct
quadratic reflection route.

### Full theta retry

Main target:

```lean
theorem PhysicsSM.Coding.E8ThetaAristotle.thetaSeries_eq_e4Series :
    thetaSeries = e4Series
```

If pinned Mathlib still lacks the necessary modular-forms dimension-one API,
the requested fallback is a precise conditional theorem isolating the missing
facts.

Result: Aristotle produced the requested fallback.  The integrated theorem is
conditional on the existence of a predicate `P` representing the shared
weight-4 level-one q-expansion property and uniqueness from the constant
coefficient.  The constant-coefficient equality is proved in Lean.

### Theta grouping

Main targets:

```lean
theorem PhysicsSM.Coding.hammingCodewords_filter_weight_card
theorem PhysicsSM.Coding.hammingCodewords_sum_by_weight_classes
theorem PhysicsSM.Coding.constructionAShellCount_eq_weight_distribution_convolution_grouped
```

Goal: replace the last `native_decide` grouping step in
`constructionAShellCount_eq_weight_distribution_convolution` with a proof from
the existing Hamming weight-distribution API.

Result: Aristotle proved all three targets.  The first two were promoted as
reusable trusted lemmas in
`PhysicsSM.Coding.ConstructionAThetaConvolution`, and the stable public theorem
`constructionAShellCount_eq_weight_distribution_convolution` now delegates to
the new grouped theorem instead of carrying its old theorem-local finite
search.

### Theta bounded-shell bridge

Main targets:

```lean
theorem PhysicsSM.Coding.constructionAShellSet_ncard_eq_shellCountRange5_zero
theorem PhysicsSM.Coding.constructionAShellSet_ncard_eq_shellCountRange5_four
theorem PhysicsSM.Coding.constructionAShellSet_ncard_eq_shellCountRange5_eight
theorem PhysicsSM.Coding.constructionAShellSet_ncard_eq_shellCountRange7_twelve
```

Goal: identify the new unbounded shell set used by the general convolution
theorem with the older bounded finite enumerators used by the first theta
coefficient files.

Result: all four targets are proved in
`PhysicsSM/Draft/ConstructionAThetaBoundedShellAristotle.lean`. The proof uses
coordinate bounds from the small squared norms and injectivity of the finite
coordinate tables.

## Local verification after integrating completed jobs

```text
lake build PhysicsSM.Draft.E8ThetaModularAristotle
lake build PhysicsSM.Draft.ConstructionAThetaBoundedShellAristotle
lake build PhysicsSMDraft
lake build
pre-commit run --all-files
rg -n "\b(sorry|admit|axiom)\b|unsafe" \
  PhysicsSM/Draft/ConstructionAThetaBoundedShellAristotle.lean \
  PhysicsSM/Draft/E8ThetaModularAristotle.lean
```

Result: all builds and pre-commit passed. The final `rg` check returned no
hits in the two newly integrated Aristotle result files. The broader
`PhysicsSMDraft` build still reports the expected preexisting `sorry` warnings
from older draft files, notably `E8ThetaSeriesMoonshot.lean` and
`E8EvenUnimodularUniqueness.lean`; those are unrelated to these two integrated
jobs.

Additional checks after integrating the `COMPLETE_WITH_ERRORS` theta-grouping
job:

```text
lake env lean \
  AgentTasks/aristotle-output/hamming-e8-strengthening-theta-grouping-20260515-extracted/hamming-e8-strengthening-retry-20260515-project_aristotle/PhysicsSM/Draft/ConstructionAThetaNoNativeAristotle.lean
lake env lean PhysicsSM/Coding/ConstructionAThetaConvolution.lean
lake build PhysicsSM.Coding.ConstructionAThetaConvolution
lake env lean PhysicsSM/Draft/ConstructionAThetaNoNativeAristotle.lean
lake build PhysicsSM.Draft.ConstructionAThetaNoNativeAristotle
lake build PhysicsSMDraft
lake build
pre-commit run --all-files
```

Result: all additional checks passed.  The `PhysicsSMDraft` and full `lake
build` commands still emit the same class of preexisting linter warnings and
older draft `sorry` warnings described above.
