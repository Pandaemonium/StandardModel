# Null-edge rank-four probe-sector semantic correction

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked; independently approved with required documentation

## Finding

The finite Gram-congruence and Lorentz-gauge theorems in
`ProbeFrameLorentzGauge.lean` are algebraically correct, but their frame type is

```text
Module.Basis (Fin 4) Real (carrierProbeSubspace A).
```

Here `carrierProbeSubspace A` is the entire zero-sum scalar-field space on the
closed carrier. For every nonempty finite event type `U`, this space has
dimension `|U| - 1`. Consequently, the existing `CarrierProbeFrame A`
hypothesis, and hence the existing `HasLorentzianInertia` hypothesis, can be
inhabited only when the closed carrier contains exactly five events.

This is not a false proof. It is a semantic-domain mismatch: the old interface
is a five-event control and cannot represent four physical probe modes on a
large refinement carrier.

## Correction

`PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean` introduces a
successor interface:

```text
RankFourCarrierProbeSector A
```

Its `space` is a rank-four subspace of the full zero-sum carrier space. Frames
are bases of this selected subspace. The module then re-establishes:

1. exact Gram congruence under frame change;
2. the conditional Lorentz gauge characterization;
3. exact transport of sectors, frames, and Gram matrices under causal-order
   isomorphisms;
4. properness of every selected rank-four sector when the carrier has more
   than five events.

The supplied-sector interface is an architectural repair, not a derivation.
It prevents the finite algebra from pretending that the whole zero-sum space
stays four-dimensional as the carrier grows.

## What the graph still owes

The continuum GR program now has a sharper G2 subgate. From each protected
carrier in the growing bounded-multiplicity atlas, the bare decorated order
must derive a subspace `P_A` satisfying all of the following:

1. `P_A` lies inside the zero-sum scalar-field sector;
2. `finrank P_A = 4` on the accepted bulk carriers;
3. retarded-shell restriction separates `P_A` quantitatively, not merely by
   cardinality;
4. order relabeling transports `P_A` naturally;
5. overlap restriction maps between neighboring charts are injective and have
   matching image, producing the transition maps in
   `OverlapRestrictionTransition.lean`;
6. the corrected operator pairing on `P_A` has Lorentzian inertia;
7. the selected sectors and transition maps converge to a cotangent bundle
   and local Lorentz gauge class.

No preferred basis should be derived. The graph-level target is the rank-four
subspace and its overlap transition class; individual tetrads remain gauge
choices.

## Candidate selectors to test

The next empirical/theoretical round should compare selectors that remain
order-native and do not inspect a target embedding:

1. four-dimensional low-mode sectors of a symmetrized retarded operator on a
   protected carrier;
2. four leading generalized modes selected by the corrected pairing against a
   positive shell norm;
3. multiscale count-profile modes whose restrictions remain stable across
   nested carrier cores;
4. overlap-consensus modes selected jointly across the atlas rather than chart
   by chart.

Each proposal needs a degeneracy policy. A spectral selector is not intrinsic
if an unresolved eigenspace tie is broken by labels; the subspace may remain
intrinsic even when no basis inside it is.

## Claim disposition

- `M [orig]`: the old whole-zero-sum frame forces exactly five carrier events.
- `M [orig]`: supplied rank-four sectors recover exact finite Lorentz gauge
  algebra and order-isomorphism covariance.
- Open reconstruction gate: a bare-order rule selecting a stable physical
  rank-four sector on large carriers.
- Closed: continuum tetrad/spin bundle, curvature convergence, Einstein
  dynamics, physical stress-energy, and calibrated constants.

The main GR note already warns that the five-event model is a control and that
the full zero-sum sector is too large. This correction upgrades that prose
warning to a kernel-checked obstruction and a nonvacuous successor type.

## Verification record

- Module SHA-256:
  `5095835582c12a2cc3280ca18cd07daa3d4c892e71dd10e23dbaa880d5850dd7`.
- `lake env lean PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean`
  passed with no diagnostics.
- `lake build PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector` passed
  (`8036` jobs) before the final algebraic-nonvacuity theorem was added.
- `lake build PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector` then
  rebuilt this module and its successor successfully (`8037` jobs total).
- After adopting Claude review requirement R1, a combined downstream build of
  `RankFourSectorWeylScaleBridge` and `CarrierProbeOverlapTransition` passed
  (`8047` jobs), rebuilding this module and both successor chains.
- Build-enforced guards report only `propext`, `Classical.choice`, and
  `Quot.sound` on the displayed flagship theorems.
- The external Claude wrapper call is logged at
  `AgentTasks/model-calls/claude/2026-07-16-102530-rank-four-probe-sector-semantic-audit-20260716.md`;
  it returned `Credit balance is too low` and produced no verdict.
- The same review was routed to the active lab Claude lane as mailbox message
  `msg-20260716-102613-74b2194d` with the review packet
  `AgentTasks/null-edge-rank-four-probe-sector-review-request-2026-07-16.md`.
- Claude's full semantic audit is recorded in
  `AutonomousLab/reviews/CLAUDE_REVIEW_RANK_FOUR_PROBE_SECTOR_2026-07-16.md`.
  It approved the theorem shapes, nonvacuity, transport semantics, and claim
  boundary, subject only to a documentation rule now added to the module:
  downstream code must receive a sector explicitly and may not choice-extract
  one from the algebraic nonemptiness theorem before a graph-native selector
  lands.
