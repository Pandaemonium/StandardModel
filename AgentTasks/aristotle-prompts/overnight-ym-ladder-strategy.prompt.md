# Aristotle strategy/audit job: Yang-Mills formalization ladder (overnight 2026-07-03)

You are acting as a research strategist and adversarial auditor for a Lean 4
formalization program, not as a Lean prover. Do NOT attempt a Lean build.
Return a written report.

Formatting requirements for the report: ASCII only, LF line endings. In
prose, write Lean escape-hatch tokens in spaced form (`s o r r y`,
`a x i o m`, `n a t i v e _ d e c i d e`), never raw.

## Standalone context (assume you are blind to the repository)

A Lean 4 project (Mathlib-based, toolchain v4.28.0) that until now
formalized finite lattice Dirac-operator theory (Ginsparg-Wilson/overlap
operators, chiral index theory on finite lattices, all kernel-checked) has
opened a new track: climbing the known results of constructive LATTICE
GAUGE THEORY as a formalization ladder, with the Clay Millennium problem
("Yang-Mills existence and mass gap") as an explicitly non-scheduled,
non-claimed summit. The near rungs are all finite mathematics:

- YM0 (done at the Z2 core level): lattice link fields, gauge action,
  plaquette holonomy, gauge invariance - kernel-checked for Z2.
- YM1 (Elitzur done; 2D exact solutions in progress): a quantitative,
  volume-uniform Elitzur theorem is kernel-checked end to end for Z2
  (pairing-involution proof, bound |<f>| <= ||f|| tanh(q_x h)). Remaining:
  the exact 2D solutions (Z2 torus closed form via an even-cover
  combinatorics argument; open 2D lattice for any finite group via a
  character fusion lemma), statements frozen with complete paper proofs.
- YM3 (the flagship; tonight's main lane): character positivity of Wilson
  weights (all character coefficients of exp(beta Re chi) are >= 0 for
  beta >= 0), a finite Bochner theorem (the kernel K(g,h) = w(g h^{-1}) on
  a finite group is PSD iff all coefficients >= 0), transfer-operator
  positivity, and LINK-reflection positivity of the Wilson ensemble for
  arbitrary FINITE gauge group, with the reconstruction (GNS quotient,
  positive transfer operator, H = -log T) and a finite-lattice mass-gap
  DEFINITION restricted to the Gauss-invariant, zero-momentum, trivial
  't Hooft-flux sector. Everything reduced to finite mathematics; proofs
  exist on paper; formalization is the deliverable. To our knowledge
  reflection positivity has never been formalized in any proof assistant
  (a novelty check is running in parallel; closest known adjacent art is
  arXiv 2606.07922, where RP is a text proof next to an unrelated Lean
  repo).
- YM4 (groundwork only): Kotecky-Preiss cluster expansion (absent from
  Mathlib) and the polymer representation of the Z2 partition function;
  statement freeze only for now.
- QCD1 (side lane): a finite Banks-Casher "shadow" - an exact finite
  spectral decomposition of the regularized condensate over the overlap
  operator's GW-circle spectrum, on the project's existing chiral-index
  machinery.

Program disciplines you should assume and audit against: no statement
weakening; draft-vs-trusted separation with kernel-checked axiom audits;
a numerical oracle pinning all conventions (plaquette orientation,
character-coefficient conjugation placement, transfer-matrix
normalization); a hard rule against conflating (a) spectral mass gap,
(b) Wilson-loop area law, (c) entanglement area law; lattice results are
never presented as the continuum prize; LINK vs SITE reflection kept
distinct; person-name attributions held back until sources are verified.

## TONIGHT-STATE (as of 2026-07-04 01:15, submitting agent: claude)

Kernel-checked tonight (zero `s o r r y`, standard axiom footprint
[propext, Classical.choice, Quot.sound]):

- YM3 engine, Route B (character-theory-free): the Wilson-weight kernel
  `K(g,h) = exp(beta * Re chi(g h^-1))` is proved positive semidefinite
  for arbitrary finite G and unitary representation `rho`, beta >= 0.
  Built via a new reusable lemma this session had to prove from scratch:
  the Schur product theorem (Hadamard product of two PSD matrices is
  PSD) turned out to be ABSENT from this repo's pinned Mathlib under any
  name (checked directly against source, not just semantic search) -
  derived instead from the Kronecker-product PSD theorem (present) plus
  a diagonal-embedding submatrix restriction (present). Not yet done:
  Cor 3b (transfer-operator positivity via tensor/Gauss-projector
  compression) and RP-LINK itself (the cut-factorization argument).
- YM1, Theorem 2' (Z2 torus exact solution): the full dual-connectivity
  combinatorial core is kernel-checked - locally-constant plaquette
  subsets on the dual grid are empty-or-universal, equal-boundary
  subsets differ by nothing or complement, and the finite cover-sum
  ratio exactly matches the closed form `(t^A + t^(P-A))/(1+t^P)` at the
  combinatorics layer (prefactors and the loop-to-plaquette-set
  identification are the remaining assembly work). A companion
  fusion/convolution module (Lemma 2a, the nonabelian exact-solution
  route) is also in progress in parallel.
- Prior to tonight: the full quantitative, volume-uniform Elitzur
  theorem (YM1) and the Z2 gauge-invariance core (YM0) were already
  kernel-checked and are considered closed.

No obstruction has forced a statement weakening; the one real surprise
is the missing Mathlib lemma above, which was a tooling/verification gap
(a semantic-search hit reaching a newer Mathlib snapshot than this repo
vendors), not a mathematical one.

## Deliverable

Return a report named `YM_Ladder_Strategy_Audit.md` answering, numbered:

1. FLAGSHIP GAP ANALYSIS. Given the YM3 chain above (character positivity
   -> Bochner -> transfer positivity -> link-reflection positivity ->
   reconstruction -> gap definition), what is missing between
   "kernel-checked for arbitrary finite gauge group" and a defensible
   flagship publication claim of "formalized reflection positivity for
   lattice gauge theory"? List every qualifier the claim needs (finite
   group, link reflection, Wilson-type weight class, finite volume, choice
   of reflection plane, Gauss sector), and rank them by how much they
   weaken the headline.
2. FINITE-G VS COMPACT-G SEPARABILITY. Is the finite-group scope honestly
   separable as a publication, or will referees treat it as trivial
   without SU(2)/U(1)? Where EXACTLY does compact G first become
   essential, and is Peter-Weyl (absent from Mathlib) the only gate, or do
   Haar-integral RP and the compact transfer operator need materially new
   analysis beyond it?
3. STATEMENT-SHAPE RISKS. For each of: the Bochner converse, the Gauss
   projector as an average, the mass-gap definition with 't Hooft flux
   quantum numbers, and the C-8 trace identity
   Z = 2^(L*nt) Tr[(T P_G)^nt] - what is the most likely way the Lean
   statement could be subtly wrong while still proving? What concrete
   cross-checks (oracle fixtures, degenerate lattice sizes, known closed
   forms) would catch each?
4. SEQUENCING. Rank in expected-value order for the NEXT two weeks:
   (i) compact-G/U(1) RP via explicit Fourier analysis on the circle
   (bypassing general Peter-Weyl), (ii) Peter-Weyl formalization for
   Mathlib, (iii) the YM4 Kotecky-Preiss module, (iv) Wegner duality
   (YM1's remaining named theorem), (v) the QCD1 sandwich completion,
   (vi) hardening tonight's results for a paper. Justify briefly; name
   what each unblocks.
5. EMBARRASSMENT AUDIT. Where is this ladder most likely to embarrass
   itself publicly? Candidates to assess: an overclaimed "first"
   (adjacent art missed), a convention bug surviving into a paper, the
   mass-gap definition measuring the wrong excitation, conflation of the
   three area-law/gap notions in press-facing prose, attributing a
   theorem to the wrong source. Add any we have not thought of.
6. VERDICT. One paragraph: is the flagship-first strategy right, or
   should the program lead with a different rung? State the strongest
   argument AGAINST the current plan.

Ground every judgment in the mathematics as described; where you rely on
literature knowledge, name the source so the team can verify it (they
will not trust unnamed citations).
