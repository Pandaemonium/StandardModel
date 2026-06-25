# Aristotle task: P2 three-reflection trace-zero guardrail

Date: 2026-06-24.

## Purpose

Prove one focused finite P2 theorem: in the real `2 x 2` branch-reflection
model, the trace of a product of three branch reflections is zero.

This advances the P2/P4/P7 branch-reflection trace ladder. We already have
finite draft results showing:

- one branch reflection is traceless;
- determinant products collapse to reflection-count parity;
- two-reflection trace is the first non-parity scalar:
  `2 * (h1*h2*p1*p2 + m1*m2) / (E1*E2)`;
- a four-reflection trace should not be advertised as topological unless an
  explicit closure/geometric constraint is supplied.

The requested theorem is the next clean odd-length guardrail. It should make the
algebraic story sharper without continuum, twistor, eigenvalue, phase, or
causal-diamond topology claims.

## Aristotle prompt

Please prove the theorem
`trace2_mul_three_branchReflections_eq_zero` in the focused Lean package.

Physics context:

- Publication lane: `P2-R`, with support for `P4-R` and `P7-R`.
- The branch reflection is the finite first-order sign operator associated with
  a two-level chiral Hamiltonian.
- Determinant-only path products have already been shown to carry only parity.
- The two-reflection trace carries the first continuous finite scalar.
- This theorem should show that three reflections have no new trace scalar in
  the current real two-generator model. It is a guardrail against overclaiming
  four-reflection or diamond traces as topological without additional closure
  hypotheses.

Exact Lean target:

```lean
theorem trace2_mul_three_branchReflections_eq_zero
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 : Real) :
    trace2 (branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) = 0 := by
  ...
```

Constraints:

- Do not weaken the theorem statement.
- Do not add fake assumptions, new `a x i o m`s, or new `o p a q u e` constants.
- Keep imports minimal. The package currently imports only `Mathlib`.
- This is finite matrix algebra only. Do not add continuum interpretation.
- It is acceptable to prove by direct expansion, `simp`, and `ring`.
- No on-shell assumptions should be needed; if you find they are needed, report
  that as a semantic issue rather than silently adding them.

Verification command:

```powershell
lake env lean NullEdgeP2ThreeReflectionTraceZero/Core.lean
```

Completion report request:

At the end, please report:

- whether the target was solved;
- whether the theorem statement changed;
- whether any proof holes remain;
- whether any assumptions or escape hatches were introduced;
- any suggested next theorem targets, especially whether the next step should be
  a four-reflection non-constancy counterexample or a constrained closure
  theorem.

## Metadata

```yaml
aristotle:
  project_id: 66433285-abb7-4646-8b1c-84e50011a4a9
  task_id: 12dba6f5-b820-4685-b3b1-1176c4ff3961
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-three-reflection-trace-zero-20260624/NullEdgeP2ThreeReflectionTraceZero/Core.lean
  expected_module: NullEdgeP2ThreeReflectionTraceZero.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-three-reflection-trace-zero-20260624-project
  output_dir: AgentTasks/aristotle-output/66433285-abb7-4646-8b1c-84e50011a4a9
  status: integrated
```

## Local preflight

```powershell
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-three-reflection-trace-zero-20260624\NullEdgeP2ThreeReflectionTraceZero\Core.lean
```

Result: passed with only the intended draft proof-hole warning.

## Submission

Submitted to Aristotle:

- project: `66433285-abb7-4646-8b1c-84e50011a4a9`;
- task: `12dba6f5-b820-4685-b3b1-1176c4ff3961`;
- initial status: `QUEUED`.

Submission note: the CLI warned that the focused package has no `.lake` folder.
This is expected for the helper-created focused package, and the prompt asks
Aristotle to run the narrow `lake env lean` command first.

## Integration

Aristotle solved the target without changing the theorem statement and without
introducing proof holes or extra assumptions. The proof is a direct finite
matrix expansion followed by `ring`.

Integrated into:

- `PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean`
- `AgentTasks/aristotle-standalone/null-edge-p2-three-reflection-trace-zero-20260624/NullEdgeP2ThreeReflectionTraceZero/Core.lean`

Verification:

```powershell
lake env lean PhysicsSM\Draft\NullEdgeP2TwoReflectionTrace.lean
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-three-reflection-trace-zero-20260624\NullEdgeP2ThreeReflectionTraceZero\Core.lean
lake build PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace
lake env lean PhysicsSMDraft.lean
```

All checks passed.
