aristotle:
  project_id: e06b9a92-0d24-4274-a695-283908ac5434
  task_id: pending
  target_file: PhysicsSM/Draft/NullEdgeKleinQuadricMassless.lean
  expected_module: PhysicsSM.Draft.NullEdgeKleinQuadricMassless
  submission_project: AgentTasks/aristotle-submit/massless-rank-design-20260624
  output_dir: AgentTasks/aristotle-output/e06b9a92-0d24-4274-a695-283908ac5434
  status: submitted

# Physics Context
Target is `massless_iff_rank_VGsqrt_le_one` from the Celestial/Massless lane. The physics goal is to formalize that a configuration is massless if and only if the rank of the visible Gram square root (or related visible Gram proxy) is bounded by 1.

# Request
This is a design/scaffold job. Please read `PhysicsSM/Draft/NullEdgeKleinQuadricMassless.lean` and relevant visible Gram operator files. Design the Lean scaffold for `massless_iff_rank_VGsqrt_le_one`. Output the complete `.lean` file content with the precise theorem statement and a `s o r r y`. Do not attempt a full proof.

# Suggested Next Steps
Please recommend the best way to define `VGsqrt` (Visible Gram square root) constructively without relying on non-computable real spectral decompositions if possible.
