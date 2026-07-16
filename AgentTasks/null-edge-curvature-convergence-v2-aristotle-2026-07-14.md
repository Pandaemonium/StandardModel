# Curvature convergence interface v2: exact-target Aristotle audit

```yaml
aristotle:
  project_id: 970cadfd-0a46-4064-bdbf-ad83473a4392
  task_id: 7a8790c7-4189-43d8-beb9-56d8ca273809
  target_file: PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean
  expected_module: PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
  submission_project: AgentTasks/aristotle-submit/null-edge-curvature-convergence-v2-20260714-project
  output_dir: AgentTasks/aristotle-output/970cadfd-0a46-4064-bdbf-ad83473a4392
  status: complete and harvested with focused-package import limitation 2026-07-14
```

## Objective

Repeat the curvature convergence audit with the exact live target present. The
first package omitted that path. This v2 target also includes the new raw
remainder estimate and quantitative convergence theorem requested by the first
audit.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-curvature-convergence-v2-20260714-20260714-234242.md
```

## Locked interpretation

1. The first-order residual structure is a valid sufficient-condition
   interface, not a derivation from graph holonomy.
2. The quantitative theorem assumes a raw estimate
   `norm(H - base - area * target) <= area * epsilon` with positive eventual
   area and `epsilon -> 0`; it derives normalized curvature convergence.
3. The component-limit theorems must derive limiting antisymmetries and
   differential Bianchi from discrete identities and componentwise convergence
   before invoking the explicit contraction theorem.
4. The remaining graph debt is the construction of areas and matrix holonomies,
   the raw error estimate, the matrix-to-component map, and convergence of
   covariant difference quotients to curvature derivatives.

## Required audit

1. Run the generated root target, which imports the exact live convergence file
   and exact contraction dependency.
2. Verify the raw-error normalization inequality, including positivity and
   signed/zero-area boundaries.
3. Verify the squeeze argument from `epsilon -> 0`.
4. Inspect every limit-passing proof and confirm the limiting Bianchi premises
   are derived rather than renamed.
5. Check both nonzero witnesses and all theorem docstrings for overclaim.
6. Do not run a broad build or change theorem statements.

## Required report

Return commands and results, assumption footprints, counterexample attempts, a
theorem-by-theorem verdict, and the exact matrix-holonomy derivative theorem
that should be targeted next.

## Harvested result

Aristotle preserved the exact live target byte-for-byte and found the source
arguments mathematically sound. In particular, eventual positive area turns
the raw estimate

```text
norm(H - base - area * target) <= area * epsilon
```

into normalized error at most `epsilon` with exactly one area cancellation,
and `epsilon -> 0` gives convergence by a legitimate norm squeeze. Explicit
zero-area and negative-area counterexamples confirm that strict positivity is
load-bearing for this signed raw-bound formulation.

The componentwise limit arguments genuinely derive both curvature
antisymmetries and differential Bianchi by uniqueness of real limits. Only
after those derived identities are available does
`limiting_divEinstein_eq_zero` invoke the explicit finite contracted-Bianchi
theorem. Both nonzero witnesses were judged nonvacuous and correctly scoped as
interface witnesses rather than graph constructions.

The prescribed focused-package command failed before elaboration because its
Lake configuration did not expose the `PhysicsSM` module prefix. Aristotle
therefore performed a source-level audit and did not claim a fresh successful
check. The unchanged live target has separately passed the local command
`lake env lean PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean`.

The exact next bridge is a graph-level theorem proving componentwise
convergence of covariant difference quotients of area-normalized matrix diamond
holonomies to the continuum covariant curvature derivative. It must construct
the areas, holonomies, transport, component extraction, raw consistency bound,
and discrete Bianchi inputs rather than assume the desired `Tendsto` result.

Full downloaded audit:

```text
AgentTasks/aristotle-output/970cadfd-0a46-4064-bdbf-ad83473a4392/extracted/project-files.tar/null-edge-curvature-convergence-v2-20260714-project_aristotle/AgentTasks/null-edge-curvature-convergence-v2-audit-report.md
```
