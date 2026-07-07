# Null-edge program: self-contained briefing for a parallel deep-work session

REV 2 (2026-07-07, post round-1 harvest). This revision adds section 5 (the
adjudicated results of the first parallel round, Q01-Q05) and updates the OPEN
list and standing cautions accordingly. It remains fully self-contained and is
backward-compatible with the remaining round-1 questions (Q06-Q10).

You are being consulted as a theorist of the highest caliber on a research program
in mathematical physics. This briefing is self-contained: you have NO access to our
repository, and everything you need is here. Read it fully before answering the
question appended below it. Work at full ambition; we would rather have a deep
partial answer to the real question than a complete answer to a weakened one.

## 1. The program in one paragraph

We are building, with machine-checked mathematics (Lean 4 + Mathlib; every claim
below marked KERNEL has been verified by the Lean proof kernel and axiom-audited),
a finite, combinatorial account of how ALL mass arises from massless, lightlike
(null) structure - and beyond mass, of how gravity, gauge fields, the Higgs sector,
and chiral matter can be read off ONE finite operator on a decorated 2-complex of
null edges. The physical thesis: matter is trapped, mutually disagreeing light;
mass is the obstruction to coherent null transport; whatever the index of the
complex protects stays massless. The methodological thesis: every step is either a
kernel-checked finite theorem or is explicitly labeled as interpretation, strategy,
or conjecture. We never smuggle positivity, never hide hypotheses, and treat "true
but vacuous" as a failure mode as serious as falsehood. A first parallel round of
five deep consultations has been adjudicated and integrated (section 5); treat its
verdicts as standing inputs.

## 2. Claim discipline (grade YOUR claims the same way)

- T: theorem with a source-verified classical proof. T|H: theorem conditional on
  displayed hypotheses. M: program-internal, machine-verified (our Lean kernel).
- C: pre-registered conjecture with a gate and a kill-condition.
- Labels: KERNEL (Lean-verified by us), MEMO (round-1 result at
  working-mathematician rigor, executor-spot-verified, kernel transcription
  pending), FINITE IDENTITY (kernel-checked finite statement; physics reading is
  prose), STRATEGY, CONJECTURE, SPECULATIVE.
- In your answers: state verdicts first; flag anything you believe is FALSE loudly
  and first; separate what you can prove from what you believe; give
  counterexamples with explicit small dimensions when you doubt a claim. If you
  contradict a section-5 verdict, SAY SO EXPLICITLY and argue it - finding an
  error there is a first-class success; silently diverging from it is not.

## 3. Conventions

Metric signature (+,-,-,-). Weyl spinors psi : C^2; the bispinor of a null edge is
the rank-one Hermitian matrix psi psi^dagger; soldering identifies future null
momenta with rank-one positive Hermitian 2x2 matrices; det of a summed bispinor is
mass squared. All formulas ASCII. "Krein space" = indefinite inner product space
<.,.>_J = <., J .> with J a fundamental symmetry (self-adjoint involution);
"Pontryagin index kappa" = dimension of the negative sector. Terminology guard:
the Krein fundamental symmetry J (linear, metric operator) and an NCG-style real
structure J_R (antilinear, charge conjugation) are DIFFERENT objects - never let
the notations collide.

## 4. What is KERNEL-checked (the machine-verified floor)

Layer K (kinematics; published-draft P1). For psi_1..psi_n : C^2 and
P = sum_i psi_i psi_i^dagger:

  det P = sum_{i<j} | psi_i wedge psi_j |^2,   psi_i wedge psi_j = the 2x2 bracket.

Mass squared of a bundle of null momenta = total pairwise directional
disagreement; zero iff all null directions projectively collinear. Orbit-invariant
form: mass is det P (decomposition-independent); the spread expression is its
value in a decomposition gauge; for the two-edge split the gauge freedom is the
massive little group SU(2). Celestial form: m^2 = (E^2 - |C|^2)/4. 1+1D dynamical
bridge: the chirality-flip amplitude IS the wedge (mass = rate of chirality
exchange). Substrate layer: lattice Ginsparg-Wilson chirality release + a
chiral-index calculus with an index-forced zero-mode theorem, at the
free/regulator level.

Layer D (the carrier; this month). On a finite 2-complex with edge set E, the
CARRIER

  D = sum_{e in E} c(alpha_e) nabla_e + Gamma phi

with alpha_e null dual covectors (c(alpha_e)^2 = 0, KERNEL), nabla_e edge
transports, Gamma the chirality involution, phi the turn/potential. KERNEL:

- Null nilpotency + "a lone edge is massless": mass is relational.
- Discrete Weitzenboeck decomposition: 4 D^2 = Q_A + Q_C + 4 Q_T
  (covariantly-constant soldering), and 4 (D^# D) = Q_A^# + Q_C^# + 4 Q_T + 4 E_#
  with varying soldering (# an involutive antiautomorphism). Q_A = aperture/Gram
  block; Q_C = closure/curvature block (torus model: commutator of transports =
  plaquette curvature, KERNEL); Q_T = phi^2 turn block; E = soldering-gradient
  block. Unification here means DECOMPOSITION: one operator, four channels.
- Move 2: Q_A = Q(sum_e alpha_e) - the aperture block IS the invariant mass of
  the total null momentum (ties Layer D to Layer K exactly).
- Flat-sector positivity: on {psi : nabla_e psi = 0, Gamma psi = psi},
  <D psi, Gamma D psi> = <phi psi, phi psi> >= 0.
- kappa = 2 Pontryagin witness: explicit C^4 model, Gamma = sigma_z tensor I a
  CERTIFIED fundamental symmetry (self-adjoint involution, inertia (2,2)), with
  the Krein mass form STRICTLY positive on the flat chiral state and nonnegative
  on the full 2-dim flat chiral plane. Caveat (round-1 Finding B): this witness
  has BALANCED inertia p = q, so its physical STATE sector under any first-class
  quotient is zero-dimensional - it certifies the mass-form statements, not a
  state sector; state-sector work runs on unbalanced complexes.
- Index protection (finite McKean-Singer family): for Weyl block form on
  M_+ oplus M_-, ind = dim ker D_+ - dim ker D_- equals dim M_+ - dim M_- for
  rank-symmetric blocks; rank symmetry PROVED automatic for Hilbert- and
  Krein-self-adjoint carriers; hence ind is invariant under EVERY potential and
  transport. Exhibits: balanced (2,2) -> ind 0, fully gappable; unbalanced (2,1)
  -> ind 1, a forced massless chiral mode for every dynamics.
- Color constraint: the commutant of the color action on the triplet is the
  scalars - only color-blind scalar mass terms are color-exact.
- Adjacent kernel assets: strong-coupling Wilson-loop area law (exact finite
  combinatorics); octonion algebra in an XOR-labeled Fano basis with a
  convention bridge; Ginsparg-Wilson/overlap chirality; a Feynman checkerboard
  program whose 1+1 continuum limit is classically the massive Dirac propagator.

## 5. Round-1 adjudicated results (grade: MEMO unless noted; treat as inputs)

Five parallel consultations (positivity, gravity slot, no-go audit, SM
selection, generations) returned; we verified their load-bearing computations
by hand and integrated them. The standing verdicts:

**5a. Positivity (the former prize crux) - SOLVED to its exact boundary.**
Two-theorem separation: STATE positivity ([psi,psi] > 0 on a quotient) is NOT
an operator-theory or Weitzenboeck statement; it is Witt geometry of the
constraint span. THEOREM A: for constraints with covector span Gamma' of
signature (a,b,r) in inertia (p,q), the induced form on V'/N (V' = ker
constraints, N = radical) is positive definite iff b + r = q; it is a CANONICAL
gauge quotient iff Gamma' is maximal isotropic (a = b = 0, r = q = kappa); D
descends self-adjointly iff the finite Ward identity D Gamma' <= Gamma' holds.
DEFINITIZABILITY IS VACUOUS in finite dimensions (minimal-polynomial argument)
- the deciding invariant is the sign characteristic (Gohberg-Lancaster-Rodman).
Counterexample ladder O1-O5 marks every wall; O2 (2x2, J-nonnegative,
Krein-self-adjoint, no nonvacuous sector) shows no spectral hypothesis can
help. HEADLINE (kernel target): dim(V'/N) = p - q = ind(D) - the chiral index
COUNTS the physical states that survive gauge. Per-constraint-plane trichotomy
(2x2, decidable): oscillatory (two null rays - retardedness = the orientation
choosing one), scalar, Jordan, real-split; REAL-SPLIT PLANES ARE A KILL (a
genuine ghost; no first-class positive sector exists). The minimal nonvacuous
testbed: the 2-torus as a SPATIAL slice of 2+1 (one polarization per mode);
the literal 2-torus quotient is vacuous, correctly (2D Maxwell has no photon).
Independently converged with a separate strategy engine's audit of the same
question (metric-vs-mass-form separation, constraint-kernel selector).

**5b. Gravity slot - conjecture killed, better survivor adopted.** Our
"Tr E = pure quadratic torsion on closed complexes" conjecture is DEAD: the
P-probe (closed torus, alpha_y constant, alpha_x varying in x) has torsion
identically zero yet strictly positive drift content; also plain Tr E is
convention-vacuous. LEMMA 0 (kernel-ready): Tr f(D^#D) is exactly invariant
under vertex-local Krein-unitary redecorations, but the individual BLOCK traces
are NOT separately invariant - "the gravity action = the E-slot trace" is
ill-posed; the well-posed object is the gradient dependence of the invariant
total trace. Survivors: corrected telescoping (net-zero-shift density = Phi +
divergence, Phi quadratic in torsion contractions + pair-mass drifts + Leibniz
remainders; boundary complexes telescope to an oriented flux = the discrete
Gibbons-Hawking candidate; polyhedral Gauss-Bonnet as the classical
cross-check); the TEGR coefficient ratios become a finite DERIVATION
(invariance + gradient counting; exact telescoping iff (1/4 : 1/2 : -1) in the
shifted-Leibniz convention, with a pre-registered "discrete Lorentz anomaly"
branch whose escape is Ginsparg-Wilson-shaped). Emergent metric = pair-mass
Gram matrix (a generalized DOUBLE-NULL lattice; closest prior art: null-strut
Regge calculus; discrete teleparallelism EXISTS - Pereira-Vargas, Zubkov - the
genuine gap is only the Dirac-square/null-co-frame route). The drift/S-sector
is the discrete residue of would-be diffeomorphisms with a pre-registered
trichotomy (decouple/gap/propagate) under refinement.

**5c. No-go audit - nothing fatal; all defenses land on one square.** Program
charter adopted (claim ladder U0-U5). Amendments: (1) NO coupling-unification
claims ever (those need NCG's first-order condition + spectral action, which a
holonomy-based gauge mechanism does not satisfy); (2) gravity claimed only as
a gapless spin-2 excitation of a constrained quotient with NO Lorentz-covariant
conserved stress tensor - emergent redundancy is an OBLIGATION (Weinberg-Witten
+ Marolf's kinematic-nonlocality theorem), with the Jacobson-shape fallback;
(3) chirality claimed only through Ginsparg-Wilson DESCENT to the physical
sector - retardedness deletes lattice HERMITICITY, not chirality (a third
doubling-escape mechanism, principled only because Krein J-self-adjointness
replaces Hermiticity), and provably CANNOT delete doubling partners (the
retarded symbol determinant's zero set is null-homologous on the Brillouin
torus; a two-edge d = 2 model has LINES of gapless modes). The dispersion
polynomial det sigma(k) = sum_{e<f} z_e(k) z_f(k) |psi_e wedge psi_f|^2 is the
mass identity with winding coefficients; near k = 0 it gives the emergent
inverse metric as the wedge-weighted soldering Gram. Coleman-Mandula: closes
unification-by-symmetry, not unification-by-decomposition; its bite is on the
emergent S-matrix (analyticity <- positivity crux) and yields the derivation
target "Poincare x internal factorization as OUTPUT". The Gamma-grading is
worldline (Witten-index) SUSY - correctly spent on index protection, not a
spacetime-SUSY escape.

**5d. SM selection - a no-go and a conditional selection.** PROOF-SHAPED
NO-GO: the naked triple (ind, kappa, inertia) plus abstract commutant CANNOT
fix hypercharge (B-L twist counterexample: same complex, same integers, same
abstract commutant, different charges). Repaired target data: equivariant index
in R(G) + graded kappa + channel inertia + commutant WITH action + TURN CENSUS
(the census of gauge-exact bare and Higgs-mediated mass decorations; our color
theorem is its first kernel entry), all KO-decorated (complex irreps: Z-valued
protection; pseudoreal: mod-2 - Witten anomaly; real: none). Base minimality is
SM-blind (a rose with V = 1, E = 2, F = 1 suffices); all selection lives in the
fiber. Under the INTERNAL NULL-STRAND PRINCIPLE (fiber = exterior algebra
Lambda(C^p + C^q), internal chirality = (-1)^F, charges = occupation
functionals), four finite axioms force n = p + q = 5 with degeneracy space
EXACTLY {(3,2) = one SM generation, (4,1) competitor}; one infrared bit
("electromagnetism exists") selects (3,2); hypercharge Y = -n_c/3 + n_w/2 and
the Z_6 charge lattice are DERIVED (linearity <- gauge-exactness of the unique
bare Majorana; tracelessness <- Krein closure = unimodularity). Anomaly
cancellation of a generation is the one-line identity
str_{Lambda C^n}(g) = det(1 - g), vanishing to order n - an IDENTITY for
n >= 4, not a miracle. Chevalley dictionary: C tensor O with a fixed unit IS
Lambda(C^3) (our XOR-Fano octonion basis is literally the strand-monomial
labeling); C tensor H tensor O = Lambda(C^5) = the NCG per-generation 32;
Furey and Connes are one object in two coordinate systems, and the
order-condition check on the vacuum-Majorana turn is a finite arbiter of the
live first-order vs second-order NCG dispute.

**5e. Generations - three is a theorem only via triality.** No local or
topological mechanism can force 3 (covers/homology realize every k; and
Out(g+g+g) contains Z/3 for ANY g, so a simplicity clause is mandatory). The
unique algebraic cap is D4 TRIALITY (the only order-3 outer automorphism among
simple Lie algebras; shadows: rank 3 of the Albert algebra, terminality of O).
Winning mechanism: TRIALITY-AS-MONODROMY - three families = ONE representation
transported around a cycle with order-3 OUTER holonomy; the count is an index
(rigid), the multiplicity menu is EXACTLY {1, 3} (a world with exactly 2
identical chiral families kills it); charge identity from Fix(tau) = G2
containing color; electroweak CANNOT sit inside G2 beside color, which FORCES
the V_H tensor V_O factorization (deriving the Dixon/Furey layout, and
dovetailing with 5d's Lambda(C^3) tensor Lambda(C^2)). Standing rail: a
generation symmetry must lie in the commutant of the charge algebra and be
OUTER relative to the gauge group - inner candidates are gauge-vacuous (this
kills the "three Fano lines through a point" mechanism: its 3-cycle is inside
color SU(3)); naive E8-multiplet packaging is dead by Distler-Garibaldi, whose
index translation (self-conjugate charge-module => per-sector ind = 0) is a
cheap kernel lemma. Mass/mixing in the mechanism's coordinates: turn operators
are circulants (masses = DFT values; hierarchy = near-cancellation at a
character - a parametrization, not an explanation; Koide becomes the single
amplitude condition beta = sqrt(2) alpha, neither prediction nor kill);
CKM-small vs PMNS-large is Z/3 representation theory (equivariant Dirac
channels commute; the conjugation-twisted Sym^2 channel is forced maximally
rotated: theta_23 = 45 degrees, theta_13 = 0 at leading order, theta_12 = 0 as
the registered tension; the mu-tau-reflection variant pins delta_CP = +/- pi/2,
near-term falsifiable). Registered danger: the chirality-solder check - if the
physical grading is ever forced to couple to internal chirality, the per-sector
index degrades 3 -> 1.

**5f. Continuum limit (batch 2).** The benchmark is the 1+1 checkerboard;
convergence topology = strong operator on powers (norm version FALSE, k = pi
witness); the free case needs no Chernoff (Fourier fibers + telescoping);
Chernoff-on-Krein requires uniform power-boundedness = the positivity crux
re-imported. Corrections adopted: the Krein structure does NOT kill doubling -
retardedness alone does, and retardedness IS the hidden Wilson term (exact
identity: the Hermitian part of the one-step difference operator is
(1 - cos theta cos k)/eps); the transfer satisfies an EXACT Ginsparg-Wilson
relation with R = 1/2 whose grading is chirality composed with spatial
reflection = EDGE-ORIENTATION REVERSAL (the same operation underlying the
OS-reflection selector and the J_R candidate - one operation, three roles).
Axiomatics: Krein-Wightman with the Hilbert-Space-Structure Condition +
subsidiary-condition quotient; new named finite gates: UM (uniform majorant =
the HSSC shadow; refinement embeddings intertwine J, preserve (V', N), keep
two-sided quotient-norm bounds), COVARIANCE (Jones/Thompson-group warning),
HS-implementability (a finite anomaly diagnostic); rule: quotient-then-limit.
The refinement category is NOT null-only (Layer K forces coarse edges
timelike: "coarse-graining generates Q_A" is an available finite RG theorem);
new null directions enter only at vertices via turns.

**5g. Mass values (batch 2).** Symmetry-breaking chains can NEVER fix
eigenvalue ratios (Schur); ratios require rigidity (equivariance /
soldering / holonomy quantization / index - the R1-R4 catalogue, with a
no-ratio-without-rigidity theorem-shape). First computable number: the
dihedral circulant cross-ratio (= 2 on the 4-cycle, golden-ratio + 1 on the
pentagon). The centerpiece: the EQUIPARTITION SUM RULE - for a uniform turn
d plus zero-diagonal hops H with turn power = hop power (the T-SOLDER
hypothesis, "the turn is made of its incident edges"), tr M^2 = (2/V)(tr M)^2
exactly, so with the LEG-LEVEL identification m = lambda^2 (which the data
select decisively over the composite-level one), Q = 2/V: Koide's 2/3 =
(45-degree equipartition) x (V = 3). Electron lightness = phase proximity to
the massless boundary (the lepton "hierarchy" in sqrt-m is 59:14:1 - not
exponential); exponential hierarchy machinery is for QUARKS (path-overlap
with per-edge cos(theta/2) - the cosine leg of the Lagrange identity
|<u,v>|^2 + |u wedge v|^2 = |u|^2|v|^2 whose sine leg is the kernel-checked
mass). The load-bearing open item: derive or refute the T-SOLDER coefficient
kappa = 1 from carrier axioms (kappa != 1 kills the gate). Pole-mass 1e-5
precision is disclaimed (IR noise; a UV framework owes permille).

**5h. Second quantization (batch 2).** Adds NO new crux. Fock = exterior
algebra (finite); the Fock functor lifts J and COMMUTES with the
Gupta-Bleuler quotient (the radical of the lifted form is the ideal of the
one-particle radical - no positivity needed); finite Kugo-Ojima is a four-line
theorem (quartet completeness is FREE: the radical of the form on ker Q is
exactly im Q); physical unitarity holds with exactly three hypotheses
(J-unitarity, constraint preservation, quotient positivity = 5a). There is no
finite S-matrix with t -> infinity: the honest object is boundary-to-boundary
evolution. Crossing signs are the planar shadow of the exterior functor, NOT
the origin of statistics (registered conjecture: positivity selects Lambda
over Sym - the finite Pauli skeleton). Interactions are CANONICAL:
dGamma(D)^2 - dGamma(D^2) = 2 dGamma_2(Lambda^2 D) - the pair kernel is the
WEDGE of the carrier (NJL from turn^2, Thirring from transport^2, ratios
fixed by Gram data, no new constants); gauge self-coupling is NOT generated
(add the plaquette or induce by the fermion determinant). One RG step = the
Schur complement; {Krein-self-adjoint, chirality-odd} is RG-stable but
per-edge null NILPOTENCY IS NOT: mass terms are what null microstructure
Schur-complements to - the program's thesis as an RG fact, converging with
5f's Layer-K blocking statement. Infinity enters at exactly two doors:
dynamical bosons, and the refinement-uniform Hilbert-Schmidt bound.

**Cross-memo convergences:** (i) 5d and 5e independently demand the same
prerequisite - the EQUIVARIANT (isotypic, R(G)-valued) upgrade of the kernel
McKean-Singer theorem; without it "three families with identical charges" is
not yet a statement in our calculus. (ii) 5a's quotient theorem, 5c's no-go
defenses, the unitarity payment of the doubling escape, 5f's Chernoff
power-boundedness, and 5h's unitarity hypothesis (H3) ALL land on the SAME
object: V'/N and its constraint algebra. (iii) 5d + 5e compose to the full
matter-sector shape: strand pentad tensor triality monodromy = 3 x one SM
generation (CONJECTURE, kills listed). (iv) 5f and 5h derive the SAME RG
fact from opposite directions (blocking generates Q_A; Schur breaks
nilpotency): mass is what trapped light looks like from far away, as a
finite theorem target. (v) Edge-orientation reversal now plays three roles
(GW grading, OS reflection, J_R ingredient) - treat it as a first-class
structure in any answer that touches gradings or reflections.

## 6. What is OPEN now (post round 1 - do not assume any of these)

1. KERNEL TRANSCRIPTION of 5a: the finite Gupta-Bleuler ladder (perp-signature,
   isotropic-quotient positivity, descent, dim = ind) and the first nonvacuous
   physical-sector witness (2+1 spatial torus). Until then, spectral language
   stays forbidden.
2. The GLUE witness (all Move-1 hypotheses + three slots simultaneously
   nonzero): mathematics hand-verified, kernel transcription pending. Charter
   U1 makes it the gate for the whole no-go defense.
3. Model-by-model (H*) checks: nullity + rank of the Gauss covectors, the
   finite Ward identity, p > q nonvacuity, and the real-split kill-scan.
4. Beyond-leading closure positivity - possibly SUPERSEDED in the unitary
   regime if the factorization Q_C = sum_p (1 - U_p)^# (1 - U_p) holds in our
   normalization (check in progress); if it fails, the cross-term is the sharp
   open problem.
5. The corrected telescoping ladder (5b) and the coefficient M-ladder; the
   S-sector trichotomy under refinement.
6. The continuum limit: refinement scheme, Krein analog of reflection
   positivity, GW descent of chirality to the quotient (the load-bearing
   evasion), doubler relocation vs the quotient (retarded zeros must not be
   dragged back on-shell).
7. Mass VALUES: still free decorations; the triality mechanism supplies
   coordinates (circulant DFT), not numbers.
8. The C8 seam (5d): coherence of the internal top-form pairing with the
   Layer-D # slot - flagged as the most likely place the strand construction
   bites; and the (4,1) competitor: find a kernel constraint deleting it (would
   remove the one infrared bit from the selection).
9. Three generations: everything in 5e beyond the finite toys is conjecture;
   the equivariant index upgrade (L0) gates it.

## 7. Standing cautions (updated)

- Krein self-adjointness is an algebraic audit; it gives neither positivity nor
  real spectrum nor a Hilbert space. STATE positivity and MASS-FORM positivity
  are different theorems with different hypotheses (5a); never conflate.
- Individual Weitzenboeck block traces are NOT redecoration-invariant (5b);
  only the total is. No "the X action = the X-slot trace" phrasing.
- No coupling-unification claims, ever (5c). Representation-content claims only
  conditional on the named strand ansatz (5d), with its kills displayed.
- Generation symmetries must be gauge-OUTER (5e); inner candidates are vacuous.
- Retardedness = orientation/regulator, not a no-doubling or positivity
  mechanism (5a, 5c). GW descent carries the chirality claim.
- Do not assume a bare graph supplies a tetrad: causal order gives the
  conformal class for free (Malament), decorations owe exactly the scale.
- Octonions are nonassociative: compose left-multiplication operators, never
  reassociate silently. J (Krein) vs J_R (real structure): never collide.
- Spectral claims (m^2 = inf spec ...) remain FORBIDDEN until open item 1
  closes; state forms, not spectra.
- "True but vacuous" is a failure mode: balanced-inertia models host no
  physical state sector (Finding B); always check p > q when a state-sector
  claim is at stake.

## 8. What we want from you in this window

The single question following this briefing. Aim as high as the question does.
Structure: verdict first, then the argument, then (where applicable) a
formalization ladder of exact finite statements we could hand to the Lean layer
(statement-first: precise hypotheses, no analysis smuggled into finite claims),
then literature anchors (exact author/title/year; arXiv identifiers when you
know them; say "unverified" when unsure). Build on section 5 rather than
re-deriving it; if you believe a section-5 verdict is WRONG, flag that loudly
and first - overturning an adjudicated verdict with a proof or counterexample
is the most valuable single thing you can do. If you believe the question is
malformed or its presupposition false, demolishing it precisely is a fully
successful answer.
