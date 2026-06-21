# Aristotle task: Theta constant duplication identities

Date: 2026-06-12

## Goal

Fill the 2 `sorry`s in

```text
PhysicsSM/Draft/ThetaDuplicationIdentities.lean
```

proving the duplication identities:

- `theta4_sq_eq`: $\Theta_4(\tau)^2 = \Theta_3(2\tau)^2 - \Theta_2(2\tau)^2$
- `theta2_sq_eq`: $\Theta_2(\tau)^2 = 2 \Theta_2(2\tau) \Theta_3(2\tau)$

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, `unsafe`, and no `native_decide`.
- Do not change definitions or sign conventions. Helper lemmas welcome.

## Verification

```bash
lake env lean PhysicsSM/Draft/ThetaDuplicationIdentities.lean
```

Axiom check on each finished theorem: only `[propext, Classical.choice, Quot.sound]`.

## Submission

```yaml
aristotle:
  job_id: d63a6632-3cf6-48ed-be12-5e0ecb45f2c7
  target_file: PhysicsSM/Draft/ThetaDuplicationIdentities.lean
  expected_module: PhysicsSM.Draft.ThetaDuplicationIdentities
  submission_project: AgentTasks/aristotle-submit/wave7-20260612-project
  output_dir: AgentTasks/aristotle-output/d63a6632-3cf6-48ed-be12-5e0ecb45f2c7
  status: submitted
```
