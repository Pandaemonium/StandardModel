# Hamming [8,4,4] uniqueness without native_decide - 2026-05-19

Status: complete and integrated.

Purpose: remove the remaining `native_decide` trust boundary from the Hamming
`[8,4,4]` uniqueness story by replacing the finite searches with structural
Lean proofs.

## Context

The current trusted theorem

```lean
theorem extendedHamming8_unique_up_to_equivalence_proof
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8
```

is kernel-checked, but it depends on two finite-search proofs:

1. `systematic_844_classification`, a `native_decide` enumeration over all
   `4 x 4` parity blocks `P`.
2. `exists_perm_to_first4`, a `native_decide` search over coordinate
   permutations sending an information set to `{0, 1, 2, 3}`.

The older Aristotle N2 draft already provides a structural systematic
classification theorem:

```lean
theorem systematic_844_classification_structural
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : forall c : Fin 4 -> ZMod 2,
      c ≠ 0 -> 4 <= hammingWeight (systematicCW P c)) :
    exists sigma : Equiv.Perm (Fin 8),
      (systematicCodeFinset P).image (permuteBinaryVector sigma) =
        extendedHamming8Finset
```

The new wave targets the missing constructive permutation lemma, the final
assembly theorem, and concrete no-native facts about `extendedHamming8`.

## Draft target files

```text
PhysicsSM/Draft/Hamming844PermutationNoNativeAristotle.lean
PhysicsSM/Draft/Hamming844UniquenessNoNativeAristotle.lean
PhysicsSM/Draft/Hamming844ConcreteNoNativeAristotle.lean
```

These files are imported by `PhysicsSMDraft.lean`.

## Jobs

| Job | Target file | Aristotle ID | Status |
|-----|-------------|--------------|--------|
| U1: constructive information-set permutation | `PhysicsSM/Draft/Hamming844PermutationNoNativeAristotle.lean` | `a0ceb4a5-d8d8-4df5-851e-e9762468e367` | integrated |
| U2: full uniqueness assembly | `PhysicsSM/Draft/Hamming844UniquenessNoNativeAristotle.lean` | `cf287ca4-a1c5-44d7-bd82-bafb7273666b` | integrated |
| U3: concrete Hamming facts no-native | `PhysicsSM/Draft/Hamming844ConcreteNoNativeAristotle.lean` | `98effd4a-af1a-461b-a1f0-da62c4d5e721` | integrated |

## Job U1: constructive information-set permutation

Primary target:

```lean
theorem exists_perm_to_first4_constructive
    (I : Finset (Fin 8)) (hI : I.card = 4) :
    exists sigma : Equiv.Perm (Fin 8), I.image sigma = {0, 1, 2, 3}
```

Constraints:

- Do not use `exists_perm_to_first4`.
- Do not use `native_decide`.
- Small helper lemmas in the same file are welcome.

Suggested route:

- Build an equivalence between the subtype `I` and `Fin 4`.
- Build an equivalence between the complement subtype and `Fin 4`.
- Combine these two equivalences to get a permutation of `Fin 8` sending `I`
  to `{0, 1, 2, 3}`.

## Job U2: full uniqueness assembly

Primary targets:

```lean
theorem systematic_codeEquiv_hamming_structural
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : forall c : Fin 4 -> ZMod 2,
      c ≠ 0 -> 4 <= hammingWeight (systematicCW P c)) :
    CodeEquivalent (systematicSubmodule P) extendedHamming8

theorem extendedHamming8_unique_up_to_equivalence_no_native
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8
```

Current status:

- This file already builds.
- The assembly proof is complete modulo the `sorry` in U1.
- Aristotle may only need to verify and clean dependencies after U1 is proved.

Constraints:

- Do not use `systematic_844_classification`.
- Do not use `exists_perm_to_first4`.
- Do not use `native_decide`.

## Job U3: concrete Hamming facts no-native

Primary targets:

```lean
theorem extendedHamming8_card_no_native : ...
theorem extendedHamming8_subtype_card_no_native : ...
theorem extendedHamming8_finrank_no_native : ...
theorem extendedHamming8_minWeight_no_native : ...
theorem extendedHamming8_doublyEven_no_native : ...
theorem extendedHamming8_has_weight4_no_native : ...
theorem extendedHamming8_isLinearCode_4_4_no_native :
    IsLinearCode extendedHamming8 4 4
```

Suggested route:

- Reuse `codewordOfMsg`, `codewordOfMsg_injective`,
  `codewordOfMsg_mem_code`, `codeword_msg_right_inv`, and
  `extendedHamming8_weight_support_no_native` from
  `HammingWeightEnumeratorNoNativeAristotle`.
- Replace cardinality and minimum-distance native checks with the structural
  16-codeword parametrization.

## Local verification before submission

```text
lake build PhysicsSM.Draft.Hamming844PermutationNoNativeAristotle
lake build PhysicsSM.Draft.Hamming844UniquenessNoNativeAristotle
lake build PhysicsSM.Draft.Hamming844ConcreteNoNativeAristotle
lake build PhysicsSMDraft
```

Result:

- all target files build;
- warnings are the intended draft `sorry` handoff markers plus existing
  unrelated project linter warnings.

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/hamming-844-no-native-20260519-project
```

Preparation command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName hamming-844-no-native-20260519 -TaskNote AgentTasks/hamming-844-uniqueness-no-native-aristotle-2026-05-19.md -CheckPath PhysicsSM/Draft/Hamming844PermutationNoNativeAristotle.lean,PhysicsSM/Draft/Hamming844UniquenessNoNativeAristotle.lean,PhysicsSM/Draft/Hamming844ConcreteNoNativeAristotle.lean
```

## Submission commands

Use the submission project above and submit each job independently:

```text
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-844-no-native-20260519-project --destination AgentTasks/aristotle-output/hamming-844-U1-permutation-no-native-20260519 "<prompt>"
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-844-no-native-20260519-project --destination AgentTasks/aristotle-output/hamming-844-U2-uniqueness-no-native-20260519 "<prompt>"
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-844-no-native-20260519-project --destination AgentTasks/aristotle-output/hamming-844-U3-concrete-no-native-20260519 "<prompt>"
```

## Submitted jobs

| Job | Aristotle ID | Output directory |
|-----|--------------|------------------|
| U1 | `a0ceb4a5-d8d8-4df5-851e-e9762468e367` | `AgentTasks/aristotle-output/hamming-844-U1-permutation-no-native-20260519` |
| U2 | `cf287ca4-a1c5-44d7-bd82-bafb7273666b` | `AgentTasks/aristotle-output/hamming-844-U2-uniqueness-no-native-20260519` |
| U3 | `98effd4a-af1a-461b-a1f0-da62c4d5e721` | `AgentTasks/aristotle-output/hamming-844-U3-concrete-no-native-20260519` |

Submission confirmed with:

```text
aristotle list
```

At confirmation all three jobs were queued.

## Integration result

Status: integrated on 2026-05-19.

Result archives fetched with:

```text
aristotle result a0ceb4a5-d8d8-4df5-851e-e9762468e367 --destination AgentTasks/aristotle-output/hamming-844-U1-permutation-no-native-20260519
aristotle result cf287ca4-a1c5-44d7-bd82-bafb7273666b --destination AgentTasks/aristotle-output/hamming-844-U2-uniqueness-no-native-20260519
aristotle result 98effd4a-af1a-461b-a1f0-da62c4d5e721 --destination AgentTasks/aristotle-output/hamming-844-U3-concrete-no-native-20260519
```

The Aristotle result archives were extracted to:

```text
AgentTasks/aristotle-output/hamming-844-U1-permutation-no-native-20260519-extracted
AgentTasks/aristotle-output/hamming-844-U2-uniqueness-no-native-20260519-extracted
AgentTasks/aristotle-output/hamming-844-U3-concrete-no-native-20260519-extracted
```

Integrated files:

```text
PhysicsSM/Draft/Hamming844PermutationNoNativeAristotle.lean
PhysicsSM/Draft/Hamming844UniquenessNoNativeAristotle.lean
PhysicsSM/Draft/Hamming844ConcreteNoNativeAristotle.lean
```

The integrated theorem set is now:

```lean
exists_perm_to_first4_constructive
systematic_codeEquiv_hamming_structural
extendedHamming8_unique_up_to_equivalence_no_native
extendedHamming8_card_no_native
extendedHamming8_subtype_card_no_native
extendedHamming8_finrank_no_native
extendedHamming8_minWeight_no_native
extendedHamming8_doublyEven_no_native
extendedHamming8_has_weight4_no_native
extendedHamming8_isLinearCode_4_4_no_native
```

Verification after integration:

```text
lake build PhysicsSM.Draft.Hamming844PermutationNoNativeAristotle
lake build PhysicsSM.Draft.Hamming844UniquenessNoNativeAristotle
lake build PhysicsSM.Draft.Hamming844ConcreteNoNativeAristotle
rg -n "\bsorry\b|\badmit\b|\baxiom\b|\bunsafe\b" PhysicsSM/Draft/Hamming844PermutationNoNativeAristotle.lean PhysicsSM/Draft/Hamming844UniquenessNoNativeAristotle.lean PhysicsSM/Draft/Hamming844ConcreteNoNativeAristotle.lean
rg -n "by\s+native_decide|native_decide\s*\+|exact\s+native_decide" PhysicsSM/Draft/Hamming844PermutationNoNativeAristotle.lean PhysicsSM/Draft/Hamming844UniquenessNoNativeAristotle.lean PhysicsSM/Draft/Hamming844ConcreteNoNativeAristotle.lean
```

The grep commands produced no hits.  The files may still mention
`native_decide` in explanatory comments, but the integrated proofs do not use
executable `native_decide`.
