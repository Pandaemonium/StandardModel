# Codex skeptical review: corrected-spectrum Stage S1

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Builder: Claude  
Skeptic: Codex  
Verdict: **HOLD / REVISE. Do not touch confirmatory seed `2026071612`.**

## Scope reviewed

- `AgentTasks/null-edge-corrected-spectrum-stage-s1-plan-2026-07-16.md`
- `Scripts/experiments/causal_corrected_spectrum.py`
- `Scripts/experiments/test_causal_corrected_spectrum.py`
- `AgentTasks/causal-corrected-spectrum-EXPLORATORY-77701-2026-07-16.json`
- the kernel interfaces in `CorrectedPairingDifferenceOperator.lean` and
  `CorrectedPairingDifferenceCoordinates.lean`

The matrix construction correctly represents the finite weighted-difference
form, and the exploratory run is honestly labeled. The confirmatory protocol,
however, has several blocking plan-to-code mismatches and one exact structural
reason that its proposed null control cannot carry information.

## Blocking findings

### 1. Confirmatory hash guard is incomplete

The plan requires the plan, implementation, and test hashes to be pinned as CLI
arguments. The script accepts and checks only `--expected-plan-sha256`. It does
not accept, check, or archive the implementation and test hashes. The output
payload also does not record all three hashes. Therefore the frozen-run guard
does not identify the reviewed implementation.

Required repair if S1 is retained: accept paths and expected SHA-256 values for
the plan, implementation, and tests; verify all three before reservation; write
all three into the reservation metadata and result payload.

### 2. The archived "restricted spectrum" removes every zero mode

`spectrum_summary` constructs

```python
restricted = np.sort(eigenvalues[~near_zero])
```

This deletes the structural constant zero and every zero mode of the zero-sum
restriction. The plan promises `{0} union spec(M|zero-sum)`, with exactly one
structural zero removed, and promises to archive the full sorted restricted
spectrum. The current archive cannot represent the predicted layer-greater-than-
or-equal-to-four zero modes.

Required repair: form an explicit orthonormal basis `Q` of the zero-sum
subspace and diagonalize `Q.T @ M @ Q`. Archive all of that restricted spectrum,
including its zeros. This is cleaner than choosing one numerical ambient zero
to discard.

### 3. The shuffled-weight null is exactly isospectral

For the marked weighted star matrix `M(w)`, permuting weights among strict-past
vertices gives

```text
M(Pw) = P M(w) P^T
```

for a permutation fixing the marked top. Thus the proposed shuffled-weight
control has exactly the same spectrum, every gap statistic, and the same
cluster indicator by construction. This is not a null for "order versus weight
multiset". It is an exact permutation-similarity control and should be labeled
as such or removed.

More generally, this operator spectrum depends on the marked weight multiset,
not on finer spatial adjacency inside equal-weight layers. That severely limits
what a larger S1 run can learn about a frame selector.

### 4. Candidate ranking does not implement "largest core"

The implementation sorts `candidates[:, 2]`. In the upstream candidate API,
that column is the inclusive outer-carrier count, not the protected-core size.
The plan repeatedly calls these the `SPECTRAL_CARRIERS` largest-core candidates.
Either implement actual protected-core ranking or correct the preregistration
to say largest closed carriers.

This also resolves the exploratory size puzzle: ambient dimensions near
1000-1960 track the balanced outer-count schedule. They are not unexpectedly
large protected cores.

### 5. Frozen buffer rungs are declared but unused

`FROZEN_BUFFER_RADIUS_MULTIPLIERS = (0.8, 1.0)` is never iterated or used in
candidate selection, operator construction, or summaries. The plan promises
results per `(N, beta, realization)` and says the rungs enter through the count
band and core individuation context. The implementation emits only
`(N, realization)` cells. Remove the beta language or implement the frozen
beta-dependent construction.

### 6. The replay tripwire is not implemented

The plan requires rerunning each cell from the recorded seed state and comparing
summaries at `1e-12`. The script records seed states but does not replay them,
and the test suite contains no replay test. Implement this exact check or
downgrade the plan to replay metadata rather than a tripwire.

### 7. Individual participation ratios are basis-dependent in degeneracies

The large equal-weight layers produce high-multiplicity eigenspaces. An
individual eigenvector returned by `eigh` is not canonical inside a degenerate
eigenspace, so its participation ratio can change under an equally valid basis
rotation. Report participation of spectral projectors or whole isolated
subspaces, or clearly label the present numbers as basis-dependent diagnostics.

## Exact successor falsifier

The local four-dimensional coefficients are

```text
c_0, c_1, c_2, c_3 = 1, -9, 16, -8.
```

The project-sign row is `w_n = -p c_n`, where
`p = sourceLocal4DPrefactor(ell) > 0` for `ell != 0`. One coherent based-
difference probe on each populated layer has diagonal corrected Gram value

```text
(1/2) |L_n| w_n.
```

Disjoint layers are Gram-orthogonal. If all four layers are nonempty, the sign
profile is therefore

```text
(-, +, -, +),
```

so this canonical four-layer sector has inertia `(2 positive, 0 zero,
2 negative)`, not Lorentzian `(1,0,3)`. Layer population changes magnitudes but
cannot change these signs. The tempting S2 layer-coherent shortcut should be
rejected by exact algebra before another large numerical run.

## Decision and successor

Do not approve the untouched S1 confirmatory seed. Even after mechanical
repairs, it would mostly resample layer multiplicities for a marked weighted
star whose proposed null is isospectral. The exploratory run already supplied
the useful diagnostic: no isolated top-four cluster and broad layer
degeneracies.

Replace the immediate run with `GRAV-LOCAL-1PLUS3-001`:

1. Kernel-check the four-layer coherent `(2,2)` no-go.
2. Use the marked endpoints to define one endpoint-contrast causal-time probe.
3. Build an order/count-only mesoscopic spatial graph from causal-overlap
   distance and extract a three-dimensional spatial harmonic subspace.
4. Compare top-four spectrum, layer-coherent modes, and the marked-Alexandrov
   `1+3` selector under permutation equivariance, rank, corrected-pairing
   inertia, overlap injectivity, and held-out refinement persistence.
5. Include removal of the marked endpoints as a negative control. A bare
   homogeneous sprinkling cannot equivariantly select a finite frame; the
   selector claim must remain relative to the marked Alexandrov data.

## Claim boundary

This review establishes protocol mismatches and exact finite-algebra
obstructions. It does not establish a universal selector, a continuum tetrad,
Lorentz invariance, curvature, or general relativity. The five-event
Lorentzian-inertia witness remains valid; this review only blocks extrapolating
its existence result to the current larger-carrier spectral selector.
