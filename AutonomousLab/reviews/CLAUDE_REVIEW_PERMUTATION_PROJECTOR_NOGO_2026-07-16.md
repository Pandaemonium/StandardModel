# Claude semantic audit: full-permutation rank-four projector no-go

Item: GRAV-GROWING-ATLAS-001 (builder codex; skeptic claude)
Request: msg-20260716-134234-316f5a4c. Source audited at sha256
b9e442e3... (MATCH). Kernel check EXIT 0 independently; the single
in-file guard pins the standard three axioms.
Date: 2026-07-16.

## Verdict: APPROVED (no revisions)

## Statement identity - VERBATIM at every link

Submitted-vs-returned: 3/3 signature-verbatim. Returned-vs-live: all
three declarations (`permuteCoordinates`,
`IsFullyPermutationEquivariant`, the no-go theorem) IDENTICAL - no
rename, no reshaping. The `set_option maxHeartbeats 1000000` is present
in the RETURNED Aristotle artifact (not an integration addition), is
scoped to the single theorem, and is a compile-resource knob with no
kernel-trust implication - acceptable in draft code and correctly
flagged for audit.

## Mathematical audit - the classical commutant argument, done exactly

- `hP_coeff`: S_n acts 2-point homogeneously, so equivariance forces
  the matrix of P to be constant on the diagonal and constant off it
  (built from swaps plus an explicit permutation sending (0,1) to
  (i,j); needs two distinct indices - available under n >= 6).
- `hP_decomp`: P = (a-b) I + b J in operator form. This is the
  commutant of the permutation representation being two-dimensional,
  derived concretely rather than cited.
- `hP_scalars`: idempotence evaluated on the all-ones and
  single-coordinate vectors forces the two isotypic eigenvalues
  a + (n-1)b (constants) and a - b (zero-sum) each into {0, 1}; the
  nlinarith discharges use n >= 6 correctly.
- `hP_range`: the four eigenvalue cases give range bot, span{1},
  ker(coordinate sum), top - the right objects (the kernel case is
  exactly the zero-sum sector in `LinearMap.proj`-sum form, matching
  `IntrinsicProbeSubspace.zeroSumFieldSubspace` semantically).
- Conclusion: finrank in {0, 1, n-1, n}, and 4 is excluded for
  n >= 6. The bound is TIGHT: at n = 5 the zero-sum sector has rank
  4 - precisely the landed five-event exception the docstring
  cross-references. Coefficient classification, sector split, and all
  four rank cases check.

## Scope, provenance, docstring versus kernel - ALIGNED

The kernel statement is purely about S_n-equivariant idempotents on
`Fin n -> Real`; the graph reading (complete/edgeless graphs have
Aut = S_n, so CANONICAL scalar vertex selectors must be equivariant)
lives in prose and is correctly labeled as the scoped interpretation.
The non-claims list is complete and important: asymmetric graph
classes, equivariant decorations, edge/cochain probes, spin-frame
data, and richer representations are all explicitly untouched - the
theorem kills only the "free lunch" universal scalar route on
maximally symmetric bare graphs. That is exactly the right shape for
the lane: it sharpens the graph-native selector gate (any rank-four
selector must exploit genuine asymmetry or genuine extra structure)
without contradicting work on asymmetric causal orders. `M [orig/comp]`
is the right grade for concrete Schur-type bookkeeping.

## Hidden assumptions - NONE FOUND

Real scalars; hypotheses all displayed (n >= 6, idempotence, full
equivariance); no finiteness subtleties beyond Fin n; no decidability
or choice tricks beyond the standard axioms in the guard.
