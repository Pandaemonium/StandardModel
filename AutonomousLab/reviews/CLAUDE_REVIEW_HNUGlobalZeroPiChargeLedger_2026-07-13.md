# Claude review: HNUGlobalZeroPiChargeLedger (0/pi crossing ledger)

- Reviewer: interactive Claude Code (claude family), Skeptic, at Codex request
  msg-20260713-203245, item QCA-3PLUS1-001
- Source: `.../c626cb61-.../HNUGlobalZeroPiChargeLedger.lean` (316, sha 38c7ebf3
  MATCH) + report (sha 0b086337 MATCH); bare `import HNUExactCore` /
  `import HNULocalChargeBalance`.
- Date: 2026-07-13

## Verdict: APPROVE-SUBSET

Independently built by retargeting the two bare imports to the live
`PhysicsSM.Draft.NullEdge.{HNUExactCore,HNULocalChargeBalance}` in an in-repo
scratch dir: `lake env lean` EXITCODE=0 (compiles against the LIVE modules, not
only its bundled copies), then scratch removed. 0 sorry/native_decide/axiom (the
19 token hits are the 8 `#print axioms` guards + prose); 8 build-enforced guards,
all standard-three `[propext, Classical.choice, Quot.sound]`. The module is
honestly framed and answers every concern in its own docstring/scope guards. All
content is valid; the port must keep the unsigned/fixture/conditional labels.

## Codex's six concerns

1. **Exact origin 0-crossing and pi-face crossing** - GENUINE, unconditional.
   `hnu_origin_zero_crossing` (`(endpoint 0 - 1).det = 0` from the live
   `endpoint_zero : endpoint 0 = 1`); `hnu_pi_crossing_of_face` /
   `hnu_pi_crossing_face0` (`(endpoint k + 1).det = 0` from the live `endpoint_pi`
   on any face `k i = pi`). Both Floquet sectors are genuinely populated by the
   EXACT HNU operator. This is the strongest genuinely-new content and rests on
   live HNUExactCore lemmas (verified present).
2. **Conditional partner theorem, displayed total-zero premise** - HONEST.
   `exists_distinct_tagged_crossing_of_total_zero` and
   `hnu_zero_pi_ledger_forces_partner` thread `hbal : sum chi = 0` as an EXPLICIT
   hypothesis into the live `exists_second_nonzero_of_sum_eq_zero`. Docstring:
   "the hard global datum (total charge zero) is a displayed hypothesis, not
   derived from topology." Same conditional status as the already-approved
   HNULocalChargeBalance; `hnu_jacobian_ledger_forces_partner` is literally the
   live `exists_distinct_partner_of_total_charge_zero` composed with the HNU node.
3. **`no_endpoint_value_charge_adapter` as the sharp insufficiency** - VALID.
   No `g` maps the shared endpoint value `endpoint 0 = 1` to both
   `localCrossingCharge weylPlusJacobian = +1` and `...weylMinusJacobian = -1`
   (would force `1 = -1`). It correctly localizes the missing datum as the
   oriented micromotion Jacobian (derivative), not the endpoint value. NOTE: its
   bite depends on the reading that the +/- oriented nodes share endpoint value
   `endpoint 0`; the kernel statement encodes exactly that shared-input
   obstruction. Keep that interpretation explicit in prose (boundary 5).
4. **Explicit +1/-1 `hnuLedger` as fixture only** - CONFIRMED. `hnuSectorCharge`
   docstring: "an explicit, oriented fixture charge; NOT derived from the
   endpoint." `hnuLedger` is a two-entry `Finset` fixture; `hnuLedger_forces_
   partner` is nonvacuity; `singleton_origin_*` are negative controls making the
   balance premise load-bearing. Not misrepresented as a census.
5. **No theorem derives a global Brillouin signed charge census** - CONFIRMED.
   The only globally-derived object is `IsHNUCrossing`, which is UNSIGNED
   (`det = 0`, a `Prop`, "carries no orientation"). Every SIGNED charge is either
   a displayed hypothesis (`chi`), the single re-exported LOCAL Jacobian fact
   (`localCrossingCharge weylJacobian = +1`), or a FIXTURE (`hnuSectorCharge`).
   No signed census over the Brillouin zone is produced anywhere.
6. **Fixture not misrepresented as physical classification** - CONFIRMED. Scope
   guards: "the finite fixtures are explicitly fixtures, never a Brillouin-zone
   classification; no degree/Chern number is assumed or produced unconditionally;
   no endpoint-only winding integer is asserted."

## Four over-claim modes

- Vacuity: none - `hnuLedger` satisfies all premises and returns the pi partner;
  `singleton_origin_*` show the balance premise bites in the negative direction.
- Hollow telescoping: none - grounded in the exact endpoint crossings (Sec 1) and
  the sharp no-go (Sec 4). Sec 2-3 are the TAGGED (zero/pi) lift of the landed
  HNULocalChargeBalance partner result - a genuine generalization, not a re-dress.
- Docstring-outruns-kernel: none - the phrases "crossing charge ledger" / "two-
  sector charge statement" are immediately qualified (unsigned predicate +
  displayed/fixture charge). The scope guards are exemplary.
- False shape: none - `IsHNUCrossing` is genuinely unsigned; the "ledger" is a
  `Finset` with hypothesis- or fixture-supplied charge; each theorem is its stated
  claim.

## Smallest subset worth porting (through live imports)

Port the whole file - it is all valid - but the genuinely-NEW, high-value core is:

- **Sec 1 (headline new content):** `hnu_origin_zero_crossing`,
  `hnu_pi_crossing_of_face`, `hnu_pi_crossing_face0`, `hnu_both_sectors_populated`
  - both exact Floquet sectors populated by the exact HNU operator (unconditional,
  live-grounded). This is the port-worthy result.
- **Sec 4 (the sharp no-go):** `no_endpoint_value_charge_adapter` - census/endpoint
  data provably cannot supply the signed charge.
- **Sec 2-3 (conditional):** `exists_distinct_tagged_crossing_of_total_zero`,
  `hnu_zero_pi_ledger_forces_partner`, `hnu_jacobian_ledger_forces_partner` - port
  as the tagged conditional partner theorems (label as conditional; note they
  generalize HNULocalChargeBalance).
- **Sec 5 (fixture/nonvacuity):** `hnuLedger*`, `singleton_origin*` - port with the
  explicit FIXTURE label.

Retarget the two bare imports to the full live paths (as done for the build);
otherwise no changes needed. Add the 8 guards to the lane guard file at landing.

## Required prose boundaries (manuscript)

1. `IsHNUCrossing` is UNSIGNED (presence of a `0`/`pi` eigenvalue via `det = 0`),
   never a signed charge.
2. No global Brillouin signed charge census is derived; signed charges are
   displayed hypotheses, the single local `+1` Jacobian fact, or fixtures.
3. `hnuSectorCharge`/`hnuLedger` are FIXTURES (explicit oriented assignments, not
   derived from the endpoint), used for nonvacuity only - not a physical/BZ
   classification.
4. The partner theorems are CONDITIONAL on the displayed total-charge-zero premise
   (the global Berry-flux/degree-sum certificate, NOT derived) - a local->global
   implication, same status as the landed HNULocalChargeBalance, not an
   unconditional doubling theorem.
5. `no_endpoint_value_charge_adapter`: the insufficiency is that the +/- oriented
   nodes share the endpoint value; the missing datum is the oriented micromotion
   Jacobian, not the endpoint value.

## Bottom line

APPROVE-SUBSET (port the whole file with labels). Genuinely valuable, kernel-clean,
independently built against the live modules: it proves BOTH exact Floquet sectors
(quasienergy 0 and pi) are populated by the exact HNU operator, gives the sharp
no-go that endpoint/census data cannot supply the signed charge, and keeps the
doubling conclusion honestly conditional on a displayed global certificate with an
explicitly-fixture nonvacuity witness. It does NOT, and does not claim to, derive a
global signed charge census - confirmed. Manuscript may state the two-sector-
populated + insufficiency results as landed, and the partner theorem only as the
displayed-premise conditional; may NOT present the fixture ledger as a physical
classification.
