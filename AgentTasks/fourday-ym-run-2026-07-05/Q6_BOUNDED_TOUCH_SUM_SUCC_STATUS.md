# Q6 `boundedTouchSum_succ_le` harvest status

Harvest: Aristotle `961529bb`, task `ad51386b`.

## Outcome

This is a partial integration, not a full Q6 closure.  The theorem
`boundedTouchSum_succ_le` now has a Lean proof term and no longer carries the
Q6 proof placeholder directly.  It is reduced to exactly one new finite,
purely combinatorial statement:

```text
boundedTouchSum_succ_le_finitePartial :
  boundedTouchSum (K+1) g
    <= |weight g| * sum_{k in range (K+3)}
         (sum_{h in nbhd g} boundedTouchSum K h) ^ k / k!
```

The reduction from this finite partial-sum bound to `boundedTouchSum_succ_le`
is kernel-checked.  It uses `boundedTouchSum_nonneg` to prove the neighbor sum
is nonnegative and `Real.sum_le_exp_of_nonneg` to bound the finite partial
exponential series by `Real.exp`.

The two further Q6 handoffs `kp_convergence_bound_of_selfIncompatible` and
`kp_tail_bound` are untouched.

## Smallest remaining statement

`boundedTouchSum_succ_le_finitePartial` is now the smallest known Q6
combinatorial crux.  Intended proof:

1. Rewrite `boundedTouchSum (K+1) g` as a finite sum over labeled decorated
   trees of size at most `K+2` touching `g`.
2. Root each tree at a slot carrying `g`.
3. Delete the root and partition the remaining slots into child subtrees rooted
   at polymers incompatible with `g`.
4. Reconcile the ordered `1/n!` normalization with the finite partial
   exponential-series normalization.

Blocker class: finite labeled rooted-tree / exponential-formula infrastructure.
This is a finite species-style counting theorem, not a KP statement ambiguity
or a missing analytic hypothesis.

## Verification

```text
lake env lean PhysicsSM\Draft\NullEdge\GateYM\PolymerKPConclusion.lean
lake env lean PhysicsSM\Draft\NullEdge\GateYM.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
lake build PhysicsSM.Draft.NullEdge.GateYM
```

The expected Q6 draft proof-placeholder warnings are now:

- `boundedTouchSum_succ_le_finitePartial`;
- `kp_convergence_bound_of_selfIncompatible`;
- `kp_tail_bound`.
