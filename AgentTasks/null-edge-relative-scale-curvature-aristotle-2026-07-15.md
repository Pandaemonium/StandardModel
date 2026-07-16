# Relative scale and curvature calibration: Aristotle semantic audit

```yaml
aristotle:
  project_id: 32c7460c-8b20-4002-b3bb-2ca7546c470c
  task_id: ef1a6310-99cf-480c-a8ad-31d88948d70a
  target_file: PhysicsSM/Draft/NullEdge/RelativeScaleCurvatureBridge.lean
  expected_module: PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge
  submission_project: AgentTasks/aristotle-submit/null-edge-relative-scale-curvature-20260715-project
  output_dir: AgentTasks/aristotle-output/32c7460c-8b20-4002-b3bb-2ca7546c470c
  status: complete, harvested, and integrated 2026-07-15
```

## Objective

Audit the density-free relative Weyl-scale reconstruction and its exact
inverse-area action on normalized holonomy curvature. Check that every theorem
is mathematically correct, nonvacuous, and described no more strongly than its
Lean statement permits. Preserve declarations unless a genuine mathematical
or convention defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-relative-scale-curvature-20260715-20260715-035431.md
```

## Locked interpretation

1. A bare relation supplies neither absolute length nor a physical density.
   `BareGraphScaleReconstruction` deliberately proves this no-go boundary.
2. The new reconstruction assumes dimension four, positive regional event
   counts, supplied conformal coframe representatives, positive representative
   volumes, and one common unknown count density across the compared regions.
3. Under those hypotheses, the common density cancels and the relative Weyl
   factor is
   `r^4 = n * volume(e0) / (n0 * volume(e))`.
4. One positive anchor scale supplies the remaining global unit. The theorem
   does not derive that unit, the regions, counts, coframes, dimension,
   manifoldlikeness, tetrad/spin structure, areas, holonomies, or dynamics.
5. The relative area factor is the isotropic four-dimensional Weyl weight
   `r^2`; this is not a claim that arbitrary geometric areas follow from
   volume alone.
6. Scaling every supplied plaquette area by a constant `c` changes
   `(H-I)/A` by `c^-1`. The bridge applies this identity to `c=r^2`; it does
   not derive the base area or holonomy family from a graph.
7. On a vertex-transitive bare relation, invariant count and representative-
   volume fields give a constant relative profile. Inhomogeneous scale
   requires graph inhomogeneity or additional symmetry-breaking data.

## Required audit

1. Run only the narrow library target
   `lake build PhysicsSM.Draft.NullEdge.RelativeScaleCurvatureBridge`.
2. Independently verify the fourth-root cancellation theorem, relative-area
   square identity, anchor volume-ratio theorem, and positive uniqueness.
3. Audit `relativeScaleProfile_graphInvariant`, especially whether fixing the
   anchor while applying graph automorphisms is represented and described
   correctly.
4. Check all positivity and nonzero hypotheses for necessity under Lean's
   totalized division and roots.
5. Verify the exact `16:1` witness gives `r=2`, area factor `4`, and curvature
   limit `3/4` from the imported nonzero base limit `3`.
6. Audit the curvature rescaling theorem in an arbitrary normed real vector
   space, including scalar-action order and all continuity assumptions.
7. Check for vacuity, hollow algebra, false shape, imported-versus-derived
   confusion, convention drift, and prose that outruns the kernel.
8. Recommend the strongest next nonvacuous bridge toward graph-derived local
   scale or curvature without claiming a bare-graph metric reconstruction.

## Required report

Return command results, independent calculations, declaration-by-declaration
verdicts, assumption footprints, exact corrections, and a remaining-obligations
ledger. Finish with statement changes, proof holes, axioms, and every supplied
geometric assumption used.

## Submission record

- Submitted project: `32c7460c-8b20-4002-b3bb-2ca7546c470c`.
- Submitted task: `ef1a6310-99cf-480c-a8ad-31d88948d70a`.
- Initial task state: `QUEUED`.
- Focused package contains exactly five Lean modules, this task note, the
  semantic context pack, and Mathlib project metadata. No `.lake` cache was
  submitted.

## Harvest record

- Aristotle found no theorem, proof, factor, positivity, or nonvacuity defect.
- It clarified that `relativeScaleProfile_graphInvariant` is fixed-anchor
  invariance, distinct from simultaneous anchor covariance. The live module
  now states and proves that covariance separately.
- It clarified that zero area scaling is valid only as a totalized algebraic
  identity; physical calibration requires a positive factor. The corrected
  prose is integrated in `RelativeScaleCurvatureBridge.lean`.
- The recommended overlap-consistency bridge is now implemented locally:
  relative length transitions compose multiplicatively, reverse transitions
  multiply to one, and relative area transitions obey the squared cocycle.
- Detailed report:
  `AgentTasks/aristotle-output/32c7460c-8b20-4002-b3bb-2ca7546c470c/extracted/project-files.tar/null-edge-relative-scale-curvature-20260715-project_aristotle/SEMANTIC_AUDIT.md`.
- Aristotle summary:
  `AgentTasks/aristotle-output/32c7460c-8b20-4002-b3bb-2ca7546c470c/extracted/project-files.tar/null-edge-relative-scale-curvature-20260715-project_aristotle/ARISTOTLE_SUMMARY.md`.
