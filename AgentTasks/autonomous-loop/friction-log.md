# Friction log

Use this file for anything that slows autonomous progress.

Template:

```text
## YYYY-MM-DD - Short title

Area: Aristotle | Lean | literature | Zotero | Neo4j | Claude | Pro | docs | validation | Windows | other
Severity: low | medium | high
Status: open | mitigated | accepted | fixed

What happened:
- ...

Why it matters:
- ...

Proposed fix:
- ...

Follow-up:
- ...
```

## 2026-06-27 - Long generated shell command hit Windows command length

Area: Windows / docs
Severity: low
Status: mitigated

What happened:
- The first attempt to create all harness files through one generated Python
  here-string failed with Windows error 206, `The filename or extension is too
  long`.

Why it matters:
- Bulk generated writes can fail before the Python script starts if the shell
  command itself is too long.

Proposed fix:
- Prefer `apply_patch` or shorter script files for bulk scaffolding.

## 2026-06-27 - Known recurring friction seeds

Area: Aristotle / Windows / literature / validation
Severity: medium
Status: open

What happened:
- Previous loops saw Windows archive extraction edge cases for Aristotle output.
- Full-repo Aristotle packages can spend budget on project builds before proof
  search.
- Literature ingestion can stall on duplicate checks or MCP/script hiccups.
- Validation is expensive and should be targeted before full builds.

Why it matters:
- These issues reduce useful theorem-search time and increase integration
  overhead.

Proposed fix:
- Prefer targeted Aristotle extraction scripts.
- Prefer context packs and focused packages over full-repo submissions when
  possible.
- Keep duplicate-check rules in the literature runbook.
- Record exact validation commands with claimed trusted results.

## 2026-06-27 - Full-repo Aristotle package contained stale context copies

Area: Aristotle / integration
Severity: medium
Status: open

What happened:

- C85 and C72 returned full-repo packages with hundreds of Lean/Markdown context
  files.
- Only one new Lean module in each package was actually intended for
  integration.
- Several package files differed from the current repo because they were stale
  context copies, not intended edits.

Why it matters:

- Blind extraction would overwrite local progress and create semantic churn.

Proposed fix:

- Add a helper command that compares package entries against the current repo,
  extracts only requested targets and summaries, and reports all other diffs as
  ignored context drift.

## 2026-06-27 - FUR-H10 exhausted Aristotle budget

Area: Aristotle
Severity: medium
Status: open

What happened:

- Project `40b43a57-f6c6-4f66-ab48-54e377697bc9` reports task status
  `OUT_OF_BUDGET`.

Why it matters:

- A non-complete project can look superficially like an idle/completed project
  in `aristotle list`.

Proposed fix:

- Require `aristotle tasks <project-id>` status checks before integration.
- Resubmit a narrower job only if the target remains strategically important.

## 2026-06-27 - Historical IDLE jobs needed deliverable-existence audit

Area: Aristotle / integration
Severity: medium
Status: open

What happened:

- Older completed C71/C74/C75/C77/C78/C79 projects still appeared as IDLE in
  `aristotle list`.
- Their named deliverables already existed in the repo, but this was not
  machine-readable in the new harness.

Why it matters:

- Future loops can waste time re-checking or risk overwriting existing work from
  stale package context.

Proposed fix:

- Add a completed-project registry or teach the helper script to compare project
  IDs against `completed-integrations.md`.

## 2026-06-27 - Aristotle service rejected task/download checks while projects are running

Area: Aristotle
Severity: medium
Status: open

What happened:

- `aristotle tasks` and `aristotle download` intermittently returned:
  `ERROR - You have too many projects in progress. Cancel a running task or wait
  for one to complete before starting another.`
- This happened while checking/downloading some COMPLETE Wave 19 projects, most
  notably C83/C84.

Why it matters:

- The loop can identify completed jobs but still be unable to download or
  integrate them until project-capacity pressure clears.

Proposed fix:

- Add retry/backoff logic to the Aristotle integration helper.
- Record COMPLETE-but-not-downloaded projects explicitly in the queue.
- Avoid launching fresh jobs until stuck downloads have been retried, unless the
  new job is strategically urgent and capacity is available.

Follow-up:

- Retry C83/C84 downloads in the next loop before submitting C89/C90.
- Retried during the second loop cycle; C83/C84 downloads then succeeded. Keep
  the friction item open because the underlying service-capacity behavior can
  recur while several projects are running.

## 2026-06-27 - Aristotle metadata/doc-search stalls during mandatory cycle

Area: Aristotle / literature / Windows
Severity: medium
Status: open

What happened:

- `aristotle --help` and `aristotle status 13131a2b-6428-440b-9372-decd7603a608`
  timed out during the loop.
- A Neo4j repo-doc search for C89/C90 context raised a Windows `cp1252`
  `UnicodeEncodeError` while printing a snippet containing a Greek character.
- A targeted `integrate_completed.py` call for C76 succeeded, but the package
  was a no-op full-repo context package with unchanged files and an unchanged
  draft placeholder hit, so no files were applied.

Why it matters:

- The loop can satisfy the mandatory literature and Aristotle steps, but
  metadata stalls make it risky to submit new jobs immediately afterward.
- Windows console encoding can make otherwise useful literature/doc searches
  appear failed.

Proposed fix:

- Prefer `integrate_completed.py <project-id>` over broad Aristotle metadata
  calls when a project ID is known.
- Teach literature search wrappers to force UTF-8 output, for example by
  setting `PYTHONIOENCODING=utf-8`.
- Consider adding a `reviewed_no_changes` registry so full-repo no-op packages
  do not keep reappearing as integration work.

## 2026-06-27 - Aristotle slim package no-lake warning on C89/C90

Area: Aristotle / packaging
Severity: low
Status: monitoring

What happened:

- Both C89 and C90 submissions succeeded, but Aristotle warned:
  `Your project contains .lean files but no .lake folder. Aristotle works better
  with access to your project's dependencies.`

Why it matters:

- The existing slim-package helper intentionally excludes local build state, but
  if Aristotle fails to resolve dependencies this warning may become a real
  packaging problem.

Proposed fix:

- Monitor C89/C90. If they fail because dependencies are unavailable, adjust the
  submission helper or use a focused package with explicit dependencies.
## 2026-06-27 - Claude wrapper cp1252 decode failure on C1 review

Area: Claude / Windows / encoding
Severity: medium
Status: open

What happened:

- The first C1 Claude review call wrote a log but captured `Response stdout` as
  `None` after a Python `cp1252` decode exception.
- Rerunning with `PYTHONIOENCODING=utf-8` and `PYTHONUTF8=1` produced a usable
  response.

Why it matters:

- The loop requires Claude review every cycle; a completed model call with empty
  response should not count as review.

Proposed fix:

- Set UTF-8 environment defaults inside `send_claude_review.py`, or have the
  harness always set `PYTHONIOENCODING=utf-8` and `PYTHONUTF8=1` before model
  calls on Windows.

## 2026-06-27 cycle 4 friction

- `Scripts/aristotle/integrate_completed.py --from-list` was too broad and swept older idle jobs, then blocked on unrelated placeholder hits. Prefer focused project-id integration for active-round jobs.
- Aristotle archive extraction failed on C90 because tar members lacked explicit parent directory entries. Patched `Scripts/aristotle/integrate_completed.py` to create parent directories for file members before extraction.
- C90 raw task summary claimed edits to `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean`, but the downloaded archive omitted that target file. The result had to be reconstructed manually from `aristotle tasks`. Follow-up tooling should fail loudly when a task summary claims changed files but the downloadable payload is context-only.
- `Scripts/lit/neo4j_doc_search.py` again hit Windows stdout encoding on non-ASCII replacement characters. Workaround: run with `PYTHONIOENCODING=utf-8` and `PYTHONUTF8=1`.
## 2026-06-27 cycle 5 friction

- Full `aristotle submit --project-dir .` for C97 failed because Aristotle rejects the repo's local `SpherePacking` dependency from `lake-manifest.json`. Workaround used: prompt-only C97 submission. This is weaker than a kernel-checked full-repo Aristotle package.
- C96 fake-progress trap logged: a regulator-removal theorem whose positive result is merely `(P -> Q) -> P -> Q` is not a guardrail. Future C96 must use concrete finite table content, data-carrying witnesses, and a computed limit map.
## 2026-06-27 cycle 6 friction

- No new tooling failure occurred in this cycle.
- Existing blocker remains: full-repo Aristotle submissions fail on the local `SpherePacking` dependency. Claude advised deferring a full tooling cycle unless this blocks a specific ready submission.
- Process guardrail reinforced: avoid adding more science jobs unless they are genuinely independent; prioritize returned-job integration now that the active queue is near the concurrency target.
## 2026-06-27 cycle 7 - C95 integration helper missed archive member

Friction:

- `Scripts/aristotle/integrate_completed.py` fetched and extracted C95 but reported no candidate files.
- The returned Lean module existed inside the extracted Aristotle archive under a full-repo subdirectory and had to be copied manually.

Impact:

- Manual archive inspection was required before integration.

Potential fix:

- Update the integration helper to detect newly returned files under nested archive roots and compare them against the repo by relative suffix.

## 2026-06-27 cycle 7 - model-call log extraction should be targeted

Friction:

- A raw read of the Claude model-call log produced too much output and hit Windows console Unicode issues on mathematical symbols.

Impact:

- The loop risked context flooding while trying to inspect a review result.

Potential fix:

- Use a small extractor script or command pattern that prints only response headings, matched verdict lines, and tails, with UTF-8 output configured.
## 2026-06-27 cycle 8 - Claude wrapper subprocess encoding fixed

Friction:

- Sending C97/C98 source files to Claude failed because `subprocess.run(..., text=True)` used the Windows cp1252 console encoding and could not encode Lean/math symbols such as `↔`.

Fix:

- Updated `Scripts/autonomous_loop/send_claude_review.py` to pass `encoding="utf-8"` and `errors="replace"` to `subprocess.run`.

Impact:

- The same C97/C98 review call succeeded after the patch and logged normally.

## 2026-06-27 cycle 8 - integration helper missed another nested Aristotle return

Friction:

- `integrate_completed.py` again reported no candidates for C98 even though the returned Lean file existed under a nested Aristotle archive root.
- C97 also returned useful files under nested archive paths.

Potential fix:

- Same as cycle 7: teach the helper to discover files by repo-relative suffix inside nested archive roots.
## 2026-06-27 cycle 11 - nested Aristotle archive discovery repaired

Friction:

- C95, C97, and C98 returned useful files under nested archive roots, but `integrate_completed.py` did not discover them without manual inspection.

Fix:

- Updated `Scripts/aristotle/integrate_completed.py` to discover no-metadata `PhysicsSM/Draft/*.lean` payloads under nested Aristotle archives when they are new or differ from the repo.
- Added suspicious path rejection, normalized line-ending/BOM comparison, and conflicting duplicate detection.

Review:

- Claude refined review accepted the patch with caveat and no blocker-level issue.

Remaining caveat:

- The patch has not been locally validated by running the helper against an archive in this cycle.

## 2026-06-27 - Report payload missing for returned Aristotle jobs

Observed in cycle 14:

- H11 summary reported `AgentTasks/null-edge-gate-h-forbidden-operator-neutrino-audit.md`, but the returned archive exposed only a Lean skeleton plus summary metadata.
- C105 summary reported `AgentTasks/null-edge-gate-c-release-datum-domain-wall-audit.md`, but the returned archive exposed only `ARISTOTLE_SUMMARY.md`.

Impact:

- Report-only or report-plus-skeleton tasks cannot be faithfully integrated from summaries alone.

Proposed repair:

- Harden the integration helper or runbook to audit expected Markdown report paths explicitly and classify `summary_only_report_payload_missing` as a first-class status.
## 2026-06-27 - Resolved: Markdown report extraction and Windows long paths

Observed:

- H11 and C105 report files were present in Aristotle archives but not extracted by `Scripts/aristotle/integrate_completed.py`.
- Root causes: helper filtered extraction to `.lean` plus `summary.md`, and nested report paths exceeded the classic Windows 260-character path limit.

Repair:

- `Scripts/aristotle/integrate_completed.py` now extracts `.md` artifacts.
- The extractor writes files through a Windows long-path-aware helper.
- Dry runs now report expected non-Lean Markdown targets as found or missing.

Validation:

- `python -m py_compile Scripts/aristotle/integrate_completed.py`
- C105 and H11 dry runs both reported the expected report files found.
## 2026-06-27 - Aggregate draft-root check blocked by cold `.olean` cache

Observed in cycle 16:

- `lake env lean PhysicsSMDraft.lean` failed on missing `PhysicsSM.Draft.NullEdgeNodalSetCyclotomic.olean` before reaching the new C102/C104 imports.

Impact:

- The new modules were individually checked, but the aggregate draft import root was not validated this cycle.

Potential repair:

- Warm/build the missing draft dependencies, or run `lake build PhysicsSMDraft` in a cycle dedicated to validation once integration pressure drops.
## 2026-06-27 - Cycle 17 aggregate draft-root friction

- Symptom: aggregate checks first hit cold `.olean` misses while draft imports were being warmed.
- Real issue found after warming: `PhysicsSMDraft.lean` had late `import` commands after the module docstring, which Lean rejects.
- Resolution: moved the Gate C/branch-audit draft imports into the initial import block.
- Verification: `lake env lean PhysicsSMDraft.lean` passes.

## 2026-06-27 - Cycle 18 C90 helper redownload/candidate comparison failure

- Symptom: `python Scripts/aristotle/integrate_completed.py d53724a6-a0aa-4f8a-9c85-5285177fd16b` redownloaded the C90 archive but crashed while comparing an unrelated missing candidate file from the extracted tree.
- Impact: the helper did not complete its normal candidate report, even though the actual C90 target file was present.
- Workaround: manually located `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean` in the redownloaded archive, copied it into the repo, removed the duplicate draft-root import, and validated the target plus `PhysicsSMDraft.lean`.
- Follow-up: harden `integrate_completed.py` so missing candidate files are skipped with a warning instead of aborting the whole integration pass.

## 2026-06-27 - Cycle 19 stale full-repo candidate hazard

- Fixed: `integrate_completed.py` now skips missing/non-file extracted candidate paths instead of aborting.
- Validation: `python -m py_compile Scripts/aristotle/integrate_completed.py` passed, and the C90 inspection no longer crashes.
- New hazard exposed: without target metadata, the helper can still report stale unrelated files from a full-repo Aristotle archive. In the C90 redownload, it found a stale `NullEdgeCelestialMixednessAristotle.lean` candidate that would remove `normalizedVisibleDensity_trace` if blindly applied.
- Follow-up: prefer `--task-note`/target-file metadata for old full-repo archives, and harden the helper to warn loudly about theorem-signature removals before any apply.

## 2026-06-27 - Cycle 20 theorem-signature removal guard

- Issue: broad Aristotle archives can contain stale unrelated files; applying them can remove theorem/lemma signatures from newer local work.
- Fix: `integrate_completed.py` now blocks `--apply` when candidate files remove theorem/lemma names, unless `--allow-signature-removals` is passed.
- Validation: the C90 stale candidate was blocked before copy because it would remove `normalizedVisibleDensity_trace`.

## 2026-06-27 - Cycle 27 Neo4j doc-search ingest timeout

- Command: `$PY Scripts/lit/neo4j_doc_search.py`.
- Purpose: refresh the repo's own document/Lean semantic index after meaningful Lean and Markdown edits.
- Result: timed out after five minutes with no successful refresh claimed.
- Impact: `neo4j_doc_search.py --query ...` may not include the latest cycle 18-26 edits until ingest completes.
- Follow-up: add a faster changed-file-only mode with progress output, or run the refresh out-of-band with a longer timeout and log completion.

## 2026-06-27 - Cycle 27 doc-search timeout fixed: --changed mode added

Area: Neo4j
Severity: medium
Status: fixed

What happened:
- The cycle-27 `neo4j_doc_search.py` full refresh timed out at five minutes. Root
  cause was not embedding cost (sha-skip already avoids re-embedding unchanged
  files) but one Neo4j round-trip per file across ~799 files before any work.

Fix:
- Added `--changed` to `Scripts/lit/neo4j_doc_search.py`: ingest only git-changed
  files (staged/unstaged/untracked), scoped through the same dir/exclude filters.
  A post-edit refresh now touches ~40 files instead of 799.
- Usage: `$PY Scripts/lit/neo4j_doc_search.py --changed` (or `--changed --dry-run`
  to preview). Full `--reembed` still available for a rebuild.

Follow-up:
- After a run that edits docs/Lean, refresh with `--changed` in-band; reserve the
  full scan for periodic rebuilds run out-of-band.

## 2026-06-27 - Recurrent Aristotle payload-extraction friction

Area: Aristotle
Severity: medium
Status: mitigated

What happened:
- Across the run, the dominant workflow drag was Aristotle payload extraction, not
  proof search: the C90 archive redownload crashed `integrate_completed.py` on an
  unrelated missing candidate, and C99b / C99-v2 returned with payloads the helper
  could not extract (`RETURNED_PAYLOAD_MISSING`). Full-repo archives also surfaced
  stale unrelated candidates that would have removed live theorem signatures.

Mitigations already landed (cycles 18-20):
- `integrate_completed.py` now skips missing/non-file candidates instead of
  aborting, and blocks `--apply` when a candidate removes theorem/lemma signatures
  unless `--allow-signature-removals` is passed.

Open follow-up (larger, not attempted this pass):
- Standardize on focused per-target Aristotle packages with task-note/target-file
  metadata so integration does not have to diff full-repo archives. Add a clear
  diagnostic when a returned archive has no extractable payload for the target,
  instead of a silent `PAYLOAD_MISSING`. Treat this as the next harness-hardening
  target if extraction friction recurs.
## 2026-06-27 - Cycle 3: recurring Aristotle payload-missing and C110a statement repair

Friction:

- C107 reports a complete proof stack, including `conjugate_aeval`, but
  `integrate_completed.py` found no candidate files in the downloaded archive.
- C110a was submitted with useful intent but Claude caught syntax and semantic
  statement issues: the true kernel bridge should be a normed-space finite sum
  bound, not a scalar signed-sum bound.

Impact:

- C107 cannot be integrated from source yet.
- C110a may need a continuation or replacement job even if Aristotle repairs
  the submitted scalar statement.

Mitigation:

- Sent a C107 artifact-recovery ask for the complete final file.
- Continue requiring focused Aristotle prompts to include "return the complete
  final file contents" in the final response.
- For the next path-sum job, start directly from the normed-space theorem
  suggested in Claude's cycle-3 review.

Follow-up:

- Cycle 4 artifact-recovery asks succeeded for C107 and C110a, and both
  recovered sources were preserved in standalone task areas.
- The archive extraction still returned no candidates for either project, so the
  underlying payload-missing friction remains unresolved.

## 2026-06-27 - Cycle 5: Aristotle show Unicode output crash on Windows

Friction:

- `aristotle show 96cce035-7b33-4df7-9b83-64e97bb67554 --limit 100` crashed
  under the default Windows `cp1252` console encoding when Lean symbols appeared
  in the progress output.

Impact:

- The first C107b transcript read failed even though the task had completed.

Mitigation:

```powershell
$env:PYTHONIOENCODING='utf-8'; aristotle show <project-id> --limit 100
```

Follow-up:

- Use this environment variable for future `aristotle show` calls that may
  include Lean Unicode.

## 2026-06-27 - Cycle 8: C110b archive still payload-missing

Friction:

- C110b completed, but `integrate_completed.py` found no candidate files in the
  downloaded archive.

Impact:

- Source preservation again depended on transcript recovery through
  `aristotle show`.

Mitigation:

- Used `$env:PYTHONIOENCODING='utf-8'` and copied the final source from the
  transcript into the standalone task area.

Follow-up:

- Keep asking Aristotle to include complete final file contents in the final
  response for focused jobs.

## 2026-06-27 - Cycle 13: Aristotle show polling can time out on running jobs

Friction:

- C108b and C108c `aristotle show` status polls timed out after roughly two
  minutes without returning usable status.
- C108 and the C111 rewrite did return usable transcript output, so the issue is
  specifically polling still-running or slow projects through `show`.

Impact:

- Cycle 13 could not confidently classify C108b/C108c as still running versus
  completed-with-large-output.

Mitigation:

- Recorded the status as `poll_timed_out_cycle13_still_pending` rather than
  treating the jobs as completed or failed.
- Next poll should prefer a non-waiting status command if available, or use
  smaller `--limit`/timeout settings and immediately fall back to a direct
  integration attempt only if the status reports completion.

Follow-up:

- Cycle 14 confirmed `aristotle tasks <project-id> --limit 5` is the safer
  status-polling command. Use it before `aristotle show`.

## 2026-06-27 - Cycle 14: C108b archive payload missing

Friction:

- C108b completed, but `integrate_completed.py` again found no candidate files
  in the downloaded archive.

Impact:

- Source preservation depended on transcript recovery from task-specific
  `aristotle show`.

Mitigation:

- Recovered the complete final file from
  `aristotle show 9686beef-8138-4c7d-9e11-03792420c27f --task e9f9f04d-1875-4028-93f0-f773a2ba88c1 --limit 100`.
- Continue requiring prompts to request complete final file contents.

## 2026-06-27 - Cycle 15: C108c archive payload missing and standalone metadata warnings

Friction:

- C108c completed, but `integrate_completed.py` again found no candidate files
  in the downloaded archive.
- C108d submission warned that the standalone folder had no `lean-toolchain` and
  no `.lake` folder.

Impact:

- C108c preservation again depended on transcript recovery.
- C108d may spend Aristotle budget on dependency setup or fail if the default
  environment does not infer the intended Mathlib setup.

Mitigation:

- Recovered C108c from task-specific transcript output.
- If C108d reports build/setup friction, create a minimal reusable standalone
  Mathlib package template for future focused jobs.

## 2026-06-27 - Cycle 22: C108d candidate discovery missed nested returned file

Friction:

- C108d completed and the downloaded archive contained
  `C108dOddMomentWitness/OddMomentWitness.lean` under a nested
  `*_aristotle` folder, but `integrate_completed.py` reported no candidates.

Impact:

- Integration required direct archive inspection even though the Lean payload was
  present.

Mitigation:

- Located the file manually with `Get-ChildItem` under
  `AgentTasks/aristotle-output/00918b10-3d0f-415e-a012-1059581f1f48`.
- Preserved the returned source in the standalone task area.

Follow-up:

- Candidate discovery should inspect nested `*_aristotle` folders and not rely
  only on expected target paths.
