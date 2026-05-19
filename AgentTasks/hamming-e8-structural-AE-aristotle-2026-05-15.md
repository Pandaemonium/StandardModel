# Hamming E8 structural strengthening Aristotle jobs - 2026-05-15

Status: four jobs completed and integrated; one job failed internally and was
resubmitted in the follow-up retry wave.

Purpose: ask Aristotle to attack five structural replacements for finite
computation in the Hamming Construction A / E8 bridge.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-structural-AE-20260515-min-project
```

This is a minimal source-only package containing:

- `PhysicsSM/`
- `PhysicsSM.lean`
- `PhysicsSMDraft.lean`
- `PhysicsSMSPL.lean`
- `lean-toolchain`
- the SPL-free Aristotle `lakefile.toml`

The package intentionally excludes `.lake`, `.git`, `AgentTasks`, and old
Aristotle output.

## Local scaffold verification

The following checks passed in the live checkout with only intended `sorry`
warnings:

```text
lake env lean PhysicsSM/Draft/E8ShortVectorsStructuralAristotle.lean
lake env lean PhysicsSM/Draft/E8RootSemanticAristotle.lean
lake env lean PhysicsSM/Draft/E8WeylSemanticAristotle.lean
lake env lean PhysicsSM/Draft/HammingE8E8StructuralAristotle.lean
lake env lean PhysicsSM/Draft/ConstructionAThetaConvolutionAristotle.lean
```

A package-local smoke check was abandoned because an earlier copied `.lake`
directory contained stale dependency checkouts. The submitted package is the
fresh minimal source-only package listed above.

## Result retrieval and integration

Results were downloaded on 2026-05-15 with `aristotle result`.

The completed jobs were integrated as follows:

- Job A replaced `PhysicsSM/Draft/E8ShortVectorsStructuralAristotle.lean`.
- Job B added `PhysicsSM/Draft/E8RootSemanticHelpers.lean` and replaced
  `PhysicsSM/Draft/E8RootSemanticAristotle.lean`.
- Job D was promoted into `PhysicsSM/Coding/HammingE8E8.lean` through the new
  helper module `PhysicsSM/Coding/HammingE8E8Helpers.lean`; the draft file now
  keeps the original Aristotle wrapper names.
- Job E was promoted into `PhysicsSM/Coding/ConstructionAThetaConvolution.lean`
  through the new helper module
  `PhysicsSM/Coding/ConstructionAConvolutionHelpers.lean`. The draft file now
  keeps the original Aristotle provenance wrapper without local duplicate API
  definitions.

The failed Weyl-reflection job C and the earlier full-theta job both reported
only an Aristotle internal error through the CLI:

```text
ERROR - Project failed due to an internal error. The team at Harmonic has been notified; please try again.
```

No partial patch or mathematical counterexample was available from either
failed result.

Follow-up: job C was resubmitted on 2026-05-15 as
`1af5acbe-09e1-4371-b225-273181ee0655` using the refreshed package recorded in
`AgentTasks/hamming-e8-strengthening-retry-2026-05-15.md`.

## Submitted jobs

| Job | Primary file | Output/result directory | Aristotle ID | Final status |
|-----|--------------|------------------|--------------|----------------------|
| A: structural short-vector count | `PhysicsSM/Draft/E8ShortVectorsStructuralAristotle.lean` | `AgentTasks/aristotle-output/hamming-e8-structural-A-short-vectors-20260515-result` | `4732cf19-75dd-4ee8-95f2-79566d8b0b7f` | complete, integrated in draft |
| B: semantic root classification | `PhysicsSM/Draft/E8RootSemanticAristotle.lean` | `AgentTasks/aristotle-output/hamming-e8-structural-B-root-semantic-20260515-result` | `83ebc0de-a2fa-4411-901b-9ec482d6f5f6` | complete, integrated in draft |
| C: semantic Weyl-reflection closure | `PhysicsSM/Draft/E8WeylSemanticAristotle.lean` | none; internal-error failure | `5a4f4508-770f-4616-8659-02a936ed38a2` | failed internally |
| D: E8 x E8 direct-sum facts | `PhysicsSM/Draft/HammingE8E8StructuralAristotle.lean` | `AgentTasks/aristotle-output/hamming-e8-structural-D-e8xe8-20260515-result` | `6b24bf9e-8c20-4fb4-a6d7-f0f84d22c18a` | complete, promoted to `Coding` |
| E: theta weight-enumerator convolution | `PhysicsSM/Draft/ConstructionAThetaConvolutionAristotle.lean` | `AgentTasks/aristotle-output/hamming-e8-structural-E-theta-convolution-20260515-result` | `1bbfa658-04ab-427e-9402-c42653ac88a5` | complete, promoted to `Coding` |

## Target summaries

### Job A

Main target:

```lean
theorem PhysicsSM.Coding.short_vector_count_eq_weight_distribution_structural :
    Set.ncard hammingE8ShortVectorSet = shortVectorWeightDistributionFormula
```

The intended proof partitions short vectors by binary residue and derives the
count from Hamming weights `0`, `4`, and `8`, with lift counts `16`, `16`, and
`0`.

### Job B

Main target:

```lean
theorem PhysicsSM.Algebra.Octonion.E8Root.isE8RootD_iff_type1_or_type2_structural
    (v : Fin 8 -> Int) :
    IsE8RootD v <-> IsType1RootD v \/ IsType2RootD v
```

The intended proof classifies doubled-coordinate roots directly from
`normSqD v = 8`, same-parity, and the modulo-4 coordinate-sum condition.

### Job C

Main target:

```lean
theorem PhysicsSM.Algebra.Octonion.E8Root.reflectD_preserves_IsE8RootD_structural
    (r v : Fin 8 -> Int) (hr : IsE8RootD r) (hv : IsE8RootD v) :
    IsE8RootD (reflectD r v)
```

The intended proof replaces the 240-by-240 closure check with semantic
reflection preservation.  The Aristotle run failed internally and produced no
partial patch.  The original scaffold remains the next retry target.

### Job D

Targets, in priority order:

```lean
theorem PhysicsSM.Coding.hammingWeight_directSum16_structural
theorem PhysicsSM.Coding.binaryDot16_split_structural
theorem PhysicsSM.Coding.hamming16E8E8_selfDual_structural
theorem PhysicsSM.Coding.hamming16_minimal_vectors_card_structural
```

The intended proof uses finite-sum splitting over `Fin 16`, then direct-sum
self-duality and a structural `240 + 240` minimal-vector count.

Integration note: the split and self-duality proofs are ordinary theorem
proving with no `native_decide`.  The 480 theorem avoids a 16-dimensional
enumeration but still uses finite 8-dimensional shell certificates in
`PhysicsSM.Coding.HammingE8E8Helpers`.

### Job E

Targets, in priority order:

```lean
theorem PhysicsSM.Coding.residueShellCount_eq_weightContribConvolution
theorem PhysicsSM.Coding.constructionAShellCount_eq_codeword_convolution
theorem PhysicsSM.Coding.constructionAShellCount_eq_weight_distribution_convolution
```

The intended proof is a general coefficient formula using one-dimensional
even/odd lift series and a partition by binary residue.

Integration note: this job is currently a draft theorem because its result
uses local copies of the lift-coefficient definitions.  Before promoting it to
`PhysicsSM/Coding/ConstructionAThetaWeightBridge.lean`, the API should be
unified with the existing `hammingCodewords`, `evenLiftCoeff`, and
`oddLiftCoeff` declarations in that trusted bridge file.

## Verification after integration

Targeted checks run after integration:

```text
lake build PhysicsSM.Coding.HammingE8E8Helpers
lake build PhysicsSM.Coding.HammingE8E8
lake build PhysicsSM.Draft.E8ShortVectorsStructuralAristotle
lake build PhysicsSM.Draft.E8RootSemanticHelpers
lake build PhysicsSM.Draft.E8RootSemanticAristotle
lake build PhysicsSM.Draft.HammingE8E8StructuralAristotle
lake build PhysicsSM.Draft.ConstructionAConvolutionHelpers
lake build PhysicsSM.Draft.ConstructionAThetaConvolutionAristotle
```

The semantic root helper replayed pre-existing duplicate-namespace warnings
from `PhysicsSM.Algebra.Octonion.Basic`; the new files themselves built.
