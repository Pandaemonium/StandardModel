# CodeLatticeE8 root-bridge follow-up Aristotle job - 2026-05-21

Status: complete, integrated 2026-05-21.

Aristotle job ID:

```text
56691706-08a0-4637-8aa7-fcc19945abce
```

Submission project:

```text
AgentTasks/aristotle-submit/code-lattice-e8-rootbridge-followup-20260521-project
```

Context:

- Job `b5779bc1-d8be-4777-a4bf-ee444176dffe` was useful and has been
  integrated.
- It removed the monolithic 240-by-240 `native_decide` proof of
  `shortShell_perm_rootList`.
- The permutation theorem now follows from nodup, subset, and length, where
  length uses the structural short-vector count.
- The follow-up removed the remaining local bounded checks from
  `CodeLatticeE8/E8/RootBridge.lean`.

Target file:

```text
CodeLatticeE8/E8/RootBridge.lean
```

Original target facts:

```lean
theorem shortShellVectorList_nodup : shortShellVectorList.Nodup

private theorem shortShellVectorList_mem_shortShell :
    shortShellVectorList.Forall (· ∈ hammingE8ShortShell)

private theorem shortShell_encoded_in_list :
    ∀ f : Fin 8 → Fin 5,
      (fun i => shortCoordVals5 (f i)) ∈ hammingE8ShortShell →
      (fun i => shortCoordVals5 (f i)) ∈ shortShellVectorList

private theorem shortVectorToRootCoords_mem_rootList_all :
    shortShellVectorList.Forall
      (fun z => shortVectorToRootCoords z ∈ rootList)

private theorem shortVectorToRootCoords_map_nodup :
    (shortShellVectorList.map shortVectorToRootCoords).Nodup
```

Result:

All target facts were either replaced by kernel-verified `decide` proofs or
eliminated by the new cardinality argument in `RootBridge.lean`.  The file now
has no `native_decide` proofs.

Original goal:

Reduce or eliminate the remaining local `native_decide` checks in
`RootBridge.lean` without changing public names or conventions.

Preferred proof directions:

1. Prove source-list facts structurally from the decomposition
   `coordinateShortVectorList ++ weightFourShortVectorList`.
2. Reuse `hammingConstructionA_short_vector_count` and
   `shortShell_mem_shortShellVectorList` where possible.
3. For image membership, try to route through the semantic predicate
   `Roots.IsE8Root` and `Roots.mem_rootList_iff_isE8Root`, rather than direct
   list membership.
4. For image nodup, prefer an injectivity or inverse argument for
   `shortVectorToRootCoords` on `hammingE8ShortShell`, if feasible.

Constraints:

- no `PhysicsSM` imports;
- no SPL imports;
- no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`;
- do not weaken theorem statements;
- preserve the doubled-coordinate root convention and the existing bridge map;
- do not introduce public names containing provenance words such as
  `Aristotle`, `NoNative`, `Helper`, or `Final`;
- if full removal is too large, produce the smallest sorry-free strengthening
  and report exactly which local checks remain.

Verification before return:

```text
lake build CodeLatticeE8.E8.RootBridge
lake build CodeLatticeE8
```

Submission note:

The live package was checked with `lake build CodeLatticeE8` before
submission.  A build attempted inside the isolated submission copy timed out
while setting up its own dependencies, so that isolated-copy check was not
claimed as passing.
