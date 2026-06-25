# Aristotle task: P1 observer spin frame SU(2) proof

Submitted: 2026-06-24.

## Scientific role

This task advances `P1-F`, the formalization paper for mass from finite
null-spinor geometry. The frame-audited observer-channel story needs a clean
residual-gauge theorem:

```text
fix observer/rest block A A^dagger
det A = det B = 1
A A^dagger = B B^dagger
=> B^{-1} A in SU(2)
```

This is the finite stabilizer statement that a fixed timelike observer block
leaves only the compact `SU(2)` spin-frame freedom. It complements the already
integrated determinant-invariance and observer-normalization results.

## Aristotle instructions

Please work on:

```text
NullEdgeP1ObserverSpinFrameSU2/Core.lean
```

Run the narrow check first:

```text
lake env lean NullEdgeP1ObserverSpinFrameSU2/Core.lean
```

Primary target:

```lean
observerSpinFrame_wellDefined_up_to_SU2
```

Guardrails:

- Keep the statement semantically unchanged unless it is false or Mathlib's
  `specialUnitaryGroup` API requires an equivalent formulation.
- Do not replace the theorem with a mere determinant-preservation lemma; the
  publication value is the residual `SU(2)` stabilizer claim.
- If the exact statement is too hard because of inverse/conjTranspose API
  details, add small helper lemmas but keep the core conclusion.

Please finish with a concise next-steps note:

- whether the target was solved;
- whether any statement/API change was needed;
- which Mathlib lemmas were key;
- the next one or two finite P1-F frame-audit targets you recommend.

## Metadata

```yaml
aristotle:
  project_id: 7a6ac35f-f9ce-43ae-8f6c-f4ef3bc60298
  task_id: cb9fe99e-5c55-4353-8b50-ae0ab51526a6
  target_file: NullEdgeP1ObserverSpinFrameSU2/Core.lean
  expected_module: NullEdgeP1ObserverSpinFrameSU2.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p1-observer-spin-frame-su2-proof-20260624-project
  output_dir: AgentTasks/aristotle-output/7a6ac35f-f9ce-43ae-8f6c-f4ef3bc60298
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeObserverSpinFrameSU2
```

The standalone source under `AgentTasks/aristotle-standalone/` was also updated
with the completed proof. The theorem keeps the full
`Matrix.specialUnitaryGroup` conclusion, so it proves both unitary and
determinant-one residual spin-frame freedom after fixing the observer block.
