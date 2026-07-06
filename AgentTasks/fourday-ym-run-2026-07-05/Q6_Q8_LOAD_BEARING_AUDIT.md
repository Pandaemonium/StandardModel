# Q6/KP → Q7/Q8 clustering-bridge load-bearing audit

Audit date: 2026-07-06. Scope: the whole strong-coupling / observable-clustering
load-bearing path, not the running Q6 child-component separation proof job.
No source statement was weakened; this is an audit/report only.

Files inspected:

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TreeGraphInequality.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/ObservableSupportBridge.lean`

(A repository build was intentionally **not** run for this pass, per request.
Findings below are from reading the source and the two run progress notes.)

## Verdict

The chain is **structurally sound and honestly conditional**, but it rests on
**three distinct `s o r r y`s in `PolymerKPConclusion.lean`, not one**. The
"single remaining crux" framing in the file/notes is accurate only for the C1
absolute-summability lane (`kp_cluster_summable`). The C2 convergence lane
(`kp_convergence_bound_of_selfIncompatible`) and the metric-tail lane
(`kp_tail_bound`) are separate open estimates and are the theorems that Q7 and
Q8 actually consume. Q7 and Q8 do not smuggle decay: every clustering/decay
statement takes the tail bound as an explicit hypothesis or bottoms out in a
clearly-labeled parked `s o r r y`.

The three open goals are:

1. `pairSum_le_expBound` (line ~924) — the labeled rooted-tree exponential
   combinatorial crux. Sole support of `kp_tree_sum_bound → kp_partial_sum_bound
   → kp_cluster_summable` (C1).
2. `kp_convergence_bound_of_selfIncompatible` (line ~1248) — the corrected C2
   Kotecky–Preiss convergence bound. Sole support of the Q7 connector
   `plaquetteKP_convergence_bound_of_plaquetteKPBound` and of `kp_tail_bound`.
3. `kp_tail_bound` (line ~1291) — the metric/coercivity tail estimate. Sole
   supplier of the `hTail` input consumed by the Q8 bridge.

## Sound pieces

- **Penrose tree-graph inequality** (`TreeGraphInequality.lean`,
  `treeGraphBound_ursell`): fully proved via the Mayer deletion recursion; no
  `s o r r y`. This is the genuine combinatorial backbone and is solid.
- **C1 reduction ladder** (`PolymerKPConclusion.lean`): every step from
  `pairSum_le_expBound` up to `kp_cluster_summable` is proved and correctly
  chained — `touchOnlySum_le_expBound`, `boundedTouchSum_succ_le_finitePartial`,
  `boundedTouchSum_succ_le` (uses `Real.sum_le_exp_of_nonneg` to inject the
  analytic exponential cleanly), `boundedTouchSum_le_kpPsi`, `kp_tree_sum_bound`,
  `kp_partial_sum_bound`. The reduction to the single combinatorial crux is
  semantically correct.
- **The C2 counterexample** `kp_convergence_bound_false` with `cexSystem` /
  `cexWitness`: a proved disproof of the *old* self-incompatibility-free C2
  statement. This is exactly the right guardrail and justifies the added
  `hself` hypothesis; it is not vacuous.
- **Root-deletion scaffolding** (`treeRootChildren`, `treeRootDeletedGraph`,
  `treeRootChildComponent`, `treeRootChildBlock` and their support lemmas):
  all proved, no `s o r r y`. Notably: arity bound `treeRootChildren_card_add_one_le`
  (`≤ n-1`), block-size bound `treeRootChildBlock_card_add_one_le`, positive
  block cardinality, and `disjoint_treeRootChildBlock_of_component_ne` (distinct
  components ⇒ disjoint blocks). These are correct and reusable.
- **ExponentialClustering (Q8)**: `HasExponentialClustering` is a plain decay
  predicate; the bridge `hasExponentialClustering_of_tailContribution_bound`
  takes the Q6 tail estimate `hTail` and the locality comparison `hBridge` as
  **explicit hypotheses**. The large `supportTail_*` algebra layer is proved and
  is pure finite-support bookkeeping. Nothing here proves decay.
- **ObservableSupportBridge (Q8)**: purely a support-identification layer
  (`support_eq`) plus pass-through wrappers; every clustering conclusion still
  requires the `hBridge`/`hTail` hypotheses. No concrete Wilson expansion,
  volume-uniform KP, or decay is claimed.
- **StrongCouplingPolymerMap (Q7)**: the `PlaquetteKPBound → KPCondition`
  plumbing and the one-plaquette Z2 fixture theorems are proved; the only
  place it becomes conditional is the convergence connector, which is honestly
  labeled as "only as complete as `kp_convergence_bound_of_selfIncompatible`."

## Load-bearing risks

1. **Three s o r r i e s, not one — and C2 is not reducible to the C1 crux as
   currently wired.** `kp_partial_sum_bound`/`kp_cluster_summable` bound
   `Σ |coeff|·absWeight` by `|weight g0|·exp(energy g0)`. But
   `kp_convergence_bound_of_selfIncompatible` bounds a *different* sum,
   `tsum(|coeff|·absWeight·exp(energyOf X)) ≤ energy g0` — an extra per-cluster
   `exp(energyOf X)` factor and a different RHS. So closing `pairSum_le_expBound`
   does **not** discharge C2. C2 needs its own reduction (its proof-handoff
   comment says to use `hself`, `hKP`, `D.treeGraphBound` directly). This is the
   biggest structural risk: the "one crux left" narrative undercounts the work
   that Q7/Q8 depend on.

2. **Q7 and Q8 depend on C2/tail, not on C1.** The Q7 connector
   `plaquetteKP_convergence_bound_of_plaquetteKPBound` calls
   `kp_convergence_bound_of_selfIncompatible` (s o r r y #2). The Q8 tail input is
   `kp_tail_bound` (s o r r y #3), which itself depends on C2. So the observable
   clustering path is gated by s o r r i e s #2 and #3; finishing the running
   combinatorial job (which serves #1) leaves the Q7/Q8 path still open.

3. **Documented unsound proof route inside `pairSum_le_expBound`.** The file's
   own CAUTION note (verified numerically + by hand) records that the naive
   "root-overcount by #{g-slots}" reduction is *false*: it converts the
   unrooted Cayley `m^(m-2)` count into rooted `m^(m-1)` and overshoots the RHS
   at order `x^3` for a single self-incompatible small-weight polymer. Any
   future attempt must root at a single canonical `g`-slot (multiplicity one).
   This is a real trap, correctly flagged; risk is that a future agent ignores
   it.

4. **Root-deletion scaffold is viable but incomplete.** The helpers give
   canonical root, children (arity ≤ n−1), deleted graph, child components,
   finite blocks, block-size bound, and disjointness *given distinct
   components*. Still missing on the path to `pairSum_le_expBound`:
   (a) distinct root children ⇒ distinct components in a tree (the running job
   `fc5aaf10`/`cc5e78d7`); (b) the blocks *cover* all non-root slots (partition,
   not just pairwise-disjoint); (c) reindex each block as a smaller ordered
   cluster; (d) block-level `absWeight` factorization; (e) the geometric
   fiber/multinomial count that consumes `factorial_mul_prod_factorial_le` and
   `rhs_forest_expand`. The scaffold points at a viable proof but the counting
   core is unbuilt.

## Are Q7/Q8 correctly conditional? (audit Q3)

Yes. No theorem in `ExponentialClustering.lean`, `ObservableSupportBridge.lean`,
or `StrongCouplingPolymerMap.lean` proves decay as a conclusion. Decay always
enters as an explicit hypothesis (`hTail`, `hBridge`, uniform-tail/uniform-energy
bounds) or the statement bottoms out in an explicitly parked Q6 `s o r r y`. The Q8
`tailContribution` is *defined* as the KP tail tsum and its exponential decay is
supplied only via `kp_tail_bound` (open). This matches the stop-condition
"a proposed Q8 bridge smuggles decay in as a conclusion" — and it is not
violated.

## Smallest next proof target

The running job targets the tree-specific distinct-child ⇒ distinct-component
step (feeding disjointness). The smallest genuinely-new theorem to line up next,
independent of both the running job and of the C1 crux, is:

**C2 reduction to the already-proved C1 ladder / tree-sum bound**, i.e. prove
`kp_convergence_bound_of_selfIncompatible` by routing through the existing
`kp_tree_sum_bound` (or `kp_cluster_summable`) plus the self-incompatible
single-polymer control. This is the highest-leverage next step because it
unblocks *both* the Q7 connector and `kp_tail_bound` (hence Q8), and it does not
wait on the combinatorial crux. It is a KP-bookkeeping estimate, not new
combinatorics.

If instead the goal is to keep pushing the combinatorial lane, the smallest
next target after the running job returns is the **block-cover/partition lemma**:
the `treeRootChildBlock`s over `treeRootChildren T r` are pairwise disjoint
*and* their union is all of `{x : Fin n // x ≠ r}` (every non-root slot is
reachable from some root child in the deleted tree). Disjointness is already
available via `disjoint_treeRootChildBlock_of_component_ne` once distinct
children give distinct components; the missing half is coverage.

## Suggested theorem statements

Sketches only (`by s o r r y`); names avoid Mathlib collisions.

```lean
-- (A) Highest-leverage: reduce C2 to the proved C1 tree-sum ladder.
-- Goal is exactly the body of kp_convergence_bound_of_selfIncompatible;
-- factor its KP-bookkeeping content into a reusable lemma.
theorem tsum_coeff_absWeight_exp_energy_le_energy
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hself : forall g, S.incompatible g g)
    (D : ClusterCoeffData S hdec)
    (hKP : KPCondition S hdec) (g0 : Gamma) :
    tsum (fun X : {X : Cluster S // X.Connected S hdec /\ X.Touches S g0} =>
        |D.coeff X.1| * X.1.absWeight S * Real.exp (X.1.energyOf S))
      <= S.energy g0 := by s o r r y

-- (B) Combinatorial lane: block cover/partition of the deleted tree.
-- Pairwise-disjointness is disjoint_treeRootChildBlock_of_component_ne (given
-- distinct components); this adds the coverage half.
theorem treeRootChildBlocks_cover {n : Nat} (T : SimpleGraph (Fin n))
    (hT : T.IsTree) (r : Fin n)
    (v : {x : Fin n // x ≠ r}) :
    ∃ j (hj : j ∈ treeRootChildren T r),
      v ∈ treeRootChildBlock T r j hj := by s o r r y

-- (C) Feeds (B): in a tree, distinct root children generate distinct
-- deleted-graph components (this is what the running job targets).
theorem treeRootChildComponent_ne_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (hT : T.IsTree) (r j k : Fin n)
    (hj : j ∈ treeRootChildren T r) (hk : k ∈ treeRootChildren T r)
    (hjk : j ≠ k) :
    treeRootChildComponent T r j hj ≠ treeRootChildComponent T r k hk := by
  s o r r y
```

## Warnings about overclaiming

- Do **not** describe `pairSum_le_expBound` as "the single remaining blocker"
  of the Q6→Q8 chain. It is the single remaining blocker of C1 (absolute
  summability) only. Q7 convergence and Q8 clustering are gated by the separate
  open theorems `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound`.
- Do **not** claim Q7 gives a volume-uniform KP convergence bound: the connector
  is only as strong as the parked C2 `s o r r y`.
- Do **not** claim Q8 proves exponential clustering: it converts an assumed Q6
  tail bound into observable decay; the tail bound (`kp_tail_bound`) is open.
- Do **not** claim any physical mass gap, infinite-volume/continuum result, or
  Wilson-slab transfer construction — none is present, and the chain audited
  here is finite polymer/graph combinatorics plus conditional decay plumbing.
- Keep the documented CAUTION: the rooted-overcount reduction of the crux is
  numerically false; do not silently adopt it.
