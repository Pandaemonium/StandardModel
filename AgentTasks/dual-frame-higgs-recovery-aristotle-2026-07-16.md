# Aristotle job: exact dual-frame Higgs derivative recovery

Date: 2026-07-16
Work item: `GRAV-ORDER-OPERATOR-001`
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/dual-frame-higgs-recovery-20260716-20260716-225757.md`
(SHA-256 `C8F3630AC957F0D56A0A5935F09FB397A9DCFC9C066EC0D93BBCE35390F0AE71`).

## Objective

Prove the finite real-to-complex linear algebra for a supplied local sample
matrix and real left inverse:

- exact recovery of every complex derivative vector;
- injectivity of the complex sample map;
- zero samples force zero derivative components;
- an explicit four-component identity-frame control.

## Exact target

`AgentTasks/aristotle-standalone/dual-frame-higgs-recovery-20260716/DualFrameHiggsRecovery/Core.lean`

Preserve every public definition and theorem statement. Small private helpers
are welcome. The matrix identity is over `Real`, while the synthesized and
recovered vectors are `Complex`; do not replace the theorem by a purely real
version or add a complex left-inverse hypothesis.

## Scope boundary

The left inverse is supplied. This target does not derive a null-edge sample
matrix, prove rank availability, bound a condition number, select a shell,
construct a coframe, fit noisy data, or prove refinement or continuum
convergence. Exact identity-frame recovery is a nonvacuous algebraic control,
not evidence that an order-native frame exists.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly four intended proof-hole warnings and no errors. Source SHA-256:
`17C10ED764B39AD4FBA7959227B84A8A1F6FAA42D274FDD312FFEEC404CF89CB`.

## Submission metadata

```yaml
aristotle:
  project_id: 3eb2c62e-1dc3-4836-8065-153a8a7b7663
  task_id: 4f364a12-34be-4e0d-a8fd-1212197f0910
  target_file: DualFrameHiggsRecovery/Core.lean
  expected_module: DualFrameHiggsRecovery.Core
  source_root: AgentTasks/aristotle-standalone/dual-frame-higgs-recovery-20260716
  submission_project: AgentTasks/aristotle-submit/dual-frame-higgs-recovery-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle reported the project as
created and the task as `QUEUED`; no wait loop was started.

## Integration review

Aristotle completed all four proof targets. The returned file changed only the
proof bodies; every public definition and theorem statement was preserved.
The candidate replayed under the pinned toolchain and was ported to
`PhysicsSM/Draft/NullEdge/DualFrameHiggsRecovery.lean` with four
build-enforced axiom guards. The production module passes targeted
`lake env lean` and `lake build`; Lean MCP reports no diagnostics, no
suspicious source patterns, and only the standard three axioms on every
guarded theorem.

Output directory:
`AgentTasks/aristotle-output/3eb2c62e-1dc3-4836-8065-153a8a7b7663/`.
