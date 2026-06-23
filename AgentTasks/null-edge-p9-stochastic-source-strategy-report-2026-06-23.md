# P9 stochastic-source guardrail: strategy report

Date: 2026-06-23

Aristotle project: `e818cb6b-006a-4b7b-9c1c-921d18946413`

Branch: P9, cosmological-constant source visibility from diamond closure.

Guardrail source: Hu and Verdaguer stochastic gravity (`PRCWRMFC`).

Status: strategy/scaffold only. The returned scaffold is useful, but it leaves
eight theorem targets as proof handoffs and should not be integrated as live
draft Lean until those holes are closed.

## Main correction

Mean-zero finite bookkeeping is not gravitational invisibility. Stochastic
gravity separates the mean stress tensor from the fluctuation/noise-kernel
source. Therefore the existing finite P9 results proving mean zero plus a
nonzero second moment should be read as a warning: they may still source
metric fluctuations unless the observer channel, boundary condition, or response
functional also kills the noise response.

The corrected predicate is:

```text
GravInvisible := MeanInvisible and NoiseInvisible.
```

This is stronger than the older branch language, where "mean-zero" or
"boundary-only" could sound sufficient.

## Minimal finite API proposed

The returned scaffold proposes a finite `DiamondNoiseSource` with:

- a finite cell set `Cell`;
- a finite configuration set `Cfg`;
- `source : Cfg -> Cell -> Real`;
- `weight : Cfg -> Real`.

It then separates:

- `meanSource`, `meanTotal`, and `meanResponse`;
- `noiseKernel`, `noisePower`, and `noiseResponse`;
- per-configuration boundary-exactness;
- mean-boundary-exactness;
- mean invisibility, noise invisibility, and gravitational invisibility.

The most important proposed observable is:

```text
noiseResponse s t = sum_{c,d} t c * t d * noiseKernel s c d.
```

This is the finite analogue of contracting a noise kernel against a diamond
test/window. It is the right object for the next proof job, because it asks
whether fluctuations are visible to the observer, not merely whether the mean
vanishes.

## Proposed theorem targets

The returned scaffold lists eight finite targets:

- `exists_meanZero_noise_nonzero`;
- `noiseKernel_self_nonneg`;
- `meanInvisible_imp_meanResponse_zero`;
- `noiseInvisible_imp_noiseResponse_zero`;
- `gravInvisible_imp_allResponses_zero`;
- `exists_meanZero_noiseResponse_nonzero`;
- `meanBoundaryExact_meanResponse_zero_of_closed`;
- `exists_meanBoundaryExact_closed_noiseResponse_nonzero`.

Together these block the false inference:

```text
mean-zero source -> gravitationally invisible source.
```

The deepest distinction is between:

- per-configuration boundary-exactness, which kills each closed-test pairing and
  therefore kills the corresponding noise response; and
- mean-boundary-exactness, which kills only the mean and can leave a nonzero
  fluctuation response.

## Next Aristotle job

Submit a proof-only job:

```text
null-edge-p9-diamond-noise-source-core
```

Target: prove the eight `DiamondNoiseSource` targets above in a focused package.
The finite witnesses should be over `Fin 1` and `Fin 2`; the structural lemmas
should be definitional `Finset.sum` unfoldings plus nonnegativity of squares.

Claim boundary: this proves a finite guardrail, not a cosmological-constant
solution, continuum gravity result, or everpresent-Lambda amplitude law.

## Demotion criteria

Demote P9 from "cosmological-constant leverage" to "research lane" if any P9
claim:

- uses mean-zero source bookkeeping as invisibility while `noiseResponse`
  remains alive;
- uses boundary closure without distinguishing mean-boundary-exactness from
  per-configuration boundary-exactness;
- states suppression only on a bare second moment rather than on an
  observer-visible noise response;
- imports P7 recoverability as if it were source invisibility;
- lacks a response law or observational scaling comparison.
