# Composed free-walk and pair-layer QCA cone

## Objective

Prove a genuine `CARSupported` cone for determinant-minor second quantization
of a finite-range one-particle unitary, then compose it with one local
pairwise-disjoint Pluecker pair-gate layer.

## Scientific payload

This closes the formal composition gap between the exact free one-particle
walk lift and the exact interacting pair-layer cone. The resulting support
radius is two displayed graph-neighborhood steps: one free layer plus one
interaction layer.

## Non-negotiable boundaries

- Do not replace `CARSupported` by the weaker `FootprintIn` predicate.
- Do not assume the conclusion as an abstract support-propagation hypothesis.
- The one-particle locality hypothesis is coefficient-level finite range.
- The theorem is a strict finite support cone, not a continuum scattering
  result or a Lieb--Robinson tail estimate.

## Aristotle metadata

```yaml
aristotle:
  project_id: 971f3bfd-f2c4-4e42-88f6-5d677d877990
  task_id: 8bec01f7-4e25-46f9-aec8-e6a51b67c665
  target_file: AgentTasks/aristotle-targets/codex_24h_free_pair_qca_cone.lean
  expected_module: PhysicsSM.Draft.NullEdge.FreePairQCACombinedCone
  submission_project: AgentTasks/aristotle-submit/codex-24h-free-pair-qca-cone-20260712-project
  output_dir: AgentTasks/aristotle-output/971f3bfd-f2c4-4e42-88f6-5d677d877990
  status: landed-and-guarded
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Harvest: both target statements were preserved and proved with only the
standard axiom footprint. The live module `FreePairQCACombinedCone` passes
direct Lean and its 8,034-job targeted build. The result uses genuine
`CARSupported` throughout and derives, rather than assumes, free support
propagation from coefficient locality.
