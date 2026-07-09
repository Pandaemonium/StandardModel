# Overnight all-mass run (2026-07-09): RUN PLAN

Planner: Claude (Opus), 2026-07-08 evening, after the 22-job harvest.
Executors: **Claude (Opus) + Codex 5.5, co-equal**, coordinating ONLY via
the append-only `LEDGER.md` in this directory. Prover: Aristotle (fleet up
to 10 concurrent). Goals sourced from Fable-5's post-harvest analysis
(2026-07-08); this plan operationalizes them with rungs, kills, imports,
and the non-degeneracy hygiene the S1-CC saga forced us to learn.

## 0. Mission (manuscript first; the four goals feed it)

1. **Keep "all mass from null edges" fully and honestly supported.** The
   deliverable of record is the manuscript
   (`Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`). It must
   stay true at every sentence under the claim calculus. Every kernel
   landing this run gets its anchor row, guard pin, and honest grade in
   the same commit.
2. **Finish the harvest** (P0): integrate `familyrankfix` (landed, a
   no-go, half-integrated — see sec 1), then harvest `finitecpt` and the
   three closers `siglorentz`/`rigidityaxiom`/`bargmanncp` as they land.
3. **Attempt the four assembly goals (sec 2).** These are the deepest
   things the framework can currently *reach* — a hadron, a generation
   count, relativity, a field equation, one flagship per force-channel.
   **Any goal that lands becomes the manuscript's new spine; any goal
   that dies by its kill condition is itself a publishable result.** They
   are ambition, not obligation: a run that lands two rungs of two goals
   and keeps the manuscript honest is a win; a run that over-claims one
   goal is a loss whatever it proves.

"All mass from null edges" is claimed ONLY in the layered sense: trusted
kinematics (mass = null disagreement, now bidirectional/universal —
`MassNullDecomposition`); guard-pinned finite channel/positivity/binding
theorems; MEMO-grade prose; named open cruxes; continuum/scale/Clay
permanently outside. Saying exactly what is proved is the win.

## 1. Standing state (read before anything)

**What the harvest landed (all M, guard-pinned, in-project green).** Read
`AgentTasks/solo-run-2026-07-08/HARVEST_LOG.md` for the full table. Key
new modules you will BUILD ON tonight:
- `NullEdge/MassNullDecomposition` — the converse (all mass IS null-edge
  disagreement, bidirectional). `NullEdge/MassEnergyBound` (m<=E),
  `Carrier/SubluminalBound` (v_g<=1 iff massless).
- `NullEdge/ChiralIndexProtection` (F6), `NullEdge/BindingEntanglementDeficit`
  (F8, binding=deficit), `NullEdge/SchurSeesaw` (E, finite seesaw).
- `Carrier/CarrierClosurePlane` (F5, **the carrier binds unconditionally**),
  `NullEdge/ConfinementPositivity` (B, colored=>negdef / singlet positive),
  `NullEdge/PositiveSectorClassification` (A PosDef => A+B^HB PosDef, gap>=1),
  `NullEdge/ESlotGeometry` (F7, E-slot transformation law + torsion/nonmetricity),
  `NullEdge/CarrierRigidity` (F2, four-block forced/no-fifth, uniqueness NOT),
  `NullEdge/CheckerboardCarrierBridge` (F1, Dirac walk IS a carrier),
  `NullEdge/WindingLowModes` (F4, winding protects >=w modes = finite 't Hooft vertex),
  `NullEdge/MassThermodynamics` (Gibbs-Duhem + critical divergence),
  `NullEdge/SignatureForcing` (null=>indefinite; rung 2 = RP probe),
  `NullEdge/FiniteLevinson`, `NullEdge/WAYTurnNoGo`, `NullEdge/MassPhaseDiagram`,
  `NullEdge/SpectralDistance` (Connes dist recovers edges), `NullEdge/ModularSelection`,
  `NullEdge/MassSphericalDesigns` (|psi^phi|^2=sin^2(th/2)),
  `NullEdge/DivisionDimensionSelection` (N, composition+CP force C/d=4).
- **NO-GOs (do not relitigate; they are results):** `FamilyIndexNoGo` /
  `FamilyRankNoGo` — three generations NOT forced without a rank-fixing
  axiom; `CarrierRigidity` — four-block split not unique. Superseded:
  `cpholonomy` wedge triple (use the Bargmann object).

**Loose end (finish in P0):** `PhysicsSM/Draft/NullEdge/FamilyRankNoGo.lean`
is copied but UNTRACKED and UNVERIFIED — build it in-project, add its
`PhysicsSMDraft` enforcement edge, record the no-go in the future-directions
doc + harvest log, commit. (Its verdict: `three_generations_not_forced`.)

**In-flight Aristotle jobs to harvest FIRST** (`aristotle list --limit 30`):
`finitecpt` e690c3b3 (CPT: Theta D Theta^-1 = D^#), `siglorentz` 265f327e
(RP selects Lorentzian), `rigidityaxiom` 6f3f56de (the uniqueness axiom for
F2), `bargmanncp` febae797 (CP-oddness + solid angle of the Bargmann triple).
`familyrankfix` 79472461 already downloaded to `/tmp` / the standalone dir.

## 1b. Documents of record (KEEP UP-TO-DATE during the run)

Run-local (continuous): `LEDGER.md` (append-only; every claim/landing/audit),
`LIT_SEARCH_LOG.md` (one line/search), `FOLLOWUP_JOBS.md` (open-piece closers),
and at dawn `HONEST_SCORECARD.md` + `MORNING_REPORT.md`.

Repo-level — update IN THE SAME COMMIT as the work:
- `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` — every landing
  gets its anchor row + honest grade; every C->M upgrade moves the prose.
- `Sources/Null_Edge_Future_Directions.md` — every no-go / superseded /
  conjecture-resolution recorded in the HARVEST RESULTS layer.
- Guard files + `PhysicsSMDraft.lean` — every flagship gets a guard pin and
  an enforcement edge in the same commit (per-module `lake build` is the
  verification of record; `PhysicsSMDraft` is down repo-wide on a pre-existing
  E8/SpherePacking module — note it, do not try to fix it).
- `Sources/Null_Edge_References.md` — verification status for any new source.
- `AgentTasks/solo-run-2026-07-08/HARVEST_LOG.md` — extend for tonight's
  harvests and semantic reviews.
Everything else is read-only context; when in doubt, ledger first.

## 2. The four assembly goals (rungs + kills + seed imports)

Each goal is a CHAIN, not a lemma. Land the cheapest killable rung first;
report the kill as loudly as the win. All finite; none touches Clay/continuum.

### Goal I — The verified hadron (Claude lead)
One finite carrier (fermions on `Cl(4) (x) C^3`, its own closure background +
Gauss constraint) on which, as a chained theorem: (a) the confinement
dichotomy holds ON this 12-dim object (colored sub-sectors negdef, singlet
positive — instantiate `ConfinementPositivity`); (b) the two-particle SINGLET
Fock sector has a bound ground state strictly below the two-constituent
threshold (via `CarrierClosurePlane` + `InteractingTwoBody`); (c) a positive
many-body spectral gap above it; (d) the bound eigenvector's channel budget
is exactly rational with `b_C < 0`, shares summing to 1 (binding = negative
closure share — the Ji-shaped statement). Blocks are 2x2 => budget rational;
reuse the 3-4-5 holonomy trick from P-hf.
- **Rungs:** (1) dichotomy on the witness; (2) singlet 2-particle sector;
  (3) below-threshold ground (near-landed); (4) sector gap by exact
  eigenvalue ordering; (5) eigenvector budget.
- **Kills:** a colored 2-particle state below the singlet (dynamical
  deconfinement); the gap closing; `b_C >= 0` (binding not closure-driven).
- **Seed imports:** `ConfinementPositivity`, `CarrierClosurePlane`,
  `FockMassGap`, `InteractingTwoBody`, `CarrierMassBudget`.

### Goal II — The finite Kobayashi-Maskawa theorem / why three generations (Codex lead)
Supply the rank-fixing axiom `FamilyRankNoGo` demanded: claim it is CP itself,
by phase counting. Mixing map between completion bases = unitary `V` mod
rephasing (diagonal phase tori). (A) **N=2 no-go:** every 2x2 unitary is
rephasing-equiv to a real matrix (constructive, no phase). (B) **N=3
existence:** the Jarlskog quartet `Im(V11 V22 conj V12 conj V21)` is
rephasing-invariant and nonzero on an explicit 3-4-5 rational witness with one
factor of `i` => `J in Q`, exact. (C) **counting theorem:** unremovable-phase
dimension = `(N-1)(N-2)/2`, the corank of an explicit integer rephasing-lattice
matrix (finite linear algebra over Z). Chain: one phase <=> `(N-1)(N-2)/2=1`
<=> `N=3` <=> strand rank `n=2`. Retires `cpholonomy` correctly (Bargmann
object). Hands Q12 triality a target (S3 monodromy on the phase torus).
- **Kills:** extra discrete rephasing invariants at N=2; corank != (N-1)(N-2)/2;
  the carrier's actual overlaps forced real (CP unformulable — a deep negative).
- **Seed imports:** `FamilyRankNoGo`/`FamilyIndexNoGo`, `NullEdgeBargmannPhaseInvariance`,
  and the `bargmanncp` closer result once harvested.

### Goal III — Relativity is born at the fixed point (Claude lead; RG lane)
Convert conjecture Q from oracle to kernel — decimation is EXACT rational
algebra, no limits. On the chain carrier: (a) two-site Schur blocking induces
an explicit rational recursion `R(lam,kap)`; (b) the massless line is
`R`-invariant (upgrade the landed collinear negative control to the
two-coupling statement); (c) linearization of `R` at criticality has
mass-direction eigenvalue exactly 2 (= b^{1/nu}, b=2) => **nu=1 as exact
arithmetic**, xi ~ (lam-kap)^-1; (d) at criticality the pinned dispersion is
conical `w=+-k` (one line from `ContinuumLimit`/`SubluminalBound`) => z=1.
Stretch (e): **exact discrete boost covariance of the massless walk**
(Arrighi-Facchini-Forets `[import]`) on the massless fixture, and covariance
FAILS off the critical line. Then "boost symmetry emerges at criticality" is a
theorem pair. Together (a)-(e) make the S4a channel-name kill runnable.
- **Rungs (cheapest first):** (b) massless-line invariance is afternoon-scale
  — do it first; then (a),(d),(c),(e).
- **Kills:** critical line not `R`-invariant (continuum program dies at the
  root — the most valuable negative); eigenvalue != 2; covariance failing on
  the massless fixture.
- **Seed imports:** `ContinuumLimit`, `SubluminalBound`, `MassGapWitness`,
  `MassPhaseDiagram`, `RGSchurMassWitness`, `FiniteRGFlow`.

### Goal IV — The finite gravitational field equation + first law (Codex lead)
Give the E-slot dynamics. Vary the finite action `S[psi,gamma] = <psi, D#D psi>`
w.r.t. the SOLDERING decorations `gamma_e`, constrained along the null cone
(`gamma^2=0`, Lagrange multipliers — finite matrix calculus). Target:
gamma-stationarity <=> a finite field equation whose LHS lives entirely in the
E-slot contorsion+nonmetricity split and whose RHS is the channel stress (edge-
local budget expectation): `Contract(T+S) = Tcal[psi]` — a finite teleparallel
Einstein equation, mass budget as source. Corollary (i, afternoon-scale, do
first): since the source is the TOTAL budget, the coupling is channel-blind —
**WEP as a trace identity** (everything with mass gravitates identically).
Thermo rung: area = pierced-edge count, entropy via the D5 ensemble at fixed
area; prove the finite Clausius `delta<E> = T delta S` along soldering
variations, and (Jacobson rung) that the field equation is its integrability
condition.
- **Kills:** the gamma-gradient not expressible in the E-slot split (a fifth
  geometric object — would rhyme with the rigidity no-go, important); the
  source containing non-channel stress (WEP fails structurally); an uncancelled
  Clausius term.
- **Seed imports:** `ESlotGeometry`, `CarrierRigidity`, `FiniteCarrierAction`,
  `FiniteQuadraticAction`, `CarrierMassBudget`, `FiniteCanonicalEnsemble`.

## 3. Run hygiene — the S1-CC lesson, made policy (BINDING)

All four goals are existential-heavy. The presentation-existence saga (an
autonomous pass proved a VACUOUSLY DEGENERATE version — Hermitian nilpotent =>
`Q_G=0` — and two review rounds to catch it) must not recur.

1. **Mandatory non-degeneracy fixtures.** Every existential hypothesis SHIPS
   WITH a required nonzero rational witness the final theorem must INSTANTIATE
   ON, stated in the job prompt AND in the theorem statement:
   - Goal I: sector dimensions pinned `> 0` in the statement.
   - Goal II: theorem C accompanied by the N=3 witness with `J != 0` (else the
     count is proved on a collapsed torus).
   - Goal III: `R` exhibited at a concrete non-critical point with
     `R(lam,kap) != (lam,kap)`.
   - Goal IV: the multiplier structure shown nonzero on a varying-soldering
     witness (else `0=0` satisfies everything).
2. **Pre-registered degenerate-proof modes.** For each goal, write down NOW,
   in its job prompt, exactly what the vacuous version looks like (empty
   sector, trivial torus, annihilating blocking, constrained-away variation)
   so the audit gate is mechanical, not judgment-dependent.
3. **Ladder economics.** Each goal = 4-6 rungs, cheapest+most-killable first.
   Goal III(b) and Goal IV(i) are afternoon-scale and tell you within a day
   whether the expensive rungs are worth queueing. Queue the cheap rung of ALL
   four before any expensive rung of one.
4. **Seed the imports.** These are ASSEMBLY theorems — hand each Aristotle job
   the exact seed-import module list (above) so the prover COMPOSES the landed
   pieces rather than reinventing them. Use standalone packages that copy those
   modules' sources (they are Mathlib-only or shallow), or a context pack.
5. **Explicitly NOT in scope** (calibration): continuum Yang-Mills / any
   Clay-adjacent target; absolute mass values; the full spacetime-reconstruction
   mega-theorem (its parts — signature, division, CPT, spectral distance — are
   jobbed; the assembly waits for their verdicts).

## 4. Division of labor (claim in ledger; swap if load inverts)

- **Claude:** P0 harvest sweep + finish `familyrankfix` + harvest the 4
  pending closers; **Goal I** (verified hadron — you landed its parts) and
  **Goal III** (RG/relativity — you landed the dispersion/subluminal core);
  **manuscript DRAFT LEAD** — fold every landing into the manuscript at grade.
- **Codex:** P0 fleet refill; **Goal II** (finite KM — clean finite Z-linear
  algebra, your lane) and **Goal IV** (gravitational field equation —
  variational E-slot dynamics); **AUDIT LEAD** — cross-audit Claude's assemblies
  each cycle (semantic alignment, the four over-claim modes, non-degeneracy
  fixtures, hidden hypotheses), independent anchor sweeps.
- Both keep the fleet saturated with rung jobs (harvest-first); both cross-review
  each other's landings each cycle. Do not duplicate a ledger-claimed rung —
  audit it instead.

## 5. Literature-search cadence (BOTH agents, every cycle)
Neo4j chunk search (`Scripts/lit/neo4j_paper_search.py --chunks`) and doc search
before each assembly rung that leans on prior art: Goal II (Jarlskog/CP-phase
counting), Goal III (Arrighi-Facchini-Forets discrete Lorentz covariance;
Cardy/finite-size scaling), Goal IV (Jacobson thermodynamic gravity;
teleparallel Einstein). One line per search in `LIT_SEARCH_LOG.md`. Verify +
add any cited source to `Null_Edge_References.md` before the manuscript cites it.

## 6. Discipline (constitution-grade; violations = run failure)
- Kernel is truth. Flagship landings need `#guard_msgs` axiom pins + a
  `PhysicsSMDraft` edge, per-module `lake build` green, in the same commit. No
  `s o r r y` outside documented draft handoffs; no `n a t i v e _ d e c i d e`
  in anything claimed M.
- Claim calculus T / T|H / M / C + MEMO everywhere; the four over-claim modes
  (vacuity / hollow telescoping / docstring-outruns-kernel / false shape)
  reviewed before ANY headline — and for assembly theorems, the non-degeneracy
  fixture (sec 3) is a HARD gate: a theorem whose existential is satisfiable by
  the degenerate witness is not landed.
- KILLS — do not relitigate: three generations forced (NO — needs the CP axiom,
  Goal II); four-block split unique (NO — CarrierRigidity); cpholonomy wedge
  triple (superseded by Bargmann); Tr E = pure torsion; Koide Route A;
  "closure disagreement IS gauge energy".
- Ledger protocol: append-only; CLAIM a rung before working it; every entry
  carries the verification commands actually run + an explicit claim boundary.
- No blocking sleeps/polls on external jobs — check inline; recognize
  saturation; use a background watcher for the fleet, not turn-by-turn polling.
- Aristotle: harvest-first; seed-import packages for the assembly rungs; one
  "grand strategy" job per agent per 90 min (whole-goal chains, no-go analyses);
  keep 1-2 audit jobs running whenever capacity allows.
- External model calls (Fable) ONLY via `Scripts/autonomous_loop/send_claude_review.py`,
  standalone packets, `--source-file` for every reviewed declaration, full logs
  under `AgentTasks/model-calls/`. Fable is the run's greatest force-multiplier —
  hand it a WHOLE goal chain (all rungs, all seed sources) and expect success;
  the failure mode is asking too little.
- Text hygiene: ASCII, UTF-8 no BOM, LF; spaced escape-hatch tokens in prose;
  `pre-commit run` before commits; commit prefix `overnight-allmass-202607:`.

## 6b. Fable-5 escalation (Claude places one call every two hours)
Give Fable the LARGEST open thing — a whole goal chain with all seed sources
verbatim, or a full-manuscript audit late in the run. Candidate asks in order:
Goal I whole chain (all five rungs + the five seed modules); Goal III exact-RG
chain; Goal IV field-equation derivation; Goal II counting theorem; a
manuscript over-claim + non-degeneracy audit in P3. Every call ledgered.

## 7. Phases and cadence
- **P0 (first hour): orient + harvest.** Read sec-1; finish `familyrankfix`;
  harvest `finitecpt` + the 3 closers as IDLE; refill the fleet with the
  CHEAP rung of all four goals (Goal III(b), Goal IV(i), Goal I(1), Goal II(A)).
- **P1: assembly sprint.** Work claimed rungs; lit cadence per sec 5;
  cross-review each cycle; fold landings into the manuscript continuously.
- **P2 (by mid-run): manuscript consolidation.** Whatever rungs landed become
  manuscript prose + anchor rows at grade; no-gos into the future-directions
  doc; keep the deliverable honest and current.
- **P3 (final quarter): audit.** Full cross-audit; anchor sweep (grep every
  cited declaration — do not trust the table); the non-degeneracy gate on every
  new existential; >=1 external review of the manuscript core with embedded
  sources; fix or downgrade every finding; write `HONEST_SCORECARD.md` +
  `MORNING_REPORT.md`.
- **Hard audit cutoff: 06:00 local on 2026-07-09.** At 06:00 both agents switch
  to audit/reporting: no new proof fronts; anchor sweeps, over-claim +
  non-degeneracy checks, verification records, scorecard, morning report.

## 8. Success criteria (in order)
1. No dishonest sentence anywhere (manuscript, ledger, scorecard). The
   non-degeneracy gate held on every assembly theorem.
2. The manuscript stays complete and honest; every landing has a verified
   anchor + grade; audited by the other agent + one external call.
3. Assembly rungs maximized (each guard-pinned + non-degeneracy-fixtured);
   every goal EITHER advanced OR killed-with-a-published-negative.
4. The fleet is harvested clean or documented in-flight at dawn; the P0 loose
   end (`familyrankfix`) closed.
