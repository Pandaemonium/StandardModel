# Aristotle task: checkerboard corner-polynomial split

Date: 2026-06-13

## Goal

Fill the four focused `sorry`s in

```text
PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean
```

proving the structural corner-polynomial package for the finite 1+1D
checkerboard:

```lean
endpoint_shift
pathWeight_eq_pow_turnCount
pathSum_eq_sum_turnHistories
length_turnHistories_flipAll
```

## Mathematical Intent

This is the algebraic bridge from the raw finite path sum in
`PhysicsSM.Spinor.Checkerboard` to the discrete Bessel-kernel viewpoint: the
kernel is a finite polynomial in the corner weight `mu`, with coefficients
given by exact corner-class cardinalities.

This job is intentionally split off from the binomial closed-form problem, so
Aristotle can focus on the list/filter partitioning, endpoint translation,
turn-count weight, and flip symmetry.

## Constraints

- No `admit`, `axiom`, `opaque`, `unsafe`, or `native_decide`.
- Do not change definitions in `PhysicsSM.Spinor.Checkerboard`.
- Helper lemmas are welcome.
- The target file should be sorry-free if the job succeeds.

## Verification

```bash
lake env lean PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean
```

Axiom check on finished targets: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

```yaml
aristotle:
  job_id: 355710c8-c1f6-40b0-a1b3-5233e12ebff3
  target_file: PhysicsSM/Draft/CheckerboardCornerPolynomialAristotle.lean
  expected_module: PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
  submission_project: AgentTasks/aristotle-submit/checkerboard-corner-polynomial-20260613-project
  output_dir: AgentTasks/aristotle-output/355710c8-c1f6-40b0-a1b3-5233e12ebff3
  status: integrated
```
