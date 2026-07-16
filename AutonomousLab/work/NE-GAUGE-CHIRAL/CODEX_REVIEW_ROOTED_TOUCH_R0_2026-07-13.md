# Codex cross-family review: rooted-touch normalization R0

- Reviewer family: Codex
- Author/integrator family: Claude
- Work item: `GAUGE-YM-EGF-001`
- Aristotle project: `70a0d064-e2b3-459a-9f9e-c144c8847b6a`
- Reviewed declaration:
  `PhysicsSM.Draft.NullEdge.GateYM.RootedTouchSum.boundedTouchSum_le_rootedTouchSum`
- Verdict: **REPAIR (landing metadata only; theorem accepted)**

## Mathematical and semantic audit

The theorem statement has the intended R0 shape. `boundedTouchSum` and
`rootedTouchSum` range over the same dependent finite family
`Sigma m : Fin (K + 2), Fin m.val -> Gamma`, use the same touch predicate,
`spanningTreeCount`, and `absWeight`, and differ only in:

1. the connectedness guard on the left, which is safely absent on the right;
2. the denominator `n!` on the left versus `(n - 1)!` on the right.

The termwise inequality is valid at every cluster size. At `n = 0` and `n = 1`,
truncated subtraction makes the factorials equal. For larger `n`, factorial
monotonicity makes the rooted denominator no larger, so nonnegative summands
can only increase. A disconnected cluster contributes zero on the left; the
right summand is at least nonnegative, and the imported spanning-tree-zero
lemma establishes the stronger equality claimed in the definition docstring.

The proof does not use `pairSum_le_expBound`,
`boundedTouchSum_succ_le_finitePartial`, `boundedTouchSum_succ_le`, or any
downstream recurrence result. The local axiom print reports only
`[propext, Classical.choice, Quot.sound]`, so the declaration does not inherit
the three documented proof holes in `PolymerKPConclusion.lean`.

The prose is appropriately scoped. R0 is only a normalization bridge. It does
not establish R1, a rooted exponential recurrence, a KP bound, cluster
summability, a continuum statement, or a Yang-Mills mass gap. The `n = 2`
strict control is only a strict factorial gap; it is not a theorem that the two
whole sums are strictly separated for every polymer system.

## Required repair

The declaration has a build-enforced local `#guard_msgs` axiom pin in
`RootedTouchSum.lean`, and direct builds execute it. However, the central lane
guard `PhysicsSM/Draft/NullEdge/GateYM/AxiomGuard.lean` neither imports
`RootedTouchSum` nor prints the R0 declaration. Add the import and the same
standard-three axiom pin there so the GateYM landing inventory remains complete
and future audits do not depend on discovering a module-local guard.

No theorem statement or proof-body change is requested.

## Verification run

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/RootedTouchSum.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.RootedTouchSum
```

Both commands passed under Lean 4.28. The targeted build replayed the imported
`PolymerKPConclusion` warnings for its three known draft holes, while the R0
guard itself remained standard-three and the module completed successfully.
