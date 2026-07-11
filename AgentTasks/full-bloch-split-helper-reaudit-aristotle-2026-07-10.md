# Aristotle audit task: exact split-job full-Bloch helper

Audit the included `NullEdgeBlochDet/Determinants.lean` exactly as submitted to
the live plus/minus determinant projects. This is the preserved generated
snapshot, not the older 83-line standalone source.

Independently check:

- all 24 signs in `det_fin_four` against Mathlib determinant conventions;
- every entry of `factor_alpha1`, `factor_alpha2`, `factor_alpha3`, and
  `factor_beta` against the defining matrices and factor convention;
- every entry and multiplication order in `splitStep_eq`;
- whether the raised heartbeat/depth options affect trust;
- placeholder and axiom footprint;
- compatibility with the zero/pi polynomial conventions used by the active
  plus/minus targets.

Use independent Lean checks or symbolic evaluation where useful. Do not edit
the source. Return severity-ordered findings and state whether projects
`d13856aa` and `5337cc9e` may safely rely on these helpers while proving their
own determinant identities.

```yaml
aristotle:
  project_id: 57fc7076-66da-4194-9ebb-f3e90c501611
  task_id: 06d97fc3-5b3d-4de6-bbda-f31e5d764e92
  target_file: NullEdgeBlochDet/Determinants.lean
  expected_module: NullEdgeBlochDet.Determinants
  submission_project: AgentTasks/aristotle-submit/full-bloch-split-helper-reaudit-20260710-project
  output_dir: AgentTasks/aristotle-output/57fc7076-66da-4194-9ebb-f3e90c501611
  status: submitted
```
