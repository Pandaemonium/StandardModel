# Aristotle job: Palatini coframe response to mixed Einstein equation

Date: 2026-07-17
Work item: `GR-PALATINI-COFRAME-003`

```yaml
aristotle:
  project_id: 40d89d02-7dc7-4a7d-97e5-aa053adc4112
  task_id: d31bb4e4-b619-483d-894b-b505fc1dcfe0
  target_file: PalatiniCoframeEinstein/Target.lean
  expected_module: PalatiniCoframeEinstein.Target
  submission_project: AgentTasks/aristotle-submit/null-edge-palatini-coframe-einstein-20260717-project
  output_dir: AgentTasks/aristotle-output/40d89d02-7dc7-4a7d-97e5-aa053adc4112
  status: in_progress
```

## Target

Prove that the ordinary first coframe response of the exact ordered Palatini
density is the determinant-weighted mixed vacuum Einstein coefficient paired
with an arbitrary tetrad variation.

This is the coefficient-level successor to the determinant/scalar-curvature
identity. Together they connect the sixteen concrete coframe Euler
coefficients to `2 Ric^d_c - delta^d_c R` without replacing the nonlinear
holonomy action by a different metric action.

## Convention lock

- coframe indices are internal row, spacetime column;
- inverse-coframe indices are spacetime row, internal column;
- ordered bivector coordinates are `(12,13,23,01,02,03)`;
- internal metric signs are `(+,+,+,-,-,-)`;
- spacetime orientation is `0123`;
- curvature is antisymmetric in ordered spacetime faces;
- the response has the calibrated positive determinant prefactor and factor
  `2` in the mixed Einstein coefficient.

## Oracle calibration

An exact-rational non-diagonal coframe with determinant one, a nontrivial
matrix-entry variation, and an arbitrary antisymmetric curvature field gave

```text
Palatini coframe response = 546
det(e) * coefficient pairing = 546.
```

This fixes the target statement but is not trusted as a proof.

## Inputs

- `AgentTasks/aristotle-standalone/null-edge-palatini-coframe-einstein-20260717/PalatiniCoframeEinstein/Target.lean`
- `AgentTasks/aristotle-standalone/null-edge-palatini-coframe-einstein-20260717/ARISTOTLE_PROMPT.md`
- `AgentTasks/context-packs/null-edge-palatini-coframe-einstein-20260717-20260717-232105.md`
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCoframeVariation.lean`
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurvatureExtraction.lean`

## Preflight

The focused target passes under the pinned toolchain with exactly one intended
proof-hole warning and no other diagnostics:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-palatini-coframe-einstein-20260717/PalatiniCoframeEinstein/Target.lean
```

## Submission

Submitted on 2026-07-17 as project
`40d89d02-7dc7-4a7d-97e5-aa053adc4112`, task
`d31bb4e4-b619-483d-894b-b505fc1dcfe0`. Initial status: `QUEUED`.
The focused-package missing-cache warning is expected; the narrow target is
the first requested command.

The task entered `IN_PROGRESS` while the live response-level bridge and mixed
Ricci/scalar contraction theorem were being integrated.

After an in-progress snapshot isolated a complementary-minor lemma, an
instruction supplied the `Matrix.det_mul` auxiliary-matrix construction also
sent to the density and minimal-helper jobs. The target statements and
conventions were not changed.

On 2026-07-18 the isolated helper job completed with a kernel-checked
auxiliary-matrix proof. A follow-up instruction reported that successful
construction to this task and asked it to use the left-inverse-only helper,
finish the multiplicative variation core, and return the strongest checking
target promptly without weakening the headline statement.

## Live resolution

The target theorem was subsequently completed independently and integrated as
`NonlinearLorentzPalatiniEinsteinBridge.palatiniDensityFirstVariation_eq_det_mul_mixedEinstein`
in `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinResponse.lean`.
The live proof uses the landed two-minor cofactor theorem, an exact
exterior-square cofactor transformation law for elementary column operations,
curvature face antisymmetry, and reconstruction from the sixteen matrix-entry
probes. It also closes the concrete Euler-coefficient, coframe-stationarity,
and joint-stationarity consequences.

## Final Aristotle harvest

The task completed on 2026-07-18 with status `COMPLETE_WITH_ERRORS`. The
integration helper harvested project
`40d89d02-7dc7-4a7d-97e5-aa053adc4112` under
`AgentTasks/aristotle-output/` and correctly blocked application because the
candidate contains two proof holes, in `det_mul_inverse_pair` and
`palatiniDensityFirstVariation_mul_core`.

The candidate preserves the requested headline statement and reports no new
nonstandard assumptions, but it is not a complete proof and was not copied
into live Lean. The independently completed response theorem remains the
authoritative kernel-checked result.
