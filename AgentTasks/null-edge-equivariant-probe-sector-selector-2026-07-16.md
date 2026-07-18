# Null-edge equivariant probe-sector selector gate

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked; selector construction gate open

## Purpose

The selected rank-four carrier-sector correction removes the five-event
vacuity from the Lorentz-gauge interface, but a supplied subspace is not yet a
bare-order derivation. This note isolates two operator constructions that can
turn intrinsic null-edge data into a basis-free four-mode sector.

## Route K: constraint kernel

For each accepted carrier `A`, derive an order-native linear constraint

```text
L_A : zero-sum probes on A -> intrinsic residual observations on A.
```

The candidate cotangent sector is `ker L_A`. The required finite gates are:

1. `finrank (ker L_A) = 4`;
2. causal-order isomorphisms intertwine `L_A` with the corresponding target
   constraint through a natural equivalence of residual-observation spaces;
3. the four-dimensional kernel is quantitatively visible on the retarded
   shell;
4. neighboring chart kernels have compatible overlap restrictions.

`EquivariantProbeSectorSelector.map_ker_eq_ker_of_intertwines` proves that the
commuting square gives exact subspace naturality. No vector ordering is used.

## Route P: projector range

For each carrier, derive an intrinsic endomorphism or spectral projector

```text
Pi_A : zero-sum probes on A -> zero-sum probes on A.
```

The candidate sector is `range Pi_A`. The finite gates are:

1. `Pi_A^2 = Pi_A`;
2. `finrank (range Pi_A) = 4`;
3. carrier relabeling intertwines `Pi_A` and `Pi_B`;
4. a nonzero spectral gap separates this four-mode cluster from the remaining
   probe modes;
5. the projector varies slowly across nested cores and atlas overlaps.

This route is currently preferred. A degenerate four-dimensional eigenspace
can be intrinsic even when every attempt to order four eigenvectors is
label-dependent. It therefore matches the physical requirement that the
cotangent subspace be derived while tetrad bases remain local Lorentz gauge.

## Candidate graph-native operators

The first benchmark should compare only operators assembled from accepted
finite causal data:

1. a symmetrized retarded response operator on the protected carrier;
2. a generalized low-mode operator from the corrected causal pairing and a
   positive retarded-shell norm;
3. a multiscale count-profile covariance operator built from nested protected
   cores;
4. an atlas-consensus operator that penalizes disagreement of overlap
   restrictions between neighboring charts.

The generalized low-mode route must keep the Lorentzian corrected pairing
separate from the positive norm used to order or isolate modes. Indefinite
Rayleigh quotients alone do not provide a stable spectral ordering.

## Pre-registered selector gate

A candidate selector advances only if all conditions below hold on fresh
accepted atlas realizations:

1. **Rank:** one isolated cluster has dimension exactly four on at least 80%
   of bulk charts in every tested size/density cell.
2. **Gap:** the cluster gap divided by the local operator norm exceeds a fixed
   threshold declared before the frozen run.
3. **Relabeling:** exact permutation tests preserve the projector after
   conjugation to numerical tolerance.
4. **Nested stability:** principal angles between sectors on nested protected
   cores decrease with size.
5. **Overlap injectivity:** neighboring chart restrictions are injective on
   the selected sectors.
6. **Overlap agreement:** paired restriction images approach one another and
   induce well-conditioned transition maps.
7. **Lorentzian inertia:** the corrected pairing restricted to the selected
   sector has one positive and three negative directions, with a declared
   eigenvalue margin.
8. **Negative controls:** randomized rank-four subspaces and label-dependent
   eigenvector tie breaking must fail stability or covariance controls.

The exact numerical thresholds, seeds, and tie/degeneracy policy require an
independent preregistration review before execution.

## Kill conditions

The selector family is killed or redesigned if any of the following persists
under size increase:

1. no isolated four-mode cluster exists;
2. the gap closes at the same rate as numerical resolution;
3. selected sectors depend on labels or arbitrary eigenvector ordering;
4. retarded-shell restriction loses a probe direction;
5. overlap transitions become singular or fail cocycle consistency;
6. Lorentzian inertia is not stable across bulk charts.

## Claim boundary

- Kernel/range transport under an intertwining equivalence: finite `M` result.
- Existence of a successful graph-native operator: open reconstruction gate.
- Identification with a continuum cotangent bundle: open convergence theorem.
- Tetrad, spin connection, curvature, Einstein dynamics, and physical
  stress-energy: still closed downstream gates.

## Verification record

- Module SHA-256:
  `de815d0c385e2984f09bcade3c341b028c1805624724283eb7b623e0bed11a36`.
- `lake env lean PhysicsSM/Draft/NullEdge/EquivariantProbeSectorSelector.lean`
  passed with no diagnostics.
- `lake build PhysicsSM.Draft.NullEdge.EquivariantProbeSectorSelector` passed
  (`8037` jobs), rebuilding the rank-four correction dependency as well.
- Build-enforced guards report only `propext`, `Classical.choice`, and
  `Quot.sound` on the kernel transport, carrier-kernel naturality, and
  projector-sector naturality theorems.
