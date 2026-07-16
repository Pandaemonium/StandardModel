# Null-edge curvature convergence interface: Aristotle semantic audit

```yaml
aristotle:
  project_id: 0d2f22ae-2ef8-402d-aa78-db178a0bbdfe
  task_id: d3a653f0-7ba4-4eab-a199-bbb3bf76cdb8
  target_file: PhysicsSM/Draft/NullEdge/CurvatureConvergenceInterface.lean
  expected_module: PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
  submission_project: AgentTasks/aristotle-submit/null-edge-curvature-convergence-20260714-project
  output_dir: AgentTasks/aristotle-output/0d2f22ae-2ef8-402d-aa78-db178a0bbdfe
  status: complete and harvested with packaging limitation 2026-07-14
```

## Objective

Audit the first explicit G4 convergence interface. The target and its exact
`FiniteContractedBianchi` dependency pass narrow Lean checks. Aristotle should
try to falsify the theorem shapes, identify hidden tautology or overclaim, and
preserve the statements unless a precise mathematical defect is found.

Semantic context pack:

```text
AgentTasks/context-packs/null-edge-curvature-convergence-20260714-20260714-231714.md
```

## Locked interpretation

1. `FirstOrderHolonomyLimit` is a sufficient-condition interface. It assumes a
   shrinking-loop first-order expansion with a vanishing normalized residual;
   it does not derive that expansion from graph transport.
2. `base` is the zero-area holonomy value, normally the identity matrix in a
   concrete realization. The generic theorem uses an additive normed vector
   space only to isolate the normalization and limit step.
3. `firstOrderHolonomyLimit_converges` should prove both that the areas shrink
   and that area-normalized holonomy displacement converges to `target`.
4. The component-limit theorems assume pointwise convergence of every fixed
   component. They derive limiting antisymmetries and differential Bianchi by
   uniqueness of limits; they do not assume the limiting identities.
5. `limiting_divEinstein_eq_zero` invokes an earlier explicit finite-index
   contraction theorem only after deriving its limiting premises.
6. No result constructs refinement maps, diamond areas, holonomies, curvature
   components, derivative convergence, a continuum connection, or an Einstein
   field equation from a bare graph.

## Required audit

1. Check the first-order normalization algebra and every eventually/nonzero
   condition, including sign and zero-area edge cases.
2. Decide whether the exact expansion hypothesis is usefully non-tautological
   as an interface and recommend the next stronger error-bound or little-o
   formulation without weakening the current theorem.
3. Check each passage of antisymmetry and differential Bianchi through
   componentwise limits.
4. Check that the contracted limit theorem genuinely derives, rather than
   renames, the limiting Bianchi premises.
5. Inspect both nonzero witnesses for vacuity and physical overinterpretation.
6. Identify the exact additional theorem needed to connect matrix diamond
   holonomies to the real componentwise `dR` sequence.
7. Run only the two narrow Lean commands for the included modules. Do not run a
   broad build.

## Success and failure criteria

Success requires a theorem-by-theorem semantic verdict, narrow Lean results,
and exact wording corrections for any overclaim. If a statement is false,
return a counterexample. Do not replace a derived premise with an assumption or
weaken a statement for convenience.

## Required report

Return commands and results, assumption footprints, falsification attempts,
the theorem-shape verdict, and a concise next-interface proposal connecting
graph holonomy, curvature components, derivative convergence, and contracted
Bianchi.

## Harvested result

Aristotle confirmed that the explicit finite contractions are genuine and that
the first-order holonomy theorem is a valid sufficient-condition interface. It
also emphasized that a vanishing normalized residual already contains much of
the desired convergence, and recommended a raw little-o or error-bound theorem.
That recommendation has been implemented as
`normalizedHolonomy_tendsto_of_error_bound`.

The exact next graph bridge is componentwise convergence of covariant difference
quotients of area-normalized matrix diamond holonomies to the curvature
derivative tensor. Pointwise curvature convergence alone is insufficient for
that derivative convergence.

The original focused package accidentally omitted the exact convergence target
and retained only a dotted root import, so Aristotle could not rerun or fully
inspect the component-limit proofs. A corrected v2 audit was submitted after
this harvest.

Full downloaded audit:

```text
AgentTasks/aristotle-output/0d2f22ae-2ef8-402d-aa78-db178a0bbdfe/extracted/project-files.tar/null-edge-curvature-convergence-20260714-project_aristotle/AgentTasks/null-edge-curvature-convergence-audit-report-2026-07-15.md
```
