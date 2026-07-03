# Null-edge checkerboard momentum-step expansion and Trotter bridge

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

If you modify dependencies, also run:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

## Current verified state

The topology-explicit design layer now lives in:

```text
PhysicsSM.Draft.CheckerboardDiracScaling
```

Important current names:

- `diracHamiltonianSymbol m p`
- `diracEvolutionSymbol m p t`
- `nullShiftSymbol eps p`
- `momentumStepSymbol D p`
- `momentumStepSymbolRaw eps m p`
- `momentumStepSymbol_eq_raw`
- `momentumStepFirstOrderModel eps m p`
- `momentumStepFirstOrderRemainder eps m p`
- `momentumStepFirstOrderDiscrepancy eps m p`
- `momentumStepFirstOrderDiscrepancy_nonneg`
- `momentumEvolution D p`
- `momentumEvolutionDiscrepancy D p`
- `CheckerboardDiracRefinement.timeStep_tendsto_zero`
- `CheckerboardDiracRefinement.massAngle_tendsto_zero`
- `CheckerboardDiracRefinement.accumulatedAngle_tendsto`

The intended continuum theorem remains only a comment:
`checkerboard_dirac_limit_statement`. Do not promote it until the per-step
and matrix-power estimates exist.

## Primary Lean target

Please prove the pointwise per-step second-order estimate:

```lean
theorem momentumStepFirstOrderDiscrepancy_isBigO_sq (m p : Real) :
    (fun eps : Real => momentumStepFirstOrderDiscrepancy eps m p)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  ...
```

This is the key missing analytic lemma for the momentum-space Dirac-limit
statement. It says the one-step symbol

```text
momentumStepSymbolRaw eps m p
```

agrees to first order with

```text
1 - i * eps * diracHamiltonianSymbol m p
```

in the local `matrixL1Norm`.

If a direct proof is awkward, useful fallback targets are:

```lean
theorem momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound
    (m p : Real) :
    ∃ C : Real, 0 ≤ C ∧
      ∀ᶠ eps in nhds (0 : Real),
        momentumStepFirstOrderDiscrepancy eps m p ≤ C * eps ^ 2 := by
  ...
```

or a theorem with an explicit constant depending on `m` and `p`.

## Helpful proof shape

The finite step is

```text
nullShiftSymbol eps p * isotropicStep (eps * m)
```

The desired first-order model is

```text
1 - i * eps * (p * directionGrade - m * reversal)
```

A likely proof route is:

1. Expand the two-by-two entries of `momentumStepFirstOrderRemainder`.
2. Use scalar Taylor bounds for complex exponentials, sine, and cosine.
3. Sum entrywise bounds through `matrixL1Norm`.

The existing scalar real sine/cosine bounds in
`CheckerboardContinuumScaffold` may help for the mass-mixing part. Complex
exponential bounds may need local helper lemmas. Prefer small named helper
lemmas over one large proof.

## Secondary target

If the per-step theorem is completed with time left, make as much progress as
possible on the next matrix-power/Trotter bridge. Good outputs include:

- a compiling theorem statement for a finite-dimensional matrix-product
  stability estimate using `matrixL1Norm`;
- a reusable lemma that bounds `A ^ n - B ^ n` from a per-step bound and
  stability hypotheses;
- or a precise proof plan identifying the minimal Mathlib lemmas needed for
  `NormedSpace.exp` continuity and finite matrix powers.

Do not assert the full checkerboard-to-Dirac convergence theorem unless the
required estimates are actually proved.

## Literature orientation

- Arrighi, Forets, and Nesme, arXiv:1307.3524, is the main operator-splitting
  and Trotter/convergence anchor.
- Strauch, arXiv:quant-ph/0508096, motivates the 1+1D quantum-walk/Dirac
  connection.
- Skopenkov and Ustinov, arXiv:2007.12879, and Earle, arXiv:1012.1564, anchor
  the path-count/checkerboard asymptotic route but are not the shortest path to
  this per-step theorem.

## Constraints

- Do not change the meaning of `momentumStepSymbolRaw` or
  `diracHamiltonianSymbol`.
- Do not introduce untrusted constants or proof placeholders.
- Do not add global matrix norm/typeclass instances.
- Keep this as a pointwise momentum theorem; no `L2` or position-space claim is
  requested.
- Keep the fixed-time subdivision guardrail intact: do not claim subdivision of
  `isotropicStep T` makes the first-order linearization error vanish.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. a semantic review of any theorem statements added;
4. a short ranked list of best next steps after the per-step theorem.
