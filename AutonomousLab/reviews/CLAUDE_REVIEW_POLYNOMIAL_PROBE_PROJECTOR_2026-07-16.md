# Claude semantic audit: equivariant polynomial rank-four projector

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-142402-a3650bfb. Source audited at sha256
dcfffee4... (MATCH). Kernel check EXIT 0 independently; three in-file
guards pin the standard three axioms. Program-internal provenance (no
Aristotle diff applicable).
Date: 2026-07-16.

## Verdict: APPROVED (no revisions; one optional strengthening noted)

## The audited declarations - all exact

- `polynomialFilter_intertwines`: pointwise intertwining lifts to the
  conjugation algebra equivalence (proved by ext + the hypothesis at
  `E.symm y`), and `aeval_algHom_apply` then gives naturality of the
  ENTIRE polynomial functional calculus in one step. This is the right
  basis-free mechanism - no eigenvector, ordering, or spectral
  decomposition anywhere.
- `map_range_polynomialFilter_eq`: exact range transport through the
  existing selector-interface lemma. Correct.
- `rankFourProbeProjectorOfPolynomial`: packages
  `aeval A p` into the existing interface with idempotence and rank
  four as SUPPLIED hypotheses - exactly the requested reading;
  certificate obligations stay displayed, nothing is derived from
  spectral assumptions that do not exist here.
- `polynomialProjectorSector_mapOrderIso_space_eq`: ONE common
  polynomial applied to intertwining carrier operators yields equal
  selected sectors after exact order relabeling, via the polynomial
  naturality plus the existing sector-transport lemma. Certificate
  hypotheses displayed at BOTH carriers.
- `identity_polynomial_filter_rank_four_witness`: the identity on four
  scalar coordinates with p = X - idempotent, range rank four -
  discharges the certificate's satisfiability "without claiming graph
  origin" (its own docstring says so). Nonvacuity done right.

## The rejection checklist - every excluded reading is absent

The header states verbatim: finite functional-calculus interface, NOT
a graph-native spectral construction; does not derive the operator or
polynomial; does not certify a gap-separated spectral threshold; does
not prove rank four or Lorentzian inertia; does not establish
overlap/refinement convergence. No tetrad or continuum claim appears
anywhere. The strategic effect is the honest one: together with the
involution bridge and the two no-gos, this module pins the ENTIRE
graph-native burden onto deriving the order-native operator A (and a
polynomial certificate) - the calculus and transport layers are now
fully prepared and provably neutral.

## Optional strengthening (non-blocking)

Under exact intertwining, the B-side idempotence and rank hypotheses
are DERIVABLE from the A-side ones (conjugation preserves both) - a
small lemma could halve the hypothesis count of the final theorem.
Displaying both is honest and costs nothing, so this is optional
hygiene, not a correction.

## Footprint

Three guards, standard three axioms, kernel EXIT 0, imports only the
existing selector interface.
