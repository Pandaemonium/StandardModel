# Aristotle task C85: RA-Wilson accretive gap theorem

```yaml
aristotle:
  project_id: 1dfb54b3-030c-4bf4-a732-7b0356cc9e78
  task_id: 0aa02112-c2ae-4c77-95a4-628bfc433fba
  target_file: PhysicsSM/Draft/NullEdgeRAWilsonGap.lean
  expected_module: PhysicsSM.Draft.NullEdgeRAWilsonGap
  submission_project: AgentTasks/aristotle-submit/null-edge-wave20-c0-c1-rawilson-20260627-project
  output_dir: AgentTasks/aristotle-output/1dfb54b3-030c-4bf4-a732-7b0356cc9e78
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/gate-c-c0-c1-rawilson-20260627-20260627-080920.md`

Wave context:

- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
- `AgentTasks/null-edge-decision-log-2026-06-27.md`
- `AgentTasks/null-edge-pro-hard-problems-briefing-2026-06-27.md`
- `PhysicsSM/Draft/NullEdgeGateCSplit.lean`
- `PhysicsSM/Draft/NullEdgeRegulatorLegalityAPI.lean`
- `PhysicsSM/Draft/NullEdgeRegulatorLegalGateCRelease.lean`
- `PhysicsSM/Draft/NullEdgeKreinOverlapSignTrap.lean`
- `AgentTasks/null-edge-taste-involution-origin-polarization-audit.md`

Kind: proof.

Goal:

Prove the finite linear-algebra core of the Gate C0 RA-Wilson species-health path.

The central lemma is:

```text
If A is anti-Hermitian and m > 0, then A + m I has no kernel.
Preferably also prove a singular-value/norm lower bound:
  ||(A + m I)v||^2 >= m^2 ||v||^2.
```

This should be stated in the simplest Lean-friendly setting that Aristotle can make kernel-clean. Acceptable choices, in descending preference:

```text
1. finite-dimensional complex inner product spaces and linear maps;
2. matrices over Complex with conjugate-transpose anti-Hermitian condition;
3. a real inner-product proxy proving the same accretive-gap pattern for skew-adjoint maps.
```

Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeRAWilsonGap.lean`.

Requested theorem shapes:

```text
antiHermitian_add_posScalar_noKernel
antiHermitian_add_posScalar_injective
antiHermitian_add_posScalar_norm_lower_bound
DRA_block_antiHermitian
RAWilson_gap_schema
```

Scope guardrails:

Do not claim the concrete null-edge operator satisfies the hypotheses unless that is imported and proved directly. It is acceptable to make the final `RAWilson_gap_schema` an abstract theorem saying that any RA double plus positive scalar Wilson mass is gapped off origin. This is a Gate C0 theorem, not a Gate C1 or full Gate C release.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 1dfb54b3-030c-4bf4-a732-7b0356cc9e78
task_id: 0aa02112-c2ae-4c77-95a4-628bfc433fba
submission_project: AgentTasks/aristotle-submit/null-edge-wave20-c0-c1-rawilson-20260627-project
```
