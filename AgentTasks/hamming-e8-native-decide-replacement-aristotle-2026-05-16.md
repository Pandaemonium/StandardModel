# Hamming E8 native-decide replacement Aristotle wave - 2026-05-16

Status: submitted to Aristotle.

Purpose: replace several large `native_decide` certificates with structural
Lean proofs that expose the underlying mathematics and are easier for
proof-search agents to work with.

## Submission project

```text
AgentTasks/aristotle-submit/hamming-e8-native-reduction-20260516-project
```

This project copy should include the live `PhysicsSM/` tree and this task
file, but not `.lake`, `.git`, or extracted `AgentTasks/aristotle-output/`
archives.

Submission packaging note: the live repository uses a local path dependency
for the Windows-safe Sphere-Packing-Lean checkout.  To avoid long-path upload
problems in this submission copy, only the submission copy's `lakefile.toml`
and `lake-manifest.json` were changed to use the remote branch
`https://github.com/Pandaemonium/Sphere-Packing-Lean` at
`windows-safe-auxiliary-renames`.  The live repository dependency was not
changed.

## Jobs

| Job | Target file | Aristotle ID | Status |
|-----|-------------|--------------|--------|
| N1: no-native Hamming weight enumerator | `PhysicsSM/Draft/HammingWeightEnumeratorNoNativeAristotle.lean` | `737cedbe-edf4-4195-9d67-6475040f1909` | in progress |
| N2: structural systematic `[8,4,4]` classification | `PhysicsSM/Draft/Hamming844SystematicNoNativeAristotle.lean` | `8d0ffbf8-027c-4e42-8fe9-7127fe28efa4` | in progress |
| N3: no-native structural E8 short-vector count | `PhysicsSM/Draft/E8ShortVectorsNoNativeAristotle.lean` | `5a8d5e57-4aae-473d-8728-5cea4d5acfef` | in progress |
| N4: semantic Weyl reflection preservation | `PhysicsSM/Draft/E8WeylSemanticAristotle.lean` | `e0a31c51-efa0-468e-b240-0e8b5f5d96ef` | in progress |

## Job N1: Hamming weight enumerator without native decide

Target file:

```text
PhysicsSM/Draft/HammingWeightEnumeratorNoNativeAristotle.lean
```

Primary targets:

```lean
theorem extendedHamming8_weight_zero_count_no_native :
    extendedHamming8WeightDist 0 = 1

theorem extendedHamming8_weight_four_count_no_native :
    extendedHamming8WeightDist 4 = 14

theorem extendedHamming8_weight_eight_count_no_native :
    extendedHamming8WeightDist 8 = 1

theorem extendedHamming8_weight_support_no_native (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    hammingWeight v = 0 \/ hammingWeight v = 4 \/ hammingWeight v = 8
```

Suggested route:

- solve the parity-check equations symbolically using four free coordinates;
- exhibit a compact parametrization of the 16 codewords;
- prove the weight distribution from the parametrization;
- avoid the existing native-decide theorems in
  `PhysicsSM.Coding.HammingWeightEnumerator`.

## Job N2: Systematic `[8,4,4]` classification without 2^16 enumeration

Target file:

```text
PhysicsSM/Draft/Hamming844SystematicNoNativeAristotle.lean
```

Primary targets:

```lean
theorem systematic_min_distance_forces_row_weight_three ...
theorem systematic_min_distance_forces_complement_rows ...
theorem systematic_844_classification_structural ...
```

Suggested route:

- for a systematic codeword from a single message bit, use
  `4 <= hammingWeight (systematicCW P c)` to force each parity row to have
  weight at least three;
- use two- and three-message-bit codewords to force the four rows to be the
  four distinct weight-three vectors in `F_2^4`;
- construct the coordinate permutation on the last four coordinates;
- do not use the existing theorem `systematic_844_classification`.

## Job N3: Short-vector count without 8-dimensional enumeration

Target file:

```text
PhysicsSM/Draft/E8ShortVectorsNoNativeAristotle.lean
```

Primary targets:

```lean
lemma svCodeW0_card_no_native : ...
lemma svCodeW4_card_no_native : ...
lemma svCodeW8_card_no_native : ...
theorem short_vector_count_eq_240_structural_no_native :
    Set.ncard hammingE8ShortVectorSet = 240
```

Suggested route:

- weight 0: exactly one coordinate is `+-2`, all others are zero, giving
  `8 * 2 = 16`;
- weight 4: exactly the support coordinates are odd `+-1`, giving `2^4 = 16`
  lifts per weight-four codeword;
- weight 8: all eight coordinates are odd, so `sqNorm >= 8`, impossible in
  the `sqNorm = 4` shell;
- use N1's no-native weight-distribution theorem if helpful.

## Job N4: Weyl reflection closure by semantic root predicates

Target file:

```text
PhysicsSM/Draft/E8WeylSemanticAristotle.lean
```

Primary target:

```lean
theorem reflectD_preserves_IsE8RootD_structural
    (r v : Fin 8 -> Int) (hr : IsE8RootD r) (hv : IsE8RootD v) :
    IsE8RootD (reflectD r v)
```

Suggested route:

- avoid `reflectD_mem_rootList`, `reflectD_involutive_on_rootList`, and
  `rootList.Forall` finite checks;
- use the semantic classification theorem
  `isE8RootD_iff_type1_or_type2_structural`;
- either prove reflection preserves the norm/parity/sum conditions directly,
  or split into the type-I/type-II root cases.

## Local pre-submission checks

```text
lake build PhysicsSM.Draft.HammingWeightEnumeratorNoNativeAristotle PhysicsSM.Draft.E8ShortVectorsNoNativeAristotle
lake build PhysicsSM.Draft.Hamming844SystematicNoNativeAristotle PhysicsSM.Draft.E8WeylSemanticAristotle
```

Result:

- all target files build;
- warnings are exactly the intended draft `sorry` markers plus existing
  unrelated project warnings.

## Submission commands

Use the submission project above and submit each job independently:

```text
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-native-reduction-20260516-project --destination AgentTasks/aristotle-output/hamming-e8-native-N1-weight-enumerator-20260516 "<prompt>"
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-native-reduction-20260516-project --destination AgentTasks/aristotle-output/hamming-e8-native-N2-systematic-classification-20260516 "<prompt>"
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-native-reduction-20260516-project --destination AgentTasks/aristotle-output/hamming-e8-native-N3-short-vectors-20260516 "<prompt>"
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-native-reduction-20260516-project --destination AgentTasks/aristotle-output/hamming-e8-native-N4-weyl-semantic-20260516 "<prompt>"
```

Submitted job IDs:

```text
N1 737cedbe-edf4-4195-9d67-6475040f1909
N2 8d0ffbf8-027c-4e42-8fe9-7127fe28efa4
N3 5a8d5e57-4aae-473d-8728-5cea4d5acfef
N4 e0a31c51-efa0-468e-b240-0e8b5f5d96ef
```

`aristotle list` confirmed all four jobs were created and then moved to
`IN_PROGRESS`.
