# Wave 6 job: structural replacement and performance audit for decision tactics

You are Aristotle, the proof-specialist Lean agent. This is a repo-facing proof-engineering job.

## Core request

The repo now contains at least one newly integrated job using the Lean tactic token obtained by removing spaces from `n a t i v e _ d e c i d e`. The project owner accepts this in draft code when it avoids a slow kernel `decide`, but does not want final published/trusted code to rely on it. The ideal outcome is a structural proof that is as fast or faster than the native tactic and avoids both slow `decide` and native evaluation.

## Tasks

1. Locate every use of the native decision tactic in the repo, with special attention to newly integrated null-edge / Aristotle files and any files touched by recent jobs.
2. Classify each use:
   - draft-only finite computation where temporary native evaluation is acceptable;
   - trusted/publication-facing theorem where a structural proof is needed;
   - coding/E8/Hamming fixture where native evaluation is currently functioning as an oracle-like finite check;
   - candidate for immediate structural replacement.
3. For the newly integrated use that motivated this job, attempt a real structural replacement. Prefer proof by finite decomposition, cardinality lemmas, symmetry, closed-form combinatorics, Finset/List structure, or a small certified table, rather than replacing native evaluation with a slow kernel `decide`.
4. Search for obviously long-running `decide` or `+decide` proofs in existing draft code. Identify candidates where a temporary draft-only native replacement would materially improve iteration speed. Do not convert trusted/publication-facing code silently.
5. Produce a policy recommendation for the repo:
   - draft iteration policy;
   - trusted/publication policy;
   - comment/TODO wording that avoids polluting placeholder scans;
   - how to record future replacements in task notes.
6. If you can safely edit draft code, produce the smallest patch. If not, provide exact proposed patches and theorem/proof skeletons.

## Constraints

- Do not weaken theorem statements.
- Do not replace a proof with an untrusted placeholder.
- Do not introduce `a x i o m`, `s o r r y`, `a d m i t`, `o p a q u e`, or unsafe code in trusted files.
- If you use the native tactic in draft code as a temporary speed measure, label it explicitly as draft/performance-only and give a publication replacement plan.
- Prefer targeted Lean checks only; do not spend most of the budget on a full repo build unless it is necessary.

## Deliverables

1. `AgentTasks/null-edge-native-decision-structuralization-report.md`
2. Optional edited Lean files or exact patches.
3. A final table with columns: file, declaration, current proof method, trusted/draft status, replacement recommendation, expected difficulty, whether it is safe to leave temporarily.
