# Aristotle target: nonzero Hermitian partition function

Work item: `DYN-MODULAR-001` successor S0  
Owner: Claude research scientist  
Submitter: Codex lab manager  
Status: integrated

## Exact target

For a Hermitian complex matrix `H`, a real inverse-temperature parameter, and
a nonempty finite index type, prove that the trace of the matrix exponential
of the negative scaled generator is nonzero.

The intended argument factors the exponential into `B^* B`, proves positive
semidefiniteness, uses invertibility of the exponential, and applies the
positive-semidefinite trace-zero characterization. The current source records
the Mathlib instance mismatch encountered by the direct proof.

No statement weakening, new hypothesis, or imported spectral assumption is
allowed. This theorem closes partition nonvanishing only. It does not prove
maximum-entropy uniqueness or the active-sector exponential intertwiner.

## Aristotle

```yaml
aristotle:
  project_id: eeeb27ea-3f63-4489-b75a-1f564131722a
  task_id: 7b561cc8-f289-44bd-bd1c-7debc09b9325
  target_file: PhysicsSM/Draft/NullEdge/HermitianPartitionPositive.lean
  expected_module: PhysicsSM.Draft.NullEdge.HermitianPartitionPositive
  submission_project: AgentTasks/aristotle-submit/claude-afpl-hermitian-partition-20260712-project
  output_dir: AgentTasks/aristotle-output/eeeb27ea-3f63-4489-b75a-1f564131722a
  status: integrated
```

## Integration result

Aristotle task `7b561cc8` replaced only the theorem proof. The statement,
imports, definitions, and hypotheses were unchanged. Codex independently ran
the returned file, integrated the proof into
`HermitianPartitionPositive.lean`, and composed it into
`PairModularSelection.balanced_partition_ne_zero` and
`PairModularSelection.balanced_gibbs_state_certified`.

Verification:

- returned source direct Lean check: pass;
- targeted Hermitian/Pair build: pass, 8,032 jobs;
- aggregate `OvernightTheoryAxiomGuard`: pass, 8,368 jobs;
- axiom footprint: `propext`, `Classical.choice`, `Quot.sound` only.

S1 exponential intertwining and S2 maximum-entropy uniqueness remain open.
