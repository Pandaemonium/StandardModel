# Start here

This directory controls the 24-hour publication run ending at 09:45 PDT on
2026-07-12.

## Read

1. `RUN_PLAN.md`
2. your executor prompt
3. the prior run's final `MORNING_REPORT.md`
4. `PAPER_GATE_MATRIX.md`
5. `ARISTOTLE_QUEUE.md`
6. the latest entries in `LEDGER.md`
7. `JORDAN_CLIFFORD_BRIDGE_PROGRAM.md` before claiming the exceptional
   Jordan/Furey lane

## First commands

```powershell
aristotle list --limit 40
git status --short
lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard
python Scripts/publication/verify_null_edge_paper_a.py --output-dir artifact/paper-a-verification-24h-start-20260711
```

The startup verifier is a baseline, not a release artifact. Do not overwrite
the prior run's final verification directory.

## Coordination

- Append claims, handoffs, results, corrections, and blockers to `LEDGER.md`.
- Do not rewrite old ledger entries.
- Record file/section ownership before editing.
- Harvest before submitting duplicates.
- Prefix new jobs `codex-24h-` or `fable-24h-`.

## Final commands

```powershell
lake build PhysicsSM.Draft.NullEdge.OvernightTheoryAxiomGuard
python Scripts/publication/verify_null_edge_paper_a.py --output-dir artifact/paper-a-verification-final-20260712
python Scripts/publication/verify_null_edge_paper_a.py --output-dir artifact/paper-a-verification-final-20260712
git diff --check
pre-commit run --all-files
```

Record the final module count, guard job count, fixture hashes, deterministic
summary hash, dirty/clean state, and every trust exception in
`FINAL_REPORT.md`.
