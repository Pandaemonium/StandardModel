# Aristotle job: finite measurement-instrument API

Date: 2026-07-10 run (submitted 2026-07-09 ~23:55 PDT).  Origin: RUN_PLAN
Flagship C rung C2.3 (finite measurement instruments with normalized outcome
probabilities and a no-disturbance marginal theorem) and the
THEORY_COMPLETION_MATRIX measurement row (grade O).  Deliberately DISJOINT
from Codex's Kraus no-signaling lane (`17674ce6`, tensor marginals): this
package is the instrument layer above it - normalization, positivity,
projective repeatability (stable records), compatible no-disturbance, and
the qubit witness with the noncommuting disturbance control proving the
compatibility hypothesis necessary.

Honest boundary (stated in-file): outcome probabilities are DEFINED by the
trace rule - the Born rule is an imported input (postulate P4 of the
manuscript's candidate-theory section), not a derivation.  Clean-room
reference: lean-quantum CPTPMap theorem shapes (logged in LIT_SEARCH_LOG
pass 1); no code imported.

## Metadata

```yaml
aristotle:
  project_id: b5e0773e-615b-4843-86f8-3d486509c178
  target_file: AgentTasks/aristotle-standalone/finite-instrument-api-20260710/FiniteInstrument/InstrumentAPI.lean
  expected_module: FiniteInstrument.InstrumentAPI
  submission_project: AgentTasks/aristotle-submit/claude-finite-instrument-api-20260710-project
  output_dir: AgentTasks/aristotle-output/b5e0773e-615b-4843-86f8-3d486509c178
  status: integrated
```

Integration: port to `PhysicsSM/Draft/NullEdge/FiniteInstrumentAPI.lean` with
guards; wires the measurement row from O to D/B (instrument consistency D at
finite level; Born input explicitly I); benchmark S13-adjacent row follows.

## Integration result (2026-07-10 05:02 PDT)

All six targets returned placeholder-free with unchanged signatures, verified
with the pinned local check, landed at
PhysicsSM/Draft/NullEdge/FiniteInstrumentAPI.lean with project namespace and
passing axiom guards (standard footprint), imported by PhysicsSMDraft, and
covered by a green targeted lake build (8026 jobs).
