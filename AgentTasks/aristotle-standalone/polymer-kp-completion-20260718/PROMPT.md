# Task: close the polymer Kotecky-Preiss DAG (Gate YM4 completion)

Project: Lean 4 (v4.28.0) + Mathlib. Yang-Mills gate, polymer cluster
expansion lane. Self-contained three-file package:
`GateYM/PolymerKPCriterion.lean` and `GateYM/TreeGraphInequality.lean`
(PROVEN infrastructure) and the target file.

## Target

`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` - exactly three
live holes:

1. `pairSum_le_expBound` (the crux). The module docstring records the
   landed lemma DAG reducing the rooted KP partial-sum theorem to this
   finite combinatorial inequality, and names the remaining gap precisely:
   the rooted-tree deletion step, block reindexing, weight factorization,
   and the geometric fiber-count bound. The scaffolding is all present and
   PROVEN: `exists_canonical_root`, `tree_root_child_mem_nbhd`,
   `treeRootChildren` (+ arity bound), `treeRootDeletedGraph`,
   `treeRootChildComponent`, `treeRootChildBlock` (+ card bound +
   disjointness), `root_child_forest_wf`, `rhs_forest_expand`, and
   `factorial_mul_prod_factorial_le`. IMPORTANT pre-registered warning in
   the file: `fiber_card_mul_le_factorial` and `perPair_absWeight_bound`
   are INSUFFICIENT on their own (a counterexample in the file shows this)
   - the fiber classification must use the block structure.
2. `kp_convergence_bound_of_selfIncompatible` - the CORRECTED C2 bound
   (the bare version is refuted by the in-file counterexample
   `kp_convergence_bound_false` / `SelfIncompatCex`; the corrected
   statement already carries the self-incompatibility hypothesis).
3. `kp_tail_bound` - the metric tail bound (the bare version is refuted by
   `TailCex.tail_bound_false`; the corrected statement carries the
   explicit energy/distance coercivity hypothesis).

Do NOT touch the historical FALSE-as-stated statements or their
counterexamples - they are retained refutation records. Close only the
three live holes above.

## Honesty protocol (pre-registered)

- If one of the corrected statements is STILL false, refute it with an
  explicit counterexample (first-class outcome) and propose the minimally
  strengthened hypothesis, proving that version.
- If `pairSum_le_expBound` resists, prove the strongest partial rung of
  the remaining chain (`sum_le_boundedTouchSum` -> depth induction ->
  analytic steps are already proved; the gap is combinatorial) and return
  a precise missing-lemma report.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not modify the two infrastructure files.
- Verify with
  `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

`pairSum_le_expBound` closed (primary; unlocks `kp_tree_sum_bound`,
`kp_partial_sum_bound`, `kp_cluster_summable` per the docstring DAG), plus
the two corrected handoffs or their honest refutation-and-repair. Completion
report: solved targets, any hypothesis changes, remaining holes, axioms.
