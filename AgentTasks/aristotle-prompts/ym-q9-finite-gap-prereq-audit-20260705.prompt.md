# Aristotle semantic audit: Q9 finite gap prerequisite package

You are acting as a semantic red-team reviewer for a Lean 4 mathematical
physics formalization. This is an audit job, not primarily proof search. The
goal is to check whether the new Q9 finite-gap prerequisite package and its
claim language match the kernel-checked Lean statements.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Project context

Project: `PhysicsSM`, draft GateYM Yang-Mills / mass-gap ladder.

Recent commit `5186598` added:

```text
PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean
```

The intended claim is:

```text
Q9 doorstep package landed: `FiniteGapAssembly.FiniteGapPrereq` bundles the
already-named local-algebra cyclicity prerequisite with strict ordered
eigenvalue data in the local/trivial-flux sector. From those hypotheses it
derives only the definition-level facts `localGap_eq_finiteMassGap`,
`localGap_nonneg`, and `localGap_pos`.

This is NOT a transfer matrix, Hamiltonian, Wilson slab-kernel, infinite-volume
state, or physical mass-gap theorem. It is a finite hypothesis package that
names the assumptions a later Q9 gap assembly must expose.
```

## Files to inspect

Please inspect at least:

```text
PhysicsSM/Draft/NullEdge/GateYM/FiniteGapAssembly.lean
PhysicsSM/Draft/NullEdge/GateYM/CyclicityPrereq.lean
PhysicsSM/Draft/NullEdge/GateYM/FluxSectorZ2.lean
PhysicsSM/Draft/NullEdge/GateYM/TransferGapDefinition.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md
AgentTasks/fourday-ym-run-2026-07-05/TASK_DIRECTIONS.md
```

Semantic preflight context pack included in the submission:

```text
AgentTasks/context-packs/ym-q9-finite-gap-prereq-audit-20260705-025028.md
```

Use that pack only as context-selection evidence; the Lean files and run notes
are authoritative.

## Local verification already run

```text
lake env lean PhysicsSM\Draft\NullEdge\GateYM\FiniteGapAssembly.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.FiniteGapAssembly
lake env lean PhysicsSM\Draft\NullEdge\GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
pre-commit run --files PhysicsSM\Draft\NullEdge\GateYM\FiniteGapAssembly.lean PhysicsSM\Draft\NullEdge\GateYM.lean AgentTasks\fourday-ym-run-2026-07-05\LEDGER.md
```

All passed locally. The aggregate GateYM build was 8091 jobs with only
pre-existing warnings plus known draft Q6 proof handoffs. Axiom audit:

```text
FiniteGapPrereq.localGap_pos:
  [propext, Classical.choice, Quot.sound]
FiniteGapPrereq.localGap_nonneg:
  [propext, Classical.choice, Quot.sound]
FiniteGapPrereq.localAlgebraCyclicInSector:
  [propext, Classical.choice, Quot.sound]
```

## Questions

1. Does `FiniteGapPrereq` expose the right Q9 inputs, or does the package hide
   a needed hypothesis such as transfer self-adjointness, sector restriction,
   vacuum uniqueness, eigenvector membership, or an actual local-operator
   spectral theorem?
2. Is it semantically honest that `localGap` uses
   `FluxSectorZ2.localGlueballGap` rather than `FluxSectorZ2.fluxGap`, and that
   `localGap_eq_finiteMassGap` is definition-level only?
3. Does bundling `LocalCyclicityPrereq` avoid the fake-gap failure mode, or
   should the package expose a more precise field tying the cyclic sector to
   the spectral data?
4. Are the names `lambda0` and `lambdaLocal` too underspecified for the stated
   claim? If so, propose exact Lean-level field names or docstring edits, not a
   theorem weakening.
5. Are the updated docs and ledger honest? In particular, is it correct to say
   this is a Q9 doorstep / finite hypothesis package while refusing any
   transfer-matrix, Hamiltonian, infinite-volume, or physical mass-gap claim?
6. What theorem or structure should be added next to advance Q9 without
   overclaiming?

## Output format

Return a concise audit report with:

1. Verdict: ACCEPT, ACCEPT WITH CHANGES, or REJECT.
2. Findings ordered by severity, with file/theorem references.
3. Exact claim-language or docstring corrections, if any.
4. Any Lean-level theorem/structure statement that should be added next.
5. Recommended next Q9 step.

Do not weaken Lean theorem statements silently. If you find a semantic
counterexample, hidden restriction, convention mismatch, or overclaim, state it
plainly.
