# The Null-Edge Program: State of the Work and Directions for Extension

*A self-contained overview for a collaborator. Written 2026-07. Everything below is
either (i) kernel-checked in Lean 4 + Mathlib (marked **PROVED**), (ii) an explicit
modelling hypothesis not yet derived (**MODELED**), (iii) an open target (**OPEN**), or
(iv) an informal idea/analogy (**SPECULATIVE**). The point of the document is the last
third — the extension directions — but the first two thirds establish what is actually
on solid ground so the extensions can be judged against it.*

---

## 0. One-paragraph summary

We are pursuing a single thesis: **mass is a relational obstruction to null (lightlike)
transport**. A lone lightlike excitation is massless; mass appears exactly when
something obstructs free null propagation. We have made this precise as an operator
statement — the square of a "null-soldered transport operator" `D` on a finite complex
of null edges decomposes, by a discrete Weitzenböck/Lichnerowicz identity, into a small
number of canonically-graded obstruction terms, each of which is one physical mode of
mass (matter/chirality, gauge/confinement, composite/kinematic, and gravity). The core
of this decomposition is now **kernel-checked**. The interesting scientific question —
and the reason for this document — is that the *same* structure (null edges + soldering
+ transport, with an indefinite/Krein inner product) plausibly organizes much more than
mass: charge, spin-statistics, causality and entropy, gravity, anomalies, and possibly
emergent spacetime. We are looking for the sharpest extensions.

---

## 1. The thesis and the central object

### 1.1 Mass as obstruction to null transport

Physical intuition: a massless particle moves on the light cone; a massive one does not.
"Acquiring mass" is being forced off free null propagation. We identify three ways a
null excitation can be obstructed, kept deliberately distinct:

- **T — Turn (matter/chirality mass).** A massless Weyl mode acquires mass by being made
  to reverse handedness — the Higgs–Yukawa chirality-flipping vertex. (Penrose's "zig-zag"
  picture of the Dirac electron: a massive fermion is two coupled *null* Weyl modes, mass
  = the flip rate between them.)
- **C — Closure (gauge mass / confinement).** The cost of closing a null loop against a
  nonabelian gauge connection — the Yang–Mills mass gap / confinement scale.
- **A — Aperture (composite/kinematic mass).** The invariant mass of several null momenta:
  individually massless constituents bound into a massive whole (`M² = (∑ pᵢ)²`).

There is a fourth, which only appears when the geometry itself varies:

- **G — Gravity.** When the null soldering is not covariantly constant, an extra term
  appears; it is the discrete avatar of the boundary term in Witten's spinor proof of the
  positive-energy theorem (ADM mass = a boundary term of a Dirac–Weitzenböck identity).

### 1.2 The carrier operator

The object that ties these together is a first-order operator on a finite **2-complex**
`K` (vertices, oriented edges, plaquettes) of null edges:

> **D = Σₑ c(αₑ) ∇ₑ + Φ**

- `αₑ` is a *null* covector soldered to edge `e`; `c` is Clifford multiplication into a
  spinor/Clifford module `S`;
- `∇ₑ` is the gauge-covariant difference along `e` (edge holonomy `Uₑ` acting on an
  internal space `W`);
- `Φ` is a chirality-odd potential (the Higgs/Yukawa datum);
- `S` carries a **Krein** (indefinite) inner product with adjoint `#` — this is the
  Lorentzian signature, not a positive-definite Hilbert space.

The mass form is the **Krein square** `D^#D` (not `D²`). The keystone fact that makes the
whole picture work is that **null covectors are nilpotent Clifford elements**:
`c(α)² = g(α,α) = 0`. So a lone edge contributes nothing, and *every* term of `D^#D` is a
pairwise relation between distinct null edges — "mass is relational" becomes a literal
statement about a matrix with zero diagonal.

### 1.3 Unification is decomposition, not identification

The central conceptual move (and the thing that dissolved an apparent paradox in our own
results): T, C, A, G are **not** four competing definitions of mass that might turn out to
coincide. They are four **canonically-graded summands of one quadratic form**:

> **D^#D = Q_A + Q_C + Q_T + E.**

This is exactly analogous to the Atiyah–Singer index density: the Chern character and the
Â-genus are genuinely distinct characteristic classes that no natural transformation
converts into one another, yet they are components of one integrand of one operator. We
even proved a "no common carrier" theorem — no single one of our models carries all four
masses non-artificially — and it turns out to be the *irreducibility half* of the
unification, not an obstruction to it. Grading, not merging, is the right notion.

The grading is by **(operator order in ∇, Clifford degree)**, refined by chirality parity:
`Q_A` is (order 2, degree 0) — the Gram form of the soldering; `Q_C` is (degree 2) — the
holonomy/curvature bivector; `Q_T` is (order 0) — the potential square. `E` is the
soldering-gradient remainder. No natural transformation moves content between the slots.

---

## 2. What is formally established (kernel-checked)

All results below are machine-checked in Lean 4 + Mathlib under a frozen toolchain, with
a build-time guard pinning each theorem's axiom footprint to the standard base
`{propext, Classical.choice, Quot.sound}` — i.e. no `sorry`, no unchecked compiled
evaluator, no extra axioms. Names are given so results can be located precisely.

### 2.1 The discrete Weitzenböck decomposition (the carrier core) — PROVED

Working in a single associative algebra `B` with `hcl` (the Clifford anticommutator of
soldered generators equals the scalar Gram datum `g`) and `hcomm` (soldering commutes with
transport):

- **`weitzenbock_master`** — `4·D0² = Q_A + Q_C`, char-free, where
  `Q_A = Σₑ_f g(e,f)·{∇ₑ,∇_f}` (symmetric Gram block) and
  `Q_C = Σₑ_f [γₑ,γ_f]·[∇ₑ,∇_f]` (antisymmetric closure block). The `E=0` shadow of
  `weitzenbock_master_varying` (below), which drops `hcomm` and exhibits the gravity slot
  `E` as the soldering-gradient defect (`E=0 ⟺ hcomm`). **OPEN→landing** as of writing.
- **`dirac_square_with_potential`** — with a chirality `Γ` (`Γ²=1`, `Γγₑ=−γₑΓ`) and a
  covariantly-constant Higgs `φ`, `(D0 + Γφ)² = D0² + φ²`. (The naive γ-even potential does
  *not* cancel — covariant constancy kills the commutator, not the anticommutator — so the
  turn slot is genuinely chirality-dressed. `Q_T = φ²`.)
- **`carrier_square_assembly`** — combining the two: `4·D² = Q_A + Q_C + 4·Q_T`. This is
  the full carrier square decomposing into the three mass slots, in the clean (`E=0`)
  regime.
- **Torus realization** (`nabla_commutator_path_difference`, `mZero_iff_commute`): on the
  minimal `ℤ₂×ℤ₂` gauge lattice with `∇_a = M(U_a)T_a − id`, the transport commutator
  `[∇_a,∇_b]` equals the plaquette holonomy path-difference, and `Q_C = 0 ⟺ the connection
  is flat`. So the abstract `Q_C` has a concrete gauge-theoretic meaning.

**Honest boundary (important — do not over-read this).** The decomposition
`weitzenbock_master` is, as pure algebra, the *standard Clifford grade-split* (sym +
antisym) — it is a general algebraic identity, not by itself a physics theorem. Its
scientific content lives entirely in three things that are **still open**: (i) the
**identification lemmas** tying `Q_A/Q_C/Q_T` to the independently-defined mass functionals
of §2.2 (without these, "`Q_A` = aperture / `Q_C` = closure / `Q_T` = turn" is a naming
convention, not a proof); (ii) the **Krein upgrade** `D²→D^#D` (mass is `inf spec D^#D`, and
`D²≠D^#D` on an indefinite space, so the `D²` assembly is a *scaffold*, not yet a mass
statement); and (iii) a **single witnessing model** — the three bricks currently live in
different algebras, so an object instantiating all hypotheses at once (a "`TorusCarrierModel`"
on the `ℤ₂×ℤ₂` torus, with `Q_A/Q_C/Q_T` simultaneously nonzero) is still being built. These
three — flagged independently by both our conceptual reviewer (Fable) and an adversarial
strategy audit — are the honest frontier; the kernel-checked decomposition is the trustworthy
scaffold they hang on.

### 2.2 The individual mass modes (from an earlier, broader push) — mixed PROVED/MODELED

Before the unifying decomposition, each mode was established on its own finite model. These
are the "component functionals" the decomposition's terms are meant to reproduce:

- **A (aperture) — PROVED.** `nbody_aperture_massless_iff_collinear`: for any `N` future-null
  momenta, the sum is again null **iff** all are collinear (both directions). Quantitative:
  `compositeMassSq_eq_sin_half` gives `M² = 4E²sin²(θ/2)` for two equal-energy null momenta —
  mass is literally the angle between null edges. An entropy functional on the null-direction
  spread (`ApertureEntropy`) is zero iff a single direction. A composite of individually
  massless constituents has strictly positive mass.
- **T (turn) — PROVED (genuine 1D no-go) + supporting.** `signedZeroCount_eq_zero`: the honest
  1D Nielsen–Ninomiya no-go — the signed count of sign-crossings of a real periodic dispersion
  vanishes (you cannot have a lone chiral mode on a lattice). Tied *exactly* to the overlap
  index: `signedZeroCount = overlap index difference`. The Ginsparg–Wilson relation and the
  Neuberger overlap operator are formalized; the deformed chiral symmetry (`γ̂₅ = γ₅(1−D)`) is
  an exact involution — the "price of the turn." `turnAmplitude_eq_zero_iff`: the
  chirality-flipping vertex vanishes iff the mass matrix does. The general `d`-dimensional /
  4D degree argument is **OPEN**.
- **C (closure) — Z2 complete; nonabelian gap OPEN.** A full finite abelian (`ℤ₂`) confinement
  chain: reflection positivity → self-adjoint transfer operator → strictly-positive spectral gap
  `= −log(tanh β)` → exponential clustering. The correct *nonabelian* strong-coupling character
  dominance (`‖c_R‖ ≤ dim(R)·c_triv`). A Tomboulis–Yaffe area-law scaffold generalized to an
  abstract SU(N) center-twist system, and a first genuinely nonabelian (quaternion group Q8)
  string tension. **MODELED:** the reflection-positivity raw bound and the SU(N) partition
  functions are hypotheses, not built from an actual Haar measure. **OPEN (the hard gate):** a
  nonabelian SU(N) mass gap at fixed spacing from a constructed lattice measure.
- **X (taxonomy) — PROVED.** The four mass functionals are pairwise distinct, each independently
  realizable, and there is no single non-artificial model carrying all four (`no_common_carrier`)
  — the irreducibility statement discussed in §1.3.
- **B (division algebra → SM) — co-location + one dynamical constraint.** The octonionic `su(3)`
  color structure sits where the Standard-Model color charges do; SM anomaly cancellation is
  formalized. `color_commutant_eq_scalars`: the commutant of the color action on one triplet is
  exactly the scalars (Schur), so a non-color-singlet diagonal mass grading is *not* a physical
  (color-exact) mass — a constraint on where Yukawa structure can live. The Spin(10) pure-spinor
  stabilizer program has a documented false-as-stated claim (complex vs compact real form) and
  open pieces.
- **V (trust) — PROVED.** The entire E8 root system (240 roots) is kernel-checked by structural
  counting and shown to be exactly the norm-2 E8-lattice vectors.

---

## 3. The conceptual map: where this touches established mathematics

The program keeps colliding with well-developed theories. These are the bridges we see; a
collaborator may see sharper ones. Each is a potential extension in itself.

- **Index theory.** The T-mode is literally an index (Nielsen–Ninomiya = the vanishing Euler
  class of a trivial bundle; crossing count = overlap index). The whole `D^#D` decomposition
  smells like an index density. *Is the entire program an index theorem in disguise?*
- **Noncommutative geometry / the spectral action.** `D = Σ c(α)∇ + Φ` is a Dirac operator; our
  discrete carrier is essentially a **gauge network** (Marcolli–van Suijlekom) — a finite-graph
  Dirac operator with edge holonomies. In the Connes–Chamseddine spectral Standard Model the
  Yukawa matrix *is* the internal Dirac operator of a finite spectral triple; lane B's job is to
  constrain that internal factor. The mass form may literally be spectral-action content `Tr f(D)`.
  Our Krein/indefinite structure connects to **indefinite (Lorentzian) spectral triples**
  (Krein-adjoint `A^# = ηA*η`, chirality involution `Γ^# = ±Γ`).
- **Discrete Weitzenböck / Lichnerowicz.** The decomposition is the discrete Bochner–Lichnerowicz
  formula; the curvature endomorphism is our `Q_C`, and the gravity term `E` is the
  spin-connection/torsion defect. Fable's sharper reading is that the `E`-slot is not just
  "gravity-like": it is the discrete null-edge version of **teleparallel gravity**. In the
  continuum, teleparallel/Weitzenbock geometry uses flat parallelism and puts gravitational
  content into the torsion/failure of the soldering to be covariantly constant. That is exactly
  the role of the carrier's soldering-gradient defect. This remains an extension target, not a
  proved equivalence, but it gives the G-slot a known geometric home.
- **Twistors and celestial holography.** Null edges are twistor-like; a massive particle needs ≥2
  twistors (one twistor is null) — the classic Penrose–Perjés–Hughston "two-twistor particle."
  In massive spinor-helicity (Arkani-Hamed–Huang–Huang) every massive momentum is a bound pair of
  null spinors `p = λλ̃`, and our kernel-checked `M² = 4E²sin²(θ/2)` is literally `|⟨12⟩|²`. The
  aperture entropy is a functional on the celestial sphere — the natural home of celestial
  holography's massive conformal primaries.
- **Positive geometry.** Aperture mass as a positive-geometry / amplituhedron-style volume;
  `⟨12⟩` brackets are the positive-geometry data.
- **The Feynman checkerboard.** The 1+1d (and 4D) checkerboard — the massive propagator as a sum
  over null zig-zag paths weighted by the number of turns — is a *complete, exactly solvable*
  instance of "mass = obstruction to null transport," and the natural toy model for the whole
  carrier picture.
- **Pure spinors / polarizations.** A maximal set of mutually-null directions is a maximal
  isotropic subspace; a pure spinor is the Fock vacuum of such a polarization. So lane B's
  pure-spinor GUT machinery and lane A's null soldering are *the same structure*: mass, in every
  mode, is failure of null transport to preserve a polarization.

---

## 4. Extension directions (the main ask)

Organized by theme. Grades: **[near]** builds directly on what's proved; **[reach]** a
substantial but well-posed program; **[SPECULATIVE]** a hunch worth a conversation.

### 4.1 Beyond mass — other invariants as obstructions to null transport

The thesis was about mass, but the carrier carries much more structure. What *else* is an
obstruction, and to what?

- **Charge and charge quantization [reach].** The closure mode already encodes gauge holonomy
  as `H²(K, Z(G))` (2-cohomology with center coefficients). Extension: derive the gauge group,
  representation content, and *charge quantization* from the cohomology of the null-edge complex,
  rather than assuming a gauge group. Does the null-edge structure force a specific `G`?
- **Spin and spin-statistics [reach].** The Clifford/Krein module is where spin lives. Can the
  spin-statistics connection be *derived* from the braiding/orientation data of null edges (edge
  orientations = the causal arrows), rather than imposed?
- **Causality, time, and entropy [reach/SPECULATIVE].** Null edges are intrinsically causal
  (they are light-cone data). We already have an "aperture entropy" that measures the spread of
  null directions. Extension: an *arrow of time* and a coarse-graining/second-law statement from
  null-edge structure; a precise bridge to **causal set theory** (which also builds spacetime
  from causal/lightlike relations but has no soldering/Clifford layer — our carrier could be the
  missing dynamical operator on a causal set).
- **Gravity as the fourth mode, taken seriously [near/reach].** The `E`-slot is the gravity mode,
  and we can already state `E=0` as the discrete tetrad postulate / metric compatibility
  (covariantly constant soldering), with Witten's positive-energy theorem as the continuum avatar.
  Fable's strongest suggestion is to name the extension **discrete null teleparallelism**:
  transport is flat in the gravity sector while the soldering varies, so gravitational content is
  torsion rather than curvature. A near Lean target is to define a discrete torsion 2-form
  `T(e,f) = nabla_e alpha_f - nabla_f alpha_e` and prove that the `E`-slot is its Clifford
  contraction, the G-slot analogue of the torus realization of `Q_C`. The reach target is a
  genuine discrete TEGR/ADM story on null-edge complexes, with the usual positive-energy boundary
  term as the continuum comparison.

### 4.2 More physics from the same carrier

- **Anomalies and anomaly inflow [near/reach].** The T-mode is exactly the lattice-fermion
  index/no-go content. Extension: formalize 't Hooft anomaly matching, anomaly inflow, and
  cross-slot effects like the Schwinger-model photon mass (a gauge mass sourced by the axial
  anomaly — a T-slot topological effect feeding the C-sector) and the Higgs mechanism (a gauge-boson
  mass entering through the potential slot). These *cross-slot* phenomena are a stress test and a
  prediction: the taxonomy classifies operator *terms*, never particle-by-particle masses.
- **The full confinement story [reach, hard].** Push the C-mode from fixed-spacing abelian to a
  genuinely nonabelian SU(N) mass gap, and toward the continuum. This is Clay-adjacent; even the
  fixed-spacing strong-coupling SU(2) gap (Osterwalder–Seiler, mechanized) would be a landmark.
- **The Standard-Model spectrum [reach].** Lane B connects `ℂ⊗𝕆` to SM charges. Extension: the
  internal spectral triple's Yukawa space (the color commutant / multiplicity spaces) as the home
  of flavor — three generations, mixing angles, the mass hierarchy. Nobody derives the mass
  *values*; the achievable target is the *shape* of the allowed Yukawa sector.
- **The Koide relation and mass textures [SPECULATIVE].** If mass is an angle/relation between null
  edges, mass *ratios* may be geometric. Worth checking whether known lepton mass relations
  (Koide) have a null-edge reading.

### 4.3 Mathematical extensions

- **Exhaustiveness / classification theorem [reach].** Prove the taxonomy is *exhaustive*: on a
  suitable null-edge complex, `D^#D` decomposes into exactly these slots and no others (a graded
  Bochner classification). Fable's recommended formulation is PBW/rewrite-theoretic: put the
  `(order in nabla, Clifford degree)` bifiltration on the free carrier algebra modulo the `hcl`,
  `hcomm`, and chirality relations, then prove the associated graded of the square has exactly the
  slot bidegrees and no others. We can currently state it *relative to hypotheses* (each dropped
  hypothesis yields exactly one known extra term); the unconditional version is open and would be
  the theoretical capstone.
- **Continuum limit and renormalization [reach].** Discrete Weitzenböck → continuum Lichnerowicz;
  a renormalization-group story for the null-edge lattice; the checkerboard as the exactly-solvable
  1+1d control case.
- **Higher gauge theory [SPECULATIVE].** The closure mode is 2-cohomology; the natural home for a
  refined closure structure is higher gauge theory (2-groups, gerbes) on the 2-complex. Does the
  aperture/turn structure want an even higher-categorical home?
- **The reusable "discrete Weitzenböck" library [near].** The abstract identity
  `4·D0² = Q_A + Q_C` holds for *any* Clifford-anticommuting soldering with commuting transport in
  *any* ring — it is a general algebraic fact worth packaging (potentially upstreamable to Mathlib),
  independent of the physics.
- **Indefinite spectral triples, formalized [reach].** There is no formal (machine-checked) theory
  of Krein/Lorentzian spectral triples yet; the carrier program is a concrete driver for one, and
  it connects to PhysLean.
- **Finite Pontryagin positivity [near].** Fable's highest-leverage positivity reframing is
  finite-dimensional: the carrier lives in a finite Pontryagin/Krein space, not an arbitrary
  infinite-dimensional Krein setting. The first formal target is an invariant maximal nonnegative
  subspace theorem for a `J`-self-adjoint finite matrix/operator. If this is proved, the mass-form
  question changes from "does a positive physical sector exist?" to the sharper and more physical
  "is the guaranteed sector natural, gauge-invariant, local, and grading-compatible?"

### 4.4 Emergent-spacetime and information-theoretic directions [SPECULATIVE]

- Can the tetrad/metric *emerge* from null-edge combinatorics, rather than being decorated on top?
  (We are deliberately careful here: a bare graph does not canonically supply a tetrad — that is a
  known guardrail — so this is a genuine open problem, not an assumption.)
- Null edges as an entanglement/holographic structure: is `D^#D` positivity (the physical-sector
  question, currently our hardest crux) an *entropic* condition? Does the aperture entropy connect
  to entanglement entropy across a null cut? Fable points to a speculative but precise finite
  shadow of ANEC/QNEC: positivity of the null-directed mass form may be relative-entropy
  positivity across a null cut, with modular flow supplying the null transport.

### 4.5 The honest hard cruxes (where help is most valuable)

If the collaborator wants the highest-leverage problems rather than new directions:

1. **Krein positivity.** On which physical sector does the indefinite form `D^#D` restrict to a
   genuine non-negative form (so `M² = inf spec` is meaningful)? Fable's near target is the finite
   Pontryagin invariant-subspace theorem: prove existence first, then ask whether the guaranteed
   sector is natural/gauge-invariant/local rather than whether a sector exists at all.
2. **The nonabelian mass gap.** The C-mode gate (see §4.2).
3. **Exhaustiveness.** The unconditional classification (see §4.3).
4. **The `ℂ⊗𝕆 →` dynamics.** A genuine piece of SM dynamics, not just charge co-location.

---

## 5. How the work is organized (pointers)

- **Formal core (Lean):** the carrier bricks live in `PhysicsSM/Draft/NullEdge/Carrier/`
  (`WeitzenbockMaster`, `CarrierPotentialTurn`, `CarrierSquareAssembly`, `WeitzenbockQC_Torus`,
  guarded by `CarrierAxiomGuard`); the per-mode corpus in `PhysicsSM/Draft/NullEdge/GateI1`
  (aperture), `GateYM` (turn/closure), and `PhysicsSM/Algebra/Furey` (division algebra).
- **The organizing synthesis:** `FABLE_STEER.md` (the decomposition-not-identification verdict and
  the Move-1/2/3 plan) and `HONEST_SCORECARD.md` (the graded status).
- **Discipline:** every headline is axiom-guarded; every result is graded PROVED/MODELED/OPEN;
  no continuum or Clay-gap claim is made anywhere; the Lean kernel is the sole arbiter.

## 6. What we would love ideas on

In one line each:

- **The biggest bet:** is "gravity is the fourth slot of the mass operator" a real discrete-gravity
  program, or an analogy that breaks? Current best answer from Fable: yes, the precise name is
  discrete null teleparallelism; the near theorem is `E` as the Clifford contraction of discrete
  torsion.
- **The unifying theorem:** what is the sharpest single statement of "mass = failure of null
  transport to preserve a polarization," and is it provable?
- **The right ambient mathematics:** index theory, Lorentzian NCG, twistor/celestial, positive
  geometry, causal sets — which one is the *natural* home, and what does adopting it buy? Current
  best split: finite Lorentzian spectral triples / spectral action for the operator as a whole;
  twistor/spinor-helicity for the aperture slot; teleparallel geometry for the G-slot; PBW
  rewriting for exhaustiveness.
- **New obstruction ⇒ new physics:** which non-mass invariant (charge, spin, causality, gravity)
  is the most promising *next* obstruction to formalize on the same carrier? Current best answer:
  spin, via the massive little group on null-edge pairs, because it builds directly on the proved
  aperture mass theorem.

---

## 7. Ranked extension directions — an expert reviewer's assessment

*Detailed ranking by a strong theorist (leverage × well-posedness under the no-`sorry` regime),
expanding the one-line answers in §6. Grades as before.*

### 7.1 The gravity slot **is** teleparallel gravity — this answers the biggest bet

The `E`-term (soldering-gradient defect; `E=0` = the discrete tetrad postulate) is the discrete host
of **teleparallel gravity** — the GR-equivalent theory built on the **Weitzenböck connection**: flat,
metric-compatible, all gravitational content in **torsion**, i.e. in exactly the failure of the
soldering to be covariantly constant relative to a trivial parallelism. So "gravity as the fourth
slot" is not a category error — torsion is to the G-slot what curvature is to the C-slot. Consequences:
(i) TEGR differs from Einstein–Hilbert by exactly a boundary term — *the* boundary term in Witten's
positive-energy proof we cite as the continuum avatar of `E` (Nester's quadratic-spinor / teleparallel
positive-energy proofs, Maluf's teleparallel ADM energy = a surface integral of torsion, are the
continuum targets). (ii) `weitzenbock_master` being the master theorem's name is not a coincidence.
(iii) **[near] Lean target:** define the discrete torsion 2-form `T_{ef} = ∇ₑα_f − ∇_fαₑ` and prove
`E` is its Clifford contraction — the G-slot analogue of our torus realization of `Q_C`. **Verdict:
a real discrete-gravity program — "discrete null teleparallelism."**

### 7.2 Krein positivity — three graded routes (the hardest crux, decomposed)

- **[near, TOP PICK] Pontryagin invariant subspaces.** The complexes are *finite*, so we are in
  **Pontryagin spaces `Π_κ`**, where Pontryagin (1944) / Krein–Langer guarantees every `J`-self-adjoint
  operator has an invariant maximal non-negative subspace. Applied to `D^#D`, this **guarantees** a
  positive-semidefinite sector — so `M² = inf spec on the physical sector` is meaningful with no extra
  input, and the question sharpens from "does a physical sector exist?" to "is the guaranteed one
  *natural*?" — a strict epistemic upgrade. Finite-dimensional honest linear algebra; **no Krein/
  Pontryagin theory exists in Mathlib**, so it is a citable formalization in its own right.
- **[reach] Osterwalder–Schrader as the physical sector.** We have RP machinery in lane C; OS
  reconstruction produces a positive Hilbert space by quotienting null vectors of a semidefinite form.
  Null edges give a canonical causal reflection `θ`. *Pre-registered conjecture:* `⟨θx,x⟩` from the
  Krein structure is positive-semidefinite on the reflection-symmetric sector and `D^#D` descends
  positively to the OS quotient — **unifying our own lanes** (confinement RP = mass Krein positivity).
- **[SPECULATIVE] discrete ANEC / entanglement.** Null-energy positivity is provably entanglement
  (ANEC/QNEC via modular theory; Borchers–Wiesbrock: null translations *are* modular flow of null cuts).
  Precise hunch: null transport = modular flow for the Krein structure + a cut; physical-sector
  positivity = a discrete ANEC ("mass-form positivity = relative-entropy positivity across a null cut").

### 7.3 The program is an index theorem — McKean–Singer, spectral action as ambient home

Prove **McKean–Singer on the carrier**: `Str e^{−tD^#D}` is `t`-independent = the index (short,
kernel-checkable in finite dim). The slot decomposition becomes the *coefficients* of the supertrace
(discrete Seeley–DeWitt) expansion — `Q_C` in the Chern slot, `E` in the Â/torsion slot, `Q_T` in the
endomorphism slot. **Ambient home:** finite Lorentzian spectral triples *with the spectral action* —
Chamseddine–Connes' `a₂,a₄` heat coefficients of `Tr f(D²/Λ²)` = cosmological constant + Einstein–
Hilbert + Yang–Mills + Higgs potential, the continuum shadow of "all masses are graded summands of one
operator square." Sharp continuum target: our decomposition should converge slot-by-slot to that
expansion. (NCG is the home of the *operator*; twistor/celestial the home of the A-slot.)

### 7.4 Exhaustiveness is a PBW / diamond-lemma theorem

Restate the classification as rewriting theory: the (order-in-∇, Clifford-degree) bifiltration on the
free algebra generated by `{γₑ,∇ₑ,φ}` modulo the relations, proving the associated graded of `D^#D` has
components in exactly bidegrees `(2,0),(0,2),(0,0),(1,1)` and no others — a **PBW/basis statement** by
Bergman's diamond lemma (finite confluence, Lean-friendly). "Each dropped hypothesis adds one slot"
becomes "relaxing one relation adds one normal-form family" — a terminating computation, not a
mystery.

### 7.5 The next invariant should be spin (then, cautiously, spin-statistics)

**Spin** builds directly on proved results. In massive spinor-helicity a massive momentum is a pair of
null spinors `p = λ^I λ̃_I`, `det λ = M`, with SU(2) little group on the pair index — **mass and spin
both live on the aperture of two null edges**. We have `M² = |⟨12⟩|²`; the extension builds the
Pauli–Lubański operator from the same pair data and recovers the Wigner classification as finite linear
algebra (single edge → helicity; two-edge aperture → SU(2) spin). Defer spin-statistics. *Koide bonus:*
massive spinors scale as `√M`, so the `√m` variables in which Koide is natural are the native variables
of the aperture slot; Foot's observation (Koide ⇔ `(√mₑ,√m_μ,√m_τ)` at 45° to `(1,1,1)`) makes it
literally an **angle** statement — the shape this framework speaks.

### 7.6 Shorter but real

- **Generalized symmetries [reach].** `H²(K,Z(G))` center-twist data *is* the 1-form center-symmetry
  background; confinement = unbroken 1-form symmetry (Gaiotto–Kapustin–Seiberg–Willett,
  **AXAWAGGB**). Our Tomboulis–Yaffe machinery is this in older clothes — the reframing
  modernizes the C-gate.
- **Charge quantization [near].** On a finite 2-complex, Dirac quantization = integrality of the
  plaquette flux cocycle (DeGrand–Toussaint), `H²(K,ℤ)→H²(K,U(1))` — eminently formalizable.
- **Emergence of geometry [reach], re-posed.** By Malament / Hawking–King–McCarthy, causal order alone
  fixes the *conformal* class — so null edges carry the conformal metric for free, and the combinatorics
  need only supply the **scale**, which is exactly the Gram data `g(e,f)` (Sorkin's "order + number =
  geometry"). Shrinks "can the tetrad emerge?" to "can the scale emerge?".
- **Interacting continuum control [reach].** The **Destri–de Vega light-cone lattice** (massive
  Thirring / sine-Gordon on null lines) is the exactly-solvable interacting upgrade of the checkerboard
  — the 1+1d control case *with interactions*.

### 7.7 If forced to pick two

1. **The Pontryagin invariant-subspace theorem** — finite-dimensional, unformalized anywhere, converts
   the hardest crux from "does a physical sector exist" to "is the guaranteed one natural."
2. **Adopt the teleparallel reading of `E`** — the difference between "gravity as fourth mode" being an
   analogy and being a discretization of a known GR-equivalent theory with the positive-energy theorem
   already at its boundary.
