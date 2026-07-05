# Aristotle proof-design audit: Q8 concrete observable bridge

You are acting as a Lean 4 proof-design and semantic-audit agent for a draft
mathematical physics formalization. This is primarily a strategy/audit job, not
a request to force a proof through by changing meanings.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Repository context

Project: `PhysicsSM`, draft GateYM Yang-Mills / mass-gap ladder.

The run is currently working Q6/Q7/Q8:

- Q6: abstract finite Kotecky-Preiss / cluster-coefficient infrastructure.
- Q7: concrete finite plaquette-polymer map and explicit rooted KP-sum
  adapters.
- Q8: conditional exponential-clustering bridge from explicit cluster-tail
  estimates.

This job asks for the next minimal Lean statement layer connecting concrete
Q7-style plaquette-polymer tails or Wilson/local-loop observables to the Q8
`LocalObservableSupportData` interface. It must not claim Q6 tail closure,
volume-uniform KP, a cluster expansion, or concrete exponential clustering.

## Files to inspect

Please inspect at least:

```text
PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean
PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean
PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean
PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean
PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean
PhysicsSM/Draft/NullEdge/GateYM.lean
AgentTasks/paper-units/strong-coupling-kp-outline.md
AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md
AgentTasks/fourday-ym-run-2026-07-05/RUN_PLAN.md
```

Semantic context pack included in the submission:

```text
AgentTasks/context-packs/ym-q8-concrete-observable-bridge-20260705-20260705-033031.md
```

Use that pack only as context-selection evidence. The Lean files and run notes
are authoritative.

## Current Lean surface

`ExponentialClustering.lean` already contains:

- `LocalObservableData`, `tailContribution`, and `HasExponentialClustering`.
- `LocalObservableSupportData`, `supportTail`, and
  `HasExponentialClusteringSupport`.
- singleton conversion `LocalObservableData.toSupportData`,
  `supportTail_toSupportData`, and
  `hasExponentialClusteringSupport_toSupportData_iff`.
- finite-support bookkeeping:
  `supportTail_mono`, `supportTail_union_le`, `supportTail_biUnion_le`,
  `supportTail_biUnion_le_card_mul_bound`,
  `supportTail_le_card_mul_bound`,
  `supportTail_le_energy_sum_mul_exp`,
  `supportTail_le_card_mul_energyBound_mul_exp`.
- clustering bridges:
  `hasExponentialClustering_of_tailContribution_bound`,
  `hasExponentialClusteringSupport_of_supportTail_bound`,
  `hasExponentialClusteringSupport_of_uniform_anchor_tail_bound`, and
  `hasExponentialClusteringSupport_of_uniform_energy_bound`.

`StrongCouplingPolymerMap.lean` already contains:

- `PlaquettePolymer`, with labels only on the finite support.
- `plaquettePolymerSystem`, `plaquetteKPSum`, and `PlaquetteKPBound`.
- adapters from `PlaquetteKPBound` to the Q6 abstract `KPCondition`.
- support-localization via `closedTouchNeighborhood` and overlap/touch filters.
- anchored and area-sliced estimates:
  `anchoredPlaquettePolymerAreaSum`, `anchoredPlaquettePolymerSum`,
  `anchoredPlaquettePolymerSum_eq_sum_areaSlices`,
  `anchoredPlaquettePolymerSum_le_sum_areaBounds`,
  `plaquetteKPSum_le_sum_closedTouchNeighborhood_areaBounds`,
  `plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_areaBounds`,
  `plaquetteKPBound_of_closedTouchNeighborhood_areaBounds`,
  `plaquetteKPBound_of_realClosedNeighborhood_areaBounds`, and
  `plaquetteKPBound_of_singletonBound_areaBounds`.
- a one-plaquette Z2 sanity fixture including
  `onePlaquetteZ2_plaquetteKPBound_areaSlice`.

## Question

Design the smallest honest Q8 bridge layer that should be added next.

The desired bridge is not "prove exponential clustering now". Instead, identify
how concrete local observables should expose finite plaquette support data so
that an eventual Q6/Q7 tail theorem can feed the existing Q8 API.

Please answer these Lean-design questions:

1. What should the next observable type/class/interface be?
   Examples to consider: a structure bundling an observable with a finite
   plaquette support, a Wilson-loop/local-loop support interface, or a
   plaquette-polymer expansion interface with coefficients and support map.
2. Should the bridge live in `ExponentialClustering.lean`, a new file such as
   `ObservableSupportBridge.lean`, or a Q7/Q8 connector file?
3. What exact Lean declarations should be added first? Return Lean-syntax
   signatures and a dependency DAG.
4. Which declarations are provable immediately from existing finite-support
   bookkeeping, and which require a real expansion/tail hypothesis?
5. How should the statement avoid conflating:
   - abstract cluster tails with concrete Wilson-loop observables;
   - finite-support bookkeeping with a Q6 metric-tail theorem;
   - a one-plaquette sanity fixture with a volume-uniform strong-coupling
     theorem?
6. If a patch is feasible without new mathematical assumptions, propose it. If
   not, return the precise statement layer and say why proof should wait.

## Constraints

- Do not weaken existing Lean theorem statements.
- Do not introduce new assumptions that hide the Q6 tail theorem, cluster
  expansion, or observable expansion.
- Do not promote any draft GateYM result to trusted code.
- Do not add fake declarations, broad imports, or executable escape hatches.
- Keep statement names and docstrings claim-honest: conditional bridge,
  finite-support bookkeeping, or proof-design layer only.
- Sanity-check the one-plaquette / singleton-support case before recommending a
  broad interface.

## Success criteria

Best output:

1. A concise verdict on the right next Q8 statement layer.
2. Exact Lean-syntax declarations and a dependency DAG.
3. A minimal patch if it can be kernel-checked without adding mathematical
   content that is not already present.
4. A clear list of blockers, classified as Q6 metric-tail, Q7 coefficient /
   support-counting, or concrete observable-expansion work.

Acceptable output:

1. A semantic audit explaining why a concrete observable bridge is premature.
2. A smallest honest placeholder-free interface to add next.
3. Claim-language guardrails for the ledger, report, and paper-unit outline.

Return a concise report. If you provide Lean code, use the live files as
authoritative and state exactly which file it belongs in.
