# Aristotle task: P2 Mandelstam trace identity

Date: 2026-06-24.

## Purpose

Prove the finite `2 x 2` traceless Mandelstam trace reduction that should sit
between the P2 branch-reflection trace ladder and later P2/P3 super-Dirac /
diamond-curvature bridge claims.

The current P2 ladder already has explicit two-, three-, and four-reflection
formulas in `PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace`. Gemini and Spark
both identified the next clean proof target as the general finite identity:
the trace of a product of four traceless real `2 x 2` matrices is determined by
pairwise two-traces. Claude's suggested bridge mentioned a `diamondRight`
symbol, but Spark confirmed that no such API currently exists in the live
super-Dirac diamond module.

This task should therefore prove the standalone algebraic identity first. A
later integration pass can decide whether to package it as:

- a general P2 trace-ladder theorem;
- a corollary for branch reflections;
- a bridge lemma for a future diamond/super-Dirac substitution map.

## Physics context

The null-edge P2 story is trying to square a first-order operator story with
observable second-order invariants. The branch-reflection trace ladder is a
finite toy model of how first-order chiral/Dirac branch data can generate
observable scalar traces. The new identity says that, in the real traceless
`2 x 2` setting, a four-step trace is not a new independent scalar once all
pairwise trace pairings are known.

This is useful because causal-diamond and super-Dirac bridge claims should not
invent extra four-step invariants unless a geometric constraint actually
requires them. The theorem is a finite algebra guardrail for later physics.

## Target

Standalone file:

```text
AgentTasks/aristotle-standalone/null-edge-p2-mandelstam-trace-identity-20260624/NullEdgeP2MandelstamTraceIdentity/Core.lean
```

Main theorem:

```lean
trace2_mul_four_traceless_mandelstam
```

Expected narrow check:

```text
lake env lean NullEdgeP2MandelstamTraceIdentity/Core.lean
```

The proof should close the single intentional proof placeholder in the target
file. It may add small helper lemmas in the same file if useful, but should not
weaken the theorem statement. Prefer a direct finite matrix-algebra proof.

## Aristotle metadata

```yaml
aristotle:
  project_id: 1aa53d34-0951-4677-a96a-9643aa84437d
  task_id: c3db14b7-6d7a-4feb-b124-4dae6bdc2cfb
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-mandelstam-trace-identity-20260624/NullEdgeP2MandelstamTraceIdentity/Core.lean
  expected_module: NullEdgeP2MandelstamTraceIdentity.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-mandelstam-trace-identity-20260624-project
  output_dir: AgentTasks/aristotle-output/1aa53d34-0951-4677-a96a-9643aa84437d
  status: integrated
```

## Local preflight

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-mandelstam-trace-identity-20260624\NullEdgeP2MandelstamTraceIdentity\Core.lean
```

Result: parses and checks with the intended proof placeholder.

Submission-project cache preflight:

```text
lake exe cache get
lake env lean NullEdgeP2MandelstamTraceIdentity\Core.lean
```

Result: cache fetched successfully; target checks in the focused submission
project with the intended proof placeholder.

## Submission

```text
aristotle submit --project-dir AgentTasks\aristotle-submit\null-edge-p2-mandelstam-trace-identity-20260624-project <prompt>
aristotle tasks 1aa53d34-0951-4677-a96a-9643aa84437d --limit 10
```

Project `1aa53d34-0951-4677-a96a-9643aa84437d`, task
`c3db14b7-6d7a-4feb-b124-4dae6bdc2cfb`, initial status `QUEUED`.

Follow-up status check:

```text
aristotle tasks 1aa53d34-0951-4677-a96a-9643aa84437d --limit 10
```

Result: task status `IN_PROGRESS`.

## Aristotle result

Aristotle completed the target with the theorem statement unchanged. No helper
lemmas were added. The proof unfolds `trace2` and `tracelessMat`, expands
finite matrix multiplication with `Matrix.mul_apply` and `Fin.sum_univ_two`,
then closes the polynomial identity with `ring`. The returned file raises
`maxHeartbeats` for this theorem because the direct entrywise expansion is
large.

Aristotle's recommended next bridge theorem is to instantiate the identity for
`branchReflection`: first show each branch reflection is a traceless matrix,
then prove that the four-reflection trace is exactly the Mandelstam pairwise
trace combination. Only after that should a one-diamond curvature scalar be
defined in terms of pairwise traces.

## Integration

Copied the proof-complete standalone file into:

```text
AgentTasks/aristotle-standalone/null-edge-p2-mandelstam-trace-identity-20260624/NullEdgeP2MandelstamTraceIdentity/Core.lean
```

Also packaged the theorem into the live draft trace ladder:

```text
PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean
```

Added declarations:

```text
tracelessMat
trace2_mul_four_traceless_mandelstam
```

## Verification

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-mandelstam-trace-identity-20260624\NullEdgeP2MandelstamTraceIdentity\Core.lean
lake env lean PhysicsSM\Draft\NullEdgeP2TwoReflectionTrace.lean
lake build PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace
lake env lean PhysicsSMDraft.lean
```

All checks passed.

## Requested completion report

Ask Aristotle to report:

- whether the theorem statement was unchanged;
- which helper lemmas, if any, were added;
- whether any proof placeholders or escape hatches remain;
- the exact verification command run;
- recommended next P2/P3 bridge theorem after this identity.
