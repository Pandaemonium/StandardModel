# Aristotle task: Spin(10) Group Stabilizer Transitivity (Job 1)

Date: 2026-06-14

## Goal

Fill the `sorry` target in:

```text
PhysicsSM/Draft/Spin10StabilizerTransitivity.lean
```

targeting:

- `evenCliffordGroup_transitive_on_krasnov_pairs`

## Mathematical Intent

Prove that the general algebraic even Clifford group (`evenCliffordGroup`) acts transitively on collinear pure-spinor pairs `(ψ₁, [ψ₂])` with intersection dimension `d = 3`.
The trusted core `PhysicsSM.Spinor.SpinorTenfoldBasisOrbit` proves transitivity on basis spinors up to scale; this task extends it to general pure-spinor pairs.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide` in the final proof.
- Keep conventions explicit.
- Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/Spin10StabilizerTransitivity.lean
```

Axiom check on finished targets: only standard Mathlib axioms.

## Submission

```yaml
aristotle:
  job_id: 23783893-0688-4b07-aaf8-3cbe3f811fef
  target_file: PhysicsSM/Draft/Spin10StabilizerTransitivity.lean
  expected_module: PhysicsSM.Draft.Spin10StabilizerTransitivity
  submission_project: AgentTasks/aristotle-submit/spin10-stabilizer-transitivity-20260614-project
  output_dir: AgentTasks/aristotle-output/23783893-0688-4b07-aaf8-3cbe3f811fef
  status: submitted
```
