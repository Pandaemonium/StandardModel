# Gate C1 GW-release setup: what is proven, what the next rung needs

Date: 2026-07-03 (overnight run). Owner handoff note for the C1 overlap /
Ginsparg-Wilson release layer, written after the C1 free-operator half was
completed tonight.

## What is now proven (kernel-checked, draft-trust)

The equal-side tetrahedral free operator `Hfree` on the finite site torus
`SiteN N = Fin 4 -> ZMod N` (real-space Hermitian overlap seed
`Hfree = gamma5 * Kfree`) now has BOTH overlap prerequisites:

1. **Coercive inverse-propagator gap.**
   `TetraFreeOperatorGapEqualN.tetraFreeOperator_gap_equalN` (commit 6acb549):
   for `0 < a`, first Wilson band `0 < rho < 2r`, and `gamma5` unitary,
   `exists gamma > 0, forall Psi, gamma * fieldL2NormSq Psi <=
   fieldL2NormSq (Hfree Psi)`.

2. **Self-adjointness.**
   `TetraFreeOperatorSelfAdjoint.Hfree_selfAdjoint` (commit 93929ab): for
   `gamma5` a Hermitian involution (`star gamma5 = gamma5`) anticommuting with
   the kinetic slash `Q` at every discrete momentum, `Hfree` is self-adjoint
   for the field inner product `fieldInner`:
   `fieldInner (Hfree Psi) Phi = fieldInner Psi (Hfree Phi)`.

   Supporting: `fourierUnitary_inner_siteN` (sesquilinear Parseval),
   `H_symbol_hermitian` (momentum-symbol Hermiticity, commit 52de79d).

Together these say: `Hfree` is a self-adjoint operator with `Hfree^2 >= gamma`
(a spectral gap around 0) - exactly the input the overlap sign function needs.

## The representation gap (the real blocker)

`Hfree` is currently a **function transformer**
`(SiteN N -> Spin -> C) -> (SiteN N -> Spin -> C)`, not a `Matrix` or a
`cfc`-ready self-adjoint algebra element. To define `sign(Hfree)` and state the
Ginsparg-Wilson relation, the next rung must first bridge:

- **Option R1 (matrix representation).** Package `Hfree` as a
  `Matrix (SiteN N x Spin) (SiteN N x Spin) C` (finite index
  `SiteN N x Spin`), prove it `IsHermitian` (from `Hfree_selfAdjoint` +
  the standard basis), and use `Matrix.IsHermitian.spectral_theorem` /
  eigenvalues. `sign(H)` is then functional calculus on the (real, nonzero -
  by the gap) eigenvalues. Most concrete; heaviest bookkeeping (the
  index-product reshape and the operator->matrix equivalence).

- **Option R2 (cfc).** Realize `Hfree` as a self-adjoint element of the finite
  C*-algebra `Module.End C (SiteN N -> Spin -> C)` (or matrices) and use
  Mathlib `cfc` (continuous functional calculus). `sign = cfc (fun x => if
  0 < x then 1 else -1)` or via `Real.sign`; the gap gives `0` off-spectrum so
  `sign` is continuous on the spectrum. Cleaner algebra, but requires wiring
  the operator into the `cfc` instance for `Module.End` and confirming the
  spectral-gap-implies-`0`-off-spectrum step in that API.

Recommendation: R1 for a first concrete `sign(Hfree)` (Mathlib's Hermitian
matrix eigen-API is well developed), with the eigenvalue gap
`|lambda| >= sqrt gamma` proved from `Hfree_selfAdjoint` +
`tetraFreeOperator_gap_equalN` (eigenvector `v`, `|lambda|^2 fieldL2NormSq v =
fieldL2NormSq (Hfree v) >= gamma * fieldL2NormSq v`).

## Target statements for the GW rung

Once `sign(Hfree)` exists with `sign^2 = 1`, `sign` self-adjoint,
`sign` commuting with `Hfree`:

```text
D_ov := (rho / a) (1 + gamma5 * sign(Hfree))
GW:    D_ov gamma5 + gamma5 D_ov = (a / rho) D_ov gamma5 D_ov
gammahat5 := gamma5 (1 - (a/rho) D_ov) = - gamma5 * sign(Hfree) ... = -sign(Hfree) gamma5 form
Weyl projectors Phat_pm := (1 +- gammahat5)/2 ; Phat_pm^2 = Phat_pm
```

The GW relation itself is then an ALGEBRAIC identity in `sign(Hfree)`,
`gamma5`, given `sign^2 = 1` and the anticommutation `{gamma5, sign(Hfree)}`
structure - provable once the sign function is constructed, largely without
further spectral input. So the rung splits cleanly:

- **Hard half:** construct `sign(Hfree)` with its three properties (needs R1
  or R2 + the eigenvalue gap). This is the multi-hour infrastructure piece.
- **Easy half:** the GW relation, `gammahat5`, and the Weyl projector
  idempotency are algebra in `sign` and `gamma5` (mirrors the existing
  `OverlapGinspargWilson.lean` abstract algebra, which already carries the
  `eps = sign(H)` template).

## Recommended execution

1. Prove the eigenvalue spectral gap `|lambda| >= sqrt gamma` (bridge
   `Hfree_selfAdjoint` + the coercive gap through R1's matrix representation).
   This is the cleanest next bankable lemma and is the precise "0 off the
   spectrum" fact the sign function needs.
2. Construct `sign(Hfree)` (R1 recommended). Consider an Aristotle proof job
   for the eigen-decomposition/functional-calculus core IF it can be isolated
   to a Mathlib-only package (the operator->matrix reshape may be isolable;
   the full GateC1 context is NOT Mathlib-only and Aristotle struggles to
   build it - see the recurring C1 build-budget caveat in docs/ARISTOTLE.md).
3. Bank the GW relation + Weyl projectors as the algebraic payoff, reusing the
   `OverlapGinspargWilson.lean` template.

## Claim scope

All regulator-level (docs/NERD_ROADMAP.md). The GW rung, when complete, gives
the free (no-gauge) chiral release on the tetrahedral regulator - NOT the
gauge-background index theorem (Gate C2) and NOT a Lorentz-invariant continuum
claim. Free global index may be zero; that is expected and fine (the free C1
goal is one physical branch + valid GW Weyl projectors, per NERD_1 section XII).
