# Aristotle task: P9 explicit Hodge projector strategy

```yaml
aristotle:
  project_id: 689020dd-79b1-4b50-9971-6d40ac8dd801
  target_file: README.md
  expected_module: none
  submission_project: AgentTasks/aristotle-strategy-packs/null-edge-p9-explicit-hodge-projector-strategy-20260623
  output_dir: AgentTasks/aristotle-output/689020dd-79b1-4b50-9971-6d40ac8dd801
  status: strategy-reviewed
```

No-code strategy/audit job. Ask Aristotle to design the finite theorem scaffold
for an explicit diamond Hodge projector and projected source/noise channel.

Scientific role: prevent P9 from becoming vocabulary. The result should say
which definitions and theorem targets are needed before source visibility has
real cosmological-constant content.

## Submission note

Submitted as no-code Aristotle strategy project
`689020dd-79b1-4b50-9971-6d40ac8dd801`.

## Result note

Aristotle returned `P9_STRATEGY.md` and an optional `RequestProject/P9Skeleton.lean`
under:

```text
AgentTasks/aristotle-output/689020dd-79b1-4b50-9971-6d40ac8dd801/extracted/project-files.tar/null-edge-p9-explicit-hodge-projector-strategy-20260623_aristotle/
```

The useful result is the dependency order:

1. Tier A: well-posed explicit finite Hodge objects: cochains, incidence maps,
   SPD metric blocks, adjoints, self-adjoint Laplacian, and sum-of-squares PSD.
2. Tier B: Hodge structure, especially `ker L1 = ker d1 cap ker d0star`, then
   projector idempotence/self-adjointness/range.
3. Tier C: source/noise channel laws: exact source invisibility, visible iff
   harmonic component, projected noise PSD/rank bound.
4. Tier D: fixed finite diamond response separation, where an explicit
   incidence-plus-metric pair gives a different harmonic rank/trace/response.

The optional skeleton is not integrated because every proof is intentionally a
handoff marker and the strategy job did not build it. The actionable next
theorem target is Tier A, especially the adjoint and sum-of-squares Laplacian
identity, before attempting `ker_L_eq_harmonic`.

This is a terminal no-code strategy state, not a Lean integration blocker.
