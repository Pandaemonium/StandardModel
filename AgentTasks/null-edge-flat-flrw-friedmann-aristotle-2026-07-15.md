# Flat-FLRW Friedmann control: Aristotle semantic audit

```yaml
aristotle:
  project_id: 4ea4e10a-1138-4135-bc84-15dd1fd0d0e5
  task_id: 589981d7-cbaf-4b43-89ae-ffc3af26e3f2
  target_file: PhysicsSM/Draft/NullEdge/FlatFLRWFriedmannControl.lean
  expected_module: PhysicsSM.Draft.NullEdge.FlatFLRWFriedmannControl
  submission_project: AgentTasks/aristotle-submit/null-edge-flat-flrw-friedmann-20260715-project
  output_dir: AgentTasks/aristotle-output/4ea4e10a-1138-4135-bc84-15dd1fd0d0e5
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Audit the conditional G7-G8 flat-FLRW control. Check the boundary-reduced
Einstein-Hilbert minisuperspace action, lapse and cosmological-term signs,
homogeneous scalar coupling, and exact equivalence between lapse stationarity
and the first Friedmann equation. Preserve theorem statements unless a real
mathematical or convention defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-flat-flrw-friedmann-20260715-20260715-021520.md
```

## Locked interpretation

1. Signature is `(+---)` and the continuum metric is assumed, not graph
   derived: `ds^2 = N(t)^2 dt^2 - a(t)^2 d x^2` with zero spatial curvature
   and coordinate cell volume one.
2. The imported continuum convention is
   `(R - 2 Lambda)/(16 pi G)`. After the standard boundary-term removal the
   proposed gravity action is
   `-3*a*adot^2/(8*pi*G*N) - Lambda*N*a^3/(8*pi*G)`.
3. The matter action is the separately audited oriented homogeneous scalar
   action `a^3*(v^2/(2*N)-N*V)`, with
   `rho=v^2/(2*N^2)+V`.
4. The proposed lapse residual is the derivative of gravity plus matter.
   For `G != 0`, `N != 0`, and `a != 0`, residual zero should be exactly
   `H^2=(8*pi*G/3)*rho+Lambda/3`, with `H=adot/(a*N)`.
5. No theorem may be read as deriving the FLRW ansatz, Einstein-Hilbert
   action, boundary term, lapse, scale factor, `G`, or `Lambda` from a graph.
   No acceleration equation or full Einstein equation is claimed.

## Required audit

1. Run only `lake env lean PhysicsSM/Draft/NullEdge/FlatFLRWFriedmannControl.lean`
   or the corresponding targeted module build.
2. Independently reduce the `(+---)` Einstein-Hilbert action, including the
   Gibbons-Hawking-York/boundary-term convention, and verify both signs and
   every factor of `3`, `8 pi G`, `N`, and `a`.
3. Differentiate the full reduced action with respect to `N`, holding
   coordinate derivatives fixed, and compare term-by-term with
   `lapseResidual`.
4. Verify both directions of `residual_zero_iff_friedmann`; check that the
   hypotheses are sufficient and whether any positivity assumptions are
   semantically required beyond the algebraic nonzero hypotheses.
5. Audit `positive_matter_friedmann_witness` for nonvacuity and exact
   normalization.
6. Audit all prose against vacuity, false shape, imported-versus-derived
   confusion, and overclaiming of Einstein dynamics.
7. Recommend the strongest next theorem: either a proper Euler-Lagrange scale
   variation yielding the acceleration equation, or a sharper graph-to-action
   obstruction/bridge if the minisuperspace control cannot advance G7.

## Required report

Return command results, independent calculations, theorem-by-theorem verdicts,
assumption footprints, exact prose corrections, falsification controls, and a
remaining-obligations ledger. Finish with statement changes, remaining proof
holes, and all convention assumptions used.

## Submission record

- Submitted project: `4ea4e10a-1138-4135-bc84-15dd1fd0d0e5`.
- Submitted task: `589981d7-cbaf-4b43-89ae-ffc3af26e3f2`.
- Initial task state: `QUEUED`.
- Focused package contains only the three required Lean modules, task note,
  context pack, and Mathlib project metadata; no `.lake` directory was
  submitted.

## Harvest record

- Aristotle found no mathematical defect and changed no existing theorem or
  definition statement.
- The independent audit confirmed the kinetic and cosmological signs, all
  lapse/scale powers, `8*pi*G` normalization, both logical directions, and the
  nonvacuous witness.
- The live source now locks the scalar-curvature convention, exact canceled
  total derivative/GHY convention, and fixed quantities under lapse variation.
- Two returned kernel-checked controls were integrated to show why the
  nonzero-scale and nonzero-coupling hypotheses cannot be dropped under Lean's
  totalized division.
- Full report:
  `AgentTasks/aristotle-output/4ea4e10a-1138-4135-bc84-15dd1fd0d0e5/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/4ea4e10a-1138-4135-bc84-15dd1fd0d0e5/ARISTOTLE_SUMMARY.md`.
