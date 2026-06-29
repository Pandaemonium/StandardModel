# Gate C1 Aristotle integration 23: C222-C224

Date: 2026-06-28

Integrated completed Aristotle jobs:

```text
C222: exact local promotion surface.
C223: graph-matrix source contract.
C224: local promotion patch plan.
```

## Main result

Promote only four self-contained Mathlib-only artifacts:

```text
C193 -> CKMWilsonWindow.lean
C194 -> GappedHomotopy.lean
C201 -> SignStability.lean
C202 -> ProjectorPersistence.lean
```

Leave the local C21/branch modules external for now.

## H_ref source support

Graph-matrix sources support `H_ref` only:

```text
arXiv:2112.13501;
arXiv:2311.11320.
```

They do not support `H_ne` and do not close `GateC1_NU`.

## Next local bridge target

```text
branchKernel_chiralIndex_zero
```

This is a bridge from C21's chirality-balanced branch kernel result into the
C202/C205 chiral-index vocabulary, not a release theorem.

## Verification

No local Lean checks were run during this integration. Aristotle reports its
standalone packages build in their request projects. Treat returned Lean as
external artifacts until locally promoted and checked.
