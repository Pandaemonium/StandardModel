# Null-Edge Dynamics: Equilibrium, Modular Generation, Decorated Growth (Gate D)

**Provenance.** In-repo theory development (Claude Fable 5, session of
2026-07-02), written after full analysis of the four NERD synthesis treatises
(`Sources/NERD_1.md` .. `Sources/NERD_4.md`) and the current Lean state of the
checkerboard stack (`NullEdgeStandalone/PhysicsSM/Draft/`). Status labels are
strict, per the v2.1 discipline: THEOREM (finite math, proof included or one
line from standard results), IMPORT (real literature theorem whose hypotheses
we have not reproduced), PROPOSAL (checkable theory development), SPECULATIVE
(labeled). Nothing here is Lean-checked yet. External anchors verified
2026-07-02 are listed in the appendix.

**Intent.** The v2.1 program has kinematics (Gate I1), a regulator QFT
(Gate C1), and an imported gravity story (Jacobson equation of state, DPI to
QNEC). What it does not have is a law: a dynamics for the graph ensemble and
its coupling to matter. This document proposes that law in three mutually
checking routes, each ending in gates, and shows that the program already owns
the toy model (the 1+1 checkerboard) in which every route can be exercised
now.

---

## 1. What "dynamics" must mean here

"Add dynamics" hides three different jobs:

1. **Matter dynamics on a fixed graph.** Exists: transport isometries along
   links, onsite fiber unitaries, the overlap kernel (A2, Gates C1-C3).
2. **A law for the graph ensemble itself.** Missing. This is the target.
3. **The coupling between 1 and 2.** Missing; it is where "matter tells
   geometry how to curve" must live.

One constraint governs everything: the theory is generally covariant and
discrete, so there is no external time parameter to evolve in. A dynamics can
therefore only be one of:

- a **measure on completed histories** (covariant path-sum / decoherence
  functional),
- a **flow induced by the state** (modular/thermal time),
- a **growth process** whose order of accretion is pure gauge (label
  invariance = discrete general covariance).

These are not competitors; they are the statics, the local reading, and the
quantum mechanics of one law. The proposal of this document:

```text
Route 1 (equilibrium):  the ensemble is the maximum-entropy measure given
                        the transport constraints; the first law is its
                        Euler-Lagrange condition.
Route 2 (modular):      local dynamics is not postulated; it is generated
                        by algebra nesting via Borchers-Wiesbrock, and the
                        distance from that ideal is a computable defect.
Route 3 (growth):       quantum dynamics is a decorated sequential growth
                        whose step amplitudes are the node coins, rigidly
                        constrained by little-group covariance.
```

The routes must agree where they overlap, and the agreements are the real
gates (section 7). A reader who wants the one-sentence version: **statics by
maximum entropy, locality by modular generation, quanta by decorated growth,
bound together by three consistency theorems.**

Convention note (Gate C0 discipline): Gates I1/C1 are kinematic and must not
consume the state-dependent `J_mod`. Gate D is the opposite: it is
*deliberately* state-side. Every object below that depends on the state says
so.

---

## 2. Route 1 - the equilibrium route: dynamics as a maximum-entropy fixed point

### 2.1 The observation that makes it natural

The v2.1 ontology (A3) is a Poisson-type measure on causal orders. There is a
standard fact begging to be load-bearing:

> **D1 (Poisson = max-ent). THEOREM-shaped.** Among point processes at fixed
> intensity, the Poisson process maximizes entropy. Finite shadow (Lean-easy):
> among probability measures on subsets of a finite set with prescribed
> inclusion probabilities `p_i`, the independent Bernoulli product measure
> uniquely maximizes Shannon entropy.

So the undecorated ontology is already the maximum-entropy answer to "order
plus number, and nothing else." That suggests the general law:

> **The physical ensemble over (graph, decorations) is the maximum-entropy
> measure subject to the transport-correlation constraints - exactly the data
> of which section 4 of the v2 treatise says the metric is the sufficient
> statistic.**

This closes a conceptual loop that was left open in v2: by Jaynes duality,
"the metric is the minimal sufficient statistic of null transport" (A6) and
"the ensemble is max-ent given the metric data" are the same statement read
in the two directions. A6 was implicitly assuming Route 1 all along.

### 2.2 The first law is an identity plus a universality demand

The finite-dimensional core is embarrassingly small. For faithful states
`rho`, `sigma` on a finite-dimensional algebra, define the modular
(entanglement) Hamiltonian of `sigma` as `K_sigma = -log sigma`. Then,
exactly:

```text
S(rho) - S(sigma) = <K_sigma>_rho - <K_sigma>_sigma - S_rel(rho || sigma)
```

Proof: `S_rel(rho||sigma) = tr rho (log rho - log sigma) = -S(rho) +
<K_sigma>_rho`, and `S(sigma) = <K_sigma>_sigma`. QED.

> **D2 (first law as max-ent stationarity). THEOREM (finite core).**
> (i) The identity above, exact in finite dimensions.
> (ii) Since `S_rel >= 0` with equality iff `rho = sigma`, and `S_rel`
> vanishes to second order around `sigma`, the entanglement first law
> `delta S = delta <K>` holds to first order at `sigma`.
> (iii) Max-ent reading: `sigma` is the unique entropy maximizer at fixed
> `<K_sigma>`; the Gibbs family `rho_lambda` proportional to
> `exp(-lambda K_sigma)` is the constrained-max-ent solution family.

This is the same identity that underlies Gate Q1 (the vacuum-subtracted
`S_rel(s) = Delta<K_s> - Delta S_s >= 0` of the v2.1 QNEC split); Route 1
promotes it from an audit tool to the variational principle of the theory.

What is then genuinely nontrivial - the actual Jacobson content - is not the
first law but **universality**: demanding stationarity in *all* small causal
diamonds at *all* points, *with the same multiplier normalization*, and
reading the constrained data through the sufficient-statistic theorem, forces
the Einstein equation as the equation of state. That step is IMPORT
(Jacobson 2015, arXiv:1505.04753) and remains paper-level; the split
"identity = free, universality = content" should be stated loudly, exactly as
the Q1/Q2 split was.

### 2.3 The multiplier dictionary

Maximum entropy subject to constraints produces one Lagrange multiplier per
constraint, and the multipliers are the physical fields of the coarse theory:

```text
constraint                          multiplier        identification
-------------------------------------------------------------------------
mean node count per region          mu_count          Lambda (unimodular
                                                      chemical potential;
                                                      ties A10 / Gate
                                                      Lambda1')
link transport second moments       g^{AB}-block      metric / tetrad
                                                      (the sufficient
                                                      statistic of A6)
coin/fiber correlation data         source block      stress tensor
                                                      coupling (route 3)
```

> **Slogan (PROPOSAL): geometry is the Lagrange multiplier of the transport
> constraints; the cosmological constant is the multiplier of counting.**

This upgrades the v2 slogans in a way that makes them *calculable*: the
equation of state is literally the statement that multipliers are conjugate
to constraints, which is what "thermodynamic identity" always meant.

### 2.4 Honesty clause

Route 1 buys equilibrium by construction, so "the first law holds" stops
being evidence and the content migrates entirely into (a) the naturalness of
the constraint set (it must be the minimal sufficient statistic, or the
construction is rigged), and (b) universality of the multipliers. Also,
maximum entropy defines *statics* - an ensemble, not an evolution. In a
covariant theory that may be all there is globally, but local dynamics must
then come from Route 2. Both caveats are registered as failure modes
(F-D1, F-D5).

---

## 3. Route 2 - the modular route: dynamics generated by algebra nesting

### 3.1 The import

In the continuum the deepest known mechanism producing dynamics from
kinematics is: **half-sided modular inclusions generate translations.**
For von Neumann algebras `N` contained in `M` with a common cyclic separating
vector, if the modular flow of `M` maps `N` into itself for `t >= 0`, then
(Borchers; Wiesbrock, with the 1993 proof gap closed by Araki-Zsido 2004)
there is a one-parameter unitary group with **positive generator**
`-(1/2pi)(log Delta_N - log Delta_M)` implementing translations, and the
structure forces type III_1. On null strands, "future algebra of a cut,
nested under cut advance" is precisely this shape: given the net of strand
algebras and a suitable state, **null translation dynamics is a theorem, not
an input.** IMPORT.

This is what would finally make "time is modular" (A4) a mechanism: dynamics
is not added to the graph; it is induced by the state on the nesting.

### 3.2 The finite no-go that makes F-M2 precise

> **D3.0 (finite half-sided inclusions are trivial). THEOREM-shaped.**
> Let `M` be a finite-dimensional von Neumann algebra with faithful state
> and modular group `sigma_t`, and let `N` be a subalgebra with
> `sigma_t(N)` contained in `N` for all `t >= 0`. Then `sigma_t(N) = N` for
> all real `t`.
>
> Proof sketch. In finite dimensions the modular flow is almost periodic:
> matrix entries of `sigma_t(x)` are finite sums of `exp(i t theta_k)`. By
> recurrence there are `t_n -> infinity` with `sigma_{t_n} -> id` uniformly
> on the unit ball. For `s > 0` and large `n`, `sigma_{t_n - s}(N)` is
> contained in `N` (since `t_n - s >= 0`), and
> `sigma_{t_n - s}(N) = sigma_{-s}(sigma_{t_n}(N)) -> sigma_{-s}(N)`;
> closedness of `N` gives `sigma_{-s}(N)` contained in `N`. Hence equality
> for all `t`. QED (to be written out carefully; the recurrence step is
> Kronecker-type and finite-dimensional compactness does the rest).

Consequence: **no finite graph can carry a proper half-sided modular
inclusion**, so Borchers translations cannot exist at any finite stage.
This is the failure mode F-M2 ("type I vs type III") converted from a worry
into a precise finite statement - and therefore into something with a
quantitative continuum handle:

### 3.3 The modular defect

> **D3.1 (defect functionals). PROPOSAL (definitions).** For the null-cut
> family `A_s` (algebra outside/future of cut `s`) with global Gaussian
> vacuum on a finite chain:
>
> (i) *Inclusion-leak defect.* The modular flow of the cut-`s` algebra acts
> on the restricted mode space by `exp(i t h_s)` with `h_s` the
> entanglement-Hamiltonian kernel (Peschel). Define
> `leak(s, t) = || P_inside(s+1) exp(i t h_s) P_outside(s+1) ||` for
> `t >= 0`: the amplitude for modes of `A_{s+1}` to be driven out of
> `A_{s+1}` by the cut-`s` modular flow. Exact half-sidedness would be
> `leak = 0` for all `t >= 0`.
>
> (ii) *Bisognano-Wichmann defect.* `bw(s) = || h_s - h_s^boost ||` with
> `h_s^boost` the discretized boost kernel (the Eisler-Peschel lattice
> entanglement-Hamiltonian comparison).

> **D3.2 (defect scaling). PROPOSAL (conjecture with protocol).** On the
> checkerboard chain with Gaussian vacuum, both defects vanish in the
> continuum limit at fixed physical `t`, with measurable rates
> `leak ~ a^{alpha}`, `bw ~ a^{beta}`. Measure `alpha`, `beta`.

Everything in D3.1-D3.2 is computable with **exactly the Gate Q2 toolchain**
(correlation-matrix entropies and entanglement Hamiltonians on nested null
cuts); the protocol in
`AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md` should gain a
"modular defect" measurement as a fourth deliverable at near-zero marginal
cost. If the defects vanish with clean rates, the program owns the first
quantitative statement of *how* type III modular structure emerges from
finite graphs - which is the analytic heart of the entire gravity story. If
they do not vanish, F-M2 is fatal and it is better to know.

### 3.4 Payoff

Route 2 reframes the emergence hierarchy: **null translation dynamics exists
exactly where the modular defect vanishes.** "Time is modular" stops being a
postulate about states and becomes an emergence criterion with an order
parameter. The thermal-time honesty clause (F-M1) is unchanged - which states
are physical is still an input - but the *dynamical* content of the choice is
now measurable.

---

## 4. Route 3 - the growth route: coin-decorated sequential growth

### 4.1 The import

Classical sequential growth (Rideout-Sorkin, arXiv:gr-qc/9904062): causal
sets grow by accreting one element at a time; requiring **discrete general
covariance** (the accretion order is pure label gauge) and **Bell causality**
(the relative probability of two attachments does not depend on spectator
elements) classifies the allowed stochastic laws as the generalized
percolation family. Evidence for a continuum limit exists
(arXiv:gr-qc/0003117); the covtree line (arXiv:2008.02607) is the modern
manifestly covariant formulation; quantum generalizations via decoherence
functionals / quantum measure theory exist but positivity is the known hard
core (Sorkin; Gudder's quantum sequential growth line, e.g.
arXiv:1108.6036). All IMPORT.

### 4.2 The NERD move: decorate the growth with the matter coins

The program already possesses, in its matter sector, exactly the data a
quantum growth law needs:

> **PROPOSAL (decorated sequential growth).** A history is a growth sequence
> of the causal order together with its decorations: each accretion event
> carries the node fiber and an **onsite coin** (the unitary/isometric node
> operation of A2); each new link carries its edge spinor. The amplitude of
> a decorated history is the ordered product of its coins; the physical
> object is the decoherence functional built from pairs of histories with
> final-segment identification. Conditions:
>
> (g1) decorated label invariance (discrete general covariance including
>      decorations);
> (g2) decorated Bell causality (a coin depends only on the causal data it
>      attaches to);
> (g3) transport isometry (A2 unchanged);
> (g4) **little-group covariance**: at each node the coin intertwines the
>      `U(2) = spin x clock` structure of the incident null splits
>      (Gates I1.7/I3).

Condition (g4) is where the program's kinematic core becomes dynamical law:

> **D5 (coin rigidity). PROPOSAL, with IMPORT core.** In the continuum
> amplitudes program, three-point amplitudes are fixed by little-group
> covariance up to coupling constants (massless: classic; massive:
> Arkani-Hamed-Huang-Huang, arXiv:1709.04891). Graph version (conjecture):
> the space of coins at a minimal node satisfying (g1)-(g4) is
> finite-dimensional, spanned by spinor-bracket monomials of the correct
> little-group weight; all freedom is coupling constants.

If D5 holds, the elementary dynamics of the theory is **fixed by symmetry up
to couplings** - the strongest kind of dynamical claim available, and the
v2 observation "the S-matrix already knows" (on-shell diagrams as the
scattering shadow of the ontology) becomes the *definition* of the
microdynamics rather than an analogy: BCFW-style gluing of on-shell data is
the elementary growth step.

### 4.3 The open core and the speculative lead

The unresolved center of any quantum growth law is **positivity of the
quantum measure** (decoherence-functional strong positivity). This is not a
NERD-specific disease; it is the known state of the field. Registered as
F-D3.

SPECULATIVE lead, recorded because it is the only structural idea on the
table for the Lorentzian sign problem (F-L1): the v2 correspondence
"future-pointing edges = positivity in the Grassmannian" suggests the
decorated-growth measure may be constructible from positive-geometry data,
with positivity rather than Wick rotation taming the oscillation. No claim;
one concrete first test exists (section 5.3).

### 4.4 Prior art to engage (not fear)

- **Energetic causal sets** (Cortes-Smolin, arXiv:1307.6167 and
  arXiv:1308.2206; quantum version Phys. Rev. D 90, 044035; spin-foam
  connection arXiv:1407.0032): causal-set events carrying conserved
  energy-momentum, with amplitudes and emergent semiclassical spacetime.
  This is the closest existing neighbor to decorated growth and must be
  cited and differentiated. The differentiators, cleanly: NERD decorates
  with *spinors* and demands little-group covariance (D5), inherits the
  chiral-fermion release machinery (C1), and enforces the quantum-measure /
  covariance discipline of CSG. ECS conserves momenta at events but has no
  splitting-gauge structure, no coin rigidity, and no lattice-chiral sector.
- **Causal graph dynamics** (Arrighi-Dowek line) and **quantum graphity**
  (Konopka-Markopoulou-Smolin): local rewriting / Hamiltonian graph
  dynamics. Both run on synchronous or preferred-time updates and
  finite-valency adjacency, which the L0 analysis (Gate L0, NERD_4) rules
  out as the ontology. Cite as the cautionary contrast class.
- **GFT / spin foams**: the second-quantized packaging of growth-like
  dynamics; arXiv:1407.0032 shows ECS-style dynamics embeds there. Optional
  packaging for Route 3 later; not load-bearing now.

---

## 5. The checkerboard is Gate D's toy, and it is already half-built

The repo's 1+1 checkerboard stack (`NullEdgeStandalone/PhysicsSM/Draft/`:
`Checkerboard1D.lean`, `CheckerboardSpacetimeCounts.lean`,
`CheckerboardContinuumScaffold.lean`, `CheckerboardDiracScaling.lean`) is,
read correctly, a decorated sequential growth model in one null dimension:

### 5.1 D4 - the dictionary (mostly reinterpretation)

```text
checkerboard object                      growth object
----------------------------------------------------------------------
path of null steps                       linear decorated growth history
one step                                 one accretion event
direction preserved                      trivial coin
turn (reversal)                          nontrivial coin
mu in checkerStep r l mu                 THE coin amplitude: the proved
                                         lemma "mass = off-diagonal
                                         reversal amplitude" is coin
                                         rigidity in 1+1, where the
                                         little group is trivial and the
                                         only invariant is the mass
turn-class counts (closed forms in       the classical (combinatorial)
CheckerboardSpacetimeCounts)             layer of the growth measure
coin-weighted sum over turn classes      the quantum measure diagonal =
                                         the checkerboard propagator
```

> **D4 (checkerboard growth dictionary). PROPOSAL, Lean-light.** Record the
> dictionary in the module docstrings and add the one missing lemma: the
> coin-weighted sum over the formalized turn classes equals the checkerboard
> kernel (this should sit adjacent to the existing
> `checkerStep`/turn-class closed forms). Each turn's coin phase is one tick
> of the I3.5 determinant-line clock; the checkerboard thread and Gate I3
> become one thread.

### 5.2 D6 - the equilibrium cross-check in miniature

> **D6 (max-ent = stationary growth, toy). THEOREM-shaped + honest gap.**
> (i) Finite THEOREM: the maximum-entropy measure over binary turn
> sequences at fixed mean turn rate is the Bernoulli product measure
> (D1's shadow). (ii) The classical checkerboard growth measure at fixed
> turn probability *is* that Bernoulli measure: Route 1 statics = Route 3
> stationarity, exactly, at the classical layer. (iii) The quantum layer is
> the continuation of the turn weight from a probability `p` to the
> amplitude `i * m * epsilon` - and this continuation is the Lorentzian
> sign problem **in miniature**. F-L1, made small, explicit, and testable.

### 5.3 The smallest positivity test

The first check of the speculative positivity lead (4.3): determine whether
the 1+1 decorated-growth decoherence functional has the strong-positivity
property, and whether its positivity domain is characterized by
future-pointing/retardation conditions. Small finite matrices; a numerics
afternoon; genuinely informative either way. SPECULATIVE input, decidable
output.

---

## 6. What NOT to do

- **No Regge/action bolt-on.** An independent gravitational action
  double-counts against the equation-of-state mechanism (Route 1) and was
  already demoted in v1 section VIII / v2 section 6. The spectral action
  remains a consistency gate (G1'.4), not a dynamics.
- **No synchronous rewriting, no Hamiltonian graph dynamics, no preferred
  foliation.** All collide with Gate L0: finite-valency equivariant
  structure dies by L0.1, and synchronous updates smuggle in a frame.
- **No bare "sum over graphs with a plausible weight".** Without the Route 1
  constraint structure or the Route 3 covariance conditions, a graph path
  integral is an unfalsifiable sign-problem generator (F-L1).

---

## 7. The consistency triangle (the binding gates)

The three routes overlap pairwise, and each overlap is a theorem target:

```text
X1 (equilibrium = growth):   the max-ent measure of Route 1 is the
                             stationary measure of the covariant decorated
                             growth of Route 3.
                             Toy case = D6 (checkerboard, THEOREM-shaped).
                             General case: paper-level.

X2 (modular = growth):       along a null strand, in the defect -> 0 limit
                             (D3.2), the growth steps realize the
                             Borchers-Wiesbrock translation semigroup: the
                             accretion flow IS the modular flow read
                             locally. Paper-level; first numerics free with
                             D3.2.

X3 (coins source geometry):  coarse-grained coin/fiber correlation data
                             enter the Route 1 constraint set and shift the
                             multipliers: matter sources geometry because
                             matter data are constraints. Schematic; becomes
                             precise only after X1.
```

A route that fails its cross-checks dies cleanly; a route that passes them
is no longer a proposal. This triangle - not any single route - is the
answer to "how would you add dynamics."

---

## 8. Axiom candidates (pending gates; NOT yet axioms)

- **A13 (equilibrium).** The physical ensemble is the maximum-entropy
  measure over decorated causal orders subject to the counting and
  transport-correlation constraints; Lambda and the metric are the
  corresponding multipliers. [Gates D1, D2, X1]
- **A14 (modular generation).** Local null dynamics is the translation
  structure induced by the state on nested strand algebras; it exists
  exactly where the modular defect vanishes. [Gates D3.0-D3.2, X2]
- **A15 (decorated growth).** The quantum dynamics is a decoherence
  functional on coin-decorated covariant growth histories, with coins fixed
  by little-group covariance up to couplings. [Gates D4, D5, D6, X1, X3]

---

## 9. Gate D ladder

| Gate | Statement | Label | Cost | Track |
|------|-----------|-------|------|-------|
| D0 | This document: the three-route split and the consistency triangle | - | done | - |
| D1 | Finite max-ent shadow: Bernoulli product uniquely maximizes entropy at fixed inclusion probabilities; Poisson = max-ent (finite windows) | THEOREM-shaped | Lean-easy | night |
| D2 | Exact first-law identity `Delta S = Delta<K> - S_rel`; first-order first law; Gibbs family as constrained max-ent | THEOREM-shaped | Lean-easy given entropy defs (check Lean-QuantumInfo/Physlib first, as for Q1) | night |
| D3.0 | Finite half-sided modular inclusions are trivial | THEOREM-shaped | Lean-medium (Kronecker recurrence) | night/Aristotle |
| D3.1 | Modular defect functionals defined (leak + BW) | PROPOSAL (defs) | trivial | with Q2 |
| D3.2 | Defect scaling exponents on checkerboard vacuum | PROPOSAL (conjecture + protocol) | numerics, shares Q2 code | paper-level |
| D4 | Checkerboard growth dictionary + coin-weighted kernel lemma | PROPOSAL | Lean-light | night |
| D5 | Coin rigidity: covariant coins = bracket monomials x couplings | IMPORT core + PROPOSAL | paper-level first | queue |
| D6 | Toy X1: max-ent = stationary growth on the checkerboard; continuation gap stated | THEOREM-shaped + honest gap | Lean-easy + prose | night |
| D7 | X2 precise statement (growth realizes modular translation as defect -> 0) | PROPOSAL | paper-level | queue |
| D8 | Positivity probe: strong positivity of the 1+1 decorated decoherence functional | SPECULATIVE input, decidable output | numerics afternoon | paper-level |

Sequencing: nothing above touches the C1 critical path. D1, D2, D6 are the
same species as Gate I1 (finite matrix/probability algebra) and belong to
the same night track and the same Aristotle packaging pattern
(Mathlib-only standalone). D3.2 and D8 ride on the Q2 numerics
infrastructure.

## 10. Failure modes

- **F-D1 (constraint vacuity).** If *any* constraint set makes Route 1 work,
  gravity-by-construction is empty. Response: the constraints must be
  exactly the minimal sufficient statistic (A6), and the multiplier
  universality across diamonds is the nontrivial, falsifiable demand.
- **F-D2 (defect does not vanish).** If D3.2's exponents are zero or
  state-fine-tuned, Route 2 dies and F-M2 is fatal for the modular gravity
  chain. This is the designed kill test for "time is modular."
- **F-D3 (positivity fails).** If no covariant coin choice yields a strongly
  positive decoherence functional, Route 3 degrades to an effective
  bookkeeping of amplitudes. Known field-wide open problem; D8 is the cheap
  first probe.
- **F-D4 (coin non-composability).** Three-point rigidity (D5) may not
  extend to consistent gluing on graphs (the continuum analogue needs
  BCFW-type consistency). If gluing fails, dynamics is not fixed by
  symmetry and couplings proliferate.
- **F-D5 (equilibrium mismatch).** If the stationary measure of covariant
  decorated growth is not the max-ent measure (X1 fails beyond the toy),
  either the constraint set or the growth conditions are wrong; the
  disagreement locus is itself informative and publishable.
- **F-D6 (Lorentzian measure).** The continuation gap of D6(iii) is the sign
  problem; the positivity lead (4.3) is SPECULATIVE. No schedule may depend
  on it.

## 11. Publication hooks

- **D1 + D2 + D6**: a short verified note - "The entanglement first law is
  a one-line identity; the content is universality" - with Lean artifact;
  natural companion to P2/P6 and the formal on-ramp to P9 (the moonshot is
  exactly D2-universality made discrete and verified).
- **D3.0-D3.2**: extends P3 (discrete QNEC) with a modular-defect section;
  jointly they make the program the owner of "finite-to-type-III emergence,
  measured."
- **D4 + D6 + D8**: a checkerboard-dynamics note tying the formalized
  combinatorics to decorated growth (also feeds P8's expository channel).
- **D5**: an amplitudes-adjacent paper once the graph statement is precise;
  engage the ECS literature there.

## 12. Execution notes

- Ingest into the null-edge Zotero/Neo4j collection before drafting:
  gr-qc/9904062, gr-qc/0003117, 2008.02607, 1108.6036, 1307.6167,
  1308.2206, 1407.0032, 1505.04753, plus the Wiesbrock/Araki-Zsido
  half-sided modular inclusion pair (journal refs in the appendix). Use the
  standard `Scripts/lit/lit_ingest.py` procedure with the pre-add existence
  check.
- Lean: D1/D2/D6 as Mathlib-only standalone Aristotle packages (same
  pattern as Gate I1); D3.0 as a focused package after a
  `lean_leansearch`/`lean-explore` pass for almost-periodicity and
  Kronecker-approximation infrastructure.
- Numerics: add the D3.1 defect measurements to the Q2 protocol file as a
  fourth deliverable; D8 is a standalone small script under the same
  `Scripts/qnec/` (or a sibling `Scripts/dynamics/`) home with oracle-policy
  fixture metadata.
- Roadmap: Gate D rows are appended to the ladder in
  `docs/NERD_ROADMAP.md`; this document is the Gate D source of record.

## 13. The claim in one sentence

**The law of the theory is a maximum-entropy ensemble whose local dynamics
is generated by modular nesting and whose quanta are coin-decorated growth
steps fixed by little-group symmetry - three routes, one triangle of
consistency theorems, every edge of which is a gate.**

---

## Appendix: external anchors (verified 2026-07-02)

- Rideout, Sorkin, "A classical sequential growth dynamics for causal
  sets", arXiv:gr-qc/9904062, Phys. Rev. D 61, 024002 (2000).
- Rideout, Sorkin, "Evidence for a continuum limit in causal set
  dynamics", arXiv:gr-qc/0003117.
- "The structure of covtree: searching for manifestly covariant causal set
  dynamics", arXiv:2008.02607.
- Gudder, "Models for discrete quantum gravity" (quantum sequential growth
  line), arXiv:1108.6036.
- Cortes, Smolin, "The universe as a process of unique events",
  arXiv:1307.6167, Phys. Rev. D 90, 084007 (2014); "Energetic causal
  sets", arXiv:1308.2206, Phys. Rev. D 90, 044035 (2014); "Spin foam
  models as energetic causal sets", arXiv:1407.0032.
- Wiesbrock, "Half-sided modular inclusions of von Neumann algebras",
  Commun. Math. Phys. 157 (1993) 83; gap closed by Araki, Zsido, Rev.
  Math. Phys. (2004/2005) ("Extension of the structure theorem of Borchers
  and its application to half-sided modular inclusions",
  arXiv:math/0412061). Borchers' theorem is the underlying structure
  result.
- Jacobson, "Entanglement equilibrium and the Einstein equation",
  arXiv:1505.04753 (IMPORT for the universality step).
- Arkani-Hamed, Huang, Huang, "Scattering amplitudes for all masses and
  spins", arXiv:1709.04891 (three-point rigidity; D5 core).
- Peschel / Eisler-Peschel correlation-matrix and lattice
  entanglement-Hamiltonian methods (as already anchored in the Q2
  protocol).
- Repo-internal: `Sources/NERD_2.md` sections 1, 4, 6; `Sources/NERD_4.md`
  sections 4, 5, 7; `NullEdgeStandalone/PhysicsSM/Draft/Checkerboard1D.lean`
  (`checkerStep`, mass = reversal amplitude);
  `AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md`.
