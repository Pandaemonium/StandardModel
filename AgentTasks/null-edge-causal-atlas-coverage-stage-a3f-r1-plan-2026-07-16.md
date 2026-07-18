# Stage A3f-R1 preregistration: buffered causal-atlas coverage

## Status and claim boundary

**Status:** preregistered before empirical implementation or execution  
**Work item:** `GRAV-ATLAS-COVERAGE-001`  
**Supersedes:** the invalidated original Stage A3f plan  
**Claim grade if successful:** external finite atlas-coverage and overlap
control only; no operator locality, G2 pass, continuum theorem, tetrad,
curvature, or Einstein dynamics

This revision repairs the fourth-root volume/proper-time normalization and
uses the exact flat four-dimensional protected-core volume. It also freezes a
genuine power-law schedule rather than holding every count scale fixed.

Stage A3f-R1 tests only whether an outer-first order atlas supplies typical,
repeatedly covered evaluation cores. Source-row support, polynomial controls,
operator stability, and rank-four metric extraction are deliberately excluded.
They require a separately preregistered successor on the same archived germs.

Coordinates may generate the oracle causal relation. They are forbidden for
candidate selection, regulator sampling, core construction, bulk definition,
coverage, overlap, and every reported gate. There is no coordinate phase.

## Exact flat-space calibration

Let an outer Alexandrov interval have proper duration `T`, and require an
evaluation event to have proper-time depth at least `s` from both endpoints.
Set

```text
z = 2s/T.
```

For `0 < z < 1`, the exact protected-core four-volume fraction is

```text
F4(z) = 1/2 ((2 - 5z^2) sqrt(1-z^2) + 3z^4 acosh(1/z)).
```

Use `F4(0)=1` and `F4(z)=0` for `z>=1`. If `M` and `H` are the continuum
expected outer and one-sided buffer counts, respectively, the Alexandrov
constant cancels:

```text
z = 2(H/M)^(1/4),
E[core count] = M F4(z).
```

This formula is an external Minkowski calibration. The order experiment does
not use embedding coordinates to define a core.

## Frozen shrinking schedule

At fixed global four-volume, event count `N` gives discreteness volume radius
`ell proportional to N^(-1/4)`. Freeze the balanced exponents

```text
R proportional to ell^(1/4),
S proportional to ell^(1/2),
L proportional to ell^(3/4).
```

Thus expected counts scale as

```text
n_R proportional to N^(3/4),
n_S proportional to N^(1/2),
n_L proportional to N^(1/4).
```

Freeze `N=(4800,9600)` and the reference counts

```text
n_R(4800) = 2048,
n_S(4800) = 12.6992084157456,
n_L(4800) = 3.56359487256136.
```

At `N=9600`, multiply these by `2^(3/4)`, `2^(1/2)`, and `2^(1/4)`,
respectively. These constants are the balanced reference
`(n_R,n_S,n_L)=(8192,32,sqrt(32))` transported down the same power law.
The finite ratios are only preasymptotic, but all three improve under
refinement and the limiting hierarchy is genuine.

Use three adjacent buffer-radius rungs

```text
beta = (0.80, 1.00, 1.25),
H_beta = beta^4 n_S.
```

At the two densities, the exact independent flat-space core fractions are
approximately `(0.5310,0.3516,0.1601)` and
`(0.5619,0.3886,0.1959)`. The corresponding expected core counts are
approximately `(1087.39,720.12,327.86)` and
`(1935.19,1338.44,674.64)`.

## Frozen candidate and sampling law

For each density, an outer candidate is a comparable pair `p < q` whose
inclusive interval count lies in

```text
[0.90 n_R, 1.10 n_R].
```

Construct the complete equivariant candidate set, then sample `K=16`
candidates uniformly without replacement at each buffer rung using independent
child streams. All three rungs use the same outer-count band but independently
sampled atlases. Retain all candidates if fewer than 16 exist and fail the
candidate-availability gate. Event labels are not scores or tie breakers.

For buffer count `H_beta`, define the protected core of `A(p,q)` by

```text
{x | p < x < q,
     H_beta <= C(p,x) + 1,
     H_beta <= C(x,q) + 1}.
```

All counts are ambient inclusive counts. No preselected mark enters candidate
or core construction.

## Independent denominator and overlap

For each buffer rung, define the order bulk before atlas sampling:

```text
Bulk_H = {x | x has at least H causal predecessors
                and at least H causal successors}.
```

Report all-event coverage, bulk coverage, the multiplicity histogram, and the
fraction of covered bulk events lying in at least two cores. For every pair of
sampled carriers with nonempty core overlap, report carrier and core Jaccard
overlap. The primary inference unit is a realization; pooled intervals are
diagnostic only.

The independent-placement baselines for `K=16` are not gates. At the widest
buffer rung they predict all-event coverage about `0.68` and repeated coverage
conditional on coverage about `0.44` at both densities. Correlated causal
intervals may differ substantially.

## Frozen execution and exact gates

- Random events: `N=(4800,9600)`.
- Duration: `1` at both densities.
- Realizations: five per density.
- Seed: `2026071607`.
- Outer band: `[0.90,1.10] n_R`.
- Buffer-radius multipliers: `(0.80,1.00,1.25)`.
- Atlas size: `16` per rung.
- Separate child streams for sprinkling and each regulator sample.
- No support-row evaluator, eigensolver, or coordinate control.

Before sprinkling, exact tests must establish:

1. the closed form agrees with direct numerical quadrature;
2. volume-radius/proper-time conversion uses `kappa_4=pi/24`;
3. the outer-count inversion reproduces its requested expected core count;
4. the three count scales have the frozen refinement exponents;
5. candidate sets, protected cores, bulk predicates, coverage multiplicities,
   and overlap relations map exactly under relabeling;
6. uniform subset sampling is applied only after complete candidate
   construction and is uniform on exhaustive small controls;
7. every protected-core event belongs to its outer carrier and ambient counts
   agree with induced counts on runtime tripwires;
8. all order-side APIs have no coordinate argument and use distinct streams.

Any exact failure kills the empirical run.

## Frozen empirical gates

A rung passes one realization only if:

- at least 16 outer candidates exist;
- all-event core coverage is at least `0.50`;
- the independent order bulk is nonempty and at least `0.60` covered;
- at least `0.35` of covered bulk events have multiplicity at least two; and
- at least one pair of distinct sampled cores overlaps nontrivially.

A rung passes one density only if at least four of five realizations pass. The
stage passes only if at least one adjacent rung pair passes at both densities.
For each passing rung, the median realization-level all-event coverage, bulk
coverage, and repeated-coverage rate may each drift by at most `0.10` between
densities. Zero denominators never count as stability.

Do not alter counts, exponents, rungs, bands, atlas size, thresholds, seed, or
duration after output. If this coverage-only stage passes, archive the selected
germs and preregister a successor that distinguishes probe data, protected
evaluation centers, and row-source eligibility while testing polynomial and
boundary controls. No rank-four projector may be opened before that successor
passes.
