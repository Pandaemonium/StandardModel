# Aristotle audit: publication artifact and reproducibility bundle

Perform a hostile review-only audit of the supplied publication verifier,
artifact manifest, gate matrix, claim matrix, CI workflow, and current generated
summary. Do not edit files and do not infer success from prose.

Check:

1. whether every manuscript headline marked machine-checked has a direct Lean
   target or an explicit aggregate guard in the verifier;
2. whether the verifier actually fails on a missing target, failed Lean check,
   changed numerical fixture, or unexpected trusted-assumption footprint;
3. whether `ARTIFACT_MANIFEST.md` accurately describes what is rebuilt and
   what remains outside the executable bundle;
4. whether the CI workflow invokes the same authoritative command and pins an
   adequate environment;
5. whether `summary.json` is deterministic, self-describing, and sufficient to
   identify the checked source state;
6. any stale paths, unguarded headline modules, misleading use of words such as
   reproducible or complete, and any gap between the gate matrix and executable
   checks;
7. the smallest exact patch list needed before a top-tier submission artifact
   can be called independently reproducible.

Return findings ordered `FATAL`, `MAJOR`, `MINOR`, and `CLEAR`, then a
file-by-file verdict table, exact replacement language, and a final `PASS`,
`PASS WITH PATCHES`, or `FAIL`. Distinguish an executable mathematical check
from manuscript semantics and from environment provisioning.

```yaml
aristotle:
  project_id: 73433966-eceb-417a-83bf-7e802450755a
  target_file: review-only
  expected_module: review-only
  submission_project: AgentTasks/aristotle-submit/codex-pub-reproducibility-audit-20260710-project
  output_dir: AgentTasks/aristotle-output/73433966-eceb-417a-83bf-7e802450755a
  status: harvested/integration-in-progress
  run: overnight-publication-run-2026-07-11
  owner: Codex
```

## Disposition

Aristotle returned `PASS WITH PATCHES`; the full report is preserved as
`AgentTasks/overnight-publication-run-2026-07-11/REPRODUCIBILITY_AUDIT_2026-07-10.md`.
Accepted immediately: golden fixture hashes are now executable assertions;
the summary schema excludes timing and absolute paths and records exact module
coverage and tool versions; missing dynamics, duplicate mass-operator, carrier,
and four-channel targets/pins were added; CI now pins Ubuntu, Python, and NumPy
and has an opt-in/scheduled full-build path. A clean immutable commit/tag,
clean-checkout verification, archive identifier, and repository license remain
dawn/release gates rather than claims of the dirty overnight tree.
