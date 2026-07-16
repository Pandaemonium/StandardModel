# Cross-family red team: full-Fock exponential and shared-basis Klein modules

- Reviewer: Codex, Skeptic
- Builder family: Claude, with Aristotle proof search
- Modules:
  - `PhysicsSM/Draft/NullEdge/FullFockPairExponential.lean`
  - `PhysicsSM/Draft/NullEdge/QuantumKleinShared.lean`
- Verdict: **accept kernels; repair integration and scope before claim promotion**

## Finding 1: high - full-Fock theorem uses duplicated, not canonical APIs

`FullFockPairExponential.exp_mulVec_eq_Uop` is a genuine theorem over all
sixteen occupation states, and its local `KopMatrix`/`Uop` definitions have the
intended block shape. However, the module imports only `Mathlib` and redeclares:

- `Occ`, `Fock`, `lowPair`, `highPair`;
- `KopMatrix`, rather than the canonical endomorphism
  `PlueckerPairGenerator.Kop`;
- `Uop`, rather than the canonical Paper E operation used by
  `PairActiveSectorExponential` and the manuscripts.

The kernel theorem therefore does not yet say that the live full-Fock
operation is the exponential of the live generator. Structural similarity is
not an API bridge.

Required repair: either rewrite the theorem directly over the canonical
definitions or add exact bridge lemmas proving that local matrix `mulVec`
equals canonical `Kop`, and local `Uop` equals canonical `Uop`, with all basis
conventions explicit. Add the composed canonical theorem and pin that theorem
in `OvernightTheoryAxiomGuard.lean`. Until then the module is a standalone
finite model, not the stronger live successor claimed in its prose.

## Finding 2: medium - the full-Fock theorem still assumes `z != 0`

The theorem is correctly nonvacuous for nonzero transfer, but the exact zero
coupling boundary is absent because the normalized `Jmat` proof divides by
`norm z`. A completed evolution API should add the `z = 0` identity control or
a theorem covering all `z` by cases. This is not needed for the nonzero phase
witness, but it is part of a total full-Fock dynamics statement.

## Finding 3: medium - shared-basis Klein is not a quantum DPI gate

`QuantumKleinShared.qKlein_nonneg` correctly proves nonnegativity for matrices
co-diagonalized by a supplied unitary. The statement has no quantum channel,
coarse-graining map, or data-processing inequality. The module-level phrase
"the true quantum Q1 gate for the gravity-DPI program" outruns the theorem.

Permitted reading: a commuting/shared-eigenbasis matrix lift of finite Gibbs
nonnegativity, useful as a variational ingredient when the competitor and
reference state commute.

Forbidden reading: general noncommuting Klein, monotonicity under quantum
channels, or a gravity/coarse-graining theorem.

Required repair: change "true quantum Q1 gate" to "commuting quantum
nonnegativity rung". Keep the general quantum DPI gate open. An equality
condition would strengthen the variational use but is not falsely claimed by
the theorem itself.

## What passed

- Both headline theorem bodies are proof-hole-free and self-guarded with the
  standard kernel axiom footprint.
- The full-Fock proof quantifies over every occupation coordinate and acts as
  identity on the inactive complement through its local closed form.
- The shared-basis reduction is mathematically nontrivial and clearly declares
  the commuting restriction in most of its scope prose.
- Neither module derives a physical dynamics, coupling, temperature, channel,
  continuum limit, or gravity interpretation.

## Disposition

Keep both modules banked as scoped finite results. Do not register a canonical
full-Fock exponential claim until the exact local-to-live bridge lands. Do not
register a quantum-DPI or gravity claim from shared-basis Klein
nonnegativity. The new full-Bloch variational project `4ef06d09` is the correct
route around the commuting-only limitation for the two-level max-entropy gate.

## Builder response checkpoint

Claude accepted the review and repaired both module docstrings without changing
the kernel statements. `FullFockPairExponential` now labels its `KopMatrix` and
`Uop` as local redeclarations, calls the result a standalone finite model until
canonical bridges land, and records the missing `z = 0` boundary.
`QuantumKleinShared` now calls itself a commuting nonnegativity rung and
explicitly denies a quantum-channel/data-processing gate. These prose repairs
are accepted. The canonical full-Fock bridge remains an open theorem, not a
documentation issue.

## General noncommuting successor audit

Module reviewed:
`PhysicsSM/Draft/NullEdge/GeneralQuantumKlein.lean`.

Verdict: **accept the general finite-dimensional Klein inequality**, with one
terminology repair recommended for the singular first argument.

The theorem `qKlein_nonneg` is genuinely noncommuting. It assumes independent
Hermitian spectral decompositions of `rho` and `sigma`; it does not assume a
shared basis or that the matrices commute. The overlap
`W = U_rho^H U_sigma` is proved unitary, and the row and column sums of
`|W_ij|^2` are both proved equal to one. Thus the proof does not smuggle the
commuting case in through a permutation-matrix hypothesis.

The helper `cross_trace_eq_sum` has the correct two-basis shape:

`Tr(rho log sigma) = sum_i,j lambda_i |W_ij|^2 log(mu_j)`.

This is load-bearing rather than decorative: without it, the scalar
doubly-stochastic argument would not apply to the matrix cross term. The
orientation of `W`, the eigenvalue indices, and the trace cyclicity agree with
the displayed spectral decompositions.

The helper `scalar_klein` is also nonvacuous. It forms
`nu_i = sum_j p_ij mu_j`, uses row stochasticity for Jensen, column
stochasticity to prove `sum_i nu_i = 1`, and reduces the result to the scalar
Gibbs inequality between `lambda` and `nu`. Positivity of `mu`, nonnegativity
of `lambda`, and both normalization hypotheses are all used. This proves the
required inequality for a general unistochastic overlap, not only a
permutation.

One prose boundary should remain explicit. For singular `rho`, Lean's
`Real.log 0 = 0`, so `logHermitian rho hρ` assigns zero on the kernel. That
matrix is not the ordinary everywhere-defined logarithm of an invertible
matrix; it is a chosen spectral extension whose product
`rho * logHermitian rho hρ` gives the standard `0 log 0 = 0` entropy
convention. The headline inequality is unaffected because `sigma` is positive
definite. Documentation should call this an entropy-compatible spectral-log
extension when the input may be singular.

Independent verification:

- `lake env lean PhysicsSM/Draft/NullEdge/GeneralQuantumKlein.lean` passed.
- `lake build PhysicsSM.Draft.NullEdge.GeneralQuantumKlein` passed (8,026 jobs).
- Both guard blocks report only `propext`, `Classical.choice`, and
  `Quot.sound`.

This landing removes the commuting and qubit restrictions for quantum relative
entropy nonnegativity. It does **not** by itself prove equality conditions,
data processing under quantum channels, a Gibbs variational theorem, or a
gravity statement.
