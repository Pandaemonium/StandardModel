# Aristotle adversarial audit: intrinsic selector descent

Review the supplied Paper F classification program, exact current source
modules, and the new typechecking `SelectorDescent/Main.lean` target. Do not edit
or prove files in this job.

Questions:

1. Is preservation of `ker eval` exactly the correct necessary-and-sufficient
   criterion for a source-level selector to descend to represented operators?
2. Is surjectivity necessary only for existence on the whole codomain and
   uniqueness, or has the statement hidden a stronger assumption than needed?
3. Does the quotient construction have the correct composition orientation?
4. Does this criterion materially advance the carrier decomposition problem,
   or is it merely a generic first-isomorphism-theorem repackaging?
5. What is the smallest noncircular live-carrier theorem that would instantiate
   it for solder degree or edge exchange?
6. What exact relation witness would kill presentation independence if the
   selector does not descend?
7. After adding this criterion to the landed torsor/shear/selector no-gos, what
   claims are safe in an abstract and what gates still block a standalone
   classification paper?

Return findings ordered `FATAL`, `MAJOR`, `MINOR`, then a theorem-shape verdict,
a publication verdict, and the single highest-value successor theorem. Treat
the live repository build results recorded in the run docs as authoritative for
the already landed modules; this reduced review package is for semantic audit.

```yaml
aristotle:
  project_id: 42092589-e223-45d8-a522-dadf651835ca
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-selector-descent-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/42092589-e223-45d8-a522-dadf651835ca
  status: harvested
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

No fatal theorem-shape issue. The criterion is correct under its displayed
surjectivity boundary but generic; it becomes scientifically substantive only
after a noncircular live-carrier solder-degree or edge-exchange selector is
proved to preserve the evaluation kernel. Findings are preserved in
`SELECTOR_DESCENT_SEMANTIC_AUDIT_2026-07-11.md`.
