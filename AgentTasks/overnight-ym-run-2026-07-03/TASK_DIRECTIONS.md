# Task directions: first moves and success tiers (YM run 2026-07-03)

Per-task guidance for the overnight YM run. Each task lists first moves
and three tiers: **baseline** (the floor - do not end the night below
this), **strong**, and **shocking** (the aim). The literature protocol in
`RUN_PLAN.md` applies to every task; log searches and ingests in
`LIT_LOG.md`.

The night's substrate is the freeze document,
`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md` (cited below
as "freeze sN"). It contains COMPLETE paper proofs for everything in
T1-T3: your job is formalization and semantic fidelity, not discovery.
When a freeze proof step resists Lean, the failure mode is almost always
a convention slip - check the oracle before rewriting mathematics.

Ambition rule, restated: small lemmas you can see the proof of - just
prove them, now, locally. Ambitious targets - one `idea:` round to refine
the statement, then Aristotle at full strength, un-weakened.

---

## T0 - Preflight, baseline commit, harvest sweep

**First moves.**

1. Baseline: already committed (`30a5523` + the planning session's prep
   commit). Verify `git status` is clean and
   `lake build PhysicsSM.Draft.NullEdge.GateYM` is green (planning
   session measured 8030 jobs, three expected `s o r r y` warnings from
   the `WilsonWeightPositivity` scaffold). If the tree is dirty,
   reconcile before claiming lane work.
2. `$env:PYTHONIOENCODING='utf-8'; aristotle list --limit 40` (paginates;
   reconcile older pages). Cross-check every IDLE project against
   `AgentTasks/overnight-nerd-run-2026-07-02/LEDGER.md` - most were
   harvested yesterday; mark them retired in tonight's registry rather
   than re-inspecting. Genuinely unharvested items get the dry-run
   integration helper.
3. `203fd831` (gate-c2-flux2d-witness resubmission) is RUNNING: note it in
   the registry with a poll owner. When it completes, harvest per
   checklist - it is not a YM job but banked results outrank lane purity.
4. Oracle: BOTH TODOs already closed by the planning session (v0.2,
   36/36 - see `PREP_NOTES.md` section 1). Just rerun
   `python Scripts/oracle/validate_lgt_core.py` once to confirm 36/36 in
   tonight's environment.
5. Neo4j: re-verify it is up (one `neo4j_paper_search.py --query` call).
   It was down at planning time and was started headlessly - restart
   command and degradation protocol in `PREP_NOTES.md` section 4.

- **Baseline:** baseline commit landed; registry complete and reconciled;
  flux2d poll owned; oracle and Neo4j re-verified.
- **Strong:** any unharvested IDLE returns integrated or explicitly
  deferred with reasons.
- **Shocking:** T0 done inside 45 minutes, both agents already on lane
  work with wave-1 statement files drafted.

## T1 - YM3 flagship lane: character positivity -> RP-LINK (freeze s5-s6)

**Context.** The single most valuable lane. Freeze s5 proves Theorem 3
(all Wilson character coefficients w_hat_R >= 0), Cor 3a (finite Bochner:
K(g,h) = w(g h^{-1}) PSD iff all w_hat_R >= 0, both directions Gram), and
Cor 3b (transfer positivity). Freeze s6 fixes the RP-LINK statement and
proof route. Freeze s15 is the Mathlib API map - use it, it was built for
this session. Reflection positivity has never been formalized by anyone
(verify via T6's novelty check before writing that sentence anywhere).

**First moves.**

1. Resolve `design:ym3-unitarity` in `DISCUSSION.md` (seeded): Theorem 3
   step (i) needs `conj(chi(g)) = chi(g^{-1})`, which Mathlib does not
   package. The freeze recommends option 1 - carry an explicit unitarity
   hypothesis (`(rho g)^H * (rho g) = 1` or `rho : G ->* Matrix.unitaryGroup n C`),
   physically free since Wilson actions use unitary representations.
   Decide in ONE round, record the verdict, move.
2. Read `PREP_NOTES.md` sections 2-3 FIRST. The planning session
   scaffolded `GateYM/WilsonWeightPositivity.lean` (typechecked, three
   documented handoff markers): the Route B chain - `reChar` Gram kernel
   PSD -> entrywise-exp via the Schur product theorem
   (`Matrix.PosSemidef.hadamard`, verified present) -> the Wilson kernel
   `K(g,h) = w(g h^{-1})` PSD WITHOUT character theory. Closing those
   three handoffs is the fastest path to the RP engine; each has a full
   proof plan in-file. Route A (Theorem 3 proper) is authored fresh in
   `CharacterPositivity.lean` per the s15 API map:
   `Representation.char_tensor` for step (ii); `char_orthonormal`
   (k = C, side condition free) for coefficient extraction; trap -
   `char_conj` is the class-function property, NOT complex conjugation.
3. Small steps local, big steps Aristotle. Likely local: the scaffold's
   `reChar_inv_of_unitary` and `reCharGram_posSemidef`; Route A's
   step (ii)/(iii) assembly. Likely Aristotle
   (`ym3-charpos-rp-20260703`): the scaffold's
   `wilsonKernel_posSemidef` (tsum/Hadamard bookkeeping), the
   coefficient extraction against `char_orthonormal`, Cor 3a's converse
   direction, and RP-LINK's cut factorization. `Matrix.PosSemidef.kronecker`
   is VERIFIED present - Cor 3b's tensor step is a citation.
4. Cor 3b wiring: tensor product of PSD kernels is PSD; conjugation by
   the positive diagonal V^(1/2); Gauss projector compression. Coordinate
   with T3's D12 module - same objects, one owner at a time.
5. RP-LINK (the flagship statement): freeze s6 verbatim as intended
   reading; LINK reflection only; the Boltzmann factor factorizes across
   the cut as a product of PSD per-link kernels; spectral-decompose K and
   exhibit <(theta F)* F> as a sum of |integral|^2 terms.
6. Acceptance test: the C-8 identity
   Z_torus = 2^(L*nt) Tr[(T P_G)^{nt}] (Z2, 1+1D) proved in Lean on a
   small concrete instance. This is what makes the reconstruction claim
   honest.

- **Baseline:** unitarity decision recorded; Theorem 3 + Cor 3a statement
  files typechecked, cross-reviewed, and the first Aristotle package
  submitted; the Gram direction of 3a proved locally.
- **Strong:** Theorem 3 and Cor 3a kernel-checked end to end; Cor 3b
  stated with the tensor/compression lemmas in place; RP-LINK statement
  frozen in Lean and cross-reviewed.
- **Shocking:** RP-LINK kernel-checked for arbitrary finite G, plus the
  reconstruction skeleton (null-space quotient, positive transfer
  operator, H = -log T on the physical sector) stated with the C-8
  identity proved on a concrete instance. That is the flagship paper's
  entire mathematical core, machine-checked, in one night. EQUALLY
  shocking: a genuine formalization obstruction in the character-theory
  API, minimized to an exact missing-lemma statement and documented as a
  Mathlib-facing gap note.

**Lit hooks.** Osterwalder-Seiler 1978 internals (T6 item 1) - verify the
LINK/SITE distinction and the exact RP statement shape before the paper
claim language is drafted; not blocking for the Lean statements, which
follow the freeze.

## T2 - YM1 completion: 2D exact solutions (freeze s4)

**Context.** Theorem 2' (Z2 torus: Z = 2^E cosh^P(beta) (1 + t^P);
contractible loop <W> = (t^A + t^{P-A})/(1 + t^P)) and Theorem 2 (open 2D
lattice, any finite G: exact area law via the fusion lemma). Oracle pins
both at 1e-12 / 1e-10. Together with the already-shipped Elitzur chain
(`ElitzurCore.lean` + `ElitzurLattice.lean`), these complete the YM1
paper unit's mathematics.

**First moves.**

1. PKG-YM1-B (`ym1-torus-evencover-20260703`): the heart is the even-cover
   lemma - on the 2D torus, a plaquette subset in which every link has
   even incidence is empty or everything (dual connectivity). Draft the
   statement file with the plaquette-expansion identity
   (cosh factorization, monomial survival iff even cover) and the
   even-cover lemma as separate targets. The combinatorics is
   self-contained finite math - Aristotle-shaped. Attempt the even-cover
   lemma locally first; it may fall to a clean induction on the dual
   graph.
2. ORACLE-TODO-1 is ALREADY CLOSED (planning session; oracle v0.2
   section [9]) - PKG-YM1-C is unblocked. NORMATIVE consequence for the
   statement file: state the fusion lemma in CONVOLUTION form
   `sum_h w(h) chi_R(h^{-1} A) = |G| w_hat_R chi_R(A) / d_R`, and derive
   the freeze s4 order `sum_h w(h) chi_R(A h)` as a corollary for
   inversion-symmetric weights (all Wilson weights; the scaffold's
   `reChar_inv_of_unitary` supplies the symmetry). The oracle's guard
   row shows the naive order genuinely fails otherwise.
3. PKG-YM1-C (`ym1-fusion-2dexact-20260703`): Lemma 2a (fusion, in
   convolution form per the above - build on
   `Representation.char_orthonormal` per the s15 map), Lemma 2b (tree
   gauge / triangular change of variables), Theorem 2 assembly. Shares
   the unitarity/conjugation design decision with T1 - inherit it, do
   not re-decide.
4. YM1-E-G (general finite-G Elitzur, freeze s3 remark (ii)): statement
   freeze ONLY unless it falls out of the ElitzurCore abstraction for
   free (the abstract pairing bound is already group-agnostic - check
   what actually pins Z2 in `ElitzurLattice.lean` before assuming).

- **Baseline:** PKG-YM1-B statement file typechecked, cross-reviewed,
  submitted (or even-cover proved locally).
- **Strong:** Theorem 2' kernel-checked; PKG-YM1-C submitted with the
  fusion lemma statement grounded in the s15 API map.
- **Shocking:** both 2D exact solutions kernel-checked - with T0's
  Elitzur chain already banked, the complete YM1 paper unit ("the first
  formalized lattice gauge theory theorems") exists as verified Lean by
  morning, pending only the T6 attribution pass.

**Lit hooks.** Wegner 1971 (dualities context for the YM1 paper's
positioning - the dualities themselves are NOT tonight's scope); the
formalization novelty check (T6 item 8) gates the paper's title claim.

## T3 - YM0 breadth: general finite-G core + D12 gap definition (freeze s1-s2)

**Context.** `Z2GaugeCore.lean` proves L1/L2/L4 for Z2 (orientation-free).
General finite G threads inverses through everything (C-1: reversed
traversal uses the group inverse). This is bookkeeping-heavy,
mathematically safe, and it is what makes "lattice gauge theory core"
true beyond one group.

**First moves.**

1. PKG-YM0-B module (`GaugeCoreGeneral.lean` working name): link fields
   E -> G with orientation; holonomy of walks with inverses; the gauge
   action (g.U)_e = g(src e) U_e g(tgt e)^{-1}; L1 (basepoint conjugation
   + orientation inversion), L2 (hol(g.U, C) = g_x hol(U,C) g_x^{-1};
   class functions gauge invariant), L3 (the action is a bijection of
   G^E; finite change of variables - Haar/compact is OUT of scope
   tonight), L4 (composition/involution/orbit bookkeeping), L5 (center
   twist fixes plaquette holonomies, multiplies the Polyakov loop;
   finite-volume <P_f> = 0 as a symmetry identity - docstring MUST carry
   the F-YM-CONFLATE guard: this is not confinement).
2. Structure for reuse: state L1/L2 for an abstract walk/holonomy layer
   so T2's Lemma 2b and T1's RP cut bookkeeping can consume them.
   Cross-review the definitional layer EARLY - definitions are where
   semantic drift enters; a bad `hol` convention poisons every downstream
   lane.
3. D12 module (`TransferGapDefinition.lean` working name): the transfer
   matrix per C-8 (Z2, 1+1D concrete first), the Gauss projector as an
   average over spatial gauge transformations, the 't Hooft flux/winding
   sector decomposition, and the gap definition Delta_Lambda restricted
   to the vacuum symmetry sector. Definition-only module is a fine
   landing state; its acceptance test is T1 step 6 (the C-8 trace
   identity). Coordinate ownership with T1 explicitly in the ledger.

- **Baseline:** general-G module with L1/L2 stated and proved (they are
  short inductions - local work, not Aristotle); definitional layer
  cross-reviewed.
- **Strong:** L1-L5 all kernel-checked for general finite G; D12 module
  compiles with the flux-sector definition and its oracle-derived
  docstring (freeze s1, D12).
- **Shocking:** D12's gap is EVALUATED on a tiny concrete instance in
  Lean (decide/norm_num scale, or documented draft-trust
  `n a t i v e _ d e c i d e` with the axiom footprint recorded) and
  matches the oracle's section [7] numbers - the first kernel-adjacent
  mass-gap computation of the program.

**Lit hooks.** 't Hooft 1978 (flux sectors; attribution for the D12
qualifier); prior-art check on formalized transfer matrices (T6 item 8).

## T4 - QCD1: finite Banks-Casher shadow (freeze s8)

**Context.** QCD1-i: the exact finite decomposition
Sigma_Lambda(m) = |nu|/(mV) + (2m/V) sum_{lambda_hat_j > 0}
1/(m^2 + lambda_hat_j^2), zero modes separated, nonzero modes in chiral
pairs. Pure finite linear algebra adjacent to the C2 spectral machinery.
QCD1-ii: the density sandwich with explicit error. The LIMIT statement is
commentary, never a claim (F2.0 lesson).

**First moves.**

1. Read the C2 spectral assets first:
   `GateC2/GaugeIndexInertiaForm.lean` (`epsCFC_trace_eq_inertia`,
   eigenvalue-count forms) and `GateC2/OverlapSignCertificate.lean`. The
   statement should be phrased on those objects, not on a parallel new
   stack.
2. Draft the chiral-pairing lemma (nonzero GW-circle modes pair under
   gamma5) as its own target - it is the one step with semantic risk
   (which map is lambda_hat, where does the GW circle enter). Open a
   `review:qcd1-pairing` thread with the exact statement before
   submission.
3. Package as `qcd1-banks-casher-20260703` if it resists local proof;
   the freeze grades it "natural Aristotle package".

- **Baseline:** QCD1-i statement file typechecked on C2 assets,
  cross-reviewed, submitted or in local progress.
- **Strong:** QCD1-i kernel-checked.
- **Shocking:** QCD1-i AND QCD1-ii (sandwich with explicit err term)
  kernel-checked - the ladder's first QCD-facing theorem, and a second
  concrete consumer of the C2 machinery within a week of C2 opening.

**Lit hooks.** Banks-Casher 1980 (attribution + exact original statement
shape - T6 item 6).

## T5 - YM4 groundwork: Kotecky-Preiss + polymer layer (freeze s7)

**Context.** The KP criterion is the ladder's most reusable module
(earmarked for the Measure Problem's quantum-growth estimates too) and is
absent from Mathlib. Full convergence analysis is NOT a one-night target;
the statement freeze in Lean plus the finite-lattice polymer
representation are.

**First moves.**

1. Statement file: abstract polymer system (finite polymer set, weight
   function, symmetric incompatibility relation), the KP condition
   (sum over incompatible gamma' of |w| e^{a} <= a), and the frozen
   conclusion shape (absolute convergence of the cluster expansion for
   log Z, uniform in volume, standard tail bound). Get the Ueltschi-form
   hypotheses EXACTLY right from the source (T6 item 3) before freezing -
   this is the one lane where the lit check is BLOCKING, per F-YM-LIT.
2. Polymer representation lemma (finite, no analysis): on the finite
   lattice, Z / (2^E cosh^P) = sum over even-cover plaquette sets,
   factorizing over connected components. NOTE the synergy: the
   even-cover machinery is shared with T2's PKG-YM1-B - same owner or
   explicit coordination, do not build it twice.
3. Oracle: add a strong-coupling series fixture (tiny lattice, leading
   orders in t, checked against the exact Z from C-7) to feed YM4-a's
   eventual formalization.
4. Submit PKG-YM4-A only if T1/T2 waves are in flight and the proof-job
   cap has room. The statement cross-review is tonight's real
   deliverable; a premature submission with wrong hypotheses is negative
   progress.

- **Baseline:** KP statement drafted with source-verified hypotheses;
  polymer-representation lemma stated.
- **Strong:** polymer representation kernel-checked (or shared with T2's
  even-cover and checked there); KP statement file typechecked and
  cross-reviewed; oracle fixture added.
- **Shocking:** PKG-YM4-A submitted at full strength after cross-review,
  with the finite combinatorial core already verified locally - the YM4
  rung's foundation laid a season early.

## T6 - YM-LIT: literature verification sprint

**Context.** The debt register (freeze s11 pointer, program doc s11) is
all cited FROM MEMORY. Tonight converts the load-bearing entries to
verified imports. The standing target list with per-item goals lives in
`LIT_LOG.md` - work it top-down; items 1, 3, and 8 are the load-bearing
ones (1 shapes T1's paper claim, 3 BLOCKS T5's statement freeze, 8 gates
every "first ever" sentence).

**First moves.** Take items in `LIT_LOG.md` order; for each: locate the
source (graph first, then web), verify the exact statement + hypotheses
against what the freeze/program doc remembers, ingest via
`lit_ingest.py` (pre-add existence check keyed on arxiv_id/doi), and log
the verdict with what it affects. Corrections to the freeze or program
doc go in a `corrections:` discussion thread - claim-language edits need
cross-review.

- **Baseline:** items 1, 3, 8 resolved and logged (Osterwalder-Seiler
  statement shape; KP/Ueltschi hypotheses; the formalization novelty
  check).
- **Strong:** items 1-6 + 8 verified and ingested; any discrepancies
  written up with proposed doc corrections.
- **Shocking:** the full register verified in one night, the novelty
  checks resolved with citations, and a one-page "verified imports"
  annex drafted that the YM1/YM3 papers can lift verbatim - YM-LIT's
  blocking function discharged for the whole finite-G floor.

## T7 - Aristotle as partner (strategy/red-team jobs)

**First moves.** BOTH prompts are already drafted by the planning
session in `AgentTasks/aristotle-prompts/`:

1. `overnight-ym-ladder-strategy.prompt.md` - COMPLETE except the one
   `TONIGHT-STATE` block (fill with the ledger summary at submission
   time). Can go out early; its questions (flagship gap analysis,
   finite-G/compact-G separability, statement-shape risks, sequencing,
   embarrassment audit) do not depend on tonight's Lean.
2. `overnight-ym3-semantic-redteam.prompt.md` - a TEMPLATE with
   `<<PASTE ...>>` slots for the VERBATIM Lean statements of the YM3
   chain once T1 authors them (definitional layer, theorem statements
   with separate intended readings, consumers). Submit once the
   statement files exist - mid-evening, not at dawn. Verbatim source,
   never paraphrase.

- **Baseline:** both submitted with registry rows.
- **Strong:** reports returned and triaged into concrete ledger actions.
- **Shocking:** the red-team catches a real semantic slip in the RP
  formalization before it reaches the paper layer (catching it IS the
  win), or the strategy report yields a morning promotion plan the user
  can execute in thirty minutes.

## T8 - Morning report

Per the RUN_PLAN spec. The report should let the user reconstruct the
night in five minutes and decide the day's promotions in thirty. Draft by
whoever is active at 07:00; cross-review mandatory.

---

## What shocking looks like globally

RP-LINK kernel-checked for arbitrary finite G with the C-8 acceptance
identity; Theorem 3 + Bochner + transfer positivity verified; both 2D
exact solutions closed; the general finite-G gauge core and the
flux-qualified D12 gap definition compiled; QCD1-i proved on the C2
assets; the KP statement frozen against verified sources; the debt
register's load-bearing entries source-verified with the novelty checks
resolved. That is the complete finite-G floor of the ladder - the
mathematics of the first TWO papers (YM1 and the YM3 flagship) existing
as verified Lean by morning, months ahead of the freeze's own schedule,
reachable because the freeze already wrote the proofs and mapped the API.
