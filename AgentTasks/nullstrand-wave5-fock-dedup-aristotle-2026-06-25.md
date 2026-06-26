# Aristotle task: wave 5 Fock/Bell cleanup and API unification

Date: 2026-06-25

## Objective

Use the wave-4 Fock/Bell result as a base and clean up the remaining API drift.
The goal is to reduce duplicate-name debt, make direction-marginal preservation
easy to reuse, and avoid future confusion between total-mass and direction-law
equivariance.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full `lake build`.
If targeted checks work, prefer:

```powershell
lake env lean PhysicsSM/NullStrand/BellQFT/FockCutoff.lean
lake env lean PhysicsSM/NullStrand/Audit/DuplicateNames.lean
```

If dependency setup fails or looks slow, skip build and return patchable Lean
plus exact blockers.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean` and any
  nearby finite-probability helper module.
- If possible, unify or relocate duplicated positive-real helper lemmas used by
  BellQFT and ZigZag rather than copying them again.
- Keep `fockNullLift_total_mass_preserved` and
  `fockNullLift_preserves_direction_marginal` semantically distinct.
- Reduce or precisely classify duplicate method names in
  `PhysicsSM/NullStrand/Audit/DuplicateNames.lean`.
- A completion report listing any public names deprecated, renamed, or kept for
  compatibility.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave5-fock-dedup-20260625-161733.md`
- `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean`
- `PhysicsSM/NullStrand/BellQFT/BlockSupport.lean`
- `PhysicsSM/NullStrand/ZigZag/MinimalRates.lean`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `PhysicsSM/NullStrand/Audit/DuplicateNames.lean`

## Aristotle metadata

```yaml
aristotle:
  project_id: 9639b353-2bd4-4696-9ccd-db25f055ea39
  task_id: fb3f2eb4-3dd5-4ca9-aa89-059907c52a83
  target_file: PhysicsSM/NullStrand/BellQFT/FockCutoff.lean
  expected_module: PhysicsSM.NullStrand.BellQFT.FockCutoff
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave5-fock-dedup-20260625-project
  output_dir: AgentTasks/aristotle-output/9639b353-2bd4-4696-9ccd-db25f055ea39
  status: integrated
```

## Integration notes

2026-06-25 Codex integration pass:

- Added shared positive-part helper module
  `PhysicsSM/NullStrand/RealPositivePart.lean`.
- Removed accidental local `realPos` helper duplicates from the BellQFT and
  ZigZag finite-rate lanes.
- Added `fockNullLift_preserves_direction_marginal` while preserving the
  total-mass theorem and compatibility alias.
- Updated `PhysicsSM/NullStrand/Audit/DuplicateNames.lean` so the pending
  duplicate list is empty after the cleanup.

Verification:

- `lake build PhysicsSM.NullStrand.BellQFT.FiniteCurrent`
- `lake build PhysicsSM.NullStrand.BellQFT.MinimalJumpRates`
- `lake build PhysicsSM.NullStrand.BellQFT.FockCutoff`
- `lake build PhysicsSM.NullStrand.ZigZag.TransferCurrent`
- `lake build PhysicsSM.NullStrand.ZigZag.MinimalRates`
- `lake env lean PhysicsSM/NullStrand/Audit/DuplicateNames.lean`
