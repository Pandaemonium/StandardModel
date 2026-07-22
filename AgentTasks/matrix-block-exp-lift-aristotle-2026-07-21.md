# Aristotle task: matrix block exponential lift

Date: 2026-07-21
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: harvested; hole-free standalone bridge

## Objective

Split the stalled massive-HNU polynomial-cost composition into reusable
Mathlib-only lemmas: exponentiation through the live reindexed two-plus-two
block lift and through a fixed unitary Dirac-basis conjugation.

## Claim boundary

This is matrix-exponential bookkeeping. It does not prove the HNU endpoint
factorization, a product-formula rate, a continuum limit, or physical-sector
stability.

```yaml
aristotle:
  project_id: da3d3a9a-d760-4161-8289-7a2820128e0e
  task_id: a95ee78b-46b7-4aed-a6d3-9ae79b0df7f1
  target_file: MatrixBlockExpLift.lean
  expected_module: Mathlib-only matrix exponential lift
  submission_project: AgentTasks/aristotle-submit/matrix-block-exp-lift-20260721-project
  output_dir: AgentTasks/aristotle-output/da3d3a9a-d760-4161-8289-7a2820128e0e
  status: harvested
```

## Current proof state

At 08:34 PDT the task remained in progress. A fresh archive is preserved at
`AgentTasks/aristotle-output/da3d3a9a-d760-4161-8289-7a2820128e0e/in-progress-snapshot-0834.zip`.
The returned draft has stated the intended reindexed block-exponential and
unitary-conjugation lemmas, but the central exponential proofs still contain
handoff placeholders. Nothing from this job is integrated or root-imported.

## Final return

At 09:32 PDT Aristotle returned all four standalone lemmas hole-free and
verified them with the focused Mathlib-only build. The public theorem footprint
uses only `propext`, `Classical.choice`, and `Quot.sound`. The archive is
`AgentTasks/aristotle-output/da3d3a9a-d760-4161-8289-7a2820128e0e/completed-0932.zip`.

This bridge is harvested as proof material for the live massive-HNU draft. It
is not root-imported as a parallel API because `MC2BlockDiagonalLift.lean`
already owns the project-facing block-lift layer. The remaining work is to port
the exact proof terms into the live endpoint composition and close the ordered
kinetic product and norm bound.
