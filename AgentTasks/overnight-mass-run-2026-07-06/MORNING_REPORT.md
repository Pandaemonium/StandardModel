# Overnight all-mass run - MORNING REPORT (2026-07-06)

STATUS: LIVE (run continues to 9am; ~34 commits, consolidation green; crux attempt in flight).

## Mission

Get as close as possible to explaining all of mass using null-edge theory, at
kernel-checked theorem grade, with honest claim labels. Opus 4.8 sole local
agent + up to 10 concurrent Aristotle jobs. See
`AgentTasks/overnight-mass-run-2026-07-06/RUN_PLAN.md`.

## Headline

The night turned the null-edge mass thesis from a **list of separately-true
finite facts** into a **guarded conjunction with two genuine cross-mode
bindings**. Two structural advances stand out: (1) the flagship
`apertureEqualsTurn_onShell` (now FULLY proved, existence and all) puts the
**turn (T)** and **aperture (A)** obstruction modes on ONE on-shell 3+1D momentum
(`2*minkDot k+ k- = m^2 =` the chirality-even turn coefficient) - the former #1
structural weakness (a conjunction across disjoint universes) is now a
shared-object identity for the T/A pair; and (2) the taxonomy theorem proves the
four mass functionals **pairwise DISTINCT**, so the capstone
`allMassFromNullEdges_guarded` is no longer vulnerable to the
one-quantity-relabeled (F-YM-CONFLATE) over-claim. The honest, defensible claim
is: **mass is a relational null-transport obstruction, demonstrated on four
representative facts, with T and A now bound on one object and the taxonomy
proved non-degenerate** - strictly stronger than a conjunction, strictly weaker
than a unified mechanism. What we do NOT have: a single model carrying more than
two modes - **closure (C)** lives in a Z2 transfer model with no `Momentum4`, so
it shares only a mechanism SHAPE with A and T, not a shared quantity. Two
kernel-checked NEGATIVES were also banked (the Q6 downstream KP conclusions and
the periodic-circle fermionic Gram crux are FALSE), each with its corrected
direction recorded. Source: mission strategy `97a015dd`
(`sm-morning-strategy-FINDINGS_97a015dd.md`).

## Theorems landed (all footprint [propext, Classical.choice, Quot.sound], 0 sorry unless noted)

- **`allMassFromNullEdges`** + **`allMassFromNullEdges_guarded`** (71a24c0,
  fd0541d, 33868be, d2063d7) - the T/C/A + co-location bundling capstone, plus
  the guarded companion bundling it WITH the proved mass-functional distinctness.
  Build-enforced axiom guards. Hardened twice per the capstone audit (5a7d6910)
  and mission strategy (70c4b556): (T) strengthened to genuine channel
  separation; (C) flagged detached; taxonomy guard discharged.
- **`massTaxonomy_functionals_pairwise_separated`** (A9, 683f10d) - the four
  mass functionals (bare, Wilson regulator, closure glueball, composite aperture)
  proved PAIRWISE DISTINCT. F-YM-CONFLATE at theorem grade.
- **`wilsonSlabConnected_reflectionPositive`** (A4, 683f10d) - RP for the first
  CONNECTED cut-bearing Wilson slab, arbitrary finite group G. The audits'
  "empty center of gravity" missing object, built. OS-ingredient (not-gap) label.
- **`ProductHaarConfig`** (A6, c925bfb) - multi-link product-Haar gauge/reflection
  symmetries PROVED (SU(N)); RP positivity one frozen handoff sorry.
- **`ElectroweakRung`** (A8, c925bfb) - gauge-invariant composite W,
  `wLikeMass_pos`, AND exact two-point exponential clustering. One unused
  Fradkin-Shenker handoff sorry.
- **`neU4_closure_gap_pos`** + `slabRPBlock_posSemidef` (sm-slab-transfer,
  8fec85d) - the NE-U4 "mass is the cost of closure" rung: the FIRST non-toy PSD
  transfer block from the connected slab (arbitrary G), and the sector-restricted
  center-flux closure gap is positive (honest fluxGap, disjoint sectors),
  gap = -log(tanh beta). Full two-plaquette Gram spectrum = documented handoff.
- **`SelfIncompatCex.selfIncompat_convergence_bound_false`** +
  **`TailCex.tail_bound_false`** (A3, 841796a) - VERIFIED NEGATIVES: the
  four-day-run's two downstream Q6 conclusions are FALSE as stated; kernel-checked
  counterexamples + the corrected `..._plain` version. See
  `Q6_DOWNSTREAM_FALSE_FINDING.md`. (Follow-up: revise StrongCouplingPolymerMap.)
- **A1 crux DAG primitives** (841796a) - block partition / reindexing / weight
  factorization for `pairSum_le_expBound`; crux narrowed to one residual (now
  attacked by sm-crux-fibercount).
- **GateYM axiom guard** (977b101) - 8 sorry-free spine flagships pinned
  (area law, Elitzur, RP kernel, Q5, center-flux gap, verified-negative KP).

## Distance-to-all-mass note (from strategy 70c4b556)

Floor already banked (capstone + A9 + the aperture=turn bridge are independent of
the hard-YM Q6/slab jobs). The hard YM proofs buy little for the MASS thesis
(only the NE-U4 (C)-upgrade toy->physical). "Unification" = shared SHAPE not
shared quantity (no shared model where (C)=(A); Z2 has no Momentum4). The T+A binding (`apertureEqualsTurn`) LANDED and is now unconditional; the
third-mode shared STRUCTURE (`ObstructionScalar`) also landed - see Headline.

## Verification

- **Consolidation build (~05:15):** `lake build PhysicsSM.Draft.NullEdge.GateI1
  PhysicsSM.Draft.NullEdge.QMF PhysicsSM.Draft.NullEdge.GateYM` -> **Build
  completed successfully (8203 jobs)**. Every one of tonight's integrated modules
  (capstone+guarded, taxonomy separation, connected slab, NE-U4 slab gap,
  product-Haar, electroweak rung, merged crux/downstream) compiles together under
  the pinned `leanprover/lean4:v4.28.0`. Draft-trust; the only `s o r r y`s are
  the documented handoffs (crux + 2 known-false-downstream + product-Haar RP +
  Fradkin-Shenker).
- **Final consolidation build (~07:00):** same three aggregators, now including
  the fully-proved flagship `ApertureEqualsTurn` and `ProductHaarZ2RP` ->
  **Build completed successfully (8205 jobs)**. The whole night's integrated
  tree is green.
- Per-headline axiom footprints spot-checked at `[propext, Classical.choice,
  Quot.sound]` throughout (including `apertureEqualsTurn_exists`, now
  UNCONDITIONAL - no `sorryAx`); build-enforced guards on the capstone, QMF,
  GateYM, Furey, and E8 flagships.
- Remaining `s o r r y`s in the integrated tree are all documented handoffs:
  the Q6 crux `pairSum_le_expBound` + its 2 dependents, the 2 KNOWN-FALSE Q6
  downstream statements (kept with refutations, revise-in-tandem), the general
  product-Haar RP positivity (Z2 case now closed), and the Fradkin-Shenker
  electroweak reconstruction. No trusted (sorry-free) theorem depends on any.

## Aristotle harvests (integrated)

| job | target | verdict | commit |
| --- | --- | --- | --- |
| A4 cd433660 | connected Wilson slab | landed, arb G RP | 683f10d |
| A9 812c4c06 | mass-taxonomy separation | landed, 4 distinct | 683f10d |
| A6 fa7fba4a | product-Haar rung | landed (symmetries proved) | c925bfb |
| A8 2d096e24 | electroweak rung | landed +2pt clustering | c925bfb |
| A10a 5a7d6910 | capstone claim audit | integrated (hardened) | fd0541d |
| 70c4b556 | mission strategy | guidance actioned | d2063d7 |
| A1 7f990a2c | Q6 crux | DAG primitives (crux open) | 841796a |
| A3 b6f17681 | Q6 downstream | FALSE-discovery + refutations | 841796a |
| fdab1ce4 | slab transfer gap | NE-U4 landed | 8fec85d |
| e751a5c8 | crux fibercount | arithmetic core (crux open) | 4642e4c |
| 3e0eb3f5 | aperture=turn FLAGSHIP | landed (1 handoff) | 470d17d |
| 4510f446 | Z2 product-Haar RP | landed (A6 handoff closed) | 470d17d |
| 322b9f72 | fermionic Gram crux | FALSE on periodic circle | (finding) |

## Harvests rejected (documented)

- **A5 a8e61bfc (transfer-gap design):** SUPERSEDED by the concrete sorry-free
  `SlabTransferGap.lean`; integrating the design's frozen sorries would be debt.
- **A7 8684c341 (fermionic scaffold):** conditional on the N5 crux, later proved
  FALSE (periodic circle) - correctly NOT integrated; kept FermionicReflection
  sorry-free.
- **A2 1b255ef8 (crux attempt 2):** no new progress (5% when 2h-stopped).

## Verified NEGATIVES (kernel-checked disproofs - first-class results)

- Q6 downstream KP conclusions FALSE as stated (`Q6_DOWNSTREAM_FALSE_FINDING.md`).
- Fermionic RP-F N5 Gram crux FALSE on periodic time circle
  (`FERMIONIC_RPF_CRUX_FALSE_FINDING.md`).
Both from Aristotle jobs correctly refusing to fabricate; both with the corrected
direction recorded.

## Claim-discipline audits

- A10a (5a7d6910): capstone hardened - (T) strengthened to genuine channel
  separation, (C) flagged detached, dangling citation removed, "all mass" prose
  re-scoped. All fixes applied + a guarded companion added.
- The mission strategy (70c4b556) deepened the (C)/(T) caveats (both applied).

## Honest distance remaining to "all mass from null edges"

- **What is now established (draft-trust, finite grade):** mass is exhibited as a
  relational obstruction to null transport in all three modes - APERTURE, TURN,
  CLOSURE - each a kernel-checked finite/kinematic identity with zero
  primitive-mass input; the octonion charge co-locates without coupling; the four
  mass functionals are proved pairwise DISTINCT (F-YM-CONFLATE at theorem grade);
  and - the night's structural advance - the FLAGSHIP now binds TWO of the three
  modes (aperture = turn) on ONE on-shell object, so the T/A pair is no longer a
  mere conjunction but a shared-object identity.
- **UPDATE (third-mode structure, dd461d6):** `ObstructionScalar.lean` now
  FORMALIZES the shared shape - closure and aperture both provably instantiate one
  abstract `ObstructionScalar` (a strictly-antitone functional of a return ratio,
  with one shared 'massless iff degenerate' law and a non-vacuity witness). So
  "shared SHAPE" is no longer prose: all three modes now share a kernel-checked
  STRUCTURE. This is still NOT a shared QUANTITY (different functionals/carriers;
  no Momentum4<->Z2 map), so the honest ceiling is "one shared obstruction
  structure, three instances; T and A additionally bound as one scalar."
- **The remaining gap:** the CLOSURE mode (C) still shares no model with aperture
  (A) - `z2GlueballMass` has no `Momentum4`; the honest verdict stays "shared
  SHAPE, not shared quantity" for the C-vs-(T/A) relation. Full unification would
  need a C-to-A binding on a shared carrier, which does not exist and may be
  artificial (the kill-test).
- **Mountains (unchanged, mostly OFF the mass thesis's critical path):** the Q6
  crux `pairSum_le_expBound` (narrowed to a combinatorial fiber-count residual);
  the full connected-slab NE-U4 spectrum; the corrected single-cut fermionic
  RP-F; the physical/continuum YM gap (permanently off-ladder). Per the strategy,
  these buy little for the MASS thesis specifically (its floor is already banked).

## Recommended next day (from mission strategy 97a015dd, ranked EV/effort)

1. ~~Complete the flagship existence `twoNull_resolution_exists`~~ **DONE this
   run** (sm-aperture-existence, 2caa0789): `apertureEqualsTurn_exists` is now
   UNCONDITIONAL, 0 sorry.
2. **Retire the false lemma from the Q7->Q6 wiring** (CHEAP, HIGH):
   `StrongCouplingPolymerMap.plaquetteKP_convergence_bound_of_plaquetteKPBound`
   consumes the FALSE `kp_convergence_bound_of_selfIncompatible`; reroute through
   the corrected `_plain`/`hself` target, then DELETE the false theorems. Codex's
   file - coordinate. Do before any external report ships.
3. **Close the Q6 crux residual** `pairSum_le_expBound` (arithmetic core +
   partition primitives proved; residual = the fiber-count injection + regrouping,
   reduced to `boundedTouchSum_succ_le_finitePartial`). Unblocks the whole KP
   chain (3 dependent sorries fall).
4. **The strategic swing: extend aperture=turn toward CLOSURE** - a
   `apertureEqualsTurnEqualsClosure` binding relating the on-shell scalar to a
   closure gap on a SHARED carrier (an abstract "obstruction scalar" both
   instantiate). The only move attacking the sharpest gap (no shared C-A model);
   speculative, guard hard against a vacuous identification.
5. **Deepen two pillars:** (a) full-slab NE-U4 spectrum (extend beyond the Z2
   sector); (b) re-state fermionic RP-F on SINGLE-CUT geometry (periodic-circle
   is FALSE).

Biggest over-claim to guard (strategy 3): the name "all mass" over-reads - it is
a guarded conjunction with ONE two-mode binding, NOT a unified mechanism; C is
not bound to A/T; the (C) zero is definitional; the KP chain is open and was
partly false. The report says exactly that.
