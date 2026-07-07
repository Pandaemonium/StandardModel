# Null-edge program: self-contained briefing for a parallel deep-work session

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
but vacuous" as a failure mode as serious as falsehood.

## 2. Claim discipline (grade YOUR claims the same way)

- T: theorem with a source-verified classical proof. T|H: theorem conditional on
  displayed hypotheses. M: program-internal, machine-verified (our Lean kernel).
- C: pre-registered conjecture with a gate and a kill-condition.
- Labels: KERNEL (Lean-verified by us), FINITE IDENTITY (kernel-checked finite
  statement; physics reading is prose), STRATEGY, CONJECTURE, SPECULATIVE.
- In your answers: state verdicts first; flag anything you believe is FALSE loudly
  and first; separate what you can prove from what you believe; give
  counterexamples with explicit small dimensions when you doubt a claim.

## 3. Conventions

Metric signature (+,-,-,-). Weyl spinors psi : C^2; the bispinor of a null edge is
the rank-one Hermitian matrix psi psi^dagger; soldering identifies future null
momenta with rank-one positive Hermitian 2x2 matrices; det of a summed bispinor is
mass squared. All formulas ASCII. "Krein space" = indefinite inner product space
<.,.>_J = <., J .> with J a fundamental symmetry (self-adjoint involution);
"Pontryagin index kappa" = dimension of the negative sector.

## 4. What is already KERNEL-checked (the floor you build on)

Layer K (kinematics; published-draft P1). For psi_1..psi_n : C^2 and
P = sum_i psi_i psi_i^dagger:

  det P = sum_{i<j} | psi_i wedge psi_j |^2,   psi_i wedge psi_j = the 2x2 bracket.

Mass squared of a bundle of null momenta = total pairwise directional
disagreement; zero iff all null directions projectively collinear. Orbit-invariant
form: mass is det P (decomposition-independent); the spread expression is its
value in a decomposition gauge; for the two-edge split the gauge freedom is the
massive little group SU(2). Celestial form: m^2 = (E^2 - |C|^2)/4 (energy
monopole vs momentum dipole deficit). 1+1D dynamical bridge: the chirality-flip
amplitude IS the wedge (mass = rate of chirality exchange), kernel-checked.
Substrate layer: lattice Ginsparg-Wilson chirality release + a chiral-index
calculus with an index-forced zero-mode theorem, kernel-checked at the
free/regulator level.

Layer D (the carrier; this month). On a finite 2-complex with edge set E, define
the CARRIER

  D = sum_{e in E} c(alpha_e) nabla_e + Gamma phi

where alpha_e are dual covectors soldered edgewise (c = Clifford multiplication
in a quadratic space where every alpha_e is NULL: c(alpha_e)^2 = 0, KERNEL),
nabla_e are edge transports, Gamma is the chirality involution, phi the
turn/potential operator. KERNEL results:

- Null nilpotency c(alpha)^2 = 0 and "a lone edge is massless" (single-edge
  diagonal vanishes): mass is relational.
- Discrete Weitzenboeck/Lichnerowicz decomposition (the "Move 1" master):
  4 D^2 = Q_A + Q_C + 4 Q_T in the covariantly-constant-soldering regime, and
  with varying soldering the remainder E appears:
  4 (D^# D) = Q_A^# + Q_C^# + 4 Q_T + 4 E_#
  where # is an involutive antiautomorphism (the Krein transpose slot).
  Q_A = symmetrized Gram/aperture block; Q_C = commutator/curvature (closure)
  block, whose torus model satisfies "commutator of transports = plaquette
  curvature" (KERNEL); Q_T = phi^2 chirality-dressed (turn) block; E = the
  soldering-gradient block (the gravity slot; teleparallel-torsion shaped).
  Unification here means DECOMPOSITION: one operator, four physical channels.
- Move 2 first identification (KERNEL): Q_A = Q(sum_e alpha_e) - the aperture
  block IS the invariant mass of the total null momentum, tying Layer D to
  Layer K exactly.
- Flat-sector positivity (KERNEL): on {psi : nabla_e psi = 0 all e,
  Gamma psi = psi}, <D psi, Gamma D psi> = <phi psi, phi psi> >= 0.
- kappa = 2 Pontryagin witness (KERNEL, this week): an explicit C^4 model
  (Gamma = sigma_z tensor I) where Gamma is a CERTIFIED fundamental symmetry -
  self-adjoint involution, inertia (2,2) both eigenspaces exactly
  2-dimensional - and the Krein mass form on the flat chiral sector is STRICTLY
  positive (= |c|^2 on a distinguished state, nonnegative on the full
  2-dimensional flat chiral plane). So the indefinite-geometry reading is
  non-vacuous: not the kappa = 0 Hilbert case, not a definite form.
- Index protection, finite McKean-Singer family (KERNEL, this week): for the
  Weyl block form D = [[0, D_-],[D_+, 0]] on M_+ oplus M_-, the chiral index
  ind = dim ker D_+ - dim ker D_- equals dim M_+ - dim M_- whenever the blocks
  are rank-symmetric; rank symmetry is PROVED automatic for Hilbert-self-adjoint
  (D_- = D_+^dagger) and Krein-self-adjoint (D_- = J D_+^dagger J') carriers.
  Hence ind is invariant under EVERY choice of potential and transport.
  Exhibits (KERNEL): balanced (2,2) complex -> ind 0, fully gappable, strictly
  positive mass form (the witness above); unbalanced (2,1) complex -> ind 1,
  every carrier annihilates a nonzero chiral state (a forced massless mode).
  Slogan: mass explains what leaves the light cone; the index explains what
  must stay.
- Color constraint (KERNEL): the commutant of the color action on the triplet
  is the scalars, so only color-blind scalar mass terms are color-exact.
- Adjacent kernel assets in the same repository: a Wilson-loop area law for
  lattice gauge theory at strong coupling (Theorem-2 level, exact finite
  combinatorics); an octonion algebra formalization (XOR-labeled Fano basis)
  with a convention bridge; Ginsparg-Wilson/overlap chirality; a Feynman
  checkerboard program (corner conventions, luminal walks) whose 1+1 continuum
  limit is the massive Dirac propagator.

## 5. What is OPEN (the honest list - do not assume any of these)

1. PHYSICAL-SECTOR POSITIVITY (the prize crux): off the flat sector, on which
   physically-motivated subspace/quotient is the Krein mass form positive?
   Known (from our own adversarial review): invariant maximal nonnegative
   subspaces exist in finite Pontryagin spaces but can be DEGENERATE - existence
   is not a physical Hilbert sector. Current strategy: a finite Gupta-Bleuler
   construction - constraint kernel V', radical N = V' cap V'^perp_J, prove the
   induced form on V'/N positive definite, and prove gauge directions =
   exactly N.
2. The GLUE witness: one explicit model satisfying ALL Move-1 hypotheses with
   Q_A, Q_C, Q_T simultaneously nonzero (we have the mathematics by hand in
   M_4(C) with Pauli tensor factors; the kernel transcription is pending).
   Note: such a model necessarily has trivial flat sector (invertible
   transports), which is WHY the positivity witness is a different model.
3. Beyond-leading closure positivity: <Q_C> >= 0 in the gauge measure beyond
   strong-coupling leading order.
4. The continuum limit: refinement scheme, Lorentzian analog of reflection
   positivity, doubling control. Nothing kernel-checked beyond finite
   identities.
5. Mass VALUES: no mechanism for ratios/hierarchy is established; the turn
   amplitude phi is a free decoration so far.
6. Retardedness (forward/positive-frequency edge data, x_e(k) >= 0) is our
   candidate physical constraint; it rules out coefficient-zero doublers but is
   NOT by itself a no-doubling or positivity proof.

## 6. Standing cautions

- Krein self-adjointness is an algebraic Lorentzian audit; it does not by
  itself give positivity, real spectrum, stability, or a Hilbert space.
- Do not assume a bare graph supplies a tetrad/frame; decorations do.
- Octonions are nonassociative: compose left-multiplication operators, never
  reassociate silently.
- "Unification is decomposition, not identification": the four channels sit in
  ONE operator identity; nothing about coupling unification is claimed.
- Spectral claims (m^2 = inf spec ...) are FORBIDDEN language until the
  positivity crux is closed: state forms, not spectra.

## 7. What we want from you in this window

The single question following this briefing. Aim as high as the question does.
Structure: verdict first, then the argument, then (where applicable) a
formalization ladder of exact finite statements we could hand to the Lean layer
(statement-first: precise hypotheses, no analysis smuggled into finite claims),
then literature anchors (exact author/title/year; arXiv identifiers when you know
them; say "unverified" when unsure). If you believe the question is malformed or
its presupposition false, demolishing it precisely is a fully successful answer.
