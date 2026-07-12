# FREEZE_CHECK.md — final go/no-go pass (review-only)

Scope: last pass before 08:00 freeze. Papers A (`Null_Edge_From_Area_to_Dirac_Gap`),
E (`Null_Edge_Finite_CAR_Dynamics`), FB (`Furey_Baez_Octonion_SM_Formalization`),
plus `HONEST_SCORECARD.md` and `FINAL_REPORT.md`. Terse; quotes verbatim.

## Bottom line (go / no-go)

| Artifact | Verdict | Single blocking fix |
| --- | --- | --- |
| Paper A | **GO** | none blocking (minor polish only) |
| Paper E | **NO-GO** | Abstract calls the Section 4 charpoly flagship `oracle-exact` / `pending flagship`, but the body, scorecard, and FINAL_REPORT all mark it **landed (Kernel + Kernel+Eval)**. Reconcile the abstract to the landed body. |
| Paper FB | **GO** | none blocking |
| HONEST_SCORECARD.md | GO (as an audit worksheet; most cells still blank by design) | — |
| FINAL_REPORT.md | **NO-GO** | Its "Honest remaining gates" / "Active external jobs" list `fbgroupiso`, `flowinstance`, `covfull` as OPEN/RUNNING while the scorecard marks all three **LANDED 07-12**. Reconcile before freeze. |

---

## (1) Abstract adjective vs body trust marks — any survivor broader than the body?

**Paper A — CLEAN.** Every strong abstract adjective is backed by a point-of-use
mark in the body, and the abstract carries the blanket disclaimer
"Every finite statement above carries the trust mark stated at its point of use
--- kernel, compiled evaluator, or exact run record --- and unmarked prose is
interpretation". Spot-checks all hold at the body's grade:
- "machine-checked from the walk symbol at all eight nodes" → body: "kernel-checked for all eight nodes" (§ eight-node census). OK.
- "A pre-registered floating-point high-momentum benchmark (a regression check, not part of the verified chain)" → body: "the Lean identities, not the benchmark, carry the proof." Explicitly *de*-scoped. OK.
- selection "not chosen but forced ... (the dynamical walk commutant remaining open)" → matches scorecard A-FORCE (static scope disclosed in-abstract). OK.
No abstract adjective found broader than its body mark.

**Paper E — SURVIVOR, but in the *conservative* direction (still a contradiction; see (4)).**
The abstract *under*-marks the flagship rather than over-marks it:
- (l.61–62) "the composed step's two-particle spectrum is computed exactly (oracle-exact)"
- (l.65) "the kernel formalization of this factorization is the paper's pending flagship (Section~4)."

Body §4 contradicts both: "the characteristic polynomial of the composed step
\emph{is} the displayed product" and "The polynomial-identity, structural-charpoly,
and pinned-mode steps are kernel; the twin-matrix arithmetic identities run
`native_decide` ... (compiled-evaluator trust)". So no *over*-broad survivor, but
a live abstract/body inconsistency (§4 below). Everything else in the E abstract
(`oracle-exact` for the free/kick commutator l.57, l.142; Kernel for generator,
cones, discriminator) matches the body exactly.

**Paper FB — CLEAN.** Abstract: "flagship theorems kernel-checked under
build-enforced axiom guards and the remaining cited theorems checked to the
standard axiom footprint by reproducible `#print axioms` queries." Body confirms
and, crucially, is *not* narrower than the abstract lets on: "none of the results
cited in this paper use compiler-trusting evaluation (`native_decide`)". The one
place the abstract could over-reach — the SU(3) claim — is pre-hedged verbatim:
"as a `MulEquiv` onto a submonoid proved equal to Mathlib's
`Matrix.specialUnitaryGroup`; this is not a theorem about the smooth Lie group
$G_2=\mathrm{Aut}(\mathbb{O})$". No survivor.

## (2) Scorecard ↔ manuscripts cross-check (orphans, both directions)

- **Scorecard → paper:** each `kernel-clean` / `LANDED` A-row (A-FORCE, A-CARBLOCK,
  A-8NODE, A-RESTGEN, A-SELECT) has a matching in-paper claim at the right grade
  (forced selection; "the CAR-to-block reduction is itself a kernel theorem";
  eight-node "machine-checked"; generalized $B_w^3=\mu^2B_w$; block-level selection).
  FB rows (FB-SU3, FB-GROUPISO, FB-DVT, FB-GEN) all appear in the FB body at the
  stated grade — including FB-GROUPISO: body "isomorphism, now itself
  kernel-checked (`FBGroupIso`)". No A/FB orphan.
- **Paper → scorecard, reverse orphan (E):** scorecard **E-SPEC "LANDED 07-12"**
  and E body §4 (kernel) both say landed, but the **E abstract still says
  `pending flagship` / `oracle-exact`.** This is a scorecard-vs-abstract orphan:
  a row graded landed whose own paper's abstract denies it. Fix in the abstract.
- **E-HALF, E-COMM:** scorecard `HONEST-PENDING` / `oracle-exact` with "no
  indicative claim rides on it" — consistent; abstract makes no half-charge claim
  and labels the commutator `oracle-exact`. No orphan.

## (3) FINAL_REPORT internal consistency / "looks stronger than it is"

- **NO-GO staleness (blocking).** The report's own honesty section is stale
  against the scorecard:
  - l.88–90 "remaining gates ... FB group-iso [fbgroupiso]; flow-count concrete
    instance [flowinstance]; ... covariance full group [covfull]"
  - l.105 "fbgroupiso ... — RUNNING", l.103 "flowinstance ... — RUNNING",
    l.106 "covfull ... — RUNNING"
  vs scorecard: FB-GROUPISO "kernel-clean; LANDED 07-12"; P-1DFLOW-R1
  "concrete-walk instance NOW LANDED (FlowOneInstance ...)"; A-FORCE "FULL
  covariance group both cosets (CovarianceGroupFull) ... LANDED 07-12". Three
  results are simultaneously "landed" (scorecard) and "open/RUNNING" (report).
  (`momtwin` is *not* in this bucket: scorecard E-MOM is landed at Kernel+Eval and
  the report gate is the still-open kernel-clean *retrofit* — consistent.)
- **Minor "looks stronger" (non-blocking).** Executive result item 3
  ("The interacting two-particle spectrum of the finite fermionic walk is exact ...")
  drops both the `L=4` fixture scope and the Kernel+Eval-on-twin caveat that the
  landed-theorems table row restores. Recommend adding "(L=4 ring; twin-arithmetic
  layer eval-trusted)" to the exec bullet. Item 1 similarly compresses "forced by
  covariance" without the "(static; dynamical commutant open)" tag the table carries.

## (4) Internal contradictions / fixture-as-universal / load-bearing definitional boundary

- **Contradiction (E, blocking):** charpoly flagship "pending/oracle-exact"
  (abstract l.61–65) vs "is the displayed product ... kernel" (body §4) vs
  "charpoly identification closed" (FINAL_REPORT table) vs "LANDED 07-12"
  (scorecard E-SPEC). Note the E title itself already says "an exact interacting
  spectrum" — only the abstract lags. Fix: one abstract edit.
- **Contradiction (cross-doc, blocking):** `fbgroupiso` / `flowinstance` /
  `covfull` = landed (scorecard) and open (FINAL_REPORT) — see (3).
- **Fixture-scoped dressed as universal:** none found. E is explicitly scoped
  ("On an explicit four-site ring at the Pythagorean kick"; "the spectrum fixture
  is $L=4$"). A's eight-node census is the full node set of the named 3+1 walk, not
  a fixture generalized. Only soft spot is FINAL_REPORT exec item 3 (item (3) above).
- **Definitional boundary carrying weight — disclosed, not hidden:**
  - E: the "integer twin" vs "physical matrix" boundary is load-bearing for the
    charpoly, but disclosed via "the faithfulness identity $B_zK_z=5V_z$ ... ties
    the integer twin to the physical matrix" and "this layer is eval-trusted and
    about the twin rather than a kernel proof of the actual-field operator." OK.
  - FB: "algebraically defined automorphism group" vs smooth $G_2$ — the definitional
    boundary is stated three times (abstract, §, closing). Not hidden. OK.
  - A: "no second mass parameter" vs "not eliminating a free scale" — reconciled
    in-abstract as an honest reparametrization ("trading the scalar mass input for
    the spinor input"). Borderline but self-corrected; OK.

## Freeze actions (ordered)

1. **E abstract (blocking):** replace "computed exactly (oracle-exact)" and
   "the kernel formalization ... is the paper's pending flagship (Section~4)" with
   the landed grade actually in §4 (kernel factorization/structural-charpoly/
   pinned modes + Kernel+Eval twin arithmetic). Also clear the stale "PENDING
   harvest" header comment and the "[PENDING: ...]" appendix stub if §4 is frozen.
2. **FINAL_REPORT (blocking):** move `fbgroupiso`, `flowinstance`, `covfull` out
   of "Honest remaining gates" and out of "Active external jobs (RUNNING)" to
   landed, matching the scorecard; keep `momtwin` (kernel-clean retrofit) and the
   genuinely open theorem gates (A dynamical commutant; E participation) as open.
3. **FINAL_REPORT (polish):** add the `L=4` + eval-twin caveat to exec item 3 and
   the "(static)" tag to exec item 1.
4. **Paper A:** clean as an honest artifact — go.
5. **Paper FB:** clean as an honest artifact — go.

Assessment basis: abstracts read sentence-by-sentence against bodies; scorecard
rows cross-diffed against both papers and FINAL_REPORT; verbatim quotes above.
This is a go/no-go checklist, not a re-review.
