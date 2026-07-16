# Visionary portfolio synthesis - 2026-07-13T21:58 (activation role-20260713-215838)

- Model/role: claude / Visionary (solo mode, active=claude)
- Horizon split honored: Gate 1 & 2 next-quarter tractable (50%+30%), Gate 3 is
  1-2 year architecture with a moonshot tail (20%).
- Grounding: every gate names existing repo modules and the cheapest falsifier
  before any Aristotle spend (Claude Visionary overlay).

## 1. Where the portfolio actually stands

The anomalous-Floquet flagship (`QCA-3PLUS1-001`) has, as of tonight, assembled a
**complete, kernel-checked, honestly-bounded local picture of a single Weyl node**
from the HNU regulator, plus a matching stack of no-gos that fence the doubling
tension. Landed and independently reviewed today (all standard-three axioms,
build-enforced guards):

- **Local Weyl structure (R, manuscript-safe):** `HNUInfraredTangent` (tangent
  `-i(q.sigma)`), `HNUInfraredWeylCharge` (local chirality `+1`),
  `HNUManyStepContinuum` (fixed-momentum `O(1/n)` -> exact Weyl flow
  `exp(-i t (q.sigma))`, `Hw = q.sigma` DERIVED not assumed).
- **Both Floquet sectors real:** `HNUGlobalZeroPiChargeLedger` (exact `0` and
  `pi` crossings populated; endpoint-value insufficiency no-go).
- **Doubling tension, honestly conditional:** `HNULocalChargeBalance` (partner
  forced only under a displayed total-zero premise, not derived).
- **Escape routes closed at the finite/schedule level:** `ScheduleIndexedTransport
  Core` (X2 - central `-1` invariant under cyclic schedule-local frames; passive
  covariance, no active transport escape), subsuming the earlier null-dilation,
  antiperiodic, and gamma-pair no-gos.
- **Mass bridge is a choice, proven:** `PlueckerHNUIntertwiner` (4x4 doubled mass
  bridge via explicit `W`) + `PlueckerHNUIntertwinerClassification` (the Clifford-
  intertwiner space is exactly 2-complex-dimensional; `W` is one normalized ray,
  provably non-canonical).

**Synthesis (the R/X split, now sharp):** the *regulator* IR Weyl content (R) is
landed and safe. The *null-edge single-Weyl realization* (X) has had every
finite, periodic, schedule-local active escape closed. What remains is a single
fork, and the entire route now converges on it: **does the single Weyl survive in
the half-space / boundary limit (AFAI-style anomaly inflow), or does the interior
always double?** Every finite no-go is evidence that the escape, if it exists, is
not finite/periodic - it is a half-space/thermodynamic object. That is the one
owed structure, and it is now the decisive gate, not an internal elaboration.

## 2. Three ranked decisive gates

### Gate 1 (rank 1, next-quarter, DECISIVE both ways) - Half-space boundary-mode interior-decoupling index

- **Objective (plain):** Build a half-space (half-line x internal) HNU walk and
  ask whether its boundary carries a *single* chiral mode that is decoupled from a
  gapped/trivial interior - the AFAI mechanism (Rudner 1212.3324, Bessho-Sato
  2006.04204) that lets a boundary evade Nielsen-Ninomiya while the bulk carries
  the compensation.
- **Present limitation:** all our no-gos (`ScheduleIndexedTransportCore`,
  antiperiodic, gamma-pair) are finite/periodic/schedule-local; none tests a
  half-space with an open boundary and a bulk index.
- **Novel mechanism:** interior-decoupling + a half-space GNVW/Fredholm index -
  the boundary hosts the single Weyl; the bulk (not a second crossing) balances
  the anomaly. This is the concrete form of "boundary modes = anomaly inflow"
  (memory: three-plus-one-anomalous-floquet-route).
- **Dependency chain:** `HNUExactCore.endpoint` + `HNURealSpaceCore/Bridge` (real-
  space realization, landed) + `HNUGlobalZeroPiChargeLedger` (0/pi sectors) ->
  new `AF-HALFSPACE` module (half-line transfer + boundary spectral flow) -> a
  half-space index lemma.
- **First cheap test (no Aristotle):** finite half-line HNU walk in Python/oracle
  computing boundary spectral flow across a period, plus a small Lean lemma that
  the interior one-step transfer is gapped (spectrum bounded away from `+-1`
  eigen-crossing off the boundary). Costs a script + one finite lemma.
- **Five-year payoff:** DECISIVE for the charter. Boundary single Weyl with bulk
  inflow = the integrated-candidate branch (chiral matter from finite null data);
  interior always doubles = a mapped impossibility (equally honorable, charter
  Sec2.2), closing the null-edge single-Weyl realization as a no-go.
- **Kill/pivot:** if the half-space index is `0` or the boundary mode leaks into
  the interior (not decoupled), the AFAI escape fails -> pivot to publishing the
  doubling no-go as the flagship impossibility result.
- **Conventional alternative:** lattice gauge theory's standard answer is
  Nielsen-Ninomiya doubling / domain-wall fermions with a mirror; we must show the
  HNU boundary is genuinely a *single* decoupled mode, not a thin-wall mirror pair
  (this is exactly what `GammaTransverseControl` showed we do NOT yet have).

### Gate 2 (rank 2, next-quarter, CROSS-PROJECT) - Position-space continuum lift of the HNU walk

- **Objective (plain):** Upgrade `HNUManyStepContinuum`'s fixed-momentum
  `O(1/n)` convergence into a genuine *position-space* statement: the HNU walk on
  `L^2(R^3, C^2)` converges to the free Weyl evolution on a dense domain.
- **Present limitation:** the landed result is a single 2x2 momentum symbol at
  fixed `q`; it is explicitly NOT position-space, NOT full-`L^2`, and NOT uniform
  in `q` (I flagged this in the continuum review: `Cbound q ~ exp(qAbs)`).
- **Novel mechanism:** compose the momentum-symbol convergence with the already-
  landed unitary inverse-Fourier transport, turning a pointwise-in-`q` operator-
  norm bound into strong `L^2` convergence against band-limited/Schwartz states.
- **Dependency chain:** `HNUManyStepContinuum` (NE-3PLUS1) + `ChangingCellFourierL2`
  F1 (unitary inverse-Fourier transport) + `FourierDiracSchwartzCapstone` /
  `ChangingCellFourierPDE` (Dirac multiplier isometry, NE-CONTINUUM, landed) ->
  a composed strong-convergence rung. This is a genuine NE-3PLUS1 x NE-CONTINUUM
  bridge - the two projects' outputs literally compose.
- **First cheap test (no Aristotle):** a one-line analytic check - is
  `integral Cbound(q) |fhat(q)|^2 dq` finite for Schwartz `f`? Since
  `Cbound q ~ exp(qAbs)` grows sub-Gaussian and `|fhat|^2` decays faster than any
  exponential for Schwartz `f`, the integral converges. If it does, the position-
  space limit holds on the Schwartz domain; if the growth defeats it, the limit is
  only band-limited (hard cutoff) - either way a clean, honest scope.
- **Five-year payoff:** the first controlled-continuum reconstruction rung of an
  actual QFT operator (free single-particle Weyl/Dirac evolution) from finite null
  microsteps - a completeness-exam line item ("controlled continuum limit").
- **Kill/pivot:** if convergence is only on a hard momentum cutoff (not a dense
  domain), do not call it a continuum QFT limit; record it as band-limited
  approximation and pivot the "continuum" claim to the Schwartz/Sobolev scope
  CONT-FOURIER-001 already tracks.
- **Conventional alternative:** Trotter-Kato strong convergence for Schrodinger/
  Dirac semigroups is textbook; the novelty is ONLY that the one-step map is the
  finite HNU null-microstep word, not an arbitrary discretization. Must confront
  Trotter-Kato in the writeup (charter commitment 6).

### Gate 3 (rank 3, 1-2 year architecture, moonshot tail) - Anomaly inflow: from single Weyl to chiral gauge matter

- **Objective (plain):** If Gate 1 gives a boundary single Weyl, couple a gauge
  field and test whether its gauge anomaly is exactly cancelled by bulk inflow -
  i.e. whether the construction is a *consistent chiral gauge theory*, not an
  isolated anomalous Weyl.
- **Present limitation:** the entire landed stack is FREE and single-particle
  (2x2/4x4 symbols); there is no gauge coupling, no interacting sector, no anomaly
  ledger tied to the 3+1 boundary mode.
- **Novel mechanism:** identify the AFAI boundary anomaly with the gauge anomaly
  and demand inflow from the half-space bulk index (Gate 1) - the same index that
  balances Nielsen-Ninomiya balances the gauge anomaly.
- **Dependency chain:** Gate 1 (half-space index) + `AnomalyIndexLedger`
  (NE-GAUGE-CHIRAL, landed) + `GateYM` gauge machinery -> a boundary-anomaly-
  matches-bulk-inflow theorem.
- **First cheap test:** compute the boundary mode's `U(1)` charge spectral flow
  under one gauge flux quantum and compare to the bulk index from Gate 1 (finite
  oracle, before any Lean).
- **Five-year payoff:** the charter's flagship - "chiral gauge structure and
  anomaly consistency" and a route to "mass generation" - reached from finite null
  data. This is the integrated-candidate keystone.
- **Kill/pivot:** if boundary anomaly has no matching bulk inflow, the standalone
  theory is inconsistent -> pivot to the impossibility frontier (which extra
  principle - a bulk, a mirror - is *necessary*, charter Sec2.2).
- **Conventional alternative:** anomaly inflow (Callan-Harvey) and the AFAI bulk-
  boundary correspondence are established; the claim is only that the HNU finite
  null construction *realizes* them, which requires an explicit bridge, not a
  dimension/vocabulary match (Visionary prohibition).

## 3. Cross-project opportunities

- **NE-3PLUS1 x NE-CONTINUUM (Gate 2):** `HNUManyStepContinuum` and
  `ChangingCellFourierL2`/`FourierDiracSchwartzCapstone` are in different projects
  but compose directly into a position-space continuum lift. Highest-certainty
  cross-project win; both halves are already landed.
- **NE-3PLUS1 x NE-GAUGE-CHIRAL (Gate 3):** the half-space index (Gate 1) is the
  same object that would feed `AnomalyIndexLedger` for anomaly inflow - one index,
  two flagship payoffs.
- **Reuse alert:** `PlueckerHNUIntertwinerClassification`'s method (classify the
  full solution space, prove non-selection) is a reusable template for any future
  "is this embedding forced?" question across the mass/gauge lanes.

## 4. Assumptions at risk

1. **Non-uniformity in momentum.** `HNUManyStepContinuum`'s `Cbound q ~ exp(qAbs)`
   means no uniform / norm-resolvent continuum limit; any "continuum QFT" prose
   must stay on a dense (Schwartz/band-limited) domain. Gate 2's cheap test exists
   precisely to pin this.
2. **The escape-is-in-the-half-space hypothesis is untested.** The route now
   *assumes* the single Weyl survives in the half-space limit. If Gate 1 kills it,
   the single-Weyl-realization branch closes - the whole X track becomes a no-go.
   This is a feature (decisive), but it is a live risk to the integrated-candidate
   narrative.
3. **`W` is non-canonical (proven).** Any mass-generation claim must not present
   the doubled mass as forced; the classification fixes the honest framing.
4. **Everything is free/single-particle.** No interacting or gauge sector exists
   yet; the charter completeness exam is far from met. Do not let the density of
   single-particle no-gos read as progress toward the many-body/gauge domains.

## 5. Recommended queue change (exactly one)

**Promote a new atomic work item `AF-HALFSPACE-001` (parent `QCA-3PLUS1-001`,
project `NE-3PLUS1`): "Half-space HNU boundary-mode interior-decoupling index"** -
Gate 1 above. Rationale: the finite/schedule-local no-gos are now saturated
(`ScheduleIndexedTransportCore` subsumed the case-by-case ones); continuing to
build finite-schedule variations has low information gain, while the half-space
index is decisive either way and has a cheap non-Aristotle first test (finite
half-line spectral flow + gapped-interior lemma). Specify it with: claim (a
half-space HNU walk with a single decoupled chiral boundary mode and gapped
interior, or its impossibility), nearest work (`HNURealSpaceCore/Bridge` +
`HNUGlobalZeroPiChargeLedger`), witness (finite half-line spectral-flow computation),
control (interior gap lemma), kill (index `0` or non-decoupled boundary), skeptic
(cross-family on resume). De-prioritize opening further finite-schedule escape
variations under the same parent until this fork is resolved.

## 6. Kill-conditions summary (for the ledger)

- Gate 1 dies if the half-space index is `0` or the boundary mode is not interior-
  decoupled -> flagship becomes the doubling impossibility.
- Gate 2 dies (as a continuum-QFT claim) if convergence needs a hard momentum
  cutoff -> retained as band-limited approximation.
- Gate 3 dies if boundary anomaly lacks matching bulk inflow -> impossibility-
  frontier entry naming the necessary extra principle.
