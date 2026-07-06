# Wave-2 contingency plan (refill as wave-1 slots free)

Keep the fleet full while there is genuine work. On each harvest, submit the
matching follow-on. Semantic review BEFORE integrating any result.

## If A1 or A2 CLOSES the Q6 crux `pairSum_le_expBound`

- Integrate the winning proof into `PolymerKPConclusion.lean`; targeted
  `lake env lean` on that file; re-run `sorry` grep (expect the crux gone).
- If A3 already closed the two downstream sorries -> the whole KP conclusion
  file is `s o r r y`-free. WAVE-2 job: a `GateYM/AxiomGuard.lean` pinning the
  now-clean KP flagships (`kp_cluster_summable`,
  `kp_convergence_bound_of_selfIncompatible`, `kp_tail_bound`,
  `kp_convergence_bound_false`) to `[propext, Classical.choice, Quot.sound]`,
  plus the exponential-clustering CONSUMER (`ExponentialClustering`,
  `StrongCouplingPolymerMap`) now that its Q6 dependency is discharged.
- If A3 did NOT close them, submit A3's targets again (unconditional now).

## If A3 CLOSES the two downstream sorries (crux still open)

- Integrate; `PolymerKPConclusion` drops to 1 `sorry` (the crux only).
- WAVE-2: nothing new needed on KP; the crux jobs A1/A2 continue. Use the freed
  slot for the GateYM axiom guard on the sorry-free GateYM flagships (area law,
  Elitzur, reflectionForm_nonneg, Q4/Q5, kp_convergence_bound_false).

## If A4 LANDS the connected Wilson slab + hol factorization

- Integrate the new `WilsonSlabConnected.lean`; targeted build.
- WAVE-2 (HIGH VALUE): prove RP-LINK end-to-end on the connected slab (strip any
  residual hypothesis), then feed `rpBlockMatrix` -> a first PHYSICAL positive
  transfer operator -> sector-restricted `finiteMassGap` instance. This is the
  A5 design turned into proof, and it makes NE-U4 ("mass is the cost of
  closure") a theorem. Reuse A5's DAG.

## If A5 returns the transfer-gap design (statement freeze)

- Integrate `TransferGapFromRP.lean`; WAVE-2: prove the cheapest DAG nodes it
  left as handoffs, gated on A4's slab if needed.

## If A6 lands the product-Haar substrate

- Integrate `ProductHaarConfig.lean`; WAVE-2: attempt the RP bilinear-form
  positivity on the smallest concrete finite edge set (the part A6 was allowed
  to leave frozen), or the multi-link gauge-fixing corollary.

## If A7 lands fermionic RP-F (N5 crux or concrete fragment)

- Integrate; WAVE-2: the fermionic Ward-subtracted `confinementGap` (NE-U5
  stretch) per `QMF5_DESIGN_HARVEST.md` Deliverable 2, gated on N11/N12.

## If A8 lands NE-U6 electroweak

- Integrate `ElectroweakRung.lean`; WAVE-2: extend the smallest finite identity
  (composite two-point positivity/decay) if only the statement froze.

## If A9 lands the taxonomy separation theorem

- Integrate `MassTaxonomySeparation.lean`; targeted build; axiom-guard it.
- WAVE-2 (capstone upgrade): add the separation theorem as a companion to
  `AllMassFromNullEdges` (a fifth conjunct or a sibling theorem
  `allMassFromNullEdges_functionals_distinct`), so the bundling capstone ships
  WITH its F-YM-CONFLATE guard proved, not merely promised.

## If A10a returns the capstone audit

- Read the findings; apply any docstring/claim-discipline fixes to
  `AllMassFromNullEdges.lean` and the mass doc (a documented rejection or a
  required disclaimer is a result). Refill with a mid-run load-bearing audit of
  whatever biggest thing has landed by then, or the ~06:00 morning grand-
  strategy job.

## The ~06:00 morning grand-strategy job (reserve a slot)

Submit a strategy job reviewing the night's commits (git log
`overnight-mass-202607:`) + the harvested results, recommending the next day's
single highest-EV path and the honest distance remaining to "all mass". Feed its
output into `MORNING_REPORT.md`.
