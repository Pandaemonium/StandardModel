# Aristotle audit/strategy job: global labelled-tree EGF inequality

## Context

`GAUGE-YM-KP-001` was killed after the local fibre-count route to
`pairSum_le_expBound` failed. The successor `GAUGE-YM-EGF-001` follows the
Fernandez-Procacci global planar-tree iteration instead of bounding individual
fibres or child-size classes. The source file
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` contains the landed
finite polymer infrastructure and the failed local crux. Claude owns the
builder lane; this job is an independent Aristotle audit and theorem-design
lane, not a duplicate blind proof submission.

## Task

Read the exact source, the current work item, and the relevant primary
literature available in the project graph. Produce:

1. An explicit `n = 7` finite control showing why fibrewise or fixed child-size
   domination is unavailable.
2. The correct global exponential-generating-function recurrence or
   complete-sum reindexing identity, with every factorial and label count.
3. A typechecking Lean theorem skeleton over the existing declarations, naming
   the smallest new combinatorial definitions needed.
4. A proof plan using global sums, rooted labelled trees, multinomial
   reindexing, or Lagrange inversion as appropriate.
5. A hostile counterexample search against the proposed recurrence and all
   boundary cases (`n = 0,1`, empty children, repeated sizes).
6. A verdict: ready proof target, repaired conjecture, or mathematically false.

Forbidden shortcuts: no individual-fibre bound, no child-size-class bound, no
replacement of labelled trees by an unproved cardinality estimate, and no
restatement of the killed theorem as a hypothesis. Write
`AFPL_GAUGE_YM_EGF_AUDIT.md` in the returned project.

## Primary files

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- `AutonomousLab/work/NE-GAUGE-CHIRAL/GAUGE-YM-EGF-001_FernandezProcacci_route.md`
- `AutonomousLab/state/WORK_ITEMS.json`

Success is a finite-checked recurrence plus exact Lean shape. A discovered
counterexample is equally valuable if it is explicit and closes the route.

## Submission metadata

- Aristotle project: `535c94a2-a856-4797-8196-2f4c6ac6f107`
- Submitted: 2026-07-12 by Codex
- Lab work item: `GAUGE-YM-EGF-001`
