# The Measure Problem: status and breakthrough paths

Status: consolidation + strategy document, 2026-07-03 (claude). This is the
first document dedicated to the program's declared central open problem. It
consolidates every statement about the growth measure scattered across the
round documents, states the entrance requirements a candidate must satisfy as
one checklist, ranks the candidate classes, defines what "breakthrough" means
in tiers, and lays out the concrete near-term program.

Same-day update (2026-07-03, second pass): section 4(e) records the first
fully specified candidate - SCG, skeleton-conditioned checkerboard growth
(external analysis contribution, reviewed and verified in-repo: the Gram
lemma checked by hand, the mixture-CMI dichotomy reproduced independently).
Gates MP1' (upgraded, v0 executed), MP2 (rescoped), and MP4 (new: the BC-Q
freeze) updated accordingly.

Same-day update (2026-07-03, third pass): the Gram/back-reaction lemma
package (Aristotle job 970e20fe) is HARVESTED and integrated -
`PhysicsSM/Draft/NullEdge/GateMP/SCGGramPositivity.lean`, all four theorems
kernel-checked, axiom-clean, no statement changed; aggregator
`GateMP.lean` added (`lake build PhysicsSM.Draft.NullEdge.GateMP`, 8027 jobs
green). R4 in the SCG grading table (section 4(e)) upgrades from "T once
970e20fe lands" to **T, done**. The necessity direction of the back-reaction
criterion turned out to have a cleaner proof than reviewed: applying the
sufficiency lemma twice via `deformed (deformed W A) A^{-1} = W` (exact under
full support), rather than a direct quadratic-form argument on `W`.

Same-day update (2026-07-03, fourth pass, per Codex review of the next-steps
ordering): gate MP4 (the BC-Q freeze) is FROZEN in
`AgentTasks/nerd-gate-mp4-bell-causality-quantum-freeze-2026-07-03.md`; SCG's
grading (section 2, section 4(e)) is updated to reflect entrance requirement
R2 satisfied under this definition. Gate F2's second-round test (F2.1,
the democratic-spurion coupling family) is separately FROZEN, unexecuted, in
`AgentTasks/nerd-gate-f2.1-preregistration-freeze-2026-07-03.md`.

Where it sits: supporting document for the growth sector of
`docs/NERD_ROADMAP.md` (gates G1-G2, D0-D8); consolidates
`Sources/nrqg-round4-tower.md` (section 9: the measure as irreducible-unless),
`Sources/nrqg-round5-audit-and-commitments.md` (capacity race; F-M2 repair),
`Sources/nrqg-round6-missing-pieces.md` (null-cone monotones; vacuum Markov
property; the A_s one-number challenge; SOC note),
`Sources/nrqg-round7-parameters.md` (Tier 3 bins),
`Sources/nrqg-round8-adversarial-synthesis.md` (two-column architecture and
the canonical problem statement), `Sources/it-from-commit-ontology-essay.md`
(sections 7-8), and `Sources/Null_Edge_Dynamics_Gate_D.md` (the three
dynamics routes, which are measure-candidate scaffolding).

Claim grades per the Round 8 calculus: `T` / `T|H` / `M` / `C`, originality
tags `[orig]` / `[comp]` / `[import]` / `[interp]`. External results cited
from memory are flagged in the verification-debt register (section 8) and
must be source-verified before any paper use.

## 0. The problem, stated

Plain form:

> The theory says the universe is a growing network of null edges carrying
> spinor and transport decorations. Every theorem proved so far holds for ANY
> such network. The missing object is the LAW: the probability rule that says
> which growth steps happen. That rule is called the measure, and without it
> the framework has kinematics, consistency conditions, and identities - but
> no dynamics and no numbers.

Canonical form (Round 8, two-column architecture):

> **Exhibit a growth measure over decorated null graphs whose coarse-grained
> (RG) fixed point exists and satisfies Column B** - the stack of
> exact-symmetry consistency theorems (quantum mechanics over C, Lorentz
> invariance, the node-bootstrap forces, spin-statistics, the gravitational
> equation of state) that the infrared limit must obey.

Two structural facts frame everything below:

1. **All other open problems are subordinate to or independent of this one**
   (Round 8, section IV.1). The measure owns every absolute number: alpha's
   value, the electron mass, the electroweak/Planck hierarchy, theta_QCD,
   the primordial amplitude, and (in its history) Lambda's magnitude.
2. **Individual falsifiability waits on it** (Round 8, Attack 3.1). Today the
   program is falsifiable only as a member of the discrete/informational
   class; the definition of "solving the Measure Problem" includes delivering
   at least one measurable number no sibling theory shares.

The honest third possibility, held open since Round 4: the measure may be
**bedrock** - environmental data not derivable from anything. A proof of
underdetermination (the constraints do not pin it) would itself be a major
result; see tier B-N in section 2.

## 1. Why it is hard (three compounding walls)

1. **The space is enormous.** "A probability rule for growing decorated
   graphs" has no useful parametrization yet; the candidate classes in
   section 4 are the only structured families the program knows.
2. **The requirements pull against each other.** The rule must be random
   enough to leave no preferred frame per sample (pixels hidden; C3), yet
   structured enough that exact-looking conservation laws, gauge structure,
   and the null-Markov fingerprint emerge at the fixed point.
3. **Continuum limits are the hardest mathematics in the subject.** Proving
   an RG fixed point exists and equals a named continuum theory is
   Millennium-Prize-adjacent even for well-understood lattice models. This is
   why the breakthrough ladder (section 2) puts a 1+1D free-sector result far
   below the full problem: it is the first rung that is actually provable.

## 2. What "breakthrough" means: the ladder

Pre-registering the tiers now prevents later grade inflation. Each tier names
its deliverable and its verification mode.

- **B-2 (bronze; attemptable this quarter).** The A_s one-number challenge
  (existing Gate G2'): produce the primordial amplitude `A_s ~ 2 x 10^-9`
  from a counting fluctuation in ANY natural, pre-registered allocation
  scheme for network growth. Verification: reproducible numerics against a
  frozen scheme class. Any mechanism that hits the number earns the right to
  be developed; misses are filed nulls.
- **B-1 (a real object exists).** A decorated growth rule - even in 1+1D -
  that simultaneously satisfies: label invariance (discrete general
  covariance), Bell causality of the rule, quantum-measure structure
  (strongly positive decoherence functional, not a classical Markov chain),
  and Lorentz invariance in distribution. No continuum claim yet.
  Verification: finite mathematics; substantial parts Lean-able.
  FIRST ENTRANT: the SCG candidate (section 4(e)). Gate MP4 (Bell causality
  for quantum measures, "BC-Q") is now FROZEN
  (`AgentTasks/nerd-gate-mp4-bell-causality-quantum-freeze-2026-07-03.md`):
  SCG's decoration layer satisfies BC-Q by construction (its per-step
  amplitude is a product of local precursor-only factors), conditional on
  the imported classical skeleton satisfying ordinary Bell causality
  (debt-flagged). BC-Q is stated as a SUFFICIENT operational definition for
  factorized constructions, not a claimed resolution of the general quantum-
  Bell-causality problem - see the freeze's section 5 for the explicit scope
  limits. SCG is therefore graded complete at the B-1 tier under this
  definition.
- **B0 (the first genuine breakthrough).** B-1 PLUS a provable
  coarse-grained limit reproducing a known continuum theory in some
  dimension. The realistic first target: the 1+1D free Dirac vacuum - i.e. a
  measure whose free sector reproduces the checkerboard/null-step walk, whose
  dispersion and coherence identities are now kernel-checked in-repo
  (`GateI1/MassCoinBridge.lean`), and whose emergent vacuum passes the
  null-Markov fingerprint test (section 3, R7). This tier is conceivable with
  current tools because the free-fermion layer is classically simulable
  (matchgates) and the Peschel/QNEC toolkit (`Scripts/qnec_pilot.py`) already
  exists.
- **B+1 (gold; decades-scale).** A measure whose 3+1D fixed point satisfies
  Column B - the full problem. Nothing below pretends to schedule this.
- **B-N (the negative breakthroughs; legitimate and valuable).**
  (i) A no-go: prove a candidate class CANNOT work (first target: classical
  growth measures, section 5, MP2). (ii) An underdetermination proof: the
  Column B constraints leave a continuum of measures - relocating the
  measure to the environmental/bedrock bin with a proof instead of a shrug.
  Either outcome is a filed deliverable under the Round 8 lifecycle.

## 3. The entrance requirements (what any candidate must satisfy)

Consolidated from Rounds 2-8; this checklist is the document's core. Each
requirement carries its source and grade. A candidate that fails any [T]-row
is dead on arrival; the [C]-rows are the program's own conjectures and could
in principle be revised.

```text
R1  Label invariance (discrete general covariance): the growth ORDER is not
    physical; only the resulting order/decoration structure is.
    [import: sequential-growth literature]
R2  Bell causality of the RULE: no growth step may depend on
    spacelike-separated regions of the graph. [import: same]
R3  Lorentz invariance in distribution; per-sample anisotropy hidden.
    Discreteness signatures may live ONLY in fluctuation channels (swerves,
    everpresent-Lambda dynamics, horizon-scale non-Gaussianity) - never in
    dispersion. [T for sprinkling kinematics (BHS); C for growth; ties to
    commitment C3]
R4  Quantum, not classical: the rule must be a quantum measure (strongly
    positive decoherence functional or equivalent), compatible with
    purification/unitarity (Level 0; commitment C2). Classical stochastic
    growth can only ever be an approximation - and MP2 (section 5) aims to
    upgrade this from preference to theorem via Bell/Tsirelson.
R5  Decorations grow WITH the graph: edge spinors and transport labels are
    part of the growth law, not painted on afterward; the gauge/code layer
    (charges = syndromes) must emerge or be consistently imposed. [M/C,
    program-specific]
R6  Soldering compatibility: the rank-one edge statistics must be compatible
    with Herm_2(C) soldering, i.e. with 3+1 dimensions at the fixed point
    (the dimension chain is conditional on exactly this). [T|H]
R7  THE FINGERPRINT - vacuum Markov property on null cuts: the emergent
    vacuum must saturate strong subadditivity on null slices (each null
    slice a complete checkpoint; Petz recovery perfect there and only
    there). This is a THEOREM about the real world's vacuum and therefore a
    sharp NECESSARY condition on any candidate's coarse-grained limit -
    currently the single most discriminating known test. [T for the
    continuum statement; the test protocol is M]
R8  RG monotones: coarse-graining must flow downhill in c/F/a; the fixed
    point is constrained by the null-deformation monotones (this is what
    "Column B" enforces dynamically). [T inventory; C for the graph flow]
R9  Algebraic type flow: graph algebras are type I; the continuum limit
    with gravity/observer should pass through type II (crossed product),
    recovering type III only as G -> 0. (The F-M2 repair; the analytic long
    pole.) [C with a modern route]
R10 Phenomenological anchors: everpresent Lambda ~ +-1/sqrt(V) with the
    spatial-inhomogeneity problem (F-SPAT) addressed - the program's own
    conjecture is that transport decorations supply the needed correlations;
    the capacity race (S_early <= O(N log d); room outruns disorder); the
    A_s number. [C/S; C4 is live at DESI]
R11 A distinguishing number: at least one measurable prediction no sibling
    discrete theory shares. [definitional, from Round 8]
```

Boundary conditions from below (new since today, and load-bearing): any
candidate's FREE sector is no longer negotiable. In 1+1D it must reproduce
the null-step walk - dispersion `cos(omega a) = cos(ka) cos(mu a)`, exact
coherence `|sin(mu a)|/sin(omega a)`, coin = Pluecker wedge - all now
kernel-checked (`MassCoinBridge`). In 3+1D (tetrahedral regulator) it must
reproduce the Gate C1 free chiral release with its GW structure and index
calculus (Gates C1-C2, kernel-checked). The measure search now has hard,
machine-checked acceptance tests at the free level. [M] [orig]

## 4. Candidate classes and their status

**(a) Classical sequential growth (CSG), undecorated.** [import] The
Rideout-Sorkin classification: Markovian, label-invariant, Bell-causal growth
dynamics on causal sets (transitive percolation and its generalizations).
Status: the covariance/causality TEMPLATE for R1-R2, and the source of the
originary/cosmological-cycle intuitions - but it fails R4 (classical) and R5
(no decorations), and manifold-likeness at large scale is unproven for any
member. Verdict: quarry, not candidate.

**(b) Quantum sequential growth.** [import, open externally] The
histories-native quantum measure (decoherence functional, strong positivity)
is the right formalism (it is also Gate B1's second route to the Born rule),
but no quantum growth dynamics with R1-R4 has ever been constructed, by
anyone. This is the genuinely open mathematics at the field's frontier.
Verdict: the right target class for B-1; expect to have to build, not
import.

**(c) The program's decorated routes (Gate D).** [orig scaffolding] The
three routes of `Sources/Null_Edge_Dynamics_Gate_D.md`:
- **Equilibrium / max-ent (D1-D2):** dynamics as a maximum-entropy fixed
  point; "Poisson = max-ent at fixed density" reframes R3 as an entropy
  statement, with geometry as the Lagrange multiplier. Natural home of the
  finite action principle (`S = S_null + S_vertex + S_holonomy +
  S_visibility`, ontology document). Strength: closest to provable
  statements now. Weakness: equilibrium is not growth; needs the
  stationarity/growth cross-check (D4/D6 already in the roadmap queue).
- **Modular generation (D3):** time from modular flow; constrained by the
  finite hsm-triviality no-go already banked. Strength: ties to the
  boost-Gibbs/Bisognano-Wichmann assets. Weakness: most abstract.
- **Coin-decorated sequential growth (D4-D6):** grow the checkerboard with
  its mass coin as part of the rule. Strength: THE natural B0 vehicle - its
  free sector is exactly the now-verified walk, so the acceptance test is
  already kernel-checked. Weakness: the quantum-measure layer (R4) on
  growth histories is unbuilt.

**(d) Bootstrap-first (constrain, do not construct).** [comp] Treat Column B
plus R1-R10 as functionals on measure space and squeeze: in the best case
the constraints pin the measure up to finitely many parameters (Round 4's
"deepest question the framework can pose about itself"); in the honest worst
case they prove underdetermination (tier B-N). Strength: every constraint
added is progress regardless of outcome; this document is its first
instrument. Weakness: needs a parametrized family to squeeze - i.e. it
feeds on (c).

**(e) SCG - skeleton-conditioned checkerboard growth (the first entrant,
2026-07-03).** [comp/orig; external analysis contribution, reviewed and
verified in-repo] Factorize the measure: a classical layer owns geometry, a
quantum layer owns decorations, interleaved per growth step so R5 holds in
letter.

- *Skeleton layer* [import, debt-flagged]: a label-invariant, Bell-causal
  CSG law on random 2D orders. The structural gift of 1+1D: a 2D order IS a
  pair of linear orders, so the (u, v) null coordinates are intrinsic to the
  poset - the checkerboard is not imposed, it is what a 2D order is; uniform
  random 2D orders correspond to causal-diamond sprinklings, so R3 rides on
  the sprinkling theorem.
- *Decoration layer* [comp/orig]: conditional on skeleton `s`, path
  amplitudes; on the regular checkerboard this is EXACTLY the verified walk
  (coin `e^{-i mu a sigma_x}`; free-sector acceptance test passes by
  construction via `MassCoinBridge`). The random-2D-order generalization
  follows the Johnston massive-series template [C, debt-flagged] and is the
  genuine D4/D6 work.
- *The decoherence functional*:
  `D(g, g') = sum_s P(s) 1[g, g' in s] A_s(g) conj(A_s(g'))`.

Three structural results, status:

1. **Gram positivity (strong positivity is FREE).** `D` is a Gram kernel
   (`A(g) = (sqrt(P(s)) A_s(g))_s`), hence PSD on every finite event
   partition - R4's positivity costs nothing for any candidate built this
   way, deleting the numerical strong-positivity probe from the D4/D6 queue.
   PROVED (Aristotle job 970e20fe, harvested; verified by hand in review, no
   statement changed):
   `PhysicsSM/Draft/NullEdge/GateMP/SCGGramPositivity.lean`
   (`gramDecoherence_posSemidef`, `gramDecoherence_event_posSemidef`), kernel-
   checked, axiom-clean. Connects to the known history-Hilbert-space
   characterization
   [import, debt-flagged: Dowker-Johnston-Sorkin lineage].
2. **The back-reaction criterion (standing design constraint).** Deforming
   the factorization to decoration-dependent skeleton weights
   `D = W(g,g') A(g) conj(A(g'))`, positivity holds IFF `W` is a PSD kernel
   on the support of `A` (diagonal congruence / Schur). Consequence, binding
   on ALL future interacting extensions: coupling geometry to matter
   preserves quantum-measure structure exactly when the geometry-dependence
   enters as an overlap of geometry records - back-reaction as
   decoherence-by-record. PROVED (same package/module as (1);
   `deformed_posSemidef_of_posSemidef`, `deformed_posSemidef_iff`); the
   necessity direction reuses sufficiency twice via the exact identity
   `deformed (deformed W A) A^{-1} = W` under full support, cleaner than the
   quadratic-form argument originally sketched.
3. **MP2 placement.** The classical no-go excludes fully classical dynamics
   INCLUDING decorations; SCG (classical skeleton, quantum decorations)
   evades it by construction and is the minimal surviving quantum extension.
   Purification (C2) comes along: fixed-skeleton evolution is unitary, the
   mixture is a random-unitary channel purified by the skeleton register.

Honest gaps, pre-registered: R2 needs the BC-Q definition frozen (gate MP4 -
a field-frontier gap, not an SCG defect; SCG satisfies the natural transfer
since conditional amplitudes depend only on precursors). NO back-reaction
(the factorization IS the statement "geometry does not respond" - fine for
B0, disqualifying for B+1, with result 2 the only known constraint on fixing
it). No absolute numbers. R9 untouched. Cylinder-event extension inherited.

**The pre-registered kill test (R7 as a dichotomy).** For fixed skeleton the
decoherence functional is rank one, so the emergent vacuum is a classical
MIXTURE over skeletons of (asymptotically Markov) pure states - and Markov
saturation is NOT preserved under mixing. Verified in-repo, twice: an
independent qubit-toy reproduction (mixture of exactly-Markov components:
CMI 0.500 bits at full routing swap - O(1) violation - vanishing
quadratically as components merge; `scratchpad/cmi_mixture_check.py`), and
the Gaussian-chain pilot (gate MP1', below). SCG therefore passes R7 IFF the
skeleton-conditional vacua CONCENTRATE as density grows, with the mixture
CMI on null cuts tracking the per-skeleton baseline to zero; if it instead
stalls at O(1), the factorized class is dead and route (c)'s equilibrium
branch promotes to primary. Bonus if it passes: the subleading CMI scaling
law on null cuts is a discreteness signature in a pure fluctuation channel -
an R11-CANDIDATE (simulation-level discriminator; an observational proxy
would be needed before it counts as R11 proper).

Grading table (per the review): R1 [T conditional on the skeleton import],
R3 [T|H via 2D orders], R4 [T, proved and kernel-checked], R5 [T in interleaved
form], R6 [n/a in 1+1D], free sector [M, kernel-checked]; R2 [satisfied under
the frozen BC-Q definition, gate MP4, conditional on the imported skeleton's
classical Bell causality];
R7 pre-registered with quantified failure mode.

## 5. The near-term program (what would actually be needed)

Ranked by (value x tractability), with verification mode and effort. Gate
names reuse the existing ladder where they coincide; only genuinely new
gates get MP-numbers.

1. **MP1' - the concentration test (upgraded from MP1; v0 EXECUTED
   2026-07-03).** The SCG analysis sharpened the fingerprint diagnostic into
   a two-curve kill test: measure BOTH the per-skeleton baseline
   `E_s[CMI_s]` (discretization curve, Peschel) and the mixture curve
   `CMI(rho_mix)` (exact, via region-local Gaussian-state reconstruction so
   no Jordan-Wigner string subtleties enter middle-block entropies).  Kill
   criterion: the mixture curve must TRACK the baseline to zero as density
   grows; stalling at O(1) kills the factorized class.  v0 calibration
   (`Scripts/mp1_concentration.py`, disordered-mass stand-in ensemble,
   paired common-random-number estimates): reconstruction self-checks at
   1e-15/1e-12; excess exactly 0 at zero spread; excess grows superlinearly
   (effective exponent ~2.6 between the two resolved spreads, small
   coefficient).  Two pre-registered findings for v1: (i) with non-Markov
   components the excess is NOT sign-constrained and at small spread sits
   below Monte-Carlo resolution - hence the kill criterion targets the
   mixture curve, not the excess sign, and v1 needs paired estimators
   (implemented) plus larger panels; (ii) i.i.d. site disorder self-averages
   strongly - the correlated geometry of genuine sprinkled 2D orders, with
   the Sorkin-Johnston state as the per-skeleton vacuum [debt-flagged], is
   the real object, together with null-cut geometry and a stencil-aware
   statement (Round 5 lesson).
2. **G2' - the A_s one-number challenge (existing gate; pre-registration
   then numerics; days-to-weeks).** FIRST freeze the class of "natural
   allocation schemes" (pre-registration discipline - without the freeze any
   hit is numerology), THEN scan. Either outcome is filed. A hit is tier
   B-2 and would be the program's first cosmological number.
3. **MP2 - the classical no-go (new gate; Lean-able; small).** Formalize: a
   classical (Kolmogorov, Bell-causal) growth measure induces a local
   hidden-variable model for spacelike-separated decoration observables,
   hence CHSH <= 2 for the emergent correlations; since the intended fixed
   point saturates Tsirelson, classical growth is excluded. Upgrades R4 from
   axiom-preference to theorem, with the standard escape clauses
   (superdeterminism, retrocausality) stated at the usual strength. Finite
   CHSH <= 2 for factorizable models is Aristotle-friendly; the graph-native
   wrapper is the program's contribution. Deliverable: one draft module plus
   a short note.
   RESCOPE (post-SCG): state the theorem as excluding fully classical
   dynamics INCLUDING decorations; SCG (classical skeleton, quantum
   decorations) evades it by construction and is the minimal surviving
   quantum extension - exactly what a B-1 vehicle should be.
4. **MP4 - the BC-Q freeze (new gate; definition work; small).** DONE
   (2026-07-03): frozen in
   `AgentTasks/nerd-gate-mp4-bell-causality-quantum-freeze-2026-07-03.md`.
   BC-Q = classical skeleton Bell causality (unchanged) plus decoration
   locality (single-step amplitudes factor through precursor-only local
   kernels). Checked against the classical limit (trivial decoration alphabet
   reduces BC-Q to ordinary Rideout-Sorkin BC exactly) and confirmed
   non-vacuous (excludes spectator-dependent amplitude rules). SCG satisfies
   BC-Q's decoration clause by construction. Explicitly NOT settled:
   uniqueness of BC-Q as THE quantum generalization (a weaker
   decoherence-functional-level condition may exist and is the remaining
   field-frontier question); back-reacting extensions need their own check
   on the weight kernel `W`. Formalization deliberately deferred pending
   review of the prose definition (not sent to Aristotle this pass).
5. **D4/D6 extension - the 1+1D decorated-growth toy (existing gates; the
   B-1/B0 vehicle; weeks-to-months).** Build the coin-decorated sequential
   growth rule on the checkerboard whose free limit is the verified walk:
   (i) define the decorated growth moves and the label-invariance quotient;
   (ii) the decoherence-functional layer comes with strong positivity FREE
   for the factorized class (`GateMP.SCGGramPositivity`, kernel-checked) -
   the numerical positivity probe survives only for back-reacting
   deformations, which the proved PSD-kernel criterion governs; (iii) verify
   the free sector against `MassCoinBridge` identities; (iv) run MP1' on its
   vacuum. Each sub-step is a filed result even if a later one fails. This
   is the critical path to B0.
6. **MP3 - the uniqueness squeeze, toy version (new gate; analysis-light;
   opportunistic).** In 1+1D, with the family from item 4 parametrized:
   which of R1-R10 cut the parameter space, and by how much? Even "the
   free-sector constraint plus Lorentz-in-distribution leaves an
   N-parameter family" is a publishable shape of answer and the first data
   point for bootstrap-first (d).
7. **F-M2 route - the type II flow (existing failure-mode repair; hard
   analysis; long horizon).** Exhibit the graph -> type II crossed-product
   flow on the simplest half-strand algebra. Not rate-limiting for B0, but
   it is the analytic prerequisite for ever claiming B+1 honestly.
8. **P10 / C4 - keep the one data contact alive (existing; phenomenology).**
   The everpresent-Lambda vs DESI analysis, rescoped per F-SPAT: does
   transport-decoration structure cure or worsen the spatial-inhomogeneity
   problem, and what parameter space survives? This is where the measure
   sector touches live data TODAY, and a definitive `w = -1` would close
   the program's main observational fluctuation channel (see kill list).

Division of labor: Lean/Aristotle for MP2, the label-invariance and
free-sector lemmas of item 4, and any finite consistency conditions; numerics
for MP1, G2', strong-positivity probes, and D8-style positivity checks; pen
and paper (plus, later, external analysts) for R9/F-M2; the main agents for
freezes, pre-registrations, and audits. No Aristotle strategy job on "solve
the Measure Problem" - the problem is not yet statement-shaped; the items
above are.

## 6. Kill-conditions and failure modes for the measure sector

- **Unobservability collapse.** If every fluctuation channel closes
  empirically - dark energy exactly constant at all redshifts (kills C4),
  swerve bounds to zero, no horizon-scale non-Gaussianity - the substrate
  becomes unobservable in principle and the measure sector demotes from
  physics to metaphysics. Registered since the it-from-commit ledger as the
  likeliest failure mode, and accepted at those odds.
- **F-SPAT unresolved.** If everpresent-Lambda's spatial-inhomogeneity
  problem resists the transport-correlation conjecture, C4 is wounded and
  R10 loses its live anchor.
- **The A_s challenge fails broadly.** If no natural scheme class comes
  within orders of magnitude, the growth sector loses its one cheap
  quantitative foothold; the inflation slot then likely requires importing
  an inflaton, which must be declared honestly.
- **The MP1' concentration test fails**: the mixture curve stalls at O(1)
  while the per-skeleton baseline vanishes - the factorized (SCG) class dies
  and the equilibrium route (D1-D2) promotes to primary, with a measured
  number rather than a structural failure. (Strong positivity itself is no
  longer a risk for the factorized class - it is free by the Gram lemma; it
  remains a live constraint only for back-reacting deformations, via the
  PSD-kernel criterion.)
- **Underdetermination proven** (tier B-N.ii): not a failure but a
  relocation - the measure moves to the environmental/bedrock bin WITH a
  proof, and the program's completeness claim is amended accordingly.

## 7. Bottom line

The Measure Problem is unsolved, but as of this document's same-day update
the board is no longer empty: SCG (section 4(e)) is the first fully
specified B-1 candidate - strong positivity now a KERNEL-CHECKED theorem
(`GateMP.SCGGramPositivity`), the back-reaction criterion a proved standing
design constraint on every future interacting extension, its Bell-causality
grading resolved under the frozen BC-Q definition (MP4), and a
pre-registered kill test whose quantitative teeth were verified in-repo the
same day. What has changed - and what this document consolidates -
is that the problem is no longer shapeless: there is a canonical statement
(two columns meeting at a fixed point), an eleven-row entrance checklist with
one uniquely sharp necessary condition (the null-Markov fingerprint), a
machine-checked free-sector acceptance test in two dimensions and a regulator
target in four, three structured candidate routes with named gates, a
breakthrough ladder with a realistic first rung (the 1+1D checkerboard-growth
measure, B0), two cheap decisive pilots (MP1, G2'), one small theorem that
would harden the quantum requirement (MP2), and a registered list of the ways
this sector dies. The measure is still the program's deepest unknown - but it
is now an unknown with a work queue.

## 8. Verification-debt register (external imports cited from memory)

Per Round 8 section IV.4, the following are unverified-imports until checked
against primary sources; none may be cited in a paper before verification:
the Rideout-Sorkin classical sequential growth classification and its
Bell-causality/label-invariance axioms; the Bombelli-Henson-Sorkin
Lorentz-invariance-in-distribution theorem for Poisson sprinkling; the
Kleitman-Rothschild generic-poset result (relevant to why uniform measures
fail); Sorkin's quantum measure / decoherence-functional framework and the
strong-positivity condition; the everpresent-Lambda phenomenology lineage
(Ahmed-Dodelson-Greene-Sorkin and successors); the matchgate/free-fermion
simulability theorems (already listed in the Round 6 debt); the
crossed-product type II results (Chandrasekaran-Longo-Penington-Witten
lineage); and, from the SCG integration: the Brightwell-Georgiou
continuum-limit results for random 2D orders and the 2D-order/sprinkling
equivalence; the Johnston massive-series (causal-set propagator) template;
the Dowker-Johnston-Sorkin history-Hilbert-space characterization of strong
positivity; and the Sorkin-Johnston vacuum construction. The in-repo [M] anchors (MassCoinBridge, Gates C1-C2, the QNEC
pilot) are kernel-checked or reproducible and carry no debt.
