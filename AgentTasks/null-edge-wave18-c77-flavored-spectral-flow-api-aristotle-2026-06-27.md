# Aristotle task C77: abstract flavored spectral-flow and modified-chirality API

```yaml
aristotle:
  project_id: 6e2c7a9f-8edf-47f7-8edf-faf3dc19b3eb
  task_id: 0af107ae-20d9-4773-bf0e-ddc126bdf458
  target_file: PhysicsSM/Draft/NullEdgeFlavoredSpectralFlowAPI.lean
  expected_module: PhysicsSM.Draft.NullEdgeFlavoredSpectralFlowAPI
  submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/6e2c7a9f-8edf-47f7-8edf-faf3dc19b3eb
  status: integrated
```

Context pack:

- `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`

Wave context:

- `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`
- `AgentTasks/null-edge-wave17-submissions-2026-06-27.md`

Kind: proof/strategy.

Goal:

Create a small Lean API for the Route B construction layer: point-split branch projectors, taste signs, modified chirality, flavored mass, and Hermitian spectral-flow kernel.

The goal is not to prove analytic overlap locality. The goal is to put the post-C21 Gate C release target into named finite predicates that later modules can instantiate.


Requested deliverable:

Write `PhysicsSM/Draft/NullEdgeFlavoredSpectralFlowAPI.lean` with definitions/predicates along these lines:

```text
BranchProjectorSystem
TasteSignSystem
ModifiedChiralityData
FlavoredMassData
HermitianSpectralFlowKernel
FlavoredIndexReady
```

Prove small algebraic theorems such as:

```text
orthogonal branch projectors + signs in plus/minus one
  -> tau^2 = Pi_B on the branch subspace;
Gamma_f = Gamma_s * tau has the expected square under commuting hypotheses;
FlavoredIndexReady implies the chirality clause of ProjectedGateCRelease, abstractly.
```

Reuse existing project predicates if imports are lightweight. If importing the full release API is too expensive, make this a draft API module with explicit notes about the later connection.


Scope guardrails:

Do not introduce new assumptions as fake facts. It is fine for this module to define structures carrying hypotheses. Avoid claiming that such structures exist for the null-edge operator. The deliverable is the interface and algebraic consequences, not the construction.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 6e2c7a9f-8edf-47f7-8edf-faf3dc19b3eb
task_id: 0af107ae-20d9-4773-bf0e-ddc126bdf458
submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeFlavoredSpectralFlowAPI.lean
```

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: 6e2c7a9f-8edf-47f7-8edf-faf3dc19b3eb
task_id: 0af107ae-20d9-4773-bf0e-ddc126bdf458
copied_files:
  - PhysicsSM/Draft/NullEdgeFlavoredSpectralFlowAPI.lean
  - PhysicsSMDraft.lean
summary: AgentTasks/aristotle-output/6e2c7a9f-8edf-47f7-8edf-faf3dc19b3eb/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
