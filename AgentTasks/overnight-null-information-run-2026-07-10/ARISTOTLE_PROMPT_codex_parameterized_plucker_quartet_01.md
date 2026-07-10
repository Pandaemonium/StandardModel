# Codex proof job: parameterized nondegenerate Pluecker quartet

Close every proof in `PluckerQuartet/Core.lean` without changing definitions,
statements, metric, coefficients, spinors, or controls. Prove that the
nondegenerate indefinite quartet with decoder `SAt m` has exact-shifted class
cost `m^2` and that this equals the canonical spinor wedge norm for every real
`m`, without a separate `mu2=m^2` hypothesis. Preserve nilpotence, the genuine
exact/nonclosed pairing, and the distinct nonzero controls
`2/5 -> 4/25` and `3/5 -> 9/25`.

This derives the Hodge/Pluecker equality on one constructed parameterized
family. It does not prove every admissible decoder is this family, derive `m`
from dynamics, or fix physical units.

Run `lake env lean PluckerQuartet/Core.lean`; return the complete file and any
normalization issue.

Context pack:
`AgentTasks/context-packs/parameterized-plucker-quartet-20260710-20260710-013353.md`.

```yaml
aristotle:
  project_id: 3fb454fa-48f6-4c08-8513-49f366535979
  target_file: PluckerQuartet/Core.lean
  expected_module: PluckerQuartet.Core
  submission_project: AgentTasks/aristotle-submit/codex-parameterized-plucker-quartet-20260710-project
  output_dir: AgentTasks/aristotle-output/3fb454fa-48f6-4c08-8513-49f366535979
  status: idle; harvested and integrated
```
