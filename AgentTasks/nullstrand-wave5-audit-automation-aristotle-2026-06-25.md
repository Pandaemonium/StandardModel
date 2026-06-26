# Aristotle task: wave 5 audit automation recovery and hardening

Date: 2026-06-25

## Objective

Recover and implement the script-level audit automation that the wave-4 report
described but did not include in its returned archive. Make G0 mechanically
auditable rather than prose-audited.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full `lake build`.
This is mostly a script/documentation job. If a targeted Lean check for
`PhysicsSM/NullStrand/Audit.lean` works, use it as a cheap sanity check only.
Prefer running the new scripts on a narrow target set. If the local environment
blocks execution, return patchable scripts plus exact commands for us to run.

## Requested output

- Patchable scripts under `Scripts/` for:
  - generating a declaration inventory for public NullStrand names;
  - checking draft/handoff import leaks into trusted NullStrand modules;
  - reconciling `Sources/NullStrand_Lean_Theorem_Manifest.csv` against live
    declarations;
  - reporting the public-capstone assumption surface for
    `finiteIIDNullStrand_master` and `checkerboardBohmBell_master`.
- Any small Lean audit additions needed under `PhysicsSM/NullStrand/Audit/`.
- A short `Sources/NullStrand_Audit_Plan.md` or equivalent runbook if useful.
- A completion report that clearly separates implemented artifacts from proposed
  follow-up automation.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave5-audit-automation-20260625-161653.md`
- `PhysicsSM/NullStrand/Audit.lean`
- `PhysicsSM/NullStrand/Audit/CapstoneAxioms.lean`
- `PhysicsSM/NullStrand/Audit/DuplicateNames.lean`
- `Sources/NullStrand_Lean_Theorem_Manifest.csv`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Scripts/check_forbidden_lean_tokens.py`

## Aristotle metadata

```yaml
aristotle:
  project_id: 853763fe-88b5-4d97-9630-69e8296b3275
  task_id: 62348e81-5558-4bfa-b522-275f4c0b30b1
  target_file: Scripts/check_nullstrand_manifest.py
  expected_module: nullstrand_audit_scripts
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave5-audit-automation-20260625-project
  output_dir: AgentTasks/aristotle-output/853763fe-88b5-4d97-9630-69e8296b3275
  status: completed_archive_missing_claimed_artifacts
```

## Integration notes

2026-06-25 Codex integration pass:

- Aristotle reported completion, but the downloaded archive did not contain the
  claimed `Scripts/check_nullstrand_*.py` files, `Scripts/nullstrand_audit_lib.py`,
  `Sources/NullStrand_Audit_Plan.md`, or the completion report.
- The archive only references those artifacts in `ARISTOTLE_SUMMARY.md`, so no
  script-layer changes were integrated from this job.
- This is being resubmitted in the next ambitious wave with an explicit
  "return patchable files" instruction.
