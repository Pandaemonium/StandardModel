# Aristotle task: antiperiodic two-tick pi dilation

```yaml
aristotle:
  project_id: 6f1114f3-e46c-4282-8c51-a81803ec62e1
  task_id: 75231ebb-9cc7-475e-940e-942b72b56bea
  target_file: AntiperiodicPiDilation.lean
  expected_module: PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation
  submission_project: continued NullDilationConditionedShift standalone project
  output_dir: AgentTasks/aristotle-output/6f1114f3-e46c-4282-8c51-a81803ec62e1
  status: integrated
```

## Motivation

The untwisted compact auxiliary dilation is exact but fails in its
zero-momentum block: the auxiliary phase is one and the complementary branch
is held. Test the smallest twisted escape. On a two-site compact register, an
antiperiodic translation can be a fixed-point-free coordinate shift carrying a
wrap phase such that `T^2 = -I`. Two fine ticks can then move the auxiliary
branch on both ticks and decode it into an explicit quasienergy-pi phase rather
than the identity.

## Required theorem ladder

1. Define an explicit complex `2 x 2` antiperiodic shift `T` on `Fin 2` and
   prove `T^* T = T T^* = I`, `T^2 = -I`, and `T` has no nonzero fixed vector.
2. Give a real-space description proving the underlying coordinate
   permutation is fixed-point-free; distinguish coordinate motion from the
   boundary phase.
3. For complementary Hermitian projectors `P,Q`, define one fine tick that
   moves `P` physically and applies `T` to an auxiliary `Q` register. Prove the
   tick is unitary and both branches move in an explicit nonzero witness.
4. Prove two fine ticks decode exactly to a two-step physical translation on
   `P` and `-1` on `Q`, with all cross terms zero.
5. Prove the momentum/twist statement has no untwisted zero-mode block; state
   this as an exact finite spectral claim, not an informal boundary-condition
   slogan.
6. Add standard-three guards and nonzero witnesses.

## Hard boundaries

This is a scoped escape from the untwisted auxiliary zero-mode obstruction. It
does not yet compose the eight HNU spin-projector substeps, prove a three-
dimensional winding, establish a global zero-plus-pi anomaly ledger, derive a
physical compact dimension, or show primitive spacetime-null soldering. A
twisted auxiliary edge is not automatically a physical null edge. Do not claim
3+1 completion.

No proof placeholders, compiled evaluation, or new assumptions. If the
proposed two-tick unitary is mathematically false in the stated architecture,
return the sharp corrected architecture or a finite counterexample/no-go.

## Integration record

- Independently reviewed by interactive Claude/Opus: `APPROVE`; durable review
  at `AutonomousLab/reviews/CLAUDE_REVIEW_AntiperiodicPiDilation_2026-07-13.md`.
- Integrated as
  `PhysicsSM/Draft/NullEdge/AntiperiodicPiDilation.lean` with live namespace,
  provenance, local standard-three guards, root import, and central flagship
  guards.
- The positive fine-tick result and the full-schedule
  `AntiperiodicHNU.twist_relocates_zero_to_pi` no-go are complementary; neither
  statement was weakened.
- Verification passed:
  `lake env lean PhysicsSM/Draft/NullEdge/AntiperiodicPiDilation.lean` and
  `lake build PhysicsSM.Draft.NullEdge.AntiperiodicPiDilation`.
