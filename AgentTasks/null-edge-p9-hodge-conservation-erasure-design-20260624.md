aristotle:
  project_id: 72ec2c6a-0c60-4625-82e6-963a73d86478
  task_id: pending
  target_file: PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean
  expected_module: PhysicsSM.Draft.NullEdgeP9HodgeProjectorInstantiation
  submission_project: AgentTasks/aristotle-submit/p9-hodge-conservation-erasure-20260624
  output_dir: AgentTasks/aristotle-output/72ec2c6a-0c60-4625-82e6-963a73d86478
  status: submitted

# Physics Context
Target is `p9_conservationOrHodgeCondition_blocks_erasure` from the P9 source visibility API (Lane A). Recent P9 finite results showed that an unrestricted coarse-map survival is too strong, as critical collapses erase the operational gap. The current plan is to ask for an admissible class: a Hodge/conservation-compatible condition that blocks the erasure of the selected local signature.

# Request
This is a design/scaffold job. Please read `PhysicsSM/Draft/NullEdgeP9HodgeProjectorInstantiation.lean` and `PhysicsSM/Draft/NullEdgeP9CoarseMapErasureGuardrail.lean` (if it exists). Design the Lean scaffold for `p9_conservationOrHodgeCondition_blocks_erasure`. The theorem should state that if a coarse map satisfies the finite Hodge conservation condition, it cannot erase the operational gap. Output the complete `.lean` file with the exact statement and a `s o r r y`.

# Suggested Next Steps
Please recommend whether this condition is sufficiently strong, or if it reduces trivially to exact recovery. Recommend any additional algebraic assumptions needed for the P9 Hodge projector.
