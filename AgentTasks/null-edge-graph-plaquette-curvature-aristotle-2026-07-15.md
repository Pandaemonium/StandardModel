# Graph plaquette curvature limit: Aristotle semantic audit

```yaml
aristotle:
  project_id: fa964306-2870-4d92-a789-9ffc1e53761d
  task_id: c7d9bc23-4a70-403d-9799-ac9fe5b6edb5
  target_file: PhysicsSM/Draft/NullEdge/GraphPlaquetteCurvatureLimit.lean
  expected_module: PhysicsSM.Draft.NullEdge.GraphPlaquetteCurvatureLimit
  submission_project: AgentTasks/aristotle-submit/null-edge-graph-plaquette-curvature-20260715-project
  output_dir: AgentTasks/aristotle-output/fa964306-2870-4d92-a789-9ffc1e53761d
  status: complete and harvested 2026-07-15
```

## Objective

Audit the exact finite-torus curvature construction as a nonvacuous G4
consistency witness. The live target and its focused dependency closure pass
local Lean checks. Aristotle should independently check transport order,
orientation sign, unit inverses, area normalization, residual convergence, and
the boundary between a constructed lattice family and graph-derived continuum
curvature.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-graph-plaquette-curvature-20260715-20260715-010532.md
```

The document-index refresh was attempted twice after the live edits but did not
finish within five minutes. The context-pack query itself completed against the
available semantic indexes. The exact live Lean sources in the focused package
remain the authoritative audit surface.

## Locked interpretation

1. `matrixPlaquettePathDifference` is an additive difference of two ordered
   two-edge transports. Its normalization base is zero; it is not itself a
   group-valued loop holonomy.
2. `groupSquareHolonomy` is the matrix value of an actual unit-valued transport
   around the closed history `0 -> 1 -> 2 -> 3 -> 0`. Its normalization base is
   the identity.
3. With the source module's list-fold convention, this orientation selects
   `groupCurvatureTarget = -[generatorA,generatorB]`. A sign change is allowed
   only if the transport order or displayed loop orientation proves the current
   declaration mathematically wrong.
4. The matrix topology is the componentwise topology inherited from the nested
   finite function space. The residual is explicitly `(0,-h;h,h^2)` in matrix
   coordinates.
5. The torus and group square are decorated constructions with chosen
   generators, mesh, area, and refinement parameter. They do not derive any of
   those data from a bare graph.
6. The headline proves a fixed nonzero holonomy-curvature limit. It does not
   identify a continuum Riemann tensor, prove Riemann symmetries or derivative
   convergence, or derive Einstein dynamics.

## Required audit

1. Run the focused command
   `lake build PhysicsSM.Draft.NullEdge.GraphPlaquetteCurvatureLimit`. A fresh
   focused package must build the copied sibling modules before the direct
   `lake env lean PhysicsSM/Draft/NullEdge/GraphPlaquetteCurvatureLimit.lean`
   command can resolve them; the direct command may then be used as a secondary
   check. Do not run a broad project build.
2. Verify the upper/lower nilpotent affine links and their displayed exact
   inverses for every real `h`.
3. Expand `transportFrom` independently and confirm the exact matrix in
   `groupSquareHolonomy_value`, including multiplication order and loop closure.
4. Check that the identity-plus-`h^2` expansion has target `-[A,B]`, and explain
   its relation to the positive `[A,B]` in the two-path-difference theorem.
5. Check positivity and nonvanishing of `plaquetteArea`, componentwise residual
   convergence, and the normalized limit theorem.
6. Audit the headline against vacuity, hollow telescoping, prose outrunning the
   kernel, and false mathematical shape.
7. Identify the strongest precise next theorem toward general lattice
   connection consistency or curvature-derivative convergence without
   overclaiming bare-graph reconstruction.

## Required report

Preserve every theorem statement unless a mathematical defect is found. Return
command results, assumption footprints, theorem-by-theorem verdicts,
independent matrix calculations, falsification attempts, exact prose
corrections, and a short G4 remaining-obligations ledger. Put the report in
`AgentTasks/null-edge-graph-plaquette-curvature-audit-report-2026-07-15.md` and
finish with a concise summary of statement changes, remaining proof holes, and
assumptions used.

## Submission record

- Submitted project: `fa964306-2870-4d92-a789-9ffc1e53761d`.
- Submitted task: `c7d9bc23-4a70-403d-9799-ac9fe5b6edb5`.
- Initial state: project `RUNNING`, task `QUEUED`; the task subsequently entered
  `IN_PROGRESS`.
- The package scan found no proof-hole lines, new assumption declarations, or
  unsafe declarations in any of the five copied Lean files.
- A fresh local build of the focused copy was attempted, but its empty cache
  began rebuilding all of Mathlib and had not reached the copied modules after
  five minutes. The redundant build was stopped and only that temporary
  package's `.lake` directory was removed before submission. The exact live
  target passed `lake env lean` and
  `lake build PhysicsSM.Draft.NullEdge.GraphPlaquetteCurvatureLimit`; the live
  `PhysicsSMDraft` root also passed with the new import.

## Harvested result

Aristotle independently confirmed the nilpotent inverse formulas, the
later-edges-on-the-left `transportFrom` multiplication order, closure of
`0 -> 1 -> 2 -> 3 -> 0`, and the exact matrix

```text
[[1-h^2, -h^3],
 [h^3, 1+h^2+h^4]].
```

For that orientation, the genuine group loop is
`U_B^-1 U_A^-1 U_B U_A`, so its coefficient is exactly `-[A,B]`; the positive
`[A,B]` coefficient belongs to the separate additive two-path difference.
Area positivity holds at every refinement index, the residual converges
componentwise in the finite matrix topology, and the target is genuinely
nonzero. The audit found no vacuity, hollow telescoping, false shape, theorem
statement change, or remaining proof hole.

Two docstrings were narrowed in the live file. The helper reported an apparent
signature change only because the returned copy line-wrapped and shortened
fully qualified `#print axioms` commands; inspection of the exact diff and
audit report confirmed that no declaration signature changed, so the returned
source was not applied wholesale.

Full audit report:

```text
AgentTasks/aristotle-output/fa964306-2870-4d92-a789-9ffc1e53761d/extracted/project-files.tar/null-edge-graph-plaquette-curvature-20260715-project_aristotle/AgentTasks/null-edge-graph-plaquette-curvature-audit-report-2026-07-15.md
```
