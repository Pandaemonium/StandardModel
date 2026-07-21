# Task: Peirce/spectral decomposition of h3(O) at distinct eigenvalues

Project: Lean 4 (v4.28.0) + Mathlib. Exceptional Jordan algebra lane (P7/P9).
Self-contained package: octonion base modules, the trusted `Jordan/H3O.lean`
carrier (Hermitian 3x3 octonionic matrices, `jordanProduct` with notation
`○`, `oneH3O`, `trace`, `IsProjection`), and
`H3OCharacteristicEquation.lean` (PROVEN structural cubic
`X ○ (X ○ X) = trace X • (X ○ X) - sigmaH3O X • X + detH3O X • oneH3O`
- check the exact landed form in the file and use it as the reduction
engine).

## Target

`PhysicsSM/Draft/H3OPeirceDecomposition.lean` - five theorems ending in a
hole. Content: at a spectral triple `(r, s, t)` (Vieta hypotheses bundled in
`IsSpectralTriple`) with DISTINCT values, the Lagrange elements

  `lagrangeE X r s t = ((r-s)(r-t))^{-1} • ((X - s•1) ○ (X - t•1))`

(1) sum to `oneH3O`, (2) reconstruct `X` eigenvalue-weighted, (3) are
Jordan idempotents, (4) are pairwise Jordan-orthogonal, and (5) satisfy the
eigen-equation `X ○ E_r = r • E_r`.

## Proof strategy

Everything reduces to commutative algebra in the powers `1, X, X ○ X` plus
the characteristic cubic for `X ○ (X ○ X)`:

- (1) and (2) are linear identities in `1, X, X ○ X` with polynomial
  coefficient identities in `r, s, t` (Vieta substitutions); `field_simp` /
  `ring` after clearing the distinctness denominators.
- (3), (4), (5) need products of two quadratic polynomials in `X`; expand
  with bilinearity of `○`, reduce the degree-3 and degree-4 terms with the
  characteristic cubic (apply it once to get `X^3`-terms, twice for
  `X^4`-terms via `X ○ (X ○ (X ○ X))` - prove the needed
  power-associativity helper lemmas for THIS carrier as intermediate
  results; small helper lemmas are expected and welcome).
- Beware: `H3O` is NOT associative; only the commutative Jordan product and
  its proved identities may be used. Do not assume operator associativity;
  parenthesize everything explicitly.

## Pre-registered honesty license

If a statement fails as given (e.g. an orthogonality needs an extra
symmetric-function hypothesis), prove the corrected statement, rename it,
and record the mismatch prominently. A kernel counterexample to any stated
identity is a first-class result.

## Constraints

- No new `a x i o m` / `o p a q u e` / `u n s a f e`; no `n a t i v e _ d e c i d e`.
- Standard axioms only ([propext, Classical.choice, Quot.sound]).
- Do not modify the included trusted modules.
- Verify with `lake env lean PhysicsSM/Draft/H3OPeirceDecomposition.lean`
  first; avoid a full `lake build` until the holes are closed.

## Success criteria

All five theorems (or honestly-corrected versions) proven, zero holes, and
a completion report: solved targets, helper lemmas added, statement
changes, axioms used.

## RESTART ADDENDUM (2026-07-19 08:20)

The target file now carries the FIRST HARVEST: `lagrangeE_sum`,
`lagrangeE_reconstruct`, `jordan_eigen`, and the full bilinearity layer
are PROVEN - do not modify them. EXACTLY TWO holes remain and are the
entire job: `jordan_power_four` (degree-4 power-associativity
`(X ○ X) ○ (X ○ X) = X ○ (X ○ (X ○ X))` on the concrete `H3O` carrier -
a direct coordinate computation is legitimate; alternatively derive it
from `h3o_characteristic_equation` by Jordan-algebra identities) and
`lagrangeE_isProjection` (idempotence; uses power-four + the
characteristic cubic exactly as `lagrangeE_orthogonal`'s proof does).
All other instructions unchanged.
