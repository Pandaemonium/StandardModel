# P9 physics development: source visibility, noise, and Lambda scaling

**Status:** physics development note, 2026-06-24.
**Related docs:** `Sources/Null_Edge_P9_Source_Visibility_Manuscript_Outline.md`,
`Sources/Null_Edge_Key_Conjectures.md`,
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`, and
`AgentTasks/aristotle-p9-diamond-visibility-api-design-report.md`.

## Executive conclusion

The strongest physical reading of P9 is not:

```text
finite source visibility directly explains the observed cosmological constant.
```

The stronger and more honest reading is:

```text
finite source visibility can separate local vacuum bookkeeping from the
gravitationally visible source channel. It may suppress local bulk vacuum noise
too strongly to be the observed dark energy by itself, while leaving a global or
harmonic residual mode as the candidate for the observed Lambda-scale signal.
```

This distinction matters. Sorkin's everpresent-Lambda mechanism gives a residual
RMS scale

```text
delta Lambda ~ sqrt(V) / V = V^(-1/2)
```

when the fluctuating count is controlled by spacetime volume `V`. In four
spacetime dimensions, `V ~ L^4`, so this is `L^(-2)`, exactly the right order
for a Hubble-scale cosmological constant. If P9 replaces the fluctuation count
by a codimension-two screen area `A ~ L^2`, the residual becomes

```text
delta Lambda_screen ~ sqrt(A) / V ~ L / L^4 = L^(-3) = V^(-3/4).
```

That beats the everpresent-Lambda benchmark, but it may beat it too well: at a
Hubble radius this is far below the observed `L^(-2)` scale. If the relevant
screen object is a null hypersurface measure `B ~ L^3`, the scaling is

```text
delta Lambda_nullBoundary ~ sqrt(B) / V ~ L^(3/2) / L^4 = L^(-5/2) = V^(-5/8),
```

which is still more suppressed than `V^(-1/2)`.

The physics lesson is therefore:

> P9 is most naturally a local vacuum-source filtering or sequestering
> mechanism. The observed nonzero dark energy should not be identified with the
> fully filtered local boundary residual unless an additional coherent,
> horizon-scale, or global harmonic mode restores an `L^(-2)` contribution.

This gives the program a sharper failure mode and a sharper opportunity.

## The two-component residual model

The finite diamond source should be decomposed schematically as

```text
J = J_exact + J_local_visible + J_harmonic.
```

Here:

- `J_exact` is boundary-exact or pure bookkeeping. It is killed by closed
  curvature-defect tests through finite integration by parts.
- `J_local_visible` is a local Pluecker/closure defect. It is visible to a
  pre-specified diamond observer and should behave like ordinary localized
  stress-energy.
- `J_harmonic` is a global, topological, or unimodular residual mode. It is not
  boundary-exact, but it is also not a local UV vacuum fluctuation.

The corresponding covariance decomposition is

```text
C_J = C_exact + C_local_visible + C_harmonic + cross terms.
```

For an observer projection `P_obs` onto curvature-visible tests, the physically
important finite quantity is

```text
Var_obs(J) = Tr(P_obs C_J P_obs^T).
```

P9 succeeds as a source-visibility mechanism if it proves that

```text
P_obs C_exact P_obs^T = 0
```

or at least that this term is screen-suppressed, while

```text
P_obs C_local_visible P_obs^T != 0
```

for explicit finite visible defects.

P9 becomes cosmologically interesting only if it also identifies what survives
in `C_harmonic`. There are two physically different cases:

1. **All local vacuum bookkeeping is filtered, and no global residual survives.**
   This is a strong vacuum-energy suppression result, but not an explanation of
   the observed nonzero dark energy.
2. **Local vacuum bookkeeping is filtered, but a global/harmonic/unimodular
   residual survives with `V^(-1/2)` scaling.** This keeps the Sorkin order of
   magnitude while giving a structural reason why ordinary local UV vacuum
   bookkeeping does not contribute a bulk mean source.

The second case is the most attractive physics target.

## Relation to the literature

The source-visibility branch sits at the intersection of four existing
literatures.

First, causal-set everpresent Lambda predicts a fluctuating cosmological term
whose RMS is controlled by spacetime volume. The original Ahmed-Dodelson-Greene-
Sorkin model (`ZP7E648U`) and Sorkin's later causal-set residue framing
(`G3FT8BXC`) motivate the `V^(-1/2)` benchmark. Das-Nasiri-Yazdi (`K5CFI3HI`,
`IHVSDGUC`) sharpen the modern phenomenological and observational pressure.

Second, Sorkin-Johnston states provide a causal-set-native reference state from
the Pauli-Jordan operator. The important warning from Sorkin-Yazdi (`G2JGSV9B`)
and Surya-Nomaan-Yazdi (`PU8Q5WKT`) is that causal-set entanglement entropy can
obey a volume law unless the SJ spectrum is truncated; an area law appears only
after a physically meaningful spectral truncation. For P9 this says the
observer channel cannot be arbitrary. A spectral/bandlimit observer is a serious
candidate for a natural coarse channel.

Third, stochastic gravity (`PRCWRMFC`, `TXN5JSZ5`) says zero mean is not enough.
The stress-energy noise kernel is physically real, and metric response depends
on stress-tensor correlations, not just expectation values. P9 must therefore
prove a covariance-projection or variance-bound theorem, not merely a mean-zero
lemma.

Fourth, causal-diamond thermodynamics (`2ZZTQS43` and Jacobson's entanglement
equilibrium program) gives the correct geometric scale for finite diamonds:
area, volume, modular/diamond Hamiltonians, and the cosmological-constant
variation appear in one first-law setting. This is the continuum pressure that
the finite `DiamondScreen` API should respect.

## A concrete finite target

The next finite theorem stack should use the new `DiamondScreen` API:

```text
DiamondScreen:
  cells -> faces -> rim, with d o d = 0

DiamondMeasure:
  cellVol, faceArea, rimLen

CurvatureDefect:
  closed face tests, interpreted as linearized diamond holonomy defects

Observer:
  a pre-specified projection onto readable source channels
```

The first physics-bearing theorem should be:

```text
boundary_exact_noise_invisible_to_closed_curvature_tests
```

Informally:

```text
If J = dB and t is a closed curvature-defect test, then
<J,t>_mu = 0.
Consequently, if a source covariance C is supported in the boundary-exact
subspace, then Tr(P_closed C P_closed^T) = 0.
```

The second theorem should be the finite scaling bound:

```text
screen_supported_residual_variance_bound
```

Informally:

```text
If the projected residual is supported on N_screen independent screen cells
with bounded variance sigma^2, then
RMS(delta Lambda) <= sigma * sqrt(N_screen) / V.
```

The third theorem should deliberately keep the global mode:

```text
harmonic_residual_not_removed_by_boundary_exactness
```

Informally:

```text
Boundary-exact filtering kills exact local bookkeeping but does not kill the
finite harmonic quotient H = closed / exact. Any cosmological residual must live
in this quotient or in a separately specified visible source sector.
```

This last theorem prevents an accidental overclaim. It says exactly where a
surviving Lambda-scale mode could live.

## Physical predictions and falsifiers

### Prediction 1: local UV bookkeeping is not the observed Lambda

If P9 is right, the huge local vacuum bookkeeping does not appear as a bulk
volume source under the gravitational observer channel. It is exact, paired,
projected away, or confined to a sector invisible to closed curvature-defect
tests.

Falsifier: a natural finite diamond observer channel sees generic local vacuum
bookkeeping with volume variance and no symmetry, Hodge, or spectral reason for
cancellation.

### Prediction 2: visible matter defects are not filtered

The observer channel must still see local closure defects, Pluecker mass
excitations, and ordinary stress-energy-like sources.

Falsifier: the same projection that removes vacuum bookkeeping also removes
localized visible defects, making the model observationally empty.

### Prediction 3: any observed dark-energy residual is global or harmonic

If the screen-filtered residual scales faster than `V^(-1/2)`, the observed
dark energy must come from a surviving global/harmonic/unimodular mode, not from
local screen noise.

Falsifier: no natural harmonic/global quotient remains after imposing the finite
diamond constraints, and the boundary residual is far too small.

### Prediction 4: spectral truncation matters

The Sorkin-Johnston literature suggests that area-law behavior can depend on a
spectral truncation. In P9 language, the observer channel may need to be a
spectral/bandlimited readout, not a hand-chosen projection.

Falsifier: the required truncation is arbitrary, state-dependent, or chosen only
after seeing the desired suppression.

## Immediate action items

1. Build `PhysicsSM.Draft.NullEdgeP9DiamondScreen` with the API from the
   Aristotle design report, but keep it draft until the statements stabilize.
2. Prove the mean and covariance versions of boundary-exact invisibility.
3. Prove the finite screen-supported variance bound and record the scaling
   exponents for codimension-one and codimension-two observer supports.
4. Add a harmonic quotient theorem: exact filtering leaves `closed / exact` as
   the only candidate location for a global residual.
5. Connect the SJ reference-state module to the observer-channel choice:
   `iDelta` Hermiticity is only the first step; the real physics is the positive
   spectral projector and the truncation that determines area versus volume
   behavior.
6. Keep the paper claim modest: "finite source visibility and vacuum filtering"
   first; "observed cosmological constant" only after the harmonic/global mode
   has a quantitative model.

## Revised thesis for P9

P9 should be framed as follows:

> A finite causal-diamond observer does not couple to all microscopic source
> bookkeeping. Boundary-exact and spectrally projected vacuum data can be
> invisible to closed curvature-defect observers, while localized Pluecker or
> closure defects remain visible. This can provide a finite source-filtering
> mechanism for local vacuum energy. The observed nonzero cosmological constant,
> if addressed at all, should be assigned to a surviving global or harmonic
> residual mode whose scaling must be compared explicitly with the causal-set
> everpresent-Lambda `V^(-1/2)` benchmark.
