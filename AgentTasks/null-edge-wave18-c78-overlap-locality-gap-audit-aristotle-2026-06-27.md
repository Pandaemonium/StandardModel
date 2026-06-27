# Aristotle task C78: overlap locality and gap audit for the null-edge flavored kernel

```yaml
aristotle:
  project_id: ccad841a-746c-4403-9a1e-5d9e049fa365
  task_id: a4c1b24f-ff12-4152-9690-5f4439c4cfd0
  target_file: AgentTasks/null-edge-overlap-locality-gap-audit.md
  expected_module: report-only
  submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/ccad841a-746c-4403-9a1e-5d9e049fa365
  status: integrated
```

Context pack:

- `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`

Wave context:

- `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`
- `AgentTasks/null-edge-wave17-submissions-2026-06-27.md`

Kind: no-build audit.

Goal:

Produce a no-build audit report identifying the exact locality/gap assumptions needed before an overlap or Ginsparg-Wilson physical operator built from the null-edge flavored-mass kernel can be treated as local and physically meaningful.

Use the standard overlap/Ginsparg-Wilson/domain-wall playbook as a comparison, but do not assume Euclidean Hermitian results transfer automatically to the Lorentzian/Krein retarded null-edge setting.


Requested deliverable:

Write `AgentTasks/null-edge-overlap-locality-gap-audit.md` with:

```text
1. the Hermitian-kernel gap condition needed for sign(H);
2. the finite-volume versus infinite-volume distinction;
3. the locality condition for the projected/overlap operator;
4. how Krein/retarded structure changes the question;
5. which theorem should be proved in a positive Euclidean proxy first;
6. what would count as a fatal failure or a downgrade to reconstruction only.
```


Scope guardrails:

Do not propose a full continuum locality theorem as the next Lean target. The near-term target should be a finite spectral-gap or positive proxy theorem plus a clear list of analytic assumptions.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: ccad841a-746c-4403-9a1e-5d9e049fa365
task_id: a4c1b24f-ff12-4152-9690-5f4439c4cfd0
submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
target: AgentTasks/null-edge-overlap-locality-gap-audit.md
```

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: ccad841a-746c-4403-9a1e-5d9e049fa365
task_id: a4c1b24f-ff12-4152-9690-5f4439c4cfd0
copied_files:
  - AgentTasks/null-edge-overlap-locality-gap-audit.md
summary: AgentTasks/aristotle-output/ccad841a-746c-4403-9a1e-5d9e049fa365/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
