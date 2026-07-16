# Homogeneous scalar coframe stress: Aristotle semantic audit

```yaml
aristotle:
  project_id: 6ae5615a-cdf1-4f14-8b6f-190bb6a2037c
  task_id: ecb7f6c0-6e4c-4863-b16f-bfada7361149
  target_file: PhysicsSM/Draft/NullEdge/HomogeneousScalarStressVariation.lean
  expected_module: PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation
  submission_project: AgentTasks/aristotle-submit/null-edge-homogeneous-scalar-stress-20260715-project
  output_dir: AgentTasks/aristotle-output/6ae5615a-cdf1-4f14-8b6f-190bb6a2037c
  status: complete and harvested 2026-07-15
```

## Objective

Audit the first constructed G6 coframe-dependent matter action. Check that the
`(+---)` homogeneous scalar action, volume normalization, lapse response,
spatial-scale responses, and assembled perfect-fluid component tensor are
mutually convention-consistent. Preserve theorem statements unless a real
mathematical or sign defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-homogeneous-scalar-stress-20260715-20260715-014501.md
```

## Locked interpretation

1. The diagonal coframe is interpreted in a fixed positive-orientation chart
   as `e = diag(N,a1,a2,a3)` with metric signature `(+---)`. The theorems are
   algebraic for nonzero `N`; physical positivity of all coframe scales is not
   claimed.
2. The reduced action is
   `a1*a2*a3 * (velocity^2/(2*N) - N*potential)`, equivalent for `N != 0` to
   oriented coframe volume times
   `1/2 g^{00} velocity^2 - potential`, with `g^{00}=N^-2`.
3. The lapse derivative should be `-spatialVolume*rho`, where
   `rho=velocity^2/(2*N^2)+potential`.
4. Each spatial-scale derivative should be `N*oppositeFaceArea*p`, where
   `p=velocity^2/(2*N^2)-potential`. Audit how this coefficient maps to
   covariant, contravariant, or mixed stress components under explicit metric
   and coframe variation conventions; do not conflate these interfaces.
5. `homogeneousScalarStress` assembles the standard covariant perfect-fluid
   component matrix `diag(rho,p,p,p)` in a mostly-minus orthonormal frame. The
   kernel proves its components and symmetry, not that arbitrary coframe
   variation has already produced the full tensor.
6. The action has no spatial gradients, flux, off-diagonal variation,
   localization, matter equation of motion, Noether identity, or conservation
   theorem.

## Required audit

1. Run only
   `lake build PhysicsSM.Draft.NullEdge.HomogeneousScalarStressVariation`.
2. Re-derive the action from `sqrt(-g) L` in the positive diagonal chart and
   verify every factor of `N` and every sign.
3. Independently differentiate with respect to `N,a1,a2,a3` and check the
   normalization of `rho` and `p`.
4. State the exact coframe-to-stress convention relating these derivatives to
   mixed or covariant components, including any sign introduced by varying
   `g_{mu nu}` versus `g^{mu nu}`.
5. Audit the nonzero witness and all prose against vacuity, false shape, and
   claims beyond the homogeneous diagonal sector.
6. Give the strongest precise next theorem adding one spatial-gradient or
   off-diagonal variation channel and the subsequent Noether-conservation
   obligation.

## Required report

Return command results, assumption footprints, independent calculations,
theorem-by-theorem verdicts, exact prose corrections, falsification controls,
and a G6 remaining-obligations ledger. Finish with statement changes, remaining
proof holes, and assumptions used.

## Submission record

- Submitted project: `6ae5615a-cdf1-4f14-8b6f-190bb6a2037c`.
- Submitted task: `ecb7f6c0-6e4c-4863-b16f-bfada7361149`.
- Initial state: task `QUEUED`.
- Both copied modules have no proof holes, new assumption declarations, or
  unsafe declarations. The exact live target passed direct Lean, and the
  headline nonzero response packet passed the axiom/source scan with no warning
  and only `propext`, `Classical.choice`, and `Quot.sound`.

## Harvest record

- Aristotle found no mathematical defect and changed no theorem or definition
  statement.
- The independent audit confirmed every lapse/scale derivative and the
  `(+---)` stress-index signs.
- The live source now incorporates the returned semantic corrections about
  oriented determinant versus `sqrt(-g)`, geometric nondegeneracy, covariant
  versus mixed components, and the limits of diagonal variation.
- Full report:
  `AgentTasks/aristotle-output/6ae5615a-cdf1-4f14-8b6f-190bb6a2037c/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/6ae5615a-cdf1-4f14-8b6f-190bb6a2037c/ARISTOTLE_SUMMARY.md`.
