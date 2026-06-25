# Aristotle task: P2 four-reflection trace nonconstancy witness

Date: 2026-06-24.

## Purpose

Prove a concrete finite witness that the unconstrained four-reflection trace is
not constant in the current P2 branch-reflection API.

The live P2 trace ladder now has:

```text
one reflection: trace zero
two reflections: first continuous non-parity scalar
three reflections: trace zero
four reflections: explicit scalar formula
```

This witness closes the referee-facing gap: the four-step scalar is genuinely
nontrivial and should not be advertised as topological without additional
closure or geometric hypotheses.

## Aristotle prompt

Please prove the three witness theorems in the focused Lean package:

```lean
trace2_four_diagWitness_eq_two
trace2_four_alternatingWitness_eq_neg_two
trace2_four_branchReflections_nonconstant
```

Physics context:

- Publication lane: `P2-R`, with support for `P4-R` and `P7-R`.
- We are not claiming continuum geometry or topology here.
- The goal is only to show that generic four-reflection trace data is not a
  constant topological label in the unconstrained finite branch-reflection
  model.
- The two witnesses are:
  - `A = branchReflection 1 1 0 1`, the diagonal reflection `diag(-1, 1)`;
  - `B = branchReflection 1 0 1 1`, the swap reflection.
- The target facts are `trace(A A A A) = 2` and `trace(B A B A) = -2`, hence
  the two four-reflection traces are unequal.

Constraints and convention risks:

- Do not weaken or change the theorem statements.
- Do not add fake assumptions, new `a x i o m`s, or `o p a q u e` constants.
- Keep imports minimal. The package currently imports only `Mathlib`.
- Use the local `trace2`, not a new trace convention.
- Product order matters: the alternating witness is exactly `B * A * B * A`.
- The local Hamiltonian convention is `!![-h * p, m; m, h * p]`.
- This is finite matrix algebra only. Do not add continuum, volume, phase, or
  topology interpretation.

Verification command:

```powershell
lake env lean NullEdgeP2FourTraceNonconstant/Core.lean
```

Completion report request:

At the end, please report:

- whether all three targets were solved;
- whether any theorem statement changed;
- whether any proof holes remain;
- whether any assumptions or escape hatches were introduced;
- suggested next theorem targets, especially whether the next step should be a
  constrained closure theorem or a pivot to P1/P7/P9.

## Metadata

```yaml
aristotle:
  project_id: d535af70-e61d-4f63-ac60-20d846ec73ab
  task_id: 7b0d6841-12a3-4c4d-9a06-ffae0933eddd
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-four-trace-nonconstant-20260624/NullEdgeP2FourTraceNonconstant/Core.lean
  expected_module: NullEdgeP2FourTraceNonconstant.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-four-trace-nonconstant-20260624-project
  output_dir: AgentTasks/aristotle-output/d535af70-e61d-4f63-ac60-20d846ec73ab
  status: submitted
```

## Local preflight

```powershell
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-four-trace-nonconstant-20260624\NullEdgeP2FourTraceNonconstant\Core.lean
```

Result: passed with only the three intended draft proof-hole warnings.

## Submission

Submitted to Aristotle:

- project: `d535af70-e61d-4f63-ac60-20d846ec73ab`;
- task: `7b0d6841-12a3-4c4d-9a06-ffae0933eddd`;
- initial status: `QUEUED`.

Submission note: the CLI warned that the focused package has no `.lake` folder.
This is expected for the helper-created focused package, and the prompt asks
Aristotle to run the narrow `lake env lean` command first.
