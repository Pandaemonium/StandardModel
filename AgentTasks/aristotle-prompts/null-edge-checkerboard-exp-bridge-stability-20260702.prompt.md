# Null-edge checkerboard exponential bridge and stability norm

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

## Current verified state

The target module is:

```text
PhysicsSM.Draft.CheckerboardDiracScaling
```

Recently proved:

- `momentumStepFirstOrderDiscrepancy_isBigO_sq`
- `momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound`
- `matrixL1Norm_mul_le`
- `matrixL1Norm_pow_le`
- `pow_succ_sub`
- `matrixL1Norm_pow_sub_pow_le`

Codex follow-up added:

- `matrixL1Norm_one`
- `continuumStepSymbol eps m p`
- `continuumStepBridgeRemainder eps m p`
- `continuumStepBridgeDiscrepancy eps m p`
- `continuumStepBridgeDiscrepancy_nonneg`
- zero-spacing sanity checks for the finite step, first-order model, and
  continuum step.

Important guardrail: `matrixL1Norm_one` proves that the local entrywise L1 norm
of the identity is `2`. Therefore the existing `matrixL1Norm_pow_sub_pow_le`
is useful as a finite error estimate, but a naive `M ^ N` long-product argument
in this norm will blow up when `N ~ 1 / eps` unless an additional stability
argument is supplied.

## Primary Lean target

Please prove the one-step exponential bridge:

```lean
theorem continuumStepBridgeDiscrepancy_isBigO_sq (m p : Real) :
    (fun eps : Real => continuumStepBridgeDiscrepancy eps m p)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  ...
```

This says the first-order model

```text
1 - i * eps * diracHamiltonianSymbol m p
```

and the one-step exponential

```text
continuumStepSymbol eps m p
```

differ by second order in the local `matrixL1Norm`.

If a direct `matrixL1Norm` proof is awkward, prove a clean fallback with an
explicit eventual constant:

```lean
theorem continuumStepBridgeDiscrepancy_tendsto_zero_div_sq_bound
    (m p : Real) :
    ∃ C : Real, 0 ≤ C ∧
      ∀ᶠ eps in nhds (0 : Real),
        continuumStepBridgeDiscrepancy eps m p ≤ C * eps ^ 2 := by
  ...
```

## Secondary stability target

After the exponential bridge, decide the best stability norm for the
`N ~ 1 / eps` product argument and do as much Lean as possible.

Good outcomes include one of:

1. Use an existing Mathlib norm on `Matrix Direction Direction Complex` with
   identity size `1`, prove or locate the needed submultiplicativity and
   exponential estimates, and state the next product theorem in that norm.
2. Prove a custom near-identity stability estimate for the specific factors
   `momentumStepSymbolRaw eps m p` and `continuumStepSymbol eps m p` that avoids
   the naive `matrixL1Norm_one = 2` blowup.
3. If neither is feasible in the time budget, return a precise proof plan with
   the exact Mathlib lemmas needed.

Do not promote `checkerboard_dirac_limit_statement` yet unless the exponential
bridge, product stability, and refinement-limit assembly are all proved.

## Literature/tooling orientation

- Arrighi, Forets, and Nesme, arXiv:1307.3524, motivates the operator-splitting
  and Trotter convergence path.
- Mathlib docs for `Mathlib.Analysis.Normed.Algebra.MatrixExponential` and
  `Mathlib.Analysis.Normed.Algebra.Exponential` are the first places to look for
  `NormedSpace.exp` continuity, Taylor, and norm estimates.

## Constraints

- Do not change the meaning of `momentumStepSymbolRaw`,
  `diracHamiltonianSymbol`, or `continuumStepSymbol`.
- Do not introduce untrusted constants or proof placeholders.
- Do not add global norm/typeclass instances.
- Keep the theorem pointwise in momentum.
- Keep the fixed-time subdivision guardrail intact.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of new theorem statements;
4. the best next theorem after the exponential bridge.
