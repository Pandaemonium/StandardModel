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
3. **Attempt the four assembly goals (sec 2), read as rungs of the four
   flagship theorem SUITES (sec 2b).** The goals are the deepest things the
   framework can currently *reach* — a hadron, a generation count, relativity,
   a field equation; the suites (Null Reconstruction / Path-Sum Universality /
   Positive-Code Particle / Mass Resource) are the publishable "grand theorems"
   those rungs and the harvest modules build toward. **Any rung that lands
   becomes the manuscript's new spine; any rung that dies by its kill condition
   is itself a publishable result.** Ambition, not obligation: a run that lands
   two rungs of two goals and keeps the manuscript honest is a win; a run that
   over-claims one rung is a loss whatever it proves. Governing rule (sec 2b):
   every rung returns a **theorem, a counterexample, or a sharpened missing
   axiom** — never "churned."

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

**Source analyses (read-only; this plan distills them — consult for the full
argument, extra rungs, and literature anchors a summary can't carry).** The raw
Pro/Fable responses that seeded this run live in this directory:
- `2026-07-08_FABLE_four-assembly-goals.md` — the source for sec 2 (Goals I-IV),
  with each goal's statement-shape and kill reasoning spelled out.
- `2026-07-08_FABLE_four-theorem-suites.md` — the source for sec 2b (Suites
  A-D): the boxed stretch theorems, full kill lists, and the Builder / Assassin
  / Oracle / Registrar structure.
- `2026-07-08_FABLE_foundations-inputs-to-theorems.md` — the deepest detail for
  **Suite A** (signature forcing two-rung argument; the R/C/H/O division-algebra
  discriminators; the (2,2)-vs-(1,3) reflection-positivity + celestial-sphere
  overdetermination; the `v_g` subluminality derivation; universality z=1; CPT).
  Read before working any Suite A or Goal III rung.
- `2026-07-08_FABLE_theorem-shaped-ontology-sharpenings.md` — the deepest detail
  for **Suites C/D**: mass=energy AM-GM, the EGY identity `V^2 + m^2/m^2_max=1`,
  the Higgs-as-WAY-reservoir template, confinement-as-BRST-code-distance (a
  proof STRATEGY for `ConfinementPositivity`: bound colored-sector norms via the
  area law), modular selection as a GGE, the P-K spherical-code/design family,
  and the **two-twistor prior-art flag** (Penrose/Perjes/Hughston — lit cadence,
  sec 5) that gates P-B.
- `2026-07-08_PRO_finite-information-ontology-reframing.md` — the full
  finite-null-information-dynamics ontology (`I = (A, H_dir, H_int, D, J,
  Gamma, C)`), including the path-conditioned visible state `rho_dir` that
  **Suite B rung B1** formalizes. The reframing itself is [spec]; mine it for
  the B1 object and the codeword/decoding vocabulary, not for claims.

## 2. The four assembly goals (rungs + kills + seed imports)

Each goal is a CHAIN, not a lemma. Land the cheapest killable rung first;
report the kill as loudly as the win. All finite; none touches Clay/continuum.
(Full statement-shapes + kill reasoning: `2026-07-08_FABLE_four-assembly-goals.md`.)

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

## 2b. The four flagship theorem SUITES (the umbrellas the goals feed)

Fable-5's 2026-07-08 stretch analysis reframes the run's ambition: aim not at
four isolated lemmas but at **four theorem suites**, each designed so that
success is a publishable "grand theorem" and failure is a clean no-go that
permanently disciplines the program. The four assembly Goals (sec 2) and the
harvest modules (sec 1) are the RUNGS of these suites, not rivals to them. Do
not renumber the Goals; read each suite as the spine a cluster of rungs builds.
(Full analysis, boxed stretch theorems, all kill lists:
`2026-07-08_FABLE_four-theorem-suites.md`. The deep per-suite detail lives in
the two Fable foundations/ontology files + the Pro info-ontology file — cited
per suite below and indexed in sec 1b.)

**The governing rule (adversarial run).** Every rung must return one of exactly
three things: **a Lean theorem, a counterexample, or a sharpened missing axiom.**
"Churned, unclear" is not an outcome. Structure each attempt around four hats
(one agent can wear several; name the hat in the ledger entry):
- **Builder** — prove it in Lean or reduce it to a finite rational matrix fixture.
- **Assassin** — hunt the counterexample: degenerate case, vacuous hypothesis,
  hidden positivity/nondegeneracy assumption. The sec-3 gate is the Assassin's
  checklist; run it BEFORE claiming, not after.
- **Oracle** — run finite rational fixtures / simulations to guide the Builder.
  FORBIDDEN from being cited as proof (CAS/oracle policy); Oracle output grades
  MEMO at most and lives in the ledger, never the manuscript spine.
- **Registrar** — record the verdict in the ledger at its honest grade:
  `M` / `C` / `MEMO` / `no-go` / `missing-axiom`.

### Suite A — Null Reconstruction Theorem
**Stretch:** finite null information + positive decoding + composable quantum
systems + CP phase  =>  (1,3)-Lorentzian complex two-spinor geometry. Signature,
dimension, causality are OUTPUTS of the null-information carrier, not inputs.
(Deep detail — two-rung signature argument, R/C/H/O discriminators,
celestial-sphere cross-check: `2026-07-08_FABLE_foundations-inputs-to-theorems.md`.)
- **Landed rungs:** `SignatureForcing` (null primitive => indefinite Gram, rung
  1 done); `DivisionDimensionSelection` (composition + continuous abelian CP
  phase => K=C => d=4); `SpectralDistance` (Connes distance recovers edge count).
- **In-flight:** `siglorentz` (RP selects one time direction), `finitecpt`
  (Theta D Theta^-1 = D^#) — harvest both into this suite.
- **NEW rungs to attempt:** (A1, Assassin-first) build a **(2,2)-signature toy
  carrier and TRY to pass slab reflection positivity** — a (2,2) carrier with a
  nondegenerate physical sector that passes OS positivity KILLS one-time
  selection; failing to build one is the evidence FOR it. (A2, stretch)
  operator-to-geometry recovery: full Lorentzian/Connes distance on the T2
  carrier recovering causal ORDER + decoration SCALE (not just edge count), the
  E-slot = order-geometry vs decoration-scale mismatch (Malament split: order
  gives the conformal class free, decorations owe the scale).
- **Kills (any = a result):** a (2,2) carrier passes OS positivity; H admits a
  composable cyclic abelian Bargmann CP invariant; spectral distance degenerates
  to 0/inf/wrong graph; a massive mode saturates v_g=1 (already dead in the good
  direction via `SubluminalBound` — kept as guardrail).

### Suite B — Path-Sum Universality Theorem
**Stretch:** finite null-edge path sums flow to the Dirac/Weyl continuum
universality class, and `Q_A, Q_C, Q_T, E` are its relevant/marginal
coordinates. This is what makes the channel NAMES physics (basin membership),
not structural analogy. Bridge order is finite carrier -> quantum
walk/checkerboard -> Dirac/Weyl continuum -> gauge-coupled (NOT "QCD first").
- **Landed rungs:** `CheckerboardCarrierBridge` (1+1D Dirac walk IS a Krein
  null-edge carrier); `FiniteLevinson` (finite optical theorem);
  `MassPhaseDiagram` (critical line |kappa|=|lambda|).
- **Feeder Goal:** Goal III (relativity at the fixed point) IS the critical-RG
  rung of this suite: exact rational decimation, z=1, nu=1.
- **NEW rungs:** (B1) formalize the **path-sum semantics** — the
  path-conditioned visible state `rho_dir = sum a_h conj(a_h') Omega_{hh'}
  |psi_h><psi_h'|`, with `Omega=1` full interference, `Omega=delta` decohered
  mixture, mass = retained which-null-direction info after tracing hidden
  histories (the `rho_dir` object + its full ontology:
  `2026-07-08_PRO_finite-information-ontology-reframing.md`). (B2) lift the checkerboard bridge to the Cl(4) carrier, then toward
  3+1D (Foster-Jacobson / Mlodinow-Brun quantum-walk `[import]`). (B3) critical
  RG universality as **basin membership** `kappa=lambda => z=1, free-Dirac fixed
  point, non-channel couplings irrelevant`. (B4) finite Levinson upgrade:
  `#bound states = scattering phase winding = reflection-sector index`.
- **Kills:** z != 1 on the massless line; a relevant RG direction OUTSIDE
  {Q_A,Q_C,Q_T,E}; Cl(4) carrier not castable as a known Dirac quantum walk;
  doublers survive the claimed carrier conditions; finite path sums fail to
  reproduce the imported checkerboard/Dirac continuum theorem even in 1+1D.

### Suite C — Positive-Code Particle Theorem
**Stretch:** the physical particle catalogue = the stable positive-sector
eigen-codes of the finite null automaton. Confinement = non-decodability;
binding = compression advantage; protected masslessness = index/quotient/rank-one
codes; generations = inequivalent positive completions (or provably
underdetermined without a new axiom). (C2's functorial confinement + the
BRST/code-distance PROOF STRATEGY for `ConfinementPositivity` — bound
colored-sector norms via the kernel-checked area law:
`2026-07-08_FABLE_theorem-shaped-ontology-sharpenings.md`.)
- **Landed rungs:** `PositiveSectorClassification` (A>0 => A+B^HB>0);
  `ConfinementPositivity` (colored negdef / singlet positive);
  `CarrierClosurePlane` (the carrier binds UNCONDITIONALLY);
  `WindingLowModes` (winding-w background >= w protected modes = finite 't Hooft
  vertex); `FamilyIndexNoGo`/`FamilyRankNoGo` (three generations NOT forced).
- **In-flight:** `finitecpt` (finite CPT antiunitary Theta, spectra
  conjugate-paired => matter-antimatter asymmetry is a state/modular question,
  not a law asymmetry).
- **Feeder Goals:** Goal I (verified hadron) IS the binding+confinement rung;
  Goal II (finite KM) IS the generation-structure rung — supplying the
  rank-fixing axiom (CP phase counting) that `FamilyRankNoGo` showed is required.
- **NEW rungs:** (C1) positive-sector classification as a MAP `carrier data ->
  {positive, balanced, protected-null, indefinite}`. (C2) sector confinement as
  a FUNCTORIAL statement: `(Gauss/BRST quotient) o (positive-sector extraction)`
  kills colored isolated codes, preserves singlets. (C3) index = anomaly:
  `Index(D_K) - Index(D_0) = Wind(K)` + the finite level-crossing / strand-number
  violation statement. (C4) sharpen generations: FIND the missing rank-fixing
  axiom (Goal II's CP counting) OR prove none exists under the framework — do NOT
  fit lepton masses; classify code completions.
- **Kills:** a stable COLORED positive-sector code; a singlet sector that cannot
  be made positive under the stated hypotheses; carrier closure NOT in the
  binding plane for the intended family; winding does not move the chiral index;
  Theta D Theta^-1 = D^# fails for an axiom-satisfying carrier; generation count
  stays n+1 with no natural rank selector.

### Suite D — Mass Resource Theorem
**Stretch:** mass = the positive-sector resource cost of compressing finite null
histories — one structure spanning entropy, concurrence, monogamy, Schur
leakage, modular flow, thermodynamic susceptibilities, criticality, and a
Compton/localization bound. Mass is simultaneously rank defect = entropy =
entanglement = compression cost = 1/localization-length = thermodynamic response.
(Deep detail — mass=energy AM-GM, the EGY identity `V^2+m^2/m^2_max=1`, the
Higgs-as-WAY-reservoir template, modular selection as a GGE, the P-K spherical-
code/design family: `2026-07-08_FABLE_theorem-shaped-ontology-sharpenings.md`.)
- **Landed rungs:** `MassThermodynamics` (Gibbs-Duhem sum rule + critical
  divergence at kappa->lambda); `ModularSelection` (block B as modular
  generator); `SchurSeesaw` (finite seesaw bound); `MassSphericalDesigns`
  (pair disagreement = sin^2(theta/2)); the concurrence/entropy dictionary
  already in the manuscript.
- **Feeder Goal:** Goal IV (gravitational field equation + first law) IS the
  thermodynamic-gravity rung: Clausius `delta<E> = T delta S` along soldering
  variations, Jacobson integrability => the field equation.
- **NEW rungs:** (D1) formalize the **mass resource theory**: free states
  `det P = 0` (rank-one direction states); monotones `det P, S(rho_dir), C^2,
  G^n, cross-disagreement mass`; free operations preserving projective null
  coherence (common spin transformations, gauge relabelings, coherent transport);
  prove the monotonicity + conversion laws. (D2) **entropy monotonicity under
  Schur compression**: `S(rho_dir^eff) - S(rho_dir) >= -C_closure` with
  `C_closure` a SIGNED coherence term (closure is not noise; it can lower mass).
  (D3) **modular selection stretch**: Gibbs state of B => modular flow
  `sigma_t = e^{-itB}(.)e^{itB}` — the generator DERIVED from the state (kill: KMS
  generator on T2 not proportional to B). (D4) **natural small-mass**:
  `zero mode at kappa=lambda => enhanced symmetry constraining kappa-lambda`
  (else critical lightness is fine-tuning unless seesaw is active). (D5) **finite
  Compton bound**: no J-positive one-particle code localizes below `1/gap` — the
  mass gap becomes a length scale (kill: an explicit sub-Compton J-positive
  localized state in the T2 sector).
- **Kills:** resource-monotone violation under allowed operations; entropy
  monotonicity failure NOT explained by signed closure; `sum_X chi_{XY} != 0`;
  no susceptibility divergence at kappa=lambda; KMS/modular generator not
  proportional to B; a sub-Compton J-positive localized state; small mass
  generated generically without protection, criticality, or seesaw.

**The event horizon (keep sharp — it makes the wins credible).** Even if all
four suites land, the framework still does NOT derive: the absolute mass scale,
the Born rule, initial conditions, or the NUMBER of null edges. These are
permanently out of scope (sec 3.5); naming them is part of the honesty gate. The
single most ambitious sentence the run may work to make true — and only at the
grade each rung actually earns — is: *spacetime, particles, forces, and mass are
the decodable geometry, codewords, defects, and compression costs of finite null
information.*

**Priority within a saturated fleet.** The suites do NOT displace sec-2 ladder
economics: still queue the cheapest killable rung of all four assembly Goals
first. Among the NEW suite rungs, the Assassin rungs come first (A1 the (2,2)-OS
attempt, D-kills) — a counterexample found early redirects the whole run — then
the small self-contained M-targets (B1 path-sum semantics, D2 entropy
monotonicity, D5 Compton bound). The stretch reconstructions (A2, B2 3+1D, C2
functorial) are Fable-call / grand-strategy-job scale, not hand rungs.

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

## 5. Literature-search cadence (BOTH agents — AT LEAST every 30 minutes, BINDING)
**Search frequently. The floor is one literature pass every 30 minutes for each
agent, all night — not only before a rung.** A run that goes an hour without a
search is off-cadence; log the gap in the ledger if it happens. This program's
edge is that almost every reframing is an *identification claim* ("X you have is
Y from another field"), so prior art is load-bearing: it supplies proof
strategies, kill conditions, and the citations a referee will demand.
- **Claude:** Neo4j chunk + doc search (`Scripts/lit/neo4j_paper_search.py
  --chunks`, `neo4j_doc_search.py`) plus the scholarly MCP for off-graph hits;
  one line per search in `LIT_SEARCH_LOG.md`.
- **Codex:** run literature searches via **Spark subagents** — dispatch a Spark
  subagent per search topic so lit work runs in parallel with your proof/audit
  lane and never stalls it; the subagent returns the ranked hits + a one-line
  ledger entry. Keep the 30-minute floor per your lane.
- **Standing search targets:** Goal II (Jarlskog/CP-phase counting), Goal III
  (Arrighi-Facchini-Forets discrete Lorentz covariance; Cardy/finite-size
  scaling), Goal IV (Jacobson thermodynamic gravity; teleparallel Einstein),
  Suite A (Baez-Huerta / Manogue-Dray division-algebra Minkowski; Franco-Eckstein
  Lorentzian spectral distance), Suite B (Arrighi discrete Lorentz; the
  **two-twistor particle prior art** Penrose/Perjes/Hughston that Fable flags as
  gating P-B — see `2026-07-08_FABLE_theorem-shaped-ontology-sharpenings.md`),
  Suite D (Cohn-Kumar universal optimality for the P-K spherical-code rung).
- Verify + add any cited source to `Null_Edge_References.md` before the
  manuscript cites it. When a claim depends on a paper's internal content, use
  `--chunks` full text, not the abstract (AGENTS.md).

## 5b. PhysLean — borrow heavily (BINDING for every physics object)
Before formalizing ANY physics object (spinors, Clifford/Pauli/Dirac algebra,
Lorentz group, gauge/hypercharge/anomaly, signature, spectral triples, twistors),
**search PhysLean first and lean on its formalizations** — it is a large, checked
physics library and most of tonight's objects (Suite A signature/Lorentz/spinor,
Suite B Dirac/quantum-walk, Suite C gauge/anomaly, Goal IV geometry) have
PhysLean prior art. Use `lean-explore` scoped `packages=["Physlib"]`
(`search_summary` -> `get_source_code`/`get_docstring`), and cross-check every
convention (metric signature, gamma signs, chirality) against it.
- **CRITICAL — consult and clean-room port, do NOT import.** PhysLean is
  version-pinned away from our `v4.28.0` build (`docs/PHYSLEAN.md`); adding it as
  a dependency breaks the build. "Borrow" = read its definition/theorem, record
  provenance ("clean-room port from PhysLean `<decl>`, convention X"), and
  re-state it against Mathlib in our namespace. Every Aristotle assembly job that
  touches a physics object should be told the relevant PhysLean declaration name
  + its convention so the prover ports rather than reinvents.

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
- Aristotle: **keep the fleet BUSY — usually ~12 jobs loaded** (cap is 10
  concurrent RUNNING per agent-view; keep the pipeline full so the next job
  starts the instant one finishes — check `aristotle list --limit 30` every
  cycle and refill immediately). The 12 must be a MIX: rung/proof jobs,
  **strategy jobs** (whole-goal chains, no-go analyses — at least 2-3 in flight),
  and **audit jobs** (semantic-alignment / non-degeneracy / over-claim sweeps of
  landed or landing work — at least 1-2 in flight). Harvest-first; every assembly
  job is a seed-import package (sec 3.4) + the relevant PhysLean decl to port
  (sec 5b). An idle fleet is a wasted night — if you are under ~12, your next
  action is to queue jobs, not to hand-prove.
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
- **P0 (first hour): orient + harvest + load the fleet.** Read sec-1; finish
  `familyrankfix`; harvest `finitecpt` + the 3 closers as IDLE; **fill the
  Aristotle fleet to ~12 jobs** (sec 6) — the CHEAP rung of all four goals (Goal
  III(b), Goal IV(i), Goal I(1), Goal II(A)) + 2-3 strategy jobs + 1-2 audit
  jobs; kick off the 30-min lit cadence (sec 5) and a first PhysLean sweep
  (sec 5b) immediately.
- **P1: assembly sprint.** Work claimed rungs; keep the fleet at ~12 and the
  30-min lit cadence running; cross-review each cycle; fold landings into the
  manuscript continuously.
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
   every goal/suite rung EITHER advanced OR killed-with-a-published-negative.
   Every rung attempted returned a theorem, a counterexample, or a sharpened
   missing axiom (sec 2b) — logged with its Registrar grade; no churn dead-ends.
4. The fleet is harvested clean or documented in-flight at dawn; the P0 loose
   end (`familyrankfix`) closed. The fleet was kept BUSY (~12 jobs, strategy +
   audit in the mix) and the lit cadence held (a search every <=30 min per agent,
   logged) — PhysLean consulted for every physics object formalized.
