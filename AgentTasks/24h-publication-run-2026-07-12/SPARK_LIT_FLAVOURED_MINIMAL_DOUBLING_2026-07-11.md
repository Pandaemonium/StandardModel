# Literature pass: flavoured and minimally doubled strict 3+1 walks

Date: 2026-07-11 20:58 PDT. Spark remained unavailable, so Codex performed the
documented direct fallback and read the primary arXiv full text.

## Primary sources

1. Bakircioglu, Arnault, Arrighi, *Fermion Doubling in Quantum Cellular
   Automaton Models*, arXiv:2505.07900.
   <https://arxiv.org/abs/2505.07900>

   The paper treats doubling directly in discrete-space, discrete-time QCA and
   resolves it by a covering map of the Brillouin zone. In `3+1`, the direct
   space is decomposed into translated sublattices/flavour sheets and the time
   translation carries an explicit tensor product of three flavour flips. This
   is not a unique-cone walk on the original cell. It is a precise enlarged-cell
   or covering construction that reinterprets the copies as flavours without
   breaking linearity or chiral symmetry. Sections 4.2 and 5, especially the
   sublattice construction near equations/figures 4.2-6, are the relevant
   clean-room template.

2. Gupta, Short, *Fermion Doubling in Dirac Quantum Walks*,
   arXiv:2601.15885v2.
   <https://arxiv.org/abs/2601.15885>

   Their exact local unitary permits a nonzero stationary amplitude
   `gamma_0`, with one-dimensional factor
   `T = gamma_+ S + gamma_0 + gamma_- S^dagger` and projector identities that
   prove unitarity. In `3+1`, the construction removes conventional doublers
   and pseudo-doublers but retains two additional low-energy Weyl-like
   solutions at explicitly described momenta. The authors report numerical
   exclusion of further solutions rather than an exact global classification.
   This is a strong template for a minimally doubled or stationary-amplitude
   hedge, not evidence for a unique cone.

## Consequences for this run

- The exact P1 slice kill is consistent with current literature: enlarging the
  local word can move or reduce copies without yielding one isolated cone.
- P4 should be recast around the Gupta-Short stationary-amplitude projector
  factor, because exact unitarity is proved by local projector algebra and the
  residual pair is explicit.
- The strongest robust positive architecture is the Bakircioglu-Arnault-
  Arrighi covering/flavour construction. It accepts a larger cell/register and
  gives the aliases an exact flavour interpretation. This is closer to the
  determinant-paired P2 route than to a four-component one-cone claim.
- Neither source licenses a unique-cone theorem. For Gupta-Short, the exact
  all-zone root classification is a worthwhile original Lean target; for the
  covering construction, the worthwhile target is an exact equivalence between
  the original copied walk and the flavoured reduced-zone walk.

## Next theorem targets

1. Clean-room formalize the one-axis projector identity
   `gamma_+ S + gamma_0 + gamma_- S^dagger` and its exact unitarity.
2. Compose three axes and state the two residual Weyl points exactly.
3. Prove the covering-map flavour equivalence on a finite momentum torus before
   attempting an infinite-lattice formulation.
