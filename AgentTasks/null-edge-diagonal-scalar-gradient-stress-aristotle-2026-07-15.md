# Diagonal scalar-gradient stress: Aristotle semantic audit

```yaml
aristotle:
  project_id: 980985db-8fd2-4ef3-b721-9666102ca908
  task_id: 51764216-7392-4f1a-8340-e2463b7ffc7b
  target_file: PhysicsSM/Draft/NullEdge/DiagonalScalarGradientStressVariation.lean
  expected_module: PhysicsSM.Draft.NullEdge.DiagonalScalarGradientStressVariation
  submission_project: AgentTasks/aristotle-submit/null-edge-diagonal-scalar-gradient-stress-20260715-project
  output_dir: AgentTasks/aristotle-output/980985db-8fd2-4ef3-b721-9666102ca908
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Audit the first spatial-gradient extension of the G6 scalar stress control.
Check the `(+---)` oriented action, all lapse and scale derivatives, the
longitudinal/transverse pressure split, the stress-index interface, and the
nonzero anisotropic witness. Preserve theorem statements unless a genuine
mathematical or sign defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-diagonal-scalar-gradient-stress-20260715-20260715-023314.md
```

## Locked interpretation

1. The diagonal coframe is `diag(N,a1,a2,a3)` with metric signature `(+---)`.
   The action uses the oriented determinant; identifying it with `sqrt(-g)`
   additionally requires positive orientation.
2. `velocity` and `gradient` are coordinate derivatives held fixed under
   coframe variation. The single gradient is along spatial direction 1.
3. The expected density and covariant orthonormal pressures are
   `rho=Kt+Kx+V`, `p1=Kt+Kx-V`, and `p2=p3=Kt-Kx-V`, where
   `Kt=velocity^2/(2*N^2)` and `Kx=gradient^2/(2*a1^2)`.
4. Normalized diagonal coframe responses couple to minus the mixed components;
   the assembled matrix records covariant orthonormal components. Do not
   conflate those index interfaces.
5. No off-diagonal variation, flux, localization, equation of motion, Noether
   identity, conservation theorem, or graph-derived matter action is claimed.

## Required audit

1. Run only
   `lake env lean PhysicsSM/Draft/NullEdge/DiagonalScalarGradientStressVariation.lean`
   or the corresponding targeted module build.
2. Independently reduce the scalar action with one spatial gradient and verify
   every sign and factor of `N,a1,a2,a3`.
3. Differentiate with respect to all four diagonal coframe coordinates and
   compare term-by-term with the Lean statements.
4. Verify the covariant/mixed stress-component mapping and explain why the
   longitudinal gradient contribution changes sign relative to the transverse
   pressures.
5. Audit the witness `(v,w,V,N,a_i)=(2,2,1,1,1)` and all prose against
   vacuity, false shape, oriented-versus-positive volume confusion, and claims
   beyond diagonal response.
6. Recommend the strongest next theorem adding one time-space off-diagonal
   coframe or ADM-shift variation and recovering the corresponding flux.

## Required report

Return command results, independent calculations, theorem-by-theorem verdicts,
assumption footprints, exact prose corrections, falsification controls, and a
remaining-obligations ledger. Finish with statement changes, proof holes,
axioms, and all convention assumptions used.

## Submission record

- Submitted project: `980985db-8fd2-4ef3-b721-9666102ca908`.
- Submitted task: `51764216-7392-4f1a-8340-e2463b7ffc7b`.
- Initial task state: `QUEUED`.
- Focused package contains only the three required Lean modules, task note,
  context pack, and Mathlib project metadata; no `.lake` directory was
  submitted.

## Harvest record

- Aristotle found no mathematical defect and changed no theorem, definition,
  or proof.
- The audit independently confirmed all four derivatives, the
  longitudinal/transverse sign split, the exact witness
  `(rho,p1,p2,p3)=(5,3,-1,-1)`, and derivative tuple `(-5,3,-1,-1)`.
- The live prose now states that coordinate derivatives are held fixed,
  distinguishes oriented determinant from `sqrt(-g)`, lists full geometric
  nondegeneracy, and locks the covariant-versus-mixed component interface.
- Full report:
  `AgentTasks/aristotle-output/980985db-8fd2-4ef3-b721-9666102ca908/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/980985db-8fd2-4ef3-b721-9666102ca908/ARISTOTLE_SUMMARY.md`.
