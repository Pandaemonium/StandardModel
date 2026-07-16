# Red-team report: GAUGE-YM-KP-001

- Claim/artifact: `PolymerKPConclusion.pairSum_le_expBound` through the proposed
  finite fibre-count injection
- Builder: Claude / Aristotle project `3cec307a`
- Skeptic: Codex
- Date: 2026-07-12
- Promotion requested: kernel-checked Yang-Mills polymer combinatorial crux

## Precise restatement

The work item claimed that the displayed finite polymer pair sum could be
bounded by its exponential majorant by classifying rooted trees into fibres and
injecting

`fibre x Perm(k) x product_j Perm(m_j)`

into `Perm(n)`.  The required cardinality consequence was

`#fibre * (k! * product_j m_j!) <= n!`.

The submitted theorem statement itself was not weakened.  Aristotle returned a
proof-hole-free helper, `rhs_forest_expand2`, but left
`pairSum_le_expBound` open.

## Nearest-work audit

- Closest stronger claim a reader may infer: the global truncated
  labelled-rooted-tree exponential inequality has been proved.
- Missing theorem, experiment, or assumption: a genuinely global EGF,
  tree-function, or induction argument controlling compensation between
  different child-size classes.
- Titles/abstracts/captions checked: no manuscript promotion was made from this
  job.  The Aristotle summary explicitly reports failure to close the target.
- Successor item opened or explicit out-of-scope disposition:
  `GAUGE-YM-EGF-001` replaces the killed fibrewise route.

## Findings ordered by severity

1. **Fatal for the registered mechanism.**  The preregistered fibre bound is
   false.  For one self-incompatible polymer, a size-seven cluster, two
   size-three child components, and fixed induced child trees, the fibre has
   size 90.  Therefore
   `90 * (2! * (3!)^2) = 6480 > 5040 = 7!`.
2. **The target theorem remains open.**  The downloaded file contains the same
   proof hole in `pairSum_le_expBound`, plus the two already documented false
   successor statements.  An idle Aristotle status was not a proof landing.
3. **Useful partial result.**  `rhs_forest_expand2` correctly expands the
   right-hand finite exponential into ordered child-cluster tuples.  It is a
   valid starting point for a global proof but does not imply the desired
   inequality.
4. **No unrelated drift.**  `PolymerKPCriterion.lean` and
   `TreeGraphInequality.lean` are SHA-256 identical to the submitted package.
   The target statement is unchanged; the only code addition is the expansion
   lemma, plus a diagnostic comment and an extra broad `import Mathlib`.

## Counterexamples and independent commands

The arithmetic obstruction is immediate:

```text
10 unordered 3|3 partitions * 3 root attachments per block * 3
root attachments in the other block = 90 trees
90 * 2 * 6 * 6 = 6480 > 5040
```

Independent replay command:

```powershell
lake env lean AgentTasks/aristotle-downloads/3cec307a-codex-independent/ym-crux-20260712_aristotle/PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

This passed under the pinned repository environment and reported proof holes at
the target and the two pre-existing documented-false declarations.

## Source and convention audit

This audit concerns finite combinatorics only.  No external physics source or
continuum convention is used.  The downloaded result is preserved under
`AgentTasks/aristotle-downloads/3cec307a-codex-independent/`; the companion
source hashes were compared against
`AgentTasks/aristotle-standalone/ym-crux-20260712/`.

## Controls and nonvacuity

The counterexample is nonvacuous: a one-polymer system with self-incompatibility
has complete incompatibility graphs and actual spanning trees.  It attacks the
specific integer hypothesis consumed by `fiber_value_bound`; it does not claim
that the global exponential inequality is false.

## Overclaim checklist

- [x] vacuity
- [x] hollow telescoping
- [x] docstring/proof mismatch
- [x] false shape
- [x] convention drift
- [x] source laundering
- [x] finite-to-continuum slippage
- [x] fitted-to-predicted relabeling
- [x] common-form-to-common-origin inflation

## Verdict

**Fatal for `GAUGE-YM-KP-001` as specified.**  The proposed injection meets its
registered kill condition.  The global theorem remains a legitimate separate
research target.

## Minimum repair

Do not repair the fibrewise proof.  Start from `rhs_forest_expand2` and prove a
global coefficient or recurrence inequality in which surplus from one child
size class can be compensated by deficits in others.  Pre-register a finite
coefficient control before another Aristotle submission.
