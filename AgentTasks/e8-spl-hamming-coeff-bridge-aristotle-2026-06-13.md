# Aristotle task: E8 SPL/Hamming coefficient bridge

Date: 2026-06-13

## Goal

Fill the single central `sorry` in

```text
PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
```

targeting:

```lean
e8_repr_number_eq_hammingConv
```

The downstream theorem

```lean
splThetaE4Series_coeff_eq_hammingThetaConvolutionCoeff
```

then follows immediately in the same file.

## Mathematical Intent

This is the coefficient bridge between the project-local Construction A
Hamming model of E8 and the SPL/modular-form E4 theta series.  It is a genuine
bottleneck: the formal Hamming weight-enumerator side is already reduced, and
`thetaE8_MF_eq_E4` is available from `PhysicsSM.Draft.E8ThetaDim8MF`.

The missing mathematical content is the representation-number identity

```lean
hammingThetaConvolutionCoeff n =
  if n = 0 then 1 else 240 * sigma3 n
```

for every `n`.

## Useful Outcomes

Full success is ideal, but the following partial results are also valuable:

- a clean conditional theorem reducing the target to a norm-preserving
  bijection between the project `e8IntLattice` model and SPL's `E8Lattice`;
- a coefficient bridge for all `n` from an explicit q-expansion shell-count
  hypothesis;
- a precise statement of any missing SPL/mathlib API needed to finish the
  proof.

## Constraints

- No `admit`, `axiom`, `opaque`, `unsafe`, or `native_decide`.
- Do not change definitions or normalizations.
- Do not weaken the target silently; if the full theorem is out of reach,
  add a named conditional theorem and leave the original target as a documented
  handoff.

## Verification

```bash
lake env lean PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
```

Axiom check on finished targets: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

```yaml
aristotle:
  job_id: 6521f062-e28a-4925-a59c-24c608864cff
  target_file: PhysicsSM/Draft/E8ThetaWeightEnumeratorBridgeAristotle.lean
  expected_module: PhysicsSM.Draft.E8ThetaWeightEnumeratorBridgeAristotle
  submission_project: AgentTasks/aristotle-submit/e8-spl-hamming-coeff-bridge-20260613-project
  output_dir: AgentTasks/aristotle-output/6521f062-e28a-4925-a59c-24c608864cff
  status: integrated
```
