# Paper D: changing-lattice R3 Shannon bridge

## Why this document exists

The run has now landed two strong results:

1. the complete live error converges in the common square-summable coefficient
   space over `Z^3`, including the omitted exact ultraviolet tail;
2. Mathlib's multivariate Fourier Hilbert basis transports that theorem exactly
   to strong convergence in four scalar `L2(T^3)` components.

That is not yet an `R^3` continuum theorem. A fixed integer Fourier lattice is
the dual of a fixed torus. Passing to `R^3` requires a changing momentum grid,
not a relabeling of the same coefficients.

## Missing scaling data

Choose a positive momentum spacing `h_N` and represent mode `k in Z^3` by

```text
xi_N(k) = h_N * k.
```

Two independent limits are required:

```text
h_N -> 0,          N * h_N -> infinity.
```

The first makes the momentum grid dense. The second makes the represented
physical momentum box exhaust `R^3`. Either condition alone is insufficient.

For the unit cube `Q = [-1/2,1/2)^3`, the coefficient-to-frequency embedding
must have the normalization

```text
(I_N c)(xi) = h_N^(-3/2) c(k)
  for xi in h_N * (k + Q).
```

This is the normalization for the exact isometry

```text
integral_R3 |I_N c|^2 = sum_k |c(k)|^2
```

on finite support. The inverse `L2(R^3)` Fourier isometry then produces the
position-space interpolant. A sinc formula may be derived later; it is not
needed for the first rigorous bridge.

## Theorem ladder

### D-R3-1. Exact cell isometry

Formalize disjoint half-open momentum cells and prove the scalar finite-support
identity above, then lift it to four spinor components. Required controls:

- one nonzero cell has exactly the stated norm;
- omitting `h_N^(-3/2)` gives the wrong `h_N^3` scaling;
- adjacent half-open cells overlap only on a null boundary.

**Status: landed.**
`PhysicsSM.Draft.NullEdge.ChangingMomentumCellIsometry` defines the cells as an
explicit coordinatewise product of scalar half-open intervals, proves exact
disjointness (stronger than null-boundary overlap), volume `h^3`, the normalized
and unnormalized one-cell integral laws, and the full finite-support isometry.
The direct function-space `Set.Ico` formulation was rejected during kernel
checking because product-order strictness is not coordinatewise strictness.

### D-R3-2. Changing-box exhaustion

For `B_N = [-N h_N, N h_N]^3`, prove measurable monotonic exhaustion under a
stated monotonicity condition and `N h_N -> infinity`. Required kill:
if `N h_N` is bounded, exhibit a fixed momentum outside every box.

**Status: landed.**
`PhysicsSM.Draft.NullEdge.ChangingMomentumBoxExhaustion` proves that every
fixed momentum is eventually inside the changing box whenever its physical
radius tends to infinity. It also gives one explicit fixed point outside every
box for any uniformly bounded radius schedule. The theorem is stated in terms
of the physical radius; choosing and auditing a joint `N,h_N` schedule remains
part of D-R3-3.

### D-R3-3. Scaled live multiplier theorem

**Status: landed.**
`PhysicsSM.Draft.NullEdge.ScaledChangingMomentumWalk` uses the explicit joint
schedule

```text
h_N = 1 / (N + 1),    integer cutoff = (N + 1)^2,
physical radius = N + 1,    microscopic steps = W_N^4,
W_N = 3(N + 1) + M + 1.
```

It proves `h_N -> 0`, exact physical-radius exhaustion, a uniform live
split-versus-Dirac-flow matrix bound over every retained scaled momentum, and
convergence for arbitrary retained mode sequences. The explicit positive
x-face mode is proved retained, has represented physical momentum exactly
`N + 1`, and has its own convergence theorem. This is the scaled multiplier
theorem, not yet the approximation of arbitrary `L2(R^3)` data by the changing
cells.

### D-R3-4. Global physical-space convergence

**Status: dense-core sampler and arbitrary-`L2` regularity bridge landed;
operator/live-flow composition still open.**
`PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling` defines the actual
cell-center piecewise-constant sampler on finite unions of the half-open cells.
For a Lipschitz field whose support is covered by the selected cells, it proves

```text
integral |sample_N f - f|^2
  <= card(s_N) h_N^3 * (L h_N / 2)^2.
```

Hence any positive mesh `h_N -> 0` with uniformly bounded represented physical
volume gives global squared-`L2` convergence to zero. This is a concrete
compact-support dense core, not an abstract approximation hypothesis.

`PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density` now proves the exact
regularity bridge. Every complex `L2(R^3)` field admits a compactly supported
smooth approximant in `eLpNorm`; the same approximant has one global Lipschitz
constant and therefore satisfies the sampler's regularity hypothesis. The
noncompact quadratic `x -> (x_0)^2` is smooth but has no global Lipschitz
constant, proving compact support is load-bearing.

Compose:

```text
scaled live bulk bound
-> exact cell-isometry embedding
-> ChangingLatticePDECore.band_approx_tendsto_zero
-> Mathlib L2 Fourier-transform isometry
-> position-space Dirac-flow convergence.
```

The exact continuum solution must be identified as the Dirac flow, not merely
named `exact` in an abstract convergence theorem.  The center-value sampler is
the correct dense-core approximation for fixed continuous representatives, but
it cannot be extended as a bounded operator on arbitrary `L2`: point values are
not invariant under almost-everywhere equality.  A one-point spike is zero in
`L2` and is nevertheless read as one at the chosen center.  This obstruction
is now kernel-checked in `ChangingMomentumPointSamplerNoGo`: the same module
proves that normalized cell averaging is AE-invariant, kills the point spike,
and reproduces the constant-one function exactly for positive cell size.

The arbitrary-`L2` successor must therefore use normalized cell averages (or
another bounded finite-rank projection).  Prove that projection is
AE-invariant, an `L2` contraction, correctly normalized on constants, and
strongly convergent as the cells refine and exhaust `R^3`.  Then run the
three-epsilon argument on the landed smooth Lipschitz approximants, apply the
live multiplier to those same projected fields, and compose with the `R^3`
inverse Fourier isometry.

## Existing Lean anchors

- `ChangingModeEmbedding`: finite-box restriction, zero padding, and complete
  coefficient-tail convergence.
- `SobolevTailRate`: quantitative weighted coefficient tails.
- `FullLiveCoefficientConvergence`: actual live retained-mode dynamics plus
  exact omitted-mode tail.
- `TorusL2LiveWalk`: exact fixed-torus Parseval transport.
- `ChangingLatticePDECore`: abstract measurable bulk/tail composition.
- `ChangingMomentumCellSampling`: concrete compact-support Lipschitz sampler
  and global squared-`L2` rate.
- `ChangingMomentumL2Density`: arbitrary-`L2` compact smooth approximation,
  global Lipschitz extraction, and noncompact quadratic boundary control.
- `ChangingMomentumPointSamplerNoGo`: point sampling fails AE invariance;
  normalized one-cell averaging respects representatives and constants.
- Mathlib `MeasureTheory.Lp.fourierTransformₗᵢ`: `L2(R^d)` Fourier isometry.

## Literature anchors

- Arrighi, Forets, and Nesme, `arXiv:1307.3524`: continuum Dirac convergence
  is a convergence theorem for the evolution, not only a multiplier slogan.
- Maeda and Suzuki, `arXiv:1902.02017`: compares `delta Z` with `R` through
  Shannon interpolation and proves Sobolev convergence.

## Claim and kill discipline

The current defensible claim includes strong `L2(R^3)` convergence of the
concrete changing-cell sampler on a compact-support Lipschitz dense core. It
does not yet include the live walk or position-space PDE in that same theorem.
Upgrade to the physical Dirac-flow claim only after D-R3-1 through D-R3-4
compose on the same scaling schedule.

Kill conditions:

- `h_N` stays fixed: the result remains periodic/fixed-torus;
- `N h_N` stays bounded: the physical momentum domain does not exhaust `R^3`;
- the cell normalization is absent or wrong: coefficient and continuum norms
  are not isometric;
- the live symbol is evaluated at unscaled `k`: the changing-lattice theorem is
  about a different evolution;
- the final theorem converges to an abstract field without identifying the
  Dirac flow: the PDE claim has not landed.
