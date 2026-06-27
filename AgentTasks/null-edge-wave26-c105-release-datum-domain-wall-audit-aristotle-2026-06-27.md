# Aristotle C105: C1 release datum and domain-wall/projected-overlap audit

aristotle:
  project_id: c633c689-2dd4-4748-97fd-869802a471eb
  task_id: bcf75a14-3044-4f9a-851c-bec41c1d21ec
  target_file: AgentTasks/null-edge-gate-c-release-datum-domain-wall-audit.md
  expected_module: n/a
  submission_project: AgentTasks/aristotle-submit/null-edge-wave26-gate-c-branch-release-20260627-project
  output_dir: AgentTasks/aristotle-output/c633c689-2dd4-4748-97fd-869802a471eb
  status: integrated
  initial_project_status: RUNNING
  initial_task_status: QUEUED
  reviewed: 2026-06-27
  integrated: 2026-06-27

Dependency class: C1 strategy/audit job.

Context pack:

```text
AgentTasks/context-packs/null-edge-wave26-gate-c-branch-release-20260627-121710.md
AgentTasks/null-edge-gate-c-neo4j-lit-lateral-analysis-2026-06-27.md
```

## Background

Literature search supports the following Gate C posture:

```text
C0 scalar Wilson gap: promising theorem.
Raw full-bare-overlap: unsafe unless a mass-window theorem is proved.
C1 release: requires release datum plus branch-line/projector/domain-wall data.
```

## Requested output

Return a report:

```text
AgentTasks/null-edge-gate-c-release-datum-domain-wall-audit.md
```

Do not force a Lean artifact unless it is genuinely useful.

## Requested analysis

Produce:

- A final C1 release datum schema with required fields and clauses.
- A route comparison:

```text
raw overlap on full D_+
projected overlap after Pi_br
spinor-line Wilson / matrix-valued Wilson
domain-wall or boundary construction
controlled quasi-local projector
```

- A "must prove before use" list for each route.
- A ghost/anomaly/Krein/locality audit table.
- A recommendation for the next two Lean theorem targets.

## Literature anchors to use

- Golterman-Shamir arXiv:2311.12790 and arXiv:2505.20436 for ghost-zero and
  mirror-sector constraints.
- Luscher hep-lat/9802011 for Ginsparg-Wilson exact lattice chiral symmetry.
- Creutz-Kimura-Misumi arXiv:1011.0761 / arXiv:1110.2482 for flavored masses,
  point splitting, spectral flow, and overlap with naive/minimally doubled
  kernels.
- Creutz arXiv:1009.3154 and Durr-Weber arXiv:2108.11766 for species
  splitting and topology sensitivity.
- Kaplan arXiv:0912.2560 for domain-wall/overlap/GW review.
- arXiv:2402.09774 for single-wall anti-vectorialization warning.

## Acceptance criteria

- Report is specific enough to drive the next Aristotle/Lean wave without a new
  strategy pass.
- It does not advertise C0 as C1 or full Gate C release.
- It treats propagator-zero mirror removal as disallowed for gauge-charged
  branches unless an explicit ghost-safety theorem is supplied.

## Integration review

Status: integrated 2026-06-27 after cycle-15 extraction-helper fix.

Integrated artifact:

```text
AgentTasks/null-edge-gate-c-release-datum-domain-wall-audit.md
```

Result:

- Added the C105 release-datum / domain-wall / projected-overlap audit report.
- The report fixes ten C1 release clauses, compares raw overlap, projected
  overlap, matrix-valued Wilson, domain-wall, and quasi-local projector routes,
  and recommends overlap mass-window dichotomy before Route-B release assembly.

Review notes:

- The earlier missing-payload diagnosis was local extractor friction: the
  Aristotle archive did contain the report, but the helper filtered out general
  Markdown files and then hit Windows long-path limits. That helper is now
  patched.
- Treat the report as strategy guidance, not a release theorem.
