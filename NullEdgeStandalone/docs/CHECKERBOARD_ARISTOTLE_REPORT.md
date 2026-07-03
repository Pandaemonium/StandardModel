# Checkerboard Aristotle Report

Date: 2026-07-01

Aristotle project:

```text
d3d18bbc-13e9-4ffb-9f39-a151055488d9
```

Aristotle task:

```text
1298d6d3-9732-482c-8c78-84641c443b50
```

This report records the finite path-combinatorics layer integrated into
`PhysicsSM.Draft.Checkerboard1D`. The returned proof package was adapted into
the standalone module's local style rather than copied verbatim.

## Physical Reading

The model is the 1+1D finite checkerboard transfer seed. There are two null
directions:

- `0`: right-moving;
- `1`: left-moving.

The one-step transfer matrix is:

```text
checkerStep r l mu = [[r,  mu],
                      [mu, l ]]
```

Here `r` and `l` preserve the right-moving and left-moving null directions,
while `mu` is the direction-reversal amplitude. In this finite model, the
mass-like channel is exactly the off-diagonal null-direction flip.

## Integrated Lean Content

New or strengthened finite path material:

- `turnCount`: number of direction reversals in a list path.
- `hasTurn_iff_turnCount_pos`: a path has a turn exactly when its turn count is
  positive.
- `turnCount_eq_zero_iff_isChain`: zero turn count is equivalent to all
  consecutive directions agreeing.
- `pathAmp_factor`: every list-path amplitude factors as
  `mu ^ turnCount path * pathAmp r l 1 path`.
- `pathAmpVec`: tuple-form path amplitude for paths of fixed length.
- `pathAmpVec_cons`: peeling the first tuple vertex multiplies in the leading
  edge amplitude.
- `pathAmpVec_sum_succ`: endpoint-constrained path sums reindex by first edge.
- `checkerStep_pow_apply`: the `(out, inc)` entry of `checkerStep ^ n` is the
  finite sum over all length-`n` checkerboard paths from `inc` to `out`.

Together these give the finite dictionary needed for later dynamics: powers of
the transfer matrix are path sums, and each path weight records the exact power
of the mass/reversal amplitude through `turnCount`.

## What This Proves

This is a finite identity layer. It proves that the checkerboard transfer
matrix has the expected finite path expansion and that null-direction changes
are counted precisely by powers of `mu`.

It does not prove a continuum limit, a 1+1D Dirac equation, a probability rule,
or any 3+1D branch-release statement.

## Later Checkerboard Integration

The original Aristotle report identified several next Lean targets. Codex
subsequently integrated `checkerStep_pow_apply_turnGrouped`,
`checkerStep_pow_apply_isotropic`, and `checkerboard_recurrence`. A later
Aristotle checkerboard-remaining job then supplied the finite bridge and
normalization checks:

- `pathAmpVec_eq_pathAmp_ofFn`;
- `turnCountVec_eq_turnCount_ofFn`;
- `turnCount_snoc`;
- `turnCount_reverse`;
- `checkerStep_isotropic_unitary`.

These close the originally listed elementary finite targets. Remaining
finite-side work is optional endpoint counting, closed-form grouped sums, and
small-spacing generator expansion.

## Next Analytic Target

`checkerboard_dirac_limit_statement` should state, but not yet prove, the
analytic scaling assumptions for a future continuum Dirac limit.

## Analytic Assumptions Still Missing

A future continuum theorem will need explicit assumptions such as:

- lattice spacing and amplitude scaling;
- a joint limit of time steps and lattice spacing;
- regularity and convergence of initial data;
- convergence of the rescaled transfer generator to a fixed Dirac Hamiltonian;
- uniform estimates for the finite path sums.

Until those are formalized, the package should describe the checkerboard lane
as finite algebra and finite path combinatorics only.
