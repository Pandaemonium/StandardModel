# Aristotle task: Spin(10) Selector Theorem (Job 3)

Date: 2026-06-14

## Goal

Fill the `sorry` target in:

```text
PhysicsSM/Draft/Spin10StabilizerSelector.lean
```

targeting:

- `physical_embedding_selected_by_krasnov_pair`

## Mathematical Intent

Prove the Selector Theorem: the physical embedding class is the unique conjugacy class in `evenCliffordGroup` stabilizing a Krasnov pair of pure spinors.
This combines the transitivity and stabilizer isomorphism theorems into the capstone logical equivalence of the Spin(10) stabilizer program.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide` in the final proof.
- Keep conventions explicit.
- Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/Spin10StabilizerSelector.lean
```

Axiom check on finished targets: only standard Mathlib axioms.

## Submission

```yaml
aristotle:
  job_id: bbc6e4c9-72ee-4a8b-80d5-ada59d7eef1e
  target_file: PhysicsSM/Draft/Spin10StabilizerSelector.lean
  expected_module: PhysicsSM.Draft.Spin10StabilizerSelector
  submission_project: AgentTasks/aristotle-submit/spin10-stabilizer-selector-20260614-project
  output_dir: AgentTasks/aristotle-output/bbc6e4c9-72ee-4a8b-80d5-ada59d7eef1e
  status: submitted
```
