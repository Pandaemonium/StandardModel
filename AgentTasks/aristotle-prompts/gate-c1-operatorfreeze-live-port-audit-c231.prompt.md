Gate C1 OperatorFreeze live-port audit, C231

You are Aristotle helping the StandardModel null-edge Gate C1 program.

Context:

C225-C227 were integrated into the live repo as Draft code without local Lean
checks. The live Draft files in this request project are:

- `CKMWilsonWindow.lean`
- `GappedHomotopy.lean`
- `SignStability.lean`
- `ProjectorPersistence.lean`
- `OperatorFreeze.lean`

`OperatorFreeze.lean` was ported from a focused standalone Aristotle package by
adjusting imports to live module paths. The live repo has not been checked.

Task:

Do a static live-port audit focused on the five files.

Please answer:

1. Are the live import paths in `OperatorFreeze.lean` semantically correct for
   the repo module layout?
2. Are there namespace/name risks introduced by `OperatorFreeze`?
3. Does `OperatorFreeze` rely on any declarations whose names or namespaces
   differ between the standalone package and the live files?
4. Does the new C226 pair of lemmas in `ProjectorPersistence.lean` introduce
   conflicts or require additional imports?
5. What exact local patch plan should Codex apply before running targeted Lean
   checks?
6. Should an import-only aggregator be added now, or only after live checks?

Constraints:

- Treat all files as Draft.
- Do not claim live repo verification unless actually checked in the live repo.
- Do not weaken theorem statements.
- Do not claim GateC1_NU.
- Preserve the Wilson/Neuberger+CKM claim boundary: CKM is internal texture,
  not spacetime doubler resolution.

Requested output:

- live-port risk report;
- exact patch recommendations;
- aggregator recommendation;
- remaining blockers.
