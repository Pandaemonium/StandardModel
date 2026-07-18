# Stage S1 preregistration: corrected-pairing spectroscopy on protected carriers

Date: 2026-07-16 (evening). Work item: GRAV-ORDER-OPERATOR-001 successor.
Status: preregistered DIAGNOSTIC stage; exploratory scoping permitted on
labeled non-frozen seeds; the confirmatory frozen run is BLOCKED until an
independent (codex-family) review approves this plan and the
implementation hashes. Author: claude (builder); requested skeptic: codex.

## Question

Does the corrected pairing of the project-local operator - kernel-proved
(2026-07-16) to be a self-adjoint zero-sum weighted-difference operator -
exhibit a stable, isolated FOUR-dimensional eigenvalue cluster on
protected-core carriers of manifold-generated sprinklings, at buffer
scales where cores individuate?

This is a DIAGNOSTIC stage in the R4-D pattern: no pass/kill gate on the
physics hypothesis; implementation tripwires only, plus preregistered
summary quantities whose values feed the successor decision. Prior work
calibration: `Sources/Null_Edge_Spectral_Question_Prior_Work_Note_2026-07-16.md`
(spectra-as-geometry and eigenmode-truncation are [comp] context:
Yazdi-Kempf 1611.09947, Sorkin-Yazdi 1611.10281, BBLL 1712.04227; the
corrected object's spectrum and the fixed-rank-four question are [orig]
candidates; NO stability expectation is imported from ASS 1403.1622,
whose instability evidence concerns the retarded, non-symmetric
operator).

## Frozen operator construction (per candidate carrier)

For a sprinkling with relation R and a count-band candidate (p, q, c):

- Closed carrier = {p, q} plus the open interval I(p, q); m = c + 1
  events. Fields live on the closed carrier; the marked event is the TOP
  endpoint q (matching the kernel witness convention).
- Weight row: w(y) = -sourceLocal4DPrefactor(ell) *
  sourceLocal4DCoefficient(n(y)) for y strictly below q in the carrier,
  where n(y) = openIntervalCount(y, q); w = 0 otherwise. Note the open
  interval (y, q) lies inside the carrier, so ambient and induced counts
  agree - no convention fork.
- Operator: the canonical ambient matrix of
  `zeroSumWeightedDifferenceOperator` (weight-difference term minus the
  delta-at-q compensator, halved). It annihilates constants and maps
  into the zero-sum subspace, and ambient R^m = constants (+) zero-sum
  fieldDot-orthogonally, so the ambient symmetric eigendecomposition
  equals {0} u spec(zero-sum restriction); the implementation
  eigendecomposes the ambient matrix and removes ONE structural zero.
- ell = 1 (the prefactor is a global positive scale; all preregistered
  quantities are scale-free ratios or sign counts; the raw spectra are
  archived so any other ell is a rescaling).
- Primary operator: LOCAL coefficients (1, -9, 16, -8, 0, ...). The
  smeared branch is out of scope for S1 (successor candidate).

## Kernel-fixed tripwires (exact, per carrier)

1. **Sylvester inertia**: the number of positive (negative) eigenvalues
   of the zero-sum restriction MUST equal the number of strict-past
   carrier events with w(y) > 0 (w(y) < 0) - i.e. layer counts n(y) in
   {1, 3} vs {0, 2} - because the form is congruent to diag(w)/2 by the
   kernel-checked difference-coordinates theorem. Any mismatch is an
   implementation halt (INADMISSIBLE), not physics.
2. **Structural zero**: exactly one eigenvalue at zero from the
   constants (to numerical tolerance 1e-9 relative), beyond any zeros
   forced by w(y) = 0 events (layer >= 4 events contribute zero weight;
   their count is recorded and the expected zero-multiplicity check
   includes them: kernel dimension of the FORM on zero-sum =
   #{strict-past y : w(y) = 0} + [1 if the compensator geometry forces
   it - the implementation records the exact expected count from the
   weight vector and checks it]).
3. **Symmetry residual**: max |M - M^T| = 0 exactly (construction) and
   eigh convergence.
4. **Relabeling invariance**: for two carriers per cell, a random event
   permutation is applied and the sorted spectrum must match to 1e-9
   relative (the kernel covariance suite guarantees this; the check is
   an implementation tripwire).
5. **Replay**: rerunning a cell from its recorded seed state reproduces
   every spectrum bit-exactly at the summary level (1e-12).

## Preregistered summary quantities (per N, beta, realization)

For each of the SPECTRAL_CARRIERS largest-core candidates (frozen at 8
per realization; largest by core size, ties by candidate index):

- full sorted eigenvalue list of the zero-sum restriction (archived);
- inertia triple (n+, n0, n-) and the layer-count prediction;
- the top-4 gap statistic: with eigenvalues sorted by |lambda|
  descending as l1 >= l2 >= ..., G4 = (|l4| - |l5|) / |l4| (0 if
  |l4| = 0), and the analogous G_k for k in {2, 3, 5, 6} as controls;
- the cluster-of-4 indicator: G4 >= 0.5 AND G4 > max(G2, G3, G5, G6)
  (a DESCRIPTIVE indicator, not a gate);
- eigenvector localization of the top 4 modes (participation ratio),
  descriptive;
- a weight-shuffled null control: the same weight multiset randomly
  reassigned over the strict-past events (one draw per carrier from the
  dedicated control stream), same summaries - the null for "the gap
  structure comes from the order, not the weight multiset".

## Frozen design

- Densities N = (2000, 4000); realizations 3 per density; buffer rungs
  beta in (0.80, 1.00) via the standard schedule (the rungs enter only
  through the count band and core individuation context; the operator
  itself is band-independent).
- Candidate family: the standard count band [0.90, 1.10] n_R at the
  balanced schedule; candidate ceiling 4000; SPECTRAL_CARRIERS = 8.
- CONFIRMATORY SEEDS (untouched until review): development 2026071612,
  none held out (single-phase diagnostic).
- Exploratory scoping seeds are drawn from a visibly different range
  (777xx) and every scoping artifact is labeled EXPLORATORY; scoping
  informs nothing but implementation shakeout, and its results are
  excluded from all claims.
- Resource ceilings: dense relation (4001)^2 booleans; peak working set
  4 GiB; 300 s per realization; eigh on at most (max core + 2)^2
  matrices, dimension ceiling 3000.
- Outcome taxonomy: PASS (all tripwires clean; summaries produced),
  INADMISSIBLE (resource failure, tripwire mismatch, candidate
  shortfall < SPECTRAL_CARRIERS). There is NO FAIL: a diagnostic cannot
  kill the four-mode hypothesis; only the successor gate (designed on
  S1's summaries) can.
- Sentinel: the confirmatory run uses `frozen_run_set_reservation` over
  its single output plus sentinel, with plan/implementation/test hashes
  pinned as CLI arguments (R4 pattern).

## Successor rules

If the cluster-of-4 indicator fires robustly (descriptively) across
cells, the successor preregisters a GATED four-mode stage (frozen gap
threshold, fresh seeds, kill condition) plus the Lean packaging via the
ready polynomial-filter interface. If spectra show no stable structure,
the successor is the mapped-frontier write-up and the probe-module
redirect (edge/cochain/spin-frame), per the visionary note. Either way
S1's archives are the design input, and S1 itself claims nothing about
the hypothesis.

## Claim boundary

Finite numerical spectroscopy on flat manifold-generated controls with
supplied coefficients. No positivity, Lorentzian inertia beyond the
Sylvester bookkeeping, spectral gap CLAIM, carrier selection,
refinement stability, tetrad, or continuum statement. M [comp]-grade
evidence generation for a future gate; the kernel theorems it leans on
are already landed and guarded.

## Exploratory scoping addendum (seed 77701, 2026-07-16 evening; EXCLUDED FROM CLAIMS)

The labeled exploratory run completed (raw sha256 6cebf162...). Honest
readout, for design only:

- All tripwires clean on every evaluated carrier (Sylvester inertia
  exact, relabeling exact, structural-zero accounting exact) - the
  implementation is sound.
- N = 2000 is too sparse: 2 of 3 realizations had fewer than 8 band
  candidates (INADMISSIBLE). The confirmatory design should move to
  N = (4000, 8000) or reduce SPECTRAL_CARRIERS at the low rung.
- Runtimes 121-284 s per realization sit against the 300 s ceiling at
  N = 4000; the ceiling must rise (or the eigendecomposition set
  shrink) before the confirmatory run. Carrier ambient dimensions ran
  ~1000-1960, far above the naive count-band estimate - the reviewer
  should check the band/schedule convention against R3 before
  approval.
- PHYSICS-SHAPED OBSERVATION (design input, no claim): the
  cluster-of-four indicator fired NOWHERE (0/8 on every passing cell;
  identically for the weight-shuffled null), with g4 = 0.000 to
  three decimals - the top of the spectrum is quasi-degenerate. The
  mechanism is structural: the local 4D coefficients vanish beyond
  layer 3, so the operator is supported on the four shallow strict-past
  layers of the top event, whose large populations produce massive
  near-degeneracies. The naive top-magnitude operationalization
  therefore measures layer degeneracy, not a frame sector. The sharper
  S2 hypothesis this suggests: the four LAYER-COHERENT collective modes
  (one symmetric combination per populated layer n = 0..3) span a
  canonical four-dimensional subspace on which the corrected pairing
  restricts to an exact 4x4 object - a candidate frame germ that is
  order-native by construction. S2 should preregister that projection
  alongside (not replacing) the S1 confirmatory spectroscopy.
