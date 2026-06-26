# Aristotle task: wave 5 selected finite dynamics assembly

Date: 2026-06-25

## Objective

Assemble the wave-4 least-action, minimal-rate, and refresh-chain lemmas into the
next finite selected-dynamics layer. Aim for a useful theorem that connects a
finite least-action current/rate selector to invariant-law preservation or a
finite equivariant null-lift statement.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full `lake build`.
If targeted checks work, prefer:

```powershell
lake env lean PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean
lake env lean PhysicsSM/NullStrand/ZigZag/MinimalRates.lean
lake env lean PhysicsSM/NullStrand/Ergodic/RefreshChain.lean
```

If dependency setup fails or looks slow, skip build and return patchable Lean
plus exact blockers.

## Requested output

- Patchable Lean for the most natural dynamics module.
- A finite selected-dynamics theorem using the weighted-Laplacian range equality,
  least-action uniqueness, minimal-rate uniqueness, or refresh-chain invariance.
- Any small helper definitions needed to connect current/rate selectors to
  finite kernels.
- If a full selected null-lift theorem is not yet well posed, return the exact
  missing API and a smallest corrected theorem statement.
- A completion report listing solved statements, failed statements, and next
  focused proof cuts.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave5-selected-dynamics-20260625-161802.md`
- `PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean`
- `PhysicsSM/NullStrand/ZigZag/MinimalRates.lean`
- `PhysicsSM/NullStrand/Ergodic/RefreshChain.lean`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: ba379f7b-a92c-4f07-8964-d2f6f0a90dae
  task_id: 2f98b3d1-d696-4764-b710-7e90d0ed55b5
  target_file: PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean
  expected_module: PhysicsSM.NullStrand.NullLift.FiniteLeastAction
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave5-selected-dynamics-20260625-project
  output_dir: AgentTasks/aristotle-output/ba379f7b-a92c-4f07-8964-d2f6f0a90dae
  status: integrated
```

## Integration notes

2026-06-25 Codex integration pass:

- Downloaded and integrated Aristotle project
  `ba379f7b-a92c-4f07-8964-d2f6f0a90dae`.
- Extended `PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean` with the
  selected finite dynamics layer:
  `leastActionGenerator`, mass conservation, column-sum zero, constant
  stationary law, and automorphism equivariance.

Verification:

- `lake build PhysicsSM.NullStrand.NullLift.FiniteLeastAction`
