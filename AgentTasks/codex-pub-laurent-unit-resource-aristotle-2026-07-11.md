# Aristotle proof job: Laurent-unit resource theorem

Name this project `codex-pub-laurent-unit-resource-20260711`.

Run:

```text
lake env lean LaurentUnitResource/Main.lean
```

Prove the exact classification of units in `LaurentPolynomial K` over a field,
the uniqueness of the monomial exponent, and the explicit two-term nonunit
control.  Search Mathlib first; if a stronger existing theorem applies, wrap it
without changing the public statements.  If the statement needs an integral
domain rather than a field or a normalization adjustment, report the exact API
issue and smallest corrected theorem.

After the ring theorem is complete, propose but do not overclaim the narrowest
determinant corollary for a one-dimensional finite-range translation-invariant
strict QCA.  Do not label the ring theorem a Nielsen--Ninomiya theorem, a
three-dimensional no-doubling result, or an alias-removal obstruction by
itself.

```yaml
aristotle:
  project_id: ea501e65-70a2-42f1-b19e-1aa59da775f2
  task_id: 9d552908-9fed-49d4-8a70-e75429737bd2
  target_file: LaurentUnitResource/Main.lean
  expected_module: LaurentUnitResource.Main
  submission_project: AgentTasks/aristotle-submit/codex-pub-laurent-unit-resource-20260711-project
  output_dir: AgentTasks/aristotle-output/ea501e65-70a2-42f1-b19e-1aa59da775f2
  status: integrated-from-running-snapshot
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

At 07:49 PDT Codex downloaded an in-progress snapshot. The target source was
already proof-complete, contained no proof holes or escape-hatch tokens, and
compiled independently against the pinned repository toolchain. It additionally
contained the requested narrow determinant corollary
`qca_det_is_unique_monomial`. The source was integrated under the project
namespace as `PhysicsSM/Draft/NullEdge/LaurentUnitResource.lean`; the remote
project was instructed to stop further proof search and finalize its current
source.
