# Hostile audit: corrected commutator regulator

Audit the promoted `CommutatorRegulator.lean`, concentrating on:

- whether the four-factor word is exactly the intended group commutator;
- whether `IsUnitary` and every multiplication-order proof are correct;
- the corrected load-bearing `G * G = 1` hypothesis in the central-collapse
  theorem;
- whether the explicit counterexample really satisfies anticommutation and
  refutes the old theorem;
- whether the rational noncentral fixture is genuinely Hermitian, involutory,
  and noncentral;
- any prose that confuses a finite matrix word with a Laurent-local walk or a
  spectral regulator.

Return `COMMUTATOR_REGULATOR_AUDIT_REPORT.md` with severity-ranked findings,
exact safe wording, and the smallest next composition theorem. Do not edit the
Lean source.

```yaml
aristotle:
  project_id: 99861ff2-2b83-4d4a-825e-de75287493ad
  task_id: 3cb95259-5891-4dbb-a1ec-b402da494db4
  target_file: CommutatorRegulator.lean
  expected_module: COMMUTATOR_REGULATOR_AUDIT_REPORT.md
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-commutator-regulator-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/99861ff2-2b83-4d4a-825e-de75287493ad
  status: completed-pass
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Report copied to `COMMUTATOR_REGULATOR_AUDIT_REPORT.md`. Verdict: no semantic
or algebraic flaw; all findings were low severity. Post-audit strengthening
landed the commuting `+I` control, a symmetric missing-`A^2=1` counterexample,
a Hermitian missing-`G^2=1` witness, and genuine exclusion of every scalar
matrix for the rational mixed fixture.
