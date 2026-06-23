# Aristotle task: P9 strict projected-kernel core

```yaml
aristotle:
  project_id: 6dfa769d-2271-4cbf-aca6-4a05e7827254
  target_file: NullEdgeP9StrictProjectedKernel/Core.lean
  expected_module: NullEdgeP9StrictProjectedKernel.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-strict-projected-kernel-20260623-project
  output_dir: AgentTasks/aristotle-output/6dfa769d-2271-4cbf-aca6-4a05e7827254
  status: integrated
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: upgrade projected noise from mere positivity to a no-hidden-
null-modes guardrail. If the original finite noise kernel is strictly positive
and the projected test is nonzero, the projected response should be strictly
positive; zero projected response should be equivalent to a zero projected
test.

## Local preflight

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-strict-projected-kernel-20260623/NullEdgeP9StrictProjectedKernel/Core.lean
```

The target typechecks with only the intended proof-hole warnings.

## Submission note

Submitted as focused Aristotle project
`6dfa769d-2271-4cbf-aca6-4a05e7827254`.

## Integration note

Integrated into `PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean` and
imported by `PhysicsSMDraft.lean`. Verified with:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean
lake build PhysicsSM.Draft.NullEdgeP9StrictProjectedKernel
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9StrictProjectedKernel.lean
```

Bookkeeping note: Aristotle may report this project as `COMPLETE_WITH_ERRORS`
at the API level because its own broader verification did not finish cleanly.
The live module is nevertheless integrated and verified locally with the
commands above, so this is not an outstanding integration item.
