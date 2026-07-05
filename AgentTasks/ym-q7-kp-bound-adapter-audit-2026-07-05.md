# Q7 KP-bound adapter audit (2026-07-05)

Scope: semantic/proof-design audit of the Q7 conditional KP adapter added in
commit `3db7523`, file
`PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymerMap.lean`, against the
Q6 KP interface and the four-day run notes.

## 1. Verdict

ACCEPT WITH CHANGES.

The adapter `kpCondition_of_plaquetteKPBound` is semantically correct, its
finite sum matches `PolymerKPCriterion.KPCondition` on
`plaquettePolymerSystem`, it does not hide the hard finite-bound proof, and the
stated claim boundary is honest. The only change requested is one accuracy
tightening in prose about what `plaquetteKPSum` is literally equal to (a signed
vs unsigned weight nuance), plus the recommended addition of a small gapless
bundling lemma that packages the KP condition together with self-
incompatibility (added in this pass; see section 4).

No semantic counterexample, no hidden convention mismatch, and no wrong finite
sum expression was found. No Lean theorem statement was weakened.

## 2. Findings by severity

### F1 (informational, resolved) - sum shape matches KPCondition exactly

`PolymerKPCriterion.KPCondition S incompatibleDecidable` is
`forall g, (sum over h in univ.filter (decide (incompatibleDecidable g h)))
|S.weight h| * exp (S.energy h) <= S.energy g`.

For `S = plaquettePolymerSystem Adj ... gammaAbs alpha halpha`:

- root polymer: `g = X`. MATCH.
- decidability witness: the adapter instantiates `KPCondition` with
  `plaquettePolymerIncompatibleDecidable`, which is the *same* witness used to
  build the filter inside `plaquetteKPSum`. MATCH (same named witness, not a
  re-derived instance).
- incompatibility filter: `incompatible X Y = SupportsOverlapOrTouch Adj
  X.support Y.support`, unfolded identically in both places. MATCH.
- energy expression: `S.energy Y = alpha * (Y.support.card : Real)`, so
  `exp (S.energy Y) = exp (alpha * Y.support.card)`, matching the exponential
  factor in `plaquetteKPSum`. MATCH.
- weight expression: `KPCondition` uses `|S.weight h|`; `plaquetteKPSum` uses
  `Y.coeffProduct gammaAbs` (no absolute value). These agree exactly because
  `coeffProduct gammaAbs Y >= 0` under `hgamma`, and the adapter discharges the
  gap with `abs_of_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma)`. MATCH under
  `hgamma`.

The `calc` block inside `kpCondition_of_plaquetteKPBound` is itself the kernel-
checked proof that the `KPCondition` filter-sum equals `plaquetteKPSum`, so the
match is machine-verified, not asserted.

### F2 (low, prose) - `plaquetteKPSum` is the unsigned form, note it

`plaquetteKPSum` is written with `Y.coeffProduct gammaAbs` rather than
`|Y.coeffProduct gammaAbs|`. As a standalone object it is therefore equal to
the KP filter-sum only when `gammaAbs` is nonnegative (the physical regime; the
adapter carries `hgamma`). This is deliberate and documented as the "physical
nonnegative-weight form", and is fine, but any downstream text that calls
`plaquetteKPSum` "the KP sum" unconditionally should say "the KP sum in the
nonnegative-weight regime `gammaAbs >= 0`". No Lean change needed.

### F3 (informational) - adapter is genuinely conditional

`kpCondition_of_plaquetteKPBound` takes `hBound : PlaquetteKPBound ...` as a
hypothesis and never discharges it. The only mathematical content added by the
adapter is the abs-drop (needs `hgamma`) and the definitional energy rewrites.
So the hard finite bound (and hence any volume-uniform / small-beta constant)
is not hidden anywhere. Axiom footprint `[propext, Classical.choice,
Quot.sound]` is consistent with a `s o r r y`-free adapter.

### F4 (informational) - self-incompatibility convention is supplied

`plaquettePolymerSystem_self_incompatible` proves `incompatible X X` for every
`X` (via `SupportsOverlap` using `X.support_nonempty`). Universally quantified,
this is exactly the `hself : forall g, S.incompatible g g` hypothesis consumed
by the corrected Q6 targets `kp_convergence_bound_of_selfIncompatible` and
`kp_tail_bound`. So Q7 does supply the convention that the corrected Q6 C2
requires.

Caveat (not a defect, but a boundary fact): the Q6 theorems that consume
`hself` (`kp_convergence_bound_of_selfIncompatible`, `kp_tail_bound`) are still
`s o r r y` handoffs, and they additionally require a `ClusterCoeffData` for the
plaquette system. So "Q7 supplies self-incompatibility" is true, but the full
Q7 -> convergence chain is not yet closed; it is blocked on the parked Q6
combinatorial proofs (`treeGraphBound_ursell`, `kp_partial_sum_bound`,
`kp_convergence_bound_of_selfIncompatible`).

### F5 (docs, accurate) - GateYM.lean, DAY_1_REPORT, run notes are honest

The module registry text in `PhysicsSM/Draft/NullEdge/GateYM.lean` (Q7 entry)
and `AgentTasks/fourday-ym-run-2026-07-05/DAY_1_REPORT.md` both describe
`StrongCouplingPolymerMap` as a "map layer / conditional adapter, not a finite-
bound proof" and explicitly disclaim any volume-uniform KP proof or general
finite-irrep coefficient map. `PolymerKPConclusion.lean`'s C2 correction (false
without self-incompatibility) is faithfully recorded. No stale or overclaiming
statement was found; nothing needs to be walked back.

## 3. Answers to the six questions

1. Yes. `plaquetteKPSum` matches the `KPCondition` finite sum for
   `plaquettePolymerSystem`: same decidability witness
   (`plaquettePolymerIncompatibleDecidable`), same root, same overlap-or-touch
   filter, energy `exp (alpha * area)`, and weight `coeffProduct` which equals
   `|weight|` under `hgamma`. The adapter's `calc` proves this equality in
   kernel.
2. Yes. `kpCondition_of_plaquetteKPBound` is valid; `hgamma` is used only to
   drop the absolute value, and `hBound` (the hard finite bound) is an
   unproven hypothesis, so nothing hard is hidden.
3. Yes. `plaquettePolymerSystem_self_incompatible` supplies the
   self-incompatibility convention that the corrected Q6 C2 needs. The
   downstream C2/tail theorems that consume it remain `s o r r y` and also need a
   `ClusterCoeffData`, so the end-to-end chain is not yet closed.
4. Yes, the claim boundary is honest: the adapter landed, but no volume-uniform
   KP theorem, no concrete connected geometry, no finite-irrep label estimate,
   and no Q8 clustering conclusion is proved.
5. See section 4.
6. No. The inspected docs are accurate; only the minor F2 wording nuance is
   worth a note.

## 4. Lean theorem added next (this pass)

Added, gapless, `s o r r y`-free (axioms `[propext, Classical.choice, Quot.sound]`):

```
theorem kpCondition_and_selfIncompatible_of_plaquetteKPBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (hBound : PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha) :
    KPCondition
        (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
          gammaAbs alpha halpha)
        (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
          NontrivialLabel gammaAbs alpha halpha)
      /\ (forall X, (plaquettePolymerSystem Adj ConnectedSupport
          NontrivialLabel gammaAbs alpha halpha).incompatible X X)
```

Rationale: this bundles `kpCondition_of_plaquetteKPBound` with
`plaquettePolymerSystem_self_incompatible` into the exact input pair
`(KPCondition, hself)` that the corrected Q6 C2 target
`kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` consume. It is
provable today with zero new gaps and makes the Q7 -> Q6 handshake explicit,
while remaining conditional on the unproven `hBound`.

## 5. Recommended next Q7/Q8 proof package

Ordered by dependency, from most-immediately-provable to hardest:

- P1 (prerequisite, provable now). A support-size / counting lemma: bound the
  number of connected polymers of a given area `k` that are incompatible
  (overlap-or-touch) with a fixed root polymer, in terms of a local branching
  constant `Delta` of `Adj` (max touch-degree) and `k`. This is the
  combinatorial fact every volume-uniform KP estimate needs, and it is pure
  finite counting - no reals, no `exp`. State it as a `Finset.card` bound on
  `univ.filter (incompatible X .)` restricted to area-`k` polymers.

- P2 (the honest finite fixture). A Z2 finite-torus theorem proving
  `PlaquetteKPBound` for a *specific* fixture using the oracle parameters
  `beta = 0.04`, `alpha = 0.75` ONLY as a finite fixture (not as a physics
  claim). Combine P1's count with the geometric-series majorant
  `sum_k N(k) * (tanh beta)^k * exp(alpha k) <= alpha` for that fixed small
  finite geometry. Keep it clearly labeled a fixture: it establishes the
  `PlaquetteKPBound` predicate for one concrete geometry, not a
  volume-uniform theorem.

- P3 (bridge, becomes gapless once Q6 lands). Chain
  `kpCondition_and_selfIncompatible_of_plaquetteKPBound` into
  `kp_convergence_bound_of_selfIncompatible` (plus a plaquette
  `ClusterCoeffData`) to obtain a plaquette-level convergence/tail statement.
  Today this inherits the Q6 `s o r r y`s (`treeGraphBound_ursell`,
  `kp_partial_sum_bound`, `kp_convergence_bound_of_selfIncompatible`); it
  becomes unconditional exactly when those parked Penrose/tree-sum proofs land.

- P4 (Q8). Only after P1-P3: feed the plaquette tail into
  `hasExponentialClustering_of_tailContribution_bound` (or the finite-support
  variant) via a concrete observable-to-cluster `hBridge`. Do not attempt Q8
  clustering as a headline result before the Q6 tail is unconditional.

Priority: P1 then P2 give real, kernel-checked new content without touching the
parked Q6 combinatorics; P3/P4 are unblocked by the separate Q6 tree-graph
package (`treeGraphBound_ursell`, `kp_partial_sum_bound`).
