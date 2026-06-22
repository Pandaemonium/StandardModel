# Aristotle task: bundle Dirac slash Plucker core

Date: 2026-06-21

## Objective

Prove the focused finite theorem that composes the static Dirac-slash square
root with the finite Plucker mass theorem for a bundle of visible null spinors.

Target file:

```text
NullEdgeBundleDiracPluckerCore/Finite.lean
```

Expected module:

```text
NullEdgeBundleDiracPluckerCore.Finite
```

## Theorem targets

```lean
sigmaMomentum_matrixWeylCoords_eq
minkowskiNorm_matrixWeylCoords_eq_det
sigma_mul_barSigma_eq_norm
barSigma_mul_sigma_eq_norm
chiralDiracSlash_sq_eq_norm
finBundleMomentum_det_eq_pairwisePluckerMass
bundleMomentum_minkowskiNorm_eq_pairwisePluckerMass
chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass
```

## Why this matters

This is the high-value bridge from the determinant-level Plucker theorem to an
operator-level statement.  It should prove, in one standalone package, that the
Dirac slash built from the finite bundle momentum squares to the pairwise
Plucker mass.

## Proof guidance

- The coordinate extraction theorem is a `2 x 2` calculation. Use `ext` and
  `fin_cases`.
- The determinant/Minkowski theorem should follow from
  `sigmaMomentum_matrixWeylCoords_eq` and `Matrix.det_fin_two`, or by direct
  calculation.
- The bundle determinant theorem is the finite Cauchy-Binet/Plucker identity.
  The previous Gram Cauchy-Binet job may be useful as a proof template:
  expand the determinant, fold double sums to unordered pairs, and use wedge
  antisymmetry.
- The final operator theorem should follow by composing
  `chiralDiracSlash_sq_eq_norm` with
  `bundleMomentum_minkowskiNorm_eq_pairwisePluckerMass`.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Do not change the `(+---)` convention without documenting it.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-bundle-dirac-plucker-core-20260621/NullEdgeBundleDiracPluckerCore/Finite.lean
```

Result before submission: passed with exactly eight intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 7bb9ddb0-2798-45ac-83fb-c94aa224243d
  task_id: 6b46aa7c-261e-4bba-a28f-bd1519609996
  target_file: NullEdgeBundleDiracPluckerCore/Finite.lean
  expected_module: NullEdgeBundleDiracPluckerCore.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-bundle-dirac-plucker-core-20260621-project
  output_dir: AgentTasks/aristotle-output/7bb9ddb0-2798-45ac-83fb-c94aa224243d
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`7bb9ddb0-2798-45ac-83fb-c94aa224243d`; `aristotle tasks` reported task
`6b46aa7c-261e-4bba-a28f-bd1519609996` as `QUEUED`.

## Integration

Aristotle reported the task as `COMPLETE_WITH_ERRORS`, but the extracted
`ARISTOTLE_SUMMARY.md` states that all eight target holes were closed and that
the standalone target file validated. Local verification confirmed:

```text
lake env lean AgentTasks\aristotle-output\7bb9ddb0-2798-45ac-83fb-c94aa224243d\extracted\project-files.tar\null-edge-bundle-dirac-plucker-core-20260621-project_aristotle\NullEdgeBundleDiracPluckerCore\Finite.lean
```

Integrated 2026-06-21 as:

```text
PhysicsSM/Draft/NullEdgeBundleDiracPluckerCore.lean
```

The repo-native module imports the trusted
`PhysicsSM.Spinor.PluckerMass.fin_bundle_plucker_mass_identity` and the draft
Dirac slash core, then proves the Weyl-coordinate extraction and the composed
bridge theorem:

```text
chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass
```

Verification:

```text
lake env lean PhysicsSM\Draft\NullEdgeBundleDiracPluckerCore.lean
lake build PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore
lake env lean PhysicsSMDraft.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\NullEdgeBundleDiracPluckerCore.lean
git diff --check -- PhysicsSM\Draft\NullEdgeBundleDiracPluckerCore.lean PhysicsSM\Draft\NullEdgeDiracMassShellProjectorsCore.lean PhysicsSMDraft.lean AgentTasks\null-edge-dirac-mass-shell-projectors-core-aristotle-2026-06-21.md
```
