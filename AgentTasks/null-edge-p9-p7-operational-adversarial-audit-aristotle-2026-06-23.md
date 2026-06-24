# Aristotle task: P9/P7 operational adversarial audit

```yaml
job_name: null-edge-p9-p7-operational-adversarial-audit-20260623
status: strategy-reviewed
project_id: 080f98c5-8d0c-4ae6-9967-d63d8ab86528
task_id: da56c47e-a08a-4411-b59a-e7f4f0dc29ac
submission_project: AgentTasks/aristotle-submit/null-edge-p9-p7-operational-adversarial-audit-20260623-project
source_staged_from: AgentTasks/aristotle-strategy-packs/null-edge-p9-p7-operational-adversarial-audit-20260623
target_file: PROMPT.md
expected_check: no Lean build requested
```

## Task

Ask Aristotle for a no-code adversarial theorem-selection report after the
latest P9 operational-gap, T2 erasure/non-vacuity, and P7 same-det
different-coherence finite wins.

The goal is to identify the next highest-value theorem target, especially:

- whether P9 should enumerate/order-preserving coarse maps or prove a class
  theorem;
- whether P7 should add an operational POVM/readout separator for the same-det
  different-coherence pair;
- which follow-up would most reduce overclaiming risk.

## Submission note

Submitted as Aristotle project `080f98c5-8d0c-4ae6-9967-d63d8ab86528`, task
`da56c47e-a08a-4411-b59a-e7f4f0dc29ac`.

Local package:

```text
AgentTasks/aristotle-submit/null-edge-p9-p7-operational-adversarial-audit-20260623-project
```

The package intentionally contains only `Stub.lean` plus the no-code prompt.

## Completion review

Aristotle returned a useful no-code audit report. The raw returned Markdown had
console mojibake, so the integrated content below is a cleaned summary rather
than a verbatim copy.

Output locations:

```text
AgentTasks/aristotle-output/080f98c5-8d0c-4ae6-9967-d63d8ab86528/extracted/null-edge-p9-p7-operational-adversarial-audit-20260623-project_aristotle/ARISTOTLE_SUMMARY.md
AgentTasks/aristotle-output/080f98c5-8d0c-4ae6-9967-d63d8ab86528/extracted/null-edge-p9-p7-operational-adversarial-audit-20260623-project_aristotle/AgentTasks/P9_P7_operational_audit_report.md
```

Main recommendations:

1. **Top next P9 theorem:** a finite coarse-map dichotomy. Enumerate or decide
   over the admissible surjective order-preserving coarse maps of the six-point
   witness and prove that operational-gap erasure is equivalent to collapsing
   the critical swapped pair. If false, the counterexample is a valuable
   demotion result.
2. **P7 operational separator:** use an X-basis-style finite effect to separate
   two same-det density proxies. The report recommends a stronger rational pair
   with different coherence magnitude, not merely sign:
   `[[1/2,1/4],[1/4,1/2]]` and `[[13/20,1/5],[1/5,7/20]]`, both trace-one,
   positive, and determinant `3/16`, separated by
   `[[1/2,1/2],[1/2,1/2]]`.
3. **P9 non-vacuity:** prove the subdiamond readout is strictly finer than the
   whole-diamond readout. Codex already banked the first concrete version as
   `PhysicsSM.Draft.NullEdgeP9SubdiamondNonvacuity`.

Risk flag:

- P9 universality remains conditional until the operational readout is made
  intrinsic/order-derived or quantified over a named admissible readout family.

Immediate follow-up:

- Completed: the P7 module now includes the stronger X-basis positive-effect
  witness as
  `determinant_does_not_determine_positiveEffectReadout_in_densityClass`.
- Run a local enumeration sanity check before submitting the P9 coarse-map
  dichotomy as a proof job.
