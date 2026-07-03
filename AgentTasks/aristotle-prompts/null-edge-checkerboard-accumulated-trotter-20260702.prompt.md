# Null-edge checkerboard accumulated Trotter bound

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build command

```powershell
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

## Context

The target file is:

```text
PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

Current namespace:

```lean
PhysicsSM.Draft.CheckerboardDiracScaling
```

The project has now integrated the checkerboard-to-Dirac one-step bridge and
several stability facts. Important existing declarations include:

- `CheckerboardDiracScalingData`
- `CheckerboardDiracScalingData.totalTime`
- `diracHamiltonianSymbol`
- `diracEvolutionSymbol`
- `nullShiftSymbol`
- `momentumStepSymbol`
- `momentumStepSymbolRaw`
- `momentumEvolution`
- `continuumStepSymbol`
- `continuumStepBridgeRemainder`
- `continuumStepBridgeDiscrepancy`
- `momentumStepFirstOrderRemainder`
- `momentumStepFirstOrderDiscrepancy`
- `momentumStepFirstOrderDiscrepancy_isBigO_sq`
- `continuumStepBridgeDiscrepancy_isBigO_sq`
- `linftyOpNorm_one`
- `linftyOpNorm_mul_le`
- `linftyOpNorm_le_matrixL1Norm`
- `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`
- `norm_expMat_sub_one_sub_self_le`
- `linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq`
- `linftyOpNorm_pow_sub_pow_le`
- `linftyOpNorm_exp_le`
- `linftyOpNorm_continuumStepSymbol_le_exp`
- `linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq`
- `l2OpNorm_one`
- `l2OpNorm_of_mem_unitaryGroup`
- `momentumStepSymbolRaw_mem_unitaryGroup`
- `momentumStepSymbol_mem_unitaryGroup`
- `momentumEvolution_mem_unitaryGroup`
- `l2OpNorm_momentumEvolution`
- `continuumStepSymbol_pow_eq_diracEvolutionSymbol`
- `linftyOpNorm_momentumEvolution_sub_continuumPow_le`
- `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`

The intended final theorem is still only a comment. Do not promote the full
`checkerboard_dirac_limit_statement` unless all analytic pieces are represented
correctly and the proof is genuinely complete.

## High-value requested work

Work in `PhysicsSM/Draft/CheckerboardDiracScaling.lean`.

Please prove as much of the accumulated pointwise Trotter theorem as possible.
The most valuable missing finite ingredients are:

1. A scoped L-infinity operator-norm bound for the null phase:

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_nullShiftSymbol_le_one (eps p : Real) :
    ‖nullShiftSymbol eps p‖ ≤ 1 := by
  ...
```

An equality theorem is even better if it is easy.

2. A scoped L-infinity operator-norm bound for the isotropic mass-mixing step,
for example:

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_isotropicStep_le_one_add_abs (theta : Real) :
    ‖isotropicStep theta‖ ≤ 1 + |theta| := by
  ...
```

An intermediate exact row-sum bound such as
`‖isotropicStep theta‖ ≤ |Real.cos theta| + |Real.sin theta|` is useful.

3. A finite raw-step factor bound, ideally:

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs
    (eps m p : Real) :
    ‖momentumStepSymbolRaw eps m p‖ ≤ 1 + |eps * m| := by
  ...
```

4. Use the existing wrapper
`linftyOpNorm_momentumEvolution_sub_diracEvolution_le` plus
`linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq` to prove a clean
accumulated finite/asymptotic theorem. A good target shape is:

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_momentumEvolution_sub_diracEvolution_eventually_bound
    (m p : Real) :
    ∃ C : Real, 0 ≤ C ∧
      ∀ᶠ eps in nhds (0 : Real),
        ... ≤ C * eps ^ 2
```

But the exact statement may need a refinement family or explicit `N`, `eps`,
and `N * eps` hypotheses. Please choose the strongest semantically honest
finite-dimensional statement that compiles.

5. If the full accumulated theorem is too large, return:

- the completed factor-bound lemmas;
- the exact remaining Lean statement you recommend next;
- the proof plan and any Mathlib lemma names discovered.

## Constraints

- Do not change existing definitions.
- Do not add global matrix norm instances; use scoped norm sections.
- Do not weaken theorem statements silently.
- Keep the theorem pointwise in momentum.
- Do not promote a continuum-limit theorem unless the fixed-time refinement
  assumptions are explicit.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. any remaining theorem statements that should go back to Aristotle next;
4. your recommendation for the most important next pieces after this job.
