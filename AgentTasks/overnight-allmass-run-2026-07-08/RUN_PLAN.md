# Overnight all-mass run (2026-07-08): RUN PLAN

Planner: Claude Fable 5 (final act of the 2026-07-07 synthesis session).
Executors: **Claude (Opus) + Codex 5.5, co-equal**, coordinating ONLY via
the append-only `LEDGER.md` in this directory. Prover: Aristotle (fleet up
to 10 concurrent). Pattern: the 2026-07-06 overnight run + the 07-07
two-day carrier run's ledger discipline.

## 0. Mission (extremely ambitious, honestly gated)

1. **Complete the work.** Close every closable kernel target in the mass
   program (tier-K list below): the KP crux, the S1 instantiation, the
   physical sector, the mass-budget theorem, the Banks-Casher count
   identity, the symmetry-zero-mode theorems, plus the full harvest of
   the in-flight Aristotle fleet.
2. **Then draft and audit a manuscript that explains ALL forms of mass
   in null-edge terms, complete with Lean anchors** - per
   `MANUSCRIPT_SPEC.md`. The manuscript is the run's deliverable; kernel
   completion feeds it. If tier-K saturates early, the manuscript starts
   early; the manuscript phase MUST begin by mid-run regardless.

"Fully explains all forms of mass" is claimed ONLY in the layered sense
of the claim calculus: trusted kinematics; guard-pinned finite channel
theorems; MEMO-grade memos; named open cruxes; continuum/scale/Clay
permanently outside. A manuscript that says exactly what is proved is
the win condition. One that says more is a loss, whatever it proves.

## 1. Standing state (read before anything)

- `docs/DOCUMENT_MAP.md` -> the map. Then:
  `Sources/Null_Edge_QCD_Mass_Roadmap_2026-07-07.md` (S1-S7 + Amendments
  A and B), `AgentTasks/twoday-carrier-run-2026-07-07/FABLE_HANDOFF_HARDEST_PIECES.md`
  (twelve pieces), `.../TSOLDER_KAPPA_ANALYSIS.md` secs 4a-4b (the Koide
  kill + symmetry-zero-mode discovery), `.../s1-closure/` (the S1 memo),
  `NULL_EDGE_RESULTS.md`, the twoday `THREAD_BOARD.md` + `LEDGER.md`
  tail, `ARISTOTLE_LANE_DOCKET_2026-07-07.md`.
- In-flight Aristotle jobs to harvest FIRST: 7f7c1ea6 (SUB-NAT
  strategy), 43a7f979 (equipartition), 0dc48ac7 (perp-signature),
  72b75f0d / 4b4d1f1b / 8d95b408 (ne-hard p01/p02/p03), fbdbe43f,
  f8aa05c8, 5ff9424e, ecbf61d8 - run `aristotle list --limit 30`.

## 2. Tier-K kernel targets (ranked; claim in ledger before working)

- **K1 (the crux of cruxes): the KP fixed-forest injection**,
  `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` ~L1564.
  WARNING: it resisted FOUR Aristotle attempts on 07-06 (fibercount
  prompts 1-4 in the 07-06 run dir - read their failure notes first).
  Fresh angles: the file's own comment sketch (left-inverse parsing,
  root-first-then-blocks; tie-break lemma explicit), or a reformulated
  injection with the sum-type-split pattern. If it resists twice more,
  write the no-go analysis and move on - do not churn.
- **K2: L4 S1 instantiation** - `closure_current_square`
  (`S1ClosureCurrentAlgebra.lean`) instantiated on the concrete
  two-transport carrier with `A^# B = -K/2`, against the guard-pinned
  4-slot normalization. Oracle fixture:
  `Scripts/oracle/probe_s1_closure_oracle_v01.py` R5.1.
- **K3: Q01 Stage C** - transcribe the carrier Gauss/closure constraint
  space V' (the HSTAR docket's declared blocker), then IMMEDIATELY run
  the S1-CC probe: `sig(J Q_C |_{V'})` (Amendment B). This single probe
  decides closure positivity's fate. Numeric first, then Lean.
- **K4: S6 mass-budget theorem** - `CarrierMassBudgetExpectation`:
  `f_A + f_C + f_T + f_E = 1` over the pinned Weitzenboeck identity +
  at least one explicit witness state (vacuity guard: no witness, no
  landing). Wording rail: f_C is the CHROMOMAGNETIC share (Amendment B).
- **K5: S4a** - `FiniteBanksCasherSmoothCount`: `m V Sigma_m = N_m` for
  the GW-stereographic operator, as a COUNT identity (spectral rail:
  no measures, no limits). Builds on `BanksCasherShadow.lean`.
- **K6: symmetry-zero-mode theorems** T1 (Z_V-symmetric decoration
  forces 1 in spec(W)), T2 (tetrahedral rational spectrum, exact
  arithmetic), T3 (abstract locus char-poly relation) - pre-registered
  in TSOLDER_KAPPA_ANALYSIS sec 4b; oracle
  `Scripts/oracle/p1_zero_mode_locus_scan.py`.
- **K7: S1a Hessian** (`LinearizedNonabelianClosure`) + **A2**
  (`ClosureTensionDerivative`: d/dbeta[-log<W>] = excess closure
  defect; finite Feynman-Hellmann).
- **K8: RG-Schur M-dependent generalization**
  (`RGSchurMassWitness.lean` follow-up) + **S5 first-meson witness**
  (singlet two-point decay rate vs strong-coupling oracle fixture).
- **K9: harvest + refill the fleet continuously** (harvest-first; sec 1
  list; keep <= 10 concurrent; every landing gets guard pins + ledger
  entry with claim boundary).
- **K10 (capacity)**: E-slot trinity split, octonion -> Lambda(C^3)
  bridge, Q12 KO sign table (fixture-first) - handoff pieces 4/5/6.

## 3. Literature-search cadence (BOTH agents, every cycle)

- Every work cycle includes at least ONE literature action. Before any
  new formalization: semantic local search (lean-explore for
  Mathlib/PhysLean; `Scripts/lit/neo4j_doc_search.py` for our docs). On
  any new physics claim or manuscript section: EXTERNAL search.
- **Codex: run all EXTERNAL literature searches through Spark
  subagents** (spawn a Spark subagent per search topic; main thread
  keeps proving while Spark searches). Claude: scholarly MCP
  (search-arxiv / search-inspirehep) + `Scripts/lit/neo4j_paper_search.py`
  (--chunks for content-level claims).
- Ingest keepers via `Scripts/lit/lit_ingest.py` (dedup pre-check;
  IN_COLLECTION edge required). Log EVERY search + verdict in this
  run's `LIT_SEARCH_LOG.md` (append-only, one line per search).
- Manuscript rule: every physics comparison in the manuscript cites a
  paper that is IN THE GRAPH, checked against full text (--chunks), not
  abstract-only.

## 4. Discipline (constitution-grade; violations = run failure)

- Kernel is truth. Flagship landings need `#guard_msgs` axiom pins
  (CarrierAxiomGuard / SlabAxiomGuard patterns). No `s o r r y` outside
  documented draft handoffs.
- Claim calculus T / T|H / M / C + MEMO everywhere; four over-claim
  modes review before any headline; SPECTRAL LANGUAGE FORBIDDEN until
  the positivity crux closes (K3 may change this - until its probe is
  green, the rail stands).
- KILLS - do not relitigate: Tr E = pure torsion; M-KOIDE Route A
  (kappa = 3/2 measured); one-sided GW inversion; site-diagonal
  defect-Gram = Q_C (grading-dead); retardedness-deletes-doublers;
  "closure disagreement IS gauge-field energy" (chromomagnetic rail).
- Ledger protocol: append-only; CLAIM a target before working it;
  every entry carries verification commands actually run and an
  explicit claim boundary. Cross-review: each agent audits the other's
  landings each cycle (semantic alignment, convention drift, hidden
  hypotheses).
- No blocking sleeps/polls on external jobs - check inline between
  genuine work; recognize saturation and switch to audit/documentation.
- Aristotle: harvest-first; context packs for nontrivial submissions;
  standalone packages for Mathlib-isolable targets; 2-hour stall rule;
  one task note per job with the metadata block.
- External model calls ONLY via `Scripts/autonomous_loop/send_claude_review.py`
  / `send_gemini_review.py`, standalone prompts, `--source-file` for
  every reviewed declaration, full logs under `AgentTasks/model-calls/`.
- Text hygiene: ASCII, UTF-8 no BOM, LF; spaced escape-hatch tokens in
  prose; `pre-commit run` before commits; commit prefix
  `overnight-allmass-202607:` with small, frequent commits.

## 5. Phases and cadence

- **P0 (first hour): orient + harvest sweep.** Read sec-1 docs, harvest
  every IDLE job, refill the fleet to 10 with K-targets.
- **P1: kernel sprint.** K-targets by ledger claim; lit cadence per
  sec 3; cross-review each cycle.
- **P2 (begin by mid-run at the latest): manuscript draft** per
  `MANUSCRIPT_SPEC.md`. Claude drafts, Codex continues K-targets +
  begins section audits as sections land (swap if the ledger says the
  load is inverted).
- **P3 (final quarter): audit.** Full cross-audit; the anchor sweep;
  at least one external review of the manuscript core with embedded
  sources; fix or downgrade every finding; write `HONEST_SCORECARD.md`
  (what was attempted / landed / killed / remains, no spin) and
  `MORNING_REPORT.md` (the user reads this first).

## 6. Success criteria (in order)

1. No dishonest sentence anywhere (manuscript, ledger, scorecard).
2. The manuscript exists, is complete in structure, every anchor
   verified, every section graded, audited by the other agent + one
   external call.
3. Tier-K landings maximized (each guard-pinned).
4. The fleet is harvested clean or documented in-flight at dawn.
