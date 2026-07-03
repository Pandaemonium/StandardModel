# Null-Edge Relational Quantum Geometry — Second Formulation

## The Informational Version

---

## 0. Status, intent, and what changed

This document is a rewrite of the v1 treatise under a single discipline: **every derived quantity — time, mass, energy, metric, curvature, Λ — must be expressible as an information functional of null transport.** Where v1 said "relational," v2 says exactly *which* relation, in the language of quantum information: purity, concurrence, modular flow, relative entropy, sufficient statistics, error correction, counting measure.

Three things happened in the rewrite.

**First, a collapse.** v1 carried three separate mass mechanisms (turn phases at nodes, hidden null motion in an internal envelope, Higgs/Yukawa onsite terms) and two separate geometric stories (cross-term proper time, tetrad-from-moments). These all turn out to be a *single linear-algebra identity* — Cauchy–Binet applied to the spinor soldering — read in five different languages. Section 1 is that identity. It is finite-dimensional, exact, and Lean-formalizable this month.

**Second, a promotion.** The gravity sector of v1 was a grab bag (Regge, CDT, spin foams, "maybe spectral action"). v2 replaces it with the one derivation of Einstein's equations that is *native* to a null-edge ontology: gravity as the equation of state of entanglement, with the null energy condition descending from the data-processing inequality. The null-edge graph is not merely compatible with this derivation; it is the discrete structure the derivation has been implicitly assuming all along, because the entire modular-theoretic chain (half-sided modular inclusions → ANEC → QNEC → focusing) lives on null congruences.

**Third, a demotion.** The regular tetrahedral crystal is no longer the ontology. It is a computational scaffold — the domain of Gate C1, which remains untouched as the active proof spine. The ontology is a *statistical ensemble* of null-edge graphs, Lorentz-invariant in distribution. Raw octonions, E8-as-spacetime, and primitive timelike edges stay discarded.

Nothing here is claimed as established physics. Every section ends in a gate: a statement precise enough to be proved or refuted. The pre-registration discipline of v1 is kept and extended.

---

## 1. One identity, five languages

### 1.1 The soldering

Work in signature $(+,-,-,-)$. Solder any real 4-momentum to a $2\times 2$ Hermitian matrix:

$$
P \;=\; p_\mu \sigma^\mu \;=\; p^0\,\mathbb{1} + \mathbf{p}\cdot\boldsymbol{\sigma},
\qquad
\det P \;=\; (p^0)^2 - |\mathbf{p}|^2 \;=\; p^2 \;=\; m^2 .
$$

This determinant is the whole story. For future-pointing momenta $P$ is positive semidefinite, and the rank dichotomy is:

$$
\boxed{\;\text{rank } 1 \iff \det P = 0 \iff \text{null} \qquad\quad \text{rank } 2 \iff \det P > 0 \iff \text{timelike}\;}
$$

A rank-one PSD matrix factors as $P = \lambda\lambda^\dagger$ for a Weyl spinor $\lambda$. So in v2 the primitive object of the theory is sharpened:

> **A null edge is a rank-one object.** Each edge $e$ carries a spinor $\lambda_e$; its momentum is $P_e = \lambda_e\lambda_e^\dagger$. In density-matrix language: *nullity is purity.* An unnormalized rank-one operator is the momentum analogue of a pure state.

The edge does not carry a clock because a pure state has no internal statistics — nothing for a clock to count. This is v1's "null edges do not age," now as an information statement.

### 1.2 The identity

Let $n$ null edges meet, with total momentum $P = \sum_i \lambda_i\lambda_i^\dagger = LL^\dagger$, where $L = (\lambda_1|\lambda_2|\cdots|\lambda_n)$ is the $2\times n$ matrix of edge spinors. The **Cauchy–Binet formula** gives

$$
\boxed{\;
m^2 \;=\; \det(LL^\dagger)
\;=\; \sum_{i<j} \big|\langle \lambda_i\,\lambda_j\rangle\big|^2,
\qquad
\langle \lambda_i\,\lambda_j\rangle \;=\; \epsilon_{ab}\,\lambda_i^a\lambda_j^b .
\;}
$$

The $\langle ij\rangle$ are the Plücker coordinates of the 2-plane spanned by the columns of $L$ inside $\mathbb{C}^n$ — equivalently, the spinor-helicity angle brackets. Using the standard identity $2\,p_i\cdot p_j = |\langle ij\rangle|^2$ for future-pointing null momenta, this **is** v1's opening cross-term computation

$$
X^2 = \Big(\sum_i e_i\Big)^2 = 2\sum_{i<j} e_i\cdot e_j ,
$$

but now with its algebraic-geometric identity revealed. One identity, five readings:

| Language | Reading of $m^2 = \sum_{i<j}|\langle ij\rangle|^2$ |
|---|---|
| **Relativity** | Proper time lives in cross terms between null edges (v1 §I) |
| **Algebraic geometry** | Mass² is the Plücker norm of a point in $\mathrm{Gr}(2,n)$ |
| **Quantum information** | Mass is pairwise *concurrence* of the edge spinors |
| **Amplitudes** | Massive spinor-helicity: $P^{a\dot a} = \lambda^a_I\tilde\lambda^{\dot a I}$, $m = \det\lambda$ |
| **Statistics** | $LL^\dagger$ is a covariance matrix; mass² is its Gram determinant — the "spread" of the null ensemble |

Sanity check against v1's tetrahedral frame: for $e_A = a(1,\mathbf v_A)$ with $\mathbf v_A\cdot\mathbf v_B = -\tfrac13$, one gets $2e_A\cdot e_B = \tfrac83 a^2 = |\langle\lambda_A\lambda_B\rangle|^2$, recovering $\tau_{AB} = a\sqrt{8/3}$ as the bracket magnitude. Parallel edges have $\langle\lambda\lambda\rangle = 0$: no bracket, no clock.

This gives the v2 slogan replacing v1's:

$$
\boxed{\;\text{Proper time is the concurrence of null polarizations.}\;}
$$

### 1.3 The little group is the splitting gauge

Decomposing a timelike $P$ into two null edges is not unique: the pair $(\lambda_1,\lambda_2)$ can be rotated by $\mathrm{SU}(2)$ (acting on the pair index) without changing $P$. But this $\mathrm{SU}(2)$ is precisely the **massive little group** of modern massive spinor-helicity (Arkani-Hamed–Huang–Huang). The theory therefore gets, for free:

> The internal $\mathrm{SU}(2)$ little-group fiber of a massive particle *is* the gauge redundancy of its decomposition into a pair of null edges.

Spin of a massive particle is not extra structure bolted onto the graph. It is the residual symmetry of the null split.

### 1.4 The S-matrix already knows

This is the strongest external evidence the program has, and v1 missed it. The modern amplitudes program — BCFW recursion, on-shell diagrams, the positive Grassmannian — *already computes interacting QFT by decomposing all internal off-shell/massive momenta into null on-shell pairs and gluing at nodes carrying finite amplitude data.* An on-shell diagram is, structurally, a null-edge graph with node coins. The Grassmannian $\mathrm{Gr}(2,n)$ and its Plücker coordinates, which §1.2 derived from the mass identity, are exactly the kinematic space of that program; positivity corresponds to future-pointing edges.

The interpretive claim of v2: the on-shell-diagram formalism is the *scattering shadow* of the null-edge ontology. Where the amplitudes program treats null decomposition as a computational trick applied to a pre-existing QFT, NRQG proposes it is the microphysics, and the "trick" works because it is undoing an emergence.

### 1.5 Gate I1 (new, finite-dimensional, Lean-tractable)

1. $\det(p_\mu\sigma^\mu) = p^2$ (soldering determinant).
2. PSD rank-one factorization: future-null $\iff P = \lambda\lambda^\dagger$.
3. Cauchy–Binet mass identity $\det(LL^\dagger) = \sum_{i<j}|\langle ij\rangle|^2$ and its equality with the cross-term expansion.
4. Little-group theorem: stabilizer of $P$ under right action on $L$ is $\mathrm{U}(2)$ (with $\mathrm{SU}(2)$ as the spin part).

Every item is finite matrix algebra. This is the cheapest nontrivial formal target in the entire program and can run in parallel with C1 without touching it.

---

## 2. Time is modular

v1's principle "nodes create clocks" gets an exact operator-algebraic meaning via the **thermal time hypothesis** (Connes–Rovelli): a faithful state $\omega$ on an algebra $\mathcal A$ defines its own flow — the Tomita–Takesaki modular flow $\sigma_t^\omega$ — and physical time *is* this flow.

Read on the graph:

- A **single null strand** generates a degenerate algebra whose modular structure is a null translation/dilation — a half-sided flow with no rest point. No clock. (This degeneracy is not a defect; it is the engine of §6.)
- A **node** where edges with total timelike $P$ meet carries a composite state with nontrivial modular Hamiltonian $K_v$. The node's rest frame $u = P/\sqrt{P^2}$ is the frame in which the modular flow is stationary, and the v1 formula
$$
E_i = -\,p_i\cdot u
$$
is reinterpreted: **edge energy is the modular frequency of the edge's phase with respect to the node's own flow.** Energy is not a property of an edge; it is the response of an edge to a clock, and clocks are states.

Two consistency checks come along automatically. (i) The de Broglie/zitterbewegung clock: an onsite fiber evolving as $e^{-iE_{\rm onsite}t}$ with frequency $m$ is exactly a modular phase in the rest frame — the checkerboard turn amplitude and the internal-clock picture are the same coin (§3 completes this). (ii) Unruh thermality: a node history with a high density of turns (acceleration) samples the null ensemble anisotropically and its modular state is KMS at the corresponding temperature — thermality of acceleration is built in rather than derived post hoc.

**Honesty clause.** Modular flows of generic states are not geometric; they can act wildly non-locally (this is the generic situation in type III algebras and even in finite dimensions for non-thermal states). The thermal time hypothesis is a *postulate* that for the physically selected node states the flow is geometric. This is Failure Mode F-M1 (§12) and Gate I2 exists to control it in finite dimensions:

**Gate I2 (finite-dimensional modular clocks).**
1. Explicit finite-dimensional Tomita theory: for faithful $\rho$ on $M_n$, $\Delta = \rho\otimes\bar\rho^{-1}$, $J_m$ = swap-conjugation; fully constructive, Lean-tractable.
2. Toy theorem: for Gaussian node states built from the local null frame, the modular Hamiltonian is the boost generator about $u$, and $E_i = -p_i\cdot u$ is its spectrum on edge modes.
3. Separation theorem: the modular conjugation $J_m$ here is *not* the Krein fundamental symmetry and *not* the real structure (§8 disentangles the three $J$'s).

---

## 3. Mass is entanglement

### 3.1 The hidden envelope is a purification

v1 §VI proposed that visible mass is hidden null motion: a particle null in an extended space $(\Delta t, \Delta\mathbf x, \Delta\mathbf y)$ appears timelike in the visible $3{+}1$ projection, with $m^2 = |\mathbf p_{\rm int}|^2$. In v2 this is recognized as a standard information-theoretic operation: **purification.**

- The global object is pure (rank-one, null) in the extended space.
- The visible momentum is its *marginal* — a compression to the visible Clifford block — and marginals of pure states are mixed exactly when there is entanglement across the cut.
- Therefore:

$$
\boxed{\;\text{Mass is the entanglement between a particle's visible and internal degrees of freedom.}\;}
$$

The quantitative anchor is the two-qubit fact: for a pure global state with coefficient matrix $c$, the visible marginal is $\rho = cc^\dagger$, the concurrence is $C = 2|\det c|$, and $\det\rho = (C/2)^2$. The momentum version replaces the normalized $\rho$ with the unnormalized $P$:

- $\det P = m^2$ — **frame-invariant**, the right invariant;
- $\det\rho_{\rm vis} = (m/E)^2$ — **frame-dependent**, because normalization divides by the observer's energy.

This is precisely the observer-channel fix identified in the earlier peer-review round (unnormalized determinant à la Fullwood–Vedral–Guzmán-González): mass-invariance statements must be made at the level of $P$, not $\rho$. The v1 hidden-envelope story survives, but as a *purification statement*, not a Kaluza–Klein commitment: the "hidden dimensions" need never be geometric. They are whatever fiber purifies the visible momentum — which is exactly the onsite fiber space of v1 §II. **Sections II and VI of v1 were the same mechanism in two languages, and both reduce to §1's identity.**

### 3.2 The on-shell bridge: $\det P = \Phi^\dagger\Phi$

The third v1 mass story — Higgs/Yukawa in $E_{\rm onsite}$ — is unified by a constraint rather than an identification. The first-order theorem from the earlier Dirac-operator session,

$$
(\gamma\cdot P)^2 \;=\; \det(P)\,\mathbb 1
$$

(immediate from $P\,\bar P = \det(P)\mathbb 1$ for the $2\times2$ chiral blocks), turns the massive Dirac equation with Yukawa coupling $Y(\Phi)$ into the on-shell condition

$$
\boxed{\;\det P \;=\; \Phi^\dagger\Phi\;}
$$

and this is **non-tautological**: the left side is fixed by graph kinematics (the concurrence of the null split, §1), the right side by internal fiber dynamics (the Higgs condensate). The physical mass shell is the locus where the two independently defined quantities agree. One mechanism, one consistency condition, three former stories:

$$
\underbrace{\text{turn phases}}_{\text{v1 §X}} \;=\; \underbrace{\text{hidden null motion}}_{\text{v1 §VI}} \;=\; \underbrace{\text{fiber frequency}}_{\text{v1 §II}} \quad\text{glued by}\quad \det P = \Phi^\dagger\Phi .
$$

**Gate I1 (extension).** Item 5: purification/marginal theorem with the frame-dependence of $\det\rho$ vs invariance of $\det P$ made exact. Item 6: $(\gamma\cdot P)^2 = \det(P)\mathbb 1$ and the on-shell bridge. All finite-dimensional.

---

## 4. Geometry is a sufficient statistic

### 4.1 Order, number, and the covariance reading

The continuum theorems (Hawking–King–McCarthy; Malament) say: causal structure determines the conformal metric; a volume datum fixes the scale. The causal-set slogan compresses this to *order + number = geometry*. v2 restates both halves informationally:

- **Conformal class = the channel structure of the graph**: which node algebras can signal to which. This is order.
- **Conformal factor = the counting measure**: node density is the local entropy density available to coarse-grained states. This is number.

The v1 reconstruction $g^{\mu\nu} \sim \sum_{A,B} C^{AB} n_A^\mu n_B^\nu$ now reads as it should have all along: **the metric is the second moment — the covariance matrix — of the local null-direction ensemble.** Geometry is not stored anywhere on the graph. It is *inferred*: the unique quadratic form a coarse observer must fit to the transport statistics. In statistical language:

$$
\boxed{\;\text{The metric is the minimal sufficient statistic of null transport.}\;}
$$

Two observers agreeing on all transport correlations must agree on $g$; nothing beyond the second moments of the null ensemble is needed to do local physics. Curvature is the failure of the sufficient statistic to be globally consistent — the position-dependence of the fitted covariance.

### 4.2 The crystal is a scaffold; the ontology is an ensemble

A regular tetrahedral lattice has a preferred frame and would generically leak Lorentz violation into the continuum. Causal set theory solved this problem exactly once and the solution should be stolen without apology: **Poisson-type sprinkling is Lorentz-invariant in distribution** (Bombelli–Henson–Sorkin — the discreteness/symmetry theorem). Therefore:

- **Ontology (v2):** a probability measure over locally finite directed null-edge multigraphs, Lorentz-covariant *in distribution*, with edge spinors and node fibers as decorations.
- **Scaffold:** the tetrahedral crystal — the exactly solvable member of the ensemble on which Gate C1 lives, playing the role flat space plays for perturbation theory.

Lorentz invariance is then a *statistical* symmetry, exact at the level of the ensemble, broken in any sample, restored in correlation functions — the same status rotational invariance has in a gas.

**Honesty clause.** Poissonized causal structures famously have the *nonlocality problem*: discrete neighborhoods are noncompact, and naive local operators fail. The known mitigation (Benincasa–Dowker–type nonlocal d'Alembertians with local continuum limits) must be imported and adapted to edge-spinor transport. This is Failure Mode F-G2 and a genuine open front, not a footnote.

---

## 5. Chirality is logical information

This section reframes the entire Gate C1/C2 architecture without changing a single theorem in it.

### 5.1 Nielsen–Ninomiya as a no-hiding theorem

The doubling theorem says: no ultralocal lattice operator carries an exact, undeformed chiral symmetry with the right anomaly. The earlier Gate C1 analysis sharpened this for the null-edge setting: *a strictly finite ultralocal chiral release is provably impossible.* In information language this is a statement about where chirality can live:

> **Chirality is not a property any local patch of the graph can hold. It is a logical qubit** — a code-space degree of freedom of the long-wavelength sector, with no ultralocal physical representative.

The Ginsparg–Wilson relation is then read as the defining condition of an **error-correcting code**: the deformed involution $\widehat\gamma_5 = -\,\mathrm{sign}(H)$ and the projectors $\widehat P_\pm$ define the code subspace on which chiral symmetry acts *exactly*, while acting on the physical lattice only approximately. This is structurally the Almheiri–Dong–Harlow mechanism (bulk symmetries as logical operators in holographic codes), appearing here in lattice field theory:

| Code theory | Overlap fermions |
|---|---|
| physical qubits | lattice/graph spinor modes |
| code subspace | GW-projected chiral sector |
| logical operator | $\widehat\gamma_5$, Weyl projectors |
| no transversal implementation | Nielsen–Ninomiya obstruction |
| code distance | spectral gap of $H_{\rm ne}$ |
| finite correlation length of encoding | Hernández–Jansen–Lüscher exponential locality |

The last two rows convert v1's Failure Modes 1 and 8 into a single quantitative statement: **the gap is the code distance, and locality is the finite correlation length of the encoding.** "Nonlocality becomes uncontrolled" now means "the code distance collapsed" — one number to monitor, the same number C1 is already proving positive.

### 5.2 The overlap operator is a compressed bulk

Anomaly inflow says a 4d chiral fermion is the edge mode of a 5d gapped topological bulk; domain-wall fermions implement this literally, and $\mathrm{sign}(H)$ is the fifth dimension integrated out. So the v2 reading of the release chain is holographic in the precise, boring sense:

$$
\text{null-edge seed} \to H_{\rm ne} \to \underbrace{\mathrm{sign}(H_{\rm ne})}_{\text{compressed 5d bulk}} \to \text{Weyl edge modes.}
$$

A chiral fermion is *boundary information of a bulk phase*, and the non-ultralocality of $D_{\rm ov}$ is not a blemish — it is the irreducible encoding overhead of storing a logical symmetry, with decay length set by the bulk gap.

### 5.3 Anomalies are protected information; SMG is erasure

The 't Hooft anomaly of a symmetry acting on the mirror sector is, in this language, **logical information that no symmetric local channel can erase.** Hence the two release routes:

- **Overlap/GW route (certified):** keep the mirror off the physical branch spectrally. This is Gates C1–C2, unchanged, still the active proof spine.
- **Symmetric mass generation route (native, conjectural):** *erase* the mirror by interactions. The theorem-shaped statement from the SMG literature (Eichten–Preskill lineage; Wang–You; with Kikukawa's cautions) is that a mirror sector can be symmetrically gapped **iff all its anomalies vanish** — iff it stores no protected information. The Standard Model's anomaly miracle then acquires its v2 meaning:

> The per-generation 16 of $\mathrm{Spin}(10)$ is exactly an anomaly-free — hence *erasable* — mirror multiplet. Anomaly cancellation is the condition that the unwanted half of the null-edge spectrum carries no logical content and can be measured out.

This also finally gives the $\mathrm{Spin}(10)$/division-algebra interests a load-bearing role that does not touch spacetime: the internal fiber must furnish an anomaly-free multiplet, and 16 of $\mathrm{Spin}(10)$ is the canonical solution. The equivalence (or inequivalence) of the two routes on a null-edge graph is pre-registered as an open problem, not assumed.

---

## 6. Gravity is the data-processing inequality

This is the promotion. The derivation chain below is the only known route to Einstein's equations in which *every* intermediate object lives on null structure — which the graph supplies as primitive.

### 6.1 The monotone chain

Along a single null strand, the future subalgebras $\mathcal A_s$ (everything to the future of cut $s$) are nested: $\mathcal A_{s'} \subset \mathcal A_s$ for $s' > s$. In the continuum this nesting is a **half-sided modular inclusion** (Borchers, Wiesbrock), and moving the cut forward is a coarse-graining. The data-processing inequality — monotonicity of relative entropy under restriction —

$$
S\big(\rho\,\|\,\sigma\big)\big|_{\mathcal A_{s'}} \;\le\; S\big(\rho\,\|\,\sigma\big)\big|_{\mathcal A_{s}}, \qquad s' > s,
$$

is then not an axiom about gravity at all. It is an axiom about information. But it has been shown to *output* gravity's positivity structure:

$$
\text{DPI / monotonicity}
\;\xrightarrow{\text{Faulkner–Leigh–Parrikar–Wang}}\;
\text{ANEC}
\;\xrightarrow{\text{Ceyhan–Faulkner}}\;
\text{QNEC: } 2\pi\langle T_{kk}\rangle \ge S''_{\rm out}
\;\xrightarrow{\text{Raychaudhuri}}\;
\text{focusing.}
$$

Null geodesic focusing — the microscopic mechanism of gravitational attraction — descends from the statement that pushing a cut along a null strand can only lose information. Hence the v2 slogan:

$$
\boxed{\;\text{Gravity is the data-processing inequality of null transport.}\;}
$$

And it joins §1 and §3 under a single roof that the earlier relative-entropy session anticipated: **mass is a correlation (concurrence); gravity is the monotone decay of correlations.** Both are faces of relative entropy on the null-edge network. A theory whose primitive transport is null is the theory in which this chain is *native* rather than emergent: half-sided inclusions are literally the nesting of strand algebras, and QNEC is the fundamental local energy condition, holding cut-by-cut on every strand.

### 6.2 The equation of state

The second half of the derivation is Jacobson's, in its modern entanglement-equilibrium form: for every small causal diamond, demand the **first law of entanglement**

$$
\delta S \;=\; \delta\langle K\rangle
$$

at fixed volume, with $K$ the diamond's (boost) modular Hamiltonian. Stationarity of vacuum entanglement in *all* diamonds at *all* points forces

$$
G_{\mu\nu} + \Lambda g_{\mu\nu} \;=\; 8\pi G\, T_{\mu\nu},
$$

with $\Lambda$ entering only as an undetermined integration constant (this is the hand-off to §7). Einstein's equation is not a law about a field called $g_{\mu\nu}$; it is the **equation of state** of null-edge entanglement — the thermodynamic identity a coarse observer must write down if the microstates are null-edge histories and the sufficient statistic of §4 is to be self-consistent under the first law.

On the graph, the natural carrier of this first law already exists in the program: the **diamond bookkeeping cochain** — the discrete assignment of entropy/modular data to causal diamonds of the order. The discrete first law is the statement that this cochain is (co)exact up to sources; its failure to be exact is curvature; its *harmonic* part is §7.

**Honesty clause.** Two registered risks. (F-M2) The continuum chain uses type III modular theory; finite graphs are type I, and the continuum limit of modular data is a real analytic gap, not a formality. (F-G3) Entanglement equilibrium presumes semiclassical diamonds; the derivation must eventually *produce* the diamond structure from the graph measure rather than assume it, or it is circular at the quantum-gravity level. Both are pre-registered in §12.

---

## 7. The cosmological constant is topology plus shot noise

Two independent mechanisms, both already latent in the program, jointly fix Λ's status.

**Topology (the harmonic part).** The P9 analysis decomposed the diamond bookkeeping cochain by discrete Hodge–Helmholtz:

$$
\beta \;=\; d\alpha \;+\; \delta\gamma \;+\; h, \qquad h \in \mathcal H^k \cong H^k(\text{complex}).
$$

The exact part is locally sourced; the coexact part is pure bookkeeping gauge; only the **harmonic component** is globally rigid — undetermined by any local first-law data, exactly matching Λ's role as the integration constant of §6.2. Consequence: on any finite complex, the Λ-moduli space is finite-dimensional with dimension a Betti number. Λ-risk is *topological and auditable*, complex by complex. (Gate Λ1 below; the Hodge decomposition on a finite complex is linear algebra and Lean-tractable.)

**Shot noise (the fluctuating part).** In unimodular language Λ is conjugate to spacetime volume, and on the graph volume *is* node count: $V \leftrightarrow N$. The conjugacy relation $\Delta\Lambda\cdot\Delta V \sim 1$ plus Poisson counting statistics $\Delta N \sim \sqrt N$ gives the Sorkin everpresent-Λ scaling

$$
\Lambda \;\sim\; \pm\frac{1}{\sqrt V} \;\sim\; 10^{-122}\ \text{(today, Planck units)},
$$

the one order-of-magnitude prediction in this subject made *before* the observation. In v2 language: **Λ is the chemical potential of node counting, and its observed value is the shot noise of the causal measure.** The harmonic part says *where* Λ lives (cohomology); the counting part says *how big* it is (Poisson noise). Neither mechanism requires new structure — both are forced by ingredients already present (bookkeeping cochain; counting measure of §4).

**Gate Λ1.**
1. Discrete Hodge decomposition of the bookkeeping cochain on finite diamond complexes (finite linear algebra; Lean-tractable).
2. Identification theorem: the harmonic component is the unique locally-unsourced summand; dimension = Betti number of the complex.
3. Fluctuation scaling $\Delta\Lambda \sim N^{-1/2}$ under the Poisson ensemble of §4.2 (paper-level probability, not a Lean target yet).

---

## 8. The operator spine: Krein, Hilbert, and the three J's

The v1 architecture ran on one operator; v2 keeps that but resolves the two convention collisions the super-Dirac session flagged, because they are load-bearing.

### 8.1 γ₅-Hermiticity *is* Krein self-adjointness

The Lorentzian/causal data of the theory live naturally in a **Krein space**: an indefinite pairing $\langle\cdot,\cdot\rangle_K = (\cdot, J_K\,\cdot)$ obtained from a Hilbert inner product and a fundamental symmetry $J_K$ ($J_K^2 = 1$, $J_K^\dagger = J_K$). Spectral calculus — gaps, $\mathrm{sign}(\cdot)$, functional calculus — requires the Hilbert space. The bridge is not an extra assumption; it is already sitting inside the standard lattice condition. γ₅-Hermiticity,

$$
D^\dagger = \gamma_5 D \gamma_5 ,
$$

is *precisely* Krein self-adjointness of $D$ with respect to the fundamental symmetry $J_K = \gamma_5$. And then

$$
H = \gamma_5\,(D - \rho/a) = J_K\,(D - \rho/a)
$$

is the **canonical Krein→Hilbert transfer**: $H^\dagger = H$ on the Hilbert space follows immediately from Krein self-adjointness of $D$. The overlap release is then the polar phase of the transferred operator:

$$
\mathrm{sign}(H) = H\,(H^2)^{-1/2} \quad = \quad \text{unitary part of the polar decomposition of } H .
$$

So the v1 pipeline seed → Hermitian sign kernel → overlap is, structurally:

$$
\boxed{\;\text{causal (Krein) operator} \;\xrightarrow{\;J_K\;}\; \text{Hilbert operator} \;\xrightarrow{\;\text{polar}\;}\; \text{chiral release.}\;}
$$

This retro-dignifies the construction: the γ₅ prefactor in $H_{\rm ne}$ was never a trick; it is the fundamental symmetry of the causal pairing, and Failure Mode 4 of v1 ("Krein/Hilbert confusion") becomes a *theorem obligation*: every physical statement must be checked for $J_K$-covariance.

### 8.2 Disentangling the three J's

Three antilinear/involutive objects were being conflated. They are now distinct axioms:

| Symbol | Object | Role | Depends on |
|---|---|---|---|
| $J_K$ | fundamental symmetry ($=\gamma_5$ in the lattice realization) | Krein↔Hilbert transfer; γ₅-Hermiticity | kinematics only |
| $J_r$ | real structure (charge conjugation) | KO-dimension of the spectral triple; particle/antiparticle | kinematics only |
| $J_m$ | Tomita modular conjugation | thermal time, node clocks (§2) | **the state** |

The first two are fixed by the operator package; the third is state-dependent and *must never* appear in kinematic theorems. Likewise the two ℤ₂ gradings — cochain form degree and chirality — are declared independent, with an isomorphism available only on the flat tetrahedral scaffold and forbidden as a general identification.

### 8.3 The spectral triple and the spectral action

The whole kinematic package is a (causal, Krein, gauge-network) spectral triple in the Marcolli–van Suijlekom sense with the program's three modifiers:

$$
(\mathcal A,\ \mathcal H_K,\ D_{\rm ne},\ J_K,\ J_r,\ \gamma)
$$

with $\mathcal A$ the node-function ⊗ holonomy algebra, $\mathcal H_K$ the Krein space of node spinors, $D_{\rm ne}$ the null-edge Dirac. This makes v1 §XIII's speculation structural: the **spectral action**

$$
S_{\rm spec} = \mathrm{Tr}\, f\!\big(H_{\rm ne}^2/\Lambda_c^2\big)
\;\sim\; f_4\Lambda_c^4\!\int\!\sqrt g \;+\; f_2\Lambda_c^2\!\int\!\sqrt g\,R \;+\; f_0\!\int\!\big(\mathcal L_{\rm YM} + \mathcal L_{\rm Higgs} + \cdots\big)
$$

generates Einstein–Hilbert, Yang–Mills, and Higgs sectors as heat-kernel coefficients of *the same operator that releases the fermions* (Chamseddine–Connes). v1's aphorism "geometry is what the Dirac operator knows how to transport" acquires an engine, and the information reading is clean: the spectral action is the entropy-like counting of null-edge modes below scale $\Lambda_c$ — geometry, gauge, and Higgs are what mode-counting *forces* an effective observer to write down. Crucially this is a *consistency* structure, not an independent derivation of gravity: §6 derives the Einstein equation as an equation of state; §8.3 confirms that the operator spine's mode counting produces the matching action. If they disagreed, the theory would be dead — that agreement is a gate, not a decoration (Gate G1′.4).

---

## 9. Three limits, one fixed point

The emergence hierarchy of v1 §IX survives, restated as renormalization:

1. **Frozen scaffold** (tetrahedral crystal, fixed): null-edge overlap lattice QFT. Domain of Gates C1–C3. Plays the role of exactly solvable flat space.
2. **Frozen ensemble, slow modulation**: transport statistics vary slowly; the sufficient statistic of §4 becomes a curved tetrad + spin connection; QFT in curved spacetime, valid while the code distance (gap) stays open.
3. **Dynamical ensemble**: the measure over graphs is itself summed. Gravity is the hydrodynamics of the sufficient statistic; the Einstein equation of §6 is its equilibrium condition; §7 fixes the zero mode.

The continuum limit is an information-theoretic **fixed point**: a graph ensemble whose coarse-grained transport statistics are scale-invariant with the correct universality class. Exponential locality (code correlation length), statistical Lorentz invariance (§4.2), and the entanglement first law (§6.2) are the three properties that must be *preserved by the flow* — they are the definition of "the right fixed point," replacing v1's vaguer "continuum accountability."

---

## 10. Axioms, second formulation

**A1 — Ontology.** A probability measure over locally finite, directed, acyclic null-edge multigraphs. Each edge carries a rank-one spinor datum $\lambda_e$ (nullity = purity); each node carries a finite-dimensional fiber Hilbert space.

**A2 — Dynamics.** Isometric/unitary transport along edges plus onsite fiber unitaries. No primitive timelike transport; all rest is internal evolution.

**A3 — Statistical relativity.** The graph measure is Lorentz-covariant in distribution (Poisson-type). The crystal is a scaffold, not the ontology.

**A4 — Modular time.** Clocks are modular flows of composite node states. Proper time increments are concurrence brackets $|\langle\lambda_i\lambda_j\rangle|$; energy is modular frequency.

**A5 — Mass as entanglement.** $m^2 = \det P = \sum_{i<j}|\langle ij\rangle|^2$; visible mass is visible–hidden entanglement of a purifying null state; the on-shell bridge $\det P = \Phi^\dagger\Phi$ ties fiber dynamics to graph kinematics.

**A6 — Geometry as sufficient statistic.** Conformal class from causal order; scale from counting; the metric is the covariance of the local null ensemble and carries no independent ontology.

**A7 — Chirality as logical information.** Chiral fermions are code-space (edge-mode) degrees of freedom; release via GW code structure with gap = code distance; alternatively via symmetric mass generation when and only when the mirror sector is anomaly-free (stores no protected information).

**A8 — Gauge.** Holonomies on edges; curvature on loops; anomaly freedom of the physical multiplet = erasability of the mirror. The internal fiber must furnish an anomaly-free multiplet (canonically 16 of Spin(10)); division-algebra structures enter only through associative operator realizations.

**A9 — Gravity as monotone.** DPI on nested strand algebras ⟹ QNEC ⟹ focusing; entanglement equilibrium on diamonds ⟹ Einstein equation as equation of state.

**A10 — Λ.** Λ is the harmonic (cohomological) component of the diamond bookkeeping cochain and the conjugate of node counting; its magnitude is Poisson shot noise $\sim N^{-1/2}$.

**A11 — Two-space discipline.** Causal data live in the Krein space; spectral calculus in the Hilbert space; $J_K$, $J_r$, $J_m$ and the two ℤ₂ gradings are never conflated.

**A12 — Accountability.** The theory must reduce to Standard Model QFT and classical GR in tested regimes, and every axiom must be shadowed by a gate: a formalizable theorem whose failure kills the corresponding claim.

---

## 11. Discarded, demoted, unified

**Discarded.**
Raw nonassociative octonion "operators" inside spectral calculus (retained only via associative realizations: left/right multiplication algebras, Clifford embeddings, controlled Jordan structure). Primitive timelike edges. Doubler removal by propagator zeros. E8 as active spacetime structure. "Energy as proper-time frequency along an edge."

**Demoted.**
The tetrahedral crystal: from ontology to scaffold (§4.2). The geometric reading of hidden dimensions: from Kaluza–Klein commitment to purification statement (§3.1) — the extra directions need never be geometric.

**Unified.**
Three mass mechanisms into one identity plus one constraint (§1, §3.2). Two geometric stories into one sufficient-statistic principle (§4.1). Mass-as-concurrence and QNEC-positivity into one relative-entropy structure (§6.1). The γ₅ prefactor and the Krein pairing into one transfer principle (§8.1). v1 §II and §VI into one fiber mechanism (§3.1).

**Newly load-bearing.**
The amplitudes program as external evidence (§1.4). The code-theoretic reading of GW (§5.1). Entanglement equilibrium as *the* gravity derivation (§6.2). The Hodge/harmonic localization of Λ joined to everpresent-Λ counting (§7). Spin(10)'s 16 as the erasability certificate (§5.3).

---

## 12. Failure modes, updated

The v1 list (F1–F10) stands. The information framing adds registered risks of its own — an honest framing must pay its own tax:

**F-M1 (nongeometric modular flow).** Thermal time is a postulate; generic modular flows are not geometric. If the physically selected node states do not have geometric modular flow, §2 degrades from mechanism to metaphor. Mitigation: Gate I2 toy theorems; restrict claims to Gaussian/vacuum-like states until proven otherwise.

**F-M2 (type mismatch).** The DPI→QNEC chain is proved in continuum type III modular theory; finite graphs are type I. The continuum limit of modular data is an analytic gap, not a formality. This is the modular analogue of the continuum-limit problem and may be *the* hard analytic problem of the program.

**F-G2 (sprinkling nonlocality).** Poisson-type ensembles have noncompact discrete neighborhoods; edge-spinor transport must be shown to admit local continuum limits (Benincasa–Dowker-style constructions adapted to spinors). If not, statistical Lorentz invariance was bought at the price of locality.

**F-G3 (equilibrium circularity).** Entanglement equilibrium assumes semiclassical diamonds. At the quantum-gravity level the diamond structure must be *derived* from the graph measure. Until then, §6.2 is a consistency condition on the semiclassical phase, not a derivation of it.

**F-I1 (identity overreach).** The Cauchy–Binet identity is exact for 2-spinor soldering in flat kinematics. The curved/4-component/interacting extensions may not preserve the Plücker structure. Claims must not silently extrapolate the identity beyond its proven domain.

**F-S1 (SMG gap).** The SMG route is conjectural on null-edge graphs; the anomaly-free⟺gappable equivalence has lattice caveats (Kikukawa). Overlap remains the certified route; SMG is a research direction, not a fallback that can be assumed.

**F-L1 (Lorentzian measure).** The dynamical-ensemble sum is a Lorentzian path integral over graphs; sign/oscillation problems are unsolved here as everywhere. No claim in §9.3 is currently better than schematic.

---

## 13. The theorem ladder, updated

**Gate C1 — unchanged, still the spine.** Finish `TetraFreeOperatorGap_equalN`: phase-to-trig adapters → full Fourier diagonalization of $H_{\rm free}$ → unitary block-diagonal gap instantiation → finite/free operator gap → self-adjointness → only then the sign/GW/release layer. Nothing in v2 touches this. Do not let the new framing pull effort off C1.

**Gate I1 — mass/concurrence (new; finite linear algebra; Lean-ready).** Soldering determinant; PSD rank-one factorization; Cauchy–Binet mass identity ≡ cross-term expansion; little-group stabilizer theorem; purification/marginal theorem with $\det P$ vs $\det\rho$ frame analysis; $(\gamma\cdot P)^2 = \det(P)\mathbb 1$ and the on-shell bridge. Estimated cost: low. Estimated value: the theory's central identity, certified.

**Gate I2 — modular clocks (new; finite-dimensional).** Constructive finite Tomita theory; boost-modular toy theorem for Gaussian node states; the three-J separation theorem. Controls F-M1.

**Gate Λ1 — cosmological constant (new; mostly finite linear algebra).** Discrete Hodge decomposition of the bookkeeping cochain; harmonic-identification and Betti-dimension theorem; Poisson fluctuation scaling (paper-level).

**Gate C2 — gauge backgrounds.** As v1, with one addition: (7) $J_K$-covariance audit of every statement (§8.1) and the two-grading discipline (§8.2).

**Gate C3 — path sums.** As v1 (rational/Chebyshev/domain-wall expansions; node-time phases; retarded/Hilbert dilation; Krein/positivity audit), plus: (6) the on-shell-diagram correspondence of §1.4 made precise on the scaffold — node coins vs. three-point amplitude data.

**Gate G1′ — emergent geometry and gravity (restructured).**
1. Sufficient-statistic theorem: transport correlations on slowly varying backgrounds determine a unique tetrad + connection (discrete HKMM + counting).
2. Discrete first law: the bookkeeping cochain satisfies $\delta S = \delta\langle K\rangle$ + harmonic term on graph diamonds.
3. Equation-of-state theorem (paper-level): first law in all diamonds ⟹ discrete Einstein equations in the continuum limit.
4. Spectral-action consistency: heat-kernel coefficients of $H_{\rm ne}$ reproduce the §6 equation of state (the §8.3 gate).

**Gate G2 — dynamical ensemble.** As v1, with the fixed-point reformulation of §9: preservation of gap, statistical Lorentz invariance, and the first law under coarse-graining defines the target universality class. Registered against F-L1.

**Formalization note.** Gates I1, I2.1, and Λ1.1–1.2 are finite-dimensional linear algebra — the same species as the C1 stack — and are the natural "slack-time" Lean targets: high conceptual leverage, low proof risk, zero interference with the C1 critical path.

---

## 14. The claim in one sentence

$$
\boxed{
\begin{array}{c}
\textbf{Spacetime is the sufficient statistic of null information flow;}\\[2pt]
\textbf{matter is its logical content; mass is its entanglement; time is its modular flow;}\\[2pt]
\textbf{gravity is its data-processing inequality; and the cosmological constant}\\[2pt]
\textbf{is its topology plus its shot noise.}
\end{array}
}
$$

Everything conservative in v1 is kept where it was proven machinery (overlap/GW, Gate C1, the two-space discipline). Everything radical is now a *named information principle* shadowed by a gate. The first hard victory has not moved: $H_{\rm tet}$ gapped, self-adjoint, released. But the second victory is now visible and cheap: Gate I1, the Cauchy–Binet spine, which turns the treatise's opening computation into the theory's certified center.

---

## Appendix: principal external anchors

Feynman checkerboard & Dirac quantum walks (lightlike paths + local turn amplitudes). Ginsparg–Wilson / Neuberger overlap / Hernández–Jansen–Lüscher locality (chiral release machinery). Nielsen–Ninomiya (obstruction). Almheiri–Dong–Harlow (symmetries as logical operators of codes). Eichten–Preskill; Wang–You; Kikukawa (symmetric mass generation and its caveats). Arkani-Hamed–Huang–Huang (massive spinor-helicity; little group as pair gauge). On-shell diagrams / positive Grassmannian program (null decomposition of interacting QFT). Hawking–King–McCarthy; Malament (causal structure ⟹ conformal metric). Bombelli–Henson–Sorkin (Lorentz invariance of sprinklings); Benincasa–Dowker (nonlocal d'Alembertians); Surya (causal set review). Connes–Rovelli (thermal time); Tomita–Takesaki; Borchers–Wiesbrock (half-sided modular inclusions). Faulkner–Leigh–Parrikar–Wang (ANEC from monotonicity); Ceyhan–Faulkner (QNEC from relative entropy). Jacobson 1995 & 2015 (equation of state; entanglement equilibrium). Sorkin (everpresent Λ; order + number = geometry). Chamseddine–Connes (spectral action); Marcolli–van Suijlekom (gauge-network spectral triples). Fullwood–Vedral–Guzmán-González (unnormalized-determinant mass invariance, per the earlier peer-review session). Furey et al. (division-algebra particle structure — internal fiber only, associative realizations only).
