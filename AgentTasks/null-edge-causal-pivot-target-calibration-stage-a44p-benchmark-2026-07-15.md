# Null-edge Stage A44p selected-pivot target calibration benchmark

## Verdict

**PER-PIVOT TARGET PASS; ONE-GRAPH REGIONAL RESIDUAL LARGE.** The packed
order-only selector, expanded 17-channel row, and off-center continuum target
now meet on one `N=100000` development graph without using coordinates to
select pivots.

## Target and resource controls

- packed relation: `1,250,137,503` bytes exactly;
- relation build: `334.37 s`;
- 16 expanded regional rows: `3.90 s`;
- selected count-depth threshold: `5921`;
- worst low/high operator target difference: `0.01065`;
- worst low/high metric target difference: `0.000813`;
- target signatures: 16 of 16 Lorentzian.

Selected time offsets lie in `[-0.0097,0.0120]R`, while spatial offsets extend
to `0.1766R`. Per-pivot finite metric shifts from the center target have median
`0.072` and maximum `0.117`; per-pivot targets are therefore not cosmetic.

## One-graph residual

The regional-mean target metric is approximately

```text
[[ 1.618,  0.007,  0.015, -0.011],
 [ 0.007, -0.756, -0.001, -0.001],
 [ 0.015, -0.001, -0.756, -0.001],
 [-0.011, -0.001, -0.001, -0.758]]
```

while the discrete regional mean is approximately

```text
[[ 0.644, -0.043, -0.240, -0.260],
 [-0.043, -0.955, -0.042,  0.041],
 [-0.240, -0.042, -0.927,  0.034],
 [-0.260,  0.041,  0.034, -0.837]]
```

Both are Lorentzian, but their relative Frobenius error is `0.546`. The
expanded regional operator error is `1.370`; individual metric errors have
median `1.279`, and 14 of 16 individual metrics are Lorentzian.

The literal residual-square ledger gives effective pivot counts `4.07` for
`quadratic_t_t`, `4.73` for `quadratic_x_x`, `9.36` for `quadratic_y_y`, and
`28.54` for `quadratic_z_z`. The anisotropy of one graph is not itself a
population estimate, but the positive off-diagonal contributions in the major
channels show that treating all 16 rows as independent would be misleading.

## Decision

Do not open held-out data or curvature. The next statistical gate needs several
fresh `N=100000` graphs, the same per-pivot targets, and the full residual
covariance ledger. Only that development result can decide whether more pivots,
higher density, or the local challenger deserves the next expensive run.

Machine-readable artifact:
`AgentTasks/causal-selected-pivot-target-stage-a44p-2026-07-15.json`.
