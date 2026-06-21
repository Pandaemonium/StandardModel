# Aristotle task: checkerboard endpoint kernel closed forms

Date: 2026-06-21

## Goal

Prove the finite endpoint-level closed forms for the `1+1` checkerboard path
sum.

Target file:

```text
PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean
```

This builds on:

```text
PhysicsSM/Spinor/Checkerboard.lean
PhysicsSM/Spinor/CheckerboardDynamics.lean
PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean
PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean
```

## Why this target

`PhysicsSM.Spinor.CheckerboardDynamics` now proves the finite endpoint
recursion, iterated two-component evolution, and telegraph/Klein-Gordon
recursion.  The remaining finite combinatorics needed for a publication-grade
checkerboard core is to turn the corner-count closed forms into endpoint
kernel formulas for the path sum itself.

The imported draft files already prove:

- the path sum is a polynomial in the corner weight;
- the polynomial coefficients are fixed-endpoint corner classes;
- those corner classes have binomial closed forms for right-incoming paths.

The target is the summation glue.

## Target declarations

```lean
pathSum_right_right_closed_form
pathSum_right_left_closed_form
pathSum_right_right_straight
pathSum_right_left_straight_zero
```

## Claim boundary

This is finite combinatorics only.

It does not prove:

- a continuum limit;
- Bessel-function asymptotics;
- equality with the analytic Dirac propagator;
- a four-dimensional checkerboard theorem.

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean
lake build PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
```

Then scan the target file for proof-command placeholders and forbidden
constructs.

## Submission

```yaml
aristotle:
  project_id: 6fe6a877-4ad1-4b70-91f0-ace14eb90a13
  task_id: 62a3c14d-d084-4a24-b1e6-4e86a4ec605b
  target_file: PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean
  expected_module: PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
  submission_mode: continue
  status: submitted
  last_checked: QUEUED
```

## Submission notes

The first submission attempt included six files and Aristotle v3 rejected it
with:

```text
Maximum 5 files allowed
```

The successful continuation upload used:

```text
PhysicsSM/Spinor/Checkerboard.lean
PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean
PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean
PhysicsSM/Draft/CheckerboardKernelClosedFormsAristotle.lean
AgentTasks/checkerboard-kernel-closed-forms-aristotle-2026-06-21.md
```
