# STRATEGY MEMO — Grand strategy 3 (Fable lanes), review-only, T+3.5h

Scope: prose audit of the three manuscripts in `context/`:

- **Paper A** = `Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` (2155 lines)
- **Paper C** = `Null_Edge_HalfWinding_Defect_Paper_Draft_2026-07-11.tex` (484 lines)
- **Paper E (skeleton)** = `Null_Edge_Finite_CAR_Dynamics_Draft_2026-07-12.tex` (159 lines)

This is a text audit only; no Lean modules were inspected (none are present in the packet — `RequestProject/Main.lean` is an empty options preamble). Every verdict below is about the *prose's calibration against its own stated status marks*, not a re-verification of the kernel claims.

---

## Q1 — PAPER A FREEZE AUDIT

Overall the manuscript is unusually claim-disciplined: the reparametrization table, the "what changes physically / what does not" box, the `Classical/New/Kernel/Human/Open` status marks, and the §"Nearest constructions" comparison all pre-empt the obvious referee objections. The residual risk is concentrated in **the abstract**, where several body-level scope qualifiers are dropped or notation is used before definition. The five highest-risk sentences, verbatim, with a one-line fix each:

**R1 — the transported-phase identity, notation-before-definition + abstract/body symbol clash.** (abstract, lines 109–113)
> "for two sites of equal modulus coupled by a chirality-sensitive kinetic edge, `$(H_\chi^2-(m^2+t^2)\id)^2=t^2\,|z_R-e^{-\ii\chi}z_L|^2\,\id$` exactly, so equal-modulus fields with different transported phase have different spectra …"

Risk: `$\chi,t,m,w$` are undefined in the abstract; and the body (line 1863) writes the *same* mismatch as `$\Delta=z_R-(\overline w)^2 z_L$`, i.e. the transport factor is `$(\overline w)^2$` there but `$e^{-\ii\chi}$` here — a referee will read these as two different identities and the `$m$` is only equal-modulus-consistent implicitly.
Fix: state the identity once, with a single transport convention (`$e^{-\ii\chi}\equiv(\overline w)^2$`) and note `$m=|z_L|=|z_R|$`; or drop the displayed formula from the abstract and keep only the "equal-modulus fields with different transported phase have different spectra" sentence.

**R2 — "exactly integrable" for a finite 4-mode gate.** (abstract, lines 118–120; and Paper E Thm 1 title)
> "it equals, up to a global phase, the exact quarter-period pulse of a finite Hermitian even quartic CAR generator whose cube closes (`$K^3=|z|^2K$`), so the one-parameter gate family is exactly integrable"

Risk: to a specialist "exactly integrable" is a term of art (Bethe/QCA integrability); what is actually proved is a closed circle-group law `$U(c_1,s_1)U(c_2,s_2)=U(\dots)$` on one pair block. This is the single most likely over-reading in either A or E.
Fix: replace "so the one-parameter gate family is exactly integrable" with "so the one-parameter gate family closes into an explicit circle group" (reserve "integrable" for the discussion where the group law is stated).

**R3 — the interference corollary reads as universally quantified but is a two-fixture computation.** (intro, lines 291–295)
> "equal-modulus fields with exactly conjugate one-particle rest operators are separated, inside the supplied pair-kick sector, by a double-kick return probability of `$4/5$` versus `$1$`."

Risk: "equal-modulus fields with exactly conjugate one-particle rest operators" is phrased as a class, but the kernel witness is the single pair `$z=3+4\ii$` vs `$z=5$` (the abstract version on line 116 correctly says "at those witnesses"). This is the "native-fixture universality overreach" the packet flags.
Fix: add the scope — "…are separated at the displayed fixtures `$z=3+4\ii$` and `$z=5$`, inside the supplied pair-kick sector, by a return probability of `$4/5$` versus `$1$`."

**R4 — the numeric benchmark sits adjacent to "checked in Lean 4" in the abstract.** (abstract, lines 137–139)
> "A pre-registered high-momentum benchmark passes all alias, body-center, Wilson-gap, and negative-control thresholds. Every finite statement above is checked in Lean~4 …"

Risk: the benchmark is a floating-point simulation (residuals `~10^{-16}`, `Scripts/sim/...`); placing it one sentence before "Every finite statement above is checked in Lean 4" invites a reader to fold the simulation into the verified chain. The body (line 1426) is honest — "identities, not the benchmark, carry the proof" — but the abstract does not carry that disclaimer.
Fix: qualify inline — "A pre-registered floating-point benchmark (regression check, not part of the verified chain) passes all … thresholds."

**R5 — "a corollary constraining the newest published doubler-free constructions".** (intro, lines 228–229)
> "including a corollary constraining the newest published doubler-free constructions"

Risk: "constraining … the newest published" is a datable superlative and "constraining" overstates a precise, narrow result: the Gupta–Short tangent generator cannot be involutory (`$M^2\neq\id$`). The body §(lines 1285–1303) is correctly scoped and even cites their Eqs. (29)–(30),(37); the intro sentence is looser than the theorem it advertises.
Fix: "including a corollary that the Gupta–Short doubler-free tangent generator cannot be involutory."

**Freeze verdict (Paper A): NO-FREEZE as written; FREEZE-GRADE after R1–R5 (all wording-only).** None of the five is a structural/mathematical over-claim — each is an abstract-level scope or notation slip against a body that is already correctly hedged. The core claim discipline is strong: the constant-`$z$` equivalence to the split-step walk is conceded openly (§"exact novelty claim"), the reparametrization table draws the "what a scalar mass cannot mimic" line cleanly, and the interaction/generator is explicitly marked *supplied not derived*. There is **no universality overreach on the derivation chain itself** — the only universality slip is R3 (fixture phrased as a class). The **claim-discipline paragraph** (lines 1895–1908, the three boundaries: no Fredholm/finite-volume index; interaction supplied not derived; everything Lean-checked with pinned axioms and CA-only results tagged elsewhere) is **accurate and matches the body** — keep it verbatim; it is the paper's strongest referee shield. Recommend the fixes land, then freeze for a specialist venue.

---

## Q2 — PAPER C POST-FIX RE-READ

**Abstract iff sentence ↔ `M13/M02_selfadj_iff`: correctly matched.** The abstract's
> "`$M_{13}$` is self-adjoint iff `$(\mathrm{sgn}\,b_0+\mathrm{sgn}\,b_2)\sin\theta=0$`, and mirror-symmetrically for `$M_{02}$`"

is the exact statement carried by `ThetaFamilyCompletion.M13_selfadj_iff` / `M02_selfadj_iff` as cited in Thm (thm:theta) and in the module table. The all-`$\theta$` scope, the "every antisymmetric entry being that single monomial," and the wrong-chart failure being exactly `$-2\sin\theta$` are internally consistent between abstract, Thm (thm:theta), and the verification appendix. The `Wth_eq_landed` transport pin (`$\cos\theta_0=4/5,\sin\theta_0=3/5$` equals the landed rational fixture) is correctly presented as the bridge proving the continuum statements *contain* the fixed-coin results. This is clean.

**One residual wording ambiguity (existence vs. multiplicity), worth a single sentence tightening — not a blocker.** The abstract makes two mode claims in adjacent registers:
- Kernel/atlas: *every* two-wall field's complete walk carries an exact `$+1$` and `$-1$` **eigenvector** (existence), via the two-chart atlas — this is the `$\pm1$`-mode existence result and is kernel-marked.
- Run-record: "Exact computation (exact-arithmetic run record, not yet machine-checked) further decides all 16 complete walks: every two-wall field … carries modes … `$\dim\ker(W\mp\id)=2$` (domain blocks: 4)".

Both use the phrase "carries modes." The kernel result is *existence of one `$\pm1$` mode per sign*; the not-yet-formalized result is the *exact multiplicity* (`$\dim\ker=2$`, blocks 4). A hostile referee will ask which "modes" claim is kernel and which is oracle. The body (lines 213–222) does draw the line — "Mode existence at this size therefore follows wall count; what the positional law classifies exactly is the reach of the reflection-route *certificate*" — so the fix is purely to make the abstract match:
Fix: in the abstract, say "carries exact `$\pm1$` **eigenvectors** (kernel)" for the existence claim and "the exact **multiplicities** `$\dim\ker(W\mp\id)=2$` are decided by exact-arithmetic run record, not yet machine-checked" for the census claim.

**Other over-claim checks — all clear:**
- Determinant-blindness pair, involutive-compression engine, positional law, mirror ill-definedness: each cites a named module with `Kernel`/`Kernel+Eval` marks and the compiled-evaluator trust footprint is disclosed at every rational-fixture use.
- The CGGSVWZ impossibility is *honestly* framed: the theorem quantifies over translation-invariant functions and "no CGGSVWZ index object is itself constructed in the formalization" — the paper does not claim to have formalized Cedzich et al.'s indices, only the translation-orbit separation + the cited translation-invariance. Good.
- The `$\mp2$` second-frame windings are explicitly "transcribed from the exact oracle computation and flagged for source re-verification, not kernel-certified" and quarantined in `CGGSVWZDictionary`. Correct quarantine.
- Eight-site complex-coin witness marked kernel-only; four-site rational instantiations marked compiled-evaluator. Consistent throughout.

**Freeze verdict (Paper C): FREEZE-GRADE.** The 15-finding pass did its job; the only remaining item is the existence-vs-multiplicity wording in the abstract (one edit), which does not change any theorem. Freeze after that one tightening.

---

## Q3 — E ENDGAME (ranking, statement shapes, efforts)

Recommended order: **(a) → (b) → (c)**. Rationale: (a) is the structural payoff that makes the whole spectrum section *mean* something and is the cheapest solid kernel win; (b) is protection insurance for the headline factorization; (c) is a contingency you only fully execute if `halfcharge2` stalls.

**(a) Momentum-block identification theorem — RANK 1 (do first).**
Statement shape: On the 4-site ring, the free minor-lift `$\Gamma(U)$` restricted to the two-particle sector block-diagonalizes under the cyclic momentum `$K\in\Z/4$`; and the sector table is exact:
> `$K=0$` carries all six exact `$\pm1$` modes; `$K=2$` carries the doubled-phase pair; `$K=1,3$` carry the Pythagorean quadruples.

Concretely: exhibit the unitary `$F$` (discrete Fourier on the ring lifted to pairs) with `$F^\dagger\,\Gamma(U)\,F=\bigoplus_{K}\Gamma_K$`, and identify each low-degree factor of the interacting charpoly with a named `$\Gamma_K$` free level. Effort: **moderate, kernel-friendly.** It is a fixed similarity transform plus eigen-identification over `$\Q$`/`$\Q(i)$`/a small cyclotomic field — finite exact linear algebra, no analysis. Highest value because it (i) upgrades "planned structural companion" to a theorem, (ii) gives an *independent* cross-check on (b) (the free factors of the 28×28 charpoly must be exactly the `$\Gamma_K$` levels), and (iii) is oracle-decided already, so the risk is low.

**(b) Independent kernel verification of the 28×28 charpoly factorization — RANK 2 (protection for the headline).**
Statement shape: at the 3-4-5 kick, the composed step's `$28\times28$` two-particle characteristic polynomial factors over `$\Q$` as (unmoved free levels) × (palindromic degree-12), and the degree-12 factor's quasienergies solve `$3125w^3-2300w^2-6156w-1440=0$`, `$w=2\cos2\varepsilon$`.
Effort: **potentially heavy if done by direct `charpoly`; light if done by verified multiplication.** Do **not** ask the kernel to *factor*; ask it to *check a supplied factorization*: provide the explicit degree-12 palindrome `$Q(x)$` and the free-level product `$P(x)$`, prove `$P(x)\cdot Q(x)=\det(xI-M_{28})$` by polynomial identity (this is a `ring`/`decide`-style equality over `$\Q$`, far cheaper than eigenvalue extraction), then separately prove the cubic-in-`$w$` claim by substituting `$w=2\cos2\varepsilon$` and matching. `native_decide` on the 28×28 determinant is a fallback but slower and heavier on the axiom footprint — prefer the "check the product" route so it stays plain-kernel. This is insurance: the spectrum section is a headline and it is currently "[PENDING: harvest]/oracle-exact, formalization in flight."

**(c) `halfcharge2` endgame + minimal publishable cut — RANK 3 (contingency).**
The strategy on record (Gamma identities via site-block factoring on the 16×16, plus rational projection arithmetic) is the right one; keep it running. **If it returns incomplete**, the minimal publishable cut of the window-charge story is:
- Keep: the exact *single-window* half-charge **at the displayed fixture** (one concrete 16×16 instance), stated as an explicit rational projection-trace equality (kernel `decide` on the fixed matrix), plus the qualitative statement that the window charge is a projection trace.
- Demote: any *family-level* or *all-`$\theta$*` window-charge claim to `Open` (or to a run-record "oracle-exact, not yet formalized" tag, quarantined exactly as Paper C quarantines the `$\mp2$` windings).
- Statement shape for the cut: "For the displayed window, `$\tr(P_{\mathrm{win}}\,Q)=\tfrac12$` exactly (kernel), where `$Q$` is the involutive-compression projector; the general-window half-integer law is stated as a conjecture with the site-block-factoring reduction as supporting evidence." This preserves a genuine, defensible half-charge result without hanging the paper on the 3h Gamma-identity job.

---

## Q4 — RUN ENDGAME (highest-value ordering of the remaining ~18h)

With C frozen and E assembling, order the remaining time to (i) lock what is nearly done, (ii) protect the two headline "[PENDING/oracle]" claims in E, then (iii) package A. Suggested sequence:

1. **Land Paper A's five wording fixes (R1–R5) and Paper C's one tightening — ~1h, do immediately.** These are the only things standing between A/C and freeze; they are pure prose and cost almost nothing. Freeze A and C first so the rest of the run is pure upside.

2. **E: momentum-block identification (Q3-a) — ~3–4h.** Cheapest structural theorem, and it doubles as the cross-check for the 28×28 factorization. Do this before (b).

3. **E: verified-product check of the 28×28 factorization (Q3-b) — ~3–4h.** Removes the single biggest "in flight / oracle-exact" liability in E. Use the "check `$P\cdot Q=\det(xI-M)$`" route to keep it plain-kernel.

4. **E: `halfcharge2` — let it finish in the background; if incomplete by ~T+12, take the minimal cut (Q3-c) — ~1–2h to package the cut.** Do not block on it.

5. **Paper A freeze package (artifact manifest, named-author gate, axiom-footprint table) — ~2h.** The manuscript already references an aggregate guard module (`OvernightTheoryAxiomGuard`); the package is assembling the manifest, not new math.

6. **One additional hostile audit, targeted — ~1–2h.** Highest-yield target is *cross-paper consistency*: A's abstract cites C's involutive-compression/positional results and E's generator result as companion facts. Re-read A's companion-citation sentences (abstract lines 84–90, 116–121) against C's and E's actual theorem statements to ensure no drift (e.g. A saying "exact involutive-compression mode mechanism" must match C's existence-vs-multiplicity split from Q2). This is where a referee cross-reading the trilogy will probe.

7. **FB open rungs (your source/prose lanes) — fill remaining slack.** The operator-intertwiner rung is Codex's; your lanes are the prose/source packaging around it — schedule these as the fill task, not the critical path.

**NEW theorem targets visible in the three manuscripts that are worth grabbing (ranked by value/effort):**

- **[HIGH value, LOW effort] Formalize E's "no exponential splitting" remark.** E currently marks `$[H_{\mathrm{free}},K(z)]\neq0$` (norm 5 at the four-mode line witness) as "oracle-grade; formalization optional." It is a single explicit finite commutator norm — a cheap kernel `decide`/`native_decide` that turns a Remark into a theorem and strengthens the "interacting automaton is *defined* by alternation" argument. Grab it.

- **[HIGH value, MEDIUM effort] Formalize Paper C's 16-field complete-walk multiplicity census (`$\dim\ker(W\mp\id)=2$`, blocks 4).** This is exactly the "not yet machine-checked" run-record that forces the existence-vs-multiplicity hedge in Q2. Discharging it (compiled evaluator over 16 fixed rational walks) removes C's last caveat and would let C claim the full multiplicity law, not just existence. Best single upgrade to an already-frozen paper.

- **[MEDIUM value, MEDIUM effort] Paper A open problem #4 as a concrete theorem: the generalized Pluecker rest operator.** A already proves `$\mu^2=\sum_{i<j}|\psi_i\wedge\psi_j|^2$` for rank-one momenta; the natural next kernel theorem is a canonical odd Hermitian operator `$B_w$` from `$w=(\psi_i\wedge\psi_j)_{i<j}$` with `$B_w^2=(\text{complete area budget})\,\id$` and a decomposition-independent phase/moduli classification. This is a genuine new result (not just packaging) and is the most publishable "missed" target, but it is a fresh construction — schedule only if steps 1–4 finish comfortably.

- **[LOW/insurance] Paper A / Paper C oracle-transcribed constants (`$\mp2$` second-frame windings).** Formalizing these removes the "flagged for source re-verification, not kernel-certified" quarantine in both papers. Low value per hour (they are already quarantined honestly) — do only as slack fill.

**Bottom line ordering:** fix wording & freeze A+C (1h) → E momentum-block (3–4h) → E 28×28 product-check (3–4h) → cheap E commutator theorem (<1h) → C multiplicity census (upgrade a frozen paper) → A freeze package + cross-paper hostile audit → `halfcharge2` cut if stalled → FB prose lanes as fill. This keeps both headline E "[PENDING]" slots covered, converts the two remaining not-machine-checked caveats (E commutator, C census) into kernel, and leaves the generalized-rest-operator theorem as the stretch goal.

---

### Audit caveats
- This memo audits prose calibration only; the packet contains no Lean sources, so the kernel/eval marks are taken at face value and cross-checked for *internal* consistency, not re-verified.
- Verbatim quotes are cited by line number in the current draft files; line numbers will shift once the R1–R5 edits land.
