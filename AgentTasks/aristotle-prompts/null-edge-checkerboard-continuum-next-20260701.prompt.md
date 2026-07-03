# Aristotle prompt: checkerboard continuum-next finite targets and strategy

You are working on the standalone null-edge checkerboard lane from the
`PhysicsSM` project. The goal is to strengthen the finite 1+1D checkerboard
setup and recommend the best next steps toward a rigorous continuum Dirac
limit.

## Package shape

This is a focused Lean package with only Mathlib and three local Lean files:

```text
PhysicsSM/Draft/Checkerboard1D.lean
PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

Run the narrow check first:

```text
lake env lean PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

Do not spend budget on broad builds unless the narrow target is done.

## Existing finite facts

`Checkerboard1D.lean` already proves:

- `checkerStep` is the two-by-two transfer with diagonal null-preserving
  amplitudes and off-diagonal reversal amplitude;
- `turnCount` and `turnCountVec` count direction reversals;
- path amplitudes factor by `mu ^ turnCount`;
- `checkerStep_pow_apply` expands matrix powers as endpoint-constrained
  finite path sums;
- `checkerStep_pow_apply_turnGrouped` groups by exact turn count;
- `checkerStep_isotropic_unitary` proves the unitary isotropic normalization
  for `a = cos theta`, `mu = Complex.I * sin theta`.

`CheckerboardContinuumScaffold.lean` adds:

- outgoing right/left edge counts;
- net outgoing displacement;
- named `isotropicStep`;
- `reversal_sq`;
- exact decomposition
  `isotropicStep theta = cos(theta) * 1 + i sin(theta) * reversal`;
- typed small-step/mass-scale records for a future analytic theorem.

## Literature orientation

See `NullEdgeStandalone/docs/CHECKERBOARD_LITERATURE_REVIEW.md` in the package.
Key points:

- Feynman-Hibbs: turn amplitude is mass-like and proportional to
  `dt * m * c^2 / hbar`, up to phase convention.
- Gersch: transfer-matrix/Ising viewpoint supports finite matrix-power path
  sums.
- Jacobson-Schulman and Earle: endpoint classes have binomial formulas; Earle
  corrects and reconciles several published formulas.
- Kauffman-Noyes: light-cone finite differences produce the checkerboard path
  sum.
- D'Ariano-Mosco-Perinotti-Tosini: one-dimensional Dirac QCA path integral has
  closed forms in Jacobi polynomials.
- Skopenkov-Ustinov: modern rigorous asymptotics and real-time lattice QFT
  variants show what a serious continuum statement must specify.

## Exact Lean targets

Please try to prove the theorem holes in:

```text
PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

Target order:

1. `turnCountVec_mod_two_eq_endpoint`
2. `endpoint_eq_iff_turnCountVec_even`
3. `velocityEndpointTurnClassCount_eq_choose`
4. `isotropicStep_mul`
5. `isotropicStep_pow_eq`

You may add small helper lemmas in the same file. Do not weaken statements
silently. If a statement is false, report a counterexample and propose the
corrected statement.

## Strategy/audit request

After proof work, please include a concise report with:

- which targets were proved;
- any statements changed, and why;
- whether the outgoing-edge convention in `CheckerboardContinuumScaffold`
  matches the Earle/Jacobson-Schulman endpoint-count conventions;
- the best next Lean theorem statements for spacetime endpoint count formulas;
- the best next analytic theorem statement for the continuum Dirac limit,
  including required hypotheses, topology/norm choice, and likely Mathlib
  blockers;
- whether the next Aristotle job should focus on finite binomial endpoint
  counts, unitary generator expansion, or analytic convergence scaffolding.

Keep finite identities, convention audits, and analytic non-claims separate.
