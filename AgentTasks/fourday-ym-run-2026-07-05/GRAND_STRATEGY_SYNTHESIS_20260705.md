# Grand-strategy synthesis: two Aristotle audits -> one plan (2026-07-05)

Synthesis of the two grand-strategy jobs, by claude:
- WHOLE-PROJECT audit (claude, `0bd9d3b4`) - all 7 programs; strategic/credibility
  lens. Raw: `GRAND_STRATEGY_AUDIT_whole-project_claude_0bd9d3b4.md`.
- YM-LADDER audit (codex, `89ae2c3b`) - the null-edge/YM stack; tactical/proof
  lens. Raw: `GRAND_STRATEGY_AUDIT_ym_codex_89ae2c3b.md`.

Both are source-grounded (read the Lean, not the prose). They agree strongly and
are complementary. This file merges them into a single prioritized plan and
surfaces the decisions the lead must make.

---

## 1. What both reports agree on (the robust core)

1. **Soundness hygiene is genuinely strong.** Real draft-vs-trusted separation,
   NO stray `a x i o m` declarations, a pervasive axiom-audit culture, and a
   self-red-teaming habit that already demoted its own "unification" overclaims
   to "co-location, not coupling." Both reports lead with this.
2. **It is really TWO programs, not one.** BET A: division algebras -> SM
   structure (Furey/Dixon/Baez; the strongest lane). BET B: null-edge geometry
   -> mass + a finite lattice-YM/QCD-mass ladder. The A<->B "unification" is an
   aspirational third bet that the Lean currently proves is INDEPENDENCE
   (co-location), not coupling.
3. **The verified content is PREREQUISITES, not the summit.** Nowhere near a
   Yang-Mills mass gap; the "all mass from null edges" unification is a shared
   mechanism SHAPE, not a theorem. Both are emphatic and correct.
4. **One analytic crux gates the whole YM mass-gap arc:** `pairSum_le_expBound`
   (`PolymerKPConclusion`, ~L938) - the labeled rooted-tree exponential
   inequality (mine ranked #3, codex ranked #1).
5. **Two never-built objects gate the YM physics:** the M1/M3 CONNECTED
   cut-bearing Wilson slab lattice (does not exist in Lean - codex calls it "the
   true center of gravity... and it is empty"), and Peter-Weyl / nonabelian
   character expansion (absent from pinned Mathlib).
6. **Two over-claim/hygiene risks to fix now:**
   - (claude) `n a t i v e _ d e c i d e` sits UNDER the E8 "publication
     artifact" (`Coding/E8ShortVectors` etc., the 240-count), which is imported
     into the DEFAULT `PhysicsSM` library and advertised as kernel-proved. By the
     repo's own rule that is draft-trust (`Lean.ofReduceBool` + `trustCompiler`),
     not kernel-trust.
   - (codex) the GateYM aggregator IMPORTS `PolymerKPConclusion` (3 `s o r r y`s),
     so `lake build ...GateYM` is NOT globally `s o r r y`-free - any "GateYM is
     kernel-checked" statement is an over-claim.
7. **Best negative asset:** `kp_convergence_bound_false` - a kernel-checked
   disproof that the naive bare-KP bound fails without self-incompatibility.
   Advertise it; never resurrect the false shape.

---

## 2. The merged priority plan (near-term: this run / next ~week)

Organized by lane and suggested owner (board rules over suggestions).

### Lane YM-analytic + YM-geometry (codex - already active here)
- **Y1. Harvest the running Q6 job**, semantic-review, targeted build, re-grep
  `s o r r y` count. (codex, hour 0-2.)
- **Y2. `pairSum_le_expBound`** - keep it as the ONE high-effort Q6 Aristotle
  search (canonical single-root deletion; `treeRootChildBlock` scaffolding named;
  two-failure park rule). Closing it turns 3 downstream theorems live. Do NOT
  submit a second Q6 variation (budget rule).
- **Y3. Build the M1/M3 CONNECTED cut-bearing Wilson slab lattice** + prove the
  mirror-coordinate holonomy factorization `hol = e(c,a) * e(c,b)^-1` that
  `WilsonCutPlaquetteEnsemble` consumes. This is the single highest-leverage
  MISSING object (unblocks genuine RP-LINK AND the first physical transfer
  operator); pure geometry/finite-algebra, no Peter-Weyl. Codex's recommended
  next job (a construction/statement-freeze, not a proof search).
- **Y4. Finish YM1 Theorem 2 (area law) as a self-contained paper unit** - it is
  done end-to-end; remaining work is packaging + an explicit "proved / oracle /
  open" boundary section. The one genuinely finishable scientific deliverable.

### Lane credibility + hygiene (claude)
- **C1. Kill the two over-claim surfaces.** (a) Everywhere, qualify "GateYM
  `s o r r y`-free" -> "except the Q6/KP conclusion cruxes." (b) Either DE-NATIVE
  the E8-240 core (kernel enumeration, NoNative pattern) OR re-label it
  draft-trust in README + theorem index. This is the single highest-credibility
  action in the whole project.
- **C2. Fix packaging/advertising drift.** README + `lakefile.toml` reference a
  `docs/` tree and a `CodeLatticeE8` / `CodeLatticeE8Standalone` package that are
  NOT in the delivered tree (the E8 work lives under `PhysicsSM/Coding`).
  Reconcile so `lake build` of a named target matches the prose; drop dead links.
- **C3. Promote the cheap wins with axiom guards.** Q4/Q5 (`FDRepUnitarizable`,
  `WilsonVacuumDominance` unconditional forms), and the Mathlib-gap fillers
  `hadamard_posSemidef` / `HermitianFromRealQuadraticForm`. Near-zero new proof
  effort; first PROMOTED results + upstream-PR candidates. Attach a
  CapstoneAxioms-style build-enforced axiom-footprint guard to each flagship.
- **C4. Wire NullStrand into a named build target** (currently orphaned from all
  top-level roots).

### Lane A backbone (claude)
- **A1. Close the two lane-A identity theorems:** `1a`
  `su3_octonion_mulEquiv_specialUnitaryGroup : MulEquiv su3Submonoid
  (Matrix.specialUnitaryGroup (Fin 3) C)` (finite identity), then `1b`
  fundamental-rep-as-color-triplet ACTION (not just matching multiplet DATA).
  Backbone of BET A; connects octonion SU(3) to Mathlib SU(3) at group level.
  NOTE: this run already landed `su3Submonoid = specialUnitaryGroup` as a set
  EQUALITY (`G2FixingE111SpecialUnitaryGroup`) and 1b irreducibility
  (`ColorTripletFundamental`); the audit's `1a` MulEquiv is the group-level
  upgrade, partly in hand.
- **A2. Honestly restate the anomaly claim:** "the U(1) linear and cubic sums are
  sums of DERIVED `Q_op` eigenvalues" (which `AnomalyFromQop` proves), NOT "the
  octonions prove an anomaly-free generation" (the SU(2)^2/gravitational
  anomalies and the RH sector are not octonion-derived).

### Lane unification verdict (claude)
- **U1. `charge_grading_mass_compatible`** on `ComplexOctonion (x) CSpinor` -
  prove the shared mass form does (or does not) factor through the spacetime
  projection. Expected: the co-location branch (this run already kernel-verified
  the color-blind-mass core, `GateI1/ColorBlindMass*`). A kernel-verified
  NEGATIVE is a real, publishable clarification; a surprise positive is the
  project's biggest result. Either way it converts the A/B narrative into a
  kernel verdict.

### Consolidation debt (either, low urgency)
- **D1.** Stop adding near-duplicate `Gauge/StandardModel*Z6*` and
  `...Equiv`/`...Package` files; consolidate into a few general results.
- **D2.** Curate ONE compile-checked theorem index (statement + claim label +
  axiom footprint per flagship) as the single public face.

---

## 3. Medium-term arc (3-6 months, two agents + Aristotle)

From the whole-project audit, adjusted:
- **Month 1 - credibility:** C2 packaging fix + C1 de-native E8-240 +
  completeness + C3 axiom guards on all flagships. Checkpoint: a named
  publication target builds kernel-trust (audit shows only
  propext/Choice/Quot.sound).
- **Month 2 - lane-A backbone:** A1 `1a` MulEquiv + `1b` action theorem + A2
  anomaly restatement. Checkpoint: octonion SU(3) connected to Mathlib SU(3) at
  group level, kernel-checked.
- **Month 3-4 - YM analytic wall:** Y2 `pairSum_le_expBound` +
  `kp_convergence_bound_of_selfIncompatible`, then exponential clustering of
  local loop observables. Checkpoint: a `s o r r y`-free finite clustering
  theorem in GateYM.
- **Month 4-5 - RP-LINK milestone + QMF statement layer:** Y3 M1/M3 lattice ->
  unconditional RP-LINK (Q1) feeding `finiteMassGap`; QMF7 STATEMENT file with
  the mass taxonomy as named defs. Checkpoint: a citable "RP for an interacting
  lattice gauge ensemble" writeup.
- **Month 5-6 - the verdict:** U1 `charge_grading_mass_compatible` (expect
  co-location) + the clarifying paper "mass is SU(3)-color-blind in the
  octonion/null-edge factorization." Checkpoint: the unification question
  answered by the kernel.

---

## 4. Decisive questions for the LEAD (these gate the plan)

The audits converge on a small set of decisions only the lead can make. The plan
above assumes provisional answers (in brackets); confirm or override:

1. **Publication trust standard.** Is `n a t i v e _ d e c i d e` acceptable in
   the flagship E8 artifact, or must every published theorem be kernel-trust
   (propext/Choice/Quot.sound only)? [Assumed: kernel-trust required -> C1
   de-native.] Everything in Month 1 hinges on this.
2. **Which flagship?** The E8/Hamming paper (mature, one trust-fix away) or the
   YM RP-LINK milestone (higher prestige, more analytic + geometry risk)? Do not
   split scarce Aristotle budget across both. [Assumed: E8/Hamming first as the
   near-term paper, YM RP-LINK as the prestige track in parallel at lower
   intensity.]
3. **Publish the negative?** Accept that the honest CURRENT unification result is
   co-location / color-blind mass, and publish it as a clarification rather than
   waiting for a coupling that may not exist? [Assumed: yes - U1 then a
   clarifying note.]
4. **Continuum permanently off-scope?** Enforce F-YM-CONFLATE and
   no-continuum-drift (QMF8) as veto conditions on QMF7 language? [Assumed: yes.]
5. **Consolidation vs volume.** Pay down the Gauge-Z6 / Draft fragmentation debt
   and commit to a single curated theorem index, or keep optimizing for file
   count? [Assumed: pay it down - D1/D2 - to stay navigable at ~1000 files.]

---

## 5. Standing guards (both reports, non-negotiable)

- Do NOT call the GateYM aggregator `s o r r y`-free (it imports the 3 Q6
  cruxes).
- Keep `hself` (self-incompatibility) threaded everywhere; the bare-KP bound is
  PROVEN false (`kp_convergence_bound_false`).
- No physical transfer operator / mass gap exists; every `finiteMassGap`
  positivity is on the 2x2 toy. Any "mass gap" prose beyond a finite
  spectral-ratio definition on a toy matrix is an over-claim.
- Let the Lean lead the prose, not the reverse - stop extending the unification
  NARRATIVE ahead of the non-factoring theorem.

---

## 6. UPDATE (2026-07-05, after lead's answers + repo verification)

### 6.1 Lead's locked decisions (replace the provisional brackets in section 4)

1. **Trust standard:** `n a t i v e _ d e c i d e` is ACCEPTED in the repo (a
   deliberate build-speed choice over slow `decide`). Structural proofs are the
   IDEAL where they can replace previously-slow `decide`s, but are opportunistic,
   not a blocker. => C1 "de-native the E8 core" DOWNGRADES from a trust-fix to an
   opportunistic cleanliness task. The E8/Hamming artifact is NOT trust-blocked.
2. **Aristotle budget: RELAXED to effectively unlimited** (free, no throttle seen).
   The only real constraint is INTEGRATION DEBT - keep harvested jobs integrated
   so the tree does not drift. Parallelize jobs aggressively; the "8-slot" and
   "no second Q6 job" rules are lifted (revisit only if Harmonic throttles).
3. **Headlines wanted** alongside negatives. Mention co-location/color-blind mass,
   but PRIORITIZE genuine headline positives too (E8/Hamming paper, RP-LINK,
   lane-A group-level SU(3)).
4. **Continuum permanently OUT** (confirmed). F-YM-CONFLATE + no-continuum-drift
   stay as vetoes.
5. **Consolidation WELCOME** (Gauge-Z6 near-duplicates + one curated theorem
   index). Greenlit.

### 6.2 Repo-verification corrections to the audits (IMPORTANT)

Both audits ran on the SLIM SUBMISSION COPY produced by
`prepare_aristotle_submission.ps1`, which EXCLUDES `docs/` and the
`CodeLatticeE8*` roots (it copies PhysicsSM + Sources + Index + AGENTS + README
only). Verified against the real repo:

- **FALSE (slim-copy artifact):** audit finding 0.1 "no `docs/` directory" and
  "`CodeLatticeE8` / `CodeLatticeE8Standalone` package missing / lakefile
  declares un-buildable libs." The REAL repo HAS `docs/` (ARISTOTLE, BUILD,
  CONVENTIONS, NERD_ROADMAP, NULLSTRAND) and HAS `CodeLatticeE8`,
  `CodeLatticeE8.lean`, `CodeLatticeE8Standalone/`, and the `lean_lib
  CodeLatticeE8*` roots exist. => C2 "fix packaging drift" is MOSTLY A NON-ISSUE;
  the real README/lakefile match the real tree. Drop it (except any genuinely
  stale line found by a direct real-repo check).
- **PARTIALLY real:** NullStrand is not wired into the default `PhysicsSM.lean`
  root (it has its own aggregator `PhysicsSM/NullStrand.lean`). Minor: wire it
  into a named target if we want it in the default build; otherwise intentional.
- **STILL real (not artifacts):** native_decide under E8 (but now ACCEPTED);
  GateYM aggregator not globally `s o r r y`-free; two-programs / co-location;
  the Q6 crux + M1/M3 + Peter-Weyl gaps; Gauge-Z6 fragmentation.
- **PROCESS FIX:** future whole-project strategy submissions must include `docs/`
  and the `CodeLatticeE8*` roots (add them via `-ExtraPath` or a strategy-copy
  variant), so Aristotle audits the complete tree, not a Lean-only slice.

### 6.3 Reshaped near-term priorities (given 6.1 + 6.2)

- E8/Hamming paper becomes a NEARER headline: native_decide is accepted, packaging
  drift was a false alarm, so the artifact mainly needs a paper writeup + honest
  "native-trust where used" labeling (NOT a de-native campaign).
- Lane-A is further along than the audit implied (this run already landed
  `su3Submonoid_eq_specialUnitaryGroup` as a literal EQUALITY plus
  `octonionMulAutFixingE111MulEquivSpecialUnitary` - so "1a" is effectively done;
  1b irreducibility landed in `ColorTripletFundamental`). Remaining lane-A is the
  anomaly-claim restatement + wiring.
- Use the unlimited Aristotle budget to parallelize headline targets (E8 paper
  formal gaps, lane-A remainders, and - codex - the M1/M3 cut-slab lattice + the
  Q6 crux).
- Opportunistic native_decide->structural where clean (done: `rootList_length`);
  do NOT sink into structuralizing the E8-240 enumeration (native is fine there).
- Consolidate Gauge-Z6 + build one curated theorem index.
