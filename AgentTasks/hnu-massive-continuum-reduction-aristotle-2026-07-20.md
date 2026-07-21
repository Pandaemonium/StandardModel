# Aristotle task: quantitative massive HNU continuum reduction

Date: 2026-07-20  
Owner: Codex  
AFPL item: `CONT-FOURIER-001`  
Status: integrated

## Objective

Complete every proof hole in
`PhysicsSM/Draft/NullEdge/HNUMassiveContinuumReduction.lean` without weakening
the physical walk, the summed massive Dirac generator, or the second-order
one-step error shape.

The module composes four landed structures:

- the exact HNU Weyl endpoint and its quantitative massless remainder;
- the doubled opposite-chirality HNU walk in the live Dirac basis;
- the exact four-component Pluecker mass coin;
- the existing unitary telescope and matrix-exponential remainder machinery.

The primary analytic reference is Arrighi--Forets--Nesme,
arXiv:1307.3524.  That paper supplies the consistency/stability architecture,
not the HNU-specific theorem.

## Required outputs

1. `massCoin4_eq_exp_mass4` with the exact displayed sign and normalization.
2. Exact rest-generator norm and the kinetic norm bound.
3. `diracHNU_sub_linear_bound`, the HNU-specific doubled-block crux.
4. The mass-coin linear remainder and Hermitian/generator norm lemmas.
5. `massive_one_step_bound` with an `O(eps^2)` coefficient.
6. Exact flow composition and the fixed-time `O(1/n)` telescope.
7. Nonnegativity and a genuinely nonzero kinetic-plus-mass control.

The explicit coefficient `massiveRemainderC` may be enlarged if a displayed
larger coefficient is required by a valid norm inequality.  Any enlargement
must remain finite, nonnegative, explicit in `q` and `z`, and uniform for
`abs eps <= 1`.  Do not replace the one-step theorem by a derivative at zero or
an existential continuity statement.

## Semantic gates

- Do not assume kinetic and mass matrices commute.
- Do not replace the HNU endpoint by `Compact3Plus1DiracRate.splitStep`.
- Do not remove the opposite-chirality block or the Dirac-basis conjugation.
- Do not introduce a separate scalar mass parameter; all mass data comes from
  `z` through `mass4 z`.
- Preserve exact unitarity and the proposition-level `z != 0` hypotheses from
  the source statement.
- The theorem is finite momentum-space convergence.  It is not yet the
  changing-lattice position-space theorem.

## Suggested proof route

- Reuse `ComplexPlueckerRateTransfer.conjugates_real_factor_to_massCoin4`,
  `complexExactFlow_eq_exp_H4`, and Mathlib's `Matrix.exp_conj` /
  `Matrix.exp_diagonal` for the exact mass exponential.
- Reuse `HNUManyStepContinuum.one_step_bound` and the exponential remainder
  bound for each two-component chiral block.
- If Mathlib has no block-diagonal L2-operator-norm equality, use upper/lower
  block embeddings and a triangle estimate; `kineticRemainderC` deliberately
  includes a factor two.
- Conjugation by `diracBasis` has norm one and must not enlarge the bound.
- For the product, use the exact identity
  `M*W - 1 - (A+B) = (M-1-A)*W + (W-1-B) + A*(W-1)`.
- Compare the product and exact exponential through their common
  linearization, then telescope with exact unitarity.

## Local preflight

The source file typechecks with exactly twelve documented draft proof holes:

```powershell
lake env lean PhysicsSM/Draft/NullEdge/HNUMassiveContinuumReduction.lean
```

Context pack:
`AgentTasks/context-packs/hnu-massive-continuum-20260720-20260720-134944.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 4fc6023e-bfcb-48d5-9b60-6ed079f27237
  task_id: 3e59da15-1846-42b8-99f0-70e8df91348c
  target_file: PhysicsSM/Draft/NullEdge/HNUMassiveContinuumReduction.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction
  submission_project: AgentTasks/aristotle-submit/hnu-massive-continuum-reduction-20260720-project
  output_dir: AgentTasks/aristotle-output/4fc6023e-bfcb-48d5-9b60-6ed079f27237
  status: integrated
```

## Integration result

Aristotle closed all twelve target proof holes without weakening the HNU walk,
the opposite-chirality doubling, or the `O(eps^2)` one-step shape.  The landed
module proves the exact Pluecker mass exponential, the HNU-specific doubled
kinetic remainder, a massive one-step estimate, and fixed-time `O(1/n)`
convergence at each continuum momentum.  It also includes an explicit nonzero
kinetic-plus-mass witness.

The result remains a fixed-momentum theorem.  The changing-lattice,
position-space massive Dirac theorem is the next composition gate.

Verified locally:

```powershell
lake build PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReduction
lake build PhysicsSM.Draft.NullEdge.HNUMassiveContinuumReductionAxiomGuard
```
