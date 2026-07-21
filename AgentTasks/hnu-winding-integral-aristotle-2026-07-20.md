# Aristotle task: exact global HNU endpoint winding

Date: 2026-07-20
Owner: Codex
Work item: `QCA-3PLUS1-001`
Status: integrated

## Objective

Prove the four-rung target in
`HNUWindingIntegral/HNUWindingIntegral.lean`:

1. exact equality between the live depth-eight HNU endpoint and the published
   `S^3` coordinate formula;
2. unit-sphere identity;
3. constant south-pole boundary value;
4. normalized global winding integral equal to `1`.

The last theorem is the actual global invariant in the primary source.  A
local Jacobian sign, unique `+I` crossing, sampled grid sum, or conditional
abstract degree theorem is not an acceptable replacement.

If the full integral cannot be completed, return every earlier rung that does
close and identify one exact Lean-ready analytic blocker: for example a
specific partial-derivative formula, determinant-density simplification, or
nested trigonometric integral.  Do not silently weaken the headline theorem.

## Provenance

Primary source: S. Higashikawa, M. Nakagawa, and M. Ueda, "Floquet chiral
magnetic effect", Phys. Rev. Lett. 123, 066403 (2019), arXiv:1806.06868,
Supplemental Material, section "Nontriviality of U(k) as a map from T^3 to
SU(2)".  The coordinate and integral formulas were transcribed from the
official arXiv source archive at
`AgentTasks/literature/hnu-1806.06868/FCME_v2_6_combined.tex`.

## Verification

Build the copied exact core first, then run the focused target.  Preserve the
live endpoint, corrected sign convention, matrix ordering, coordinate order,
and integral normalization.

```yaml
aristotle:
  project_id: b167538e-32bb-4e80-a617-22f6fc89ab2e
  task_id: 850a540b-8f1d-42c7-91ea-ad4f15d41211
  target_file: HNUWindingIntegral/HNUWindingIntegral.lean
  expected_module: HNUWindingIntegral.HNUWindingIntegral
  submission_project: AgentTasks/aristotle-submit/hnu-winding-integral-20260720-project
  output_dir: AgentTasks/aristotle-output/b167538e-32bb-4e80-a617-22f6fc89ab2e
  status: integrated
```

## Integration result

All four requested rungs landed in
`PhysicsSM/Draft/NullEdge/HNUWindingIntegral.lean`.  The proof identifies the
live endpoint with the published sphere coordinates, proves the unit-sphere
and collapsed-boundary identities, computes the exact oriented density, and
evaluates the normalized global integral as `1`.  Build-enforced guards pin the
headline results to the standard three assumptions.

This is the actual endpoint winding integral, not a local-Jacobian surrogate.
It remains distinct from a micromotion invariant or bulk-edge theorem.
