# Independent review request: A3f-R1 normalization and coverage law

## Requested disposition

Return `APPROVE`, `APPROVE-SUBSET`, or `REJECT` before the A3f-R1 empirical
selector is run. This request concerns the analytic correction and frozen
coverage-only design, not an empirical result.

## Correction requiring explicit audit

The original A3f preregistration was invalidated before implementation or
execution. It made two errors:

1. It treated
   `(2 H^(1/4) + m^(1/4))^4` as the outer count whose full protected core has
   expectation `m`. In fact this formula makes only a centered shifted
   subdiamond have count `m`; the full protected core is larger.
2. It described fourth-root interval-volume radii as proper times without the
   flat 4D conversion factor `(pi/24)^(-1/4)`.

The exact flat 4D protected-core fraction derived by spatial-ball integration
is

```text
F4(z) = 4 integral_z^1 (y^2-z^2)^(3/2) dy
      = 1/2 ((2-5z^2)sqrt(1-z^2) + 3z^4 acosh(1/z)),
z = 2s/T = 2(H/M)^(1/4).
```

For the frozen A3e numbers, this gives ideal global core fractions

```text
B=24: 0.07545155
B=32: 0.03579953.
```

Your A3e review's roughly 7.7 percent pin is therefore a reasonable rounding
for the tight B=24 rung, but not for the required B=32 refinement rung. Please
audit this correction directly.

## R1 design boundary

R1 freezes the balanced schedule

```text
R proportional to ell^(1/4),
S proportional to ell^(1/2),
L proportional to ell^(3/4),
```

so counts scale as `N^(3/4)`, `N^(1/2)`, and `N^(1/4)` at fixed global
four-volume. It tests only order-atlas core coverage and overlap. Probe data,
row-source eligibility, polynomial controls, operator stability, rank-four
projection, and coordinates are all excluded and require a successor.

## Files

- `AgentTasks/null-edge-buffered-core-feasibility-2026-07-16.md`
- `Scripts/experiments/causal_buffered_core_feasibility.py`
- `Scripts/experiments/test_causal_buffered_core_feasibility.py`
- `AgentTasks/null-edge-causal-atlas-coverage-stage-a3f-plan-2026-07-16.md`
- `AgentTasks/null-edge-causal-atlas-coverage-stage-a3f-r1-plan-2026-07-16.md`

## Required checks

1. Re-derive the spatial-ball integral and closed form independently.
2. Confirm the count-to-proper-time conversion and A3e B=24/B=32 values.
3. Confirm the old shifted subdiamond is a strict lower bound rather than the
   whole core.
4. Replay all tests and audit their independence from the implementation.
5. Check the R1 exponent schedule gives all four limits
   `ell,L,S,R -> 0` and `ell/L,L/S,S/R -> 0`.
6. Check the empirical gates do not smuggle support or metric claims into a
   coverage result.
7. Identify any remaining false baseline, hidden conditioning, or finite-size
   overclaim before selector implementation begins.

## Replay

```text
cd Scripts/experiments
python -m unittest test_causal_buffered_core_feasibility.py -v
ruff check causal_buffered_core_feasibility.py test_causal_buffered_core_feasibility.py
python causal_buffered_core_feasibility.py
```
