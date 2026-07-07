# Q6. The continuum limit: from finite Krein complexes to Lorentzian QFT

Every finite identity we prove is safe; the physics lives in the limit. Design
the limit program at full precision - the Lorentzian/Krein replacement for the
Osterwalder-Schrader route - anchored on the one limit we already own.

## Setup

Assets: the Feynman checkerboard program is formalized at the finite level in the
repository (corner conventions, luminal walks), and its 1+1 continuum limit is
CLASSICALLY known to be the massive Dirac propagator - our carrier is its
algebraization (corner weight = turn amplitude phi; zigzag segments = null edges;
Q_T = phi^2 the mass term). Retarded transports are our causality decoration. The
Wilson-loop area law at strong coupling is kernel-checked (Euclidean lattice
side). Nothing about limits is kernel-checked; that is the point of this
question.

## The questions

1. THE BENCHMARK THEOREM. State, at full mathematical precision, the theorem
   "the 1+1 null-edge carrier on the refining causal-diamond complex converges
   to the continuum Dirac evolution" - the topology of convergence (strong
   resolvent? kernel-wise on cylinder functions?), the exact scaling of phi with
   the lattice step (the classical checkerboard scaling eps -> 0 with m eps
   fixed), and what plays the role of the Trotter/Chernoff argument. This is our
   first continuum theorem target; make it formalization-shaped (a ladder of
   4-6 statements from purely finite to the limit statement).
2. LORENTZIAN OS. What is the correct axiomatics for the limit objects? Compare:
   (a) Euclidean OS + Wick rotation (needs reflection positivity - what is the
   Krein-space analog of the OS positivity axiom, and is our flat-sector/quotient
   positivity its finite shadow?); (b) direct Lorentzian axioms (Wightman on
   Krein spaces, Strocchi-Wightman for gauge theories, modular/Tomita methods);
   (c) the d'Antoni-style or Kaplan-style light-front constructions. Which fits
   a REFINING FAMILY OF FINITE KREIN SPACES best, and what is the precise
   compatibility condition between refinement maps and the fundamental
   symmetries J_n?
3. DOUBLING IN THE LIMIT. Where exactly does fermion doubling try to enter the
   checkerboard/null-edge limit, and what kills it: retardedness (forward
   cones), the Krein structure, or a hidden Wilson-term equivalent? Connect to
   the kernel-checked Ginsparg-Wilson layer: is the continuum-limit-safe
   statement "the null-edge transfer operator satisfies a GW relation with
   R = (retardation kernel)"? State it finitely.
4. WHAT REFINES. Refining a 2-complex of null edges is not cubical lattice
   refinement: new null directions must appear at each stage (the celestial
   sphere gets populated). Propose the refinement category (objects: decorated
   complexes; morphisms: coarse-grainings compatible with soldering, J, and
   retardation) and the fixed-point notion in it. Is there a renormalization
   semigroup here, and which of our slots (Q_A, Q_C, Q_T, E) is relevant /
   marginal / irrelevant under it in 1+1 and in 3+1?
5. OBSTRUCTIONS. The two facts most likely to make the whole limit program
   fail as stated - name them, and the earliest finite computation that would
   reveal each.
6. LITERATURE: checkerboard limits (Gersch; Jacobson-Schulman; Kauffman-Noyes),
   Krein/indefinite-metric QFT axiomatics (Strocchi; Morchio-Strocchi;
   Yngvason), lattice-to-continuum constructive results closest in spirit
   (Gross-Osterwalder-Seiler era results; recent constructive lattice fermion
   limits). Include the Destri-de Vega light-cone lattice (massive
   Thirring/sine-Gordon regularized on a lattice of null lines) as the
   exactly-solvable INTERACTING 1+1 control case one rung above the free
   checkerboard benchmark. Exact citations.

## Success criterion

The benchmark-theorem ladder (question 1) precise enough to start formalizing its
finite rungs immediately, plus a reasoned choice of axiomatics (question 2) with
the finite-shadow statement of its positivity axiom. Everything labeled with the
claim calculus.
