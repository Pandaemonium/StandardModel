# Aristotle task: P9 discrete coarse-graining strategy

```yaml
aristotle:
  project_id: 6b4325a0-5dd1-4985-80c2-fef93375f77d
  target_file: PROMPT.md
  expected_module: none
  submission_project: AgentTasks/aristotle-strategy-packs/null-edge-p9-discrete-coarse-graining-strategy-20260623
  output_dir: AgentTasks/aristotle-output/6b4325a0-5dd1-4985-80c2-fef93375f77d
  status: strategy-reviewed
```

No-code strategy/audit job.

Scientific role: correct the previous P9 strategy gate so a fundamentally
discrete model is not rejected merely because fine-scale harmonic/projected
objects are ill-conditioned. The desired output is a discrete-first
coarse-graining or renormalized-observable roadmap for the P9
source-visibility/noise branch.

## Submission note

Submitted as Aristotle project `6b4325a0-5dd1-4985-80c2-fef93375f77d`.

## Review note

Reviewed on 2026-06-23. The returned `ARISTOTLE_SUMMARY.md` was useful and
added one major prioritization change: build the coarse-grained noise-kernel
variance route first. The corrected P9 gate should require a fixed-in-advance
coarse-graining map `R`, a stable plateau for a statistic such as
`tr(R K R^T)`, geometry movement between flat and de Sitter-like diamonds, and
invariance under boundary-exact perturbations. Microscopic ill-conditioning or
absence of a pointwise continuum limit is not by itself a failure.

Docs updated:

- `Sources/Null_Edge_Key_Conjectures.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

This is a terminal no-code strategy state, not a Lean integration blocker.
