# Aristotle job: proper Lorentz exponential link curves

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-008`

```yaml
aristotle:
  project_id: 358cec0d-a9ab-4ce3-a31b-fedbfe7aab86
  task_id: a936a850-649f-41ea-b42e-9f9141cdd9c8
  target_file: ProperLorentzExponential/Target.lean
  expected_module: ProperLorentzExponential.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-proper-lorentz-exponential-20260717-project
  output_dir: AgentTasks/aristotle-output/358cec0d-a9ab-4ce3-a31b-fedbfe7aab86
  status: completed_comparison_harvested_local_retained
```

## Target

Prove that exponentiating a matrix in the project convention for the Lorentz
Lie algebra gives an eta-Lorentz matrix with determinant exactly `+1`. This
upgrades the new canonical invertible link curves
`U exp(t hat(delta A))` to curves inside the proper Lorentz component whenever
the base link is proper Lorentz.

## Convention lock

- spacetime metric: mostly-minus `(+,-,-,-)`;
- basis order: `(0,1,2,3)`;
- finite matrix size: four;
- group equation: `M^T eta M = eta`;
- Lie-algebra equation: `X^T eta + eta X = 0`;
- properness: determinant exactly `+1`.

The job must not weaken determinant `+1` to determinant squared equal to one.

## Inputs

- `AgentTasks/aristotle-standalone/null-edge-proper-lorentz-exponential-20260717/ProperLorentzExponential/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-proper-lorentz-exponential-20260717/ARISTOTLE_PROMPT.md`
- `AgentTasks/context-packs/null-edge-proper-lorentz-exponential-20260717-20260717-221202.md`
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurveDerivative.lean`
- `PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean`

## Preflight

The standalone target passes under the pinned repository toolchain with
exactly two intended proof-hole warnings and no other diagnostics:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-proper-lorentz-exponential-20260717/ProperLorentzExponential/Target.lean
```

The focused preparation helper reported two proof-hole lines, zero admission
tokens, zero assumption-declaration tokens, and zero unsafe tokens. The package
includes the prompt and semantic context pack explicitly.

## Submission

Submitted on 2026-07-17 as project
`358cec0d-a9ab-4ce3-a31b-fedbfe7aab86`, task
`a936a850-649f-41ea-b42e-9f9141cdd9c8`. Initial task status was `QUEUED`.
Aristotle was instructed to run the narrow target first, preserve determinant
`+1`, and return a complete eta-covariance proof plus the exact determinant
blocker if the ambitious properness half cannot be closed.

## Local closure while queued

While the remote task remained `QUEUED`, the exact target was closed locally
without changing either statement. The determinant proof avoids a missing
general determinant-of-exponential theorem by splitting
`exp X = exp(X/2) * exp(X/2)`: eta preservation makes the half-step
determinant square to one, and multiplicativity therefore gives determinant
`+1` for the full step.

The proof was integrated into
`PhysicsSM/Draft/NullEdge/ProperLorentzExponential.lean`, and
`NonlinearLorentzPalatiniCurveDerivative.lean` now proves that every canonical
variation curve remains pointwise eta-Lorentz and determinant-positive when
the base connection is. This is proper `SO(1,3)` membership; the separate
orthochronous sign remains open.

The task later transitioned from `IN_PROGRESS` to `COMPLETE`; it was retained
as an independent comparison/audit rather than treated as a blocker.

Local verification:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-proper-lorentz-exponential-20260717/ProperLorentzExponential/Target.lean
lake env lean PhysicsSM/Draft/NullEdge/ProperLorentzExponential.lean
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurveDerivative.lean
```

## Comparison harvest

The remote task completed and was harvested under
`AgentTasks/aristotle-output/358cec0d-a9ab-4ce3-a31b-fedbfe7aab86/`.
Its returned target passes the strict executable-token scan and direct Lean
check without proof holes. Aristotle used a continuous determinant path and
connectedness to select the positive sign. The live local half-step proof is
retained because `exp X = exp(X/2)^2` closes the same exact determinant target
with less topology and a smaller proof surface.
