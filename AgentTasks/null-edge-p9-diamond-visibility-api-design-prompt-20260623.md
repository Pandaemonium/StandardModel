# Aristotle strategy/design job: P9 DiamondSourceVisibility API Design

```yaml
job_name: null-edge-p9-diamond-source-visibility-api-design-20260623
status: submitted
project_id: 45929669-f4b1-4cbf-9f49-e4f624ef66bc
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-diamond-source-visibility-api-design-20260623-project
target_file: AgentTasks/aristotle-p9-diamond-visibility-api-design-report.md
```

## Context

The P9 cosmological-constant / source-visibility branch has a finite theorem spine:
- boundary-exact invisibility (`PhysicsSM.Draft.NullEdgeP9BoundarySource`)
- chain-complex no-bulk-source (`PhysicsSM.Draft.NullEdgeP9BFClosure`)
- mean-zero cancellation (`PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation`)
- closed-visible-fan rest energy (`PhysicsSM.Draft.NullEdgeP9VisibleFanMassCharacterization`)
- fluctuation/suppression scaling (`PhysicsSM.Draft.NullEdgeP9UniformSuppression`, `PhysicsSM.Draft.NullEdgeP9WeightedFluctuation`)

Currently, these modules use abstract cochains, abstract unit tests, and abstract amplitudes. The bottleneck is the lack of a *geometric* definition layer.

## Assignment

Propose ONE coherent `DiamondSourceVisibility` API that makes the amplitudes, tests, and screens geometric:

1. A finite diamond/screen with incidence data (faces, cells, boundary).
2. Geometric cell weights identifying `amp_i` with an area/volume/chosen diamond measure rather than an abstract real number.
3. A curvature or holonomy-defect cochain replacing `unitTest`, so a "visible" source is one that pairs non-trivially with a curvature defect.
4. An observer/coarse-graining projection so that invisibility means lying in the kernel of the observer map.
5. Bridge maps showing the existing finite theorems (boundary-exact invisibility, closed-fan rest energy, variance scaling) are special cases of the new geometric API.

Then state, as handoff theorem signatures (not proofs), the next 5-8 theorems the API should make provable, including:
- `boundaryExact_iff_invisible_to_curvatureDefects`
- `diamondResidualVariance_scales_with_cellArea`
- `recoverabilityGap_controls_sourceVisibility`

Please end with this exact summary shape:

```text
overall assessment:
proposed core definitions:
bridge lemmas to existing theorems:
ranked next theorem signatures:
likely blockers:
integration notes:
```
