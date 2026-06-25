# Aristotle task: P2 four-reflection trace formula

Date: 2026-06-24.

## Purpose

Prove the explicit four-reflection trace formula in the current finite P2
branch-reflection API.

This follows the newly integrated P2 trace ladder:

```text
one reflection: trace zero
two reflections: first continuous non-parity scalar
three reflections: trace zero
```

The four-reflection theorem should close the next even-length scalar in the
same `h,p,m,E` convention. It is a guardrail against advertising generic
four-reflection or causal-diamond traces as topological. Any topological or
closure interpretation must come later as an extra theorem with explicit
constraints.

## Aristotle prompt

Please prove `trace2_mul_four_branchReflections_formula` in the focused Lean
package.

Physics context:

- Publication lane: `P2-R`, with support for `P4-R` and `P7-R`.
- The branch reflection is the finite first-order sign operator associated with
  a two-level chiral Hamiltonian.
- Determinant-only path products carry only parity.
- Two-reflection trace carries the first continuous scalar.
- Three-reflection trace is zero.
- This theorem should make the four-reflection scalar explicit in the current
  branch-reflection convention, before any separate causal-diamond closure or
  topology claim is introduced.

Exact Lean target:

```lean
theorem trace2_mul_four_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real) :
    trace2 (branchReflection h4 p4 m4 E4 *
        branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      2 * ((((h1 * p1) * (h2 * p2) + m1 * m2) *
            ((h3 * p3) * (h4 * p4) + m3 * m4)) -
          ((m1 * (h2 * p2) - (h1 * p1) * m2) *
            (m3 * (h4 * p4) - (h3 * p3) * m4))) /
        (E1 * E2 * E3 * E4) := by
  ...
```

Constraints and convention risks:

- Do not weaken or change the theorem statement.
- Do not add fake assumptions, new `a x i o m`s, or `o p a q u e` constants.
- Keep imports minimal. The package currently imports only `Mathlib`.
- The product order is exactly `R4 * R3 * R2 * R1`.
- The local Hamiltonian convention is `!![-h * p, m; m, h * p]`.
- The cross-term sign is part of the target. Do not flip it by silently changing
  the convention.
- All helicity dependence enters through `h * p`.
- Use the local `trace2`, not a new trace convention.
- No on-shell assumptions should be needed for this formal matrix identity.
- This is finite matrix algebra only. Do not add continuum, volume, phase, or
  topology interpretation.

Verification command:

```powershell
lake env lean NullEdgeP2FourReflectionTraceFormula/Core.lean
```

Completion report request:

At the end, please report:

- whether the target was solved;
- whether the theorem statement changed;
- whether any proof holes remain;
- whether any assumptions or escape hatches were introduced;
- suggested next theorem targets, especially whether the next step should be a
  concrete four-reflection nonconstancy witness or a constrained closure theorem.

## Metadata

```yaml
aristotle:
  project_id: fe62ea07-12c0-474f-981f-4b2d52639b15
  task_id: 9133118d-e470-4bf2-8abe-054eb159b63a
  target_file: AgentTasks/aristotle-standalone/null-edge-p2-four-reflection-trace-formula-20260624/NullEdgeP2FourReflectionTraceFormula/Core.lean
  expected_module: NullEdgeP2FourReflectionTraceFormula.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p2-four-reflection-trace-formula-20260624-project
  output_dir: AgentTasks/aristotle-output/fe62ea07-12c0-474f-981f-4b2d52639b15
  status: integrated
```

## Local preflight

```powershell
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-four-reflection-trace-formula-20260624\NullEdgeP2FourReflectionTraceFormula\Core.lean
```

Result: passed with only the intended draft proof-hole warning.

## Submission

Submitted to Aristotle:

- project: `fe62ea07-12c0-474f-981f-4b2d52639b15`;
- task: `9133118d-e470-4bf2-8abe-054eb159b63a`;
- initial status: `QUEUED`.

Submission note: the CLI warned that the focused package has no `.lake` folder.
This is expected for the helper-created focused package, and the prompt asks
Aristotle to run the narrow `lake env lean` command first.

## Integration

Aristotle solved the target without changing the theorem statement and without
introducing proof holes or extra assumptions. The returned proof was integrated
manually to preserve the local docstring and final-newline hygiene.

Integrated into:

- `PhysicsSM/Draft/NullEdgeP2TwoReflectionTrace.lean`
- `AgentTasks/aristotle-standalone/null-edge-p2-four-reflection-trace-formula-20260624/NullEdgeP2FourReflectionTraceFormula/Core.lean`

Verification:

```powershell
lake env lean AgentTasks\aristotle-standalone\null-edge-p2-four-reflection-trace-formula-20260624\NullEdgeP2FourReflectionTraceFormula\Core.lean
lake env lean PhysicsSM\Draft\NullEdgeP2TwoReflectionTrace.lean
lake build PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace
lake env lean PhysicsSMDraft.lean
```

All checks passed.
