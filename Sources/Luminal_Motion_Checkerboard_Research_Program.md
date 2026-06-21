# All Motion Is Luminal: Checkerboard Path Integrals for Massive Fermions

**Status:** research program draft, v1 (2026-06-11).
**Provenance:** consolidated from two AI-assisted research conversations
(largely redundant duplicates) developing the thesis "all motion is luminal;
mass is the bookkeeping of how often luminal motion turns around." All
literature claims below are from those conversations and assistant knowledge;
each work package includes a source-verification step before anything is
treated as established.
**Relation to PhysicsSM:** Parts III and VI connect to the division-algebra
spinor program (`PhysicsSM/Spinor/`, Spin(10) pure spinors, octonionic
spinor-helicity). Part V identifies kernel-checkable Lean targets.

---

## 1. Thesis

**Slogan.** Every fundamental fermion always moves at exactly $c$. Mass is
not a resistance to motion; it is the rate at which luminal motion reverses
(1+1D) or scatters on the celestial sphere (3+1D). Subluminal velocity is a
time average of light-speed zigzag.

**Precise form.** The massive Dirac propagator in even spacetime dimension
admits an exact expansion as a sum over piecewise-null polygonal paths, with
a factor $im$ per corner and a spin-transport (Berry/Pancharatnam) factor
along the path. The 1+1D case is Feynman's checkerboard, where the spin
factor trivializes and the sum is pure combinatorics. The research program
is: (a) state and prove the higher-dimensional expansion cleanly, (b) carry
it to Lorentz-invariant discrete settings (causal sets), (c) exploit the
division-algebra structure that singles out dimensions 2, 4, 6, 10, and
(d) formalize the discrete/algebraic layers in Lean.

**Scope caveat, stated up front.** The thesis is a theorem about the analytic
structure of propagators, an exact statement about QCD's contribution to
hadron masses, and an *interpretation* beyond that. Zitterbewegung is
representation-dependent (it vanishes for Foldy-Wouthuysen position and for
strictly positive-energy packets). What is representation-independent is the
propagator-level statement, and that is what we formalize. Fundamental
scalars (the physical Higgs boson) are outside the scope: a scalar has no
chirality to flip, and the dominant worldline paths for a massive scalar
propagator are not null. The honest scope is "every SM particle except the
Higgs," plus composite mass via confinement.

---

## 2. Part I: The continuum pillars (with proof sketches)

### 2.1 The velocity operator is luminal

For the Dirac Hamiltonian $H = c\,\alpha \cdot p + \beta mc^2$, the
Heisenberg equation gives $\dot{x}^i = c\,\alpha^i$, and each $\alpha^i$
squares to the identity, so its spectrum is $\{\pm 1\}$: an instantaneous
velocity measurement yields $\pm c$ exactly.

*Sketch (Schroedinger 1930).* Solve the Heisenberg equations:
$\dot\alpha = (2i/\hbar)(cp - \alpha H)$, and since $H$ is conserved,
$\alpha(t) = c p H^{-1} + e^{2iHt/\hbar}(\alpha(0) - cpH^{-1})$. Integrating,
$x(t) = x(0) + c^2 p H^{-1} t + (\text{oscillation at frequency } 2H/\hbar)$.
The drift term is the classical velocity $c^2 p / E$; the oscillation
(Zitterbewegung) has frequency $\geq 2mc^2/\hbar \sim 10^{21}\,$Hz and
amplitude of order the reduced Compton wavelength. The subluminal group
velocity is literally the time average of luminal motion. *Caveat:* the
oscillation requires interference between positive- and negative-frequency
components and disappears for the Newton-Wigner position operator, so this
pillar is suggestive, not invariant.

### 2.2 Mass is the chirality-flip rate

In the Weyl basis the free Dirac equation splits as
$$i\,\bar\sigma^\mu \partial_\mu \psi_L = m\,\psi_R, \qquad
  i\,\sigma^\mu \partial_\mu \psi_R = m\,\psi_L .$$
Each chiral component, taken alone, is a *massless* field propagating at
$c$. The mass term is precisely the coupling converting $L$ into $R$ and
back, at rate $mc^2/\hbar$. This is Penrose's zigzag: a massive electron is
a left-handed "zig" perpetually converting into a right-handed "zag," each
segment lightlike, with amplitude proportional to $im$ per conversion.

The Standard Model upgrades the picture to a mechanism: above the
electroweak scale all fermions are exactly massless Weyl spinors; the Yukawa
coupling to the Higgs condensate is the flip vertex, so mass *is* the
coherent forward-scattering rate off the vacuum. The same mechanism gives
massive gauge bosons (massless propagation punctuated by condensate
scattering, structurally identical to a photon acquiring effective mass in a
plasma). This pillar, unlike 2.1, is frame- and representation-independent.

### 2.3 Composite mass is confined luminal motion

About 99% of the proton's mass is not Higgs-generated: it is the confined
kinetic and field energy of nearly-massless quarks and exactly-massless
gluons. A proton at rest is a box of luminal stuff whose momenta cancel;
its rest mass is the invariant mass of trapped light-speed motion. For
baryonic matter the slogan is not an interpretation, it is QCD.

---

## 3. Part II: The 1+1D checkerboard, exactly

### 3.1 The model and the theorem

On a spacetime lattice with spacing $\varepsilon$ (units $\hbar = c = 1$),
paths move one step right or left per time step. The amplitude of a path
with $R$ direction reversals is $(i\varepsilon m)^R$. Feynman's claim
(rigorous since Skopenkov-Ustinov, c. 2020-22): the lattice path sum
converges, as $\varepsilon \to 0$ with endpoints fixed, to the exact 1+1D
Dirac propagator.

### 3.2 Proof sketch (combinatorics to Bessel functions)

Fix endpoints with $p$ right-steps and $q$ left-steps ($p + q = t/\varepsilon$,
$p - q = x/\varepsilon$). A path is determined by where its reversals sit:
$R$ reversals partition the path into runs, and elementary counting gives
the number of paths with exactly $R$ reversals as a product of two binomial
coefficients, approximately $\binom{p-1}{r}\binom{q-1}{r}$ for $R = 2r$
(same-chirality endpoints; the odd case is analogous). The kernel component
is
$$K \;\sim\; \sum_{r} \binom{p-1}{r}\binom{q-1}{r}\,(i\varepsilon m)^{2r}.$$
In the continuum limit $\binom{p}{r}\varepsilon^r \to (t+x)^r / (2^r r!)$
and similarly for $q$, so each term tends to
$\big( im\sqrt{t^2 - x^2}/2 \big)^{2r} / (r!)^2$, and the sum is the Bessel
series: $K \to J_0(m\tau)$ with $\tau = \sqrt{t^2 - x^2}$ the proper time
between the endpoints. The four chirality components assemble $J_0$ and
$J_1$ factors into exactly the known retarded 1+1D Dirac kernel.

Two structural facts to keep for higher dimensions: (i) the corner weight is
a *scalar*, so the path sum collapses to counting; (ii) the expected number
of corners along a contributing path is proportional to $m\tau$, so "mass
counts corners per unit proper time" is exact, and the massless limit is a
single straight null line.

### 3.3 The telegraph-process identity

Kac's telegraph process: a classical particle moves at $\pm v$ and reverses
at Poisson rate $a$. The occupation densities $u_\pm$ satisfy
$\partial_t u_\pm \pm v\,\partial_x u_\pm = a(u_\mp - u_\pm)$, whose
second-order form is the telegrapher's equation. Formally replacing
$a \to im$ turns this system into the Dirac equation in light-cone
components. The checkerboard sum is the analytic continuation in the flip
rate of a genuine probabilistic expectation (Gaveau-Jacobson-Kac-Schulman
1984): **mass = imaginary Poisson flip rate**. This gives a second,
probabilistic proof route for 3.2 and a template for randomized lattices
(Part IV.4).

### 3.4 Why 1+1D is a coincidence

The checkerboard works because in two spacetime dimensions **the light cone
has exactly two rays, the Dirac spinor has exactly two components, and they
are the same two**: chirality *is* direction of motion. In $d+1 \geq 2+1$
both halves fail: null directions form a continuous sphere $S^{d-1}$, spin
is no longer slaved to direction (the little group of a null ray is
nontrivial), and any finite direction set breaks rotational invariance and
invites fermion doubling (Nielsen-Ninomiya). This is the real content of
"the checkerboard doesn't generalize" -- but it does, if the corner weights
become matrices.

---

## 4. Part III: The higher-dimensional structure theorem

### 4.1 The Neumann series in the mass

Write the massive propagator as a geometric series around the massless one.
In the Weyl basis $S_0 = \mathrm{diag}(S_L, S_R)$ is the pair of massless
chiral propagators and the mass term is off-diagonal, so
$$S_m \;=\; \sum_{k \geq 0} (im)^k\,
  \underbrace{S_0 * S_0 * \cdots * S_0}_{k+1 \text{ factors}},$$
with chirality alternating $L, R, L, \dots$ at each of the $k$ insertion
vertices. This identity is exact and dimension-independent; it is the
covariant skeleton of the checkerboard. For the *retarded* propagator the
series converges: the $k$-th term carries a causal-diamond volume factor
that decays factorially in $k$ at fixed proper time (the Bessel series of
3.2 is the 1+1D instance).

### 4.2 Strong Huygens selects the null-polygon picture

The massless retarded propagator is sharply supported on the light cone
precisely in even total spacetime dimension $\geq 4$ (and the 1+1D chiral
propagators are supported on single null rays); in odd dimensions there is a
tail inside the cone. Therefore in 3+1D **every term of the Neumann series
is an integral over piecewise-exactly-null polygonal paths**: $k$ corners
located anywhere on successive forward light cones, weight $(im)^k$, times a
matrix transport factor. In 2+1D the strict null-zigzag picture is
*impossible* -- the checkerboard is better behaved in 3+1 than in 2+1.

### 4.3 The spin factor is a Berry holonomy (proof sketch)

Along a null segment $\Delta x = r(1, \hat n)$ the numerator of the chiral
propagator is $\sigma_\mu \Delta x^\mu = r(\mathbb{1} + \sigma\cdot\hat n)
= 2r\,P_+(\hat n)$, a rank-one projector onto the spin-coherent state
$|\hat n\rangle$ (the alternating chirality supplies $\bar\sigma$ on
alternate segments, projecting onto $|-\hat n\rangle$ as appropriate). The
matrix transport along a polygon with directions $\hat n_1, \dots, \hat n_k$
is a product of rank-one projectors, and the standard coherent-state
identity gives
$$P(\hat n_k)\cdots P(\hat n_1)
  \;=\; \Big( \prod_{j} \langle \hat n_{j+1} | \hat n_j \rangle \Big)\,
        |\hat n_k\rangle\langle \hat n_1| .$$
The modulus of each overlap is $\cos(\theta_{j,j+1}/2)$ (a bending
suppression), and the phase of the cyclic product is $e^{-i\Omega/2}$ where
$\Omega$ is the solid angle enclosed by the geodesic polygon traced on the
direction sphere $S^2$ -- the discrete Pancharatnam/Berry phase of a
spin-1/2 dragged along the path's celestial-sphere trajectory. This is the
Polyakov spin factor in discrete form. So:

**Structure theorem (target form).** *3+1D Dirac retarded propagator =
(scalar zigzag combinatorics over null polygons, weight $(im)^k$) times
(spin-1/2 Berry holonomy of the direction history).* Mass and spin are the
abelian and non-abelian parts of the same corner data.

A consistency check: fixing the momentum direction and passing to the
helicity basis collapses the whole sum to a 1+1D checkerboard along that
axis.

### 4.4 Division algebras select dimensions 2, 4, 6, 10

The "spinor = null direction" correspondence is tightest exactly in the
division-algebra dimensions: $\mathrm{Spin}(d-1,1) \cong SL(2,\mathbb{K})$
for $\mathbb{K} = \mathbb{R}, \mathbb{C}, \mathbb{H}, \mathbb{O}$ in
spacetime dimensions $d = 3, 4, 6, 10$, and a null momentum is precisely a
rank-one Hermitian $2\times 2$ matrix over $\mathbb{K}$:
$p = \lambda\bar\lambda$ (spinor-helicity decomposition). Intersecting with
the strong-Huygens constraint (even $d$, plus the special 1+1D case) gives
**checkerboard-friendly dimensions 2, 4, 6, 10** -- exactly the classical
superstring dimensions. A 9+1D checkerboard with corners weighted by
octonionic spinor inner products is, to our knowledge, unexplored;
nonassociativity bites in the path-ordering of corner factors, which is
either fatal or interesting. This is where the program meets the
PhysicsSM spinor layer: pure spinors of $\mathrm{Spin}(10)$ parametrize
maximal null subspaces, and the repo's `SpinorTenfold*` modules are the
natural formal home for the rank-one/null correspondence.

---

## 5. Part IV: Discrete realizations (survey and gaps)

All claims here require source verification (WP0) before being relied on.

1. **Jacobson (1984-85), spinor chains.** A 3+1D path integral over
   speed-$c$ paths whose step direction is encoded in a two-component
   spinor; path amplitude = product of spinor overlaps
   $\langle\nu_{j+1}|\nu_j\rangle$ (discrete Berry phases, exactly the
   factors of 4.3) times Feynman's $(i\varepsilon m)^R$.
2. **Foster-Jacobson lattice models.** Massless fermions on a hypercubic
   spacetime lattice with null faces; in the 2016-17 version a right-handed
   step carries the spin projector onto the step direction and a left-handed
   step the orthogonal projector. Amplitude $i^{\pm T} 3^{-B/2} 2^{-N}$ for
   $N$ steps, $B$ bends, $T$ the signed bend count; no fermion doubling;
   Dirac mass enters as amplitude $i\varepsilon m$ to flip chirality per
   step. Structural rhyme: the hopping-parameter expansion of Wilson
   fermions weights lattice paths by $(1 \pm \gamma_\mu)/2$ per link --
   the same "spin aligns with motion" projector mechanism.
3. **Quantum walks / quantum cellular automata.** Trotterize
   $e^{-i\varepsilon H}$ into conditional shifts along axes (each at speed
   $c$ in the corresponding $\alpha_i$ eigenbasis) plus a mass rotation
   $e^{-i\varepsilon m \beta}$: the walker is instantaneously luminal,
   subluminal on average -- the thesis implemented as a unitary circuit
   (Meyer; Bialynicki-Birula 1994; Strauch; Arrighi et al. in 3+1D; Succi's
   quantum lattice Boltzmann "stream at $c$, collide via mass mixing").
   **D'Ariano-Perinotti** derive rather than guess: unitarity + locality +
   homogeneity + isotropy on a Cayley graph of $\mathbb{Z}^3$ force an
   essentially unique Weyl automaton on the BCC lattice, and the massive
   Dirac automaton couples the two chiral Weyl automata with off-diagonal
   amplitude $im$ -- mass *defined* as the flip amplitude between two
   luminal chiral walkers. Trapped-ion experiments (Gerritsma et al.,
   Nature 2010) directly simulated Dirac Zitterbewegung.
4. **Causal sets (Johnston).** On a Poisson sprinkling into Minkowski
   space, sum over chains $x = x_0 \prec x_1 \prec \cdots \prec x_k = y$
   with a fixed "hop" amplitude $a$ per link and "stop" amplitude $b$ per
   intermediate element; the matrix geometric series
   $K = aC(I - abC)^{-1}$-type sum, with $(a, b)$ fixed by matching the
   sprinkling-averaged kernel to the continuum retarded propagator, works
   in 1+1 and 3+1. This is a **Lorentz-invariant scalar checkerboard**
   (sprinklings have no preferred frame). The spin-1/2 version is
   substantially open: Johnston's thesis offers only suggestions for a
   causal-set Dirac propagator.
5. **Rigor benchmark.** Skopenkov-Ustinov ("Feynman checkers") made the
   1+1D model fully rigorous: pointwise asymptotics, probability of
   chirality, continuum limits. Their open-problem list explicitly includes
   the 2+1 and 3+1 generalizations. No higher-dimensional theory exists at
   that level of rigor. Ord's "entwined paths" and Riazanov (1958) are
   instructive failed/partial attempts.

---

## 6. Part V: The research program

### WP0: Source verification and provenance (first, cheap, mandatory)

Pull and check the primary sources before building on them: Schroedinger
1930; Feynman-Hibbs problem 2-6; Gaveau-Jacobson-Kac-Schulman PRL 1984;
Jacobson 1984/85; Foster-Jacobson (incl. 2016/17); Bialynicki-Birula 1994;
Meyer 1996; D'Ariano-Perinotti PRA 2014; Johnston PRL 2008 + thesis;
Skopenkov-Ustinov 2020-22; Penrose (Road to Reality zigzag); Hestenes ZBW;
Barut-Zanghi. Record each in `Sources/` with conventions (metric signature,
Weyl-basis layout, sign of $im$ corner weight). **Deliverable:** annotated
bibliography + convention table. Per AGENTS.md, conventions from different
sources are never silently merged.

### WP1: Rigorous 1+1D checkerboard, formalized in Lean

The finite-lattice statement is pure combinatorics -- ideal kernel-checked
territory, no analysis required:

- **WP1a (exact, finite).** Define the checkerboard path sum on
  $\mathbb{Z}^2$ and prove it satisfies the discrete Dirac recursion
  (one-step unitary update). This is an exact theorem about finite sums --
  Lean-formalizable now with `Finset` machinery.
- **WP1b (corner counting).** Prove the closed form: number of lattice
  paths with $R$ reversals = explicit binomial product; derive the
  discrete-Bessel form of the kernel as a polynomial identity in
  $(i\varepsilon m)$.
- **WP1c (telegraph bridge).** Formalize the algebraic identity between
  the checkerboard recursion and the telegraph-process master equation
  under $a \leftrightarrow im$ (a statement about $2\times 2$ systems, not
  about stochastic processes).
- **WP1d (long horizon).** Continuum limit to $J_0/J_1$; requires Bessel
  asymptotics from mathlib -- check availability first.

**Publishable unit:** "Feynman checkers, formally verified" -- to our
knowledge no proof assistant formalization of the checkerboard exists.
Modest but clean, and a natural Aristotle workload.

### WP2: The 3+1D null-polygon expansion, stated and proved in prose first

Make Section 4 a theorem with hypotheses:

- **WP2a.** Precise statement of the Neumann series for the retarded
  propagator as distributions; term-by-term well-definedness of the
  cone-supported convolutions; factorial convergence at fixed proper time.
- **WP2b.** The projector/holonomy factorization of 4.3 as a lemma chain:
  (i) $\sigma\cdot\Delta x = 2r P_+(\hat n)$ for null $\Delta x$;
  (ii) rank-one projector product = overlap product times outer product;
  (iii) phase of cyclic overlap product = half the enclosed solid angle.
- **WP2c.** The helicity-basis collapse to 1+1D as a consistency theorem.

**Publishable unit:** a careful expository-rigorous paper "The Dirac
propagator as a sum over null polygons: mass as corner counting, spin as
celestial holonomy." Much of this is folklore (Polyakov spin factor,
worldline formalism) but apparently not assembled in this form.

### WP3: Lean formalization of the spin-holonomy lemma chain

WP2b is finite-dimensional complex linear algebra -- formalizable
independently of any analysis:

- $2\times 2$ rank-one projectors $P(\hat n) = (1 + \sigma\cdot\hat n)/2$;
- the product-collapse identity;
- the discrete solid-angle phase (Pancharatnam) for spherical triangles,
  via explicit spin-coherent states.

This sits directly on the repo's Clifford/spinor layer
(`PhysicsSM/Clifford/`, `PhysicsSM/Spinor/`) and doubles as reusable Berry-
phase infrastructure. Natural namespace:
`PhysicsSM.Spinor.CoherentProjector` or similar.

### WP4 (flagship): fermionic hop-stop propagator on causal sets

**Problem.** Define a spin-1/2 hop-stop sum on Poisson sprinklings and
prove convergence-in-mean to the continuum Weyl/Dirac retarded propagator.

**Proposed construction.** Replace Johnston's scalar hop weight by the
*covariant* matrix weight $\sigma_\mu (y - x)^\mu$ per hop $x \to y$ (for
nearly-null links this is approximately $2r P_+(\hat n_{xy})$ -- the
Foster-Jacobson projector -- but the unnormalized covariant form avoids
choosing a frame), alternate chirality ($\sigma \leftrightarrow
\bar\sigma$) across stops, and attach an $i m$-type stop weight, with hop
and stop normalizations $(a, b)$ to be matched.

**Attack plan.**
1. Compute the sprinkling expectation of the single-hop matrix weight: the
   conjecture to test first is
   $\mathbb{E}\big[\sum_{\text{links}} \sigma\cdot(y-x)\,(\cdot)\big]
   = c\,\sigma^\mu \partial_\mu\,
   \mathbb{E}\big[\text{scalar chain sum}\big]$,
   i.e. the covariant vector weight differentiates Johnston's scalar
   volumes. If true, the fermionic result reduces to Johnston's plus the
   identity $S_{\text{Dirac}} = (i\gamma\cdot\partial + m)\,G_{\text{KG}}$,
   which is also the route Johnston himself gestured at.
2. Identify the obstructions honestly: (i) almost all causal links in a
   sprinkling hug the light cone -- *good* for the null-zigzag picture but
   the link-direction distribution is boost-divergent, so only the
   covariant (unnormalized) weight can have finite Lorentz-invariant
   expectations; (ii) the spin connection has no canonical discrete home on
   a causal set -- here flat Minkowski with a global frame suffices for the
   first theorem, curvature is a later extension; (iii) variance control:
   convergence in mean is the realistic first target, fluctuations second.
3. Run the program in 3+1 and 5+1 in parallel (both Huygens dimensions,
   $\mathbb{C}$ and $\mathbb{H}$ spinor-helicity), where the rank-one null
   correspondence does maximal work and the quaternionic case stress-tests
   the formalism short of octonionic nonassociativity.
4. Numerical pilot first: sprinkle, sum chains with matrix weights, compare
   against the continuum kernel. A `Scripts/oracle/` Monte Carlo gives a
   cheap falsification test before investing in proofs (CAS/oracle policy:
   fixtures justify tests, not theorems).

**Publishable unit:** "A Lorentz-invariant checkerboard: the Dirac
propagator from causal sets." This is the highest-risk, highest-value item.

### WP5: Skopenkov-Ustinov-grade asymptotics for Johnston's scalar sum

Independent of WP4 and lower-risk: precise asymptotics of the hop-stop
chain sum on sprinklings (not just expectation matching) -- pointwise decay,
fluctuation behavior, and whether Benincasa-Dowker-type curvature
corrections appear in subleading terms when sprinkling into weakly curved
spacetimes. Chain-counting asymptotics on sprinklings (expected number of
$k$-chains in an interval, related to interval volumes and the
Myrheim-Meyer dimension machinery) are the established starting point.

### WP6: Division-algebra checkerboards (5+1 and 9+1)

- **WP6a.** Formalize the spinor-helicity rank-one factorization
  "$p$ null $\iff$ $p = \lambda\bar\lambda$" over $\mathbb{R}, \mathbb{C},
  \mathbb{H}$ in Lean (finite-dimensional algebra; quaternionic case uses
  existing division-ring machinery).
- **WP6b.** The octonionic ($d = 10$) case: state the rank-one
  correspondence using the repo's XOR-convention octonions and the
  `SpinorTenfold*` pure-spinor layer. Per AGENTS.md, all parenthesization
  explicit; any Baez/Furey formula passes through `ConventionBridge`.
- **WP6c (exploratory).** Define the corner weight for a 9+1D zigzag as an
  octonionic spinor overlap and determine exactly where nonassociativity
  obstructs path-ordering: does the alternative law (any two elements
  generate an associative subalgebra) rescue products along *planar*
  direction histories? A precise no-go theorem would itself be a result --
  and a Lean-checkable one.

### Sequencing and milestones

```
WP0 (verify sources)                                 [short]
  -> WP1a/b + WP3 (Lean, parallel, Aristotle-heavy)  [short-medium]
  -> WP2 (prose structure theorem)                   [medium]
  -> WP4 pilot numerics -> WP4 theorem               [medium-long]
  -> WP5, WP6 (parallel, as capacity allows)         [long]
```

Three independent publishable units (WP1+WP3 formalization paper; WP2
structure-theorem paper; WP4 causal-set paper), each of which stands alone
if the others stall.

---

## 7. Risks and failure modes

- **Literature scooping:** WP2 may exist in scattered worldline-formalism
  form; WP0 must include a serious search (Polyakov spin factor,
  Migdal/Karanikas-Ktorides worldline spin literature) before claiming
  novelty.
- **WP4 divergence:** the boost-divergent link distribution may make even
  covariant matrix weights ill-defined in expectation; the
  derivative-of-scalar-sum reduction (attack step 1) is the escape hatch --
  if it fails, the honest output is a documented no-go.
- **Ontology creep:** the program's claims must stay at the
  propagator/amplitude level. "The electron really trembles" is not a
  theorem and must not be stated as one in any writeup.
- **Convention corruption:** Weyl-basis layout, sign of the corner weight
  $im$ vs $-im$, and metric signature differ across the source papers.
  Every formalized statement records its convention; cross-source formulas
  go through explicit bridges (AGENTS.md policy).
- **Nonassociativity (WP6c):** the octonionic path-ordering may simply be
  obstructed; budget for a negative result.

---

## 8. Connection back to PhysicsSM north star

This program does not displace the mathematics-first ordering of
`NORTH_STAR.md`; it adds a propagator/path-integral layer that consumes the
same foundations: Clifford algebras and spinors (WP3), division-algebra
spinor-helicity (WP6a/b feeding on `SpinorTenfold*`), and explicit
convention discipline throughout. The Lean targets (WP1, WP3, WP6a/b) are
all finite/algebraic statements suitable for the existing toolchain and the
Aristotle workflow; the analytic continuum limits are explicitly marked
long-horizon and are not prerequisites for the formal layer.
