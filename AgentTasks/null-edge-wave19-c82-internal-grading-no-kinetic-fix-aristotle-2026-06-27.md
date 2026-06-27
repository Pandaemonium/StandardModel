# Aristotle task C82: internal grading alone cannot polarize external kinetic balance

```yaml
aristotle:
  project_id: 893fe869-0e3c-40c5-b0cd-aa302f1a21ea
  task_id: 9340871d-3a1f-4bdf-acb6-adcb136e0790
  target_file: PhysicsSM/Draft/NullEdgeInternalGradingNoKineticFix.lean
  expected_module: PhysicsSM.Draft.NullEdgeInternalGradingNoKineticFix
  submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/893fe869-0e3c-40c5-b0cd-aa302f1a21ea
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

Formalize Pro's Gate H/Gate C separation:

If the kinetic operator factors as `D_ext(q) tensor 1_E`, and the external origin kernel contains a plus and minus `Gamma_s` pair, then tensoring with an internal grading `chi_E` does not make the origin branch pure for `Gamma_s tensor chi_E`.

This protects the program from a tempting but false shortcut: using Furey/internal `chi_E` alone to repair C21's external kinetic chirality balance.


Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeInternalGradingNoKineticFix.lean`.

Requested theorem shapes:

```text
balanced_pair_tensor_internal_remains_balanced
internal_grading_does_not_polarize_factorized_kernel
chiE_alone_not_gateC_kinetic_fix
```

An abstract finite-dimensional/vector-space model is acceptable. The key is the theorem statement: one external plus eigenvector and one external minus eigenvector tensor the same nonzero internal eigenvector to produce opposite `Gamma_s tensor chi_E` signs.


Scope guardrails:

Do not make claims about the full Furey internal spectrum. This is a negative structural lemma about factorized kinetic operators only. It should support, not replace, Gate H.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 893fe869-0e3c-40c5-b0cd-aa302f1a21ea
task_id: 9340871d-3a1f-4bdf-acb6-adcb136e0790
submission_project: AgentTasks/aristotle-submit/null-edge-wave19-regulator-legality-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeInternalGradingNoKineticFix.lean
```
