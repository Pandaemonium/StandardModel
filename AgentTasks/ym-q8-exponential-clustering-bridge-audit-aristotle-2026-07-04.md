# Aristotle harvest: Q8 exponential-clustering bridge audit

```yaml
aristotle:
  project_id: 2c127e31-7227-433b-92f2-89c6d93aaf69
  task_id: f75cd4a1-385f-429d-9f6b-0ea1794573ed
  target_file: PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean
  output_dir: AgentTasks/aristotle-output/ym-q8-exponential-clustering-bridge-audit-20260704
  status: harvested-integrated
```

## Verdict

Aristotle accepted the single-anchor Q8 bridge
`hasExponentialClustering_of_tailContribution_bound` as the right
statement-freeze surface: the Q6 tail estimate and Q7 observable expansion are
explicit hypotheses, so the theorem does not depend on parked Q6 proof bodies.

The audit also recommended and supplied a finite-support observable API, which
I integrated:

- `LocalObservableSupportData`
- `supportTail`
- `HasExponentialClusteringSupport`
- `hasExponentialClusteringSupport_of_supportTail_bound`

The support bridge sums the Q6 tail contribution over every polymer in the
source observable support and gives the amplitude
`prefactor * sum (energy g0)` over that support.

## Verification

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/ExponentialClustering.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM.ExponentialClustering`
- `lake env lean PhysicsSM/Draft/NullEdge/GateYM.lean`
- Placeholder/escape-hatch scan on `ExponentialClustering.lean`: no hits.
- Dependency audit for both Q8 bridge theorems:
  `[propext, Classical.choice, Quot.sound]`.

`lake build PhysicsSM.Draft.NullEdge.GateYM` was attempted after integration,
but the current dirty worktree has unrelated concurrent T1 reflection edits
that make `ReflectionEnsemble.lean` fail with missing `Group G` instances.
The Q8 target itself and the aggregator file check both passed.

## Next Q8 Packages

1. After Q6 closes `kp_tail_bound`, add the one-line bridge from Q6's theorem
   to the Q8 `hTail` hypothesis.
2. Prove the singleton-support specialization from
   `LocalObservableSupportData` back to `LocalObservableData`.
3. Instantiate the observable-to-cluster comparison `hBridge` from the Q7
   plaquette-polymer map.
4. Consider a tighter two-support bridge predicate only if the current
   `ReachesFrom` upper bound proves too loose.
