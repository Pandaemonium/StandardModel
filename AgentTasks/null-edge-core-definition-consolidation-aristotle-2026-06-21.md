# Aristotle task: null-edge core definition consolidation

Date: 2026-06-21

## Objective

Ask Aristotle for a no-build design/scaffold pass that consolidates duplicated
visible-spinor, Weyl-block, Pluecker, and finite-bundle definitions into a
clean proposed `PhysicsSM/NullEdge/Core` API.

Expected main output:

```text
null-edge-core-definition-consolidation-output.md
```

Context pack:

```text
AgentTasks/context-packs/null-edge-core-definition-consolidation-20260621-173119.md
```

## Why this matters

The strategy roadmap identified definition consolidation as the highest
leverage next move. We now have multiple theorem islands using local copies of
`CSpinor`, `rankOneHermitian`, `spinorWedge`, finite bundle momentum, Weyl
coordinates, Pluecker mass, Dirac-slash blocks, and generation-blindness
wrappers. The next proof wave will be cleaner if Aristotle helps design the
canonical API before more targets are submitted.

## Instructions

This is not a proof-completion job. Aristotle should not run `lake build` or
attempt to make a final compiling module tree. It should return:

- a proposed final module layout;
- canonical definition names;
- theorem names and dependency graph;
- migration notes from current trusted/draft theorem islands;
- statement-risk notes around real/nonnegative determinant mass, phase
  invariance, hidden Gram data, and Weyl-coordinate conventions;
- optional Lean-like skeletons clearly labeled as non-final handoff sketches.

## Aristotle metadata

```yaml
aristotle:
  project_id: 475b1a71-b31a-46ea-8b92-9efb8e236979
  task_id: b7885986-ea44-4746-b037-b42e3ad10b4d
  target_file: null-edge-core-definition-consolidation-output.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/null-edge-core-definition-consolidation-20260621-project
  output_dir: AgentTasks/aristotle-output/475b1a71-b31a-46ea-8b92-9efb8e236979
  status: analyzed
```

Submitted 2026-06-21. `aristotle submit` created project
`475b1a71-b31a-46ea-8b92-9efb8e236979`; `aristotle tasks` reported task
`b7885986-ea44-4746-b037-b42e3ad10b4d` as `QUEUED`.

## Result analysis

Fetched and reviewed 2026-06-21. Aristotle returned:

```text
AgentTasks/aristotle-output/475b1a71-b31a-46ea-8b92-9efb8e236979/extracted/project-files.tar/null-edge-core-definition-consolidation-20260621-project_aristotle/null-edge-core-definition-consolidation-output.md
```

The result understood the assignment and did not build Lean. Most useful
outputs:

- proposed `PhysicsSM/NullEdge/Core/{Spinor,Bundle,Determinant,WeylBlocks,DiracBridge,Phase,GenerationBlindness,GramWeighted,Curvature}.lean`;
- identified local duplicate definitions in generation-blindness and Bargmann
  phase drafts;
- recommended porting theorem islands onto canonical trusted Pluecker symbols
  before adding new higher-level wrappers;
- suggested a `NonnegRealValue` wrapper around complex determinant reality and
  nonnegativity;
- ranked next proof jobs: generation-blindness port, Bargmann-phase port,
  rank-one ket-bra unifier, reduced-density mass/energy, Gram reality, zero-edge
  collinearity, and closed-loop Pancharatnam phase invariance.

Caveat: the output says `NullEdgeGramWeightedMassAristotle.lean` has a missing
decoherence dependency. In the live repo that module exists at
`PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean`; the warning is an
artifact of the curated no-build package omitting that file. The split-core
recommendation is still useful, but the live repo is not blocked on a missing
file.
