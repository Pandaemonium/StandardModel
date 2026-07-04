# Aristotle red-team job: YM3 reflection-positivity chain, statement-vs-intent audit

TEMPLATE - the submitting agent must fill every <<PASTE ...>> slot with
VERBATIM Lean source (not paraphrase) before submission. A prose
paraphrase cannot expose a semantic mismatch between the intended math
and the kernel-checked statement, which is this review's whole point.

You are acting as an adversarial semantic auditor of Lean 4 theorem
STATEMENTS, not as a prover. Do NOT attempt a Lean build. The Lean kernel
checks proofs; it cannot check that a statement says what its authors
intend. Your job is the gap between the two.

Formatting requirements for the report: ASCII only, LF line endings. In
prose, write Lean escape-hatch tokens in spaced form (`s o r r y`,
`a x i o m`), never raw.

## Standalone context (assume you are blind to the repository)

A Lean 4 project is formalizing, for lattice gauge theory with an
arbitrary FINITE gauge group G, the chain: character positivity of Wilson
weights -> finite Bochner theorem -> transfer-operator positivity ->
LINK-reflection positivity -> reconstruction and a finite-lattice
mass-gap definition. Normative conventions (pinned by a numerical oracle,
36/36 fixtures):

- C-1: finite oriented lattice; link variables on positively oriented
  edges; reversed traversal uses the group inverse.
- C-2: plaquette holonomy counterclockwise, based at s:
  hol(p) = U(s,mu) U(s+mu,nu) U(s+nu,mu)^{-1} U(s,nu)^{-1}.
- C-4: weight per plaquette w(h) = exp(beta * Re chi_f(h)), beta >= 0,
  chi_f the character of a UNITARY representation.
- C-5: character coefficient w_hat_R = (1/|G|) sum_h w(h) chi_R(h^{-1});
  this is the EXPANSION coefficient (w = sum_R w_hat_R chi_R). Fusion
  identities must use the convolution argument order
  sum_h w(h) chi_R(h^{-1} A); the order sum_h w(h) chi_R(A h) is valid
  only for inversion-symmetric weights (all Wilson weights are; general
  class functions are not - an oracle guard row exhibits the failure).
- C-8: transfer matrix T = V^(1/2) K V^(1/2), V diagonal
  spatial-plaquette weight, K tensor product of per-link temporal
  kernels K1(s,s') = w(s s'^{-1}); Gauss projector = average over local
  spatial gauge transformations; pinned identity
  Z_torus = 2^(L*nt) Tr[(T P_G)^{nt}] for Z2 in 1+1D.
- Intended RP statement (LINK reflection ONLY - SITE reflection is a
  DIFFERENT theorem and must not be conflated): for the time reflection
  theta through a plane bisecting a layer of temporal links, and A_+ the
  algebra of functions of links strictly on the positive side,
  <(theta F)* F> >= 0 for all F in A_+, for any per-plaquette
  class-function weight with all w_hat_R >= 0.
- The finite-lattice mass gap is defined on the transfer operator
  restricted to the Gauss-invariant, zero-spatial-momentum, TRIVIAL
  't Hooft-flux sector (on small tori the naive Gauss-sector gap is
  saturated by a winding electric flux line, not a glueball - omitting
  the flux quantum number makes the definition measure the wrong
  excitation).
- Hard claim discipline: spectral mass gap, Wilson-loop area law, and
  entanglement area law are three distinct notions; results are
  finite-lattice statements, never the continuum Millennium problem.

## Statements under audit (VERBATIM Lean source)

### Definitional layer (link fields, holonomy, weights, kernels)

<<PASTE: full verbatim source of the definitions the theorems quantify
over, including any local Fintype/DecidableEq instances and the
unitarity hypothesis as actually stated.>>

### Theorem statements

<<PASTE: full verbatim source of every theorem statement in tonight's
YM3 chain, with docstrings. Include the intended-reading one-liner for
each, stated SEPARATELY from the Lean text.>>

### Consumers (how downstream code uses them)

<<PASTE: any downstream statement that consumes the above, if it exists
yet - e.g. the C-8 acceptance-test statement.>>

## Deliverable

Return a report named `YM3_RedTeam_Report.md` answering, numbered, for
EACH statement:

1. INTENT MATCH. Does the Lean statement say what the stated intended
   reading says? Identify every mismatch, however small (quantifier
   scope, implicit coercions, wrong side of an equivalence, direction of
   an inequality, real-vs-complex scalar field, which group element is
   inverted).
2. CONVENTION DRIFT. Check against C-1..C-8 above, especially: the
   argument order in every character sum (the C-5 trap); inverse
   placement in holonomy and kernels (K(g,h) = w(g h^{-1}), not
   w(h g^{-1}) - or is the statement invariant under that swap, and if
   so, is THAT proved or assumed?); where the unitarity hypothesis
   enters and whether any lemma silently needs it where it is not
   assumed.
3. HIDDEN HYPOTHESES. What is assumed by the formalization that the
   paper proof does not need (or vice versa)? Nonempty/Fintype/
   DecidableEq instances that secretly restrict generality; connectivity
   assumptions; beta >= 0 vs beta real; the weight being strictly
   positive vs nonneg.
4. VACUITY AND STRENGTH. Could the statement be TRUE FOR THE WRONG
   REASON (vacuous quantifier, degenerate instance, zero object)? What
   concrete small-instance evaluation would detect it? What is the most
   ambitious defensible STRENGTHENING of the statement?
5. DEMOTION TEST. What single discovery would demote the flagship claim
   ("reflection positivity for lattice gauge theory with arbitrary
   finite gauge group, kernel-checked") to something weaker, and does
   any statement above contain the seed of that discovery?

Close with a ranked list of the three most dangerous findings and the
one-line fix for each.
