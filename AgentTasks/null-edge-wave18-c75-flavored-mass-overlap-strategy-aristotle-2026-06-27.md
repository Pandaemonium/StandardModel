# Aristotle task C75: flavored-mass / overlap Gate C strategy

```yaml
aristotle:
  project_id: 5cbe6395-0dce-4357-bb60-a302ad5a6899
  task_id: 579b86b8-9ba7-4aff-8f78-2ec2a0bf1530
  target_file: AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md
  expected_module: report-only
  submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/5cbe6395-0dce-4357-bb60-a302ad5a6899
  status: integrated
```

Context pack:

- `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`

Wave context:

- `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`
- `AgentTasks/null-edge-wave17-submissions-2026-06-27.md`

Kind: no-build strategy/audit.

Goal:

Produce a no-build strategy report that makes flavored mass / point splitting / Hermitian spectral flow the center of the Gate C v3 construction.

Start from the current post-C21/post-C64 facts:

```text
bare D_+ has chirality-balanced branch kernels;
known determinant zeros include branch lines and off-branch witnesses;
T_lin misses at least the C64 off-branch witness;
Wave 17 is testing scalar null-Wilson positivity and gauge/ghost clauses.
```

Use the literature lane indicated in the context pack, especially Creutz-Kimura-Misumi `1011.0761` / `1110.2482`, point splitting, minimally doubled flavored mass, modified chirality, and overlap/Ginsparg-Wilson kernels.


Requested deliverable:

Write `AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md` with:

```text
1. the exact proposed D_phys construction family;
2. the role of point-split projectors P_a;
3. the flavored mass M_flavored and modified chirality Gamma_f relationship;
4. how scalar Wilson positivity should be used as a lemma, not the central operator;
5. which parts should become Lean proof targets;
6. which parts remain analytic/locality/gauge-coupling assumptions;
7. a one-page release checklist for Gate C v3.
```

Prefer precise theorem statements over general prose.


Scope guardrails:

Do not claim Gate C release. Do not assume locality of the overlap sign function. Do not assume the CKM construction transfers automatically to the null-edge operator. Classify every coefficient or regulator choice as fixed, constrained, tunable, or open.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 5cbe6395-0dce-4357-bb60-a302ad5a6899
task_id: 579b86b8-9ba7-4aff-8f78-2ec2a0bf1530
submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
target: AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md
```

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: 5cbe6395-0dce-4357-bb60-a302ad5a6899
task_id: 579b86b8-9ba7-4aff-8f78-2ec2a0bf1530
copied_files:
  - AgentTasks/null-edge-flavored-mass-overlap-gate-c-strategy.md
summary: AgentTasks/aristotle-output/5cbe6395-0dce-4357-bb60-a302ad5a6899/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
