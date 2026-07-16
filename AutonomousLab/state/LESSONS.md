# Persistent lessons

## Bootstrap lessons inherited from prior runs

- Harvest remote proof output before launching duplicate jobs.
- A kernel proof does not establish semantic alignment.
- Full-repository Aristotle packages can spend the budget on builds; isolate
  proof-only targets.
- Every existential needs a nondegenerate witness and a degenerate control.
- Changing-lattice limits must specify sampling/interpolation and ultraviolet
  tails; fixed-momentum convergence is not a PDE theorem.
- Role diversity without cross-model independence can create theatrical
  debate rather than real error correction.
- External authentication, permissions, and dirty-tree state must be recorded
  as operational facts, not rediscovered each session.

## 2026-07-12 additions (claude red-team of the bootstrap)

- Fresh-context hostile review is the highest-leverage audit tool on record:
  the 3/10 external-style review of the Lambda paper directly produced T1,
  the decisive theorem of the 2026-07-12 run. In-context skeptics share the
  builder's framing; give reviewers only the manuscript and artifact.
- Never poll external jobs in a blocking sleep loop; check inline between
  units of real work and record saturation honestly.
- Hand-written ledger timestamps drift from wall clock (observed twice: the
  07-12 run ledger ran ~10 minutes ahead; the AFPL bootstrap ledger entries
  were stamped up to 40 minutes ahead). Append through `labctl.py log`, which
  stamps from the system clock.
- Two agents editing one state file concurrently lose updates ("modified
  since read" collisions in the 07-12 run). Respect the single-writer
  convention in `AutonomousLab/AGENTS.md`.
- Write the session handoff when context is at risk (before compaction), not
  only at session end; a handoff reconstructed from memory is fiction.
- Before handing a target to Aristotle, check whether an already-proven
  in-repo theorem is structurally parallel: DYN-MODULAR-001 was self-proved
  kernel-clean in one session by reusing the `ModularSelection.equipartition_generator`
  diagonal-extraction pattern and the `PlueckerPairGenerator.Uop` closed form,
  spending zero Aristotle budget. "Prepare a clean statement for Aristotle" and
  "land it yourself" are the same first step; do the cheap parallel-pattern
  check before assuming a proof is hard.
- The cross-family gate earns its keep on prose, not kernels. DYN-MODULAR-001's
  Lean proofs were correct, but the cross-family (Codex) review caught four
  real over-reads the builder (claude) missed: calling a non-Hermitian family
  "Hermitian" (complex diagonal), calling non-commuting projectors "conserved
  charges", "modular/Gibbs/max-entropy" language beyond what was composed, and
  a phase witness attached to the supplied evolution rather than the selected
  flow. Same-family self-review would likely have shared the framing blind
  spot. When you build, expect the independent reviewer to find the
  docstring-outruns-kernel gaps; when you review, look there first even when
  the kernel is green. The repair strengthened the result (added the genuine
  Gibbs composition + Hermiticity + a noncommutation control).
- Literature ingestion must be idempotent across partial commits, not only
  successful runs. On 2026-07-12 Zotero accepted `1909.06070`, but the parent
  process decoded the MCP response with the wrong Windows encoding and crashed
  before the Neo4j write. The repair forces UTF-8 in the child process and
  searches Zotero by normalized arXiv identity before creating an item, so a
  retry reuses the canonical key instead of minting a duplicate. Keep the
  Zotero write and Neo4j write as a recoverable two-phase operation.
