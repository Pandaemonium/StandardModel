# Aristotle semantic context pack

Generated: 2026-07-15T19:29:54
Query: `causal operator Poisson smeared kernel discrete concentration variance ell over L local Alexandrov germ A41 A42`

Use this as context, not as proof. Verify every imported theorem
statement and source convention against the live repo before relying on it.

## Repo docs and Lean hits

### 1. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.49 Stage A41c passes deterministic continuum normalization]

Score: `0.791`

```text
### 3.49 Stage A41c passes deterministic continuum normalization

A41 evaluates the exact Poisson mean of the published smeared four-dimensional
kernel on the marked flat germ. For Poisson interval mean \(\lambda\),

\[
  \mathbb E[f(N,\epsilon)]
  =e^{-\epsilon\lambda}
   \left(1-9z+8z^2-\frac43z^3\right),
  \qquad z=\epsilon\lambda.
\]

The project-sign continuum operator is integrated on the six classes
\(1,t,t^2,x_1^2,t^3,tx_1^2\), after multiplication by each of two frozen
smooth count-depth profiles. A41c splits the quadrature at every analytic
outer cutoff intersection and inner proper-volume branch. Every order
`160/240` comparison passes.

At `L/R=0.065`, the primary and robustness profiles both give Lorentzian
signature, metric error about `0.03`, response-ratio error below `0.07`,
`Delta_ps` below `0.03`, and maximum nominally zero response below `0.15`.
Across the frozen scale sequence, metric error falls by `84.5%` and `89.0%`.
No scalar, drift, rank-one, or potential correction is used.

A41c therefore passes the **deterministic continuum-normalization subgate**.
It shows that A39/A40 are not explained by a wrong asymptotic scalar
normalization. It does not show that a random finite operator concentrates,
nor does it construct an intrinsic mesoscopic algebra. The finite A41d target
extension separately certifies quadrature at `L/R=0.20,0.16`; it is not a new
asymptotic gate. Full results are in
`AgentTasks/null-edge-causal-continuum-kernel-moments-stage-a41c-benchmark-2026-07-15.md`.
```

### 2. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.50 Stage A42 rejects the first discrete concentration schedule]

Score: `0.782`

```text
### 3.50 Stage A42 rejects the first discrete concentration schedule

A42 evaluates one live project-sign operator row at the marked center of flat
random sprinklings. The operator coefficients, interval counts, cutoff depth,
and density scale are order/count constructions; coordinates enter only to
sprinkle the flat order and supply oracle polynomial fields. Every sample is
compared with the A41d finite-scale target, not directly with the asymptotic
d'Alembertian.

The held-out `N=20000`, four-realization ensemble gives:

| cutoff | `L/R` | `ell/L` | field error | metric error | `Delta_ps` difference | signature rate |
|---|---:|---:|---:|---:|---:|---:|
| primary | 0.20 | 0.51 | 3.65 | 0.47 | 0.40 | 0.50 |
| primary | 0.16 | 0.63 | 4.83 | 1.15 | 0.12 | 0.25 |
| robustness | 0.20 | 0.51 | 4.16 | 0.31 | 0.24 | 1.00 |
| robustness | 0.16 | 0.63 | 5.60 | 0.66 | 0.16 | 0.25 |

All exact coefficient, endpoint-cutoff, and scale-admissibility checks pass,
but every stratum fails the field and metric thresholds. Metric error improves
with density in all four strata, while field error improves only at `0.16`;
individual errors remain much larger than ensemble-mean errors. The result is
therefore a **kill for this density/scale/averaging schedule**, not for the
continuum kernel. Merely requiring `ell<L` is insufficient: the tested
`ell/L=0.51-0.63` high-density values do not realize the needed
\(\ell\ll L\) hierarchy.

This sharpens the one-operator program proposed above. The next graph-side
task is an analytic variance/concentration audit followed by a preregistered
schedule with substantially smaller `ell/L` or explicit mesoscopic averaging.
Only after row-level finite-target concentration should a local function
subspace be selected by product closure, operator closure, mult
```

### 3. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [3.47 Stage A40 kills global projected weak geometry]

Score: `0.780`

```text
core.

A40 therefore kills a **global projected degree-two calculus** for the current
retarded operator, region, densities, and schedule. It does not kill A38's
operator identities or weak geometry: the same implementation passes when a
local d'Alembertian is supplied. The next graph-side move must change the
operator normalization or locality architecture, not merely polynomial degree
or projection topology. The two admissible successors are an analytic
derivation of the retarded kernel's temporal/spatial response, or a genuinely
local Alexandrov algebra germ with a protected inner core and shrinking
core/patch ratio. Full results are in
`AgentTasks/null-edge-causal-projected-weak-geometry-stage-a40-benchmark-2026-07-15.md`.
```

### 4. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Finite position kernels and a controlled $3+1$ extension]

Score: `0.777`

```text
its a compactly supported smooth approximant with arbitrarily small
  $L^2$ error, and that same approximant has one global Lipschitz constant.
  Compact support is load-bearing: the smooth noncompact quadratic
  $x\mapsto x_0^2$ has no global Lipschitz constant.

  There is a sharp representative-level obstruction to extending this center
  sampler to arbitrary $L^2$.  A function equal to one at a single cell center
  and zero elsewhere is zero almost everywhere, but center sampling reads the
  value one; sampling the AE-equal zero function reads zero.  Thus the center
  sampler is not AE-invariant and cannot define a bounded operation on $L^2$
  equivalence classes.  This no-go is NewResult{} Kernel{}, not merely an
  analytic warning.  Normalized cell averaging supplies the correct first
  repair: it is AE-invariant, sends the one-point spike to zero, and returns
  exactly one on the constant-one function for every positive cell size.

  The representative-safe repair has now advanced substantially.  The finite
  cell-average projection is an exact $L^2$ contraction; compact support is
  eventually covered by the explicit expanding schedule; only the active
  cells, not the full growing box, have a uniform volume bound; and the exact
  three-term transfer estimate has constants $6$ and $3$.  The final epsilon
  composition to arbitrary $L^2$ data is a separate capstone now under kernel
  verification.  Beyond it remain the identification of cell averages with
  coefficients evolved by the live walk, composition with
  \eqref{eq:scaledlivebound}, and inverse continuum Fourier identification of
  the position-space Dirac flow.  We do not yet claim that final PDE theorem.

The same architecture extends to four internal components.  The
successive-axis factorization itse
```

### 5. `AgentTasks/aristotle-downloads/f0d38cd0-cdec-46ef-800b-b588e3e07740/output-final_aristotle/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` [Finite position kernels and a controlled $3+1$ extension]

Score: `0.776`

```text
its a compactly supported smooth approximant with arbitrarily small
  $L^2$ error, and that same approximant has one global Lipschitz constant.
  Compact support is load-bearing: the smooth noncompact quadratic
  $x\mapsto x_0^2$ has no global Lipschitz constant.

  There is a sharp representative-level obstruction to extending this center
  sampler to arbitrary $L^2$.  A function equal to one at a single cell center
  and zero elsewhere is zero almost everywhere, but center sampling reads the
  value one; sampling the AE-equal zero function reads zero.  Thus the center
  sampler is not AE-invariant and cannot define a bounded operation on $L^2$
  equivalence classes.  This no-go is NewResult{} Kernel{}, not merely an
  analytic warning.  Normalized cell averaging supplies the correct first
  repair: it is AE-invariant, sends the one-point spike to zero, and returns
  exactly one on the constant-one function for every positive cell size.

  The representative-safe repair has now advanced substantially.  The finite
  cell-average projection is an exact $L^2$ contraction; compact support is
  eventually covered by the explicit expanding schedule; only the active
  cells, not the full growing box, have a uniform volume bound; and the exact
  three-term transfer estimate has constants $6$ and $3$.  The final epsilon
  composition to arbitrary $L^2$ data is a separate capstone now under kernel
  verification.  Beyond it remain the identification of cell averages with
  coefficients evolved by the live walk, composition with
  \eqref{eq:scaledlivebound}, and inverse continuum Fourier identification of
  the position-space Dirac flow.  We do not yet claim that final PDE theorem.

The same architecture extends to four internal components.  The
successive-axis factorization itse
```

### 6. `AgentTasks/24h-publication-run-2026-07-12/D_R3_SHANNON_BRIDGE_PROGRAM.md` [D-R3-4. Global physical-space convergence]

Score: `0.763`

```text
ended as a bounded operator on arbitrary `L2`: point values are
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
```

### 7. `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` [G2. Operator metric and unique scale reconstruction]

Score: `0.762`

```text
s region-mean pairing is not stably Lorentzian.
Johnston generators do not consistently beat random controls. This kills the
tested global region and strong `L2` topology, not the degree-two envelope as
basis-independent bookkeeping.

Stage A40 then projects every `Box`, `Gamma`, Hessian, and `Gamma2`
intermediate back into that envelope. The nonlinear flat-chart Hessians remain
nonzero, so the test is not vacuous, but the flat Ricci residual stays near
one and barely improves with density. The same projected implementation gives
roundoff-zero flat Ricci for an ordinary centered finite-difference
d'Alembertian. The causal failure therefore points to the retarded kernel's
continuum normalization, boundary/nonlocal contamination, or the use of a
global algebra rather than an implementation error.

The next G2 fork is consequently analytic and local. First derive the
retarded kernel's continuum moments on constants through representative
cubics, including temporal/spatial response and boundary terms, and determine
whether a coordinate-free operator correction can recover the required
second-order symbol. In parallel, specify a genuinely local Alexandrov algebra
germ with an outer patch, protected inner core, and exact retarded-support
condition. The next numerical stage must be selected by that audit and must
again pass both nonlinear flat Ricci cancellations before any curved-Ricci
comparison. Pointwise second jets remain a secondary cross-check.

Stages A41c-A42 resolve the first part of that fork. The exact Poisson-mean
kernel has the correct asymptotic scalar normalization on both frozen local
germs without the A29 rank-one correction. The first discrete schedule does
not concentrate around its finite-scale moments: at `N=20000`, `ell/L` remains
`0.51-0.63`, all four f
```

### 8. `PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean` [without]

Score: `0.761`

```text
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling.sampleFinite_tendsto_sq_error_zero

/-! ### ChangingMomentumL2Density: arbitrary-L2 compact approximation and
global Lipschitz extraction for compactly supported smooth functions. -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.memLp_exists_continuous_compact_sq_approx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.memLp_exists_continuous_compact_sq_approx

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.compactSupport_contDiff_exists_global_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.compactSupport_contDiff_exists_global_lipschitz

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.memLp_exists_compact_global_lipschitz_eLpNorm_approx' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.memLp_exists_compact_global_lipschitz_eLpNorm_approx

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.quadraticAxis_not_global_lipschitz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density.quadraticAxis_not_global_lipschitz

/-! ### ChangingMomentumPointSamplerNoGo: exact AE-invariance obstruction for
center sampling and normalized one-cell average controls. -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChangingMomentumPointSamplerNoGo.sampleFinite_not_ae_invariant' depends on a
```

## Scoped paper hits

### 1. Local d'Alembertian for causal sets

Score: `0.758`
Zotero key: `I72KXVQA`
arXiv: `2506.18745`

### 2. Correction terms for propagators and d'Alembertians due to spacetime discreteness

Score: `0.736`
Zotero key: `arxiv:1411.2614`
arXiv: `1411.2614`
DOI: `10.1088/0264-9381/32/19/195020`
URL: http://arxiv.org/abs/1411.2614

Abstract:

Finite-sprinkling correction terms for causal-set retarded propagators and d'Alembertian operators compared with continuum limits.

### 3. Toward a spectral theory of cellular sheaves

Score: `0.728`
Zotero key: `CWXAFIF4`
DOI: `10.1007/s41468-019-00038-7`
URL: https://doi.org/10.1007/s41468-019-00038-7

### 4. Locality properties of Neuberger's lattice Dirac operator

Score: `0.724`
Zotero key: `BEG87SU5`
arXiv: `hep-lat/9808010`
URL: https://arxiv.org/abs/hep-lat/9808010

### 5. Frustration index and Cheeger inequalities for discrete and continuous magnetic Laplacians

Score: `0.717`
Zotero key: `FNP9V3DT`
DOI: `10.1007/s00526-015-0935-x`
URL: https://doi.org/10.1007/s00526-015-0935-x
