# Aristotle proof task: finite CAR functoriality and unitarity

Paper E publication gate.  Starting from the landed determinant-minor lift and
creation covariance, prove identity, composition, conjugate-transpose, and
Fock-inner-product preservation without changing any statement or replacing
the determinant by an abstract exterior-power API.

Required output:

1. all seven target theorems in `FiniteCARFunctorial/Main.lean` proved;
2. no weakened scalar field, mode type, or unitarity condition;
3. no compiler-trust shortcut or new assumption;
4. preserve the nonzero occupied-state control;
5. if full functoriality blocks, return every proof-complete prefix and identify
   the exact missing Cauchy-Binet or ordered-minor lemma.

Semantic context:
`AgentTasks/context-packs/codex-pub-car-functorial-20260710-183322.md`.

Manuscript consequence: success closes the functoriality/unitarity half of
Paper E.  It does not by itself establish inherited spatial locality or an
interacting scattering observable.

```yaml
aristotle:
  project_id: f90d69c7-00f9-4a5f-9d8e-7435504c4bae
  target_file: FiniteCARFunctorial/Main.lean
  expected_module: FiniteCARFunctorial.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-car-functorial-20260710-project
  output_dir: AgentTasks/aristotle-output/f90d69c7-00f9-4a5f-9d8e-7435504c4bae
  status: integrated
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

Final snapshot audit: all requested theorems are proof-complete with unchanged
statements.  The live module contains the same functorial, adjoint, inverse, and
inner-product payload; its adjoint identity is factored as the stronger reusable
lemma `fockInner_Gamma_left`.
