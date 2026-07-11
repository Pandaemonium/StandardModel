# Aristotle audit: Pluecker quartic versus one-body CAR generators

Name this project `codex-pub-quartic-generator-audit-20260711`.

Perform a hostile review-only semantic audit of the exact supplied Lean files
`PlueckerQuarticNotOneBody.lean`, `PlueckerQuarticInteraction.lean`, and
`FiniteCARFockBasic.lean`, plus the live E-H1 claim/gate rows. Do not edit files
and do not build the full repository.

Check:

1. Is `oneBodyGenerator A = sum_ij A_ij create_i annihilate_j` the standard
   finite number-preserving one-body CAR generator with the repository's
   creation/annihilation order and sign convention?
2. Does `oneBodyGenerator_high_to_low_zero` correctly use disjoint pair states,
   or can any one-body term connect `{2,3}` to `{0,1}` through a sign/order
   subtlety?
3. Does the nonzero quartic amplitude theorem match the same input/output
   orientation and phase?
4. Is `witnessQuartic_not_oneBodyGenerator` nonvacuous and stronger/different
   from the no-`Gamma(U)` theorem without conflating generators and evolution?
5. Audit every manuscript phrase: “genuine two-body certificate” is intended;
   “local Hamiltonian,” “exact flow,” “not Gaussian,” “scattering,” and
   continuum claims are prohibited.
6. Give PASS/FAIL, severity-ranked findings, the strongest safe one-sentence
   result, and the next theorem needed for a spatially local dynamical paper.

```yaml
aristotle:
  project_id: 3e0fa1a7-d4fd-4345-aba8-837d9b15a49f
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-quartic-generator-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/3e0fa1a7-d4fd-4345-aba8-837d9b15a49f
  status: harvested-pass
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Harvest disposition

PASS. The auditor independently confirmed the standard `a_i^* a_j` order, the
all-matrix vanishing of the disjoint-pair one-body block, the exact forward
quartic amplitude and phase, and the distinction between generator-level and
evolution-level obstructions. The strongest safe scope remains the displayed
four-mode fixed-basis model. No spatial locality, exponential-flow,
Bogoliubov/Gaussian, scattering, or continuum claim is licensed. Report:
`AgentTasks/aristotle-output/3e0fa1a7-d4fd-4345-aba8-837d9b15a49f/result/codex-pub-quartic-generator-audit-20260711-project_aristotle/AUDIT_REPORT_codex-pub-quartic-generator-audit-20260711.md`.
