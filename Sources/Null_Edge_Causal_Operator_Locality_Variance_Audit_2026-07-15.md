# Causal-operator locality and variance audit

Date: 2026-07-15  
Status: literature audit and successor decision  
Scope: G2 operator-metric reconstruction in the null-edge GR program

## Question

Does the A42-A43 finite-concentration failure invalidate the retarded
Benincasa-Dowker operator, and should the next experiment increase its
nonlocality scale, average it regionally, or test a genuinely local intrinsic
operator?

## Source-locked facts

1. Benincasa and Dowker introduce a retarded, Lorentz-invariant, nonlocal
   four-dimensional causal-set operator whose continuum mean approaches the
   scalar d'Alembertian on slowly varying fields. On curved backgrounds the
   same mean approaches the d'Alembertian minus one half the scalar curvature.
   **T [import]** within the assumptions and conventions of their paper.

2. Aslanbeigi, Saravani, and Sorkin study continuum averages of generalized
   retarded nonlocal operators. Their original four-dimensional example has
   unstable continuum modes. This is a spectral statement about continuum
   evolution, not the finite-sprinkling row-variance problem measured by A42.
   **T [import]** for the paper's analyzed family; it must not be cited as an
   explanation of A42 without a separate bridge.

3. Boguna and Krioukov exhibit failures of standard nonlocal operators on
   fields with noncompact support. Their constant-field divergence uses a
   global constant field. For a fixed finite support, they explicitly recover
   convergence and emphasize that the support and density limits do not
   commute. **T [import]** in their `(-,+,+,...)` convention.

4. Therefore their noncompact-support examples do not contradict A41c. A41c
   acts on compact smooth tapered germs and takes the density limit with the
   germ fixed before any enlargement of support. **T|H [interp]**, conditional
   on preserving that order of limits in the proposed refinement theorem.

5. Boguna and Krioukov also propose an intrinsic local causal-set operator.
   It combines a chain-selected temporal second difference with averages over
   distance-selected spatial neighborhoods. In their notation,

   \[
     B=-(C+d+1)D_t+C D_s,
   \]

   and converges to their `(-,+,+,...)` d'Alembertian in Minkowski controls.
   They report numerical concentration in `2+1` dimensions over densities
   from `10^4` to `3x10^6`, and state that a retarded variant can be defined.
   Spatial averaging is used to suppress first-derivative contamination.
   **T [import]** only for the construction and limits actually analyzed in
   the paper.

6. The spatial-distance input used by that local operator is itself a
   reconstruction pipeline. For unrelated events `a,b` and a common-past
   event `c`, the finite causal overlap is the common Alexandrov count divided
   by the smaller of the two Alexandrov counts. Converting this dimensionless
   ratio into a distance also uses a proper-time estimate for `c` and either a
   dimension-dependent inverse function or an asymptotic dimension-dependent
   coefficient. The paper's numerical acceleration filter additionally uses
   density and dimension, although its second overlap filter can be used
   intrinsically. **T [import]** for the paper's construction. Therefore the
   local operator does not independently solve dimension or absolute-scale
   reconstruction from a bare order. **T|H [interp]**.

## Convention lock

The null-edge program uses signature `(+---)` and

\[
  \Box=\partial_t^2-\sum_i\partial_i^2.
\]

The Boguna-Krioukov paper uses the opposite sign. Any benchmark must negate
their displayed operator before comparing principal symbols, corrected
pairings, or metric signatures with A41-A43. Their available numerical study
is `2+1`, while G2 requires a four-dimensional audit; dimensional constants
and distance-estimator errors must be rederived rather than copied.

`PhysicsSM/Draft/NullEdge/FiniteCausalOverlap.lean` formalizes the exact finite
count ratio, proves symmetry, bounds it in `[0,1]`, and proves relabeling
equivariance. It intentionally stops before the dimension/proper-time/scale
conversion.

## What A41-A43 now establish

- A41c passes the compact-germ deterministic continuum-mean gate for two
  tapered profiles in a small Lorentzian scale window.
- A42 rejects the tested one-row finite-sprinkling schedule at `N=20000`.
- The exact diagonal second moment explains much of the observed fluctuation
  and exposes the conditional amplitude scale `ell^2/L^4`.
- A43 shows that increasing `L` enough to reduce one-row noise leaves the
  two-profile Lorentzian-mean window. Its held-out seed was not opened.

These results are a finite **no-overlap result for the tested schedule**, not a
no-go theorem for compact nonlocal operators and not a derivation of a better
operator.

## Final concentration audit

Aristotle project `bcefd810-9c50-479d-a8b3-d5c1eef964c7` independently
confirmed the exact one-count Poisson moment calculation and found that the
finite-binomial correction is much smaller than the A42 discrepancy. Its
falling-factorial product proof and conditional concentration wrapper were
integrated into
`PhysicsSM/Draft/NullEdge/CausalOperatorKernelMoments.lean`, with explicit
nonnegative variance scale and positive effective sample size hypotheses.

The audit does not provide the missing total-variance bound. Random atoms,
two-sided taper depth, and shared-sprinkling covariance remain in that
hypothesis. Its nominal `N=400000` planning point would require about `20 GB`
for a dense causal bit matrix before overhead, and its coordinate-selected
pivots are inadmissible under the A44 order-only protocol. No such random run
is authorized before a reusable interval-count prototype and a frozen
tied-depth pivot schedule establish a feasible resource envelope.

## Successor decision

Keep two explicit branches and compare them under the same oracle controls.

### Branch N: compact nonlocal regional observable

Retain the project-sign Benincasa-Dowker row on the exact tapered Alexandrov
germ, but replace a point estimate by an order-derived regional weak average.
The audit must measure the full same-graph covariance, including overlapping
predecessor intervals and random taper covariance. Independent-row error bars
are forbidden. This branch preserves the established curved
`Box-R/2` mean and retardedness.

### Branch L: intrinsic local challenger

Clean-room implement the Boguna-Krioukov distance/neighborhood construction,
first on flat polynomial controls. The benchmark must separately audit:

- exact annihilation of constants and the project-sign conversion;
- temporal and spatial first-moment leakage;
- affine and quadratic response in `1+1`, `2+1`, and then `3+1`;
- sensitivity to longest-chain and spacelike-distance estimators;
- relabeling covariance, retarded support, and computational cost;
- corrected-pairing Lorentzian rank and finite-sprinkling concentration.

The local operator becomes the primary architecture only if it beats Branch N
on pre-registered concentration and covariance gates while retaining an
acceptable curved-background principal symbol. Until then it is a challenger,
not a replacement.

## Kill conditions

- Kill Branch N if its full regional covariance prevents concentration under
  every admissible `ell << L << L_curv` schedule tested after analytic power
  counting.
- Kill Branch L if intrinsic distance-estimator noise, first-moment leakage, or
  retarded asymmetry prevents a stable Lorentzian corrected pairing.
- Do not advance either branch to curvature until flat rank, signature,
  product response, and count-volume gates pass on held-out data.

## Sources

1. D. M. T. Benincasa and F. Dowker, "The Scalar Curvature of a Causal Set,"
   [arXiv:1001.2725](https://arxiv.org/abs/1001.2725).
2. S. Aslanbeigi, M. Saravani, and R. D. Sorkin, "Generalized Causal Set
   d'Alembertians," [arXiv:1403.1622](https://arxiv.org/abs/1403.1622).
3. M. Boguna and D. Krioukov, "Local d'Alembertian for causal sets,"
   [arXiv:2506.18745](https://arxiv.org/abs/2506.18745), Phys. Rev. D 113,
   024046 (2026).
4. M. Boguna and D. Krioukov, "Measuring spatial distances in causal sets via
   causal overlaps," [arXiv:2401.17376](https://arxiv.org/abs/2401.17376),
   Phys. Rev. D 110, 024008 (2024).
