aristotle:
  project_id: e972fe08-4a4d-4ac6-97ec-efbfb879e77f
  task_id: pending
  target_file: PhysicsSM/Draft/NullEdgeObserverSpinFrameSU2.lean
  expected_module: PhysicsSM.Draft.NullEdgeObserverSpinFrameSU2
  submission_project: AgentTasks/aristotle-submit/spin-frame-su2-design-20260624
  output_dir: AgentTasks/aristotle-output/e972fe08-4a4d-4ac6-97ec-efbfb879e77f
  status: submitted

# Physics Context
Target is `observerSpinFrame_wellDefined_up_to_SU2` from the celestial Plucker spine. The context is that fixing an observer's finite rest frame or two-null geometry should restrict the residual Lorentz transformations on the spinor variables exactly to SU(2) (or a specified little group).

# Request
This is a design/scaffold job. Please read `PhysicsSM/Draft/NullEdgeP1SL2Frame.lean` and `PhysicsSM/Draft/NullEdgeObserverChannelCore.lean`. Formulate the Lean theorem statement `observerSpinFrame_wellDefined_up_to_SU2` in the context of the finite Plucker spinor geometry. Output the complete `.lean` file with the exact statement and a `s o r r y`.

# Suggested Next Steps
Please recommend if the SU(2) action should be constructed as an explicit group representation or just as an algebraic stabilizer identity.
