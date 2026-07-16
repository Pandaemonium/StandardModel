# Aristotle proof job: rooted-touch normalization bridge R0

## Context and corrected route

Aristotle audit project `535c94a2-a856-4797-8196-2f4c6ac6f107` found an exact
two-type counterexample to the open unrooted recurrence
`pairSum_le_expBound`; that theorem and its exponential weakening must not be
used. The genuine target `boundedTouchSum_le_kpPsi` instead needs rooted child
subtrees. This job proves the easy first rung of that repaired route: changing
the normalization from `1/n!` to `1/(n-1)!` can only increase the nonnegative
cluster sum.

## Immutable target

Create `PhysicsSM/Draft/NullEdge/GateYM/RootedTouchSum.lean`, importing
`PolymerKPConclusion`, with the following definition and theorem:

```lean
noncomputable def rootedTouchSum (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (K : Nat) (g : Gamma) : Real := by
  classical
  exact sum p : (Sigma m : Fin (K + 2), (Fin m.val -> Gamma)),
    if Cluster.Touches S (Sigma.mk p.1.val p.2) g
      then (spanningTreeCount S hdec (Sigma.mk p.1.val p.2) : Real)
             / (Nat.factorial
                 (((Sigma.mk p.1.val p.2 : Cluster S).n) - 1) : Real)
             * (Sigma.mk p.1.val p.2 : Cluster S).absWeight S
      else 0

theorem boundedTouchSum_le_rootedTouchSum
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec K g <= rootedTouchSum S hdec K g := by
  sorry
```

Use the exact dependent-pair syntax that elaborates in the pinned repository;
the returned audit skeleton used angle-bracket notation for the same objects.
Do not alter the summation domain, touch predicate, tree count, absolute weight,
or either factorial normalization.

## Proof obligations and controls

- Prove the inequality termwise using nonnegativity and
  `(n - 1)! <= n!`; handle `n = 0` and `n = 1` explicitly so truncated Nat
  subtraction is visible rather than hidden.
- Reuse existing nonnegativity lemmas for `spanningTreeCount` and `absWeight`.
- Do not invoke `pairSum_le_expBound`, `boundedTouchSum_succ_le`, or any theorem
  depending on their open proof hole.
- Add equality controls at the empty/singleton boundary and a strict rational
  control at a cluster size where the factorials differ, if expressible without
  rebuilding the full polymer witness.
- Expected footprint: standard kernel axioms only; no trust-expanding evaluator,
  new axiom, opaque placeholder, or weakened theorem.
- Run the new file directly before any broad build.

## Boundary

R0 is only a normalization bridge. It does not prove the rooted exponential
recurrence R1, the size-to-height bridge, the KP criterion, cluster summability,
or a Yang-Mills mass gap. Those remain separate targets.

## Submission metadata

- Aristotle project: `70a0d064-e2b3-459a-9f9e-c144c8847b6a`
- Submission project: `AgentTasks/aristotle-submit/gauge-rooted-touch-r0-20260713-project`
- Lab work item: `GAUGE-YM-EGF-001`
- Status: submitted 2026-07-13 by Codex
