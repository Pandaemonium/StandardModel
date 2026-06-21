# Aristotle task: checkerboard corner closed forms split

Date: 2026-06-13

## Goal

Fill the four focused `sorry`s in

```text
PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean
```

proving the exact binomial corner counts:

```lean
length_turnHistories_even
length_turnHistories_odd
length_turnHistories_zero
length_turnHistories_right_right_odd
```

## Mathematical Intent

This is the run-counting core of the 1+1D Feynman checkerboard.  With incoming
direction `right`, `p` right steps, and `q` left steps, histories with fixed
endpoint and fixed corner count are counted by products of binomial
coefficients.  These are the discrete combinatorial coefficients that become
the Bessel-kernel terms in the continuum discussion.

The statements were brute-force checked for small parameters by
`Scripts/oracle/validate_checkerboard.py`; the oracle is only evidence, not a
proof.

## Constraints

- No `admit`, `axiom`, `opaque`, `unsafe`, or `native_decide`.
- Do not change definitions in `PhysicsSM.Spinor.Checkerboard`.
- Helper lemmas are welcome.
- The target file should be sorry-free if the job succeeds.

## Verification

```bash
lake env lean PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean
```

Axiom check on finished targets: only
`[propext, Classical.choice, Quot.sound]`.

## Submission

```yaml
aristotle:
  job_id: fca75150-da8b-488c-93c3-5189022b8718
  target_file: PhysicsSM/Draft/CheckerboardCornerClosedFormsAristotle.lean
  expected_module: PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle
  submission_project: AgentTasks/aristotle-submit/checkerboard-corner-closed-forms-20260613-project
  output_dir: AgentTasks/aristotle-output/fca75150-da8b-488c-93c3-5189022b8718
  status: integrated
```
