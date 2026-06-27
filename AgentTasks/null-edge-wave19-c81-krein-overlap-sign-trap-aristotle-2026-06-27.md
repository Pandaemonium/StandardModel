# Aristotle task C81: Krein self-adjointness is not enough for overlap sign

```yaml
aristotle:
  project_id: 0c61513a-85ac-4c19-bc41-9eaa6142f254
  task_id: fbd0b724-ec20-40d5-b1ef-3a9ca9d695be
  target_file: PhysicsSM/Draft/NullEdgeKreinOverlapSignTrap.lean
  expected_module: PhysicsSM.Draft.NullEdgeKreinOverlapSignTrap
  submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/0c61513a-85ac-4c19-bc41-9eaa6142f254
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/gate-c-regulator-legality-20260627-074056.md`

Wave context:

- `AgentTasks/null-edge-wave19-regulator-legality-analysis-2026-06-27.md`
- `AgentTasks/null-edge-pro-hard-problems-briefing-2026-06-27.md`
- `AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md`
- `AgentTasks/null-edge-overlap-locality-gap-audit.md`
- `AgentTasks/null-edge-point-split-gauge-covariant-flavored-mass-plan.md`
- `AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md`

Kind: proof/strategy.

Goal:

Formalize the finite 2x2 counterexample from Pro's answer:

```text
J = diag(1,-1)
A = [[0,1],[-1,0]].
```

Show that `A` is `J`-self-adjoint but has non-real spectrum/eigenvalue relation `A^2 = -I`, so ordinary Hermitian spectral flow or a real-spectrum sign-function argument cannot be inferred from Krein self-adjointness alone.


Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeKreinOverlapSignTrap.lean`.

Requested theorem package:

```text
kreinTrap_J_self_adjoint
kreinTrap_sq_eq_neg_one
kreinTrap_not_real_spectrum_proxy
krein_self_adjoint_not_overlap_sign_legal
```

Use the simplest matrix representation that is robust in Lean. If explicit spectrum as a set is expensive, prove `A^2 = -1` and an abstract no-real-eigenvalue consequence sufficient for the guardrail.


Scope guardrails:

Do not try to formalize the full analytic matrix sign function. The deliverable is the finite algebraic guardrail showing `J`-self-adjointness does not imply the Hermitian/gapped hypotheses needed by overlap/GW.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 0c61513a-85ac-4c19-bc41-9eaa6142f254
task_id: fbd0b724-ec20-40d5-b1ef-3a9ca9d695be
submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeKreinOverlapSignTrap.lean
```
