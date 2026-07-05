# Aristotle proof-design audit: Q7 support-counting theorem surface

You are acting as a Lean proof-design strategist for the Q7
strong-coupling polymer-map lane of a Lean 4 mathematical physics
formalization.  The target is the next theorem surface after the
kernel-checked support-localization API.  This is a statement-design and
Mathlib-search job, not a request to claim a finite KP bound.

Formatting: ASCII only, LF line endings.  In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Project context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

Current Q7 file:

```text
PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
```

Recent Q7 progress:

- `PlaquettePolymer` is support-indexed, so labels outside support no longer
  overcount physical polymers.
- `plaquetteKPSum` and `PlaquetteKPBound` name the explicit rooted finite KP
  sum and its bound predicate.
- `kpCondition_of_plaquetteKPBound` adapts an explicit finite bound to
  `PolymerKPCriterion.KPCondition`.
- `kpCondition_and_selfIncompatible_of_plaquetteKPBound` packages the Q7
  `KPCondition` with self-incompatibility for Q6.
- `closedTouchNeighborhood` and
  `SupportsOverlapOrTouch.iff_exists_right_mem_closedTouchNeighborhood` now
  characterize overlap-or-touch incompatible supports as exactly those meeting
  the root support's closed touch-neighborhood.

The previous audit report is:

```text
AgentTasks/ym-q7-kp-bound-adapter-audit-2026-07-05.md
```

It recommends next:

1. A pure support-size/counting lemma for connected polymers incompatible with
   a fixed root, in terms of a local branching/degree constant.
2. Only after that, a finite Z2 fixture proving `PlaquetteKPBound` for one
   small geometry.
3. Only after Q6 closes, Q7-to-Q8 tail/clustering consequences.

## Files to inspect

Please inspect at least:

```text
PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean
PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/ym-q7-kp-bound-adapter-audit-2026-07-05.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md
```

Semantic context-pack preflight included:

```text
AgentTasks/context-packs/ym-q7-support-counting-strategy-20260704-20260704-173937.md
```

Use the context pack only as context-selection evidence.  The Lean files and
run notes are authoritative.

## Local verification already run

After the support-localization updates:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.StrongCouplingPolymerMap
lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM
lake build
```

All passed locally.  The full build was 8295 jobs with existing
info/linter/deprecation chatter only.  The new support-localization lemmas have
dependency footprint `[propext, Quot.sound]`.

## Questions

1. Is the current `closedTouchNeighborhood` / iff API the right first
   reduction for counting rooted incompatible polymers?  If not, what exact
   correction should be made?
2. What is the smallest honest Lean API for connected plaquette supports that
   can support a volume-uniform count?  For example, should Q7 introduce a
   concrete graph-connected predicate built from `PlaquetteAdjacency.touch`, a
   bounded-degree hypothesis, or an abstract counting hypothesis first?
3. Search Mathlib for useful finite graph / connected-set counting lemmas.
   Does Mathlib already have a lemma bounding the number of connected finite
   subsets of size `k` meeting a finite anchor set in a bounded-degree graph?
   If not, what is the nearest API and what must be built locally?
4. Propose exact Lean theorem statements for the next support-counting package.
   The statements should be small enough to land before proving a concrete
   `PlaquetteKPBound`, and they must not hide the hard combinatorics behind an
   unreviewed hypothesis.
5. If a small theorem can already be proved from the current Q7 file, return a
   Lean patch.  Otherwise return a statement DAG and proof plan.

## Guardrails

- Do not claim a concrete finite KP bound or a volume-uniform small-beta
  theorem.
- Do not weaken the existing Q7 statements.
- Do not import a large new theory stack unless it is clearly needed and
  justified.
- Keep the result compatible with the support-indexed `PlaquettePolymer` design.
- Prefer an API that later specializes to the finite Z2 oracle fixture but is
  not hard-coded to it.

## Output format

Return a concise report with:

1. Verdict on the current support-localization API.
2. Mathlib search findings.
3. Recommended theorem package, ordered by dependency.
4. Exact Lean statement sketches, with namespaces and parameters.
5. Proof plan and known blockers.
6. If you changed Lean, include the changed file contents or a patch summary,
   and state exactly what was verified.
