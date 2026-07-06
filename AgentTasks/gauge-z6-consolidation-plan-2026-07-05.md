# Gauge Z6 consolidation plan (2026-07-05)

Actions grand-strategy audit finding 2.8 / D1 (lead greenlit consolidation): the
`PhysicsSM/Gauge` tree has 21 of 46 files named `StandardModel*Z6*` /
`*Quotient*` / `*Kernel*` (~4000 lines), the clearest instance of the
"many narrow near-duplicates" anti-pattern. This is TRUSTED code with a chain of
23 cross-imports, so the merge must be dependency-aware and build-verified - a
focused task, not a rushed one. This file scopes it; execution is a separate
commit series.

## Ground truth

21 files, layered by import (sampled): `Z6KernelMap` <- `Z6KernelEquiv`;
`Z6FiniteKernel` <- `Z6Kernel`; package/equiv files sit above the core. Each file
holds a handful of narrow lemmas (phase, kernel-elt maps, surjectivity,
bijectivity, quotient laws). All are `s o r r y`-free; footprints should be
kernel-trust (verify with `#print axioms` before/after - the merge must NOT
change any footprint).

## Target structure (21 files -> ~5 + 1 aggregator)

Group by dependency layer / theme, preserving ALL theorem names (so downstream
imports need only path updates, not renames):

1. `StandardModelZ6Kernel.lean` (merge: `Z6Kernel`, `Z6FiniteKernel`,
   `Z6KernelMap`, `Z6KernelEquiv`, `Z6KernelPackage`, `UnitZ6Kernel`,
   `UnitZ6ExactKernelPackage`, `ProductCoveringTrueZ6Kernel`) - the Z6 kernel of
   the covering map and its finiteness/exactness.
2. `StandardModelZ6QuotientMonoid.lean` (merge: `Z6QuotientMonoid`,
   `Z6QuotientMonoidEquiv`, `Z6QuotientMonoidLaws`, `Z6QuotientScaffold`).
3. `StandardModelZ6QuotientImage.lean` (merge: `Z6ImageQuotient`,
   `Z6QuotientImageFiber`, `Z6QuotientImageEquiv`, `Z6IdentityFiber`).
4. `StandardModelZ6SMBlock.lean` (merge: `ProductCoveringQuotientSMBlock`,
   `ProductCoveringTrueQuotientSMBlock`, `UnitZ6SMBlockEquiv`,
   `UnitZ6QuotientGroup`) - the (SU(3)xSU(2)xU(1))/Z6 block equivalences.
5. `QunitQubitQutritQuotientRepresentation.lean` - keep standalone (distinct
   topic) OR fold into SMBlock if it only depends on it.
6. `StandardModelZ6.lean` - NEW pure-import aggregator over the merged 5, with a
   docstring theorem-map, wired into the default root in place of the 21
   individual imports.

## Execution recipe (per merged module, safe + reversible)

1. `#print axioms` every public theorem in the group; record the footprints.
2. Concatenate the group's files into the target, preserving namespaces and
   theorem names; drop now-internal imports; keep docstrings.
3. `grep -rl "import PhysicsSM.Gauge.<oldfile>"` across the repo; repoint every
   importer to the merged module (or the aggregator).
4. `lake build` the merged module, then the aggregator, then a full `lake build`.
5. Re-run `#print axioms` on the same theorems; CONFIRM identical footprints (the
   merge must be behavior-preserving).
6. Delete the old files only after the full build is green and footprints match.
7. Add the merged flagships to `Gauge/AxiomGuard` (new, mirroring
   QMF/E8/Furey/AxiomGuard) so the consolidated results get the build-enforced
   footprint guard too.

## Risk / stop conditions

- TRUSTED tree: a broken import breaks the default `PhysicsSM` build. Do it one
  group at a time, full-build between groups, never batch all five blind.
- If any theorem's `#print axioms` changes after merge, STOP - the concatenation
  reordered a definition or dropped a hypothesis; investigate before proceeding.
- Do not rename any public theorem in this pass (rename is a separate,
  reviewable change); path-only moves keep the diff mechanical.

## Estimated effort

~1 focused session (5 merge commits + import repointing + a full build per
group). Cheap in proof effort (zero new proofs), moderate in mechanical care.
Highest value: navigability of the ~1000-file repo and a smaller public surface,
per the audit's "few general results + curated index" recommendation.

## UPDATE (2026-07-05): the subtree has CONFLICTING duplicate definitions

Attempting a naive "import all 21" aggregator FAILED with a hard environment
collision, revealing a real problem the plan must account for:
`PhysicsSM.Gauge.StandardModelSubgroup.SMProductCoveringTriple` is defined
INCOMPATIBLY in three files:
- `StandardModelProductCoveringTriple.lean:136` - `structure SMProductCoveringTriple`
  (the canonical one; this module IS imported by the default `PhysicsSM` root).
- `StandardModelProductCoveringQuotientSMBlock.lean:50` -
  `abbrev SMProductCoveringTriple := SMCoveringTriple` (a DIFFERENT thing, same
  fully-qualified name; NOT imported by the default root).
- `StandardModelProductCoveringTrueQuotientSMBlock.lean` - adds more
  `SMProductCoveringTriple.*` defs on top.

Consequences for the consolidation:
1. These modules CANNOT be co-imported - so the naive aggregator is impossible,
   and the merge cannot simply concatenate; the duplicate must be resolved first.
2. The `QuotientSMBlock` / `TrueQuotientSMBlock` track appears to be an ALTERNATE
   (possibly superseded / dead) formulation NOT in the default build. Before
   merging, DECIDE: is it live, superseded, or dead? If dead, delete it (biggest
   single consolidation win); if an alternate track, rename its `abbrev` to a
   distinct name so both can coexist / be co-imported.
3. This is a JUDGMENT call about which formulation is canonical - best made with
   the maintainer, not mechanically. It elevates step 0 of the execution recipe
   from "record footprints" to "reconcile the SMProductCoveringTriple duplicate
   and prune/rename the alternate track."

So the consolidation is genuinely non-trivial (real conflicting duplicates, not
just verbose naming) and its highest-value first action is resolving this
duplicate - likely pruning a dead alternate track - not a mechanical file merge.

## UPDATE 2 (2026-07-05): full Gauge-tree dead-module + duplicate scan

Read-only scan of all 46 `PhysicsSM/Gauge/*.lean`. Comprehensive consolidation
targets (all deletions are the MAINTAINER's call - surfaced, not executed):

DEAD / zero-importer modules (nothing in the repo imports them):
- `SU2.lean`, `SU3.lean`, `U1.lean` - EMPTY STUBS ("Status: stub", empty
  namespace). Aspirational placeholders; the real SU(3)/SU(2)/U(1) content lives
  elsewhere (the covering/Z6 files, `BlockEmbeddings`, etc.). Naming irony:
  `Gauge/SU3.lean` is empty while the color group work is in verbosely-named
  files.
- `StandardModel.lean` - stub that claims to "assemble SU3/SU2/U1" which are
  themselves empty stubs. Dead.
- `StandardModelProductCoveringQuotientSMBlock.lean` (353 lines) - orphaned,
  carries the conflicting `SMProductCoveringTriple` abbrev (UPDATE 1). Dead.

DUPLICATE declaration base-names across different Gauge files: ONLY
`SMProductCoveringTriple` (isolated - not a pervasive collision problem).

Revised consolidation priority (highest value first, all low-risk since the
dead modules have 0 importers):
1. Prune the 4 empty stubs (`SU2`/`SU3`/`U1`/`StandardModel`) IF they are not
   reserved placeholders - trivial win, removes the misleading "empty SU3"
   naming. (Maintainer: are these reserved for future real content?)
2. Prune / reconcile `ProductCoveringQuotientSMBlock` (dead + conflicting def).
3. THEN the thematic Z6 merge (UPDATE 1 recipe), now unblocked (no live
   co-import collision remains once the dead conflicting module is gone).

Net: the consolidation is mostly SAFE DELETION of dead/stub modules (5 files,
~430 lines) plus one thematic merge - not a risky live-code refactor. The one
judgment call is whether the 4 stubs are reserved placeholders.
