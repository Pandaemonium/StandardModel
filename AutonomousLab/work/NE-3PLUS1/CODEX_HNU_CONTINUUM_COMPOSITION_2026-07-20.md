# HNU changing-cell continuum composition map

Date: 2026-07-20
Owner: Codex
Work item: `CONT-FOURIER-001`
Status: three-term changing-lattice position-space capstone and exact
Schwartz-domain Weyl generator identification landed

## 1. Target statement

For every two-component momentum-space field `F` in `L2(R^3)`, fixed physical
time `t`, the inverse-Fourier reconstruction of the explicit HNU walk on a
refining and exhausting momentum-cell schedule should converge strongly in
position-space `L2` to the exact Weyl evolution

```text
E_t(q) = exp(-i t (q_1 sigma_1 + q_2 sigma_2 + q_3 sigma_3)).
```

The final theorem must use the actual normalized cell coefficients, one common
substep count at each refinement level, and the live HNU endpoint. It must not
identify a two-component Weyl field with the older four-component massive
Dirac continuum modules.

## 2. Exact three-term decomposition

Let `P_N F` be the normalized piecewise-constant cell projection, `C_N` the
cell-center exact Weyl multiplier, and `L_N` the live HNU multiplier with the
common adaptive substep count. Then

```text
L_N P_N F - E_t F
  = (L_N - C_N) P_N F
  + (C_N - E_t) P_N F
  + E_t (P_N F - F).
```

The position-space norm is the same after inverse Fourier transform. Each term
has a separate proof obligation and should remain separately named in Lean.

## 3. Status by term

### Term I: live HNU versus exact cell-center flow

**Status:** actual two-component momentum- and position-space theorem landed.

`HNUChangingCellL2.lean` now supplies:

- `Spinor2 := EuclideanSpace Complex (Fin 2)`;
- actual normalized cell coefficients from `F`;
- the physical center bound `qAbs qCenter <= 3 * (N + 1)`;
- one common step count
  `adaptiveSteps (3 * (N + 1)) t N` for every scheduled mode;
- summed coefficient-energy contraction;
- momentum-space and inverse-Fourier position-space `L2` convergence.

The quantitative input is kernel-checked in
`HNUCompactMomentumContinuum.lean`. The live term is bundled as a genuine
vector-valued `Lp` element and transported through inverse Fourier transform;
its position-space norm tends to zero. Aristotle project
`da35eb2a-1150-47f9-8b67-bce8c90f8e86` supplied the initial live coefficient,
schedule, and pointwise-error spine; the remaining integration and Plancherel
composition was completed and replayed locally.

### Term II: exact cell-center versus continuously varying exact flow

**Status:** actual two-component cell-integral theorem landed.

`HNUExactFlowMomentumLipschitz.lean` proves

```text
||E_t(q) - E_t(p)|| <= |t| * ||q - p||_1
```

and, inside a physical cell of width `h`,

```text
||E_t(q) - E_t(q_center)|| <= 3 * |t| * h / 2.
```

The proof required and now supplies a dimension-generic sharp Hermitian
exponential theorem in `HermitianExpLipschitz.lean`; the established `4 x 4`
API remains as a wrapper.

`HNUExactFlowCellIntegral.lean` now performs the actual disjoint-cell integral
with the HNU `Spinor2` and `Eflow`, rather than importing the four-component
Dirac result. It uses the normalized coefficients extracted from the supplied
field, proves continuity and integrability of each cell variation, proves the
exact global disjoint-cell energy identity, and bounds the full energy by

```text
(3 * |t| * h_N / 2)^2 * input energy.
```

Thus the complete continuously varying intra-cell term tends to zero. The
module now also proves global strong measurability and square-integrability,
bundles the representative as a genuine vector-valued `Lp` element, and
transports it through Mathlib's inverse-Fourier isometry. The position-space
norm tends to zero. This is not a preferred-point or finite-sample surrogate.

### Term III: projection error

**Status:** two-component momentum- and position-space theorem landed.

`ChangingMomentumCellProjectionStrongL2.projectAt_tendsto_strong_L2` proves
strong `L2` convergence for every scalar component under the explicit refining
and exhausting schedule. The new kernel-checked module
`HNUChangingCellProjectionL2.lean` now performs the finite sum over the actual
two-component Weyl field, proves the exact representative-level Euclidean norm
identity, bundles the error into vector-valued `Lp`, and proves strong
momentum-space convergence. Exact Weyl evolution is unitary, so it preserves
this error norm when the final three-term capstone is assembled.

### Plancherel transport

**Status:** all three transports and the final position-space composition
landed for the two-component field.

`HNUChangingCellProjectionL2.positionProjectionErrorLp_norm_tendsto_zero`
uses the explicit measure-preserving bridge from the cell domain to
`EuclideanSpace Real (Fin 3)` and Mathlib's vector-valued inverse Fourier
linear isometry. Thus Term III is already closed in position-space `L2`, not
only componentwise or at the representative level.

`HNUExactFlowCellIntegral.positionExactCellVariationLp_norm_tendsto_zero`
uses the same audited bridge and inverse-Fourier isometry for Term II. Its
momentum- and position-space norms are identified exactly by Plancherel.

`HNUChangingLatticeContinuumCapstone.lean` evolves the actual projection tail
by the momentum-dependent exact Weyl unitary, proves exact norm preservation,
and composes the three terms with the required middle-term sign. It proves:

```text
positionTotalErrorLp_norm_tendsto_zero
```

for every componentwise `L2` two-spinor field and fixed physical time. A
separate semantic theorem proves almost everywhere that the bundled error is
exactly the live changing-cell approximation minus the exact Weyl evolution;
the convergence theorem is therefore not merely a convenient sum of unrelated
small quantities.

### Weyl PDE identification

**Status:** exact two-component Schwartz/Fourier generator identity landed.

`HNUExactFlowGenerator.lean` now proves that the exact two-component flow has
fixed-momentum generator `-i H_W(q)`, proves the induced derivative on a Weyl
spinor at zero time, and includes an explicit nonzero axis-spinor action. Thus
the target continuum equation is kernel-checked rather than read informally
from a first-order expansion.

`HNUWeylSchwartzPDE.lean` now supplies that missing convention-sensitive bridge.
For every two-component Schwartz spinor it proves integrability of the
position expression

```text
(-I / (2*pi)) * sum_j sigma_j partial_j g
```

and proves that its Mathlib Fourier transform is exactly multiplication by
`H_W(q) = sum_j q_j sigma_j`. The file also proves the coordinate-derivative
`2*pi*I*q_j` multiplier, commutation with a fixed bounded matrix action, and an
explicit nonzero axis-symbol witness. Aristotle project
`f1971541-94f0-4450-b62e-872fd583badd` returned the proof-hole-free source;
it was replayed locally and guarded under the project namespace.

This is the correct dense-domain PDE identification for the limiting Weyl
evolution. A closed unbounded self-adjoint operator/domain theorem remains a
possible analytic upgrade, not a prerequisite for the Schwartz PDE statement.

## 4. What the completed theorem establishes

It establishes a genuine changing-lattice, position-space, strong-`L2`
continuum limit for the live local unitary HNU regulator to one Weyl sector. It
is substantially stronger than fixed-momentum convergence or agreement
of a Taylor series.

It would not by itself establish:

- a massive Dirac particle;
- a doubled left/right pair with the correct mass turn;
- a Lorentz-invariant finite regulator at nonzero spacing;
- an all-null microscopic interpretation (HNU substeps have stay sectors);
- interacting QFT, gauge fields, or a Standard Model continuum limit;
- an economical relation between physical lattice spacing and the adaptive
  internal substep count.

## 5. Published comparison architecture

Arrighi, Nesme, and Forets, *The Dirac equation as a quantum walk: higher
dimensions, observational convergence* (arXiv `1307.3524`, J. Phys. A 47
465302, 2014), supplies the closest primary-source proof pattern. Their ladder
is:

1. well-posed symmetric-hyperbolic continuum evolution;
2. first-order consistency of the discrete update;
3. stability from exact unitarity in Sobolev norms;
4. convergence from the consistency/stability estimate;
5. low-pass lattice sampling and Shannon reconstruction;
6. an observational discrepancy of order `O(epsilon^2)` under their stated
   regularity and sampling assumptions.

The paper does not prove the HNU result and cannot be imported as one: its walk,
time-step scaling, regularity class, and interpolation map differ. It does,
however, confirm that sampling/reconstruction and stability are theorem data,
not prose. The HNU route currently uses an explicit normalized cell projection
and arbitrary componentwise `L2` input instead of band-limited Shannon samples;
its price is a rapidly growing adaptive internal substep count. A later rate
comparison should state both tradeoffs rather than compare bare big-O symbols.

Knowledge-system status: Zotero/Neo4j key `4F87TGCN`, arXiv id repaired to
`1307.3524`, 17 full-text chunks ingested on 2026-07-20.

## 6. Immediate dependency order

1. Independently audit the semantic representative theorem and adaptive
   schedule interpretation in `HNUChangingLatticeContinuumCapstone.lean`.
2. Compose the strong changing-lattice evolution theorem and the exact
   Schwartz generator theorem into a manuscript capstone with hypotheses and
   quantifier order shown verbatim.
3. Quantify the physical cost of the common adaptive internal substep count.
4. Decide whether a closed-operator domain theorem adds a needed physical
   claim or is better left to a later analytic paper.

## 7. Kill conditions

- The live HNU coefficient normalization fails the energy contraction.
- No common substep count controls all scheduled momenta at one level.
- The cell-center bound is assumed rather than proved from the schedule.
- The final norm concerns an arbitrary coefficient sequence rather than an
  actual supplied `L2` field.
- A `Fin 4` Dirac theorem is silently reused for the `Fin 2` Weyl field.
- The Fourier normalization or generator domain is suppressed.
- The adaptive schedule converges only by letting a hidden physical time or
  momentum scale collapse.
