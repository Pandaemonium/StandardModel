# Hamming E8 theta bridge next Aristotle round - 2026-05-17

Status: submitted to Aristotle.

Purpose: after jobs `3c9ed71d-c668-4cc2-9321-36c93b273d91` and
`e0bdc02b-654d-4e39-9091-51253941e0ad` were integrated, the rank-8 analytic
theta modular form file has no executable proof holes.  The next useful work is
to connect that modular-form theorem back to the Hamming Construction A
coefficient statements.

## Current frontier

`PhysicsSM/Draft/E8ThetaDim8MF.lean` now provides the analytic core:

```text
thetaE8_MF
thetaE8_MF_apply
thetaE8_MF_eq_E4
thetaSeries8_transform_S
e8_dualLattice_eq_self
```

The remaining bridge targets are:

```text
PhysicsSM/Draft/E8ThetaModularFormConstructionAristotle.lean
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

## Job A: package the new theta modular form for the Hamming route

Target file:

```text
PhysicsSM/Draft/E8ThetaModularFormConstructionAristotle.lean
```

Main theorem:

```lean
theorem exists_e8Theta_weight4_modularForm_with_qExpansion :
    exists f : ModularForm (CongruenceSubgroup.Gamma 1) 4,
      (forall z : UpperHalfPlane, f z = e8ThetaAnalytic z) /\
      (forall n : Nat,
        (ModularFormClass.qExpansion (1 : Real) f).coeff n =
          (hammingThetaConvolutionCoeff n : Complex))
```

Suggested route:

1. Import `PhysicsSM.Draft.E8ThetaDim8MF`.
2. Use `PhysicsSM.Coding.E8ThetaDim8.thetaE8_MF` as the candidate modular form.
3. Prove or isolate the transport lemma identifying `e8ThetaAnalytic` with
   `PhysicsSM.Coding.E8ThetaDim8.thetaSeriesUHP8`.
4. Prove or isolate the q-expansion coefficient lemma from the project shell
   count theorem `constructionAThetaCoeff_eq_hammingThetaConvolutionCoeff`.
5. If the exact theorem is still too large, add the smallest useful helper
   theorem with a documented handoff note.  Do not weaken existing statements.

## Job B: SPL theta-polynomial coefficient bridge

Target file:

```text
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
```

Main theorem:

```lean
theorem splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff (n : Nat) :
    PowerSeries.coeff n splThetaE4Series =
      (hammingThetaConvolutionCoeff n : Complex)
```

Suggested route:

1. Prefer using the new modular-form result if it gives an easier route from
   the E8 theta q-expansion to `E4`.
2. Otherwise continue the existing theta-polynomial route:
   `hammingThetaConstantPolynomial_eq_thetaE4_of_duplication` plus the
   q-expansion coefficient theorem.
3. It is acceptable to add helper lemmas in this draft file or in a small
   helper file, but do not introduce axioms, `opaque`, or `unsafe`.

## Job C: q-expansion coefficient bridge

Target file:

```text
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean
```

Main theorem:

```lean
theorem hammingThetaConstantPolynomial_qExpansion_coeff (n : Nat) :
    PowerSeries.coeff n (ModularFormClass.qExpansion (1 : Real)
      hammingThetaConstantPolynomial) =
      (hammingThetaConvolutionCoeff n : Complex)
```

Suggested route:

Use the new `E8ThetaDim8MF.thetaE8_MF_eq_E4` theorem if it avoids the older
duplication-identity route.  If the full theorem is circular in this file, add
a non-circular conditional theorem that consumes the new modular-form/q-series
bridge from `E8ThetaModularFormConstructionAristotle`.

## Job D: final all-coefficient closure

Target file:

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

Main theorem:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

Suggested route:

Use `hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form` together with the
best available q-expansion bridge from Job A.  If Job A is not available in the
same run, prove a short conditional wrapper that consumes the new theorem from
`E8ThetaModularFormConstructionAristotle`.

## Submission package

Planned package:

```text
AgentTasks/aristotle-submit/hamming-e8-theta-bridge-next-round-20260517-project
```

Planned package command:

```text
powershell -ExecutionPolicy Bypass -File Scripts/prepare_aristotle_submission.ps1 -JobName hamming-e8-theta-bridge-next-round-20260517 -TaskNote AgentTasks/hamming-e8-theta-bridge-next-round-aristotle-2026-05-17.md -CheckPath PhysicsSM/Draft/E8ThetaDim8MF.lean,PhysicsSM/Draft/E8ThetaModularFormConstructionAristotle.lean,PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean,PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean,PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

Package checks:

```text
No .lake/.git/local output state: checked
No compiled .olean/.ilean artifacts: checked
SpherePacking remote: https://github.com/Pandaemonium/Sphere-Packing-Lean @ windows-safe-auxiliary-renames
PhysicsSM/Draft/E8ThetaDim8MF.lean: proof-sorry-lines=0
PhysicsSM/Draft/E8ThetaModularFormConstructionAristotle.lean: proof-sorry-lines=1
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean: proof-sorry-lines=1
PhysicsSM/Draft/E8ThetaQExpansionBridgeAristotle.lean: proof-sorry-lines=1
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean: proof-sorry-lines=1
```

## Submitted jobs

| Job | Aristotle ID | Status at submission check |
|-----|--------------|----------------------------|
| A: modular-form packaging bridge | `4187d12a-350d-42ea-8b38-1ce21d45602e` | in progress, 1% |
| B: SPL theta-polynomial coefficient bridge | `fd908714-de0f-4894-91cf-9cabdb3f341a` | in progress, 1% |
| C: q-expansion coefficient bridge | `5915f954-711f-41cc-a053-0adef7e4d11c` | queued |
| D: final all-coefficient closure | `c2afc434-2e08-4900-b16d-9ec5ac0c56b1` | queued |

Follow-up result commands:

```text
aristotle result 4187d12a-350d-42ea-8b38-1ce21d45602e --destination AgentTasks/aristotle-output/hamming-e8-theta-bridge-modular-packaging-20260517
aristotle result fd908714-de0f-4894-91cf-9cabdb3f341a --destination AgentTasks/aristotle-output/hamming-e8-theta-bridge-spl-coeff-20260517
aristotle result 5915f954-711f-41cc-a053-0adef7e4d11c --destination AgentTasks/aristotle-output/hamming-e8-theta-bridge-qexp-20260517
aristotle result c2afc434-2e08-4900-b16d-9ec5ac0c56b1 --destination AgentTasks/aristotle-output/hamming-e8-theta-bridge-final-coeff-20260517
```
