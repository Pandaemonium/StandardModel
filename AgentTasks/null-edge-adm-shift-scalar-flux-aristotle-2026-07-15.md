# ADM-shift scalar flux: Aristotle semantic audit

```yaml
aristotle:
  project_id: 72744313-4ac9-401e-a905-34cc98f4d3da
  task_id: beb2eb6b-4436-468f-8fb8-96fe53169e05
  target_file: PhysicsSM/Draft/NullEdge/ADMShiftScalarFluxVariation.lean
  expected_module: PhysicsSM.Draft.NullEdge.ADMShiftScalarFluxVariation
  submission_project: AgentTasks/aristotle-submit/null-edge-adm-shift-scalar-flux-20260715-project
  output_dir: AgentTasks/aristotle-output/72744313-4ac9-401e-a905-34cc98f4d3da
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Audit the first off-diagonal G6 scalar stress control. Check the ADM coframe,
normal derivative, shift derivative, sign and normalization of the canonical
momentum density, conversion to covariant orthonormal `T_(hat 0)(hat 1)`, the
assembled symmetric matrix, and the nonzero witness. Preserve declarations
unless a genuine mathematical, sign, or index-interface defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-adm-shift-scalar-flux-20260715-20260715-030830.md
```

## Locked interpretation

1. Signature is `(+---)` and the supplied coframe is
   `theta0=N dt`, `theta1=a1(dx1+beta dt)`, `theta2=a2 dx2`,
   `theta3=a3 dx3`.
2. `velocity=partial_t phi` and `gradient=partial_1 phi` are coordinate
   derivatives held fixed under shift variation. The unit-normal derivative
   is `(velocity-beta*gradient)/N`.
3. The oriented action is
   `a1*a2*a3*((velocity-beta*gradient)^2/(2*N)
   -N*gradient^2/(2*a1^2)-N*V)`.
4. Its beta derivative should be
   `-a1*a2*a3*gradient*(velocity-beta*gradient)/N`. The positive canonical
   momentum density is defined as the negative of this response.
5. The covariant orthonormal flux should be
   `T_hat01=((velocity-beta*gradient)/N)*(gradient/a1)`, with canonical
   density `a1^2*a2*a3*T_hat01`. Audit this against coordinate metric
   variation, including the fact that nonzero beta changes both `g00` and
   `g01`.
6. The assembled matrix packages separately derived diagonal and shift
   responses. It is not a theorem deriving every tensor component from an
   arbitrary coframe variation.
7. No lapse, shift, tetrad, graph localization, scalar action, matter equation,
   Noether identity, conservation law, or graph stress tensor is derived here.

## Required audit

1. Run only
   `lake env lean PhysicsSM/Draft/NullEdge/ADMShiftScalarFluxVariation.lean`.
2. Independently invert the coframe and metric and rederive the scalar action.
3. Differentiate with respect to beta at arbitrary beta and verify every sign
   and factor of `N,a1,a2,a3`.
4. Derive the coordinate metric-variation response and verify that its
   covariant orthonormal interpretation is exactly `T_hat01`, not `T^01`, a
   mixed component, or its negative.
5. Audit `canonicalShiftMomentumDensity_eq_flux`, symmetry and component
   extraction for `shiftedGradientStress`, and the unit witness.
6. Check all prose against vacuity, false shape, oriented-versus-positive
   volume confusion, and claims beyond the single shift response.
7. Recommend the strongest next matter theorem toward a local conserved stress
   tensor, stating the additional field equation and localization hypotheses.

## Required report

Return command results, independent coframe and metric calculations,
declaration-by-declaration verdicts, assumption footprints, exact prose or
statement corrections, falsification controls, and a remaining-obligations
ledger. Finish with statement changes, proof holes, axioms, and every
convention assumption used.

## Submission record

- Submitted project: `72744313-4ac9-401e-a905-34cc98f4d3da`.
- Submitted task: `beb2eb6b-4436-468f-8fb8-96fe53169e05`.
- Initial task state: `QUEUED`.
- Focused package contains exactly the four required Lean modules, task note,
  context pack, and Mathlib project metadata; no `.lake` cache was submitted.

## Harvest record

- Aristotle found no mathematical, sign, normalization, or index-interface
  defect and changed no declaration statement or proof.
- The audit independently inverted the shifted coframe and metric, confirmed
  that nonzero shift varies both `g00` and `g01`, and recovered exactly the
  covariant orthonormal component `T_(hat 0)(hat 1)` with conversion factor
  `a1^2*a2*a3`.
- The live prose now says the canonical momentum density is sign-defined, not
  numerically nonnegative. Fully qualified live axiom guards were retained;
  they pass in the repository build.
- Detailed report:
  `AgentTasks/aristotle-output/72744313-4ac9-401e-a905-34cc98f4d3da/extracted/project-files.tar/null-edge-adm-shift-scalar-flux-20260715-project_aristotle/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/72744313-4ac9-401e-a905-34cc98f4d3da/extracted/project-files.tar/null-edge-adm-shift-scalar-flux-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`.
