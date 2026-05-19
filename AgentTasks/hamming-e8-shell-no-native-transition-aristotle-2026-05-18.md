# Hamming E8 shell bridge no-native transition matrix job - 2026-05-18

Status: submitted to Aristotle.

Purpose: replace the `native_decide` finite matrix checks used by the
Construction A/SPL coordinate transition with kernel-reduced structural proofs.

## Target file

```text
PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean
```

This file is intentionally SPL-free.  It imports only the project-side matrix
modules and defines a local copy of the transition matrix plus an explicit
integer inverse.

## Primary targets

Please prove:

```lean
theorem constructionAToSPLTransitionLocal_inv_mul :
    constructionAToSPLTransitionLocalInv * constructionAToSPLTransitionLocal = 1

theorem constructionAToSPLTransitionLocal_mul_inv :
    constructionAToSPLTransitionLocal * constructionAToSPLTransitionLocalInv = 1

theorem constructionAToSPLTransitionLocal_det :
    constructionAToSPLTransitionLocal.det = 1

theorem constructionAToSPLTransitionLocal_factorization :
    constructionAToSPLTransitionLocal * e8BasisChangeMatrix =
      splToCartanTransition.transpose

theorem constructionAToSPLTransitionLocal_gram :
    (constructionAToSPLTransitionLocal.map (Int.castRingHom Rat)).transpose *
      splE8GramQ *
      (constructionAToSPLTransitionLocal.map (Int.castRingHom Rat)) = e8ScaledGramQ
```

The two inverse checks are the highest priority fallback targets.

## Important trust constraint

Do not use `native_decide`.  Do not use the existing SPL bridge declarations
`constructionAToSPLTransition_det`,
`constructionAToSPLTransition_factorization`, or
`constructionAToSPLTransition_gram`, since those are the declarations this job
is intended to replace.

At the end, please report:

```lean
#print axioms PhysicsSM.Coding.constructionAToSPLTransitionLocal_inv_mul
#print axioms PhysicsSM.Coding.constructionAToSPLTransitionLocal_mul_inv
#print axioms PhysicsSM.Coding.constructionAToSPLTransitionLocal_det
#print axioms PhysicsSM.Coding.constructionAToSPLTransitionLocal_factorization
#print axioms PhysicsSM.Coding.constructionAToSPLTransitionLocal_gram
```

The axiom sets should not contain `Lean.trustCompiler`.

## Proof sketch

For the inverse and factorization checks, a direct kernel-reduced proof should
be acceptable:

```lean
ext i j
fin_cases i <;> fin_cases j <;> norm_num [Matrix.mul_apply, ...]
```

For the Gram theorem, the preferred proof is structural:

1. Use `splGram_to_cartan`.
2. Use `constructionA_scaledGram_to_cartan`.
3. Use `constructionAToSPLTransitionLocal_factorization`.
4. Use the explicit inverse checks to rewrite away the Construction A
   basis-change matrix.

If the structural proof is too long, an entrywise `fin_cases` proof of the Gram
identity is still useful as long as it avoids `native_decide`.

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/hamming-e8-shell-no-native-transition-20260518-project
```

Planned command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName hamming-e8-shell-no-native-transition-20260518 -TaskNote AgentTasks/hamming-e8-shell-no-native-transition-aristotle-2026-05-18.md -CheckPath PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean
```

## Submitted job

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| Transition matrix without native_decide | `d8cd0e61-073e-4d98-897a-919632c7f295` | created |

## Integration note

Status: helper integrated from the final shell job on 2026-05-18.

The final shell job `4ebb5fe6-c0ff-4342-8840-6dd27513246a` returned a
completed `PhysicsSM/Draft/E8TransitionMatrixNoNativeAristotle.lean`, and that
file has been integrated into the repo. The separately submitted transition
job may still return a useful alternative proof later, but the current repo no
longer needs it for the no-native shell bridge.
