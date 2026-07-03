# 1+1D Checkerboard Lane

This note records the first concrete step toward the dynamical program
recommended by Aristotle on 2026-07-01.

## Why This Lane Exists

The Pluecker theorem makes the slogan

```text
mass = obstruction to staying one null beam
```

precise as finite kinematics. It does not yet give a propagator, a path sum, or
a continuum Dirac equation.

The 1+1D Feynman checkerboard is the cleanest finite dynamical testbed. A path
moves at speed `c` along one of two null directions. The mass parameter appears
as the amplitude to reverse direction. In a continuum limit, the full
checkerboard path sum is expected to recover the 1+1D Dirac propagator.

This package does not prove that continuum limit yet. It now contains the
finite transfer and matrix-power path-sum seed needed before any analytic
continuum theorem should be attempted.

## Lean Seed

Module:

```text
PhysicsSM.Draft.Checkerboard1D
```

Core definitions:

- `Direction := Fin 2`
- `rightState`, `leftState`
- `directionGrade`
- `reversal`
- `nullTransport r l`
- `massFlip mu`
- `checkerStep r l mu`

The transfer step is:

```text
checkerStep r l mu = nullTransport r l + massFlip mu
                   = [[r,  mu],
                      [mu, l ]]
```

Here `r` and `l` preserve the right-moving and left-moving null directions.
The parameter `mu` is exactly the off-diagonal reversal amplitude.

## Checked Facts

- `checkerStep_right_to_left`
- `checkerStep_left_to_right`

These say the two direction-changing entries of one step are exactly `mu`.

- `checkerStep_zero_mass`
- `massless_step_right`
- `massless_step_left`

These say that at `mu = 0`, the right and left null directions decouple.

- `massFlip_right`
- `massFlip_left`

These say the mass channel sends a right-moving state to a left-moving state
and conversely.

- `nullTransport_commutes_directionGrade`
- `massFlip_anticommutes_directionGrade`

These are the finite grading discipline: massless transport preserves the
direction grading, while the reversal/mass channel anticommutes with it.

- `checkerStep_sq`
- `checkerStep_mulVec`
- `checkerboard_recurrence_right`
- `checkerboard_recurrence_left`
- `checkerboard_recurrence`

This expands two checkerboard steps. The off-diagonal terms are the two
one-turn paths:

```text
preserve then reverse
reverse then preserve
```

- `edgeAmp`
- `edgeAmp_of_turn`
- `edgeAmp_turn_symmetric`
- `pathAmp`
- `HasTurn`
- `turnCount`
- `hasTurn_iff_turnCount_pos`
- `turnCount_pos_of_hasTurn`
- `hasTurn_of_turnCount_pos`
- `turnCount_eq_zero_iff_not_hasTurn`
- `not_hasTurn_of_turnCount_eq_zero`
- `turnCount_eq_zero_of_not_hasTurn`
- `turnCount_eq_zero_iff_isChain`
- `first_step_eq_of_turnCount_zero`
- `pathAmp_zero_mass_of_hasTurn`
- `pathAmp_zero_mass_of_turnCount_pos`
- `pathAmp_factor`
- `pathAmpVec`
- `turnCountVec`
- `pathAmpVec_cons`
- `turnCountVec_cons`
- `pathAmpVec_factor`
- `turnCountVec_le_length`
- `pathAmpVec_unit_mass_isotropic`
- `pathAmpVec_isotropic`
- `pathAmpVec_sum_succ`
- `checkerStep_pow_apply`
- `checkerStep_pow_apply_factored`
- `checkerStep_pow_apply_turnGrouped`
- `checkerStep_pow_apply_isotropic`
- `turnCount_snoc`
- `turnCount_reverse`
- `pathAmpVec_eq_pathAmp_ofFn`
- `turnCountVec_eq_turnCount_ofFn`
- `checkerStep_isotropic_unitary`

These define finite checkerboard path amplitudes and prove the sharp zero-mass
statement: every path containing a direction reversal has zero amplitude when
`mu = 0`. They also prove the quantitative factorization

```text
pathAmp r l mu path = mu ^ turnCount path * pathAmp r l 1 path
```

so the exact power of the mass/reversal amplitude in a finite path is its number
of turns.

The tuple-form theorem

```text
(checkerStep r l mu ^ n) out inc =
  sum over length-n paths from inc to out of pathAmpVec r l mu path
```

is now kernel-checked as `checkerStep_pow_apply`. This is the finite
checkerboard path-sum identity for powers of the transfer matrix. The stronger
theorem `checkerStep_pow_apply_turnGrouped` groups the same path sum by exact
turn count, making each entry a finite polynomial in `mu`. The theorem
`checkerStep_pow_apply_isotropic` specializes this to `r = l = a`, where each
length-`n` path contributes `mu ^ turns * a ^ straight_edges`.

The tuple/list bridge theorems identify tuple paths built with `List.ofFn`
with the list-path API for both amplitudes and turn counts. The theorem
`turnCount_reverse` proves that reversing a finite path preserves its number of
turns. The theorem `checkerStep_isotropic_unitary` proves that the isotropic
transfer

```text
checkerStep (cos theta) (cos theta) (Complex.I * sin theta)
```

is unitary in the finite two-state Hilbert-space sense.

## Non-Claims

This is not yet:

- a continuum limit;
- a proof of the 1+1D Dirac equation;
- a probability rule;
- a 3+1D branch-release construction.

## Next Targets

The remaining useful targets are no longer the elementary finite bridge and
unitarity checks. The next proof package should focus on:

- optional exact endpoint path-count formulas or closed forms for grouped
  checkerboard sums;
- a finite generator-expansion statement connecting the unitary normalization to
  the expected continuum Hamiltonian terms;
- a theorem statement for the scaling limit to the 1+1D Dirac equation, with
  exact analytic hypotheses separated from the finite algebra.

The Aristotle integration report is
[`CHECKERBOARD_ARISTOTLE_REPORT.md`](CHECKERBOARD_ARISTOTLE_REPORT.md).
The literature review and next proof split are in
[`CHECKERBOARD_LITERATURE_REVIEW.md`](CHECKERBOARD_LITERATURE_REVIEW.md).

Sources for orientation:

- [Feynman checkerboard overview](https://en.wikipedia.org/wiki/Feynman_checkerboard)
- [Feynman's 1947 letter on the Dirac path integral](https://arxiv.org/html/2408.15070v1)
