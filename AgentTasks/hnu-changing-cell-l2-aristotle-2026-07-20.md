# Aristotle task: HNU changing-cell position-space L2 convergence

Date: 2026-07-20
Owner: Codex / `CONT-FOURIER-001` and `QCA-3PLUS1-001`
Priority: flagship continuum gate

## Objective

Create and prove
`PhysicsSM/Draft/NullEdge/HNUChangingCellL2.lean` by composing the exact HNU
many-step estimates with the repository's normalized changing-momentum-cell and
inverse-Fourier infrastructure.

The target is not fixed momentum and not a finite sample. At refinement level
`N`, use all `scheduledModes N`, their physical cell centers, one common HNU
step count, the actual normalized coefficients extracted from a supplied
two-component `L2` field, and the inverse Fourier isometry.

## Required imports and anchors

- `PhysicsSM.Draft.NullEdge.HNUCompactMomentumContinuum`
  - `CEnvelope`, `adaptiveSteps`, `adaptive_rate_le`,
    `many_step_bound_on_ball`, `adaptive_changing_window_tendsto`.
- `PhysicsSM.Draft.NullEdge.HNUManyStepContinuumLive`
  - `Wend`, `Eflow`, `qAbs`.
- `PhysicsSM.Draft.NullEdge.ChangingCellScaledLiveWalk`
  - `mode3Equiv`, `mem_scheduledModes_iff_modeBox`, physical schedules, and
    the proof pattern for coefficient energy.
- `PhysicsSM.Draft.NullEdge.ChangingMomentumCellCoefficientBridge`
  - `cellCoefficient`, `coefficient_energy_le_input`, `embedFinite`.
- `PhysicsSM.Draft.NullEdge.ChangingCellFourierL2`
  - representative-safe `Lp` and inverse-Fourier packaging patterns.
- Context pack:
  `AgentTasks/context-packs/hnu-changing-cell-l2-20260720-20260720-075322.md`.

Run the narrow target first:

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUChangingCellL2.lean
```

Do not begin with the full root build.

## Exact construction requirements

1. Define `Spinor2 := EuclideanSpace Complex (Fin 2)` and the actual
   componentwise normalized cell coefficient extracted from
   `F : Momentum3 -> Spinor2`.
2. Prove its squared norm is the sum of two scalar coefficient energies and
   prove the scheduled coefficient-energy contraction from componentwise
   `MemLp` hypotheses.
3. Define the physical cell-center momentum for each scheduled `Mode3` and
   prove

   ```text
   qAbs qCenter <= 3 * (N + 1).
   ```

   Use the live definitions; do not assume this inequality.
4. Use one common step count over the entire level:

   ```text
   adaptiveSteps (3 * (N + 1)) t N.
   ```

5. Define the per-cell error by applying

   ```text
   Wend(qCenter, t/steps)^steps - Eflow(qCenter,t)
   ```

   to the actual cell coefficient. Prove a uniform norm bound with rate at most
   `1/(N+1)` using the landed HNU envelope theorem.
6. Sum the squared errors over every scheduled mode and bound the sum by the
   squared common rate times the input-field energy.
7. Embed the resulting two spinor components back into the same normalized
   momentum cells. Prove the exact representative-level energy identity and
   genuine vector-valued momentum-space `L2` norm convergence.
8. Bridge from repository momentum coordinates to
   `EuclideanSpace Real (Fin 3)` using the existing measure-preserving map, then
   apply Mathlib's vector-valued inverse Fourier linear isometry. Prove the
   position-space `L2` norm of the live-versus-cell-center-exact error tends to
   zero.
9. Include the zero mode as a nonvacuity witness and build-enforced
   `#guard_msgs ... #print axioms` blocks for every headline theorem.

## Required claim boundary

The headline theorem should say exactly:

> The inverse-Fourier reconstruction of the HNU live-versus-exact
> cell-center error converges strongly to zero in position-space L2 for every
> componentwise L2 two-spinor field under the explicit refining/exhausting cell
> schedule and common adaptive HNU substep count.

It is one component of the final PDE theorem. It does not by itself prove that
the cell projection converges to the original field, control the continuously
varying exact multiplier inside each cell, or identify the position-space Weyl
generator. Those are separate landed or successor terms in the final
three-term composition.

## Failure discipline

- Do not weaken to fixed momentum, one mode, a finite sample, an arbitrary
  assumed coefficient sequence, or an assumed convergent projection.
- Do not use compiler-evaluation trust or introduce new assumptions.
- If a shared generic lemma is needed, add it with a descriptive name and keep
  its hypotheses visible.
- If the full result cannot be closed, return the largest verified prefix and
  the exact first unresolved theorem, with the current Lean error.

## Expected output

Return the complete new Lean file plus a short summary naming every theorem,
the exact hypotheses of the capstone, any deviation from this target, and the
targeted verification command actually run.

## Aristotle metadata

```yaml
aristotle:
  project_id: da35eb2a-1150-47f9-8b67-bce8c90f8e86
  task_id: pending
  target_file: PhysicsSM/Draft/NullEdge/HNUChangingCellL2.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUChangingCellL2
  submission_project: AgentTasks/aristotle-submit/hnu-changing-cell-l2-20260720-project
  output_dir: AgentTasks/aristotle-output/da35eb2a-1150-47f9-8b67-bce8c90f8e86
  status: submitted
```
