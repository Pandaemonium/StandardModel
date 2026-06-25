# Aristotle task: P2 closed branch-coordinate sum rule

Date: 2026-06-24.

## Purpose

Prove the first non-empty closure theorem after the P2 branch-reflection
Mandelstam package.

The previous result proves that real two-generator branch-reflection
four-traces are determined by pairwise two-traces. A bare `oneDiamondSub`
wrapper would risk empty formalism: it would rename generic branch data as a
diamond without adding a real constraint. This task instead adds an explicit
finite closure constraint in the branch-coordinate plane.

Write a branch reflection in coordinates:

```text
a = -(h*p)/E,
b = m/E.
```

The pairwise two-trace is `2 * (a_i*a_j + b_i*b_j)`. The target theorem is a
Mandelstam-style closure sum rule: if four normalized branch-coordinate vectors
sum to zero, then the sum of all six pairwise branch-reflection traces is
`-4`.

## Model-call provenance

Context packet:

```text
AgentTasks/model-calls/context-packs/2026-06-24-round-023-context.md
```

Model-call records:

```text
AgentTasks/model-calls/gemini/2026-06-24-round-023-adversarial-next-target.md
AgentTasks/model-calls/claude/2026-06-24-round-023-constructive-next-target.md
```

Gemini warned that a bare one-diamond substitution map would be empty formalism.
Claude suggested adding real closure/shell content. Spark confirmed there is no
existing one-diamond API and recommended a closure-constrained theorem rather
than a P1/P7 pivot. The final staged target uses branch-coordinate closure,
which has an exact finite sum rule.

## Target

Standalone file:

```text
AgentTasks/aristotle-standalone/null-edge-p2-closed-branch-coordinate-sum-rule-20260624/NullEdgeP2ClosedBranchCoordinateSumRule/Core.lean
```

Main declarations to prove:

```text
branchPairTrace_eq_coordPairTrace
coordPairTrace_sum_eq_neg_four_of_closed_unit
branchPairTrace_sum_eq_neg_four_of_coordClosed_unit
branchCoord_norm_sq_eq_one_onMassShell
branchPairTrace_sum_eq_neg_four_of_closed_onMassShell
```

Expected narrow check:

```text
lake env lean NullEdgeP2ClosedBranchCoordinateSumRule/Core.lean
```

Do not weaken theorem statements. Small helper lemmas in the same file are fine.
The intended proof route is finite algebra:

- use the existing pairwise branch-reflection trace formula for
  `branchPairTrace_eq_coordPairTrace`;
- expand `(a1 + a2 + a3 + a4)^2` and
  `(b1 + b2 + b3 + b4)^2` for the coordinate sum rule;
- use the coordinate theorem to prove the branch theorem;
- use `field_simp` / `nlinarith` for the on-shell unit norm theorem.

## Aristotle metadata

```yaml
aristotle:
  project_id: 9225aabb-45af-445f-97fe-2f2575252eb2
  task_id: 6316f8f1-7412-46ad-bf2c-356802bdd1b1
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-closed-branch-coordinate-sum-rule-20260624/NullEdgeP2ClosedBranchCoordinateSumRule/Core.lean
  expected_module: NullEdgeP2ClosedBranchCoordinateSumRule.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-closed-branch-coordinate-sum-rule-20260624-project
  output_dir: AgentTasks/aristotle-output/9225aabb-45af-445f-97fe-2f2575252eb2
  status: integrated
```

## Local preflight

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-closed-branch-coordinate-sum-rule-20260624\NullEdgeP2ClosedBranchCoordinateSumRule\Core.lean
```

Result: parses and checks with the five intended proof placeholders.

Submission-project preflight:

```text
lake exe cache get
lake env lean NullEdgeP2ClosedBranchCoordinateSumRule\Core.lean
```

Result: cache fetched successfully; target checks in the focused submission
project with the five intended proof placeholders.

## Submission

```text
aristotle submit --project-dir AgentTasks\aristotle-submit\null-edge-p2-closed-branch-coordinate-sum-rule-20260624-project <prompt>
aristotle tasks 9225aabb-45af-445f-97fe-2f2575252eb2 --limit 10
```

Project `9225aabb-45af-445f-97fe-2f2575252eb2`, task
`6316f8f1-7412-46ad-bf2c-356802bdd1b1`, initial status `QUEUED`.

Follow-up status check:

```text
aristotle tasks 9225aabb-45af-445f-97fe-2f2575252eb2 --limit 10
```

Result: task status `IN_PROGRESS`.

## Aristotle result

Aristotle completed all five target theorems with theorem statements
unchanged. No helper lemmas were added. The key proof is the coordinate closure
identity: a linear combination of the two closure equations and the four
unit-norm equations yields the six-pair trace sum `-4`.

The final theorem genuinely uses both closure and on-shell/unit assumptions:
`hcloseA` and `hcloseB` feed the finite closure sum rule, while each
`hh`, nonzero `E`, and mass-shell triple feeds the unit-normalization theorem.

Aristotle recommends continuing toward a one-diamond geometric substitution
map now that there is a real closure invariant for that map to preserve.

## Integration

Copied the proof-complete standalone file into:

```text
AgentTasks/aristotle-standalone/null-edge-p2-closed-branch-coordinate-sum-rule-20260624/NullEdgeP2ClosedBranchCoordinateSumRule/Core.lean
```

Also packaged the theorem cluster into the live P2 trace module:

```text
PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean
```

Added declarations:

```text
branchA
branchB
coordPairTrace
branchPairTrace
branchPairTrace_eq_coordPairTrace
coordPairTrace_sum_eq_neg_four_of_closed_unit
branchPairTrace_sum_eq_neg_four_of_coordClosed_unit
branchCoord_norm_sq_eq_one_onMassShell
branchPairTrace_sum_eq_neg_four_of_closed_onMassShell
```

## Verification

```text
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-closed-branch-coordinate-sum-rule-20260624\NullEdgeP2ClosedBranchCoordinateSumRule\Core.lean
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
- whether the final theorem really uses closure and unit/on-shell assumptions;
- recommended next step after this closure sum rule.
