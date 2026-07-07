# Q1. Solve the physical-sector positivity crux

This is the program's single most valuable open problem. Everything downstream
(spectral language, particle interpretation, any contact with unitarity) waits on
it.

## Setup

Finite Pontryagin space (V, <.,.>, J), J = Gamma the chirality (self-adjoint
involution, inertia (p,q), kappa = min(p,q) > 0). Carrier
D = sum_e c(alpha_e) nabla_e + Gamma phi, Krein-self-adjoint: D^# = J D^dagger J
= D. Kernel-checked floor: the Weitzenboeck decomposition of D^#D into
Q_A + Q_C + 4 Q_T + 4E; strict positivity of <D psi, J D psi> on the flat chiral
sector; the degenerate-maximal-subspace obstruction (invariant maximal nonnegative
subspaces exist but can be null-degenerate, so existence arguments are
insufficient).

Our proposed route (finite Gupta-Bleuler): choose a constraint subspace V'
(candidate: retarded/forward edge-transport data plus closure constraints), form
the radical N = V' cap V'^perp_J, and aim to prove (a) the induced form on V'/N is
positive DEFINITE, (b) the gauge-shift image equals exactly N, (c) kappa counts
what the quotient removes.

## The questions

1. THEOREM OR COUNTEREXAMPLE. In finite dimensions, for Krein-self-adjoint D on
   Pi_kappa, characterize exactly when such a (V', N) with positive-definite
   quotient EXISTS and when it is CANONICAL (natural in the data, not chosen).
   If extra hypotheses are unavoidable, identify the minimal one - candidates:
   definitizability of D (finite dim: when does a definitizing polynomial fail
   to exist?), nonnegativity of the form restricted to ker of constraints,
   sign-definiteness of D^#D on a spectral subspace, discrete positive-energy
   condition. Give the sharpest finite counterexample (explicit small matrices,
   dimensions, inertia) for each hypothesis you drop.
2. THE RIGHT V'. Is the correct finite analog of Gupta-Bleuler the kernel of
   explicit closure (Gauss) constraint operators, with retardedness playing the
   positive-frequency SPLIT role inside it? In finite dimensions there is no
   frequency integral: what plays "annihilation part of the constraint"? Be
   fully concrete: for the 2-torus gauge model with transports U_1, U_2 and
   plaquette curvature, write the constraint operators and compute V', N, V'/N.
3. WEITZENBOECK REDUCTION. Can positivity on V'/N be proven SLOT-WISE - the
   aperture block by Gram positivity, the turn block as phi^2, the closure block
   by its leading-order normalization, the E block by a torsion-square
   structure? State the exact slot-wise lemmas whose conjunction yields the
   theorem, each as a finite statement.
4. SPECTRAL CONSEQUENCE. Once (a)-(c) hold, precisely which spectral statement
   becomes legal? ("The induced operator on V'/N is self-adjoint for the induced
   inner product; m^2 = min of its spectrum on the ... sector.") State it so
   that it is a theorem-shape, not an aspiration, and say what remains to check.
5. LITERATURE. Krein-space operator theory that already solves pieces of this:
   Langer's definitizable operators; Bognar; Azizov-Iokhvidov; Gupta-Bleuler
   and Kugo-Ojima quartet mechanism in finite-dimensional toy form; anything on
   discrete/lattice BRST with kernel-checkable content. Exact citations.

## Success criterion

A complete answer is EITHER a finite-dimensional theorem (statement + proof
sketch at working-mathematician rigor + formalization ladder of 3-6 exact finite
lemmas) OR a decisive counterexample showing our quotient route needs a stated
repair hypothesis, plus the repaired route. Partial credit: the exact boundary
between the two.
