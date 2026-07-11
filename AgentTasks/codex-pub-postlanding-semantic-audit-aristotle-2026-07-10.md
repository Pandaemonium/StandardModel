# Aristotle audit: Paper A after full-Bloch and CAR landings

## Role

Act as a hostile mathematical-physics referee and Lean semantic auditor. The
manuscript was revised after the previous referee packet to include exact
all-zone `+1/-1` determinant criteria and generic fermionic creation covariance.
Audit those claims against the verbatim source, together with the surrounding
headline and scope language.

## Files of record

- `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
- `PhysicsSM/Draft/NullEdge/FullBlochSplitDeterminants.lean`
- `PhysicsSM/Draft/NullEdge/FullBlochSplitPlus.lean`
- `PhysicsSM/Draft/NullEdge/FullBlochSplitMinus.lean`
- `PhysicsSM/Draft/NullEdge/FiniteCARSecondQuantization.lean`
- `PhysicsSM/Draft/NullEdge/OvernightTheoryAxiomGuard.lean`
- `PhysicsSM/Draft/NullEdge/Compact3Plus1DiracRate.lean`

## Questions

1. Does every manuscript formula match the exact Lean definition, including
   signs, factor 4, matrix convention, and branch label?
2. Does the prose distinguish an exact full-zone determinant criterion from a
   complete classification of its zero loci?
3. Does the creation-covariance claim match the theorem's finite ordered-mode
   scope and avoid implying functoriality, unitarity, annihilation covariance,
   locality, or interacting QFT?
4. Are any existential or nondegeneracy claims vacuous?
5. Does any abstract/contribution/conclusion sentence outrun the strongest
   theorem actually present?
6. Is the new result clearly differentiated from standard assigned-mass
   split-step walks and ordinary second quantization?
7. List every reproducibility or artifact omission that could trigger a major
   referee objection.

## Required output

- `FATAL`, `MAJOR`, `MINOR`, and `CLEAR` findings, ordered by severity.
- Exact manuscript phrase or section and exact Lean declaration for each
  finding.
- A minimal corrected replacement sentence for every prose defect.
- A final acceptability verdict for a specialist mathematical-physics journal
  and a separate prestige-physics verdict.
- Do not edit files and do not prove new theorems.

## Metadata

```yaml
aristotle:
  project_id: 9d0e0fe4-263b-4bd6-bc46-d93b48225a3c
  task_id: pending
  target_file: Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-postlanding-semantic-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/9d0e0fe4-263b-4bd6-bc46-d93b48225a3c
  status: stalled-cancelled
```

## Progress request

2026-07-10 21:03 PDT: sent an `ask` request for completed findings, exact
anchors, remaining work, and an immediate-return estimate. The prompt was
accepted, but the CLI wait renderer failed on Windows `cp1252`; no response was
lost from the remote project. Apply the two-hour return/split rule if the report
is not downloadable at the next status check.

2026-07-10 21:04 PDT: the project crossed the two-hour threshold while still
`RUNNING`. Sent an `instruct` request to stop all further work and immediately
return the complete findings already obtained. Harvest the resulting report;
do not extend this monolithic audit again.

2026-07-10 21:10 PDT: the project remained `RUNNING` and produced no report
after the stop instruction. Cancelled under the two-hour rule. Its downloadable
snapshot contained no audit artifact, so there is no finding to integrate. The
compact replacement audit is project `c7e14de3`.
