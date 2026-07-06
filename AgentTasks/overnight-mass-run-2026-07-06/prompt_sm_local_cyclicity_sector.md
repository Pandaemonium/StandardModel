Investigate and, if feasible, formalize the LOCAL CYCLICITY / SECTOR-SPANNING
prerequisite for the finite transfer-gap lane.

Motivation:

The Faizal-Shabir arXiv:2606.19362 finite-a gap argument uses the density of
local vectors in the vacuum-orthogonal sector when converting temporal
clustering into a spectral gap. For our finite slab, this must be a NAMED
finite theorem, not an implicit assumption. Otherwise a "gap" could be proved
only on a too-small observable subspace.

Context:

- `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`
- `AgentTasks/context-packs/sm-local-cyclicity-sector-20260706-061955.md`
- Existing GateYM transfer/sector modules:
  `SlabTransferGap.lean`, `SlabFullSpectrumGap.lean`, `SlabCenterWitness.lean`,
  `SlabTransferZ2*.lean`, `TwoStateTransferZ2*.lean`, and
  `TransferGapDefinition.lean`.

Target:

- Prefer a new module
  `PhysicsSM/Draft/NullEdge/GateYM/LocalCyclicitySector.lean`, or a design note
  if the exact theorem surface is not ready.
- Prove the smallest useful finite statement:
  local/loop/flux insertion vectors span the claimed vacuum-orthogonal or
  selected local sector for the relevant tiny Z2 slab, OR prove a precise
  negative/counterexample showing the proposed spanning target is false.
- If the general finite-slab statement is too broad, isolate the exact
  statement needed by Q9 and list missing definitions.

Constraints:

- A negative result is acceptable and valuable.
- Do not claim a physical/continuum gap.
- No new `a x i o m`, `o p a q u e`, `u n s a f e`, or statement weakening.
- Check with
  `lake env lean PhysicsSM/Draft/NullEdge/GateYM/LocalCyclicitySector.lean`
  if a Lean module is created. If broad `lake build` stalls, skip it and report.

Finish with a concise report: proved theorem or counterexample, exact theorem
surface recommended for Q9, remaining gaps, and commands run.

```yaml
aristotle:
  project_id: 99b88d4d-457f-42dc-b749-bfaffdad6a4c
  task_id: 50192964-d7e4-4be5-b5af-3df12f194e7e
  target_file: PhysicsSM/Draft/NullEdge/GateYM/LocalCyclicitySector.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.LocalCyclicitySector
  submission_project: AgentTasks/aristotle-submit/sm-local-cyclicity-sector-20260706-project
  output_dir: AgentTasks/aristotle-output/99b88d4d-457f-42dc-b749-bfaffdad6a4c
  status: submitted 2026-07-06 06:25 PDT
```
