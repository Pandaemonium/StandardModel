# Claude review: HNULocalChargeBalance (conditional partner theorem)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-195719, item QCA-3PLUS1-001
- Source: `PhysicsSM/Draft/NullEdge/HNULocalChargeBalance.lean` (66, sha a7be4a31
  MATCH), in-repo; imports `ChargeBalanceForcesPartner` + `HNUInfraredWeylCharge`.
- Date: 2026-07-13

## Verdict: APPROVE

A clean, honest, correctly-conditional Nielsen-Ninomiya partner statement.
Targeted repo build `lake build PhysicsSM.Draft.NullEdge.HNULocalChargeBalance`:
BUILD_EXIT=0; 3 proper `#guard_msgs` at the standard three; 0 sorry/native_decide/
axiom. All five requested checks pass.

## Requested checks

### Vacuity - NONE (premise satisfiable AND constraining)
The zero-total premise is genuinely inhabited: `ChargeBalanceForcesPartner.
oppositeFixture` (`weylPlusJacobian`, `weylMinusJacobian`) has
`oppositeFixture_total_charge_zero` (`+1 + (-1) = 0`). Conversely
`hnuSingleton_charge_sum_ne_zero` proves the HNU node ALONE fails it
(`sum = +1 != 0`). So the theorem is about a real, non-trivial premise class, not
vacuously true.

### Hidden assumptions - NONE
The docstring is explicit: "The zero-total premise is DISPLAYED and is not derived
here from Brillouin-zone topology, Floquet micromotion, locality, or a
bulk-boundary theorem. Thus the result is a precise local-to-global implication,
not an unconditional doubling theorem for the HNU regulator." The only hypotheses
are the displayed `i0 in s`, `J i0 = weylJacobian`, and `hsum : sum ... = 0`.

### Convention mismatch chirality / localCrossingCharge - NONE
Both are the SAME det-sign charge. `localCrossingCharge` is det-based
(`localCrossingCharge_ne_zero_iff : localCrossingCharge A != 0 <-> A.det != 0`;
`localCrossingCharge_eq_one` on `det = 1`), exactly like `chirality =
sign(det)` from WeylSphereChargeBridge. `hnuLocalCrossingCharge_eq_one` proves
`localCrossingCharge weylJacobian = 1` via `weylJacobian_det = 1`, agreeing with
`chirality weylJacobian = 1`. The partner theorem is stated ENTIRELY in the
`localCrossingCharge` API (the charge-balance API's own convention), with
`weylJacobian` and its `det` the only things drawn from HNUInfraredWeylCharge - so
the two conventions are not mixed, and where they touch (the HNU node) they agree
`= +1`.

### Total-charge-zero visibly load-bearing - YES
`hsum` is an explicit hypothesis threaded straight into
`exists_second_nondegenerate_of_total_charge_zero`, whose proof uses it in
`exists_second_nonzero_of_sum_eq_zero` (a nonzero term + zero sum forces a second
nonzero term). And `hnuSingleton_charge_sum_ne_zero` demonstrates the premise does
real work: WITHOUT a partner the sum is `+1 != 0`, so zero-total is precisely what
compels the partner. Load-bearing, not decorative.

### Genuinely distinct nondegenerate partner - YES
The conclusion is `exists i1 in s, i1 != i0 and (J i1).det != 0`: a DISTINCT
(`!= i0`) crossing that is NONDEGENERATE (`det != 0`, hence nonzero
localCrossingCharge). Not a relabelling of the HNU node; a second genuine crossing.

## Over-claim modes

- Vacuity: none (above).
- Hollow telescoping: none - the finite-sum partner argument
  (`exists_second_nonzero_of_sum_eq_zero`) is substantive, and the negative
  control makes the premise bite.
- Docstring-outruns-kernel: none - explicitly "conditional ... not an
  unconditional doubling theorem"; the zero-total is not derived.
- False shape: none - this is exactly the local-charge Nielsen-Ninomiya partner
  implication, conditional on the local-ledger anomaly-cancellation premise.

## Fit with the program (Skeptic note)

This is the honest conditional form of the doubling tension: locally the HNU node
carries `+1`; IF one imposes a finite zero-total LOCAL crossing-charge ledger (the
naive anomaly-cancellation premise), a distinct nondegenerate partner is FORCED.
Crucially it does NOT claim the HNU regulator itself satisfies that premise - the
whole point of the anomalous-Floquet route (and my synthesis) is that HNU's single
Weyl EVADES local charge balance by carrying the compensation in the full-Floquet
winding, not a second local crossing. This module correctly stays conditional and
leaves that escape intact.

## Bottom line

APPROVE. A precise, non-vacuous, conditional local-to-global partner theorem:
zero-total local charge (displayed, load-bearing, satisfiable) forces a distinct
nondegenerate partner to the `+1` HNU node; no convention mismatch (both det-sign),
no hidden assumptions, correctly conditional (not an unconditional doubling claim).
Targeted build green.
