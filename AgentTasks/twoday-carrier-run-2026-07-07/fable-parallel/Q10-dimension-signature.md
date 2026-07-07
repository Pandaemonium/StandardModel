# Q10. Why 3+1? Dimension and signature selection from null structure

The deepest input we currently smuggle: spinors are C^2, the celestial sphere is
CP^1, spacetime is 3+1 Lorentzian. If null edges are ontologically primary, the
dimension and signature should be OUTPUTS - selected by consistency of the
null-edge algebra - or demonstrably free parameters. Decide which.

## Setup

Assets and hints: the whole kinematic layer runs on the exceptional isomorphism
"future null directions in 3+1 = rank-one Hermitian 2x2 = CP^1" - the
Lorentz group as PSL(2,C) acting on the celestial sphere; the division-algebra
ladder R, C, H, O corresponds to Minkowski dimensions 3, 4, 6, 10 via
sl(2, K) = so(1, K-dim + 2) (Baez-Huerta; Kugo-Townsend spinor identities); our
repository has the octonion case formalized (XOR-Fano convention) pointing at
the d = 10 / superstring corner; null nilpotency c(alpha)^2 = 0 is the
kernel-checked algebraic heart of the carrier.

## The questions

1. WHAT THE CARRIER NEEDS. Go through the carrier's algebraic requirements -
   null covectors spanning the dual space, a chirality grading, a fundamental
   symmetry with balanced-enough inertia, the Weitzenboeck decomposition's
   cross-term cancellations, and (from Q1) a positive physical quotient - and
   determine in which (d, signature) each requirement is satisfiable.
   Candidate selection principles to evaluate: (a) "enough null directions":
   only Lorentzian signature (1, d-1) has a null cone spanning the space -
   Euclidean dies immediately; multi-time (2, d-2) signatures have null cones
   but notoriously lose well-posedness/positivity - does OUR positivity
   quotient fail there for an algebraic reason you can state finitely?
   (b) division-algebra rigidity: the 2x2-determinant mass identity
   det(sum psi_i psi_i^dagger) = pairwise wedges requires Hermitian 2x2 over
   K in {R, C, H, O}; which parts survive over H (d=6) and O (d=10, watch
   nonassociativity - our repo can check O-cases mechanically), and which are
   C-only?
2. THE SELECTION THEOREM CANDIDATE. Formulate the sharpest candidate theorem of
   the form: "a finite null-edge complex with [list of physical requirements]
   admits a consistent carrier iff its local model is R^{1,3} (equivalently:
   the edge bispinor algebra is the C case)". Which requirement does the
   selecting? If instead the answer is the full ladder {3,4,6,10}, state THAT
   theorem and identify the additional principle (three generations from Q5?
   the positivity quotient? anomaly-shaped index sum rules?) that cuts it to 4.
3. SIGNATURE FROM RETARDEDNESS. Our retarded transports impose an orientation
   of the null cone (a time arrow) at the finite level. Is Lorentzian signature
   plus time orientation EQUIVALENT, on a finite complex, to the existence of
   the retardation structure (a purely order-theoretic characterization a la
   causal sets: Malament/Hawking-King-McCarthy discretized)? State the finite
   equivalence precisely - it would make signature a theorem about order.
4. TWO SPATIAL DIMENSIONS OF THE CELESTIAL SPHERE. The celestial sphere being a
   complex curve (CP^1) is what makes 2-component spinor magic work. Is there a
   finite-combinatorial avatar: the "sky" of a vertex (its null-edge link) must
   carry a complex/conformal structure for the aperture identity to close -
   and does demanding that at every vertex force d = 4 (skies = S^2)? Compare
   with twistor/celestial-holography claims about why d=4 is special.
5. HONEST ALTERNATIVE. Steelman the deflationary answer: dimension/signature
   are inputs everywhere in physics, our framework included, and apparent
   selection arguments secretly assume the answer (e.g. by choosing C^2
   spinors). If that is the truth, say so bluntly and identify the exact
   assumption where the dimension enters our kernel-checked layer.
6. LITERATURE: Baez-Huerta division algebras and supersymmetry; Kugo-Townsend;
   Manogue-Dray; Penrose twistor arguments for d=4; causal-set order+number
   results; Tegmark's and Borstnik-Nielsen's dimension-selection arguments;
   celestial holography reviews. Exact citations.

## Success criterion

A requirement-by-(d,signature) verdict table; ONE candidate selection theorem
stated with full finite precision (even if its proof is a program); the
retardedness-equals-signature equivalence statement; and the steelmanned
deflationary verdict if selection fails. No romance: if 4 is not special in this
framework, we need to know before we write another paper.
