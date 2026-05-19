# Hamming E8 representation formula retry Aristotle job - 2026-05-16

Status: submitted to Aristotle.

Purpose: submit the independent remaining all-coefficients theorem after Claude
integrated job `1f94935b-0393-4dc7-a20d-95fff002b621` and submitted the
Jacobi duplication job `ae8dc185-509e-44a4-8e3d-9b964cb208f3`.

## Why this job

The active duplication targets are already covered by running jobs:

```text
58dd34f0-c61e-401b-8e76-0296e03996b4 IN_PROGRESS
ae8dc185-509e-44a4-8e3d-9b964cb208f3 IN_PROGRESS
```

The remaining independent gap is the project-local E8 representation-number
formula:

```lean
theorem PhysicsSM.Coding.E8ThetaSPLBridge
    .hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

The earlier coefficient-gap job
`a9a170c1-b4ec-4a0e-8468-ca2db69e6f75` returned useful partial scaffolding
but left this theorem as a documented draft `sorry`.

## Submission package

```text
AgentTasks/aristotle-submit/hamming-e8-representation-formula-20260516-project
```

This package was copied from the current theta missing-pieces submission copy
and refreshed with the live `PhysicsSM/` directory and root project files. It
was checked to exclude `.lake` and `.git` directories before submission.

## Aristotle target

Target file:

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

Primary target:

```lean
theorem hammingThetaConvolutionCoeff_eq_e4Coeff (n : Nat) :
    hammingThetaConvolutionCoeff n =
      if n = 0 then 1 else 240 * sigma3 n
```

Fallbacks requested:

- prove a reduction to an explicit modular-form uniqueness or dimension
  hypothesis already available in mathlib or Sphere-Packing-Lean;
- prove a formal power-series theorem equating the project theta series with
  the Hamming weight-enumerator polynomial in the even/odd lift series;
- prove one missing one-dimensional q-expansion bridge lemma for
  `evenLiftCoeff` or `oddLiftCoeff`;
- otherwise return the strongest sorry-free helper theorem and a documented
  handoff note.

## Submitted job

| Job | Aristotle ID | Status at submission |
|-----|--------------|----------------------|
| Hamming E8 representation formula retry | `7069d39f-733a-4c30-8673-1035dd91a324` | queued |

## Local verification

```text
lake env lean PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
aristotle list
```

Results:

- `E8ThetaCoeffGapAristotle.lean` elaborated with exactly the intended warning
  that `hammingThetaConvolutionCoeff_eq_e4Coeff` uses `sorry`.
- `aristotle list` confirmed job
  `7069d39f-733a-4c30-8673-1035dd91a324` was created and queued.

## Retrieval command

```text
aristotle result 7069d39f-733a-4c30-8673-1035dd91a324 --destination AgentTasks/aristotle-output/hamming-e8-representation-formula-retry-20260516
```

## Result and integration

Status: Aristotle job `7069d39f-733a-4c30-8673-1035dd91a324` completed.

Result archive:

```text
AgentTasks/aristotle-output/hamming-e8-representation-formula-retry-20260516
```

Extracted review copy:

```text
AgentTasks/aristotle-output/hamming-e8-representation-formula-retry-20260516-extracted/hamming-e8-representation-formula-20260516-project_aristotle
```

The primary theorem `hammingThetaConvolutionCoeff_eq_e4Coeff` remains a draft
`sorry`. Aristotle returned the requested useful fallback: a sorry-free
modular-form reduction theorem
`hammingThetaConvolutionCoeff_eq_e4Coeff_of_weight4_form`.

Integrated file:

```text
PhysicsSM/Draft/E8ThetaCoeffGapAristotle.lean
```

The integrated theorem proves the all-coefficients divisor-sum formula from a
single hypothesis: there is a `ModularForm Γ(1) 4` whose q-expansion
coefficients are `hammingThetaConvolutionCoeff`. The proof uses SPL's
weight-4 level-one dimension theorem and `E4_q_exp` to identify the form with
the normalized Eisenstein series.

The remaining gap is now precisely the analytic construction and coefficient
identification of the E8 theta modular form:

- define the Construction A E8 theta function as a modular form of weight 4
  and level 1;
- prove T-invariance from the even-lattice norm divisibility;
- prove S-invariance using Poisson summation and self-duality;
- prove holomorphicity and cusp boundedness;
- match its q-expansion coefficients to the finite shell counts already used
  by `hammingThetaConvolutionCoeff`.

## Post-integration verification

```text
lake build PhysicsSM.Draft.E8ThetaCoeffGapAristotle
```

Result:

- build succeeded;
- Lean reported the expected warning that the draft main theorem
  `hammingThetaConvolutionCoeff_eq_e4Coeff` still uses `sorry`.
