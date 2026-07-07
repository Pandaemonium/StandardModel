# Aristotle job: KP fixed-forest fiber injection

Project: two-day carrier run, Codex lane KP / Penrose scheme.

Target file in staged Lean project:
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`

## Context

The theorem `pairSum_le_expBound` remains the main KP combinatorial crux.  The
current file already has:

- canonical root selection: `exists_canonical_root`,
- child blocks: `treeRootChildren`, `childBlockOf`, `restrictCluster`,
- child forest well-formedness: `root_child_forest_wf`,
- weight factorization: `absWeight_eq_root_mul_blocks`,
- arithmetic per-fiber bound: `fiber_value_bound`,
- abstract counting reducer:
  `fiber_card_mul_le_factorial`.

Recent Aristotle strategy (`KP_FIBER_INJECTION_STRATEGY_20260707.md`) says the
next exact blocker is the concrete fixed-forest fiber injection feeding
`fiber_card_mul_le_factorial`.

## Request

Do **not** try to prove `pairSum_le_expBound` directly.  Work on the smallest
fixed-forest counting theorem that can feed the existing
`fiber_card_mul_le_factorial`.

Preferred target: a standalone theorem, placed near
`fiber_card_mul_le_factorial`, that turns a root-plus-block partition of
`Fin n` into the required injection, or directly into the cardinality bound.

Here is the intended mathematical shape.  Feel free to correct the statement if
these hypotheses are not strong enough.

```lean
open Classical in
lemma fixed_forest_fiber_card_mul_le_factorial
    {n k : Nat} (m : Fin k -> Nat)
    (Fib : Type*) [Fintype Fib]
    (root : Fib -> Fin n)
    (block : Fib -> Fin k -> Finset (Fin n))
    (hcard : forall x j, (block x j).card = m j)
    (hroot_not_block : forall x j, root x ∉ block x j)
    (hdisj : forall x i j, i ≠ j -> Disjoint (block x i) (block x j))
    (hcover : forall x,
      ({root x} : Finset (Fin n)) ∪
          (Finset.univ.biUnion (fun j : Fin k => block x j)) = Finset.univ)
    (hlayout_inj : Function.Injective fun x =>
      (root x, fun j : Fin k => block x j)) :
    Fintype.card Fib * (Nat.factorial k * ∏ j, Nat.factorial (m j))
      <= Nat.factorial n := by
  ...
```

If proving the direct cardinality theorem is too hard, prove an intermediate
lemma constructing the injection

```lean
Fib × Equiv.Perm (Fin k) × (∀ j, Equiv.Perm (Fin (m j)))
  -> Equiv.Perm (Fin n)
```

under corrected partition hypotheses, and then feed it to
`fiber_card_mul_le_factorial`.

## Success criteria

Return one of:

1. A patch to `PolymerKPConclusion.lean` with the standalone theorem proved.
2. A smaller proved theorem plus an exact explanation of how it feeds
   `fiber_card_mul_le_factorial`.
3. If the proposed statement is false or too weak, a counterexample or missing
   hypothesis, plus the corrected Lean statement and proof plan.

Do not weaken `pairSum_le_expBound`.  Do not use or revive the known false
over-rooted KP statements (`kp_convergence_bound_false` and siblings).  This is
pure finite combinatorics over `Fin n` and finite block partitions.
