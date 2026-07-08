# Aristotle audit job - K1 anti-regression next target 2026-07-07 23:12 PDT

```yaml
aristotle:
  project_id: c9bce7a2-8f25-4d56-85ec-744206e3e4ea
  task_id: d1738c9f-03d3-4369-a54a-d6327a54d579
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
  submission_project: none
  output_dir: AgentTasks/aristotle-output/c9bce7a2-8f25-4d56-85ec-744206e3e4ea-extracted/d1738c9f-03d3-4369-a54a-d6327a54d579_aristotle
  status: harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K1_ANTIREGRESSION_NEXT_2026-07-07_2312.md)
```

## Prompt

You are Aristotle, asked for a focused K1 next-target audit, not a full proof
attempt.

Context: two K1 audits now agree that the root-pinned flat-word encoder cannot
carry the full `m_j!` factor when `m_j` is total child-block size. The most
economical next Lean step appears to be an anti-regression fixture plus the
free-slot theorem-shape handoff.

Current Codex evidence:

```text
Live scaffold:
- `childBlockOf T r j` is a deleted-root block.
- `sum_childBlockOf_card` sums child-block cards to `n - 1`.
- `perPair_absWeight_bound` uses `Nat.factorial (childBlockOf T r j).card`.
- `fiber_card_mul_le_factorial` is a generic reducer from an injection into
  `Perm (Fin n)`.

Oracle:
- n=3, root=0, root_child=1, block=(1,2).
- pinned-word encoder image count = 1 for two total-block permutations.
- structured ordered-block codomain image count = 2.
```

Latest Aristotle verdict:

```text
Do both routes in sequence. First land the sound free-slot `(m_j - 1)!`
replacement; pursue the structured ordered-block route only if the downstream KP
bound needs the full factor. Keep `fiber_card_mul_le_factorial` unchanged.
Add the n=3 toy case as anti-regression.
```

Request:

1. Give the smallest Lean anti-regression artifact shape that should be added
   before another K1 proof attempt. Should it be a Python oracle only, a Lean
   decidable theorem, or both?
2. If it should be Lean, suggest concrete declaration names and statement
   shapes for the negative pinned-word collision and positive structured-word
   two-image check.
3. Give the cleanest free-slot theorem/handoff statement that can be placed in
   a draft file without touching the old generic reducer.
4. Identify what would count as overclaim in the K1 scorecard after this
   anti-regression step.
5. Recommend whether Codex should attempt this locally now or package it for a
   proof-focused Aristotle job.

Return concise sections: verdict, declarations, free-slot target, overclaim
guard, local-vs-Aristotle.

## Harvested result

Status: complete; downloaded to the `output_dir` above. Main file:
`K1_ANTIREGRESSION_AUDIT.md`.

Verdict:

- Land both toy anti-regression checks, but make the Lean decidable theorem the
  authoritative artifact; the Python n=3 oracle is only a scratch cross-check.
- Add concrete `Fin 3` fixture declarations for the negative pinned-word
  collapse and the positive structured-word separation:
  `toyTotalBlockPerms_card`, `pinnedWord_collapses_toy`
  (optionally `pinnedWord_not_injective_toy`), and
  `structuredWord_separates_toy`.
- Put the sound `(m_j - 1)!` bound in a new draft file that imports the generic
  reducer read-only; do not touch `fiber_card_mul_le_factorial`.
- Add a graceful old-shape corollary bounded by `m_j!` only after proving the
  free-slot `(m_j - 1)!` theorem.
- Overclaim guard: fixture means "regression prevented", not "K1 closed";
  structured `m_j!` is not verified for all `n`; the free-slot route closes K1
  only if the downstream KP bound survives with `(m_j - 1)!`.
- Recommended sequence: Codex lands the decidable toy fixtures locally, then
  packages the free-slot theorem for a proof-focused Aristotle job.
