# Phenomenology card: what the HNU and mass-response theorems can cash out

Date: 2026-07-20
Role: Codex / Phenomenologist
Work item: `QCA-3PLUS1-001`, with consequences for `MASS-ORIGIN-001`

## Claim ceiling

The current HNU results establish an exact local unitary Floquet regulator with
a Weyl infrared tangent, a full-Brillouin-zone exclusion of zero and pi
crossings after the declared Pluecker mass perturbation, and an explicit
changing-window operator convergence schedule. They do not yet predict a
particle mass, a lattice spacing, an ultraviolet scale, or a measurable
Lorentz-violation coefficient.

The origin-of-mass results classify several finite response operators and now
prove that a gap is insufficient without observable overlap. They do not yet
derive Standard Model Yukawa values, the Higgs pole, Lambda_QCD, or a physical
two-point pole.

## Observable card 1: HNU regulator error

**Quantity.** For physical momentum `q`, time `t`, and microscopic step count
`n`, compute

```text
delta(q,t,n) = ||W_HNU(q,t/n)^n - exp(-i t q.sigma)||.
```

**Units.** Dimensionless until a lattice time and momentum unit are supplied.

**Derived input.** The HNU endpoint, exact unitarity, `Cbound(q)`, and the
kernel-checked estimate `delta <= Cbound(q) t^2/n`.

**Chosen schedule.** `adaptiveSteps(R,t,N)` from
`HNUCompactMomentumContinuum.lean`, where `qAbs(q_N) <= R_N`. The resulting
envelope error is at most `1/(N+1)`.

**Baseline.** The exact continuum Weyl multiplier at the same momentum and
time. Compare on the same norm and Fourier convention.

**Controls.** Origin-axis nonzero generator; full zero/pi census; the older
separable split walk; at least one high-momentum boundary sequence.

**Held-out quantity.** After an explicit physical scale map is supplied, test
the leading anisotropic correction at momenta not used to choose the schedule.
Do not select the scale after seeing that correction.

**Error model.** The present theorem controls deterministic discretization
error only. Experimental, finite-volume, interaction, and scale-setting errors
are absent.

## Observable card 2: mass response visibility

**Quantity.** For a positive/self-adjoint reconstructed evolution and a
gauge-invariant observable `O`, extract the spectral weight and the leading
connected-correlation decay rate.

**Required data.** The evolution, physical-sector embedding, vacuum,
observable, normalization, and continuum map. The operator spectrum alone is
not enough.

**Finite controls.** `GapPoleResponseObstruction` holds the spectrum fixed and
changes physical-direction overlap from one to zero.
`TransferCorrelationMassFalsifier` holds the transfer operator fixed and
changes the observable. These are overlap controls, not pole-mass models.

**Baseline.** Standard spectral decomposition or lattice transfer-matrix
extraction with the same observable quantum numbers.

**Held-out quantity.** In the first nonabelian witness, preregister one
gauge-invariant channel and ask whether its extracted gap agrees with the
Hamiltonian/transfer eigenvalue without fitting an extra response coefficient.

## Nearest externally meaningful milestones

1. Compose the HNU adaptive window bound with normalized cell projection,
   intra-cell multiplier control, inverse Fourier transport, and the exact Weyl
   generator. This would establish finite-time position-space `L2`
   convergence for a declared input class.
2. Add one scale-setting prescription and calculate the first regulator
   correction. Until then there is no laboratory unit or numerical bound.
3. Construct a normalized positive nonabelian transfer operator, a connected
   gauge-invariant correlator, and a bright/dark overlap pair. This is the
   minimum honest composite-mass benchmark.
4. Only after the above, compare the same held-out quantity against a standard
   lattice/QCA baseline at equal computational and parameter budgets.

## Kill conditions

- The changing-cell HNU composition fails because the growing-window schedule
  cannot be made common, local, or norm stable.
- A legitimate timeframe or branch change invalidates the zero/pi ledger.
- The first local interaction mixes the intended sector with compensating
  modes.
- Every proposed mass observable has zero overlap with the selected finite gap.
- A physical scale can be introduced only by fitting the observable that is
  advertised as a prediction.

## Phenomenology verdict

The most consequential immediate theorem is the full HNU changing-lattice
`L2` composition, not a more elaborate microscopic picture. It converts the
regulator into recovered relativistic dynamics. The most consequential mass
theorem is positive observable-overlap reconstruction, not another internal
gap identity. Those two results would make the program calculationally
comparable to established physics while keeping all dimensionful inputs
visible.
