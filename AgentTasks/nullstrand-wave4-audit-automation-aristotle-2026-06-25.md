# Aristotle task: wave 4 audit automation and manifest reconciliation

Date: 2026-06-25

## Objective

Turn the new in-tree audit scaffold into more useful generated checks. The goal
is not only to `#check` declarations, but to make declaration drift, duplicate
names, draft imports, and capstone assumption surfaces visible enough that G0 can
be closed mechanically.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full
`lake build`. If targeted checks for `PhysicsSM/NullStrand/Audit.lean` work, use
them only as cheap checks. If dependency setup fails or looks slow, skip build
and return patchable Lean/scripts plus exact blockers.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/Audit/` or a script-level proposal
  under `Scripts/` if Lean is the wrong layer for a generated check.
- A manifest reconciliation plan for
  `Sources/NullStrand_Lean_Theorem_Manifest.csv`.
- A draft-import firewall strategy that distinguishes trusted imports from
  intentionally quarantined draft/handoff modules.
- A capstone assumption-whitelist approach for
  `finiteIIDNullStrand_master` and `checkerboardBohmBell_master`.
- A completion report with exact commands a human should run locally.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave4-audit-automation-20260625-150653.md`
- `PhysicsSM/NullStrand/Audit.lean`
- `PhysicsSM/NullStrand/Audit/Inventory.lean`
- `PhysicsSM/NullStrand/Audit/DraftFirewall.lean`
- `Sources/NullStrand_Lean_Theorem_Manifest.csv`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Scripts/check_forbidden_lean_tokens.py`

## Aristotle metadata

```yaml
aristotle:
  project_id: e676e62f-ab89-466d-9bf4-b693c39ed34a
  task_id: e58437c4-82df-4d15-bbc4-f0571b7c4423
  target_file: PhysicsSM/NullStrand/Audit/Inventory.lean
  expected_module: PhysicsSM.NullStrand.Audit.Inventory
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave4-audit-automation-20260625-project
  output_dir: AgentTasks/aristotle-output/e676e62f-ab89-466d-9bf4-b693c39ed34a
  status: partially_integrated
```

## Integration

Partially integrated into `PhysicsSM/NullStrand/Audit.lean` and new audit
modules under `PhysicsSM/NullStrand/Audit/`. The returned archive did not
include the script/doc artifacts named in the completion summary, so script-level
manifest/firewall automation remains a follow-up target.
Report: `AgentTasks/nullstrand-wave4-audit-automation-report-aristotle-2026-06-25.md`.
