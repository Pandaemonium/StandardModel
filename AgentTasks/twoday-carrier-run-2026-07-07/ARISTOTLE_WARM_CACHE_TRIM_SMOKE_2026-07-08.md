# Aristotle Warm-Cache Trim Smoke - 2026-07-08

Purpose: test whether Aristotle can receive a project directory containing a
trimmed `.lake` cache and use a prebuilt project module instead of rebuilding or
requiring the source file.

Submission project:

- `AgentTasks/aristotle-submit/ne-warm-cache-trim-smoke-20260708-project`

Trimmed cache contents:

- `.lake/build/lib/lean/PhysicsSM/Prelude.olean`
- `.lake/build/lib/lean/PhysicsSM/Prelude.ilean`
- matching `.hash` files
- `Prelude.trace`

Deliberately omitted:

- full repo `.lake`
- `.lake/packages`
- `PhysicsSM/Prelude.lean`
- any old Aristotle output

Target command:

```text
lake env lean WarmCacheSmoke/Target.lean
```

Expected behavior:

- Lean imports `PhysicsSM.Prelude` from the submitted `.lake` artifacts.
- Aristotle replaces the single proof hole in `trim_lake_smoke_target`.
- Aristotle reports whether the warm-cache layout was preserved and usable.

Aristotle metadata:

```yaml
aristotle:
  project_id: 64569dc2-2c02-4857-935e-263ce6be0723
  task_id: d5e3c294-1339-4468-9d6b-5407fcf131c4
  target_file: WarmCacheSmoke/Target.lean
  expected_module: WarmCacheSmoke.Target
  submission_project: AgentTasks/aristotle-submit/ne-warm-cache-trim-smoke-20260708-project
  output_dir: AgentTasks/aristotle-output/64569dc2-2c02-4857-935e-263ce6be0723
  status: running
```

Submitted with:

```powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/ne-warm-cache-trim-smoke-20260708-project "..."
```

Local preflight:

- Package size after adding the trimmed cache: 9 files, about 35 KB.
- `lake env lean WarmCacheSmoke/Target.lean` passed locally from inside the
  submission project, with only the intentional proof-hole warning.
- Because `PhysicsSM/Prelude.lean` is absent from the submission project, this
  confirms local import resolution used the submitted
  `.lake/build/lib/lean/PhysicsSM/Prelude.olean` cache slice.

Remote status:

- Initial `aristotle list --limit 5`: project `RUNNING`.
- Initial `aristotle tasks ... --limit 10`: task `QUEUED`, then `IN_PROGRESS`.
- After roughly two minutes: still `RUNNING` / `IN_PROGRESS`.

Remote result:

- Final task status: `COMPLETE_WITH_ERRORS`.
- Aristotle reported `error: unknown module prefix 'PhysicsSM'`.
- Diagnosis: the upload did not preserve the hidden `.lake/build` subtree.  On
  the worker, `.lake/build/lib/lean/PhysicsSM/Prelude.olean` was absent.

## Retry v2: visible cache plus restore script

Submission project:

- `AgentTasks/aristotle-submit/ne-warm-cache-trim-smoke-v2-20260708-project`

Change from v1:

- The cache slice is shipped under visible path
  `warm-cache/build/lib/lean/PhysicsSM/`.
- A visible fallback archive `warm-cache-prelude.tar.gz` is also shipped.
- `restore_warm_cache.sh` recreates `.lake/build/lib/lean/PhysicsSM/` on the
  worker before the Lean check.

Local preflight:

- `sh restore_warm_cache.sh; lake env lean WarmCacheSmoke/Target.lean` passed
  locally, again with only the intentional proof-hole warning.
- The locally restored hidden `.lake` was then removed from the v2 submission
  directory before upload, so the remote test depends on visible cache restore.

Aristotle metadata v2:

```yaml
aristotle:
  project_id: 98f78e0b-e922-4151-a010-e4b3aa69fd60
  task_id: d89bdb43-e812-4b45-93ba-832cbe4764b5
  target_file: WarmCacheSmoke/Target.lean
  expected_module: WarmCacheSmoke.Target
  submission_project: AgentTasks/aristotle-submit/ne-warm-cache-trim-smoke-v2-20260708-project
  output_dir: AgentTasks/aristotle-output/98f78e0b-e922-4151-a010-e4b3aa69fd60
  status: running
```

Submission note:

- The Aristotle CLI warned that the project contains `.lean` files but no
  `.lake` folder.  This is expected for v2: the point is to test visible cache
  restore into `.lake/build` on the worker, because v1 showed hidden `.lake`
  upload is not reliable.

Remote result v2:

- Final task status: `COMPLETE`.
- Downloaded archive:
  `AgentTasks/aristotle-output/98f78e0b-e922-4151-a010-e4b3aa69fd60/project-files.tar.gz`
- Returned summary:
  `AgentTasks/aristotle-output/98f78e0b-e922-4151-a010-e4b3aa69fd60/extracted/project-files.tar/ne-warm-cache-trim-smoke-v2-20260708-project_aristotle/ARISTOTLE_SUMMARY.md`
- Aristotle reported that the visible `warm-cache/` directory was not preserved
  by upload, but the visible `warm-cache-prelude.tar.gz` archive was preserved.
- `restore_warm_cache.sh` extracted the tarball and recreated
  `.lake/build/lib/lean/PhysicsSM/`.
- `lake env lean WarmCacheSmoke/Target.lean` then succeeded without `lake build`,
  dependency fetch, or network access.
- Aristotle replaced the proof hole in `trim_lake_smoke_target` with `by rfl`
  and reported that the theorem does not depend on any axioms.

Conclusion:

- Hidden `.lake/build` upload does not work.
- Visible cache directories may also be filtered.
- A visible compressed cache archive plus an explicit restore script DOES work
  for at least this small prebuilt-project-module smoke test.
