# Claude semantic audit: complete layered-retarded polynomial-selector no-go

Item: GRAV-ORDER-OPERATOR-001 (builder codex; skeptic claude)
Request: msg-20260716-155753-03c2c4bb (extends/supersedes the abstract
review CLAUDE_REVIEW_RETARDED_POLYNOMIAL_NOGO_2026-07-16.md, whose
verdict stands and is incorporated).
Sources audited: FiniteStrictPastNilpotence (c698f350...),
RetardedPolynomialProjectorNoGo (b02e3de4...),
LayeredOperatorPolynomialNoGo (8e2f6bdc...) - all MATCH. Independent
triple build green (8037 jobs). Guards: 2 + 2 + 6, all standard three.
Date: 2026-07-16.

## Verdict: APPROVE

## Statement chains - VERBATIM at every link, both Aristotle pairs

- Nilpotence pair (project cdb53c37): submitted = returned (4/4) and
  returned = live (both public statements IDENTICAL).
- Abstract no-go pair (project 1c4479b1): verified in the superseded
  review - submitted = returned = live (2/2 IDENTICAL).
- The composition module is program-internal, as its provenance says.

## Strict-chain nilpotence - assumptions sufficient, control sharp

`weightedPastOperator_pow_card_eq_zero` needs exactly: finite, nonempty,
transitive, irreflexive - no totality, no linear extension, arbitrary
real weights. The proof is the honest classical argument: a nonzero
card-th power forces a strictly-ascending chain of card+1 events
(built by induction through the incidence sums), transitivity
propagates the relation along the chain, irreflexivity makes the chain
injective, and pigeonhole kills it. The two-chain control is exactly
the requested nonvacuity: N /= 0 (evaluated concretely) and N^2 = 0 -
the bound is used, not vacuous.

## Convention fidelity - kernel-proved against the production operator

The audit's sharpest question is discharged in the strongest possible
form: `layeredOperatorLinear_apply` PROVES pointwise equality with the
pre-existing `FiniteCausalOrder.layeredOperator`
(FiniteCausalOrderOperator.lean:149, the long-landed production
definition `prefactor * (diagonal * phi x + layeredPastSum ...)`),
with `layeredPastLinear_apply` distributing the prefactor through the
strict-past sum. The 4D specializations are likewise kernel-bridged:
the source-sign operator (diagonal = -1) via the same equality, and
the ACTIVE project-sign smeared operator via the PRE-EXISTING bridge
`projectSmeared4DOperator_eq_layeredOperator`. No re-definition
convenience anywhere; signs and prefactor placement are theorem-locked,
not eyeballed.

## The composed no-go - exactly as claimed

For every finite causal order, every prefactor/diagonal/coefficient
family, and every real polynomial p: an idempotent
`aeval (layeredOperatorLinear ...) p` is 0 or id (nilpotence at
card V + the abstract theorem, composed with `Fintype.card_pos` on the
displayed Nonempty). Instantiated for both the source-sign local 4D
operator and the active smeared operator. The conclusion is precisely
the disjunction - nothing stronger is claimed.

## Exclusions and remaining gates - honest

The header kills ONLY the direct real-polynomial-filter architecture
on the one-spectrum retarded operator and explicitly leaves open:
normal/Hermitian operators built from retarded/advanced data,
non-polynomial functional calculus, larger probe representations, and
a separately derived constraint kernel. That is exactly the right
boundary: the corrected-pairing/symmetrized route - the program's
actual G2 candidate - is untouched and is now the UNIQUELY indicated
direction, since one-sided retarded transport is closed kernel-grade.
G2 and all downstream GR gates remain open/closed exactly as before.

## Notes carried forward

The style flag from the superseded review (file-scoped maxHeartbeats
in RetardedPolynomialProjectorNoGo) remains open and non-blocking; the
other two modules scope their budgets correctly (`in`-scoped at line 56
of the nilpotence module; none needed in the composition).
