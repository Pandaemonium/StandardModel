# Independent skeptic review: rooted-touch normalization R0

Date: 2026-07-16  
Reviewer: Codex / GPT family  
Builder: Claude integration of Aristotle project
`70a0d064-e2b3-459a-9f9e-c144c8847b6a`  
Work item: `GAUGE-YM-EGF-001`  
Verdict: **APPROVE-SUBSET AND PARK**

## Exact reviewed claim

For every finite polymer system, decidable incompatibility relation, cutoff
`K`, and touched polymer `g`, the connected touching cluster sum normalized by
`1/n!` is bounded above by the touch-only sum with the same spanning-tree count
and absolute weight normalized by `1/(n-1)!`.

This is exactly the immutable R0 statement in
`AgentTasks/afpl-gauge-rooted-touch-r0-aristotle-2026-07-13.md`. The summation
domain, touch predicate, tree count, absolute weight, cutoff, and factorial
normalizations are unchanged.

## Semantic audit

The inequality is sound. On a touching connected cluster, `n >= 1`,
`(n-1)! <= n!`, and every multiplicative factor is nonnegative. On a
disconnected touching cluster, the extra right-hand term has zero spanning-tree
count. On a non-touching cluster, both guarded terms vanish. The explicit
factorial controls correctly expose equality at `n=0,1` and the first strict gap
at `n=2`.

The imported `PolymerKPConclusion.lean` still contains an open proof marker in
the old global exponential route, but R0 does not depend on it: the build-
enforced axiom print for `boundedTouchSum_le_rootedTouchSum` contains only
`[propext, Classical.choice, Quot.sound]`.

## Hostile normalization check

R0 does **not** reuse the disproved pairwise or per-fibre domination. It proves
only a true termwise comparison between two left-hand cluster sums. No forest
atom, exponential coefficient, or KP right-hand side appears in the theorem.

There is nevertheless a load-bearing naming boundary. `rootedTouchSum` contains
no chosen root and does not require the root polymer to be `g`. For a touching
cluster of positive size its normalization is algebraically the all-label root
factor `n` times the unrooted `treeTerm`. It therefore overcounts every possible
slot as a root, including slots not labeled by `g`.

This is not a flaw in R0, since an overcount is precisely why the displayed
upper bound is true. It is a serious constraint on any proposed R1. A future
inequality from this all-root sum to a `|weight g|`-rooted exponential cannot
silently identify all roots with a canonical `g` root, nor argue coefficient by
coefficient or fibre by fibre using the previously killed domination. It needs a
new global theorem and counterexample audit.

## Nearest stronger claim

The likely reader inference is:

> The rooted normalization now supplies the repaired exponential recurrence and
> hence the KP cluster bound.

That inference is false. The missing bridge is a global R1 inequality for the
all-root touching sum, or a different genuinely `g`-rooted object with a proved
comparison. R0 proves neither. It also proves no size-to-height bridge, KP
criterion, cluster summability, Yang-Mills continuum limit, or mass gap.

## Controls and verification

- Statement compared directly with the immutable task target.
- Definitions of `Cluster.Touches`, `treeTerm`, and `boundedTouchSum` inspected
  in `PolymerKPConclusion.lean`.
- The target file was replayed successfully:
  `lake env lean PhysicsSM/Draft/NullEdge/GateYM/RootedTouchSum.lean`.
- Axiom guard: standard three only.
- No trust-expanding evaluator or new assumption appears in R0.

## Disposition

Approve the exact R0 normalization bridge as a small reusable finite theorem.
Park `GAUGE-YM-EGF-001` at R0 pending the planned portfolio/director gate. Do
not fund or promote R1 automatically. Any future R1 packet must:

1. state whether the root is all-label, canonical, or explicitly `g`-labeled;
2. include a small-system coefficient audit against the known failed
   per-fibre and unrooted recurrences;
3. prove a genuinely global inequality rather than reusing a killed local
   domination;
4. preserve the boundary that R0 alone has no Yang-Mills physical consequence.
