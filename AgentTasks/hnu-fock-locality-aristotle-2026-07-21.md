# Aristotle task: finite fermionic Fock locality

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated

## Objective

Prove that a sparse local one-particle unitary has a locality-preserving finite
fermionic second quantization: exact creation/annihilation conjugation,
neighborhood support, and finite-depth relational light cone.

## Claim boundary

One-particle unitarity and antisymmetry do not imply Fock locality. This job is
the free finite rung only; interacting sector preservation remains separate.

Semantic context:
`AgentTasks/context-packs/hnu-fock-locality-20260721-20260721-002814.md`.

```yaml
aristotle:
  project_id: 78221f1e-595b-4029-ac5a-f98d48ef9174
  task_id: f00fa308-eaf7-40d5-b026-aa300f9209d2
  target_file: PhysicsSM/Draft/NullEdge/FiniteFermionicLocality.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteFermionicLocality
  submission_project: AgentTasks/aristotle-standalone/hnu-fock-locality-20260721
  output_dir: AgentTasks/aristotle-output/78221f1e-595b-4029-ac5a-f98d48ef9174
  status: integrated
```

## Integration result

The returned exterior-algebra implementation was reviewed, compiled directly,
and integrated as `PhysicsSM/Draft/NullEdge/FiniteFermionicLocality.lean`.
The integration adds one capstone not present in the raw return:
`finite_depth_localCAR_image_le` combines finite-depth matrix support with the
one-step CAR-algebra theorem. Its hypotheses retain an explicit inverse pair
for the schedule product, so sparsity is not misreported as unitarity.

The module proves free finite Fock locality only. Interacting locality,
positive-sector preservation, and a continuum QFT limit remain open.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteFermionicLocality.lean
```

The direct check passed, including four build-enforced standard-three axiom
guards. Nonfatal linter warnings inherited from the Aristotle proof remain.
