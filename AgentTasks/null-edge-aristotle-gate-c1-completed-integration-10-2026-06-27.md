# Null-edge Aristotle Gate C1 completed integration 10

Date: 2026-06-27

Integrated jobs:

```text
C155: point-splitting/flavored-mass dictionary
Project: 33efa8c6-2015-49d8-8c70-a5487e766ee8
Task: 973d1a78-e278-40c3-b661-425285cc6f8c

C159: NullEdgeReferenceOverlapImport theorem package
Project: a977c2ed-c8f6-4f25-8160-a8d56e5c2e2a
Task: b9f1fe71-7df2-4bd2-8d0a-2bd5fe82f6ee
```

## Executive result

C159 gives the central theorem-interface for the current Gate C1 strategy.
C155 gives the best concrete construction language so far for `W_branch`.

Together, they sharpen the current plan:

```text
point-split flavored/species mass W_branch
  -> mass-window/sign-straddling seed
  -> sector-signature match
  -> uniformly gapped reference import
  -> GateC1_NU
```

## C159: reference-overlap import interface

C159 delivered a design document and a kernel-checkable Lean skeleton.

The design document was copied to:

```text
AgentTasks/null-edge-c159-reference-overlap-import-design-2026-06-27.md
```

Core theorem shape:

```text
NullEdgeReferenceOverlapImport:
  finite seed input
  + sector-signature match
  + uniformly gapped homotopy
  + mass window / sign straddling
  + reference GW / one-Weyl / bad-gap data
  + anomaly, ghost, and control certificates
  -> GateC1_NU.
```

Important structural guards:

```text
finite seed is not the release;
GateC1_NU is not GateC1_local;
anomaly/index and determinant-line health require explicit certificates;
control/locality is not free from a homotopy;
bad-sector removal must be inverse-propagator gap, not propagator zero.
```

The Lean skeleton remains in the downloaded artifact. It is useful as a future
draft API source, but it was not promoted into live Lean in this pass.

## C155: point-splitting/flavored-mass dictionary

C155 delivered a dictionary document and a finite Lean core.

The dictionary was copied to:

```text
AgentTasks/null-edge-c155-pointsplit-dictionary-integration-2026-06-27.md
```

Core dictionary:

```text
Brillouin-zone corner
  -> null-edge branch

corner level / number of pi-components
  -> branch grading

single cos(a p_mu) factor
  -> one-edge branch-Pauli sign

product_mu cos(a p_mu)
  -> point-split flavored mass W_branch

taste projector
  -> branch/flavor projector
```

The formal core proves:

```text
psMass = product over branch Pauli signs;
psMass is +/-1 by branch parity;
psMass sign-straddles for dimension >= 1;
constant mass cannot sign-straddle;
the branch split is balanced.
```

This is a significant upgrade: the preferred `W_branch` is no longer an
abstract inserted Pauli factor. It should be modeled as a null-edge
point-split/flavored/species mass, directly analogous to naive/flavored-overlap
reference kernels.

## Updated blocker state

C159 turns the physical Gate C1 problem into a theorem-interface checklist.
C155 supplies a concrete candidate family for the mass-window part of that
checklist.

Remaining key blockers:

```text
choose the exact null-edge point-split W_branch;
prove its mass window for actual H_ne;
match sector signatures to a reference flavored-overlap/domain-wall kernel;
construct a uniformly gapped homotopy;
prove or import overlap linearization and bad-sector gap;
discharge SMActsInternally;
provide anomaly/index and non-ultralocal control certificates.
```

## Lean promotion note

The C155 and C159 Lean artifacts were not promoted into the live source tree in
this pass. They should be considered strong candidates for a follow-up Lean
integration pass after namespacing, text-hygiene cleanup, and local checks.
