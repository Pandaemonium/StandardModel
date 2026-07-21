# Aristotle task: massive doubled HNU walk with Pluecker onsite turning

## Objective

Construct and verify a genuine `3+1` massive Floquet composition after relaxing
the requirement that every internal component translate during every substep.
The exact HNU endpoint supplies the Weyl transport, its opposite-momentum copy
supplies the second chirality, and `massCoin4` supplies a local Pluecker-derived
turn.

## Target

Prove the eight holes in
`PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean` without changing any
imported declaration or convention.  The central theorem is
`massiveHNU_ray_hasDerivAt` with derivative exactly
`-i (kinetic4 q + mass4 z)`.

First verify the explicit basis rotation.  If its sign or block ordering is
wrong, correct only `diracBasis` or the lower-block momentum sign, document the
correction, and preserve the target derivative.  If no such correction works,
return an exact counterexample entry.

Stretch target after the derivative lands: characterize the origin zero/pi
crossings for nonzero `z` and state the precise residual global census gate.

## Honesty conditions

- The onsite mass coin is a local internal event, not a null spatial edge.
- Exact unitarity plus the infrared derivative does not prove a unique species.
- Do not claim anomaly cancellation, a full Brillouin census, or continuum
  convergence.

Run only:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean
```

No new assumptions, compiler-trusted decision procedures, or weakened
derivative statement.  Report all corrections and axioms.

## Aristotle metadata

```yaml
aristotle:
  project_id: ff1b8e25-93f0-46a7-806d-9f0c99212a6c
  task_id: 40700def-11db-4849-abdd-ba3f55a2df7a
  target_file: PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay
  submission_project: AgentTasks/aristotle-submit/hnu-pluecker-massive-stay-20260719-project
  output_dir: AgentTasks/aristotle-output/ff1b8e25-93f0-46a7-806d-9f0c99212a6c
  status: integrated
```

Submitted on 2026-07-19. Initial task state: `IN_PROGRESS`.

## Integration record

Harvested from Aristotle and integrated on 2026-07-19. The returned module
proves exact unitarity, the zero-momentum rest identity, the HNU kinetic
derivative, the Pluecker onsite derivative, and the combined massive infrared
derivative. The local mass coin remains explicitly onsite; no global
Brillouin-zone gap or species census is inferred.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUPlueckerMassiveStay.lean
```

The direct check passed under the pinned toolchain. The printed assumption
footprints contain only `propext`, `Classical.choice`, and `Quot.sound`.
