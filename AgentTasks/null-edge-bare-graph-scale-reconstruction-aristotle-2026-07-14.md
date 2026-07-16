# Bare-graph scale reconstruction: Aristotle proof and semantic audit

```yaml
aristotle:
  project_id: 78f2db65-b0e0-4f83-b39c-c1163f2b6cbe
  task_id: a970d6fb-b8f2-42f9-94b7-c7b1a626ad40
  target_file: PhysicsSM/Draft/NullEdge/BareGraphScaleReconstruction.lean
  expected_module: PhysicsSM.Draft.NullEdge.BareGraphScaleReconstruction
  submission_project: AgentTasks/aristotle-submit/null-edge-bare-graph-scale-reconstruction-20260714-project
  output_dir: AgentTasks/aristotle-output/78f2db65-b0e0-4f83-b39c-c1163f2b6cbe
  status: complete and harvested 2026-07-14
```

## Objective

Audit the new exact boundary between a bare finite relation and calibrated
four-dimensional scale reconstruction. The live target already passes its
narrow Lean check. Aristotle should independently review the theorem shapes,
try to break the no-go and uniqueness claims, and offer statement-preserving
proof improvements only when they clarify the mathematics.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-bare-graph-scale-reconstruction-20260714-20260714-224254.md
```

## Locked interpretation

1. `RelationAutomorphism R T` means only that a vertex equivalence preserves
   the directed relation in both directions.
2. `GraphInvariant R s` is invariance of a real scalar field under every such
   relabeling. It is not a claim that every physically admissible graph
   observable has this form.
3. `bareGraphScale_rescaling_ray` proves only that relabeling invariance and
   positivity do not select an absolute normalization: every positive global
   multiple is still invariant, and a nonunit multiple differs from the
   original field.
4. `countingVolume density n = n / density` treats density as an independent
   calibration. The theorem must not imply that raw count derives density.
5. The constructive scale theorem is four-dimensional and conditional on a
   nondegenerate real coframe representative. It selects the unique positive
   Weyl factor whose absolute determinant equals calibrated counting volume.
6. No theorem here derives manifoldlikeness, a coframe, Lorentz signature,
   spin structure, curvature, or Einstein dynamics from the bare relation.

## Required audit

1. Check all definitions and theorem statements for vacuity, hidden inserted
   scale, false generality, and sign or determinant mistakes.
2. Verify that `graphInvariant_constant_of_vertexTransitive` and
   `bareGraphScale_rescaling_ray` express exactly the claimed orbit and global
   normalization obstructions.
3. Verify the density-calibration injectivity argument for every nonzero count.
4. Verify the fourth-root construction, Weyl weight four, existence, and
   uniqueness of the positive conformal factor.
5. Check that no negative-Weyl or orientation claim is being smuggled into the
   use of absolute determinant.
6. Inspect the two explicit witnesses for nonvacuity.
7. Run only the narrow target command. Do not launch a broad repository build.

## Success and failure criteria

Success requires a convention-explicit semantic report and a narrow Lean pass
without changing the locked theorem statements. If a statement is false or
overclaimed, return the exact counterexample or minimum corrected wording. Do
not weaken a theorem merely to make a proof easier.

## Required report

Return the narrow command and result, assumption footprints, theorem-by-theorem
semantic verdict, any counterexample search performed, and the exact remaining
gap between calibrated conformal scale and a tetrad/spin/curvature
reconstruction from a bare graph.

## Harvested result

Aristotle completed the audit without changing any locked theorem statement or
proof. The narrow command `lake env lean BareGraphScaleReconstruction.lean`
passed. No precise mathematical defect was found, and the guarded declarations
used only `propext`, `Classical.choice`, and `Quot.sound`.

The audit explicitly tested the empty-type, zero-field, unit-rescaling,
zero-count, zero-density, negative-radicand, degenerate-coframe, zero-target,
negative-Weyl, orientation-loss, and coframe-nonuniqueness boundaries. Every
counterexample to a tempting stronger claim is excluded by an explicit
hypothesis or lies outside the stated conclusion.

The exact semantic endpoint is one uniquely calibrated positive Weyl factor on
the ray of an independently supplied nondegenerate coframe. The result does not
derive the density calibration, geometric carrier, coframe, metric signature,
spin structure, connection, curvature, or dynamics from the bare relation.

Full downloaded audit:

```text
AgentTasks/aristotle-output/78f2db65-b0e0-4f83-b39c-c1163f2b6cbe/extracted/project-files.tar/null-edge-bare-graph-scale-reconstruction-20260714-project_aristotle/AgentTasks/BareGraphScaleReconstruction-semantic-audit-2026-07-15.md
```
