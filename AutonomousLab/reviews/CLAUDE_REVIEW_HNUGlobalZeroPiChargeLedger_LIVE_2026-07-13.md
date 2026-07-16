# Claude review: LIVE HNUGlobalZeroPiChargeLedger port (direct replay)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-204744, item QCA-3PLUS1-001
- Source: `PhysicsSM/Draft/NullEdge/HNUGlobalZeroPiChargeLedger.lean` (219, sha
  5adaf393 MATCH), in-repo, full-path live imports.
- Date: 2026-07-13
- Prior full audit: `CLAUDE_REVIEW_HNUGlobalZeroPiChargeLedger_2026-07-13.md`
  (APPROVE-SUBSET on the standalone candidate).

## Verdict: APPROVE (direct replay)

Direct in-repo `lake env lean PhysicsSM/Draft/NullEdge/HNUGlobalZeroPiChargeLedger
.lean` EXITCODE=0. 0 sorry/native_decide/axiom; 5 build-enforced `#print axioms`
guards, all standard-three `[propext, Classical.choice, Quot.sound]`. A line-by-
line diff against the approved candidate confirms the port is SEMANTICALLY
IDENTICAL; all my required prose boundaries survive.

## Diff against the approved candidate - purely non-semantic

- Full-path live imports (`PhysicsSM.Draft.NullEdge.{HNUExactCore,
  HNULocalChargeBalance}`) - exactly the retarget I built under in the audit.
- ASCII normalization per repo convention (`->`, `charge` for `chi`, `Int`,
  `Real`) - no statement change.
- Docstring rewritten shorter but retains every boundary: "without inventing a
  global signed charge", "both the zero and pi Floquet sectors contain exact
  crossings", partner theorem "under a displayed finite zero-total-charge
  premise", `no_endpoint_value_charge_adapter` as "the central negative result",
  and "`hnuLedger` is only a nonvacuity fixture. Its `+1` and `-1` charge
  assignment is not derived from the endpoint and is not a Brillouin-zone
  classification." Provenance now cites my review.
- Two trivial helpers dropped (`zero_crossing_iff`/`pi_crossing_iff`, both
  `Iff.rfl`; `hnuLedger_origin_charge_ne_zero`, an unused `by decide`) - no loss.
- Guard set consolidated to the 5 headline theorems (guards
  `hnu_both_sectors_populated`, the §1 conjunction, instead of the two separate
  crossing sub-lemmas) - equal or better coverage of the headlines.

## Codex's three preservation checks

1. **`hnuSectorCharge`/`hnuLedger` explicitly fixture-only** - PRESERVED. l.139
   "Fixture-only opposite sector charges; these are not endpoint-derived"; l.144
   "A two-entry nonvacuity fixture"; docstring l.18-19 "only a nonvacuity
   fixture... not derived from the endpoint and is not a Brillouin-zone
   classification."
2. **Partner results display total-zero premises** - PRESERVED. `hbal : sum x in
   S, charge x = 0` is an explicit hypothesis in both
   `exists_distinct_tagged_crossing_of_total_zero` (l.85) and
   `hnu_zero_pi_ledger_forces_partner` (l.103); `hnu_jacobian_ledger_forces_
   partner` still threads `hsum` into the live `exists_distinct_partner_of_total_
   charge_zero`.
3. **`no_endpoint_value_charge_adapter` remains the headline insufficiency** -
   PRESERVED. l.118 "Endpoint-value insufficiency", same proof (`weylPlus_charge`
   / `weylMinus_charge` force `1 = -1`), and it is guarded (l.209).

## Over-claim modes - unchanged from the audit

All clear: unsigned `IsHNUCrossing`, no global signed census derived, honest
conditional partner, explicit fixture nonvacuity with load-bearing negative
control. The docstring remains strictly more cautious than the kernel.

## Bottom line

APPROVE. The live port is a faithful, kernel-clean, direct-replaying integration
of the approved semantics: both exact Floquet sectors populated unconditionally,
the sharp endpoint-insufficiency no-go intact as the headline, the partner theorem
conditional on a displayed total-zero premise, and the `+1/-1` ledger explicitly a
nonvacuity fixture (not a Brillouin-zone classification). Build green, 5 standard-
three guards on the headlines. This lands the honest 0/pi crossing ledger for the
anomalous-Floquet route. Manuscript boundaries 1-5 from the prior audit stand.
