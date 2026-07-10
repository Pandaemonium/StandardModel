# Summary of changes for run a6b05923-e538-4909-b717-06b9c02a17b5
Delivered `RequestProject/Main.lean` (namespace `DiracGammaPhysLean`) and `ARISTOTLE_SUMMARY.md`, verified with a clean `lean_build` (no sorry/admit/native_decide/new axioms; Mathlib-only).

The file reproduces PhysLean's Dirac-representation gamma matrices verbatim as explicit constant complex 4×4 matrices (`g0,g1,g2,g3`, entries in {0,±1,±I}), the mostly-minus metric `eta = diag(1,-1,-1,-1)` (signature (+,-,-,-)), and the indexed family `gamma : Fin 4 → Matrix (Fin 4) (Fin 4) ℂ`, and proves:

1. `gamma_sq_0/1/2/3`: the diagonal Clifford relations `(γ^0)²=I`, `(γ^i)²=-I`.
2. `gamma_anticomm_01/02/03/12/13/23`: off-diagonal anticommutation `g_μ g_ν = -(g_ν g_μ)` for all six distinct pairs.
3. `clifford_relation`: the packaged `{γ^μ,γ^ν} = 2η^{μν}·I` for all 16 (μ,ν), reduced by `fin_cases` to (1) and (2).
4. `nondegeneracy`: explicit witnesses that the gammas are nonzero/distinct and `eta` is genuinely indefinite, so the Clifford relation is not the trivial Euclidean case.
5. `dirac_gamma_verdict`: the packaged verdict.

Proofs use `ext`/`fin_cases` + `Matrix.mul_apply` + `Fin.sum_univ_four` + `simp`/`norm_num` (plus `module`/`abel` for packaging); no symbolic complex analysis, no real transcendentals, no nlinarith. Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` confirming the footprint is exactly [propext, Classical.choice, Quot.sound].

Honest scope: this is the finite Clifford algebra (anticommutation) only — not Lorentz covariance, the spinor representation, or the mass term. Provenance: package HEPLean/PhysLean, declaration `spaceTime.gamma` (Dirac representation), version gap pinned off v4.28.0, used as a reference and NOT imported (clean-room port). All work committed and pushed.

# claude-dirac-gamma-physlean — Dirac gamma algebra grounded in PhysLean's convention

## What was proved

A self-contained, kernel-checked, Mathlib-only verification (`RequestProject/Main.lean`,
namespace `DiracGammaPhysLean`) that the PhysLean Dirac-representation gamma matrices
satisfy the Clifford algebra of the mostly-minus Minkowski metric `η = diag(1,-1,-1,-1)`,
signature `(+,-,-,-)`.

The four gamma matrices `g0, g1, g2, g3` are reproduced verbatim as explicit constant
complex `4×4` matrices (entries in `{0, ±1, ±I}`), together with the metric `eta` and the
indexed family `gamma : Fin 4 → Matrix (Fin 4) (Fin 4) ℂ`.

### Headline theorems

- `gamma_sq_0 : g0 * g0 = 1`, `gamma_sq_1/2/3 : gᵢ * gᵢ = -1` — the diagonal Clifford
  relations `(γ^μ)² = η^{μμ} · I`.
- `gamma_anticomm_01/02/03/12/13/23 : g_μ * g_ν = -(g_ν * g_μ)` — off-diagonal
  anticommutation for all six distinct pairs.
- `clifford_relation (μ ν : Fin 4) : gamma μ * gamma ν + gamma ν * gamma μ
  = (2 * eta μ ν) • (1 : Matrix (Fin 4) (Fin 4) ℂ)` — the packaged Clifford algebra
  `{γ^μ, γ^ν} = 2 η^{μν} I` for all 16 index pairs, reduced by `fin_cases` to the diagonal
  and anticommutation lemmas.
- `nondegeneracy` — explicit witnesses that the gammas are nonzero/distinct (`g0 0 0 = 1`,
  `g2 0 3 = -I ≠ 0`, `g0 ≠ g3`) and that `eta` is genuinely indefinite (`eta 0 0 = 1`,
  `eta 1 1 = -1`, `eta 0 0 ≠ eta 1 1`), so `clifford_relation` is not the trivial Euclidean
  all-`+1` case.
- `dirac_gamma_verdict` — the packaged verdict conjoining all of the above.

Proofs use `ext`/`fin_cases` + `Matrix.mul_apply` + `Fin.sum_univ_four` + `simp`/`norm_num`
(+ `module`/`abel` for the packaged relation). No symbolic complex analysis, no real
transcendentals, no `nlinarith`.

### Axiom footprint

Each headline carries an in-file `#guard_msgs (whitespace := lax) in #print axioms …` check
confirming the footprint is exactly `[propext, Classical.choice, Quot.sound]`. No `sorry`,
`admit`, `native_decide`, or new axioms; builds under the required time budget.

## Honest scope

This verifies the finite Clifford *algebra* (the anticommutation relations) only — not the
Lorentz covariance, the spinor representation, or the mass term. It anchors the Dirac
operator convention to an external, machine-verified one.

## Provenance

- Package: HEPLean/PhysLean (github.com/HEPLean/PhysLean)
- Declaration: `spaceTime.gamma` (Dirac representation)
- Version gap: PhysLean is pinned off our v4.28.0 toolchain; it is used as a REFERENCE for
  the matrix constants only and is NOT imported. This is a clean-room port against Mathlib.
