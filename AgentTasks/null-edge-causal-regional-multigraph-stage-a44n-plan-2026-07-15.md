# Null-edge Stage A44N multi-graph regional covariance preregistration

**Status:** complete; every frozen development gate passed

## Question

At the measured-feasible `N=100000` density, does a 16-pivot order-selected
regional average concentrate around its per-pivot finite targets across fresh
graphs strongly enough to justify a higher-density Branch N successor?

The A44p pilot seed `20261550` informed this protocol but is excluded from all
gates below.

## Frozen data

- fresh development seeds: `20261560`, `20261561`, `20261562`;
- random events: `100000` per graph;
- duration-`2` flat diamond;
- primary compact cutoff `(0.02,0.08)` at `L/R=0.20`;
- minimum 16 tied-depth count-selected pivots, retaining all ties;
- exact packed relation blocks `32 x 4096`, popcount block `128`;
- all 17 affine/quadratic/cubic channels used by A44p;
- one certified low/high continuum target per selected pivot, with orders
  `(28,36,10,12)` and `(40,52,14,16)`.

Each graph writes a complete checkpoint before the next begins. Aggregation is
forbidden until all three fresh checkpoints exist and pass the target gate.

## Development gate

1. Every graph passes cache-size, finite-row, quadrature, and Lorentzian-target
   controls.
2. Every regional-mean discrete metric has signature `(1,3,0)`.
3. At least `75%` of all individual pivot metrics are Lorentzian.
4. Median regional full-metric error is below `0.50`, with maximum below
   `0.75`.
5. Median 17-channel regional operator error is below `1.25`, with maximum
   below `2.0`.
6. The pooled residual covariance ledger reconstructs every direct regional
   second moment to `1e-12`.
7. For `quadratic_t_t`, `quadratic_x_x`, `quadratic_y_y`, and
   `quadratic_z_z`, the minimum effective pivot count is at least `3` and the
   median is at least `4`.

These thresholds are frozen from the A44 architecture gate and the separate
A44p pilot; they are not a held-out physics claim.

## Branch rule

- If every gate passes, retain Branch N and permit a separately preregistered
  `N=200000` development refinement. This does not authorize `N=400000`.
- If signature passes but an error or covariance gate fails, keep the exact
  backend but deprioritize density escalation until the intrinsic local
  challenger receives its own finite-sprinkling comparison.
- If signature fails, stop Branch N at this schedule.

No held-out seed, curvature estimator, or GR claim is opened by this stage.

## Recorded outcome

The three fresh checkpoints and their aggregate artifact pass every gate. All
regional means are Lorentzian, the individual Lorentzian rate is `91.7%`, the
median metric error is `0.361`, and the median 17-channel operator error is
`0.742`. The exact covariance decomposition error is below `5.33e-15`.

The frozen rule therefore permits a separately preregistered `N=200000`
development run. A subsequent information-flow audit found that the current
global selector and taper give every selected-row observable a conservative
whole-graph read set. The empirical pass remains valid, but density escalation
is deferred until that complete-dependency issue is repaired or bounded.

Benchmark:
`AgentTasks/null-edge-causal-regional-multigraph-stage-a44n-benchmark-2026-07-15.md`.
