# Aristotle task: exact stay/shift unitarity classification

## Scientific question

When is an onsite `stay` amplitude compatible with an exactly local unitary
walk, and what algebraic restriction is imposed when the onsite amplitude is
forbidden?

## Target

Prove every hole in `StayLaurent/Classification.lean`.  The main target is the
converse coefficient extraction and the final iff.  You may add small
roots-of-unity or Laurent-coefficient lemmas.  Do not assume continuity,
analyticity, commutativity of the three coefficient matrices, or finite
dimension beyond the displayed `Fintype` index.

If the converse is false as stated, return an explicit finite matrix
counterexample and the minimal corrected statement.  Do not weaken silently.

## Physics boundary

This is a one-axis finite algebra theorem.  It determines admissible local
stay/forward/backward amplitudes but does not prove a `3+1` walk, a Dirac
continuum limit, or doubler removal.

## Verification

Run only:

```text
lake env lean StayLaurent/Classification.lean
```

No new assumptions, compiler-trusted decision procedures, or placeholder
definitions.  Finish with solved targets, statement corrections, remaining
holes, and an axiom report.

## Aristotle metadata

```yaml
aristotle:
  project_id: c8f5634c-c200-443f-82b3-25d8a4e6dd37
  task_id: 6643e246-860e-413d-a07b-425b001bea52
  target_file: StayLaurent/Classification.lean
  expected_module: StayLaurent.Classification
  submission_project: AgentTasks/aristotle-submit/stay-laurent-unitarity-20260719-project
  output_dir: AgentTasks/aristotle-output/c8f5634c-c200-443f-82b3-25d8a4e6dd37
  status: integrated
```

Submitted on 2026-07-19. Initial task state: `IN_PROGRESS`.

## Harvest result

All five requested results were proved without statement changes. The exact
certificate iff unitarity classification and no-stay orthogonality consequence
were independently rebuilt and integrated as
`PhysicsSM/Draft/NullEdge/StayLaurentUnitarityClassification.lean`, with a
build-enforced axiom guard.
