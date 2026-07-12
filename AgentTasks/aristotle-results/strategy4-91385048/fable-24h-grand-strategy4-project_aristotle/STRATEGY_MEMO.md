# STRATEGY MEMO — Grand strategy 4 (Fable lanes, 24h run, T+5h)

**Mode:** REVIEW-ONLY. No Lean sources in packet; audit is of prose vs. the
manuscripts' *own* status marks (calibration), not kernel truth.

**Inputs audited:**
- `context/Null_Edge_Finite_CAR_Dynamics_Draft_2026-07-12.tex` (Paper E skeleton)
- `context/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex` (FB manuscript)

Trust labels used below match the drafts' own: **Kernel** (kernel-checked,
build-guarded), **Kernel+Eval**, **oracle-exact** (computed, not formalized),
**PENDING** (harvest not landed), **prose-only**.

---

## Q1 — PAPER E hostile referee read (Thirring-QCA / Mlodinow–Brun lens)

### (a) Five highest-risk sentences, verbatim, with one-line fixes

**E-1 (calibration failure — indicative claim over a PENDING mark).**
> "On an explicit four-site ring at the Pythagorean kick, the composed step's
> two-particle spectrum is exactly characterized: … twelve interaction-shifted
> quasienergies given in closed algebraic form by a rational cubic in
> $2\cos2\varepsilon$ [PENDING: harvest of the spectrum-fixture formalization]."

The verb "is exactly characterized" is indicative, but the *same sentence*
carries a PENDING bracket. A referee reads the bracket as "not done."
**Fix:** demote to "is computed (oracle-exact) to be …; a kernel formalization
of this factorization is the paper's pending flagship (§4)," and delete the raw
`[PENDING …]` token from the abstract — internal marks must not survive into
reader-facing text.

**E-2 (unlicensed adjective — "gauge-invariant").**
> "A gauge-invariant operational discriminator --- return probability $4/5$
> versus $1$ for equal-modulus conjugate fields at the displayed fixtures
> $z=3+4\ii$ and $z=5$ --- shows the interacting sector retains the Pluecker
> phase."

Two problems: "gauge-invariant" is asserted with no invariance theorem cited
(the landed object is `PlueckerPhaseObservable`, a return probability in a fixed
convention), and "retains the Pluecker phase" is an interpretation, not a proved
property. **Fix:** "A convention-fixed operational discriminator — return
probability $4/5$ vs. $1$ at $z=3+4\ii$ vs. $z=5$ — separates the two
equal-modulus conjugate fixtures, consistent with phase retention"
(drop "gauge-invariant"; downgrade "shows … retains" to "consistent with").

**E-3 (nonexistence overclaim from one commutator).**
> "$[H_{\mathrm{free}},K(z)]\neq0$ exactly (norm $5$ at the four-mode line
> witness; run record), so no Trotter-free factorization of a combined
> exponential exists; …"

A single nonzero commutator shows the layers do not *share* an exponential; it
does not prove "no Trotter-free factorization … exists" (a universal
nonexistence). Also this rests on a "run record," tagged "[Oracle-grade;
formalization optional.]" — not Kernel. **Fix:** "so the free and kick layers
do not exponentiate jointly, and we *define* the automaton by alternation, as in
the Thirring-QCA convention" (drop the universal nonexistence claim; keep the
oracle tag on the commutator).

**E-4 (eigenvector overclaim — the "and does"; see (c)).**
> "so the composed automaton has no exact momentum decomposition and the
> interaction can, and does, recruit levels from every sector."

"has no exact momentum decomposition" is licensed (nonzero cross-sector
commutator $3\ii/5$); "and does … recruit levels from every sector" is an
eigenvector-support claim not established by the cited facts. **Fix:** see (c)
for exact replacement wording.

**E-5 (abstract states a non-Kernel fact without a status tag).**
> "There is no free/interaction exponential splitting: $[H_{\mathrm{free}},K]\neq0$
> exactly, so the composed automaton is defined, as in the interacting
> cellular-automaton literature, by alternating the free minor-lift with the
> kick layer."

The abstract of a kernel-branded paper asserts $[H_{\mathrm{free}},K]\neq0$ as
flat fact, but the only support is the oracle "run record" of the Remark. Either
formalize the commutator (cheap: it is a finite $28\times28$ entry check) or
tag it. **Fix:** "the free and kick layers do not commute (four-mode witness,
oracle-exact), so the automaton is defined by alternation" — and formalize the
commutator before freeze; it is the smallest kernel win that de-risks E-3/E-4/E-5
at once.

### (b) Is the PENDING-slot architecture honest if boundstate lands but halfcharge2 does not?

**As an internal skeleton: yes. As a submission draft: not in its current
wording.** Three conditions decide it:

1. **Every reader-facing claim tied to an unlanded harvest must be in the
   subjunctive/oracle-labeled, not the indicative.** Right now the abstract
   fails this (E-1, E-5). Fix those and the skeleton is honest about what is
   proved.
2. **Raw internal tokens (`[PENDING …]`, `[Oracle-grade; formalization
   optional.]`, "run record") must not appear in the submitted body.** They are
   scaffolding; a referee treats a PENDING bracket in the abstract as a missing
   result and the whole paper as premature. Convert each to either a landed
   Kernel citation or an explicit "conjectured/oracle-computed" sentence.
3. **Map `halfcharge2` to the exact reader-facing claim it backs, and confirm
   nothing indicative depends on it.** In the current draft the operational
   discriminator (§5) already stands on `PlueckerPhaseObservable` (**Kernel**),
   so if `halfcharge2` is the strengthening of that observable, its non-landing
   leaves §5 at its present (already-proved) strength and does **not** block
   submission — it just means §5 is not upgraded. If instead `halfcharge2`
   backs a claim stated in the indicative anywhere, that claim must be demoted
   until it lands. **Action:** add a one-line "what this harvest fills" note per
   PENDING slot so the dependency is auditable; do not submit until each PENDING
   maps to a Kernel citation or an honest conjecture line.

Net: boundstate filling §4 (spectrum) is the load-bearing harvest; halfcharge2
is a secondary upgrade. The architecture survives halfcharge2 slipping **iff**
the abstract/body are rewritten so no indicative claim rides on it.

### (c) Does the momentum-table paragraph overclaim? Is "and does" licensed?

**"can" is licensed; "and does … recruit levels from every sector" is not.**

The cited evidence is: (i) a momentum-neutral support fact
$|P_K\,e_{01}|^2=1/4$ (one seed vector spreads equally over the four sectors);
(ii) a nonzero cross-sector commutator entry $3\ii/5$ (kick breaks translation);
(iii) $\mathrm{charpoly}(U_2)=$ monic block product (a factor-multiset trade).

These establish that the kick **can** couple sectors (nonzero off-block matrix
elements) and that no exact momentum grading survives. They do **not**
establish that the *interacting eigenvectors* actually have support in every
sector, nor that every one of the twelve shifted quasienergies "draws from"
every sector. That is an eigenvector-support / participation statement, and it
requires eigenvector tracking of the composed step $U_2$ — which the draft's own
tags say is oracle-exact/PENDING, not proved. The equal weight of a *single*
seed vector $e_{01}$ is not the same as every interacting level recruiting from
every sector.

**Exact replacement wording:**
> "so the composed automaton admits no exact momentum decomposition: the kick has
> nonzero matrix elements between distinct momentum sectors (explicit entry
> $3\ii/5$) and weights the four sectors equally on the seed state
> ($|P_K\,e_{01}|^2=1/4$). Whether every interacting quasienergy draws support
> from every sector is an eigenvector-participation question we do not resolve
> here."

If eigenvector participation is in fact computed by the oracle, replace the last
sentence with "the oracle-computed eigenvectors have nonzero support in all four
sectors (oracle-exact; formalization in flight)" — but only with that explicit
tag, never as bare indicative.

### (d) Venue fit and single most valuable missing theorem

**Venue.** The physics content (exact interacting two-particle spectrum, exact
circuit-locality cones, phase discriminator) sits squarely in the
Thirring-QCA / interacting-QCA line — natural homes are **Quantum** or
**Phys. Rev. A** (where the Thirring QCA and Mlodinow–Brun appeared). But the
*selling point* is machine-checked exactness, which PRA referees will not weight.
Recommendation: target **Quantum** (receptive to both the QCA physics and the
"exact, kernel-verified" framing), with a formal-methods cut (ITP/CPP) in
reserve if the formalization is to be the headline. Do **not** lead with the Lean
angle at PRA.

**Single most valuable missing theorem.** The **kernel-checked exact
two-particle spectrum factorization** on the $L=4$ ring — the palindromic
degree-12 factor with quasienergies solving
$3125w^3-2300w^2-6156w-1440=0$, $w=2\cos2\varepsilon$. This is the paper's
headline and it is currently oracle-only/PENDING; without it, E reduces to
"generator + locality cones + a two-point discriminator," which a QCA referee
will find thin against the perturbative Thirring-QCA results already published.
This theorem is exactly the **boundstate** job already in flight (§Q3), so the
priority is correctly placed — do not open a new job for it. Second-best, and
nearly free: formalize $[H_{\mathrm{free}},K]\neq0$ (a finite entry check) to
retire E-3/E-4/E-5's reliance on a "run record."

---

## Q2 — FB MANUSCRIPT hostile read (Furey / Baez–Schwahn / Boyle lens)

### (a) Five highest-risk sentences, verbatim, with one-line fixes

**FB-1 (universal soundness claim, only flagships build-enforced).**
> "every theorem cited below carries the standard Mathlib logical footprint
> (propext, Classical.choice, Quot.sound) and nothing else"

The provenance note says non-flagship theorems were checked "against its module
docstring … on the day of writing," while only four flagships carry
*build-enforced* guards. "every theorem … and nothing else" is a universal
soundness assertion whose enforcement is a one-time manual `#print axioms`, not
CI. **Fix:** "the flagship theorems are build-guarded to this footprint
(`Furey.AxiomGuard`); every other cited theorem was checked to the same
footprint at time of writing" — distinguish enforced from checked-once.

**FB-2 (monoid-equivalence vs. group-isomorphism ambiguity).**
> "a multiplicative equivalence onto the submonoid that is proved *equal* to
> Mathlib's `Matrix.specialUnitaryGroup (Fin 3) C`."

Abstract says "multiplicatively equivalent to $SU(3)$"; theorem says "$\simeq^*$
onto the *submonoid*." If $\mathrm{Aut}_{e_{111}}(\OO)$ is a group and the map is
a bijective homomorphism onto $SU(3)$, this is a *group* isomorphism; the
"submonoid / multiplicative equivalence" hedging invites the reader to suspect
the inverse/group structure was not packaged. **Fix:** state precisely — "a
group isomorphism onto `specialUnitaryGroup (Fin 3) C`" if the inverse is
proved; otherwise "a bijective monoid homomorphism (group-inverse packaging
open)." Do not straddle.

**FB-3 (causal "forces" over a one-line justification).**
> "(ii) valued in determinant-one unitaries --- the octonion relation
> $e_{001}e_{010} = e_{011}$ forces $\det = 1$;"

"forces" asserts a determinant consequence from a single structure constant with
no visible argument. A division-algebra referee will want the step. **Fix:**
"…the multiplicativity constraint from $e_{001}e_{010}=e_{011}$ pins $\det=1$
(`G2FixingE111DetOne`)" — cite the lemma rather than assert "forces."

**FB-4 (aspirational module name cited as Kernel; name mismatch on the page).**
> "`DVTTwoSidedStabilizerMoonshoot` for the faithful quotient action[^fn]"
> [^fn]: "Module name as in the repository: `DVTTwoSidedStabilizerMoonshot`."

A flagship-adjacent result cited by a name containing "Moonshot," plus a
body/repo spelling mismatch ("Moonsho**o**t" vs "Moonshot"), is an auditor red
flag: "moonshot" reads as aspirational/incomplete and the mismatch reads as
untraceable. **Fix:** rename the module to a descriptive, non-aspirational name
(e.g. `DVTTwoSidedFaithfulQuotientAction`) and quote it identically in prose and
repo; never let a "moonshot"-named decl carry a Kernel tag without reconciliation.

**FB-5 (capstone name/verb risks reading as derivation).**
> "the all-left table, completed by the conventional right-handed singlets, is
> exactly the anomaly-free `standardModelOneGeneration`." (theorem
> `fureyRealizesOneGenerationPackage`)

The boundary is recorded (the `ClaimBoundary` field flags the right-handed
sector as conventional input), but the verb "realizes"/"completed … is exactly"
is the single most quotable-out-of-context line for a "they claim to derive a
generation" attack. **Fix:** rename to `fureyMatchesOneGenerationPackage` and
phrase "matches, once the conventional right-handed singlets are appended, the
anomaly-free `standardModelOneGeneration`" — "matches," not "realizes."

### (b) Does the Jordan–Clifford bridge section keep the mandatory semantic boundaries?

**Yes — all five boundaries are explicitly maintained. No sentence slips.**
The load-bearing disclaimers are present and correctly scoped:

1. *rep conjugacy ≠ particle–antiparticle:* "that identification is an
   interpretive postulate of the construction, not a theorem --- representation
   conjugacy and physical antiparticle conjugation must not be conflated." ✔
2. *idempotent ≠ QFT vacuum:* "the primitive idempotent that plays the role of a
   vacuum is an algebraic idempotent, not the QFT vacuum state." ✔
3. *degree ≠ compositeness:* "occupation degree is an algebraic grading; it
   carries no claim that leptons are composites of quarks or similar." ✔
4. *empty/full ≠ weak doublet:* "nothing at this level makes the empty and full
   states a weak doublet; weak structure enters separately …" ✔
5. *EW operators = consistent construction, not derivation:* "The $W^\pm$
   operators are *defined* as explicit basis-state permutation maps and then
   proved to satisfy the $\su(2)$ relations; they are not constructed from the
   $\alpha_i$ ladder algebra." ✔

**Closest-to-the-line (no slip, but tighten):** the capstone verb "realizes"
(FB-5) and the master-question rungs, e.g. "one chiral generation as
$\Lambda^{\mathrm{even}}(W\oplus V)$" — these are correctly inside the *open*
rung list and the section closes with the honest hygiene line "Nothing in this
section uses any null-edge result as evidence," and the kill conditions are
stated in advance. That framing is exactly right; keep it. The only action is
the FB-5 rename so the boundary is carried in the *name*, not only the docstring.

### (c) Is the Baez–Schwahn boundary remark stated accurately (per the manuscript's own source-audit quotes)?

**Structurally honest and the load-bearing subtlety is correctly flagged; two
internal-consistency nits to reconcile before freeze.** (These are calibration
checks against the manuscript's own quotes — I do not have BS2026 to adjudicate.)

- **Correct and well-drawn:** the three-part split
  (*Kernel-checked here* / *external, source-verified, not formalized* / *open*)
  is the right honesty structure; and the sentence
  > "the identity-component subscript is load-bearing, since $\mathrm{Stab}(B)$
  > has a second, antiunitary component"

  correctly warns that $\mathrm{Stab}(B)_0 \cong (SU(3)\times SU(3))/\Z_3$
  (their Lemma 4) must not be inflated to all of $\mathrm{Stab}(B)$. Good.

- **Nit 1 — op vs. non-op notation.** The manuscript's own Theorem
  (`thm:dvt`) uses $(SU(3)\times SU(3)^{\mathrm{op}})/\Z_3$, while the BS quote
  uses $(SU(3)\times SU(3))/\Z_3$. These agree as abstract groups
  ($SU(3)^{\mathrm{op}}\cong SU(3)$ via $g\mapsto\bar g$) and the "op" is exactly
  why the right action $X\mapsto AXB$ appears — but a referee will see a
  mismatch. **Reconcile explicitly** in one clause ("$SU(3)^{\mathrm{op}}\cong
  SU(3)$; the op records the right action").

- **Nit 2 — potential double-counting of the "second factor."** The remark says
  the kernel-checked coordinate avatars are `thm:su3` (the automorphism $SU(3)$)
  *together with* `thm:dvt`, "which is their second factor." But `thm:dvt`
  *already* is the full two-sided $(SU(3)\times SU(3)^{\mathrm{op}})/\Z_3$, i.e.
  contains *both* $SU(3)$ factors. Calling `thm:su3` additionally "their second
  factor" is ambiguous: is the octonion-automorphism $SU(3)$ *identified with*
  one of the two matrix factors inside `thm:dvt`, or is it an independent third
  $SU(3)$? **Clarify** which coordinate $SU(3)$ (automorphism vs. left-matrix vs.
  right-matrix) plays which role, so the "avatar" correspondence is
  unambiguous.

Both nits are wording/consistency, not proof gaps; fix in prose before freeze.

### (d) Venue fit and the one structural change with best value

**Venue.** The paper explicitly disclaims physical derivation ("Nothing here
derives the Standard Model"), so a physics-novelty venue (**J. Phys. A**) is a
weak fit — referees will ask for the physics it declines to claim. Best fits, in
order: (1) **arXiv-first**, then (2) a **formal-methods venue** (ITP / CPP /
JAR) or **Annals of Formalized Mathematics** (the outline's stated primary),
where a verified, convention-explicit audit trail *is* the contribution;
(3) **Adv. Appl. Clifford Algebras** among math-physics options, as the most
receptive to octonion/Clifford SM structure and to the convention-bridge
methodology. Recommendation: arXiv-first + Annals of Formalized Mathematics
(or AACA if a physics-community readership is wanted), not J. Phys. A.

**One structural change, best value.** Land open rung (i) — the
**whole-submodule operator intertwiner** — before submission, i.e. bundle the
left-multiplications as endomorphisms of the ideal and prove a linear-operator
intertwining theorem with $\Lambda V$, upgrading the "48-entry table agreement"
from a *basis coincidence* to a genuine **module isomorphism**. This is the
manuscript's own nominated "decisive next theorem," and it is the difference
between "suggestive parallelism" (low novelty for any venue) and a *structural*
bridge result. If it cannot land in the window, the second-best change is
purely editorial: **promote the Jordan–Clifford master question (with its graded
rungs and kill conditions) to the framing spine of the paper**, so the
contribution reads as "verified foundations + sharply-stated open frontier"
rather than a catalog of parallel constructions.

---

## Q3 — Endgame ordering (~16h; landing freeze 08:00; audit 08:00–09:45)

### (a) Remaining moves ranked by expected referee-facing value per hour

No new Lean jobs proposed (none beats the in-flight four on value/hour).

| Rank | Move | ~Cost | Value/hr | Why |
|---|---|---|---|---|
| 1 | **Apply the prose calibration fixes** (E-1…E-5, FB-1…FB-5; §c nits) | minutes–1h | **Highest** | Retires the exact sentences a hostile referee quotes; makes the scorecard honest; un-gameable and near-free. Do first. |
| 2 | **boundstate** harvest (E §4 spectrum cubic) | ~4h, 33%→ | High | Fills E's *headline* Kernel slot; converts E-1's PENDING to Kernel. Already actively proving. |
| 3 | **momentum** formalization | med | Med–High | Oracle→Kernel on the exact paragraph flagged in Q1(c)/(d); de-risks E's riskiest section. |
| 4 | **census** (C certificates) | med | Med | C is already freeze-grade; strengthens but marginal referee-facing gain. |
| 5 | **halfcharge2** | ~5h | Lowest | Longest/riskiest, secondary slot; acceptable to leave honestly PENDING if it does not land (see Q1b). |
| — | **HONEST_SCORECARD.md + FINAL_REPORT.md + verifier ×2** | 08:00–09:45 | Mandatory | Audit-phase deliverable, not optional; hard-scheduled. |

Sequencing note: the four Lean jobs run in parallel, so the real scheduling
lever is *attention and the 08:00 gate*. Do move #1 immediately (it also fixes
what the scorecard must reflect). Keep boundstate as the watched job; treat
halfcharge2 as best-effort with a pre-written honest-PENDING scorecard row so a
non-landing costs nothing at freeze. Freeze prose at 08:00 regardless of
halfcharge2.

### (b) HONEST_SCORECARD.md skeleton (fast + un-gameable)

One row per **claim** (every flagship across A, C, E, FB). Columns:

| Column | Content | Un-gameable because |
|---|---|---|
| `Claim ID` | stable id (e.g. `E-SPEC`, `FB-SU3`) | lets FINAL_REPORT/verifier cross-reference |
| `Claim (1 line)` | the mathematical statement in words | forces a human-readable target to diff against |
| `Manuscript anchor` | paper + §/theorem number | ties prose to the row |
| `Lean decl(s)` | fully-qualified decl name(s) | **a row with no decl name is prose-only by definition** |
| `Kernel status` | `kernel-clean` / `PENDING-harvest` / `oracle-exact` / `prose-only` / `external` | the only column that may say "done" |
| `Axiom footprint` | `standard` / `native_decide` / `new-axiom` | catches evasion (Trap 2) |
| `Guard pin` | build-guard name or `none` | separates *enforced* from *checked-once* (FB-1) |
| `Oracle tag` | `oracle-exact (unformalized)` or `n/a` | forbids oracle rows from claiming kernel |
| `Known gaps / boundary` | `ClaimBoundary` field / open rung / "—" | surfaces the recorded gap next to the claim |
| `Last verified` | commit hash + timestamp | morning audit re-runs verifier and diffs this |

**Rules baked into the skeleton (so the morning audit is mechanical):**
- A cell in `Kernel status` = `kernel-clean` is **invalid unless** `Lean decl(s)`
  is non-empty AND `Axiom footprint` = `standard`.
- Any claim stated in the *indicative* in either manuscript must map to a row
  with `Kernel status = kernel-clean`; otherwise the manuscript sentence must be
  subjunctive/oracle-labeled. (This is the E-1/E-5 test.)
- `oracle-exact` and `PENDING-harvest` rows are rendered in a visually distinct
  block and may never appear as "done" in FINAL_REPORT.
- Top of file: a `Verifier run` header with the two commit hashes + times from
  the double run, so the two runs must agree.

### (c) Two most likely "manufactured completion" traps in the final 16h, and the check that defeats each

**Trap 1 — Status drift / prose promotion.** As the boundstate/momentum
harvests are "expected," an oracle-computed or PENDING result gets written in the
indicative in abstract/body before the kernel proof actually lands (E-1 and E-5
already do this in the current draft). The paper then *reads* done while a slot
is empty. Companion-paper shuffling ("moved to companion, in flight") is the same
trap wearing a citation.
**Check that defeats it:** a mechanical claim↔scorecard cross-diff — extract
every indicative claim sentence from both `.tex` files and require each to map to
a scorecard row with `Kernel status = kernel-clean`; fail the audit if any
indicative claim maps to a `PENDING`/`oracle-exact`/`external` row or to no row.
Companion references must resolve to a specific decl or be tagged `external`.

**Trap 2 — Guard / axiom evasion and silent statement-weakening.** A proof
"lands" but (i) hides a `sorry`/`admit` inside a `have`/`let`, or leaks
`native_decide`/a new `axiom` upstream of a decl whose `#print axioms` guard is
**not** among the four flagships (FB-1's universal footprint claim is exactly the
soft spot); or (ii) the *statement* is quietly weakened — a hypothesis added that
makes it vacuous, a `: True`, or a rename (the `Moonshot`/`Moonshoot`
decl and the `≃*`-onto-submonoid wording are prime spots) — so a true-but-empty
theorem passes.
**Check that defeats it, two parts:** (a) in the double verifier run, execute
`#print axioms` on **every** scorecard `kernel-clean` decl (not just the four
guarded flagships) and repo-wide `grep` for `sorry`/`admit`/`native_decide`/
`axiom`; any non-standard footprint or hit fails the audit. (b) statement-
integrity diff — compare each cited theorem's *current* statement against its
scorecard one-line claim **and** against the previous freeze commit, to catch
silent weakening/renaming; require the guarded flagships' `#guard_msgs` blocks to
be unchanged.

*(Third, lower-probability trap worth a one-line guard: "companion shuffle" —
covered by Trap 1's external-tag rule.)*

---

## One-paragraph bottom line

Both drafts are *architecturally* honest — E marks its PENDING slots, FB keeps
all five semantic boundaries and splits BS2026 into kernel/external/open. The
residual risk is **calibration leakage into reader-facing text**: E's abstract
states pending/oracle results in the indicative (E-1, E-5) and over-labels the
discriminator (E-2) and the momentum recruitment (E-4/Q1c); FB makes one
universal soundness claim that only four guards enforce (FB-1) and carries a
straddled `≃*`/submonoid wording (FB-2) plus an aspirational, mismatched decl
name (FB-4). All are minutes-cost prose fixes and should be move #1 of the
endgame. The one substantive Lean win that most raises referee-facing value is
already in flight (boundstate = E's headline spectrum theorem); the one FB
structural upgrade worth attempting is open rung (i), the ΛV operator
intertwiner. Freeze prose at 08:00; drive the audit off a scorecard whose
`kernel-clean` rows are invalid without a named decl and a standard axiom
footprint.
