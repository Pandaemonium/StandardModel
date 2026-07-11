# Aristotle task: strict-locality kill for commutator-Wilson candidate

## Scientific finding

The older strict-QCA strategy proposed factors with angle `r*q` and called the
result a finite Laurent-polynomial QCA while using noninteger `r` to lift known
aliases. That locality claim is false: `cos(r*q)` and `sin(r*q)` are finite
harmonics in `exp(i*q)` only for integer frequency `r`. This target proves the
exact family-scoped consequence: every integer-frequency member has a trivial
Wilson gate at the zone edge and retains all three even-corner aliases.

## Target

Prove all theorems in:

`CommutatorWilsonStrictnessKill/Main.lean`

Run:

```text
lake env lean CommutatorWilsonStrictnessKill/Main.lean
```

## Constraints

- Preserve every statement.
- No new assumptions or compiler-trusting shortcuts.
- This is explicitly family-scoped; do not inflate it into a universal QCA
  no-go.
- Use `Real.sin_int_mul_pi` and `Real.cos_int_mul_pi` where appropriate.
- Keep the exact range-one nondegeneracy control.
- If a helper about integer powers of `-1` is needed, add it locally.

## Publication effect

Success converts a misleading successor claim into a sharp negative theorem:
within this commutator-Wilson ansatz, strict finite harmonic range and the
advertised zone-edge de-aliasing cannot coexist.

## Metadata

```yaml
aristotle:
  project_id: 144a848d-d853-4ab5-b741-2a6fd7e0398b
  task_id: pending
  target_file: CommutatorWilsonStrictnessKill/Main.lean
  expected_module: CommutatorWilsonStrictnessKill.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-commutator-wilson-strictness-kill-20260710-project
  output_dir: AgentTasks/aristotle-output/144a848d-d853-4ab5-b741-2a6fd7e0398b
  status: submitted
```
