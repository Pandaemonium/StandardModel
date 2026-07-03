# Gate C1 C274: matrix branch-Wilson square and gap-transfer target

Date: 2026-06-29
Status: prepared for Aristotle submission.

## Purpose

This job asks Aristotle for blunt recommendations and, where useful, focused theorem targets for Gate C1. It is intentionally not a broad full-repo build job.

## Submission packet

- Submission project: `AgentTasks\aristotle-submit\gate-c1-c274-branch-wilson-square-recommendations-20260629`
- Prompt: `AgentTasks\aristotle-submit\gate-c1-c274-branch-wilson-square-recommendations-20260629\PROMPT.md`
- Context pack: `AgentTasks\context-packs\gate-c1-next-operator-strategy-20260629-20260629-061718.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: d671a61a-3627-4b35-9517-997c8dd55f43
  task_id: 3c8f70bb-3d80-4711-b8c5-ac7f27543f77
  target_file: strategy/recommendation packet
  expected_module: none
  submission_project: AgentTasks\aristotle-submit\gate-c1-c274-branch-wilson-square-recommendations-20260629
  output_dir: AgentTasks/aristotle-output/d671a61a-3627-4b35-9517-997c8dd55f43
  status: integrated
```

## Prompt

````text
You are Aristotle working on the PhysicsSM null-edge Standard Model project.

Blunt request: help us turn `TetraBranchWilsonSymbol.lean` from a scaffold into the matrix-valued branch-Wilson theorem we actually need. If the theorem as imagined is wrong, tell us immediately and recommend the corrected one.

Context:
- Scalar Wilson is not expected to solve C1 by itself.
- We need a matrix-valued branch Wilson term W(k) that can separate physical and mirror branch sectors.
- A useful earlier candidate suggested proving an exact identity for Kbranch = a^{-1}(i Q(k) + W(k)) of the form star K * K = a^{-2}(Q^2 + W^2 plus commutator terms), then specializing under commutation or positivity hypotheses to transfer a W-sector gap into an H/K spectral gap.
- Current live file has `BranchWilsonData`, `Kbranch`, `Hbranch`, scalar specialization, chirality commute/anticommute predicates, and `BranchWilsonAudit`, but no decisive square/gap theorem yet.

Included files:
- Context pack.
- `TetraBranchWilsonSymbol.lean`.
- `TetraFreeOperator.lean`.
- `PhysicalC1Criteria.lean`.
- Related overlap/locality/index predicate files.

What we need from you:
1. Propose the exact matrix-valued theorem statements we should add to `TetraBranchWilsonSymbol.lean`.
2. Identify the weakest useful hypotheses on W(k): Hermitian, commute/anticommute with Q, projection form, sector gap, chirality behavior, gauge equivariance, etc.
3. If possible, provide Lean proof code for the core algebraic identities without changing the intended meaning of existing declarations.
4. If full proof code is too costly, give a precise implementation plan with helper lemma names and proof sketches.
5. Explain which theorem is actually decisive for Gate C1 and which theorem is only bookkeeping.
6. Recommend how to construct or search for W(k), not just how to prove things after W(k) is given.

Do not waste effort on scalar Wilson as a solution path. Scalar specialization is useful only as a compatibility check.

Completion report format:
- Proposed declarations:
- Minimal assumptions:
- Proof code or proof plan:
- Operator-search recommendation for W(k):
- Warnings about false or too-weak statements:

````


## Submission result

Submitted on 2026-06-29.

```text
WARNING: Your project contains .lean files but no lean-toolchain is present.
Aristotle works best with Lean Toolchain leanprover/lean4:v4.28.0

WARNING: Your project contains .lean files but no .lake folder.
Aristotle works better with access to your project's dependencies.
Did you forget to run `lake build`?

Project created: d671a61a-3627-4b35-9517-997c8dd55f43

```


## Task status check

2026-06-29: `aristotle tasks d671a61a-3627-4b35-9517-997c8dd55f43 --limit 5` reported task `3c8f70bb-3d80-4711-b8c5-ac7f27543f77` as `QUEUED`.


## Integration note

2026-06-29: Integrated into plan section 91 and Lean via BranchWilsonSquareCore.lean plus TetraBranchWilsonSymbol wrappers.
