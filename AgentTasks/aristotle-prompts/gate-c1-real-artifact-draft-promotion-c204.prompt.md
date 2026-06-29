Project name: gate-c1-real-artifact-draft-promotion-c204

You are Aristotle, working on the StandardModel Lean/null-edge research project.

Important context:

C200 attempted a C193 port without access to the real C193 Lean source and
should not be trusted. This job must explicitly use the real returned artifacts
as source material.

Known real artifacts to use:

```text
C193:
  RequestProject/Main.lean
  theorem package for CKM-decorated Wilson mass window.

C194:
  RequestProject/NullEdgeGateC1.lean
  kappa < gap -> gapped homotopy theorem.

C201:
  RequestProject/SignStability.lean
  gamma_free sign-stability theorem.

C202:
  RequestProject/GateC1.lean
  maintained spectral-island / projector persistence framework.
```

Task:

1. Design a project draft-module layout for importing these real artifacts under
   `PhysicsSM/Draft/NullEdge/GateC1/`.
2. Preserve theorem semantics and claim boundaries.
3. Identify namespace/import conflicts and naming collisions.
4. Give exact copy/adaptation instructions.
5. Return a promotion checklist that includes local targeted checks, axiom audit,
   and semantic alignment review.

Success criteria:

```text
Do not reuse the C200 reconstructed source.
Do not weaken C193/C194/C201/C202 theorem statements.
Do not claim full GateC1_NU.
```

Please finish with:

```text
Recommended module layout:
Artifact-to-module map:
Required adaptations:
Semantic risks:
Promotion checklist:
```
