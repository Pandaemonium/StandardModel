# Fixed-cardinality atlas no-go under a shrinking chart schedule

Date: 2026-07-16  
Work item: `GRAV-ATLAS-PACKING-001` postmortem  
Claim grade: finite theorem plus conditional asymptotic consequence

## Finite bound

For a finite event universe, let `chosen` be an atlas of `K` protected cores.
If every core has cardinality at most `B`, then

```text
card(union chosen) <= K * B.
```

Consequently, demanding coverage of at least `target` events forces

```text
target <= K * B.
```

Both statements are kernel-checked in
`PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean` as
`coveredBy_card_le_card_mul` and `coverage_target_forces_card_mul`. They are
build-pinned to the standard Mathlib axiom footprint.

## Consequence for the balanced A3f schedule

The frozen expected counts obey

```text
n_R ~ N^(3/4),  n_S ~ N^(1/2),  n_L ~ N^(1/4).
```

Every protected core is contained in its outer carrier. The candidate band
therefore supplies the deterministic bound

```text
B_N <= floor(1.10 n_R(N)) - 1 = O(N^(3/4)).
```

For any fixed atlas cardinality `K`, its all-event coverage fraction is at
most

```text
K B_N / (N + 1) = O(N^(-1/4)) -> 0.
```

Thus a fixed `K=16` atlas cannot retain nonzero global coverage in the genuine
shrinking-scale limit. This does not invalidate the A3f-R2 finite benchmark;
it fixes its interpretation as a finite-density gate rather than a continuum
atlas law.

If the protected-core count is asymptotic to the calibrated value

```text
B_N ~ n_R(N) F_4(2 (n_S(N) / n_R(N))^(1/4)),
```

then `F_4 -> 1` and `B_N ~ N^(3/4)`. Maintaining a nonzero target coverage
therefore requires at least

```text
K_N = Omega(N^(1/4)).
```

Under one density doubling, the corresponding chart-count multiplier is
`2^(1/4)`, so a baseline `K=16` maps to about `19` charts. This number is an
analytic scaling diagnostic, not permission to rerun or repair A3f-R2.

## Slow physical shrinkage

The outer proper duration relative to the unit global diamond scales as

```text
T_R = (n_R / N)^(1/4) = O(N^(-1/16)).
```

At the tested densities, the outer carriers are therefore still macroscopic:

```text
N=4800: T_R about 0.808
N=9600: T_R about 0.774
```

This explains why sixteen charts can cover an order-one fraction at present
densities while being asymptotically incapable of doing so. The count hierarchy
is valid, but its outer physical scale enters the local regime extremely slowly.

## Successor architecture

A clean successor has two separate gates.

1. **Complete-family convergence:** establish that the complete order-only
   candidate union has controlled coverage and candidate abundance along a
   density ladder, using streaming or bit-packed evaluation if the family
   exceeds the A3f-R2 resource ceiling.
2. **Growing-atlas convergence:** preregister `K_N` with the necessary
   `N^(1/4)` scaling, then evaluate coverage, overlap connectivity, repeated
   coverage, and greedy efficiency relative to the complete-family union on
   fresh development and held-out seeds.

The successor must not reinterpret seed `2026071608` as held-out evidence,
lower the killed A3f-R2 gates, or open source-row/operator phases. A growing
atlas solves only the cardinality inconsistency; it does not prove stochastic
covering, natural probe reconstruction, Lorentzian inertia, or G2.
