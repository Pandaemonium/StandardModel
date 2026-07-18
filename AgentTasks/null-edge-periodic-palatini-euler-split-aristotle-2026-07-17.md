# Aristotle job: split periodic Palatini Euler coefficient

Date: 2026-07-17
Work item: `GR-PALATINI-CONNECTION-LOCAL-002`

```yaml
aristotle:
  project_id: d1600b71-c514-4759-95b0-581b0da3ceaa
  task_id: a0027748-cb7c-410b-9e5d-29acac4cb4ab
  target_file: PeriodicPalatiniEulerSplit/Target.lean
  expected_module: PeriodicPalatiniEulerSplit.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-periodic-palatini-euler-split-r3-20260717-project
  output_dir: AgentTasks/aristotle-output/d1600b71-c514-4759-95b0-581b0da3ceaa
  status: harvested-partial; local proof integrated
```

## Target

Split the exact local periodic Palatini coefficient proof into its two
mathematically independent parts: the backward-difference response and the
four algebraic connection cross terms. The standalone module already proves
the response split and reduces the original six-term theorem to those two
targets.

## Inputs and constraints

- `AgentTasks/context-packs/null-edge-periodic-palatini-euler-20260717-140845.md`
- `AgentTasks/aristotle-standalone/null-edge-periodic-palatini-euler-20260717/PeriodicPalatiniEuler.lean`
- `AgentTasks/aristotle-standalone/null-edge-periodic-palatini-euler-split-20260717/PeriodicPalatiniEulerSplit/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-periodic-palatini-euler-split-20260717/ARISTOTLE_PROMPT.md`

The connection is unrestricted, all lower indices are ordered, and no
continuum identity or symmetry may be inserted. This is a focused successor
to project `d1a5c26d-f460-4d06-99ff-d05a00c27c7c`, whose one-hour snapshot
contained a proved periodic site-probe summation lemma but left the unsplit
finite normalization open.

## Submission

Submitted as project `d1600b71-c514-4759-95b0-581b0da3ceaa`, task
`a0027748-cb7c-410b-9e5d-29acac4cb4ab`, after a main-repo pinned-toolchain
preflight of `PeriodicPalatiniEulerSplit/Target.lean`. The preflight compiled
with exactly the two intended proof handoffs; the response split and final
composition were already kernel-checked.

While the task was queued, an `instruct` message supplied the exact
kernel-checked `periodic_sum_probe_edgeDifference` lemma returned by the
completed predecessor and asked Aristotle to add it unchanged. The local
successor source includes the same lemma and still compiles with only the two
intended proof handoffs.

During proof search, a second local helper was added and kernel-checked:
`sum_weight_mul_connectionComponentProbe` collapses a weighted ordered probe
to its unique site and three ordered indices. Its exact statement and proof
were sent with a second `instruct` message to focus the algebraic target. No
target statement was changed.

## Local completion

While Aristotle remained in progress, the split was completed locally without
changing either target statement. The derivative proof factors the trace into
two Ricci branches, applies exact periodic summation by parts, and preserves
the `upper = left` trace condition. The algebraic proof evaluates all four
ordered component probes, contracts them against the inverse metric, and then
uses the scalar site probe. The resulting standalone module contains no proof
handoffs and passes:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-periodic-palatini-euler-split-20260717/PeriodicPalatiniEulerSplit/Target.lean
```

The same proof was transferred to
`PhysicsSM/Draft/NullEdge/FinitePeriodicPalatiniEulerEquation.lean`. Its
headline coefficient theorem and the downstream torsion-free conformal no-go
compile with build-enforced axiom guards. No Aristotle-generated proof was
used in that integration.

At approximately 57 minutes, an `instruct` message asked Aristotle to stop and
package any current result because the local proof was complete. The client
wait timed out after two minutes without a response; project/task status must
be checked separately before harvesting.

## Harvest

The task finished as `COMPLETE_WITH_ERRORS` and was downloaded to
`AgentTasks/aristotle-output/d1600b71-c514-4759-95b0-581b0da3ceaa/final.zip`.
The returned summary reports complete proofs of
`periodic_sum_weight_mul_probe_firstJet` and
`algebraic_probe_integrand_eq_explicit`, but both requested target theorems
remain unresolved in the returned `Target.lean`. The package therefore was
retained for provenance and comparison only; no returned source was copied
into the live module.

After integrating the link-holonomy architecture and literature audit, the
semantic document-index refresh was attempted again and timed out at five
minutes on the enlarged shared worktree. The active proof remains
self-contained and continues to use the previously generated context pack.
