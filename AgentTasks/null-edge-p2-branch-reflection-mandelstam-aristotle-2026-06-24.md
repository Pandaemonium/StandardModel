# Aristotle task: P2 branch-reflection Mandelstam package

Date: 2026-06-24.

## Purpose

Prove the branch-reflection instantiation of the P2 Mandelstam trace identity.
This is the next finite algebra guardrail after
`trace2_mul_four_traceless_mandelstam`.

The goal is not to claim causal-diamond curvature yet. The goal is to prove
that, in the real two-generator branch-reflection model, a four-step trace is
already determined by pairwise two-traces once the branch reflections are
written in explicit traceless coordinates. Later super-Dirac or one-diamond
claims must then introduce a named geometric substitution map.

## Model-call provenance

Context packet:

```text
AgentTasks/model-calls/context-packs/2026-06-24-round-022-context.md
```

Model-call records:

```text
AgentTasks/model-calls/gemini/2026-06-24-round-022-constructive-next-target.md
AgentTasks/model-calls/claude/2026-06-24-round-022-adversarial-next-target.md
```

Gemini recommended the branch-reflection instantiation and warned about the
coordinate bridge. Claude sharpened the job into a bundled target: explicit
coordinates, pairwise trace polynomial, four-reflection Mandelstam corollary,
and on-shell consistency audit. Spark confirmed the sign/order convention:

```text
branchReflection h p m E = tracelessMat (-(h*p)/E) (m/E) (m/E)
```

and the exact order `R4 * R3 * R2 * R1`.

## Target

Standalone file:

```text
AgentTasks/aristotle-standalone/null-edge-p2-branch-reflection-mandelstam-20260624/NullEdgeP2BranchReflectionMandelstam/Core.lean
```

Main declarations to prove:

```text
branchReflection_eq_tracelessMat_coords
trace2_mul_tracelessMat_coords
trace2_mul_two_branchReflections_from_coords
trace2_mul_four_branchReflections_mandelstam_ordered
trace2_branchReflection_sq_eq_two_on_massShell_from_coords
```

Expected narrow check:

```text
lake env lean NullEdgeP2BranchReflectionMandelstam/Core.lean
```

Do not weaken theorem statements. Small helper lemmas in the same file are fine.
Prefer direct finite matrix algebra and use the already-proved
`trace2_mul_four_traceless_mandelstam` theorem for the four-reflection
specialization if helpful.

## Aristotle metadata

```yaml
aristotle:
  project_id: 91206432-2d5d-4679-a86c-488e4375e6e0
  task_id: 42e52ee4-7a8e-4ea9-9d6c-5b98349319b1
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-branch-reflection-mandelstam-20260624/NullEdgeP2BranchReflectionMandelstam/Core.lean
  expected_module: NullEdgeP2BranchReflectionMandelstam.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-branch-reflection-mandelstam-v2-20260624-project
  output_dir: AgentTasks/aristotle-output/91206432-2d5d-4679-a86c-488e4375e6e0
  status: integrated
```

## Local preflight

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-branch-reflection-mandelstam-20260624\NullEdgeP2BranchReflectionMandelstam\Core.lean
```

Result: parses and checks with the five intended proof placeholders.

Submission-project preflight:

```text
lake exe cache get
lake env lean NullEdgeP2BranchReflectionMandelstam\Core.lean
```

Result: cache fetched successfully; target checks in the focused submission
project with the five intended proof placeholders.

## Submission

```text
aristotle submit --project-dir AgentTasks\aristotle-submit\null-edge-p2-branch-reflection-mandelstam-v2-20260624-project <prompt>
aristotle tasks 91206432-2d5d-4679-a86c-488e4375e6e0 --limit 10
```

Project `91206432-2d5d-4679-a86c-488e4375e6e0`, task
`42e52ee4-7a8e-4ea9-9d6c-5b98349319b1`, initial status `QUEUED`.

Follow-up status check:

```text
aristotle tasks 91206432-2d5d-4679-a86c-488e4375e6e0 --limit 10
```

Result: task status `IN_PROGRESS`.

## Aristotle result

Aristotle completed all five target theorems with every theorem statement
unchanged. No helper lemmas were added. The proofs are direct finite matrix
algebra:

- entrywise extensionality for the branch-coordinate bridge;
- finite `2 x 2` expansion for the pairwise coordinate trace;
- coordinate rewriting for the branch pairwise trace;
- coordinate rewriting plus `trace2_mul_four_traceless_mandelstam` for the
  four-reflection Mandelstam reduction;
- `field_simp` and `nlinarith` for the on-shell audit.

The on-shell audit agrees with the P2 trace-ladder convention: under
`h*h = 1` and `E^2 = p^2 + m^2`, the square trace of one branch reflection is
exactly `2`.

Aristotle recommends the next P2/P3 bridge as a named one-diamond substitution
map, with any geometry living in that map rather than being smuggled in by
renaming a generic four-trace.

## Integration

Copied the proof-complete standalone file into:

```text
AgentTasks/aristotle-standalone/null-edge-p2-branch-reflection-mandelstam-20260624/NullEdgeP2BranchReflectionMandelstam/Core.lean
```

Also packaged the theorem cluster into the live P2 trace module:

```text
PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean
```

Added declarations:

```text
branchReflection_eq_tracelessMat_coords
trace2_mul_tracelessMat_coords
trace2_mul_two_branchReflections_from_coords
trace2_mul_four_branchReflections_mandelstam_ordered
trace2_branchReflection_sq_eq_two_on_massShell_from_coords
```

## Verification

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-branch-reflection-mandelstam-20260624\NullEdgeP2BranchReflectionMandelstam\Core.lean
lake env lean PhysicsSM\Draft\NullEdgeP2TwoReflectionTrace.lean
lake build PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace
lake env lean PhysicsSMDraft.lean
```

All checks passed.

## Requested completion report

Ask Aristotle to report:

- whether every theorem statement was unchanged;
- which helper lemmas, if any, were added;
- whether any proof placeholders or escape hatches remain;
- the exact verification command run;
- whether the on-shell audit agrees with the existing P2 convention;
- recommended next P2/P3 bridge theorem after this package.
