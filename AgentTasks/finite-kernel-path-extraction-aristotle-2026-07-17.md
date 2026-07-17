# Finite kernel path extraction Aristotle task

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: submitted

## Target

Prove that every nonzero entry of a finite matrix power has an explicit chain
of nonzero primitive entries, then transport that chain to a supplied support
relation. This is the exact finite bridge from a retarded matrix series to the
claim that each nonzero order-`n` term is carried by an `n`-step primitive
path.

The public statements are in:

`AgentTasks/aristotle-standalone/finite-kernel-path-extraction-20260717/FiniteKernelPathExtraction/PathExtraction.lean`

The semantic context pack is:

`AgentTasks/context-packs/finite-kernel-path-extraction-20260717-20260717-051203.md`

## Statement lock

Aristotle may add local helper lemmas but must not weaken or change the public
definitions or theorem statements. In particular:

- matrix rows remain targets and columns remain sources;
- path length must equal the matrix exponent;
- no positivity assumption may be added;
- the transport theorem must accept an arbitrary supplied step relation;
- the three-event witness must retain its zero primitive endpoint and nonzero
  two-step endpoint.

## Mathematical sketch

Induct on the exponent. At exponent zero, a nonzero identity-matrix entry
forces source and target to agree. At the successor step, expand with matrix
multiplication. A nonzero finite sum has a nonzero summand; the corresponding
nonzero product gives both a nonzero first primitive edge and a nonzero lower-
power entry. Apply the induction hypothesis and prepend the primitive edge.

Transport to a supplied relation is induction on `HasKernelPath`. Collapse to
a transitive ambient relation is induction on the positive-length relation
path.

## Verification contract

Run first:

```text
lake env lean FiniteKernelPathExtraction/PathExtraction.lean
```

Return the completed target file and a short report listing solved targets,
any statement changes, remaining proof holes, and assumptions used.

## Local preflight

- The focused source must typecheck before submission with only the intended
  executable handoff markers.
- The final integrated production theorem will be reviewed separately for
  null-link semantics: path extraction does not itself prove that the supplied
  primitive relation is a continuum null relation.

## Operations note

The document-index refresh attempted immediately before context-pack creation
hit its five-minute shell timeout. The context pack was nevertheless generated
successfully from the existing semantic index and is supplemented by the fresh
standalone source in the focused submission.

## Aristotle metadata

```yaml
aristotle:
  project_id: 16309cb8-603b-4074-a0c7-1d1cc9b30468
  task_id: d509a9da-f3af-47e4-842c-30e90bf623c0
  target_file: FiniteKernelPathExtraction/PathExtraction.lean
  expected_module: FiniteKernelPathExtraction.PathExtraction
  submission_project: AgentTasks/aristotle-submit/finite-kernel-path-extraction-20260717-project
  output_dir: AgentTasks/aristotle-output/16309cb8-603b-4074-a0c7-1d1cc9b30468
  status: submitted
```
