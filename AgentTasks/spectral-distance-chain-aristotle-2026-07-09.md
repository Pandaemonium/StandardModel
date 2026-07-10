# Aristotle job: finite spectral distance on an (n+1)-point chain

Date: 2026-07-09.  Origin: Pro "positive Hodge theory of finite null
information" synthesis (sec 6, "geometry is the decoder's self-description",
and sec 13 gap "recovering geometry completely from D"), triaged in
`Sources/Null_Edge_Future_Directions.md`.  This is the escalation of the
landed two-point operator-to-geometry witness (`SuiteAOp2Geom`,
`dCausal m 0 1 = 1/m`) to an (n+1)-point causal chain, which the 2026-07-09
harvest notes explicitly name as the follow-up.

## Statement package

Standalone Mathlib-only package.  Targets (see module docstring for the full
list): the per-edge Lipschitz set (the Connes condition for the EDGE-DOUBLED
block Dirac operator, documented in-file, with the block commutator identity
as its own target so the condition is honestly spectral); the telescoping
bound; achievability (`IsGreatest`: the spectral distance IS the weighted
geodesic `sum 1/m_k`); geodesic additivity (finite triangle equality);
conformal/scale covariance (`m -> c*m` rescales distances by `1/c`); and an
exact `8/15` rational witness.

Convention note: the NON-doubled tridiagonal Dirac operator is known to give
corrections to the geodesic distance (Iochum-Krajewski-Martinetti 2001); the
package deliberately uses the edge-doubled operator and says so.  Statements
are handed off with documented `s o r r y` markers; all typecheck.

## Metadata

```yaml
aristotle:
  project_id: 7895c97a-60e0-4a98-9f8f-efca607086a6
  target_file: AgentTasks/aristotle-standalone/spectral-distance-chain-20260709/SpectralChainDistance/ChainDistance.lean
  expected_module: SpectralChainDistance.ChainDistance
  submission_project: AgentTasks/aristotle-submit/spectral-distance-chain-20260709-project
  output_dir: AgentTasks/aristotle-output/7895c97a-60e0-4a98-9f8f-efca607086a6
  status: submitted
```

## Integration notes

On completion: dry-run `Scripts/aristotle/integrate_completed.py`, review the
report, then port into `PhysicsSM/Draft/NullEdge/` as a draft module with
guard blocks, and update the operator-to-geometry rung in
`Sources/Null_Edge_Future_Directions.md` (Suite A) plus the harvest log.
