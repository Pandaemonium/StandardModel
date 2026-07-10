# Aristotle job: rapidity as information distance (boost slice)

Date: 2026-07-10.  Origin: Pro moduli-theory analysis (round-8, secs 6-7 and
theorem program B, flagged "inexpensive, very high-value").  The Bloch half
is already landed (`NullEdgeP7BlochMassRatio`, `VelocityMixtureLinearEntropy`,
`KraftCompressionMass`); this job supplies the missing hyperbolic half on
the diagonal boost slice: one-parameter boost group (rapidities add),
unimodularity, Einstein velocity addition = tanh addition, the speed limit
`|tanh| < 1`, rapidity as log-coordinate distance on the positive slice, and
boost invariance of the momentum determinant (invariant mass) with a moving
witness.  Honest scope pinned in-file: collinear 1+1 light-cone slice, not
the full `SL(2,C)/SU(2) = H3` isometry theorem.

## Metadata

```yaml
aristotle:
  project_id: f001c5e8-58e6-41b6-8f62-87058d9249cb
  target_file: AgentTasks/aristotle-standalone/rapidity-information-distance-20260710/RapidityInformationDistance/RapidityDistance.lean
  expected_module: RapidityInformationDistance.RapidityDistance
  submission_project: AgentTasks/aristotle-submit/rapidity-information-distance-20260710-project
  output_dir: AgentTasks/aristotle-output/f001c5e8-58e6-41b6-8f62-87058d9249cb
  status: integrated
```

Integration: completes the causal-Bloch-geometry suite; surface beside the
Bloch mass-ratio rung in Future Directions.

## Integration result (2026-07-09 23:22 PDT)

All targets returned placeholder-free with unchanged signatures (vacuum-shift:
see the in-file corrected negative control note), verified with the pinned
local Lean check pre-port, landed at PhysicsSM/Draft/NullEdge/RapidityInformationDistance.lean
with project namespace and passing axiom guards, imported by PhysicsSMDraft,
and covered by a green targeted lake build.
