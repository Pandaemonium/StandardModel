Gate C1 promoted Draft leaf static audit, C225

You are Aristotle working on the StandardModel Lean 4 project.

Project context:

The null-edge Gate C1 program has pivoted to a controlled non-ultralocal
release target, `GateC1_NU_Free`, using a Wilson/Neuberger overlap reference
decorated by a CKM internal branch/flavor mass texture. CKM must not be treated
as the primary spacetime doubler-resolution operator. Wilson/Neuberger resolves
spacetime corners; CKM splits finite branch/flavor sectors.

Recent returned artifacts were locally promoted into Draft leaves, but no local
Lean checks have been run yet. The promoted files in this request project are:

- `CKMWilsonWindow.lean`
- `GappedHomotopy.lean`
- `SignStability.lean`
- `ProjectorPersistence.lean`

Task:

Perform a static audit of these four promoted Draft leaves.

Please answer:

1. Which declarations are the most important reusable theorem spine?
2. Are there namespace, import, duplicate-name, argument-order, or convention
   collision risks among these four files?
3. What is the smallest safe import/namespace structure for a later local
   aggregator module?
4. Which theorem names should be aliased or wrapped, and which should remain
   private to their source namespace?
5. Are any statements too broad or semantically risky for the Gate C1 use case?
6. What exact local patch plan should Codex apply before running targeted Lean
   checks?

Constraints:

- Do not weaken mathematical statements.
- Do not invent a full Gate C1 theorem.
- Do not claim local project verification unless you actually run a check in
  this request project.
- Treat these as Draft artifacts only.
- Preserve the claim boundary: these files do not close `GateC1_NU_Free` until
  `H_ref`, `H_ne`, transport, sector-signature match, and the kappa inequality
  are instantiated.

Requested output:

Return a concise but concrete integration report:

- reusable declarations;
- collision risks;
- recommended namespace/import plan;
- exact patch recommendations;
- verification status;
- remaining blockers.
