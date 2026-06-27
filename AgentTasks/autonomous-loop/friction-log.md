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
