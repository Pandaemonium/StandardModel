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

## 1c. Public Lean packages to lean on heavily (reference-first)

PhysLean remains the physics reference package, but this run should also lean
heavily on the public Lean ecosystem below. Default policy: **consult and
clean-room port theorem shapes, API design, proof strategy, and missing
hypotheses; do NOT add a build dependency during the overnight run unless the
toolchain/version audit is explicit and the dependency is isolated.** Our pin is
Lean `v4.28.0`; many useful packages are near-but-not-equal pins.

- **Kraft / InformationTheory**:
  `https://github.com/elazarg/kraft` (Lean `v4.26.0`, Apache-2.0). Use heavily
  for Suite D's compression/resource layer: prefix-free and uniquely-decodable
  codes, Kraft-McMillan inequalities, and the source-coding lower bound
  `entropy <= expected code length`. This is the closest public Lean analogue
  of "mass as compression cost."
- **testing-lower-bounds**:
  `https://github.com/RemyDegenne/testing-lower-bounds` (Lean `v4.13.0-rc3`,
  Apache-2.0). Use heavily for classical information theory: f-divergence,
  KL/relative entropy, Renyi, total variation, DeGroot information, estimation
  risk, and data-processing proof shapes. Treat as reference/blueprint only
  because the toolchain is far from our pin.
- **lean-quantum**:
  `https://github.com/Hayata-Yamasaki-Group/lean-quantum` (Lean `v4.29.0-rc6`,
  Apache-2.0). Use heavily for Suite B/D finite quantum-information interfaces:
  coordinate-free finite-dimensional Hilbert systems, density operators,
  channels, partial trace, Kraus/Stinespring/Choi representations, and quantum
  entropy/DPI theorem shapes. This is the best public guide for `rho_dir`,
  tracing hidden histories, and channel/resource monotones.
- **SciLean**:
  `https://github.com/lecopivo/SciLean` (Lean `v4.28.0-rc1`, Apache-2.0). Use
  heavily as a reference for variational/action calculus, gradients,
  optimization, differential equations, and executable scientific-computing
  patterns. Do not import tonight: its README says Windows is not officially
  supported and it uses BLAS/FFI plumbing.
- **Plausible**:
  `https://github.com/leanprover-community/plausible` (Lean `v4.32.0-rc1`,
  Apache-2.0). Use as a design reference for Assassin/oracle counterexample
  search over finite fixtures. It is not a proof source, but its workflow is
  ideal for catching vacuity and degenerate existential statements early.
- **CSLib**:
  `https://github.com/leanprover/cslib` (Lean `v4.32.0-rc1`, Apache-2.0). Use
  as a longer-term reference for verified CS/automata/path-semantics APIs,
  especially Suite B path sums and finite algorithmic infrastructure.
- **LeanCamCombi**:
  `https://github.com/YaelDillies/cam-combi` (Lean `v4.31.0`, Apache-2.0). Use
  for graph/probabilistic/extremal/additive-combinatorics proof style and any
  Suite D spherical-code/design or finite-code combinatorics that is not already
  covered by Mathlib.
- **Sphere-Packing-Lean**:
  `https://github.com/math-inc/Sphere-Packing-Lean` (Lean `v4.28.0`,
  Apache-2.0; local Windows-safe fork already exists under
  `AgentTasks/external/`). Use for E8/spherical-code/design and Cohn-Kumar
  adjacent proof architecture. Do not point Windows at upstream directly because
  of the known `Aux.lean` filename issue; use the existing Windows-safe fork or
  standalone copied statements.

**Workflow rule:** before starting Suite B or D rungs, and before Goal IV's
Clausius/Jacobson rung, do a repo/API search over the relevant packages above
and log one line in `LIT_SEARCH_LOG.md` or the ledger. If a theorem shape is
borrowed, record the repo + module/file + convention gap in the task note or
docstring. Translate mathematics, not source text.

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
  **External Lean references:** consult `lean-quantum` for coordinate-free
  finite Hilbert-state/channel APIs if the path-sum density matrix enters this
  rung, and `CSLib` for finite path/automata API ideas. Reference only; do not
  import.

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
  **External Lean references:** consult `SciLean` before inventing finite
  gradient/action notation; consult `lean-quantum` before formalizing density
  operators, partial trace, or channel-stress maps; consult
  `testing-lower-bounds` / `Kraft` before stating entropy, divergence, or
  compression-cost monotones. Reference only unless a separate dependency audit
  says otherwise.

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
- **Lean reference packages:** for B1, lean heavily on `lean-quantum`'s
  density-operator/channel/partial-trace interface before choosing any local
  `rho_dir` representation; use `CSLib` as a reference for finite path/automata
  semantics. If our local object is deliberately simpler, document the
  simplification in the module docstring.

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
- **Lean reference packages:** for D1/D2/D3, lean heavily on `Kraft` for
  compression/source-coding theorem shapes, `testing-lower-bounds` for
  divergence/data-processing/relative-entropy proof shapes, `lean-quantum` for
  quantum channels and entropy/resource monotones, and `Sphere-Packing-Lean` /
  `LeanCamCombi` for spherical-code/design and finite combinatorics. These are
  reference libraries unless explicitly isolated; do not silently introduce
  their dependencies into the main build.

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
- Both keep ~7 jobs live in their own `claude-`/`codex-` lane (harvest-first,
  no filler, 2-hour stall rule — sec 6); both cross-review each other's landings
  each cycle. Do not duplicate a ledger-claimed rung — audit it instead.

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
- **Standing Lean-package targets:** for Suite B/D and Goal IV, search the
  sec-1c package list before inventing a local API. `lean-quantum`, `Kraft`,
  `testing-lower-bounds`, and `SciLean` are not optional flavor text; they are
  first-pass reference libraries for density matrices/channels, compression,
  divergences/data processing, and finite variational calculus. Log useful
  module/file names and version gaps.
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
- Aristotle: **each agent keeps ~7 of its own jobs running** (so ~14 in flight,
  split into two lanes so neither agent is crowded out). **Prefix every job you
  submit with `claude-` or `codex-`** so the lanes are legible in
  `aristotle list --limit 30` — check it every cycle and refill YOUR lane the
  instant a slot frees. Do NOT submit filler just to hit ~7: there is enough
  high-impact work to fill the lanes honestly — but if no proof rung is ready,
  fill with **strategy jobs** (whole-goal chains, no-go analyses) or **audit
  jobs** (semantic-alignment / non-degeneracy / over-claim sweeps), never a
  make-work job. Harvest-first; every assembly job is a seed-import package
  (sec 3.4) + the relevant PhysLean decl to port (sec 5b). Be AMBITIOUS with each
  job (hand it a whole chain, not a scrap).
- **Two-hour stall rule.** If any one job has been RUNNING for more than two
  hours, cancel it and harvest whatever completed work it produced (download +
  salvage any finished lemmas), then re-scope and resubmit the remainder as a
  fresh, smaller job. (If the CLI refuses to cancel a running job — a known
  failure mode — stop feeding/continuing it, harvest its partial output, and
  abandon it; do not let it block a lane slot in your bookkeeping.) Log the
  cancel + salvage in the ledger.
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
- **P0 (first hour): orient + harvest + load your lane.** Read sec-1; finish
  `familyrankfix`; harvest `finitecpt` + the 3 closers as IDLE; **fill your
  Aristotle lane to ~7 jobs** (sec 6, `claude-`/`codex-` prefixed) — the CHEAP
  rung of all four goals (Goal III(b), Goal IV(i), Goal I(1), Goal II(A)) +
  strategy + audit jobs; kick off the 30-min lit cadence (sec 5) and a first
  PhysLean sweep (sec 5b) immediately.
- **P1: assembly sprint.** Work claimed rungs; keep your lane at ~7 (2-hour
  stall rule live) and the 30-min lit cadence running; cross-review each cycle;
  fold landings into the manuscript continuously.
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
   end (`familyrankfix`) closed. Each agent kept ~7 jobs in its own
   `claude-`/`codex-` lane (strategy + audit in the mix, no filler; 2-hour stalls
   cancelled + salvaged) and the lit cadence held (a search every <=30 min per
   agent, logged) — PhysLean consulted for every physics object formalized.

---

## 9. DAY EXTENSION (2026-07-09, daytime) — status and the day's goals

The overnight run met its success criteria early (43 commits by dawn; both
overnight cutoff artifacts drafted: `MORNING_REPORT.md`, `HONEST_SCORECARD.md`).
The user extended the run through today. This section is the daytime constitution;
secs 3 (non-degeneracy), 5/5b (lit + PhysLean cadence), and 6 (discipline,
~7-job `claude-`/`codex-` lanes, buildable-proof rule v3 in every prompt) remain
BINDING. The build slowdown was diagnosed as machine memory starvation and is
FIXED (post-restart: ~15-30s/module) — the overnight HELD list was re-landed.

### 9a. Where the run stands (dawn snapshot)

- **Overnight Goals I-IV: effectively landed.** I: hadron + dynamical confinement
  + rung-5 honest correction. II (Codex): KM phase counting, N=2 no-go + N=3
  Jarlskog witness, incidence corank, family-rank bridge. III: exact RG, 3+4
  channel RG (all four channels relevant), rational boost covariance. IV: WEP
  trace/action bridges (Codex) + field equation, Jacobson equation-of-state,
  gravity-sourced-by-matter, unified mass budget (Claude) — RECONCILIATION of the
  two Goal-IV lanes is a named day task.
- **Manuscript**: retitled **"All Mass Comes from Massless Edges"**; new §2b
  ("Mass is slowed-down light" — velocity operator ±c, zigzag, Zitterbewegung);
  §4a point 4 (channel-RG kill-test survives, all four channels RG-relevant);
  §6/§7/§8/§9 extended; ~20 new anchor rows, all names grep-verified.
- **New fronts opened (user-driven)**: gravity+QFT unification (P-L, 4 modules
  landed + spectral-action-avatar delivered); cosmological constant (Λ doc +
  sec 7b synthesis; 6 Λ jobs in flight/queued); mass-from-massless beyond
  fermions (Higgs-longitudinal, CPT-antiparticle-zigzag delivered, to harvest).
- **Fleet**: 4 Λ jobs running; IDLE harvest backlog ~12 (gravity trio follow-ons,
  prior frontier round, spectral-action-avatar, Codex waves).

### 9b. The day's goals (in priority order)

- **Day Goal A — the Λ suite (the sharpest new physics).** Harvest + land
  L1-L4 (`lambda-unimodular`, `lambda-edge-count`, `lambda-susceptibility`,
  `lambda-conjugacy-uncertainty`, `lambda-count-dichotomy`); then **L6**: one
  graded manuscript section on the cosmological constant (the everpresent handle,
  the exponent prediction `Lambda_rms ~ N^{-1/2}` on the Poisson branch, the
  pre-registered Poisson-vs-hyperuniform FORK with its kill). The fork
  (`which count is conjugate to Lambda`) is where this program can exceed causal
  set theory — treat a hyperuniform verdict as a headline negative, not a loss.
- **Day Goal B — the unification assembly ("one operator, both forces").**
  Reconcile the two Goal-IV lanes (Codex's WEPTrace/WEPActionBridge vs Claude's
  Goal4FieldEquation/GravitySourceMatter — same multiplier pattern, different
  constraints); harvest spectral-action-avatar + teleparallel + holographic; then
  a coherent §7 rewrite: equation-of-state + G=kappaT + one-functional +
  UnifiedMassBudget's `totalBudget = c*det P` as one graded story, and the P-L
  candidate-paper skeleton in future-directions.
- **Day Goal C — "mass from massless" across the full particle table.** Harvest
  Higgs-longitudinal (gauge bosons: the third polarization IS the mass) and
  CPT-antiparticle-zigzag (antimatter = CPT-mirror zigzag) + helicity-chirality;
  extend §2b from fermions to the full table with the honest fermion/boson scope
  split. This closes the title's last scope caveat.
- **Day Goal D — consolidation (the paper is the deliverable).** Clear the
  harvest backlog (~12 IDLE); independent anchor sweep of ALL 2026-07-09 rows
  (Codex); verify + add every new [import] source (Jacobson, ADGS, DESI,
  Chamseddine-Connes-Marcolli, quiver spectral action, Torquato/hyperuniformity)
  to `Null_Edge_References.md` BEFORE the manuscript cites them; refresh the
  scorecard/report at the day cutoff; over-claim audit of §2b + §7 + the Λ
  section (the three newest, boldest sections).

### 9c. Day cadence and cutoff

Same lanes (Claude: A, C, manuscript lead + Λ/unification harvests; Codex: B
reconciliation lead, D audit lead, its own Suite C/D waves). Lit cadence sec 5
continues. **Day audit cutoff: 21:00 local 2026-07-09** — final quarter switches
to audit/report exactly as sec 7's P3 did (EVENING_REPORT.md + scorecard
refresh). Event horizon unchanged (no absolute masses, no Born rule, no V/sign
derivation for Lambda; new fronts obey the same claim calculus).

---

## 10. NEXT CAMPAIGN (post-2026-07-09) — ship, dynamics, forcing

Planned 2026-07-09 after the day run closed all three day priorities (A: the Λ
suite landed and folded; B: §7 reconciled with Codex's landed
`GravityUnificationCapstone`; C: the particle table complete with honest
boundaries). The finite STATIC layer is saturated (~144 kernel-checked NullEdge
modules; both external frontier reviews converge on this verdict). The next
campaign is three different kinds of work: **ship** (N1), **dynamics** (N2/N3),
**forcing** (N4), with two finite completion theorems (N5) as parallel Aristotle
fodder and one standing long arc (N6). Direction approved by the user
2026-07-09 ("think ambitious and impactful").

Everything in secs 3 (non-degeneracy), 5/5b (lit + PhysLean), and 6 (discipline,
claim calculus, guard pins, harvest loop) remains BINDING. The verification of
record is unchanged: per-module `lake build` + term-position placeholder scan +
build-enforced `#guard_msgs` axiom pins, landed as module + `PhysicsSMDraft`
edge + manuscript/paper anchor row (grep-verified names) + ledger, one commit.
**Event horizon unchanged and verbatim:** no absolute mass scale, no Born rule,
no V/sign derivation for Λ, no continuum/Clay claims beyond what N3 actually
lands.

### N0. Session P0 (carry-over, do first every session until cleared)

- Harvest `claude-mass-shell-projectors` (a347e33b) when COMPLETE: energy
  projectors `Lambda± = (pslash ± m)/2m` — complete pair of orthogonal
  idempotents, `tr = 2` each, singular as `m -> 0` (the honest contrast with the
  chiral projectors, which survive `m = 0`). Land per the standard loop; anchor
  row next to `ChiralProjectorsDirac`.
- Then the held follow-on becomes well-posed: **the projector non-commutation
  theorem** `[P_L, Lambda±] != 0 iff m != 0` — "mass is exactly the failure of
  the chirality split and the energy split to commute" (at `m -> 0` limit-form:
  `2m·[P_L, Lambda+] = [P_L, pslash]`, computable exactly). One rational 4x4
  Aristotle job; seeds: `ChiralProjectorsDirac`, the mass-shell module,
  `DiracGammaPhysLean`.

### N1. SHIP P-A — the tight four-claim paper (highest certainty x impact)

**Mission.** Extract the submission-ready paper from the manuscript. Timing is
load-bearing: Douglas-Hoback-Mei-Nissim 2603.15770 shows machine-verified QFT is
having its founding moment; priority in that literature is being set now.

**The spine (all M, guard-pinned, in-tree — anchor names verified 2026-07-09):**
1. *Mass = null-edge disagreement, bidirectional.* `MassNullDecomposition`
   (converse), `DetPUniqueness` (det is forced, not chosen),
   `PauliMomentumPhysLean` (det P = m² in PhysLean's convention),
   `SigmaMapNullEdges` (the σ-map IS a sum of null edges — closes which-P),
   `MasslessEdgeCount` (edge count = rank), `RankCeiling` (the honest rank-2
   boundary).
2. *The carrier square's forced four-channel split.* `CarrierRigidity`
   (four blocks forced, no fifth), `GradedDecompUniqueness` (abstract
   uniqueness layer), `UnifiedMassBudget`.
3. *Cl(4) positive sector with a mass gap.* `PositiveSectorClassification`,
   `FockMassGap`, `ConfinementPositivity` (colored negdef / singlet positive).
4. *Closure binds.* `CarrierClosurePlane` (unconditional),
   `BindingEntanglementDeficit` (binding = entanglement deficit), `Goal1Hadron`.
+ *The tie:* `GroundMassDetFamilyLaw` (§3<->§4 as a family law, not a fit).

**Rungs (mostly writing; Claude draft lead, Codex audit lead):**
- (N1.1) Claim inventory freeze: one page, the four claims + tie, each with its
  exact theorem statement, grade, and axiom footprint. NOTHING graded C in
  title/abstract/claims — C-material moves to a clearly-labeled outlook section.
- (N1.2) Extraction: new `Sources/Null_Edge_P-A_Paper_Draft_v1.md` from the
  manuscript — §§ intro / claim 1 / claims 2-4 / family-law tie / methods
  (verification of record, claim calculus, kill discipline as a FEATURE) /
  outlook. Keep the manuscript as the program document; the paper is narrower.
- (N1.3) Axiom-audit appendix: footprint statement, guard-file pattern, the
  spaced-token scan, per-claim `#print axioms` output reproduced verbatim.
- (N1.4) Prior-art + positioning section (lit rung, verify-then-cite):
  Douglas et al. 2603.15770 (constructive-QFT formalization — the field
  context); Wigner little group [import]; the two-twistor prior art
  (Penrose/Perjes/Hughston) that gates the P-B adjacency; NCG finite triples
  (1804.09482 already verified). Every citation through
  `Null_Edge_References.md` first.
- (N1.5) External audit: >=2 Fable calls via `send_claude_review.py`, one per
  claim pair, `--source-file` for EVERY reviewed declaration; fix or downgrade
  every finding. Then the mechanical passes: full anchor sweep (grep every
  cited name), over-claim review of every section against the four modes.
- (N1.6) Freeze + arXiv packaging (user does the submission; we deliver the
  camera-ready draft + a REPRODUCING.md with the exact build commands).

**Kill/honesty:** a referee-facing sentence that outruns its kernel statement is
a defect regardless of how the theorem reads; the fix is always the sentence.

### N2. The exact-phase path sum — Gaussian-rational checkerboard (start now)

**Mission.** The buildable half of the #1 frontier ("turn the static budget into
a quantum history theory"). Key observation: **the 1+1D checkerboard path sum is
exact arithmetic in Q(i)** — amplitude per history = `(i·eps·m)^corners`, so for
rational `eps·m` every phase and every kernel entry is Gaussian-rational, and
the propagator is a POLYNOMIAL in `eps·m` with corner-count binomial
coefficients. No transcendentals, no limits, fully kernel-checkable under
buildable rule v3 (exact `Q(i)`, not analytic `Complex`).

**In-tree seeds (verified):** `Draft/CheckerboardCornerCountAristotle`,
`Draft/CheckerboardCornerClosedFormsAristotle`,
`Draft/CheckerboardCornerPolynomialAristotle`,
`Draft/CheckerboardKernelClosedFormsAristotle`,
`Draft/CheckerboardSpinorRecursionAristotle`, `NullEdge/CheckerboardCarrierBridge`,
`NullEdge/ZigzagAutomaton`, `NullEdge/ZigzagWeyl`,
`NullEdge/GateD/FiniteCheckerboardTurns`, plus the checkerboard-program corner
conventions + oracle fixtures (see the checkerboard WP task notes before fixing
sign/corner conventions — do NOT re-derive them).

**Rungs (each one Aristotle job, cheapest first):**
- (N2.1) *Amplitude ring + path object.* Represent `Q(i)` explicitly (pairs
  `(re, im) : Q x Q` with explicit mul, or `Zsqrtd (-1)` localized — first job
  DECIDES and documents the representation; no analytic `Complex`). Define
  finite checkerboard histories (null zigzags on the `(t,x)` lattice), their
  corner count, and `amp h = (i·eps·m)^(corners h)`.
- (N2.2) *Path sum = kernel (the payload).* `sum over histories from A to B of
  amp h  =  K(A,B)` where `K` is the landed closed-form kernel
  (`CheckerboardKernelClosedFormsAristotle`). This is the Jacobson-Schulman
  combinatorial identity: group histories by corner count, count with
  binomials, match coefficients. Exact, finite, rational.
- (N2.3) *Path sum satisfies the discrete Dirac recursion* (tie to
  `CheckerboardSpinorRecursionAristotle`): one-step decomposition of the sum =
  the recursion. Together with N2.2: **the propagator IS the sum over null
  histories** — as a kernel theorem, not an analogy.
- (N2.4) *The turn-phase verdict.* `m = 0 => amp` supported on the (at most
  two) straight null histories (massless propagation = no turning); each
  chirality flip contributes exactly the quarter-phase `i`; mass enters the
  amplitude ONLY through corners. Verdict theorem: "mass is the amplitude of
  turning," graded M for the finite identity, `[import]` Feynman
  checkerboard + Jacobson-Schulman for the reading. This realizes the
  path-action reading exactly: the turn channel's PHASE face.
- (N2.5, stretch) *Cl(4) lift.* Four-channel per-history action on the carrier
  (`CheckerboardCarrierBridge` is the bridge); amplitude
  `= prod of per-step channel phases`; reproduce the carrier one-step unitary.
  **Pre-registered kill:** if no four-channel action assignment reproduces the
  landed discrete propagator, the path-sum reading of the channels is WRONG and
  §4a's retreat language activates — report as loudly as a landing.

**Non-degeneracy fixtures (in-theorem, per sec 3):** a t=3 lattice point with
corner count >= 1; kernel entry computed BOTH ways (path sum and closed form),
nonzero, with visible m-dependence; the m=0 collapse witness (exactly the
straight histories survive).

**Lit rung (before the manuscript cites the reading):** verify + add
Feynman-Hibbs (checkerboard problem), Jacobson-Schulman 1984 (path integral for
the 1+1D Dirac equation), and the discrete-Lorentz quantum-walk line
(Arrighi et al., already in the graph) to `Null_Edge_References.md`.

### N3. The continuum limit — the program's single decision point (campaign 2)

**Mission.** Lattice propagator (exact, from N2) -> Dirac propagator (analytic).
Everything graded C — channel names, the Ji correspondence, the Higgs reading —
lives or dies here. **Do not start until N2.2 is landed**; the limit must sit on
the exact object.

**Scope exception (explicit):** N3 is EXEMPT from buildable rule v3's
no-transcendentals clause — this is the analytic campaign. Mathlib
`Real`/`Filter.Tendsto` analysis is the point. Aristotle is used at LEMMA scale
(one convergence lemma per job), not for the whole chain.

**Strategy (statement engineering first — the strategy IS the plan):**
- (N3.1) *Mathlib groundwork inventory* (human + lean-lsp/lean-explore, no
  Aristotle): what exists for binomial/`Nat.choose` asymptotics, power-series
  convergence, `arcsin`/`sqrt` expansions, dominated convergence for series.
  Deliverable: a gap list — which limit lemmas exist vs need proving. Statement
  freeze only after this.
- (N3.2) *Dispersion lane (cheaper, do first).* One-step transfer-matrix
  eigenvalues; prove `omega(k, eps) -> sqrt(k^2 + m^2)` as `eps -> 0` (Mathlib
  asymptotics). **Pre-registered kill:** any other limit dispersion with the
  landed channel couplings kills the channel-name reading — §4a activates.
- (N3.3) *Kernel lane (coefficient-wise — the trick that keeps it finite).*
  The exact kernel is `sum_c N(c; t, x) (i·eps·m)^c`. At fixed order `c` in
  `m`, the corner-count binomial `N(c)` times the lattice scaling converges to
  an explicit rational-coefficient limit — ARITHMETIC limits of binomials, one
  order per job. Define the continuum propagator BY its power series in `m`
  (kernel-friendly; avoids needing named Bessel functions, which Mathlib may
  lack — the series = `J_0`/`J_1` Bessel forms is recorded as documentation
  `[import]`, not needed by any proof).
- (N3.4) *Sum interchange.* The one genuinely analytic lemma: uniform tail
  bound justifying coefficient-wise -> kernel convergence (dominated
  convergence over the finite-support lattice sums).
- (N3.5) *The claim, exactly.* Douglas et al. constructed continuum QFT via
  OS/GJ Gaussian measures; they did NOT prove a lattice -> continuum limit. Our
  claim if N3 lands: "a machine-verified lattice-to-continuum limit of a named
  model (1+1D checkerboard -> Dirac)" — that and no more. Standing lit check
  each session N3 is active: has anyone landed a lattice limit since?

### N4. The generations hunt — force one CP phase, or extend the no-go

**Mission.** The chain is landed as equivalences-to-a-datum
(`KMPhaseCounting`, `FiniteKMCP`, `KMFlagship`, `KMC3FlagshipCapstone`,
`KMFamilyRankBridge`; the no-go `FamilyRankNoGo`): three completions <=> n=2
<=> N=3 <=> exactly one physical CP phase. The open question is FORCING. Hunt
discipline: every candidate principle gets formalized, then tested against the
`FamilyRankNoGo` pattern — is it rank-fixing in disguise (equivalent to
assuming n=2) or genuinely independent? Either verdict is a theorem.

**Rungs:**
- (N4.0, cheap, land first) *The minimality packaging.* `(N-1)(N-2)/2 >= 1 <=>
  N >= 3` is already implicit in the counting theorem; state it as the
  conditional forcing it honestly is: [the framework admits CP violation,
  i.e. J != 0 is realizable] + [minimal completion count among those] => N = 3
  EXACTLY. Grade: **T|H — conditional on two NAMED principles, not a
  derivation**; the manuscript sentence must display both hypotheses. One
  afternoon Aristotle job on the landed counting modules.
- (N4.1) *Finite Sakharov.* Formalize the finite avatar: a 3-sector unitary
  cycle's T-odd rate asymmetry is proportional to the Jarlskog `J` (finite
  matrix identity, rational witness); so [observed matter asymmetry] => J != 0
  => N >= 3. Turns N4.0's hypothesis (a) from an assumption into a physical
  postulate with a finite theorem behind it. Kill: the asymmetry identity has
  non-J terms that can carry it (then CP-violation-existence does not follow).
- (N4.2) *Bargmann nondegeneracy.* State "every nondegenerate composable
  Bargmann-invariant configuration on the completion torus requires >= 1
  unremovable phase" and test whether anything caps it AT one without fixing
  n=2. Expected honest outcome: it forces `>= 1`, not `= 1` — the cap is the
  hard part; report exactly where it fails.
- (N4.3) *The octonionic route (repo home turf, multi-week).* The exceptional
  Jordan algebra `J_3(O)` is rank 3 BECAUSE the octonions end the division
  algebras. Rungs: (a) define `J_3(O)` (27-dim) over the project's XOR-basis
  octonions (`PhysicsSM.Algebra.Octonion.Basic`; every product through
  `ConventionBridge`, all parenthesization explicit — AGENTS.md octonion rules
  are BINDING and the known failure mode here); (b) the Freudenthal
  determinant / degree-3 characteristic identity; (c) a Jordan frame witness:
  3 primitive orthogonal idempotents (`diag` idempotents, explicit); (d) the
  bridge: [completion algebra carries a `J_3(O)` frame] => completionCount = 3;
  (e) the honest forcing test: what, if anything, in the framework selects
  `J_3(O)` as the FAMILY algebra? Must not collide with
  `DivisionDimensionSelection` (which selected K=C for the SPACETIME algebra —
  keep the two selection questions explicitly separate). Kill: realizable-not-
  forced => `FamilyRankNoGo` extends to the most famous candidate — publishable.
- (N4.4) *The systematic no-go.* If N4.1-N4.3 all collapse to rank-fixing in
  disguise or insufficiency: package "three generations cannot be forced by
  {Sakharov, Bargmann, exceptional-Jordan} without a rank axiom" as the
  strengthened no-go paper-let. Pre-register this NOW so the negative is a
  deliverable, not a disappointment.

### N5. Two finite completion theorems (parallel Aristotle fodder, start now)

Both are COMPLETIONS of landed modules, not fresh starts (verified in-tree
2026-07-09):

- (N5.1) *Carrier rigidity wiring.* `GradedDecompUniqueness` already has the
  abstract layer (`decomposition_unique`, and `split_not_forced` as its honest
  boundary). Missing: the wiring to the CONCRETE carrier square
  `2(D#D) = Q_A + Q_C + 2E# + 2Q_T`. Rungs: (a) extract the interface
  hypotheses `decomposition_unique` needs; (b) prove the concrete four-block
  split satisfies them on the Cl(4) carrier (seeds: `CarrierRigidity`,
  `UnifiedMassBudget`, the GateYM guard files); (c) instantiate: THE four
  channels are a property of the object, not the presentation. Kill: a
  genuinely distinct split satisfying all interface properties — then
  `split_not_forced` strengthens instead. Either way a theorem.
- (N5.2) *The WAY dichotomy (the finite Higgs mechanism).* `WAYTurnNoGo`
  already landed the negative half (`way_nogo`,
  `chirality_requires_nontrivial_ancilla`). Missing: the CONSTRUCTIVE half —
  an explicit finite charge-coherent ancilla (dim >= 2 reservoir, the
  Higgs-as-WAY-reservoir template from
  `2026-07-08_FABLE_theorem-shaped-ontology-sharpenings.md`) implementing the
  chirality gate with EXACT isospin conservation on system+ancilla; concrete
  unitary witness in `Q` or `Q(i)`. Verdict: the turn channel operates IFF
  coupled to a charge-coherent reservoir — the finite Higgs mechanism as a
  dichotomy at M grade; upgrades §5 from MEMO to structure. Kill: no
  finite-dim ancilla works — a strengthened no-go, also publishable.

### N6. The verified interacting hadron (standing long arc, one job at a time)

Landed base: `Goal1Hadron`, `Goal1Confinement`, `FockSecondQuantization`,
`InteractingTwoBody`, `FockMassGap`, `DerivedInteraction`, `ConfinementPositivity`.
Next rungs, in order, each gated on the last: (a) three-constituent
(baryon-like) singlet bound state strictly below every colored threshold;
(b) many-body spectral-gap ordering above it; (c) the bound eigenvector's
channel budget exact and rational with `b_C < 0` (Goal I rung 5's honest
correction, revisited at the many-body level); (d) two-hadron scattering sector
+ the `FiniteLevinson` tie (bound-state count = phase winding). The landmark if
the arc completes: "first machine-verified interacting finite QFT with a
confinement dichotomy and a bound state" — independent of the null-edge
ontology, valuable to verified physics as a field.

### N7. Sequencing, lanes, and cadence

| When | Work | Shape |
|---|---|---|
| Session P0 | N0 harvest + projector commutator | harvest loop + 1 job |
| Now (week 1) | N1.1-N1.4 extraction; N2.1-N2.3; N5.1-N5.2; N4.0 | writing + 5-6 Aristotle jobs |
| Week 2 | N1.5-N1.6 audits + freeze; N2.4; N4.1-N4.2 | Fable calls + 3-4 jobs |
| Campaign 2 | N3 (after N2.2 lands); N4.3 octonionic | analysis lane + octonion lane |
| Standing | N6 (one job at a time); N4.4 if the hunt collapses | background |

- **Lanes:** Claude — N1 draft lead, N2, N3, N0; Codex — N1 audit lead, N4,
  N5; both cross-review landings per the sec-6 discipline. Fleet sizing follows
  the work: with the static layer saturated, ~7 jobs is a CAP not a target —
  no filler; an empty lane is honest when the frontier is writing or analysis.
- **Lit cadence:** per-session floor (not 30-min — the day-run cadence was for
  saturated fleets): one pass per active goal per session, logged; plus the N3
  standing prior-art check and N1.4's verify-then-cite rule.
- **Honesty invariants (verbatim from the day run, still the whole game):**
  claim calculus on every sentence; non-degeneracy witness on every
  existential; the four over-claim modes reviewed before any headline; kills
  pre-registered and reported as loudly as landings; the event horizon named
  in every deliverable.
