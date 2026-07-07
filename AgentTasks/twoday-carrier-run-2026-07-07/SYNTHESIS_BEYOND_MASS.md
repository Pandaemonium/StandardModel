# Beyond mass: the null-edge program as index theory on a Krein complex

Synthesis note, 2026-07-07 (Fable-5 session, Claude lane). Companion to
`NULLEDGE_PROGRAM_AND_EXTENSIONS.md` (the collaborator overview); this note is the
NEXT layer of thinking - new connections found while landing the day's bricks, with
explicit claim labels. Kernel anchors cited by theorem name are in
`PhysicsSM/Draft/NullEdge/Carrier/` and guarded in `CarrierAxiomGuard.lean`.

Claim labels used: KERNEL (kernel-checked today, guard-green), FINITE IDENTITY
(kernel-checked finite statement whose physics reading is prose), STRATEGY (attack
plan, not yet math), CONJECTURE (precise but unproved), SPECULATIVE (not yet precise).

## 1. The organizing shift: one operator, three integers (the index trinity)

The program so far asked "where does mass come from?" and answered with a
decomposition: `D^#D = Q_A + Q_C + Q_T + E`. Today's landings suggest the deeper
frame: the carrier `D` on a finite Krein complex carries THREE integer invariants,
and the discrete skeleton of a Standard-Model-like theory is their joint data.

1. **The chiral (Fredholm) index** `ind(D) = dim ker D_+ - dim ker D_-`.
   KERNEL: `chiralIndex_eq_graded_dimension`, `chiralIndex_protected`,
   `chiralIndex_adjoint_pair`, `chiralIndex_krein_pair`,
   `exists_protected_massless_mode`. It equals the graded dimension
   `dim M_+ - dim M_-` for every rank-symmetric carrier (automatic for Hilbert- and
   Krein-self-adjoint blocks). It counts PROTECTED MASSLESS chiral modes.
2. **The Pontryagin index** `kappa` = dimension of the negative sector of the
   fundamental symmetry. KERNEL (witness): `finrank_eigenspace_plus/minus` = 2 on
   the `sigma_z (x) I` witness - inertia (2,2), `kappa = 2`. It counts GHOST/GAUGE
   directions - the price of manifest locality on null edges.
3. **The Weitzenbock inertia** - the signature data of the mass form distributed
   across the slots `Q_A / Q_C / Q_T` (aperture / closure / turn). PARTIAL KERNEL:
   Move-2 `Q_A = Q(sum alpha)` identification; the full mode taxonomy is the W2
   ladder. It classifies WHERE mass can sit.

Helpful way of thinking (the slogan of this note): **mass physics is index theory on
a Krein complex - mass is everything the indices do not protect.** The mass question
and the masslessness question are the two sides of one operator identity, and the
masslessness side is now partially kernel-checked.

Program-level CONJECTURE (falsifiable in-model): for finite null-edge models, the
triple `(ind, kappa, Weitzenbock inertia)` determines the qualitative particle
content - number of protected chiral fermions, gauge redundancy rank, and which mass
channels (turn vs closure vs aperture) can be active.

## 2. Masslessness inverted: gapping obstructions (from today's index bricks)

FINITE IDENTITY, kernel-checked: `chiralIndex_protected` says no potential `phi` and
no transport `nabla` can change `ind`; `exists_protected_massless_mode` exhibits the
consequence - on any complex with `dim M_- < dim M_+`, EVERY carrier annihilates a
nonzero positive-chirality state.

Physics readings (prose layer, honestly separated):

- **A chirally unbalanced complex cannot be fully gapped.** Mass generation is
  topologically obstructed; the obstruction is an integer computed from the complex
  before any dynamics. This is the finite shadow of "why the photon/neutrino sector
  stays light without fine-tuning": not dynamics, bookkeeping.
- **Gapping happens in +/- pairs.** The rank-nullity mechanism pairs lifted modes
  across chirality - the finite skeleton of Dirac-mass pairing; the unpaired surplus
  is Weyl/Majorana-shaped. (Seesaw-shaped question, CONJECTURE: in a two-sector
  complex where one sector's grading is balanced and the other's is not, do small
  turn couplings between them reproduce the seesaw hierarchy at the level of the
  finite mass form? Checkable on an 8-dimensional toy.)
- **Consistency check on today's witness** (worth recording): the kappa=2 Pontryagin
  witness has BALANCED grading (2,2), so `ind = 0` there - consistent with its
  strictly positive mass form (`witness_mass_form_strictly_positive`): nothing is
  protected, everything can be (and is) massive. A CHIRAL witness
  (`Gamma = diag(1,1,-1)` on C^3, say) is the natural next exhibit: `ind = 1`, one
  forced massless mode coexisting with the massive sector. Cheap target, high
  didactic value.

## 3. CRACK 3 rerouted: positivity as finite Gupta-Bleuler (STRATEGY)

The standing prize is off-flat positivity of the Krein mass form on a physical
sector. Existence of maximal nonnegative subspaces is KNOWN-DEGENERATE (Codex's
audit: true but does not give a physical Hilbert sector). Today's reframe, informed
by how Krein spaces are actually used in gauge QFT (Gupta-Bleuler / Kugo-Ojima):

**Do not look for a positive subspace. Build the physical QUOTIENT.**

Ladder (each rung finite linear algebra, Aristotle-sized):

1. Constraint kernel: define the finite constraint set (retardedness
   `x_e(k) >= 0` as the positive-frequency selector, per Fable call-03; plus
   closure constraints on gauge slots) and `V_phys' := ker(constraints)`.
2. Radical: `N := V_phys' cap (V_phys')^perp_J` - the null subspace of the Krein
   form restricted to the constraint kernel. On finite complexes this is the
   radical of a restricted Hermitian form; computable.
3. Quotient positivity: the induced form on `V_phys'/N` is nondegenerate by
   construction; the THEOREM to prove is that it is positive DEFINITE - and the
   Weitzenbock decomposition should reduce this to slot-wise statements
   (aperture: `nbody_massSq_nonneg`-style Gram positivity; turn: `phi^2` squares;
   closure: the leading-order `Q_C` normalization).
4. Naturality: gauge shifts land in `N` (that is WHY the quotient is the physical
   space); state as: the closure-mode image is contained in the radical.

The conceptual gain: the crux stops being "find positivity" (false in general on a
Krein space) and becomes "the radical is exactly the gauge directions" - an
EXACTNESS statement, which is the kind of thing finite complexes are good at. This
also finally gives `kappa` its physical job: `kappa` counts what the quotient
removes.

Cross-reference: this is the standing FABLE_QUEUE item "Krein positivity domain"
and Codex's "definitizable vs eigenbasis hypothesis" question - the quotient route
REPLACES the search for the right positivity hypothesis with a construction.
Aristotle strategy job firing this cycle to ratify the exact rung statements.

Two further selectors for V' (integrated 2026-07-07 from
`Sources/Ontology_extensions.md` sec 2, routes b/c), to be compared against the
constraint-kernel selector in ONE finite framework:

- **The OS/reflection selector (STRATEGY, pre-registered).** Null edges give a
  canonical causal reflection `theta` across a cut (reverse causal arrows).
  Conjecture: the reflection form `<theta x, x>` built from the Krein structure
  is positive semidefinite on the reflection-symmetric sector, and `D^#D`
  descends positively to the OS quotient. Payoff if true: the reflection
  positivity used for confinement (OS1 lane) and the Krein positivity needed
  for mass are THE SAME THEOREM used twice - a lane unification. Sharp
  witness-checkable sub-claim (new, this note): the fundamental symmetry is
  the causal reflection - `J = Gamma` IS a reflection of null direction
  (chirality = direction of motion in the checkerboard reading), so on the
  kappa=2 witness "OS form = Krein form on the symmetric sector" is a finite
  computation. Both quotient constructions (Gupta-Bleuler radical, OS null
  vectors) are instances of one pattern - quotient a semidefinite sector by
  its radical - differing only in how the sector is selected; that is the
  right shared formal core to build once in Lean.
- **The modular/entropic selector (SPECULATIVE, the deep version).** Continuum
  counterpart: ANEC/QNEC positivity of null-directed energy is provably an
  entanglement statement (modular theory + relative-entropy positivity), and
  Borchers-Wiesbrock half-sided modular inclusions make null translations the
  modular flow of null cuts. Discrete shadow worth chipping at: null transport
  on the carrier = modular flow for (Krein structure + cut), and
  physical-sector positivity = a discrete ANEC ("positivity of the mass form =
  relative entropy positivity across a null cut"). Every ingredient is finite;
  if even the shadow survives, positivity, entropy (sec on horizons), and
  causality become one statement.

## 4. The action level: one trace, three couplings (+ gravity boundary term)

Move 1 proved "unification is decomposition" at the equation-of-motion level. The
spectral-action reading extends it to the action level: on a finite complex,
`Tr f(D^2)` decomposes through the Weitzenbock identity into
`Tr Q_A` (cosmological/area term), `Tr Q_C` (Yang-Mills), `Tr Q_T` (Higgs
potential), `Tr E` (gravity, teleparallel).

HONESTY GUARD (why there is deliberately NO Lean theorem here yet): on a FIXED
finite complex this is linearity of the trace - a hollow-telescoping trap. The
genuine content is asymptotic: which test functions `f` separate the slots under
complex refinement (the discrete heat-coefficient hierarchy), and whether the
coefficients match Chamseddine-Connes. That is a continuum-limit program, labeled
as such. Literature anchors to ingest: Chamseddine-Connes spectral action; van den
Dungen / van Suijlekom Krein spectral triples; Bizi-Brouder-Besnard Lorentzian NCG.

NEW CONJECTURE (finite, checkable, non-hollow): teleparallel gravity's
Einstein-Hilbert = torsion-scalar + boundary-term split should discretize as: on a
CLOSED complex (no boundary), `Tr E` is expressible purely in quadratic torsion
contractions (the `2E = C(T) + C(S)` decomposition of the G-TELE thread); on a
complex with boundary, the difference telescopes to the boundary - a discrete
Gibbons-Hawking term. Continuum anchors for the E-slot-sources-mass claim
(per `Sources/Ontology_extensions.md` sec 1, to lit-verify on ingest): the TEGR
boundary term is the one in Witten's positive-energy proof; Nester's
quadratic-spinor positive-energy method; Maluf's teleparallel ADM energy as a
surface integral of torsion - i.e. the continuum already computes MASS as a
boundary torsion integral, which is exactly the E-slot's job description. Checkable on the Z2 two-torus witness once the torsion
contraction identity lands. If true, the E-slot gives BOTH bulk gravity and its
boundary term from one soldering-gradient - and the boundary term is where
holography/entropy would enter the program.

## 5. The checkerboard bridge: two in-repo programs are one (STRATEGY, near-term)

The repo already contains a Feynman-checkerboard formalization program (corner
conventions, luminal WP, `compositeMassSq_eq_sin_half`). The carrier program IS its
algebraization:

| checkerboard | carrier |
|---|---|
| null zigzag segment | null edge with `c(alpha_e) nabla_e` |
| corner (turn) | `Gamma phi` insertion |
| corner weight `i eps m` | turn amplitude `phi` (Q_T = phi^2) |
| zigzag dispersion | aperture form Q_A |
| checkerboard transfer matrix | edge transport `nabla` |
| path sum over zigzags | expansion of `D^n` in edge words |

Concrete kernel target (A/T lane, plausibly this run): on the 1+1 two-edge carrier,
identify the corner-counting expansion of the carrier square/transfer object with
the checkerboard corner generating function; the landed
`compositeMassSq_eq_sin_half` (A=T bridge) is the aperture face of the same
identity. Payoff: "mass = amplitude to turn" stops being an analogy between two
programs and becomes one shared theorem family - and the checkerboard's KNOWN
continuum limit (1+1 Dirac propagator) becomes the carrier program's first
continuum benchmark. This is the cheapest continuum story we own.

## 6. Confinement as closure-mass density (bridge to the YM lane)

The kernel-checked YM area law (Theorem 2, lattice) and the closure slot `Q_C`
measure the same object - plaquette flux - in two regimes: statistically
(Wilson-loop expectation decays with spanned area) vs algebraically
(per-configuration curvature obstruction). Reframe: **string tension = closure-mass
density per unit null area**; confinement = "closure mass grows without bound with
separation". The standing `<Q_C> >= 0` crux is exactly the interface statement
between the two regimes. CONSISTENCY-CHECK DIRECTION: the exact Z2 two-torus `Q_C`
theorem (Codex thread, call-03-ratified) should exhibit, in one finite model, both
the algebraic `Q_C` value and the transfer-gap quantity `tanh beta` that the landed
`QCLeading` scalar layer normalizes - one model, both readings, no measure claims.

## 7. Generations and textures (SPECULATIVE, kept honest)

With the checkerboard bridge, "generation structure = covering/cycle structure of
the turn graph" becomes testable in the smallest possible arena: build a finite
turn graph whose `phi^dagger phi` has two nondegenerate eigenvalues ("two
generations"), and ask which graph data the ratio computes. Destri-de Vega
generalized checkerboards are the higher-dimensional version. No claims; first toy
first.

The sqrt-mass observation (from `Sources/Ontology_extensions.md` sec 5; genuinely
native to this framework): massive spinor-helicity pairs scale as sqrt(M), so the
variables in which the empirical Koide relation is simplest (sqrt(m_e), sqrt(m_mu),
sqrt(m_tau)) are the NATIVE variables of the aperture slot; and Foot's observation
makes Koide literally an ANGLE statement - Q = 2/3 iff the sqrt-mass vector makes
a 45-degree angle with the democratic vector (1,1,1). In our language that is a
Gram/aperture-form statement about three composite states. FINITE IDENTITY target
(cheap, zero physics risk): formalize `koide_iff_angle` - the equivalence between
the Koide combination and the angle condition - as pure finite linear algebra,
with the physics reading kept in prose. Whether any Q5 mechanism then FORCES the
angle is the real (open, dangerous) question; the identity itself is safe and
makes the discussion precise.

## 8. What to formalize next (ranked, with owners)

1. **CRACK 3 quotient ladder rungs 1-2** (radical of the restricted form; gauge
   image in the radical) - Claude + Aristotle strategy ratification first. The
   prize.
2. **Chiral witness** (`Gamma = diag(1,1,-1)`, `ind = 1`: forced massless mode
   coexisting with certified massive modes) - Claude, cheap, completes the
   index-protection exhibit. Pairs with the kappa=2 witness as the two poles.
3. **M4 glue witness** (all 8 Move-1 hypotheses + three slots nonzero) - OPEN,
   Codex lane (per handoff review); unchanged by today's positivity witness (the
   two witnesses are necessarily different models - glue needs invertible
   transports, positivity needs a flat sector).
4. **Z2 two-torus exact `Q_C`** - Codex thread (call-03 priority), feeds sec 6.
5. **Torsion contraction `2E = C(T) + C(S)`** - G-TELE, needs Fable/next-call
   ratification of "may this be called torsion"; then the closed-complex `Tr E`
   conjecture of sec 4 becomes checkable.
6. **Checkerboard corner/turn identification** (sec 5) - Claude A/T lane.
7. **Refinement/heat asymptotics frame** for the spectral action - literature
   round + strategy job before any Lean.
8. **`koide_iff_angle` finite identity** (sec 7) - cheap, self-contained,
   makes the sqrt-mass discussion exact with no physics claim.
9. **Dirac charge quantization on the complex** (from
   `Sources/Ontology_extensions.md` sec 6): integrality of the plaquette flux
   cocycle (DeGrand-Toussaint decomposition), i.e. an `H^2(K, Z) -> H^2(K, U(1))`
   integrality statement - eminently formalizable on the existing torus complex,
   and it adds a fourth integer (the flux class) to the index-trinity picture.

## 9. One-paragraph status for outside readers

As of tonight the program has, kernel-checked and axiom-guarded: the discrete
Weitzenbock decomposition of the carrier square into aperture/closure/turn/soldering
slots (Move 1); the first slot identification (Q_A = invariant aperture mass,
Move 2 start); a certified Pontryagin (kappa=2) fundamental symmetry with STRICT
Krein-positive mass form on its flat chiral sector (today) - so "mass = relational
obstruction to null transport" now has a non-vacuous indefinite-geometry
realization; and the finite McKean-Singer index protection theorems (today) - so
"masslessness = topology of the complex" is now a theorem family, not a slogan. The
two open cruxes are off-flat positivity (rerouted through the Gupta-Bleuler
quotient, sec 3) and beyond-leading closure positivity (sec 6). Everything else in
this note is labeled strategy/conjecture/speculative and priced accordingly.
