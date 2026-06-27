# Claude adversarial review request: cycle 11 Aristotle integration helper patch

Date: 2026-06-27.

Please review the attached source file:

```text
Scripts/aristotle/integrate_completed.py
```

## Context

The autonomous loop repeatedly hit the same friction:

- C95 returned `PhysicsSM/Draft/NullEdgeAntiVectorializationGuardrail.lean`, but
  `integrate_completed.py` reported no candidates.
- C98 returned `PhysicsSM/Draft/NullEdgeChiralIndexWitnessGuardrail.lean`, but
  `integrate_completed.py` again reported no candidates.
- C97 returned `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean` under
  a nested archive root.

The common pattern was:

```text
AgentTasks/aristotle-output/<project>/extracted/project-files.tar/<task>_aristotle/PhysicsSM/Draft/Foo.lean
```

The old helper only discovered files named `Aristotle.lean` when no task metadata
was provided, so direct returned modules were invisible.

## Patch intent

The patch adds:

- `repo_relative_from_payload(path)` to recognize repo-shaped `PhysicsSM/*.lean`
  payloads inside nested Aristotle archives;
- `differs_from_repo(source, repo_relative)` to ignore unchanged context copies;
- broader fallback discovery for no-metadata projects: include returned
  `PhysicsSM/*.lean` files only if they are new or differ from the live repo.

## Questions

1. Does the patch address the C95/C97/C98 nested archive miss without making the
   helper too eager?
2. Is there a path-safety or accidental-copy risk I missed?
3. Are there edge cases where unchanged context files would still be listed as
   candidates?
4. Should this patch be accepted as-is, or should the next loop cycle refine it?

Please answer briefly and adversarially.
