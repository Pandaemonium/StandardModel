# Null-edge interaction ontology

**Status:** speculative ontology note grounded in finite theorem targets.
Original observer-channel reframing 2026-06-23; obstruction-geometry addendum
2026-06-27; **fully updated 2026-07-03** to absorb the computational
(it-from-commit) ontology, the NRQG derivation tower (Round 4), the
adversarial audit and commitment ledger (Round 5), and the gap-audit fills
(Round 6).

**Related documents:**
`Sources/it-from-commit-ontology-essay.md` (the computational ontology in
full), `Sources/nrqg-round4-tower.md` (the derivation tower),
`Sources/nrqg-round5-audit-and-commitments.md` (adversarial audit, commitment
ledger, QNEC pilot), `Sources/nrqg-round6-missing-pieces.md` (gap fills:
forced dynamics, spin-statistics, Weinberg-Witten, null-cone monotones, magic,
gauge = code), `Sources/NERD_1.md` through `Sources/NERD_4.md` (the v2
treatise lineage; NERD_4 = v2.1), `docs/NERD_ROADMAP.md` (gate ladder and
claim discipline), `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`,
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
`Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md`,
`Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md` (current Lean status
of the matter level).

**Epistemic tags,** adopted from the round documents and used throughout:
**[T]** anchored to a theorem or established external result; **[M]** anchored
to a program-internal result, including kernel-checked Lean and verified
numerics; **[C]** precise conjecture with a named gate; **[O]** unconstrained
ontological interpretation (the round documents write this tag as Omega). The
tags are the license for the boldness: everything marked [O] is allowed to be
as radical as it wants precisely because it is not allowed to pretend to be a
[T].

## Executive thesis

The ontology now has three nested layers, each strictly bolder than the last,
each carrying its own tag.

**The interaction layer** (2026-06-23, retained) [C/O]:

> Reality is made of lawful null interactions. Particles are stable sectors of
> the finite quantum channels that coarse-grain those interactions.

**The computational layer** (it-from-commit) [O]:

> Reality is a finite, reversible, locally readable quantum computation whose
> only primitive transitions are null messages. Energy is the clock budget.
> Matter is light in conversation with itself. Gravity is congestion. A
> classical fact is a commit - a record published too redundantly to roll
> back. Nothing in the universe is a thing. Everything is a session.

**The tower layer** (Round 4, audited in Round 5) [T/M/C, level by level]:

> This ontology is Level 8 of a derivation tower whose ground floor is three
> information axioms - information is never destroyed (purification),
> composite states are determined by local reads plus correlations (local
> tomography), and the substrate executes on null messages. From these,
> quantum mechanics over the complex numbers is a theorem; 3+1 spacetime
> dimensions are a conditional corollary; the interaction vertices are the
> unique consistent decoration of the graph; the fermion content is a
> consistency (erasability) condition; gravity is an inequality; the
> cosmological constant is sampling noise; and the arrow of time is counting.

The mature single-paragraph ontology, updated:

> The fundamental objects are not particles in spacetime, but quantum-labeled
> null transitions in a causal incidence structure - messages in a finite,
> reversible, locally readable computation. A particle is a stable or
> metastable sector (a session) of the resulting transfer channel. Its
> invariant mass square is the determinant of the unnormalized observer-visible
> momentum block, equivalently the Pluecker spread of unresolved null
> components, equivalently the pairwise concurrence of its null constituents;
> mass is also the clock rate of the left/right chirality conversation that
> constitutes the particle. An observer-conditioned celestial state measures
> the ratio `m / E_u`, not invariant mass itself. Higgs/Yukawa couplings are
> legal chirality-changing mass operators - the exchange rate of the L/R
> conversation - that first create chirality coherence; visible mixedness
> appears only after an explicit dephasing, trace, detector restriction, or
> observer channel. Spin is the phase-coherent structure discarded by the
> scalar determinant. Gauge structure is the error-correcting code layer of
> the network; gauge curvature is the holonomy defect between alternative
> histories, and charge is a syndrome. Gravity is the congestion response of
> the network - the finite-diamond response to the subset of interaction
> bookkeeping visible as a bulk source, enforced by monotonicity of relative
> entropy on null deformations. Classicality is the commit protocol:
> decoherence publishes, and what has been published widely enough is a fact.

The safe theorem-level core remains narrower, and is unchanged:

> A timelike visible momentum can be represented as a finite bundle or reduced
> visible state of null spinor directions, and its invariant mass is exactly
> the unnormalized Pluecker spread of those null components. After an
> observer-time normalization is fixed, the corresponding normalized celestial
> mixedness is the frame-relative ratio `m/E`.

The most disciplined mathematical core can be stated without the full
ontology: a future-causal momentum is a positive Hermitian spinor matrix; its
determinant is invariant mass squared; rank-one factorizations resolve it into
null spinors; and a chosen timelike observer turns the same matrix into a
celestial qubit whose mixedness measures `m / E_u`. The proposed dynamics then
asks whether a finite null-step Dirac transfer makes this same ratio appear as
chirality coherence and as the stable-sector readout of a causal quantum
channel.

The compressed research spine, extended by the new layers:

```text
information axioms (purification, local tomography)
-> quantum mechanics over C
-> positive Hermitian momentum (Herm_2(C) soldering)
-> Plucker null-spinor resolution
-> observer-conditioned celestial qubit
-> chirality coherence
-> null-step transfer dynamics
-> forced interaction vertices (node bootstrap)
-> stable or metastable particle sectors (sessions)
-> monotones on the null cone (gravity, RG)
-> commit ledger (classicality, facts)
```

The broad claim that null interactions are ontologically fundamental should be
read as an interpretation of this spine, not as evidence for it.

## Where the ontology sits: the derivation tower

Round 4 assembled the program into a tower; Round 5 audited its arrows; Round
6 inserted the missing levels. This document is the top floor, and its license
depends on the floors below. Read bottom-up:

```text
LEVEL 0  [axioms]  information axioms: (i) purification - information is
                   never destroyed; (ii) local tomography - composite states
                   are determined by local reads plus correlations;
                   (iii) compositional axioms (causality, coarse-graining).
                   Information causality is Level-0-adjacent (Gate IC1).
LEVEL 1  [T]       quantum mechanics over C (CDP reconstruction; real
                   amplitudes experimentally falsified)
LEVEL 2  [T]+[M]   spacetime = Herm_2(C) ~= R^{3,1}: nullity = purity,
                   rank-one soldering P = lambda lambda^dagger -> 3+1
LEVEL 3  [T]       kinematics: Cauchy-Binet mass, boost-Gibbs clocks,
                   Minkowski = Minkowski (Gates I1-I2)
LEVEL 3.5 [T->M]   dynamics: the unique consistent decoration of the null
                   graph (soft theorems + four-particle consistency; Gate NB1)
LEVEL 4  [M]       matter: null-edge graph; GW/code chirality release
                   (Gate C1); erasability/Z_16 -> 16 of Spin(10) -> nu_R;
                   gauge fields as the code layer
LEVEL 5  [C]       flavor: J_3(O) exceptional continuation, three
                   generations, mixing as triple concurrence (Gate F1,
                   on probation)
LEVEL 6  [T]+[M]   gravity: DPI -> QNEC -> focusing; entanglement
                   equilibrium -> Einstein equation of state; RG monotones;
                   vacuum Markov property on null cuts
LEVEL 7  [M]+[C]   cosmology: Lambda = harmonic zero mode + 1/sqrt(N) shot
                   noise; arrow and initial condition from growth (the
                   capacity race)
LEVEL 8  [O]       ontology: this document
```

The tower's integrity claim is modest and checkable: **no arrow points down.**
Nothing at a lower level assumes anything from a higher one.

Three disciplinary points from the Round 5 audit are binding on this document:

1. **The dimension chain is a conditional derivation.** "Local tomography
   selects C; Herm_2(C) is R^{3,1}; therefore 3+1 dimensions" is a theorem
   chain [T] only *given* soldering-fundamentalism - the [M] postulate that
   spacetime is the statistics of rank-one soldered null edges. The premise is
   independently supported (the soldering is the unique structure under which
   mass, proper time, and the little group become linear algebra, Gate I1),
   and the contrapositive is an unconditional kill-condition: discovery of
   geometric extra dimensions falsifies the premise and the tower (commitment
   C1 below). The audit converted a circularity accusation into an exposure.
2. **Two corollaries of the chain, carried with care.** (i) The octonions are
   evicted from spacetime by local tomography and confined to the internal
   fiber, where the generation conjecture gives them a job (Level 5). (ii) In
   R^{3,1} the minimal spanning set of future null directions is four, so the
   Gate C1 tetrahedral scaffold is the minimal-valence regulator consistent
   with Level 2 - a natural minimal choice, not an arbitrary pick. Per the
   program guardrail this does NOT claim a bare graph canonically supplies a
   tetrad; the scaffold remains decorated data until a theorem derives it.
3. **Level-0 axioms in ontology language.** Purification = the universe never
   erases: every mixing is entanglement export, never destruction - exactly
   the reversible-computer principle the black-hole information analysis
   independently concluded. Local tomography = the network is locally
   debuggable: no global read is ever required for local physics to exist.
   "Why is the world quantum?" relocates to: because the substrate is a
   reversible, locally readable information system, and the reconstruction
   theorems prove those properties have a unique closure [T].

Current [M] status of the tower's foundation (2026-07-03): the Gate C1 free
chiral (overlap/Ginsparg-Wilson) release is complete in kernel-checked draft
Lean, and the Gate C2 index/certified-sign layer now exists above it - an
integer overlap index, a functional-calculus-free certified sign, an
unconditional eigenvalue-count index formula, and an explicit nonzero-flux
overlap-index witness (the pi-flux triangle). See
`Sources/Null_Edge_Gate_C2_Index_And_Certified_Sign.md`. The tower is only as
real as this foundation, and the foundation now compiles.

## Master principles: compression, and monotones on the null cone

The document's original master principle is retained:

> Physics is the invariant theory of what survives coarse-graining from a
> null-edge interaction network.

Equivalently:

> Mass, curvature, measurement outcomes, and gravitational sources are finite
> defects of attempting to compress richer null-edge data through an observer
> channel.

Here "observer" does not mean a subjective mind. It means a physical channel,
quotient, sector projection, detector algebra, or coarse-graining map. The
channel must be specified before a claim can be invariant, monotone, or
recoverable. In particular, a channel that normalizes by `Tr(P)` has also
chosen a timelike reference vector or energy convention; it is a
frame-relative observable, not a Lorentz scalar by itself.

Round 6 added the second master principle, and it is [T]-grade as an
inventory. The scattered one-way statements of physics are one inequality -
monotonicity of relative entropy (the data-processing inequality, DPI) -
applied to null-deformed regions: the averaged null energy condition
(Faulkner-Leigh-Parrikar-Wang), the quantum null energy condition
(Ceyhan-Faulkner), the entropic c-theorem in d=2 and F-theorem in d=3
(Casini-Huerta), and the a-theorem in d=4 (Casini-Teste-Torroba), whose proof
runs on strong subadditivity for regions on the light cone plus the **Markov
property of the vacuum on null planes**: the vacuum saturates strong
subadditivity on null cuts - conditional mutual information exactly zero,
every null slice exactly recoverable from the previous one (Petz recovery is
perfect there and only there).

> **The universe runs on monotones, and its monotones run on the null cone.
> The null-edge program makes the null cone primitive.**

[O] The Markov property is the architecture speaking: "the vacuum is a
quantum Markov chain along null cuts" says *null slices are complete
checkpoints* - each carries everything needed to reconstruct the next, nothing
carried out-of-band. A message-passing substrate would produce exactly this
signature, and it is a theorem that our vacuum has it. Of everything absorbed
in this update, this is the result that most looks like the graph leaving a
fingerprint on the continuum.

The two principles compose: the observer channel says *what* is visible; the
null-cone monotones say *which way* visibility can flow. The defect dictionary
sits inside both:

```text
mass      = defect of projective collinearity
curvature = defect of path-independent transport
spin      = phase data lost by scalar compression
gravity   = source defect visible to diamond observables
entropy   = pointer loss: the gap between stored and addressable
```

The strongest compact slogan for the kinematic core remains:

> Invariant mass is the unnormalized Pluecker defect of null data; normalized
> mixedness is what that defect looks like to a specified observer frame.

## Energy is clock speed

[T] The Margolus-Levitin theorem: a quantum system with mean energy `E` above
its ground state can pass through orthogonal (distinguishable) states at a
rate of at most `nu_max = 2E / (pi hbar)`. Distinguishable-state transitions
are the physical definition of an elementary operation, so the theorem says,
without metaphor: energy is the maximum rate of state change. Joules are ops
per second, and `hbar` is the exchange rate.

[T] This is not a constraint imposed on energy from outside; it is what
energy is. `E = hbar omega` says a system's energy is the rate at which its
phase updates; the Hamiltonian is the generator of time translation - the
scheduler, the operator whose spectrum is the allocation of update rates
across the system's parts. Conservation of energy, via Noether, is
time-translation symmetry of the scheduler: the total clock budget of an
isolated system is fixed. The universe does not gain or lose compute; it only
reallocates it.

[M] In the program this becomes local and relational: the node-relative
energy `E_i = -p_i . u` is the modular frequency of an edge against a node's
own clock, and the boost-Gibbs theorem (Round 3, A1) makes the node clock's
modular Hamiltonian literally the boost. Energy is allocated update rate *as
measured by the composite doing the measuring*. There is no global clock rate
because there is no global clock - only nodes, each metering the traffic
through itself.

[O] So "more resources for high-energy regions" is the least speculative
clause in the computational ontology, with the causal arrow reversed: the
universe does not budget compute according to energy. **Energy is the
budget.** Where more happens per second, we say there is more energy.

## Frame-invariance correction

The referee audit forces an important correction, retained verbatim because
everything downstream leans on it. The invariant object is the unnormalized
`2 x 2` Hermitian momentum block:

```text
P = sum_i psi_i psi_i^dagger.
```

Its determinant is the Lorentz scalar:

```text
det(P) = m^2.
```

Under a spin-frame/Lorentz transformation `A in SL(2,C)`,

```text
P |-> A P A^dagger,
det(A P A^dagger) = det(P).
```

The normalized visible state

```text
rho_vis = P / Tr(P)
```

is different. Since `Tr(P) = 2E` uses the time component of the four-momentum,
`rho_vis` depends on a chosen timelike observer or rest-frame convention. Its
determinant measures:

```text
det(rho_vis) = det(P) / Tr(P)^2,
2 sqrt(det(rho_vis)) = m / E.
```

Thus normalized visible mixedness is a frame-relative mass-ratio/proper-time
rate, not invariant mass itself. This does not kill the null-edge mass
theorem; it improves its precision. The paper should lead with `det(P) = m^2`
and then use normalized `rho_vis` only after explicitly fixing the observer
channel or frame.

This also changes the novelty claim. The kinematic relation between massive
two-spinor/twistor data and concurrence has prior art, especially Chin and Lee
(`arXiv:1407.2492`, Zotero `3VBEK82X`), and the non-covariance of reduced spin
entropy is a standard warning from Peres-Scudo-Terno
(`Phys. Rev. Lett. 88, 230402`, also `quant-ph/0203033`) and Gingrich-Adami
(`Phys. Rev. Lett. 89, 270402`, also `quant-ph/0205179`). The program's
defensible novelty is the finite null-edge/Lean-checked packaging, the
unnormalized invariant/channel split, and the still-open dynamical proposal
connecting proper-time rate to null-edge coarse-graining.

The clean observer-conditioned state is:

```text
rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P),
U = u.sigma,
```

for a unit timelike observer `u`. With the standard bispinor convention,

```text
det(rho_{p|u}) = m^2 / (4 (p dot u)^2),
2 sqrt(det(rho_{p|u})) = m / (p dot u).
```

The formula `rho_vis = P / Tr(P)` is a special-frame shorthand. It should not
be used as the canonical Lorentz-covariant definition in publication text.

Fixing the observer also supplies a distinguished two-null resolution of a
timelike momentum. With

```text
E_u = p dot u,
q = p - E_u u,
s = sqrt(E_u^2 - m^2),
n = q / s,
```

one may set

```text
k_+ = ((E_u + s) / 2) (u + n),
k_- = ((E_u - s) / 2) (u - n).
```

Then

```text
k_+^2 = k_-^2 = 0,
k_+ + k_- = p.
```

This is a clean theorem target because it makes the two-null picture canonical
after choosing `u` and the observed momentum direction. It is also a
guardrail: null resolutions are not unique in general, so different spinor
bundles realizing the same `P` should be treated as purification,
hidden-isometry, or observer-channel freedom rather than as directly
distinguishable constituent realities.

## Architecture: compute at nodes, communicate on edges

Every computer separates two functions: moving data and changing it.
Interconnect and processor. The null-edge graph is the claim that the universe
makes the same separation, absolutely.

[T] A null edge has zero proper time; in the soldered formulation, a null
momentum is a rank-one - *pure* - object, and pure states have trivial modular
structure: no cyclic-separating vector, no intrinsic flow, no internal
statistics for a clock to count. Therefore, with theorem-grade force in the
finite-dimensional setting:

> **A photon performs no computation. It is pure data transfer.** Light is the
> universe's interconnect: state moved at the maximum signaling rate,
> unchanged, unaging, untouched. Computation - actual state change, actual
> modular ticking - happens only at nodes, where edges meet and the composite
> state is mixed.

[T] And matter? In the Weyl basis the Dirac mass term couples the left- and
right-handed components: each sources the other, at rate `m`. A free massive
fermion is two null (Weyl) processes handing their state back and forth -
Penrose's zig-zag, the Feynman checkerboard, the Colin-Wiseman zig-zag
process, all the same picture. In the program's language: the two null
constituents whose concurrence *is* the mass (Gate I1) are the two halves of a
conversation, and the boost-Gibbs modular flow is the precession that carries
one into the other.

[O] The ontology of matter, stated at full boldness:

> **Matter is light in conversation with itself. Mass is the rate of the
> conversation.** A particle "at rest" is not a thing sitting still; rest does
> not exist at the level of the substrate, where all transport is null. Rest
> is a balanced loop - a message bouncing between two chirality registers so
> symmetrically that the center of the conversation stays put. The Higgs
> field, which sets `m`, is the medium's exchange rate: the coupling that
> prices how eagerly the left register answers the right. A vacuum expectation
> value is a standing offer of dialogue.

The de Broglie clock `omega = m c^2 / hbar` stops being mysterious: a massive
particle ticks at a rate proportional to its rest energy because the ticking
is the L/R exchange, the exchange rate is the mass, the mass is the energy at
rest, and energy is clock speed. The circle closes with nothing left over.

[O] Furniture inventory: photons are packets on the bus; fermions are
two-register ping-pong processes; bosonic force carriers are the bus messages
by which processes adjust one another's registers; "objects" - atoms, chairs,
planets - are hierarchies of stable message loops, conversations so redundant
and self-correcting that they persist. Nothing in the universe is a thing.
Everything is a session.

## Relativity as distributed-systems bookkeeping

[T] Lamport (1978) founded distributed-computation theory on one observation,
taken explicitly from special relativity: in a system of processes
communicating by messages there is no global "now," only the partial order
generated by message passing. Logical clocks, vector clocks, consistent cuts:
the entire toolkit is causal-order theory. The null-edge graph closes the loop
Lamport opened. Under this ontology the universe is not *like* a distributed
system; it is one, and the dictionary is exact:

```text
distributed systems              null-edge physics
--------------------             -----------------------------
processes                        nodes / node fibers
messages                         null edges
happened-before partial order    causal order
no global clock                  relativity of simultaneity
consistent cut / snapshot        antichain / Cauchy surface
logical clock ticks              proper time (modular ticks)
message latency                  spatial distance
maximum message speed            c
```

[O] The metaphysical war between presentism ("only the now exists") and
eternalism ("the block universe exists") dissolves in this dictionary the way
it dissolves for a distributed-systems engineer: there is no fact of the
matter about the global state "now" - not because the present is unreal but
because "the global present" is a coordination artifact, one consistent cut
among many, none privileged. The question is not deep. It is ill-typed.

[T->O] Time dilation becomes a resource statement. A system's total update
budget is `E`; the fraction spent on internal state change - on *being* rather
than *going* - is `m/E = 1/gamma`, which is exactly the proper-time rate.
[M] The Round 3 entropy-velocity theorem prices it in bits: the momentum
state's entropy is `H_2((1+v)/2)` - a full bit of internal mixedness at rest,
dropping to zero as `v -> 1`. The tradeoff is absolute:

> **You can move your state or you can update it.** A photon spends its entire
> budget on motion and never experiences anything; a particle at rest spends
> its entire budget on experience and goes nowhere. Every worldline is a
> spending pattern. The twin who traveled aged less because aging is
> computation and she spent her cycles on the road.

## Finite causal quantum instrument

The primitive object should be a finite causal quantum instrument, not merely
a bare graph. A finite diamond or local process has data of the schematic
form:

```text
D = (V, E, psi, H_int, U, Phi, A, Omega)
```

where:

- `V` is a finite set of events;
- `E` is a finite set of causal null edges;
- `psi_e : C^2` is the visible spinor direction carried by edge `e`;
- `H_int` is the hidden/internal label space, carrying chirality, weak isospin,
  color, family, Higgs bookkeeping, and other unresolved labels;
- `U_e` is gauge transport along edge `e`;
- `Phi_v` is an odd chirality-changing Higgs/Yukawa vertex operator;
- `A[h]` is the amplitude assigned to a compatible history `h`;
- `Omega` is the physical observer channel from full edge/history data to a
  visible algebra.

In the strict quantum-information version, `Omega` should be a completely
positive trace-preserving map, or more generally a quantum instrument whose
outcomes label accessible detector records. In algebraic or combinatorial
finite models, the same symbol can denote a quotient, sector projection,
partial trace, or restriction to an observable algebra. The point is not that
an observer chooses reality, but that a physically specified channel defines
which invariants are visible.

One extra calibration is essential. A normalized quantum channel preserves
probability, not absolute energy scale. Therefore a particle-sector model
needs a separate momentum readout

```text
P = M(rho)
```

before any observer normalization such as `rho_{p|u}` is applied. Without this
readout, a channel can describe information flow but cannot by itself define
an invariant mass.

The full process may carry data like:

```text
psi_e tensor internal_label_e.
```

The visible observer channel produces something like:

```text
rho_vis = Omega(rho_full),
P       = Tr(P) rho_vis.
```

Thus the ontology is not just:

```text
events + null edges + labels + amplitudes.
```

It is:

```text
finite null-edge data -> observer channel -> visible invariants.
```

## Particles as stable channel sectors (sessions)

In ordinary language we say that particles interact. In this ontology, that is
a coarse-grained reversal. The underlying reality is interactional; "particle"
is the name for a stable pattern in the transfer algebra of the interaction
network - in commit language, a session that stays up.

Let `T_D` denote the effective transfer operator across a diamond or family of
diamonds. A particle species should be modeled as an approximately idempotent,
representation-stable sector:

```text
T_D Pi_a ~= lambda_a Pi_a.
```

Here `Pi_a` is a stable projector or recurrent sector. Then:

```text
particle species = stable projector / recurrent sector
state of particle = vector or density matrix inside that sector
mass = visible determinant invariant of that sector
charge = conserved internal flow label of that sector
spin = projective spinor phase representation of that sector
lifetime = inverse leakage out of that sector
decay = failure of approximate idempotence
```

This is sharper than saying that a particle is a bundle. A bundle explains a
kinematic mass invariant. A stable channel sector can also explain
persistence, decay, scattering, and measurement.

The sharper quantum-channel version uses a completely positive transfer
channel `T`. Particle identity should be looked for in fixed observable
algebras of `T^dagger`, noiseless subsystems, peripheral modes with
`|lambda| = 1`, and metastable modes with `|lambda| < 1` close to one. For a
discrete time step `Delta t`, a metastable eigenmode has the natural lifetime

```text
tau = - Delta t / log |lambda|.
```

With momentum labels present, a particle branch should have

```text
lambda_a(k) ~= exp(-((Gamma_a(k) / 2) + i E_a(k)) Delta t),
E_a(k)^2 ~= |k|^2 + m_a^2.
```

This imports the right quantum-information vocabulary: preserved information,
fixed points, noiseless subsystems, and long-lived spectral sectors. It also
keeps the ontology honest: a projector by itself is not a particle species
until the transfer channel and its spectral branch are specified.

This is analogous to superselection sectors in algebraic quantum field theory,
but only as a loose structural analogy. In the Doplicher-Haag-Roberts picture,
particle charges are organized by localized, transportable endomorphisms of a
local observable algebra, with fusion, statistics, and gauge reconstruction
coming from locality hypotheses. A finite null-edge transfer-sector model does
not yet have those inputs, and DHR is not naturally built for the massless
sectors that this program treats as primitive. The useful lesson is therefore
narrower: particle identity should be represented by stable sectors of an
observable or transfer algebra, not by primitive beads.

An unstable particle is a metastable null-edge pattern with leakage into other
sectors. A muon is not a heavier bead in the primitive ontology. It is a
different metastable channel sector, with different visible mixedness,
internal labels, Yukawa couplings, and allowed decay channels.

A computational footnote that Round 6 makes precise (see "Where the quantum
hardness lives" below): the free sector of all of this - transport, mass
coins, Gaussian states - is classically simulable. Sessions are cheap to
*run*; what is expensive, and what makes the network genuinely quantum, is
what happens at interaction vertices.

## Mass as lost null-direction information

The central theorem spine is the finite Pluecker mass identity. A single
visible null edge has rank-one Hermitian momentum:

```text
p_i = psi_i psi_i^dagger
det(p_i) = 0.
```

A finite visible bundle has total momentum:

```text
P = sum_i psi_i psi_i^dagger.
```

The invariant mass square is:

```text
m^2 = det(P) = sum_{i<j} |psi_i wedge psi_j|^2.
```

Thus a single visible edge is massless, and a collinear family of edges is
still massless. Mass appears when the visible null directions fail to be
projectively collinear.

[M] Gate I1 sharpens the two-edge case into quantum-information language: the
determinant of a two-null bundle is the pairwise concurrence (the 2-tangle) of
its constituents. Mass is the entanglement of a null pair. This identification
is what the generation conjecture (Level 5 below) tries to continue one degree
higher.

After fixing a timelike observer convention, normalize in an
observer-conditioned way:

```text
rho_{p|u} = U^{-1/2} P U^{-1/2} / Tr(U^{-1} P).
```

In a special frame this may reduce to the shorthand:

```text
rho_vis = P / Tr(P).
```

Then, with the usual momentum convention,

```text
m / E_u = 2 sqrt(det rho_{p|u}).
```

This gives the frame-relative observer-channel reading:

```text
massless particle = observer sees a pure null-direction state
massive particle  = observer sees a mixed null-direction state
rest frame        = observer sees maximal celestial mixedness
```

So:

> Invariant mass is the unnormalized Pluecker spread of visible null data; the
> normalized mixedness is the observer-conditioned ratio `m/E_u`.

The word "hidden" is physical, not psychological. It means hidden by tracing
out or quotienting internal, chiral, history, phase, detector, or
coarse-grained degrees of freedom. The massive effective state is not "really
slow" at the fine level; the fine visible transfers remain null. What becomes
timelike is the unnormalized visible momentum block.

## Proper time as visible impurity

The same normalized formula gives a proper-time interpretation once a lab time
or observer frame has been fixed. For a null edge:

```text
det(rho_vis) = 0.
```

For a massive effective trajectory:

```text
det(rho_vis) > 0.
```

Thus the local proper-time rate can be written:

```text
d tau / dt = 2 sqrt(det rho_vis).
```

For a discrete history, the natural finite expression is:

```text
tau(H) = sum_k Delta t_k * 2 sqrt(det rho_vis,k).
```

This matches the relativistic relation:

```text
m / E = sqrt(1 - |v|^2).
```

In null-edge language:

```text
sqrt(1 - |v|^2)
= visible celestial mixedness
= failure of the observer-visible state to remain null-pure.
```

So:

> Proper time is the rate at which a null-edge process appears impure to the
> physically relevant visible channel, after the observer time convention has
> been fixed.

In budget language (see "Energy is clock speed"): `m/E = 1/gamma` is the
fraction of the update budget spent on internal state change rather than
transport, and the entropy-velocity theorem [M] prices the same split in bits,
`H_2((1+v)/2)`. Proper time is the spend rate of the being-budget.

This suggests a Page-Wootters-style research bridge. In relational clock
constructions, time is read from correlations between a clock subsystem and
the rest of the state rather than imposed as an external background parameter.
The null-edge version would ask whether the frame-relative visible impurity
rate of a stable channel sector can act as the local clock variable for an
effective massive particle. This is a lead, not a theorem: the finite
mass-ratio identity is the bankable part, while the Page-Wootters
interpretation requires a specified clock subsystem, constraint,
conditional-state construction, and a clear explanation of how the
frame-relative `m/E` quantity is reconciled with the invariant `det(P)` mass.

## Electrons, Higgs, and legal entangling power

An electron should not be pictured as a tiny massive object that is slowed
down by the Higgs field. The cleaner null-edge picture is:

- the fine visible components are massless/null;
- left-handed and right-handed Weyl components transform differently under the
  electroweak group;
- a bare chirality flip is not gauge legal;
- the Higgs/Yukawa insertion is the allowed odd transition that couples the
  two chiral components;
- after electroweak symmetry breaking, this coupling is seen as a mass term.

Let the chiral spaces be:

```text
psi_L in H_L
psi_R in H_R.
```

The legal odd Yukawa/Higgs maps are:

```text
Phi_Y        : H_L -> H_R
Phi_Y^dagger : H_R -> H_L.
```

The doubled first-order operator has the schematic form:

```text
D =
[ 0                    sigma.p + Phi_Y^dagger ]
[ barSigma.p + Phi_Y   0                       ].
```

Its square should contain:

```text
D^2 =
  visible null propagation
  + gauge curvature terms
  + Phi_Y Phi_Y^dagger mass blocks
  + commutator / covariant-derivative terms.
```

The sharpened bridge is chirality coherence first, observer mixedness second.
The proposed channel chain is:

```text
Yukawa / Higgs insertion
-> legal left/right coupling
-> left/right chirality coherence
-> explicit dephasing, partial trace, detector restriction, or observer channel
-> rho_{p|u} becomes mixed
-> det(rho_{p|u}) becomes nonzero
-> effective mass appears.
```

This is stronger than "null zigzags create mass." It says:

> Higgs/Yukawa coupling supplies the legal first-order chirality mass
> operator; visible mixedness is the observer-channel shadow of that coherent
> coupling.

In conversation language [O]: the Yukawa coupling is the exchange rate of the
L/R dialogue, and the vacuum expectation value is a standing offer of
dialogue - the reason every electron everywhere converses at the same rate.

The bridge remains a theorem target. The Standard Model tells us that the
Higgs/Yukawa term supplies the left/right mass coupling; the null-edge program
must still prove a finite channel model in which the Higgs/Yukawa singular
value and the Pluecker determinant are the same on-shell scalar. It should not
count an independent Higgs mass term and an independent Pluecker mass term as
two separate sources of mass.

## Null-step dynamics and chirality coherence

The ontology becomes much more credible when the null-edge story is tied to a
finite dynamics, not only to a kinematic decomposition. A promising exact
model is the discrete null-step quantum walk

```text
U_a(k) = exp(-i k a sigma_z) exp(-i mu a sigma_x).
```

Its quasienergy satisfies

```text
cos(omega a) = cos(k a) cos(mu a).
```

For a nondegenerate eigenstate, the `z`-chirality coherence is

```text
C_z = |sin(mu a)| / |sin(omega a)|.
```

In the continuum limit this tends to

```text
mu / sqrt(k^2 + mu^2) = m / E.
```

This is exactly the kind of bridge the ontology needs: luminal conditional
shifts, chirality-flip amplitude, Dirac dispersion, and the observer-visible
proper-time ratio appear in one finite model. It should be treated as a
priority theorem target for the P2/P4 dynamics paper. The interpretive slogan
"all elementary visible movement is lightlike" is strongest when it can be
backed by this kind of first-order transfer operator, not merely by the fact
that any timelike momentum admits null decompositions.

## Forced dynamics: the node bootstrap

The gap this fills (Round 6, Hole 1): everything above is kinematics, free
operators, and inequalities. Nowhere did the stack say *why the forces are
these forces* - why Yang-Mills, why universal gravitational coupling, why not
spin-3 messages. The script turns out not to be chosen; it is forced, and the
theorems that force it live entirely on null legs [T]:

- **Weinberg's soft theorems (1964).** Consistency of soft massless spin-1
  emission forces coupling to conserved charges (charge conservation is not an
  input); soft massless spin-2 forces universal coupling to energy-momentum -
  the equivalence principle as a theorem; soft spin >= 3 admits no consistent
  long-range coupling at all.
- **Four-particle consistency (Benincasa-Cachazo; McGady-Rodina).** Gluing
  on-shell three-point amplitudes into four-point objects consistently forces:
  self-interacting spin-1 couplings to satisfy the Jacobi identity (Lie
  algebras are derived, not postulated), spin-2 to be the unique graviton with
  GR's structure, and nothing above spin 2 with finitely many species.

Since the program's nodes *are* on-shell three-point data on null legs, these
results transplant as node self-consistency conditions on the graph: the only
consistent node decorations are Yang-Mills vertices over some Lie algebra, one
universal graviton mode, and Yukawa-type scalar couplings. This inserts a new
tower level:

> **Level 3.5: the dynamics is the unique consistent decoration of the null
> graph.**

[O] The commit glosses are exact, not decorative. The Jacobi identity is
*associativity of message routing* - three-way handoffs must not depend on
bracketing order. And the equivalence principle: gravity couples to energy,
energy is the clock budget, so **the scheduler prices demand, not process
type; congestion pricing is type-blind, hence everything falls identically.**
The deepest principle of general relativity is the statement that a load
balancer cannot see what a process is, only how much it runs.

Gate NB1: transplant the four-point consistency computation onto tetrahedral
null kinematics symbolically; verify Jacobi-from-consistency in graph-native
variables. Medium effort, high leverage: it would make Level 3.5 [M] rather
than borrowed [T].

## Spin, statistics, and PCT

Two layers: the retained phase-data reading of spin, and the new modular route
to the spin-statistics and PCT theorems.

**Spin as the phase data discarded by mass** (retained). The Pluecker mass
formula uses `|psi_i wedge psi_j|^2` - a scalar shadow that discards the
complex phase of `W_ij = psi_i wedge psi_j`. The mass theorem is the modulus
layer of a richer spinor invariant:

```text
m^2 = sum_{i<j} |W_ij|^2.
```

The phases of `W_ij` are natural candidates for spin orientation data,
Berry/Pancharatnam phase, chirality-history information, fermionic sign
behavior, and holonomy around null-edge loops. The guiding slogan:

```text
mass = modulus of null-direction spread
spin = phase coherence of null-direction spread
```

This is not a claim that spin is literal mechanical rotation. There is an
important invariant-theory caveat: a single phase of `W_ij` changes under
spinor rephasings, so raw Pluecker phases are not automatically physical spin.
The safe observables are rephasing-invariant combinations, such as
Bargmann/Pancharatnam products around closed spinor triples or loops, together
with the standard massive `SU(2)` little-group representation. The useful
finite task is to identify which phase data survive the observer channel and
holonomy quotient. The classical gyroscope analogy has limited value; in the
finite theory, resistance to reconfiguration should come from the stable
sector, first-order operator, and spinor-phase constraints, not from a tiny
rotating body.

**Spin-statistics and PCT via modular covariance** (new; Round 6, Hole 2).
Fermions appear everywhere in the program, but no spin-statistics theorem
appeared anywhere - these are usually *assumed* on lattices. The fill was
sitting in the program's own results. [T] Guido-Longo (algebraic QFT): if the
wedge algebras satisfy modular covariance - the modular flow of the vacuum on
a wedge is the boost (the Bisognano-Wichmann property) - then the
spin-statistics connection and the PCT theorem follow. No Lagrangian, no
canonical quantization: modular structure alone.

[M] The Round 3 boost-Gibbs result A1 is precisely a finite
Bisognano-Wichmann property: the modular Hamiltonian of the soldered momentum
state *is* the boost. The program's route to spin-statistics is therefore
already under construction: it rides the Gate I2 -> F-M2 chain (finite modular
theory -> type-II crossed-product continuum; see the gravity section). When
the wedge-modular structure lands, spin-statistics and PCT are *inherited
theorems*. And the program's three-J taxonomy (Krein `J_K`, charge conjugation
`J_C`, Tomita `J_mod`) pays its dividend: **the PCT operator is the modular
conjugation of the wedge.** The third J was never bookkeeping; it was the
antimatter map.

[O] Antimatter, in commit language: every wedge ledger admits exactly one
modular reflection, and antiparticles are matter read in that reflection -
sessions replayed by the wedge's own mirror. CPT invariance is the statement
that the ledger and its modular mirror carry the same physics: the one
discrete symmetry the architecture cannot break, because it is not a symmetry
of the content but of the reading.

Gate SS1: formalize the conditional (Bisognano-Wichmann on graph wedges) =>
(statistics fixed by spin) in the cleanest available finite or 1+1d shadow.
Conditional theorems are still theorems; the hypothesis is exactly what F-M2
is for.

## Gauge fields: holonomy defect, code layer, syndromes

Gauge fields are naturally interactional. They say how to compare internal
data transported along different histories.

**Holonomy defect** (retained). Given two causal paths from `p` to `q`, the
finite diamond defect is:

```text
Delta U(p,q; gamma_1, gamma_2) = U_gamma_1^{-1} U_gamma_2.
```

If the two histories agree, the defect is trivial. If they do not, the defect
is the graph-native curvature carrier. In the non-Abelian case, the raw defect
is endpoint-covariant, while class functions of the defect are gauge
invariant.

> Gauge curvature is the failure of alternative interaction histories to
> compress to one path-independent transport.

**The code layer** (new; Round 6). [T] Lattice gauge theories *are* quantum
error-correcting codes: the toric code is Z_2 gauge theory; string-net models
generalize; electric charges are **syndrome defects** - endpoints of error
strings - and their dynamics is syndrome transport. This is not analogy; it is
the same mathematics with two vocabularies. Consequences absorbed into the
ontology:

1. **Charge quantization is automatic**: holonomies valued in compact groups
   have quantized charge lattices, no monopole argument needed - though
   compactness is also exactly what permits monopoles (one structure, both
   facts).
2. The redundancy that quantum Darwinism needs for the classical ledger (see
   the commit section) and the redundancy of gauge description are
   load-bearing in the same architecture: the memory fabric's stabilizer
   structure.
3. [O] Forces, in commit language: *a force is the propagation of an error
   syndrome through the memory fabric, and charge is the fabric's memory of
   where its code was violated.*

Gauge curvature and mass remain sibling defects:

```text
mass defect      = disagreement among null directions
gauge curvature  = disagreement among internal transports
spin phase       = disagreement among projective spinor phases
gravity source   = disagreement visible to diamond screen observables
```

## Where the quantum hardness lives

Round 6's complexity layer, running vertically through the tower. [T] The
dichotomy: free-fermion dynamics - any mass, any Gaussian state - is
matchgate/fermionic-linear-optics circuitry, classically simulable in
polynomial time (Valiant; Terhal-DiVincenzo; Jozsa-Miyake); free bosons
likewise. The checkerboard, the mass coin, the entire kinematic layer of this
program: computationally *free*. Quantum computational hardness
(BQP-completeness) enters only at non-Gaussian nodes - genuine interaction
vertices - and contextuality is the identified resource behind that hardness
(Howard et al.).

The convergence that makes this structural rather than cute: by the node
bootstrap, the only consistent interaction vertices are the
Yang-Mills/gravity/Yukawa nodes. So:

> **The vertices that consistency forces are exactly the vertices that
> purchase computational depth.** Transport is free; mass is free; the
> universe's entire budget of quantum hardness is spent at the interaction
> nodes - and those nodes are the unique consistent ones. The world is the
> cheapest possible substrate decorated with the only nontrivial gates it is
> allowed to have.

Gate M1: track a fermionic non-Gaussianity ("magic") monotone through an
interacting quench on a small chain - the designated interacting frontier
after the QNEC pilot. Deliverable: magic injection rate vs coupling, the first
measurement of *where* the graph spends quantumness.

[O] One restrained speculation, flagged as such: energy (demand volume) and
non-Gaussianity (quantum depth) are different resource currencies - the
scheduler prices the first, complexity theory prices the second, and the
equivalence principle says gravity sees only the first. Whether the second has
any gravitational shadow at all is a well-posed question the program is not
yet entitled to answer.

## Matter content: erasability and the Z_16 dichotomy

Why these particles? The erasability frame (v2 section 5.3): a mirror sector
can be symmetrically gapped iff it carries no 't Hooft anomaly - iff it stores
no protected logical information - and the per-generation **16 of Spin(10)**
is the canonical anomaly-free (erasable) multiplet.

The Round 5 audit corrected and *upgraded* the claim. The objection: the
15-Weyl Standard Model already cancels all perturbative (local) gauge and
gravitational anomalies, so "anomaly freedom mandates nu_R" is false as
stated. The repair [T]: the defensible statement is **global** - the Standard
Model carries a Z_16 global (Dai-Freed-type) anomaly, and its cancellation
requires 16 Weyl fermions per generation, i.e. exactly the right-handed
neutrino nu_R, **or** an exotic gapped topological sector in its place
(Garcia-Etxebarria-Montero; Wang-Wen). This is literature-grade mathematics,
and it is precisely the erasability logic in its sharpest known form: the
mirror/completion sector must carry zero protected information mod 16.

The package claim, now a genuine dichotomy (T-adjacent, confidence 6/10):

> **The tower mandates either three right-handed neutrinos or a topological
> dark sector.** Both horns are bold, testable in principle, and
> dark-matter-relevant.

If the nu_R horn holds, it buys three mysteries at once (borrowed
phenomenology, honestly labeled - the nuMSM realizes all three with exactly
three nu_R's): neutrino masses via seesaw, baryogenesis via leptogenesis, and
a keV-scale sterile dark-matter candidate. The program's native secondary
candidate stays registered: stable topological modes of the graph
(harmonic-cochain excitations, cousins of the Lambda sector), which would also
gravitate without gauge coupling.

[O] The ontological reading closes cleanly. nu_R is the unique fermion in the
multiplet with **no public API**: a singlet under every gauge interaction - a
session that consumes compute (it has mass: internal ticking) and therefore
gravitates (congestion), but publishes nothing on any gauge channel. *Dark
matter is matter with no public interface.* That is not a metaphor bolted on
afterward; it is a literal description of gauge-singlet fields, and the tower
requires at least this one.

## Three generations: the exceptional continuation

The deepest unexplained pattern in physics: matter comes in three copies,
identical except for mass, mixed by the CKM/PMNS matrices. The tower suggests
a continuation that is almost forced by its own logic - and that the Round 5
audit keeps on probation.

[T] The setup. Level 2 used `Herm_2(K)` - the degree-2 determinant - for
spacetime, and Gate I1 showed the physics of that determinant is pairwise
concurrence (2-tangle: mass = entanglement of a null pair). Jordan's
classification says the `Herm_n(K)` family has exactly one exceptional member
beyond the associative tower: `J_3(O)`, the 27-dimensional Albert algebra with
its cubic norm (degree-3 determinant), automorphism group F4, structure group
E6. There is no `J_4(O)`; the tower has exactly one more rung and then
provably stops.

[C] The conjecture (generation triple): spacetime took `Herm_2(C)`; the
internal fiber takes the unique exceptional continuation `J_3(O)`. Its three
primitive idempotents are the three generations. This is the
Todorov-Dubois-Violette / Boyle program, adopted with an information-theoretic
twist [T]: just as `det_2` = concurrence (2-tangle), the natural degree-3
invariant of three qubits - Cayley's 2x2x2 hyperdeterminant - *is* the
3-tangle (Coffman-Kundu-Wootters). The pattern reads:

```text
det_2 = mass = 2-tangle        (spacetime / kinematics)
cubic norm = flavor = 3-tangle (internal fiber / generations)
```

[C] Gate F1 (on probation after audit): the one measured pure number of
tripartite flavor structure is the Jarlskog invariant `J ~ 3 x 10^-5`.
Conjecture: `J` is, up to normalization, a tripartite entanglement monotone of
the flavor state. The audit found the gate as first stated under-determined -
there are many inequivalent embeddings of flavor data into 2x2x2 tensors, so a
positive result could be numerology. F1 now requires a pre-registered
canonical construction, with its rephasing transformation properties proven
first, before any numbers are computed. Confidence stays low (3/10); honesty
is cheaper than enthusiasm.

[O] If any version survives: flavor mixing is the geometry of triple
concurrence, CP violation is the universe's irreducibly-three-party
entanglement, and the answer to "why three generations?" is the same as the
answer to "why does the Jordan tower stop?" - because after spacetime spends
the associative determinants, exactly one exceptional cubic norm remains, and
it is three-by-three. The octonions, evicted from spacetime by the dimension
chain, are exactly what is left over to build it from.

## Gravity: congestion, source visibility, and the Weinberg-Witten obligation

The gravitational branch remains the most ambitious, and it now has three
sub-layers: the congestion reading (what gravity is), the source-visibility
program (what sources it), and the obligations the program has accepted to
earn the picture.

**Congestion** [M/T/O]. The program's verified numerics already contain the
key fact: in the causal-scheduler gravity suite, gravitational time dilation
emerges from pure tick counting - proper time along a worldline is the number
of scheduler ticks received, and worldlines in dense regions receive
relatively fewer. No metric was put in. [O] Read ontologically: a
concentration of mass-energy is a concentration of processing demand; the
scheduler serves the whole causal order; per-process service rate drops where
demand crowds. **Gravitational time dilation is lag.**

[T] The law governing the congestion is derivable from information
constraints. The Bousso covariant entropy bound lives on light sheets and
states that the entropy crossing a light sheet is bounded by its initial area
in Planck units. In graph language: **area is channel count** - a 2-surface's
area is the number of null strands threading it, and the bound says you cannot
push more information through a null bundle than it has strands. Jacobson's
derivation (Clausius or entanglement-equilibrium form) then produces the
Einstein equation from the requirement that the first law hold on every local
horizon:

```text
G_{mu nu} = 8 pi G T_{mu nu}   reads:   capacity response = 8 pi G x demand.
```

The right side is the local ops-rate density (energy). The left side is the
geometry's answer: how the sufficient statistic must curve so that no null
channel is ever oversubscribed. The null energy condition that keeps it
attractive descends from monotonicity of relative entropy - the DPI
(Faulkner et al.; Ceyhan-Faulkner). [O] So: **gravity is the flow-control
protocol of the cosmic network.** Curvature is congestion pricing. The
Einstein equation is the load-balancing law, enforced not by a mechanism but
by an inequality - gravity is the impossibility of information growing along a
channel, experienced from inside as attraction.

[M] Supporting evidence, Round 5: the discrete QNEC pilot on the 1+1d
free-fermion chain passed - fitted central charge `c = 1.0000`, zero
violations of the plain discrete QNEC, and the improved (saturating) bound
holds from the allowed side once a computable stencil error is corrected. The
discrete QNEC must be stated stencil-aware; then saturation is exact
(commitment C10).

**Source visibility** (retained; the program's finite target). Define a finite
diamond source functional schematically as:

```text
S_D(rho_full)
= pairing between observer-visible stress/source data and diamond test data.
```

The central question is whether hidden/internal/vacuum bookkeeping lies in the
kernel of this functional, or contributes only a boundary term:

```text
S_D(rho_hidden) = boundary term or zero
S_D(rho_visible_mass) != 0.
```

This is naturally adjacent to holographic causal-diamond language.
Bousso-style screen bounds and Holographic Space-Time models emphasize that a
causal diamond's physical content should be encoded by finite screen data.
The null-edge program should use that literature as a guardrail, not as
something already derived. The finite task is to say exactly which diamond
observer channel sees a bulk source and which bookkeeping is only
boundary-visible. The program must distinguish: visible momentum closure; BF
or surface closure; observer invisibility; boundary-exact bookkeeping; bulk
source pairing; residual fluctuation scaling.

A source functional is still not gravity by itself. To become a gravitational
claim, the branch must also specify a response law, a conservation identity, a
universality or equivalence-principle statement, and a continuum or scaling
limit. Note that the node bootstrap (Level 3.5) now supplies the universality
statement from a different direction: soft spin-2 consistency forces universal
coupling - the scheduler prices demand, not process type. Jacobson-style
derivations recover Einstein dynamics only after substantial geometric and
field-theoretic assumptions; they are guardrails, not proof that a finite
diamond source functional already reproduces gravity.

**The obligations** (Round 5 and 6; new, and binding).

1. **Weinberg-Witten, confronted.** The theorem forbids a massless spin-2
   particle composite of a Lorentz-covariant QFT with a covariant conserved
   stress tensor. Every emergent-gravity program dies here unless it names its
   dodge. The program's dodge [M], two independent layers: (i) the graph is
   not Lorentz covariant per sample - only in distribution - so WW's
   hypotheses fail at the substrate exactly as they fail for phonons on a
   crystal, but with the symmetry statistically exact so no observable
   violation leaks; (ii) the equation-of-state route never introduces a
   graviton operator in the matter Hilbert space at all - the metric is a
   sufficient statistic, and gravitons are collective hydrodynamic modes of
   the ensemble. The cost, honestly: the program must *exhibit* the graviton
   as a collective mode with the right propagator. Registered as Gate G1'.5,
   with failure mode F-WW in the ledger: if the ensemble's collective modes
   cannot reproduce a massless spin-2 pole (statistically), the gravity sector
   fails regardless of the entropic derivation.
2. **The type mismatch, repaired in sketch.** The DPI -> QNEC machinery is
   proved in type III von Neumann algebras; finite graphs are type I; "take
   the continuum limit" is not an argument (failure mode F-M2). The modern
   crossed-product results (Chandrasekaran-Longo-Penington-Witten and
   successors) show that including gravity and an observer converts the type
   III algebra of a horizon into type II - an algebra with a trace and finite
   entropies, sitting between the graph's type I and the naive continuum's
   type III. The repaired conjecture: the continuum limit of the null-graph
   algebras is the type II crossed product, with type III recovered only in
   the strict G -> 0 limit. Hard, but now shaped like mathematics rather than
   like hope.
3. **RG, in the tower.** The continuum limit now has its selection principle:
   coarse-graining flows downhill in c/F/a (the null-cone monotones), and the
   fixed point the graph must hit is the one its null-deformation monotones
   permit.

## Black holes: where demand wins

[T] Four established facts, one silhouette. (1) The Bekenstein bound caps the
information a region of given size and energy can hold; black holes saturate
it - they are maximal-density memory. (2) Black holes are conjectured to be
nature's fastest scramblers, and the chaos bound
`lambda_L <= 2 pi k_B T / hbar` caps scrambling by temperature - the thermal
clock limit; black holes saturate that too. (3) From outside, the horizon is
write-only: infalling data updates the state (the area grows) but cannot be
addressed. (4) The Page curve, in its modern derivations, says the data is not
destroyed; unitarity wins; the information re-emerges, scrambled beyond any
practical decoding, in the Hawking flux.

[O] The computational silhouette:

> **A black hole is what happens when local processing demand exceeds every
> capacity bound at once.** The scheduler's response is not to crash but to
> seal: wall the region behind a write-only interface, run it at the saturated
> thermal clock rate, maximally parallel, maximally scrambled, and stream the
> memory back out on the slowest timescale in physics. A black hole is the
> universe's swap file - and Hawking evaporation is the flush.

[T->O] The deeper point hiding in unitarity: Landauer's principle prices
erasure, but unitary evolution never erases. The universe, run as a quantum
computation, is a reversible computer that never frees memory. What we call
entropy increase is not data loss; it is *pointer loss* - information
migrating into correlations too dispersed to address (decoherence is exactly
this migration).

> The Second Law, ontologically: **the universe never forgets; it only
> misfiles.** Entropy is the growing gap between what is stored and what is
> addressable.

[T] A geometric coda from Round 6: complexity = volume/action gives the
interior its meaning - interiors grow after thermalization because
computation continues after entropy saturates, at the Margolus-Levitin/Lloyd
rate; the interior is that continued computation made spatial. ER = EPR joins
as the one-liner it deserves: a wormhole is a maximally shared session.

## Measurement, memory, and the commit ontology

In this ontology, an observer is represented by a channel or quotient of the
full interaction data. Measurement is not merely revealing a pre-existing
particle property. It is imposing a physically available algebra on a richer
interaction pattern.

The same edge or chain can be: invisible to one quotient; visible to a
spectral observable; removable by gauge; homologically trivial as a boundary;
source-carrying for a diamond functional. Thus "null" is observable-relative.
A null edge is not an edge with no content. It is null with respect to a
specified invariant or observer map.

The information-theoretic sharpening has two distinct parts (retained,
load-bearing):

```text
observer-invisible
= distinct fine sources have the same or nearly the same observer output

recoverable
= fine information can be reconstructed from the observer output and a
  reference state/channel.
```

Relative entropy, data processing, and Petz-style recoverability are natural
finite tools for making reversibility precise. They are not automatic
invisibility theorems. In P9 source-visibility language, invisibility must be
defined by the chosen diamond source functional or observer algebra; a small
recoverability gap is evidence that coarse-graining is reversible, not that a
source has been erased.

**The memory architecture** (new; it-from-commit). [T] The maximum entropy of
a region scales with its boundary area, not its volume; in AdS/CFT the
three-dimensional interior is provably reconstructable from boundary data via
an error-correcting-code structure (Almheiri-Dong-Harlow) - bulk operators are
logical operators of a boundary code. [O] In computing there is a name for
state that is not stored but recomputed from a smaller record on demand:
lazily evaluated. The bulk is a cache. Interior space is the derived layer,
rendered from a lower-dimensional ledger when a query - an interaction, a
measurement, a message arrival - forces evaluation. Nothing about this makes
the interior less real; it makes it contingent on the ledger, which is what
the code structure says with precision.

[T] And which data makes it into the *classical* record? Zurek's quantum
Darwinism: classicality is redundancy. A state becomes an objective classical
fact exactly when the environment has broadcast many redundant copies of it.
Objectivity is not a metaphysical primitive; it is *publication*.

[O] The measurement problem, restated as systems engineering:

> **Superposition is uncommitted working memory. Decoherence is the commit
> protocol. The classical world is the public ledger** - the massively
> replicated, effectively immutable subset of the universe's state. A
> "measurement outcome" is a fact that has been published too widely to roll
> back. The arrow of experienced time is the append-only property of the
> ledger; un-publishing requires recapturing every copy, which the DPI prices
> at impossible.

Wheeler said *it from bit*. The null-edge ontology sharpens the slogan: bits
are cheap and reversible; what makes a *fact* is the irreversible, redundant,
causally-broadcast write. **It from commit.**

Note the load-bearing convergence with the gauge section: the redundancy that
quantum Darwinism needs for the ledger and the redundancy of gauge description
are the same architectural resource - the memory fabric's stabilizer
structure.

## Lambda and the finite machine

[T] If the observed accelerated expansion is a true cosmological constant, the
future is de Sitter space, whose horizon carries entropy
`S_dS ~ 3 pi / (Lambda G) ~ 10^122` - and the N-bound conjecture (Bousso;
Banks) takes this as the dimension of the total Hilbert space available to any
observer: `dim H ~ e^{10^122}`. Lloyd's accounting from the other end: the
universe within our horizon has performed at most `~10^120` elementary
operations on `~10^90` bits of matter.

[O] Read jointly: **the cosmological constant is the reciprocal of the
universe's RAM.** Lambda small = memory vast; Lambda = 0 would be the infinite
machine; the observed Lambda > 0 is the announcement that the machine is
finite.

[M/C] The program's account of its *size*: Lambda is conjugate to node count,
and its value is Poisson shot noise, `Lambda ~ +-1/sqrt(N)` - the counting
fluctuation of the causal measure (harmonic zero mode + shot noise, v2
section 7). The one free-standing numerical success in this subject (Sorkin's
everpresent Lambda, predicted at the right order before 1998) is, in this
reading, the universe's memory size showing through as sampling noise.

This is now a **live commitment** (Round 5, C4): dark energy is not a
constant - Lambda is everpresent, stochastic, `|Lambda| ~ 1/sqrt(V)`, tracking
ambient density, capable of sign excursions. DESI DR2 reports up to ~4 sigma
frequentist preference for evolving dark energy; Bayesian reanalyses contest
it. The tower is on the record *for* the anomaly being real, with everpresent
Lambda phenomenology as its shape. Kill-condition: ever-tightening `w = -1`
exactly, at all redshifts, with shrinking error bars. The corresponding
phenomenology paper (P10: everpresent Lambda vs current dark-energy data) is
the program's highest-value physics paper.

The retained cautions still bind: the program must either derive an
everpresent-Lambda-style `1/sqrt(V)` fluctuation law from finite
counting/source data, or explain with a concrete observer channel why the
residual amplitude differs; it must avoid contradicting Jacobson-style horizon
thermodynamics; and if hidden bookkeeping generically sources bulk volume, or
source invisibility is imposed rather than derived, the branch should be
demoted.

[O] The run itself has a thermodynamic shape: gravitational clumping explores
the energy landscape; stars are dissipation engines; black holes are terminal
garbage collection; the de Sitter end-state is the machine idling at its
minimum clock. If one insists on asking what the computation is for, the least
anthropocentric answer available is: the universe is an annealer computing its
own ground state, and the expansion is the cooling schedule. Whether that is
deep or vacuous is taken up in "What is it computing?".

## The arrow of time: the capacity race

The Past Hypothesis - the postulate that the universe began in a state of
extraordinarily low entropy - comes close to dissolving in a growth ontology,
and the Round 5 audit sharpened the dissolution into a bolder claim.

[T-adjacent] If the causal order grows (classical sequential growth a la
Rideout-Sorkin; quantum versions open), then at early stages the universe has
few elements. Entropy is bounded by the log of the accessible state space, so
`S_early <= O(N_early log d)`: **a universe that begins small begins
low-entropy as a matter of counting.** The arrow of time is the growth
direction - the direction in which commits accumulate - and spatial expansion
is memory allocation: new nodes, new Hilbert space, new room for entropy to
grow into.

The audit objection (Penrose's actual puzzle): why was the *matter* sector
thermal while the *gravitational* sector was absurdly sub-maximal (smooth
geometry)? A bound on total entropy does not touch the sectoral imbalance.
The repair - and the repaired claim is bolder:

> The early universe was not a low-entropy state of a big system; it was a
> **small system at full capacity**: matter thermal because the allocated
> memory was saturated, gravitationally smooth because the clumping degrees of
> freedom *did not yet exist* - the graph had not yet allocated the
> horizon-scale channels whose occupation is gravitational entropy. The arrow
> exists because **capacity has grown faster than entropy production ever
> since**. There never was a low-entropy state; there was a small universe
> with no room, and room has been outrunning disorder for 13.8 Gyr.

The Second Law becomes: allocated memory only grows, and pointers only get
lost.

Two honest gaps, registered. (i) What plays inflation's role - why the
allocation history produces the observed flatness/homogeneity/spectrum - has
no native mechanism yet; the sharpest target is now the one-number challenge:
produce the primordial amplitude `A_s ~ 2 x 10^-9` from a counting fluctuation
in any natural allocation scheme (Gate G2'). (ii) "Why does N grow?" is
Level-0 bedrock: growth is execution, and asking why there is execution is
asking why there is anything running rather than a static text.

## Why we see no pixels

The standard objection to any discrete ontology: where are the lattice
artifacts? Why is Lorentz symmetry so brutally exact?

[T] The constraints are real and severe: Fermi-LAT gamma-ray-burst timing
pushes linear Planck-scale dispersion beyond the Planck energy; the Holometer
found no holographic jitter; causal-set swerve diffusion is tightly bounded.
Any honest discrete ontology must explain not why discreteness shows, but why
it hides so well.

[M] The program's answer was forced for internal reasons: the ontology is not
a crystal but an ensemble - a Poisson-type measure over null graphs, Lorentz
invariant in distribution (Bombelli-Henson-Sorkin). A sample has no symmetry;
the statistics have it exactly.

[O] Heard as engineering: a regular grid is a *bad* scheduler substrate - it
has resonances, preferred directions, aliasing. Every high-performance
distributed system randomizes: hashed sharding, randomized routing, jittered
clocks, precisely so that no workload can align with the substrate and no
measurement from inside can detect a preferred frame of the infrastructure.
Poisson sprinkling is what maximum-entropy load balancing looks like.

> **Lorentz invariance is the no-preferred-scheduler theorem.** We see no
> pixels because a well-randomized substrate provably shows none in
> distribution. The absence of artifacts is the artifact.

[O, falsifiability clause] This is the ontology's most testable edge, and the
ledger must say so: residual signatures of a random null substrate live in
*fluctuations*, not dispersion - everpresent-Lambda dynamics (arguably already
seen), swerve-type diffusion (bounded, not excluded), and non-Gaussian
corrections to horizon-scale statistics. If all such channels close to zero
with unlimited precision, the graph becomes unobservable in principle and this
section collapses from physics into metaphysics. Registered.

## Observers: the subroutines that compress

[T] Three anchors. (1) All perception is of the past: every input any
observer receives arrives on null or timelike channels - no observer has ever
experienced "now," only a merge of the message queue. (2) The thermodynamics
of prediction (Still-Sivak-Bell-Crooks): a driven system dissipates at a rate
set by the non-predictive part of its memory - retaining information about the
input that does not help predict its future costs free energy. Systems that
model well, dissipate less. (3) Landauer: maintaining memory against noise has
an energy price, and the budget is finite.

[O] Put together, these select something. In a universe of fixed compute
budget where prediction is thermodynamically cheaper than reaction, the
long-run survivors among message loops are the ones that *model their input
streams* - that compress. Life is not an anomaly the computational universe
must excuse; it is the universe's cache-optimization layer, thermodynamically
favored wherever energy gradients pay for memory:

> **Observers are the subroutines that compress.** A mind is a message loop
> that got so good at predicting its queue that it started modeling itself as
> part of the stream. Attention is the allocation of a finite tick budget
> across the model - attention *is* energy, locally. The felt flow of time is
> the append rate of the loop's own commit log. Your "now" is your latest
> merge. Your past is your ledger. Your self is not a datum anywhere in the
> graph - it is the process, the updating itself.

[O] Two consequences worth one sentence each. Other minds: when two observers
interact, each holds a compressed, slightly stale model of the other - cached
copies, refreshed by messages, never synchronized, because there is no global
cut. Death: a process ontology relocates what ends - the loop halts; the
ledger remains; every commit already published into the causal order is, by
unitarity, never erased, only progressively misfiled.

This section is deliberately outside the tower (Round 4's irreducible core):
it is a theory of the *function* of observers, not of the existence of
experience.

## The Born rule (residual)

[C] The last foundational IOU, with two routes registered:

1. **Gleason route** (R4-5, Gate B1). On the graph, node statistics must be
   invariant under the null-splitting gauge (the little-group SU(2) - pure
   redundancy, physically empty). A noncontextual probability assignment on
   the projection lattice of a fiber of dimension >= 3 is forced by Gleason's
   theorem to be Born; the POVM strengthening covers dimension 2. Conjecture:
   splitting-gauge invariance + noncontextuality across node decompositions =
   the graph-native hypotheses of a Gleason-type argument, making the Born
   rule the unique consistent tick-statistics on the network. Confidence
   moderate as mathematics; the philosophical residue (why noncontextuality?)
   is binned honestly at Level 0.
2. **Histories route** (Round 6). Sorkin's quantal measure / decoherence
   functional framework is the histories-native probability calculus, built
   for causal sets; strong positivity is the axiom to test against the graph's
   node algebra.

## Smaller unifications, filed

- **Tsirelson's bound** [T]. Why are quantum correlations exactly this strong
  and no stronger? Information causality (Pawlowski et al.): stronger-than-
  quantum correlations would let a receiver extract more information than was
  transmitted. A network-accounting axiom - Level 0 material - capping
  correlations exactly at Tsirelson. The graph forbids PR-boxes for the same
  reason it enforces the DPI: the books must balance. Gate IC1: locate
  information causality relative to the Level-0 axioms (inherited vs
  independent).
- **Area law from the gap** [T/C]. Hastings: in 1d, a spectral gap implies an
  area law. The Gate C1 gap therefore does triple duty - chirality release
  (code distance), locality (correlation length), and the memory architecture
  itself (area-law entanglement). Higher-d is conjectural; noted. The flagship
  Lean theorem is quietly also the program's area-law license.
- **Hierarchy, re-filed** [C]. The datum was misfiled as "why is the Higgs
  mass small"; the measured value places the SM vacuum near the metastability
  phase boundary, so the mystery is "why critical." Growing networks
  generically self-organize toward criticality; named mechanism class, named
  check (does the graph growth measure exhibit self-organized criticality in
  its coupling flows?). Still weak (2/10) - but now a question instead of a
  shrug.
- **ER = EPR** [T->O]: a wormhole is a maximally shared session.

## What is it computing?

The question everyone asks, with the four honest answers, in ascending order
of boldness.

**Deflationary [O].** Nothing. "Computation" is our best current compression
of the trace, as "mechanism" was Newton's and "geometry" Einstein's. This
answer is fully available and should be kept loaded as ballast.

**Reflexive [T-adjacent].** Itself - and necessarily so. A computer cannot
simulate itself faster than it runs, so the universe is its own fastest
simulator, and physical law is precisely the compressible part of the trace.
That laws exist means the trace is astonishingly compressible; that time
exists means it is not fully compressible - **time is the irreducible part of
the execution.** The unreasonable effectiveness of mathematics becomes the
observation that we are subroutines running the same compression the trace
admits.

**Thermodynamic [O].** Its own equilibrium: an annealer with a Lambda-driven
cooling schedule, output = the de Sitter ledger. Bold, quantitative, bleak.

**Reflexive-anthropic [O, maximum boldness].** The universe computes
descriptions of itself, and we are where that computation currently peaks -
not by design, but by the thermodynamic selection of compressors operating on
a substrate whose laws are compressible. Formal verification - the activity
this research program lives by - is then the sharpest available instance of
the phenomenon: the universe, machine-checking its own compression. This
answer cannot be tested and should be enjoyed rather than believed.

## Candidate finite action principle

The ontology needs a finite variational object. A useful schematic candidate
is:

```text
S = S_null + S_vertex + S_holonomy + S_visibility.
```

Here:

```text
S_null
```

enforces primitive nullity:

```text
det(psi_e psi_e^dagger) = 0.
```

```text
S_vertex
```

enforces local conservation and legal internal transitions:

```text
sum_in P_e - sum_out P_e = allowed source / sink defect
```

together with charge, chirality, and representation constraints. The node
bootstrap (Level 3.5) constrains what "legal" can mean: the vertex set is not
a free design choice but the unique consistent decoration.

```text
S_holonomy
```

weights gauge curvature defects:

```text
sum_diamond Re Tr(1 - U_loop).
```

```text
S_visibility
```

weights observer-visible source defects:

```text
sum_diamond F(Omega(rho_full), screen_data).
```

The operator-style version is:

```text
S = Tr f(D_D^2) + vertex constraints + boundary terms
```

with:

```text
D_D = d_U + delta_U + Phi + Phi^dagger.
```

The desired square is:

```text
D_D^2 =
  graph Laplacian
  + gauge curvature
  + Higgs / Yukawa mass blocks
  + visible Pluecker scalar
  + boundary / source terms.
```

This should become the mathematical spine of the synthesis.

## Theorem targets and gates

### Theorem A: frame-audited observer-channel mass-ratio theorem

Let the full state be a pure null-edge state:

```text
|Psi> = sum_i c_i |psi_i>_vis tensor |a_i>_int.
```

Trace out internal labels:

```text
rho_vis = Tr_int |Psi><Psi|.
```

After fixing the observer energy normalization `Tr(P) = 2E`, the visible mass
ratio is:

```text
m / E = 2 sqrt(det rho_vis).
```

Interpretation:

```text
mass ratio m/E = concurrence / mixedness generated by hidden null-direction
                 information.
```

This is a useful bridge between the Pluecker theorem and quantum information,
but it is frame-relative because the normalization by `Tr(P)` uses the chosen
time component. The Lorentz-invariant theorem is the unnormalized statement
`det(P) = m^2`, together with `det(A P A^dagger) = det(P)` for
`A in SL(2,C)`. A new Lean target should make the contrast explicit:

```text
det_normalizedMomentum_eq_det_div_trace_sq
sl2_det_conj_invariant
normalized_mixedness_is_frame_ratio
observer_twoNullDecomposition_sum_eq_momentum
observer_twoNullDecomposition_each_null
```

### Theorem B: massless iff recoverable null direction

For the visible qubit:

```text
m = 0
<-> rho_vis is pure
<-> the visible null direction is recoverable
<-> the observer has no hidden which-direction uncertainty.
```

The recoverability statement must be made physically precise. In the minimal
finite version, it can mean that `rho_vis` is rank one and therefore
determines a single point of celestial `CP^1`. A stronger Petz-style recovery
theorem should wait until the observer channel and reference state are fixed.

The safe claim is about recoverability of the visible null direction, not
automatic recovery of the entire internal microstate. It would be too strong
to claim, without extra hypotheses, that a heavier particle means larger Petz
failure for all internal labels, or that a massless particle implies perfect
recovery of the full hidden sector.

### Theorem C: rest frame as maximal celestial mixedness

For normalized `rho_vis`:

```text
rho_vis = I / 2
<-> spatial momentum vanishes
<-> rest frame
<-> m / E = 1.
```

This is clean, finite, and physically interpretable, but it should now be
read as a frame-dependence witness. Maximal normalized mixedness identifies
the rest frame of a timelike bundle; boosting the same invariant `P` changes
`rho_vis = P / Tr(P)` while leaving `det(P)` fixed.

### Theorem D: gauge curvature as non-recoverable path information

For two histories `gamma_1` and `gamma_2`:

```text
Delta U = U_gamma_1^{-1} U_gamma_2.
```

Gauge curvature is nontrivial exactly when the internal comparison data cannot
be compressed to one path-independent transport. This should first be stated
as a finite holonomy-defect theorem, then only later as an
information-theoretic recoverability statement.

### Theorem E: finite super-Dirac square

Construct:

```text
D = d_U + delta_U + Phi + Phi^dagger
```

on a doubled chiral/internal edge complex. Prove its square decomposes into:

```text
D^2 =
  finite wave / Laplacian term
  + holonomy curvature
  + Higgs / Yukawa chirality-flip mass block
  + visible Pluecker determinant block
  + boundary / source defect.
```

This should be stated as a finite Weitzenbock/Lichnerowicz-style matrix
identity plus one genuinely program-specific block identification. The generic
fact that a Dirac-type operator squares to Laplacian plus curvature and
zero-form mass terms is standard. The potentially new theorem is narrower: the
Higgs/Yukawa or visible scalar block of this finite square must be shown to
equal the Pluecker determinant mass block already proved in the spinor
theorem.

### The gate register (from Rounds 4-6)

The tower's named gates, as they bear on this document. Detailed statements
live in the round documents; base priority is unchanged (the Lean gate ladder
first - the tower is only as real as its foundation).

```text
D1    Herm_2(K) ~= Minkowski classification + local-tomography
      multiplicativity criterion, in Lean (dimension chain)
B1    Gleason (POVM form) + splitting-gauge wrapper (Born rule)
F1    Jarlskog / 3-tangle test - ON PROBATION until a pre-registered
      canonical construction exists (generations)
NB1   Jacobi-from-consistency on tetrahedral null kinematics (forced
      dynamics -> [M])
SS1   (Bisognano-Wichmann on graph wedges) => spin-statistics, conditional
      form (spin-statistics/PCT)
G1'.5 linearized spin-2 collective mode of the null-graph ensemble with the
      correct two-point structure (the Weinberg-Witten obligation)
M1    non-Gaussianity (magic) injection rate in an interacting quench
IC1   information causality's place relative to the Level-0 axioms
G2'   primordial spectrum / the A_s one-number challenge from a growth
      measure
P10   everpresent-Lambda vs current dark-energy data (phenomenology paper;
      commitment C4's discriminator)
```

## Extended dictionary

The interaction dictionary and the computational dictionary, merged. Where the
two give different glosses of the same entry, both are kept - the first is the
channel reading, the second the commit reading.

```text
event
= node in causal incidence structure

null edge
= primitive lawful transition carrying rank-one visible spinor momentum
= a message: pure data transfer, no computation

history
= compatible finite composition of null transitions

observer
= physical channel / quotient from full null-edge data to visible algebra
= a compressor modeling its own input queue

particle
= stable idempotent / eigenpattern of the null-edge transfer algebra
= a session: a self-sustaining message loop

mass
= determinant / mixedness of the observer-visible null-direction state
= clock rate of the L/R chirality conversation

energy
= allocated update rate; the budget itself (Margolus-Levitin)

rest
= a balanced loop; dynamic equilibrium of the conversation

proper time
= accumulated visible impurity of a null-edge process
= the node's own modular tick count

distance
= message latency (null-hop count); the metric is latency statistics

charge
= conserved internal flow label under allowed vertex transitions
= a syndrome: the fabric's memory of where its code was violated

Higgs / Yukawa coupling
= legal odd chirality-changing operator that creates stable visible mixedness
= the exchange rate of the L/R dialogue; the vev is a standing offer

gauge field
= comparison rule for internal labels along alternative histories
= the error-correcting code layer of the network

gauge curvature
= finite holonomy defect between alternative histories

force
= flow control between sessions; propagation of an error syndrome

antimatter
= the wedge ledger read in its own modular reflection (PCT = J_mod)

dark matter
= gravitating sector with no public API (gauge-singlet sessions)

measurement
= imposition of an observer channel that selects a stable visible algebra
= publication into the redundant environment record

classical fact
= a commit: redundantly published, effectively irreversible

the quantum state
= uncommitted working memory

the present
= a consistent cut; observer-local latest merge

entropy
= the addressable/stored gap: pointer loss, never data loss

black hole
= saturated region: write-only, thermal-clocked, slowly flushed

Lambda
= 1/RAM: the finiteness of the machine, audible as shot noise

gravity
= finite-diamond thermodynamic response to observer-visible source defects
= congestion; the DPI experienced from inside

laws of physics
= the compressible part of the trace

time
= the irreducible part: execution itself

spin
= projective spinor phase coherence not captured by scalar mass

spacetime
= reconstruction from causal order, counting, null incidence, and stable
  observer channels

the self
= the updating, not the updated
```

## Implications

If the observer-channel/computational interaction ontology is right, the
following become guiding expectations:

1. **No primitive massive bead.**
   Massive particles are stable sectors of null interaction channels -
   sessions, not substances.

2. **Mass is channel-relative but invariant after the channel is fixed.**
   It measures spread, mixedness, or entanglement of visible null components,
   not an intrinsic property of a single fine edge. Equivalently, it is the
   clock rate of a chirality conversation.

3. **Energy is the budget.**
   Where more happens per second, there is more energy; the Hamiltonian is
   the scheduler, and conservation of energy is the fixity of the budget.

4. **Proper time is visible impurity - and spend rate.**
   A process accumulates proper time at the rate its visible null-direction
   state fails to remain pure; `m/E` is the fraction of budget spent on being
   rather than going.

5. **The Higgs is a legal entangling gate.**
   Higgs/Yukawa couplings determine which chirality-changing internal
   transitions are legal and how strongly they generate stable visible
   mixedness; the vev is a standing offer of dialogue.

6. **Spin is phase-coherent structure; statistics is modular.**
   Spin belongs to the coherent spinor and representation data left over
   after the scalar mass compression; spin-statistics and PCT are inherited
   from wedge modular covariance, and antimatter is the modular mirror.

7. **The dynamics is forced.**
   The only consistent vertex decorations are Yang-Mills, one universal
   graviton, and Yukawa couplings; Jacobi is routing associativity, and the
   equivalence principle is type-blind congestion pricing.

8. **Gauge structure is the code layer.**
   Curvature is holonomy defect across diamonds; charge is a syndrome; charge
   quantization is automatic from compact holonomy.

9. **Gravity is source visibility and congestion.**
   Bulk curvature responds only to the part of interaction bookkeeping
   visible to the appropriate diamond or screen source functional; the
   response law is the load-balancing form of the DPI on null deformations.

10. **The matter content is a consistency condition.**
    The Z_16 dichotomy mandates either three right-handed neutrinos or a
    topological dark sector; dark matter is matter with no public interface.

11. **Classicality is commitment.**
    Facts are commits: decoherence publishes, redundancy makes objective, and
    the DPI prices rollback at impossible.

12. **The arrow is a capacity race.**
    A universe that begins small begins low-entropy by counting; room has
    been outrunning disorder ever since, and expansion is memory allocation.

13. **No pixels, by randomization.**
    Lorentz invariance in distribution is the no-preferred-scheduler theorem;
    the discreteness signature lives in fluctuations, not dispersion.

14. **Quantum theory is native - and its hardness is localized.**
    Histories carry amplitudes from the beginning; the free sector is
    classically simulable, and quantum depth is purchased exactly at the
    forced interaction vertices.

## Claim-status ledger

| Claim | Tag | Current status |
|---|---|---|
| A finite bundle of null spinors can have timelike total momentum | [T/M] | Banked finite algebra |
| The determinant mass equals total pairwise Pluecker spread | [T/M] | Banked finite algebra |
| Unnormalized `det(P) = m^2` is the Lorentz-invariant mass scalar | [T/M] | Banked finite algebra / near Lean wrapper |
| Masslessness is equivalent to common visible null direction | [T/M] | Banked finite algebra |
| Mass of a two-null bundle = pairwise concurrence (2-tangle) | [M] | Gate I1 |
| Normalized mass ratio `m/E` is visible celestial mixedness after a frame or observer-time convention is fixed | [M/C] | Strong finite target with partial draft support; prior-art and frame audit required |
| Rest frame is maximal celestial mixedness | [C] | Strong finite target and frame-dependence witness |
| Proper-time rate equals visible impurity | [C] | Strong finite target; physics interpretation requires frame and clock-construction audit |
| The Dirac slash of bundle momentum squares to the Pluecker scalar | [M] | Kernel-clean draft support |
| Higgs/Yukawa insertion is the gauge-legal chirality-flip gate | [T/M] | Kernel-clean bookkeeping support plus standard physics |
| Visible mixedness appears after chirality dephasing, partial trace, detector restriction, or observer channel | [C] | Conjectural finite channel target |
| Gauge curvature is causal-diamond holonomy defect | [M] | Banked finite gauge theorem |
| Particles are stable channel sectors | [C/O] | Ontological and operator-theoretic conjecture |
| Particle identity resembles a finite superselection-sector problem | [C] | Loose analogy and formal target, not DHR correspondence |
| Page-Wootters clock language explains proper time | [C] | Research lead beyond the finite mass-ratio identity |
| Energy is maximum update rate (ops per second) | [T] | Margolus-Levitin; definitional reading of E = hbar omega |
| Photons perform no computation (nullity = purity = no modular flow) | [T] | Finite-dimensional statement banked; continuum reading interpretive |
| Matter is a two-register L/R exchange at rate m | [T/O] | Weyl-basis Dirac + zigzag/checkerboard; ontological gloss labeled |
| QM over C is derivable from purification + local tomography | [T] | CDP reconstruction; real QM experimentally falsified |
| 3+1 dimensions from local tomography (dimension chain) | [T given M] | CONDITIONAL derivation given soldering-fundamentalism; kill-condition C1 |
| The dynamics is the unique consistent decoration of the graph | [T->M] | Soft theorems + 4-particle consistency; transplant pending Gate NB1 |
| Spin-statistics and PCT from wedge modular covariance | [T, conditional] | Guido-Longo; hypothesis = finite Bisognano-Wichmann (A1) extended; Gate SS1 |
| Gauge theory = quantum error-correcting code; charge = syndrome | [T] | Toric code / string nets; absorbed |
| Free sector classically simulable; hardness only at vertices | [T] | Matchgate/Gaussian theorems; Gate M1 for the interacting frontier |
| Z_16 dichotomy: three nu_R or a topological dark sector | [T-adjacent] | Dai-Freed anomaly literature; upgraded by Round 5 audit (6/10) |
| Dark matter = gauge-singlet sector ("no public API") | [C/O] | Follows the dichotomy's nu_R horn; nuMSM phenomenology borrowed honestly |
| Three generations from J_3(O); mixing as 3-tangle | [C] | On probation; Gate F1 requires pre-registered construction (3/10) |
| ANEC/QNEC/c/F/a-theorems are one monotone on null deformations | [T] | Inventory established; the program makes the null cone primitive |
| Vacuum is Markov on null cuts (null slices are complete checkpoints) | [T] | Established; the fingerprint result |
| Discrete QNEC holds, stencil-aware | [M] | Pilot passed (c = 1.0000, zero violations); commitment C10 |
| Gravity = congestion; Einstein equation = capacity response | [M/T/O] | Tick-counting numerics + Bousso/Jacobson assembly; response-law obligations registered |
| Weinberg-Witten is dodged (per-sample non-covariance; collective mode) | [M] | Dodge on record; obligation Gate G1'.5, failure mode F-WW |
| Continuum limit is the type II crossed product | [C] | Repair sketch for F-M2; crossed-product route |
| Lambda = harmonic zero mode + 1/sqrt(N) shot noise ("1/RAM") | [S/C] | Live commitment C4; DESI-era discriminator = paper P10 |
| Arrow of time = capacity race (small universe at full capacity) | [T-adjacent] | Sharpened form after Penrose objection; growth measure missing |
| Lorentz invariance in distribution; signatures in fluctuations only | [M/O] | BHS ensemble; falsifiability clause registered |
| Born rule from splitting-gauge invariance + Gleason | [C] | Gate B1; histories route secondary |
| Classicality = commit (Darwinism + decoherence + DPI) | [T/O] | Established components; ontological assembly labeled |
| Holographic screen data organize diamond source visibility | [C] | Research lead and guardrail for P9 |
| All elementary visible movement is lightlike | [O] | Guiding conjecture |
| Spin is phase coherence of complex Pluecker data | [C] | Plausible research direction |
| Gravity follows from source visibility of null-edge bookkeeping | [C] | High-risk research direction |
| Vacuum bookkeeping is boundary-like or observer-invisible | [C] | Open P9 target |
| Gate C1 chiral release + Gate C2 index/certified-sign layer | [M] | Kernel-checked draft Lean, 2026-07-03; includes nonzero-flux index witness |

## Commitments and kill-conditions

The boldness core, imported from Round 5: what the ontology *forbids* and
*predicts*, each with its kill-condition. A program is exactly as bold as this
table and exactly as defensible as its honesty about the last column. Full
statements and current experimental pressure live in
`Sources/nrqg-round5-audit-and-commitments.md`.

| # | Commitment | Kill-condition | Status |
|---|---|---|---|
| C1 | No geometric extra dimensions, ever | KK resonances; compact-dimension gravity deviations | Safe so far; genuine exposure |
| C2 | Unitarity is exact - no objective collapse | Confirmed CSL / Diosi-Penrose signal | Collapse parameter space shrinking |
| C3 | No dispersion-type Lorentz violation; fluctuation-type residuals allowed | Confirmed energy-dependent photon dispersion | Currently winning (GRB bounds) |
| C4 | Dark energy is not a constant (everpresent Lambda) | Ever-tightening w = -1 exactly, at all z | **Live** (DESI era); paper P10 |
| C5 | The Z_16 dichotomy: three nu_R or topological dark sector | Neutrinos exactly massless; or DM shown to be neither | Half-confirmed (nu masses exist) |
| C6 | No exact global symmetries (B, L violated at some rate) | Proof/measurement of exact global B | Low-risk boldness, flagged |
| C7 | Black hole information returns | Confirmed information loss | Mainstream; postdiction credit only |
| C8 | Capacity bounds never violated (Bekenstein, ML, chaos) | Any super-capacity observation | Deepest in-principle exposure |
| C9 | Complex amplitudes (local tomography) | Real/quaternionic QM revival | **Won** (network Bell tests) |
| C10 | Discrete QNEC holds, stencil-aware | Violations surviving stencil correction | Pilot passed |

Reading honestly: C3, C7, C9 are inherited winning positions (claimed as
consistency, not victories); C1, C2, C8 are long-horizon exposures with real
teeth; **C4 and C5 are the live wires** where data in motion could vindicate
or wound the tower within years.

## Falsification and demotion criteria

The ontology should be weakened or demoted if any of the following occur. The
first group is retained from the original document; the second group is
inherited from the computational layer and the audit.

Interaction-layer criteria (retained):

- massive propagation cannot be connected to a natural first-order null-edge
  operator;
- the program treats normalized `rho_vis = P / Tr(P)` mixedness as Lorentz
  invariant rather than as a frame-relative `m/E` quantity;
- observer channels make the unnormalized mass scalar arbitrary rather than
  invariant under the physically fixed visible sector;
- stable particle sectors cannot be formulated without adding primitive
  particle labels by hand;
- Higgs/Yukawa chirality mixing cannot be represented as a finite odd
  operator whose square gives the expected mass block;
- the Higgs/channel model cannot show how left/right coupling generates
  chirality coherence, or cannot identify the observer/dephasing/trace
  channel that turns that coherence into visible mixedness;
- spinor phase data cannot be made compatible with the graph holonomy layer;
- the source-visibility branch fails to distinguish visible Pluecker mass
  from hidden/internal bookkeeping, or imposes invisibility instead of
  deriving it;
- hidden bookkeeping generically produces volume-scaling bulk sources;
- the holographic/screen reading supplies only metaphor and no finite diamond
  source functional;
- the continuum limit requires adding non-null primitive structures by hand;
- the ontology merely rephrases quantum field theory without new finite
  theorems, predictions, constraints, or formalized guardrails.

Computational-layer and audit criteria (new):

- per-sample Lorentz invariance is exact at all scales - every fluctuation
  channel (everpresent-Lambda dynamics, swerves, horizon-scale non-
  Gaussianity) closes to zero - leaving the graph unobservable in principle:
  the ontology survives as metaphysics only (registered as its likeliest
  failure mode, and accepted at these odds for the sake of the view);
- any capacity bound breaks: information density beyond Bekenstein,
  state-change beyond Margolus-Levitin, scrambling beyond the chaos bound - a
  single super-capacity observation ends the computational reading outright;
- unitarity fails (true erasure, objective collapse with information loss):
  the never-forgets ledger is falsified and "commit" loses its meaning;
- the area law fails as a fundamental scaling (volume-law fundamental
  entropy): the memory architecture is wrong;
- the ensemble's collective modes cannot reproduce a massless spin-2 pole
  (F-WW): the gravity sector fails regardless of the entropic derivation;
- the null-graph algebras provably do not flow to the type II crossed product
  (F-M2 unrepaired): the continuum gravity chain loses its foundation;
- gate-level failure upstream: if the program's own Lean/numerics gates (C1
  and its successors, the first-law numerics, the discrete QNEC) die, the [M]
  anchors are removed and this document reverts to standalone philosophy -
  which it was always prepared to be, but was written in the hope of being
  more.

## Publication-safe phrasing

The ontology can guide the writing, but the paper should distinguish theorem
from conjecture. A safe high-level phrasing is:

> We propose that massive propagation can be modeled as the visible
> coarse-graining of fundamentally null components through a physical observer
> channel. In this model, each elementary visible step is lightlike and
> massless, while invariant mass square appears as the unnormalized Pluecker
> determinant of the non-collinearity, chirality mixing, or hidden-label
> entanglement of those null components. Normalized visible mixedness measures
> the frame-relative ratio `m/E`.

A stronger speculative version is:

> Interactions, not particles, are fundamental. Particles are stable sectors
> of finite null-edge transfer channels, and mass is an emergent invariant of
> the unnormalized observer-visible null-direction data. Frame-relative
> mixedness describes how that invariant appears to a specified observer
> channel.

The maximal audited statement - every clause load-bearing, every exposure
named - is Round 5's, and it is the strongest thing the program is currently
entitled to say in public:

> This program asserts that reality is a finite, reversible, locally readable
> computation on null messages; it stakes that assertion on ten explicit
> kill-conditions, one of which is already won (complex amplitudes), one of
> which is in live play at DESI (dark energy is not constant), and one of
> which passed its first numerical test (the null energy condition survives
> discretization); it derives, conditionally but formalizably, the dimension
> of spacetime from the readability of quantum states; it upgrades "why is
> there a right-handed neutrino" to a Z_16 theorem with a dark-sector escape
> clause; it replaces the low-entropy initial condition with a capacity race
> it intends to model; and it keeps, at the bottom of everything, a Lean file
> whose compilation is the difference between all of the above being a
> physics program and being a very disciplined poem.

The first form belongs in the main theorem-facing paper. The second belongs
in a clearly labeled ontology section. The third belongs in program documents
and manifestos, with its ledger attached. The it-from-commit material ([O]
throughout) belongs in the companion essay, never in theorem-facing text.

## Summary

The null-edge interaction ontology says that the world is a quantum grammar of
allowed causal-null transitions - equivalently, a finite, reversible, locally
readable computation whose only primitive moves are null messages. A physical
observer channel compresses this grammar into visible states and invariants;
the null-cone monotones say which way the compression can flow. Particles are
stable sectors of the resulting transfer algebra: sessions. Invariant mass is
the determinant of the unnormalized observer-visible momentum block - the
concurrence of null constituents, the clock rate of a chirality conversation;
normalized mixedness is the frame-relative `m/E` shadow of that determinant.
Energy is the update budget itself. Proper time is accumulated visible
impurity - the spend rate of being. Spin is the phase-coherent data discarded
by the scalar mass; statistics and PCT are modular. The interaction vertices
are not chosen but forced, and they are exactly where the universe's quantum
hardness is spent. Gauge structure is the network's error-correcting code;
curvature is history disagreement; charge is a syndrome. Gravity is the
congestion response of the network - the DPI experienced from inside - and
sources only what the diamond channel can see. The matter content is an
erasability condition with a dark-sector escape clause. Classicality is the
commit protocol; facts are what has been published too widely to roll back.
The cosmological constant is the finiteness of the machine, audible as shot
noise. The arrow of time is a capacity race that began when the universe was
small.

The finite Pluecker mass theorem makes the central kinematic idea real; the
derivation tower makes the ontology load-ordered; the audit makes it
falsifiable; the commit layer makes it total. The remaining work is to prove
the dynamical operator story, transplant the forced-vertex theorems onto the
graph, exhibit the collective graviton, land the type II continuum, connect
Higgs/Yukawa bookkeeping to visible mixedness, make spin and phase
graph-native, find the growth measure, and test whether source visibility
gives genuine cosmological-constant leverage - while the Lean gate ladder
keeps the foundation compiled.

## Obstruction geometry: the program may be bigger than mass (2026-06-27)

A lateral read suggests the program is not only "mass from null-edge spread."
It may be a general theory of *when a one-beam / one-branch / one-orbit
description fails*, with mass as the quadratic norm of that failure. The mass
mechanisms in the dictionary are then faces of a single obstruction geometry
rather than a list of analogies:

- **Mixedness** (null bundle): mass is the impurity of a null-direction
  density matrix. Normalize `rho = P / Tr(P)`; in Bloch language `det rho =
  (1 - |r|^2)/4`, so a massless bundle is a *pure* celestial spin state and a
  massive bundle is *mixed*. Equivalently, with `|Psi> = sum_i psi_i (x) |i>`
  the bundle is massless exactly when the spinor direction factorizes from the
  edge-label space: mass appears when the null direction is correlated with
  hidden bundle structure. (Carry only as observer-conditioned language per
  the `docs/NULLSTRAND.md` guardrail.)
- **Stiffness** (Yukawa / electroweak / Higgs): mass is the quadratic normal
  stiffness of a canonical zero locus, a pair `(M, s)` of moduli/orbit locus
  and section/Hessian. See the obstruction-stiffness table in
  `Sources/Null_Edge_Key_Conjectures.md` (conjecture 6).
- **Branch topology** (Gate C): the failure to select one chiral line over the
  branch locus `Z = { q : det D_+(q) = 0 }`.
- **Internal algebra** (Gate H): the forbidden-vs-legal structure of finite
  Dirac/Higgs maps.
- **Forbidden maps**: the absence theorems that say certain dangerous
  operators are not legal at all.

The compact reframing:

> The program classifies the canonical ways a system fails to remain a single
> free null mode: mixedness, stiffness, branch topology, internal algebra, and
> forbidden maps are faces of the same obstruction geometry.

This is a manifesto-level statement. It stays here, clearly labeled, until the
unifying object (the Morse-Bott pair `(M, s)`, conjecture 6) has a finite
theorem spine. A nearby external boundary marker is causal fermion systems,
where fermionic and causal structure are also primitive; the useful question
is whether the Pluecker spread is a simple finite causal-action term, and if
not, what makes the null-transport obstruction algebra distinctive (see the
bibliography addition).

Post-update note (2026-07-03): the obstruction-geometry reading now has a
natural home in the tower - it is the Level 3/4 interface seen laterally, and
the "forced dynamics" result (Level 3.5) is evidence in its favor: the legal
vertex set is itself an absence theorem, the forbidden-maps face of the same
geometry.
