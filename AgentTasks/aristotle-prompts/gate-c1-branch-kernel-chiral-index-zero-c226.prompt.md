Gate C1 branchKernel_chiralIndex_zero theorem design, C226

You are Aristotle working on the StandardModel Lean 4 project.

Project context:

Gate C1 is now framed as a Wilson/Neuberger overlap reference import decorated
with a CKM internal branch/flavor mass texture. The current known obstruction
must be preserved:

The bare null-edge branch symbol is chirality-balanced. It does not by itself
release one physical Weyl branch.

The next bridge theorem should translate that known obstruction into the
projector/chiral-index vocabulary used by the later Gate C1 theorem stack.

Files in this request project:

- `NullEdgeActualCliffordSymbol.lean`
- `NullEdgeBranchClassifierAPI.lean`
- `ProjectorPersistence.lean`

Target bridge:

```text
branchKernel_chiralIndex_zero
```

Intended meaning:

The actual C21-style branch kernel has zero chiral index when expressed in the
C202/C205-style projector/chiral-index vocabulary. This theorem is deliberately
not a release theorem. It records that the bare branch kernel remains
chirality-balanced and therefore cannot be the final physical projector.

Task:

1. Inspect the three files and identify the best existing declarations for:
   branch kernel, chirality, projector, rank, and chiral index.
2. Propose the exact Lean theorem statement for
   `branchKernel_chiralIndex_zero`.
3. If feasible in this focused package, implement the theorem or a minimal
   proof skeleton with helper lemmas.
4. If not feasible, return the exact missing definitions/lemmas and a patch
   plan for Codex.
5. Do not route the proof through a false chiral-release claim.

Constraints:

- Preserve the known obstruction: the bare branch kernel has zero chiral index.
- Do not invent a new gamma convention.
- Do not change source definitions to make the theorem easier.
- Do not claim `GateC1_NU_Free`.
- If the local files are not enough to prove the theorem, say exactly what is
  missing rather than weakening the statement.

Requested output:

- exact theorem statement;
- dependency map to existing declarations;
- proof plan or implemented Lean patch;
- any semantic risks;
- next local Codex action.
