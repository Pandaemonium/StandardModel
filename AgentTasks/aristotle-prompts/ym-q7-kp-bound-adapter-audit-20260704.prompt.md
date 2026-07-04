# Aristotle semantic/proof-design audit: Q7 KP-bound adapter

You are acting as a semantic red-team reviewer and Lean proof-design
strategist for the Q7 strong-coupling polymer-map lane of a Lean 4
mathematical physics formalization.  The goal is to audit the newly integrated
conditional KP adapter and recommend the next exact theorem surface.

Formatting: ASCII only, LF line endings.  In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Project context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

Recent commit `3db7523` added a Q7 bridge in:

```text
PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
```

The intended claim is:

```text
Q7 now has a kernel-checked conditional adapter:
an explicit finite plaquette-polymer rooted KP sum bound
`PlaquetteKPBound` implies the abstract `PolymerKPCriterion.KPCondition`
for `plaquettePolymerSystem`.

This does NOT prove the finite bound, any volume-uniform small-beta
constant, or any concrete geometry/label-counting estimate.
```

The Q6 layer was recently corrected: Aristotle found that the old bare C2
target is false without self-incompatibility.  Q7's conservative
overlap-or-touch polymer system has `plaquettePolymerSystem_self_incompatible`,
so it supplies the missing self-incompatibility convention once a KPCondition
instance is available.

## Files to inspect

Please inspect at least:

```text
PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean
PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/ym-q6-abstract-kp-proof-aristotle-2026-07-04.md
AgentTasks/ym-q7-support-indexed-label-redesign-aristotle-2026-07-04.md
AgentTasks/fourday-ym-run-2026-07-05/DAY_1_REPORT.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md
```

Semantic preflight context pack included in the submission:

```text
AgentTasks/context-packs/ym-q7-kp-bound-adapter-audit-20260704-20260704-154208.md
```

Use that pack only as context-selection evidence; the Lean files and run notes
are authoritative.

## Local verification already run

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.StrongCouplingPolymerMap
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
```

All passed locally.  The aggregate GateYM build was 8078 jobs with only
pre-existing warnings plus known Q6 draft proof handoffs.

New adapter axiom footprint:

```text
plaquettePolymerIncompatibleDecidable:
  [propext, Classical.choice, Quot.sound]
plaquetteKPSum:
  [propext, Classical.choice, Quot.sound]
kpCondition_of_plaquetteKPBound:
  [propext, Classical.choice, Quot.sound]
```

## Questions

1. Does `plaquetteKPSum` match the finite sum in
   `PolymerKPCriterion.KPCondition` for `plaquettePolymerSystem`, including
   the same decidability witness, root polymer, incompatibility filter, weight
   expression, and energy expression?
2. Is `kpCondition_of_plaquetteKPBound` semantically valid under the stated
   nonnegative `gammaAbs` hypothesis, and does it avoid hiding the hard
   finite-bound proof?
3. Does the Q7 system now supply the self-incompatibility hypothesis needed by
   corrected Q6 C2 through `plaquettePolymerSystem_self_incompatible`?
4. Is the claim boundary honest?  In particular, is it correct to say that the
   adapter landed but that no volume-uniform KP theorem, concrete connected
   geometry, finite-irrep label estimate, or Q8 clustering conclusion is
   proved?
5. What exact Lean theorem should be added next?
   Consider options such as:
   - a bridge from `PlaquetteKPBound` plus Q6 corrected C2 to a plaquette
     convergence/tail statement;
   - a concrete finite-geometry theorem proving `PlaquetteKPBound` from a
     combinatorial count;
   - a Z2 finite-torus theorem using the oracle-style parameters
     `beta = 0.04`, `alpha = 0.75` only as a finite fixture;
   - a support-size/counting lemma needed before any volume-uniform estimate.
6. Are any docs stale or overclaiming after the update, especially
   `GateYM.lean`, `DAY_1_REPORT.md`, `LEDGER.md`, and `DISCUSSION.md`?

## Output format

Return a concise audit report with:

1. Verdict: ACCEPT, ACCEPT WITH CHANGES, or REJECT.
2. Findings ordered by severity, with file/theorem references.
3. Exact claim-language corrections, if any.
4. Any Lean-level theorem statement that should be added next.
5. Recommended next Q7/Q8 proof package.

Do not weaken Lean theorem statements silently.  If you find a semantic
counterexample, hidden convention mismatch, or wrong finite-sum expression,
state it plainly.
