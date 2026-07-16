# Aristotle independent replay: L0 fixed-support boost no-go

Work item: `L0-BOOST-001`  
Role: Reproducer  
Status: integrated

## Exact target

Starting only from the displayed rational boost

```text
Lam = [[5/3, 4/3], [4/3, 5/3]],
```

independently prove that the orbit of `(1,0)` is injective and that no finite
forward-invariant support can contain it. Also prove the Minkowski-form
preservation theorem and the zero/identity boundary controls.

The standalone target contains the exact definitions and statements but no
copied proofs. It imports only Mathlib.

## Semantic boundary

This is a fixed finite-support obstruction. It is not a theorem about random
causal sets, invariant probability laws, or Lorentz symmetry in distribution.

## Aristotle

```yaml
aristotle:
  project_id: 04eeaea0-770f-4e1b-bd5a-18cc9f8a1077
  task_id: 6287586e-116d-462a-a0e6-81a4879abbc0
  target_file: L0BoostReplay.lean
  expected_module: L0BoostReplay
  submission_project: AgentTasks/aristotle-submit/codex-afpl-l0-replay-20260712-project
  output_dir: AgentTasks/aristotle-output/04eeaea0-770f-4e1b-bd5a-18cc9f8a1077
  status: integrated
```

## Integration result

Aristotle task `6287586e` independently closed all eleven proof holes without
changing any definition or theorem statement. The returned source compiles in
the pinned repository, contains no proof holes or trust-expanding constructs,
and reports only `propext`, `Classical.choice`, and `Quot.sound`.

The replay includes the headline no-go, Minkowski-form preservation, the
nonzero future unit-timelike witness, the zero-singleton boundary case, and the
identity control. AFPL work item `L0-BOOST-001` is integrated. The positive
law-level Lorentz question remains separate in `L0-DIST-001`.
