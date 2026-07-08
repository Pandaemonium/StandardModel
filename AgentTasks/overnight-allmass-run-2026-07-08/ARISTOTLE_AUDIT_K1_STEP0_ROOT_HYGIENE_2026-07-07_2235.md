# Aristotle audit job - K1 STEP0 root hygiene 2026-07-07 22:35 PDT

```yaml
aristotle:
  project_id: 0b59874b-2ecd-40e6-bfd6-866e334a6241
  task_id: 31150b59-f6c6-49e9-a5a1-6f32e81dd020
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
  submission_project: none
  output_dir: AgentTasks/aristotle-output/0b59874b-2ecd-40e6-bfd6-866e334a6241
  status: harvested
```

Submitted with:

```powershell
aristotle submit (Get-Content -Raw ARISTOTLE_AUDIT_K1_STEP0_ROOT_HYGIENE_2026-07-07_2235.md)
```

Initial status check:

```text
Project 0b59874b-2ecd-40e6-bfd6-866e334a6241 running; task 31150b59-f6c6-49e9-a5a1-6f32e81dd020 queued at first poll.
```

## Harvested result

Status: complete. Aristotle noted the submitted project did not include
`PolymerKPConclusion.lean`, so it treated this as a combinatorial
strategy/no-go audit and sanity-checked the arithmetic in Lean.

Key findings:

- The off-by-root diagnosis is plausible; the failure mode is encoder
  non-injectivity, not raw size of the inequality.
- Minimal decisive toy case: one child block of total size `m_1 = 2`, with
  `n = 3`; pinning the connection slot collapses the two `Perm (Fin 2)`
  inputs to the same word image.
- The original product of `m_j!` factors is valid only if `m_j` counts free,
  non-pinned slots, not total child-block size.
- If `m_j` counts total child-block size and the connection slot is pinned, the
  least disruptive replacement is the injection with factors
  `(m_j - 1)!`.
- A structured-block codomain remains the viable route for preserving the full
  `m_j!` factor.

## Prompt

You are Aristotle, asked for a focused strategy/no-go audit, not a full Lean
proof attempt.

Context: the null-edge run has a hard rule that K1 must run STEP0 before any
new attempt to prove the KP fixed-forest injection in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.

Existing situation:

- The old target is the fixed-forest fiber-count step feeding
  `fiber_card_mul_le_factorial`.
- Existing infrastructure includes canonical root selection, root-child
  blocks, restricted child clusters, `root_child_forest_wf`,
  `fiber_value_bound`, and the abstract reducer
  `fiber_card_mul_le_factorial`.
- Earlier attempts tried to use an injection:
  `Fib x Perm(Fin k) x (forall j, Perm(Fin (m j))) -> Perm(Fin n)`.
- SevenChallenges diagnosis: if the encoder outputs the canonical root first
  and `m j` is total child-block size including the root-connection slot, then
  allowing all `m_j!` internal block permutations is suspect. The canonical
  root/connection slot may be pinned, leaving only `(m_j - 1)!` free-slot
  permutations. That would explain repeated failed attempts.

Request:

Give a verdict-first audit memo answering:

1. Is the off-by-root diagnosis mathematically plausible, and in what exact
   finite toy example should Codex test it first?
2. What are the minimal hypotheses under which the original
   `#Fib * k! * prod_j (m_j!) <= n!` statement is valid?
3. What are the corrected alternatives if `m_j` counts total block size:
   free-slot factorials, a stronger encoder, or a different target
   classification?
4. What should Codex inspect in `fiber_card_mul_le_factorial`,
   `root_child_forest_wf`, and the child-block declarations to decide whether
   `m_j` means total block size or free non-root slots?
5. If the original statement is false under the current semantics, give the
   cleanest no-go statement and the least disruptive replacement theorem shape.

Return a concise memo. Do not propose weakening `pairSum_le_expBound` directly.
Do not use placeholder proofs or new assumptions. This is an audit/strategy job.
