# Synchronized tetrad-bundle exact bridge: Aristotle proof task

```yaml
aristotle:
  project_id: 0d655055-f1d0-41f9-9d43-9da8406b3fe4
  task_id: a689b5e7-6b5a-4030-8e61-ef0a1bd631d6
  target_file: PhysicsSM/Draft/NullEdge/SynchronizedTetradBundle.lean
  expected_module: PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle
  submission_project: AgentTasks/aristotle-submit/synchronized-tetrad-bundle-20260715-project
  output_dir: AgentTasks/aristotle-output/0d655055-f1d0-41f9-9d43-9da8406b3fe4
  status: integrated
```

## Objective

Prove and semantically audit the exact finite matrix bridge suggested by the
positive Stage A20 synchronized metric-bundle benchmark. The standalone target
uses row-coordinate transitions `zY = zX * A`, row-gauge metric factorization
`g = e * eta * e^T`, and internal transition `L = eXInv * A * eY`.

The target has four locked results:

1. exact metric covariance implies `L * eta * L^T = eta`;
2. an exact affine cocycle implies the corresponding internal cocycle;
3. the three-edge bundle statement packages both conclusions; and
4. a nonidentity rational 1+1 boost witnesses nonvacuity.

## Locked interpretation

- These are exact conditional matrix theorems, not graph reconstruction.
- `eXInv * eX = 1` is the inverse order required by the Lorentz proof.
- `eY * eYInv = 1` is the inverse order required at the intermediate cocycle
  cancellation. The bundled result separately uses `eYInv * eY = 1` for the
  second Lorentz edge.
- Metric covariance follows the Python Stage A20 row-coordinate convention
  `gX = Axy * gY * Axy^T`.
- The conclusions do not establish properness, time orientation, an
  `SL(2,C)` lift, a central sign cochain, a spin structure, convergence, or
  emergence of metric data from a bare graph.
- Do not weaken theorem statements or reverse transpose/order conventions.

## Required work

1. Run only
   `lake env lean SynchronizedTetradBundle/MetricCoframeCocycle.lean` first.
2. Replace all executable proof holes with kernel-checked proofs.
3. Check every multiplication and transpose order against the locked row-gauge
   convention.
4. Confirm that each inverse hypothesis is used in the stated order and flag
   any redundant hypothesis.
5. Preserve the nonidentity boost witness; do not replace it with identity
   matrices.
6. Add small helper lemmas if they improve clarity, but do not alter the four
   public statements.
7. Report the exact axiom footprint and any use of classical matrix APIs.
8. Finish with a concise report: solved targets, statement changes, remaining
   proof holes, and every geometric input still conditional.

## Intended live integration

After local review, the proof will become
`PhysicsSM/Draft/NullEdge/SynchronizedTetradBundle.lean`, imported only after
its theorem statements, row/column conventions, and nonvacuity witness pass
semantic review and the pinned Lean build.

## Submission record

- The standalone target passed
  `lake env lean AgentTasks/aristotle-standalone/synchronized-tetrad-bundle-20260715/SynchronizedTetradBundle/MetricCoframeCocycle.lean`
  in the live pinned repository environment with only the four intended proof-
  hole warnings.
- The focused package passed
  `lake env lean SynchronizedTetradBundle/MetricCoframeCocycle.lean` after
  fetching the pinned Mathlib cache. Generated `.lake` dependencies were
  removed before upload.
- Submitted project: `0d655055-f1d0-41f9-9d43-9da8406b3fe4`.
- Submitted task: `a689b5e7-6b5a-4030-8e61-ef0a1bd631d6`.
- Initial task state: `QUEUED`.

## Harvest and integration

- Aristotle task `a689b5e7-6b5a-4030-8e61-ef0a1bd631d6` completed with all four
  theorem signatures unchanged.
- The returned symbolic proofs preserve the locked row-coordinate, transpose,
  inverse-order, and cocycle conventions.
- The returned finite witness used compiled evaluation. Before live integration
  it was replaced by a componentwise `norm_num` proof, so the live witness is
  kernel-checked without compiled-evaluator trust.
- Integrated live module:
  `PhysicsSM/Draft/NullEdge/SynchronizedTetradBundle.lean`.
- Added build-enforced axiom guard:
  `PhysicsSM/Draft/NullEdge/SynchronizedTetradBundleAxiomGuard.lean`.
- Every guarded theorem has transitive axiom footprint
  `[propext, Classical.choice, Quot.sound]`.
- The semantic boundary is unchanged: exact metric/coframe data and coordinate
  cocycles are hypotheses, not outputs of bare-graph reconstruction.

## Local verification

- `lake env lean PhysicsSM/Draft/NullEdge/SynchronizedTetradBundle.lean`
- `lake build PhysicsSM.Draft.NullEdge.SynchronizedTetradBundle`
- `lake env lean PhysicsSM/Draft/NullEdge/SynchronizedTetradBundleAxiomGuard.lean`
