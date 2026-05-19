# Hamming E8 shell bridge no-native final job - 2026-05-18

Status: submitted to Aristotle.

Purpose: remove the remaining `Lean.trustCompiler` dependency from the final
Construction A to SPL/E8 shell-count transport theorem used by the
`Theta_E8 = E4` coefficient proof.

## Target file

```text
PhysicsSM/Draft/E8ShellBridgeNoNativeAristotle.lean
```

## Primary target

```lean
theorem constructionAShellSetLocal_ncard_eq_e8Shell_no_native (n : Nat) :
    Set.ncard (constructionAShellSetLocal (4 * n)) =
      Set.ncard {w : E8Lattice | ‖(w : R8)‖ ^ 2 = 2 * (n : Real)}
```

The intermediate bridge lemmas in the same file are intended helper targets:

```lean
theorem constructionAToE8_injective_no_native
theorem constructionAToE8_surj_E8_no_native
theorem constructionAToE8_inner_no_native
theorem sqNorm_eq_two_mul_norm_sq_no_native
```

## Important trust constraint

Do not use these existing bridge lemmas, because they currently transitively
depend on `native_decide`:

```lean
constructionAToE8_injective
constructionAToE8_surj_E8
constructionAToE8_inner
constructionAToE8_norm_sq
sqNorm_eq_two_mul_norm_sq
constructionAShellSetLocal_ncard_eq_e8Shell
```

It is acceptable to use the new no-native helper statements from:

```text
PhysicsSM/Draft/E8BasisSpanningNoNativeAristotle.lean
PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean
```

If those files still contain `sorry`s in the submission package, you may either
prove the needed helper statements here or leave a precise handoff note saying
which upstream no-native helper must be integrated first.

At the end, please report:

```lean
#print axioms PhysicsSM.Coding.E8ShellBridge.constructionAShellSetLocal_ncard_eq_e8Shell_no_native
```

The axiom set should not contain `Lean.trustCompiler`.

## Proof sketch

The existing theorem
`E8ShellBridge.constructionAShellSetLocal_ncard_eq_e8Shell` is the blueprint.
The replacement proof should:

1. Reuse the same explicit map from Construction A shell elements to
   `E8Lattice`.
2. Use `basisLinearCombination_reconstruction_no_native` in place of the old
   `basisLinearCombination_reconstruction`.
3. Use the explicit no-native transition inverse and Gram facts to prove
   injectivity, surjectivity, and norm preservation for `constructionAToE8`.
4. Convert the resulting bijection into equality of `Set.ncard`s.

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/hamming-e8-shell-no-native-final-20260518-project
```

Planned command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName hamming-e8-shell-no-native-final-20260518 -TaskNote AgentTasks/hamming-e8-shell-no-native-final-aristotle-2026-05-18.md,AgentTasks/hamming-e8-shell-no-native-basis-aristotle-2026-05-18.md,AgentTasks/hamming-e8-shell-no-native-transition-aristotle-2026-05-18.md -CheckPath PhysicsSM/Draft/E8ShellBridgeNoNativeAristotle.lean
```

## Submitted job

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| Final shell bridge without native_decide | `4ebb5fe6-c0ff-4342-8840-6dd27513246a` | created |

## Integration result

Status: integrated on 2026-05-18.

Result package fetched with:

```text
aristotle result 4ebb5fe6-c0ff-4342-8840-6dd27513246a --destination AgentTasks\aristotle-output\hamming-e8-shell-no-native-final-20260518
```

Integrated files:

```text
PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean
PhysicsSM/Draft/E8ShellBridgeNoNativeAristotle.lean
```

The final job also contained a basis-spanning proof, but the dedicated basis
job output `45b7b33d-f38e-4835-b707-3ed57c76f8f0` was integrated for
`E8BasisSpanningNoNativeAristotle.lean`.

Downstream integration:

```text
PhysicsSM/Draft/E8ThetaMFBridgeAristotle.lean
```

was updated to use
`E8ShellBridge.constructionAShellSetLocal_ncard_eq_e8Shell_no_native`.
It also now uses a local no-native Construction A convolution bridge based on
`extendedHamming8_weight_support_no_native`, so the modular-form route no
longer inherits `Lean.trustCompiler` from the older Hamming support theorem.

Verification run after integration:

```text
lake build PhysicsSM.Draft.E8BasisSpanningNoNativeAristotle PhysicsSM.Draft.E8TransitionMatrixNoNativeAristotle PhysicsSM.Draft.E8ShellBridgeNoNativeAristotle
lake build PhysicsSM.Draft.E8ThetaMFBridgeAristotle PhysicsSM.Draft.E8ThetaCoeffGapAristotle
```

Axiom checks for the integrated shell bridge and downstream modular-form
coefficient theorem report only the standard Lean foundations `propext`,
`Classical.choice`, and `Quot.sound`.
