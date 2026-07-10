# Codex proof job: finite unitary path action and exact EOM

Close every proof in
`FiniteUnitaryPathAction/Core.lean` without changing the definitions or theorem
statements. This is a clean-room finite variational layer modeled on the
action/Euler-Lagrange organization of PhysLean:

1. prove the squared-residual action is nonnegative;
2. prove action zero iff every link obeys the selected unitary evolution;
3. derive linkwise Hilbert-norm conservation both from the EOM and from action
   zero;
4. close the positive scalar jump and zero constant-history controls exactly.

The nontrivial control is load-bearing: do not permit an action definition that
vanishes on every history. Do not claim that the unitary, action, Hilbert space,
or time slicing is derived from primitive data. The theorem is a rigorous
finite action characterization of selected unitary dynamics and is intended as
the reusable action shell for the null-edge Dirac walk.

Run only:

`lake env lean FiniteUnitaryPathAction/Core.lean`

Reference theorem shapes may be taken from Mathlib finite sums, norm-square
positivity, `LinearIsometryEquiv.norm_map`, and sum-zero rigidity. Clean-room
proof only.

```yaml
aristotle:
  project_id: f22d0921-567f-40ed-b410-91a40c1aecf2
  target_file: FiniteUnitaryPathAction/Core.lean
  expected_module: FiniteUnitaryPathAction.Core
  submission_project: AgentTasks/aristotle-submit/codex-finite-unitary-path-action-20260710-project
  output_dir: AgentTasks/aristotle-output/f22d0921-567f-40ed-b410-91a40c1aecf2
  status: harvested, integrated, and guarded at 06:35 PDT
```

The returned file closes every theorem and passes local Lean. It is integrated
as `PhysicsSM.Draft.NullEdge.FiniteUnitaryPathAction`; the project docstring
uses the literature-audited phrase "least-residual action characterization"
rather than claiming a primitive stationary-action derivation.
