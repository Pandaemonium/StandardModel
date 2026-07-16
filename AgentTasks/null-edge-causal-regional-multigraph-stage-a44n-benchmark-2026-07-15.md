# Null-edge Stage A44N multi-graph regional covariance benchmark

**Status:** all frozen development gates passed; held-out and physical gates closed

## Run

Three fresh independent flat-diamond graphs were evaluated at `N=100000` with
seeds `20261560`, `20261561`, and `20261562`. The earlier A44p pilot was not
pooled. Each graph used the frozen 16-pivot tied count-depth selector, the
primary compact profile at `L/R=0.20`, all 17 probe channels, and one certified
finite continuum target per selected pivot.

The exact packed relation occupied `1,250,137,503` bytes per graph. Build times
were `340.29`, `339.43`, and `332.22` seconds; 16-pivot response times were
`4.24`, `3.81`, and `3.57` seconds.

## Frozen gate result

Every preregistered check passed:

- all target, finite-row, exact-cache, quadrature, and target-signature controls;
- Lorentzian signature `(1,3,0)` for all three regional-mean metrics;
- Lorentzian signature for `44/48 = 91.7%` of individual pivot metrics;
- regional metric errors `0.400`, `0.203`, and `0.361`;
- 17-channel operator errors `1.076`, `0.699`, and `0.742`;
- exact residual covariance reconstruction to `5.33e-15`;
- pooled diagonal effective pivot counts `12.10`, `20.57`, `30.35`, and
  `60.21` for the four metric diagonal channels.

The frozen branch decision is
`retain_branch_n_and_preregister_n200000_development`. This permits a separate
`N=200000` development protocol. It does not authorize `N=400000`, held-out
testing, curvature, or a physical concentration claim.

## Dependency qualification

The subsequently harvested covariance theorem makes a new architecture debt
visible. The current selector reads global past/future counts for every
eligible event. Each selected row also uses global future counts of its
predecessors to determine the taper. Consequently the conservative atom-level
read set of every random selected-row observable is the whole sprinkling, even
though its realized nonzero field support is compact.

The safe read-overlap graph is therefore complete, with degree `m-1`. The exact
Lean identity in `PhysicsSM/Draft/NullEdge/RegionalCovariance.lean` rewrites the
resulting dependency variance scale as

```text
sigmaSq * kappa + sigmaSq * (1 - kappa) / m.
```

Thus the dependency-degree theorem gives decreasing error only if the supplied
neighbor covariance ratio `kappa` itself decreases, or if the selector and
taper are redesigned to use pivot-local information. The three-graph residual
ledger has mixed positive and negative off-diagonal terms, but it is far too
small to provide a population upper bound on `kappa`.

## Decision

Record the A44N empirical development pass, but defer the `N=200000` run until
one of the following is preregistered:

1. a pivot-local outer germ whose taper and interval inputs have bounded
   overlap;
2. an independent thinning or sample-split construction separating anchor
   selection from row evaluation;
3. a multi-graph covariance-ratio program large enough to test decay of the
   complete-graph `kappa_N` bound.

The result is encouraging evidence that regional averaging stabilizes
Lorentzian operator shape. It is not yet a proof or credible tail estimate.

## Artifact

`AgentTasks/causal-regional-multigraph-stage-a44n-development-2026-07-15.json`
