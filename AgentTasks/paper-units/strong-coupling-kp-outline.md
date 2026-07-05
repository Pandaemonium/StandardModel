# Strong-Coupling KP Lane Outline

Conservative paper-unit inventory for the finite strong-coupling/Kotecky-Preiss
lane of the four-day YM run. This is a theorem map, not a claim that the KP
theorem, volume-uniform strong-coupling bound, or exponential clustering theorem
is closed.

## Scope

Target lane: Q6/Q7/Q8 of
`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`.

Current formalization layer:

- Q6: abstract finite polymer/KP conclusion infrastructure in
  `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`,
  `TreeGraphInequality.lean`, and `PolymerKPConclusion.lean`.
- Q7: finite plaquette-polymer map and explicit rooted KP-sum adapters in
  `StrongCouplingPolymerMap.lean`.
- Q8: conditional exponential-clustering bridge in
  `ExponentialClustering.lean`.

Claim boundary:

- Draft GateYM only; no trusted promotion in this run.
- No volume-uniform KP theorem is proved.
- No general finite-group character-coefficient smallness theorem is proved.
- No cluster expansion theorem is closed while Q6 has remaining draft handoffs.
- No concrete observable expansion from Wilson loops to Q8 cluster tails is
  claimed.

## Kernel-Checked Core

Q6 abstract polymer side:

- `PolymerSystem` and `KPCondition` freeze the finite abstract polymer model
  and rooted KP inequality.
- `ClusterCoeffData` packages a finite cluster-coefficient interface.
- `TreeGraphInequality.lean` proves the finite `SimpleGraph` Penrose
  tree-graph inequality and is used to prove
  `PolymerKPConclusion.treeGraphBound_ursell`.
- The older bare-KP convergence target is formally refuted as
  `kp_convergence_bound_false`; the corrected route requires
  self-incompatibility.
- The current partial-sum route reduces to the finite rooted species/counting
  crux `touchOnlySum_le_expBound`.

Q7 plaquette-polymer map:

- `PlaquettePolymer` represents nonempty connected finite plaquette supports
  with labels only on the support.
- `plaquettePolymerSystem` maps Q7 data into the abstract `PolymerSystem`.
- `plaquetteKPSum` names the explicit rooted finite plaquette KP sum.
- `PlaquetteKPBound` names the finite explicit Q7 KP-bound target.
- `kpCondition_of_plaquetteKPBound` and
  `kpCondition_and_selfIncompatible_of_plaquetteKPBound` route an explicit Q7
  bound into the abstract KP condition and self-incompatibility interface.
- `plaquetteKP_convergence_bound_of_plaquetteKPBound` routes an explicit Q7
  bound into the corrected Q6 convergence theorem, carrying the same remaining
  Q6 draft dependency.

Q7 support-localization and support-counting landing pads:

- `closedTouchNeighborhood` localizes incompatible/touching supports.
- `SupportsOverlapOrTouch.iff_exists_right_mem_closedTouchNeighborhood`,
  `SupportsOverlapOrTouch.iff_inter_closedTouchNeighborhood_nonempty`, and
  `SupportsOverlapOrTouch.iff_card_inter_closedTouchNeighborhood_pos` give the
  exact finite counting filters.
- `sum_supportsOverlapOrTouch_le_sum_closedTouchNeighborhood_anchors` and
  `plaquetteKPSum_le_sum_closedTouchNeighborhood_anchors` reduce rooted
  overcounting to anchored sums.
- `plaquetteKPSum_le_card_closedTouchNeighborhood_mul_anchorBound` and
  `plaquetteKPSum_le_card_mul_singletonBound_mul_anchorBound` give the
  cardinality/degree form for uniform anchored bounds.
- `anchoredPlaquettePolymerAreaSum` and `anchoredPlaquettePolymerSum` split
  anchored contributions by support cardinality.
- `plaquetteKPSum_nonneg`, `anchoredPlaquettePolymerAreaSum_nonneg`, and
  `anchoredPlaquettePolymerSum_nonneg` record the nonnegativity hypotheses
  needed by later support-counting comparisons.
- `anchoredPlaquettePolymerAreaSum_le_anchoredPlaquettePolymerSum` bounds each
  fixed-area slice by the full anchored sum under nonnegative coefficients.
- `anchoredPlaquettePolymerAreaSum_zero`,
  `anchoredPlaquettePolymerAreaSum_eq_zero_of_card_lt`, and
  `anchoredPlaquettePolymerSum_eq_sum_positiveAreaSlices` clean up the finite
  support-cardinality range to positive areas `1..Fintype.card P`.
- `anchoredPlaquettePolymerSum_eq_sum_areaSlices` and
  `anchoredPlaquettePolymerSum_le_sum_areaBounds` reduce anchored estimates to
  per-area slice bounds.
- `anchoredPlaquettePolymerSum_le_sum_positiveAreaBounds` is the same
  reduction with hypotheses only over the positive-area range.
- `plaquetteKPSum_le_sum_closedTouchNeighborhood_areaBounds` and
  `plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_areaBounds` lift the
  area slices back to the rooted KP overcount.
- `plaquetteKPSum_le_sum_closedTouchNeighborhood_positiveAreaBounds` and
  `plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_positiveAreaBounds`
  are the positive-area rooted-overcount variants.
- `plaquetteKPBound_of_closedTouchNeighborhood_areaBounds`,
  `plaquetteKPBound_of_realClosedNeighborhood_areaBounds`, and
  `plaquetteKPBound_of_singletonBound_areaBounds` are the current support-count
  landing pads for a later per-area estimate.
- `plaquetteKPBound_of_closedTouchNeighborhood_positiveAreaBounds`,
  `plaquetteKPBound_of_realClosedNeighborhood_positiveAreaBounds`, and
  `plaquetteKPBound_of_singletonBound_positiveAreaBounds` are the corresponding
  landing pads with no `k = 0` hypothesis.

Concrete sanity fixture:

- The one-plaquette Z2 model proves `onePlaquetteZ2_plaquetteKPSum`,
  `onePlaquetteZ2_plaquetteKPBound`, `onePlaquetteZ2_kpCondition`, and
  `onePlaquetteZ2_kpCondition_and_selfIncompatible` under the explicit scalar
  condition `|tanh beta| * exp alpha <= alpha`.
- The same fixture now computes the area-one anchored slice as
  `onePlaquetteZ2_anchor_area_sum` and routes the scalar smallness hypothesis
  through the area-slice adapter as `onePlaquetteZ2_plaquetteKPBound_areaSlice`.
- Beta-zero and `|tanh beta| <= alpha * exp (-alpha)` wrappers are proved.
- This fixture is finite and non-volume-uniform; it is a sanity check for the
  adapters, not a lattice theorem.

Q8 conditional clustering side:

- `LocalObservableData` and `LocalObservableSupportData` define abstract
  connected-correlator interfaces.
- `tailContribution` and `supportTail` name the Q6-style tail input.
- `hasExponentialClustering_of_tailContribution_bound` and
  `hasExponentialClusteringSupport_of_supportTail_bound` are conditional
  bridges from explicit tail bounds to exponential clustering.
- `supportTail_le_card_mul_bound`,
  `supportTail_le_card_mul_energyBound_mul_exp`, and
  `hasExponentialClusteringSupport_of_uniform_anchor_tail_bound` package
  finite-support cardinality prefactors.
- Amplitude/rate weakening wrappers are proved for constant bookkeeping.

## Active Aristotle Jobs

Running or pending at the time this outline was added:

- `b2a176b7`: Q6 focused proof job for `touchOnlySum_le_expBound`.
- `141c0c07`: Q7 support-counting strategy job.

Harvest rule: integrate completed jobs only after checking the returned Lean
against the pinned local toolchain, preserving the current Q6/Q7 claim
boundaries unless the kernel-checked statements really close them.

## Remaining Mathematical Cruxes

Q6:

- Prove or further reduce `touchOnlySum_le_expBound`.
- Close the corrected self-incompatible convergence theorem.
- Close the metric-tail theorem required by Q8.

Q7:

- Prove a genuine connected-support counting theorem for a concrete lattice
  geometry.
- Prove coefficient smallness/area-slice bounds for the desired finite group
  character expansion.
- Combine geometry and coefficient estimates into a volume-uniform
  `PlaquetteKPBound`.

Q8:

- Connect concrete Wilson/local-loop observables to the Q8
  `LocalObservableSupportData` interface.
- Feed the eventual Q6 metric-tail theorem plus concrete Q7 observable bridge
  into a real exponential-clustering statement.

## Provenance Notes

- KP source status is tracked in
  `AgentTasks/fourday-ym-run-2026-07-05/LIT_LOG.md`.
- Primary Kotecky-Preiss full proof text remains partially blocked in this
  environment; Fernandez-Procacci full text supports the modern tree-graph/KP
  proof-plan language used in Q6 notes.
- CAS/oracle role is limited to small finite fixtures and sanity checks; it is
  not used as proof of the KP theorem.

## Current Paper-Unit Status

This is not yet a paper unit claiming a strong-coupling theorem. It is a
reviewable theorem inventory for the KP lane. The nearest upgrade path is:

1. Harvest `touchOnlySum_le_expBound` or a strictly smaller verified Q6 lemma
   DAG.
2. Harvest or replace the Q7 support-counting strategy with kernel-checked
   finite counting lemmas.
3. Add a concrete geometry/coefficient theorem feeding
   `plaquetteKPBound_of_singletonBound_positiveAreaBounds` or its real-growth
   version.
4. Only then attempt a Q8 concrete clustering statement.
