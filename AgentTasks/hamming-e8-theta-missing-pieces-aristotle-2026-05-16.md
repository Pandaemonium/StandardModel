# Hamming E8 theta missing pieces Aristotle jobs - 2026-05-16

Status: submitted to Aristotle.

Purpose: split the remaining Hamming Construction A / SPL theta bridge into
two focused proof-specialist jobs after the formal convolution result from job
`bf905d04-b40c-43b1-9449-8cebc7fbe995`.

## Local target files

Added:

```text
PhysicsSM/Draft/E8ThetaDuplicationAristotle.lean
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
```

The first file isolates the two classical Jacobi theta duplication identities:

```lean
theorem theta2_sq_duplication (tau : UpperHalfPlane) :
    (Theta2 tau)^2 = 2 * Theta2 (twoTau tau) * Theta3 (twoTau tau)

theorem theta4_sq_duplication (tau : UpperHalfPlane) :
    (Theta4 tau)^2 = Theta3 (twoTau tau)^2 - Theta2 (twoTau tau)^2
```

The actual Lean statements use SPL's Unicode theta names `Theta_2`,
`Theta_3`, and `Theta_4`.

The second file isolates the q-expansion coefficient bridge:

```lean
theorem hammingThetaConstantPolynomial_qExpansion_coeff (n : Nat) :
    PowerSeries.coeff n (ModularFormClass.qExpansion (1 : Real)
      hammingThetaConstantPolynomial) =
      (hammingThetaConvolutionCoeff n : Complex)
```

Together these pieces feed the existing conditional theorem
`splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff_of_duplication` in
`PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle`.

## Local verification

Commands run in the main checkout:

```text
lake env lean PhysicsSM/Draft/E8ThetaDuplicationAristotle.lean
lake env lean PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
```

Results:

- `E8ThetaDuplicationAristotle.lean` checks with two intentional draft
  `sorry`s.
- `E8ThetaQExpansionBridgeAristotle.lean` checks with one intentional draft
  `sorry`.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-theta-missing-pieces-20260516-project
```

The package was copied from the previous minimized SPL package
`hamming-e8-spl-theta-bridge-20260515-project`, then refreshed with the current
`PhysicsSM` sources and root files.  The generated package `.lake` cache was
removed before submission.

## Submitted jobs

| Job | Aristotle ID | Status at submission |
|-----|--------------|----------------------|
| Jacobi theta duplication identities | `58dd34f0-c61e-401b-8e76-0296e03996b4` | queued |
| Hamming theta q-expansion coefficient bridge | `1f94935b-0393-4dc7-a20d-95fff002b621` | queued |

Submission commands:

```text
aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-theta-missing-pieces-20260516-project --destination AgentTasks/aristotle-output/hamming-e8-theta-duplication-20260516 <prompt>

aristotle submit --project-dir AgentTasks/aristotle-submit/hamming-e8-theta-missing-pieces-20260516-project --destination AgentTasks/aristotle-output/hamming-e8-theta-qexpansion-bridge-20260516 <prompt>
```

Immediate status check:

```text
aristotle list
```

reported:

```text
1f94935b-0393-4dc7-a20d-95fff002b621 QUEUED
58dd34f0-c61e-401b-8e76-0296e03996b4 QUEUED
```

## Follow-up

When the jobs complete, fetch with:

```text
aristotle result 58dd34f0-c61e-401b-8e76-0296e03996b4 --destination AgentTasks/aristotle-output/hamming-e8-theta-duplication-20260516

aristotle result 1f94935b-0393-4dc7-a20d-95fff002b621 --destination AgentTasks/aristotle-output/hamming-e8-theta-qexpansion-bridge-20260516
```

Review any output for new `sorry`, `axiom`, `admit`, or `unsafe` before
integration.

## Duplication result integrated - 2026-05-16

`aristotle list` reported:

```text
58dd34f0-c61e-401b-8e76-0296e03996b4 COMPLETE 100%
```

Retrieved with:

```text
aristotle result 58dd34f0-c61e-401b-8e76-0296e03996b4 --destination AgentTasks/aristotle-output/hamming-e8-theta-duplication-20260516
```

The returned archive was extracted to:

```text
AgentTasks/aristotle-output/hamming-e8-theta-duplication-20260516-extracted
```

Useful integrated changes:

```text
PhysicsSM/Draft/ThetaDuplicationProof.lean
PhysicsSM/Draft/E8ThetaDuplicationAristotle.lean
```

The new helper proves local theta duplication identities by direct Mathlib
series manipulations, and the Aristotle target file transports them to SPL's
theta constants. The two target theorems `theta2_sq_duplication` and
`theta4_sq_duplication` no longer contain `sorry`.

Verification after integration:

```text
lake env lean PhysicsSM/Draft/ThetaDuplicationProof.lean
lake build PhysicsSM.Draft.E8ThetaDuplicationAristotle
```

Both checks completed successfully. The warnings in the build output are from
pre-existing draft handoff markers in imported coefficient-bridge files, not
from the two duplication theorems.
