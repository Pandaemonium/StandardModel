# Four-day YM run: ledger (single source of truth)

Rules: claim before touching files; one active task per agent; heartbeat
every 30-45 min; stale claim (no heartbeat 3 h) may be taken over after a
DISCUSSION note. Task ids map to `TASK_DIRECTIONS.md` and program-doc
section 14 (Q-items).

## Task board

| task | queue | status | owner | file globs | notes |
|------|-------|--------|-------|-----------|-------|
| T0 preflight | - | open | - | (read-only + this dir) | day 1 first cycle |
| T1 Wilson cut factorization | Q1 | open | - | PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity*.lean | flagship; after T0 |
| T2 transfer Hilbert space | Q2 | open | - | PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert*.lean | design thread first |
| T3 D12 sector decomposition | Q3 | open | - | PhysicsSM/Draft/NullEdge/GateYM/FluxSector*.lean | design thread first |
| T4 harvest unitarizability | Q4 | open | - | PhysicsSM/Draft/NullEdge/GateYM/FDRepUnitarizable.lean, WilsonVacuumDominance.lean | d4a9bd1f; harvest-first |
| T5 eigenvalue reality/ordering | Q5 | open | - | PhysicsSM/Draft/NullEdge/GateYM/FusionTransferSpectrum.lean (extend) | after T4 |
| T6 KP finite conclusion | Q6 | open | - | PhysicsSM/Draft/NullEdge/GateYM/PolymerKP*.lean | strategy job first |
| T7 strong-coupling polymer map | Q7 | open | - | PhysicsSM/Draft/NullEdge/GateYM/StrongCouplingPolymer*.lean | statement layer |
| T8 exponential clustering | Q8 | open | - | (after T6/T7) | gated |
| T9 cyclicity prerequisite | Q9 | open | - | (statement file only) | stretch |
| T10 infinite-volume statement | Q10 | open | - | (statement file only) | stretch, day 4 |
| T11 lasso identification | Q11 | open | - | PhysicsSM/Draft/NullEdge/GateYM/RectBoundary*.lean + standalone pkg | ordering pre-derived |
| T12 YM-LIT | - | open | - | AgentTasks/fourday-ym-run-2026-07-05/LIT_LOG.md | standing lane |
| T13 paper-unit outlines | - | open | - | AgentTasks/paper-units/*.md | day-end lane |
| T14 oracle fixtures v0.3 | - | open | - | Scripts/oracle/validate_lgt_core.py | support lane |
| T15 daily/final reports | - | open | - | AgentTasks/fourday-ym-run-2026-07-05/DAY_*.md, FINAL_REPORT.md | alternate drafters |

## Aristotle registry

| project id | name | rung | status | owner | notes |
|-----------|------|------|--------|-------|-------|
| d4a9bd1f | ym-gap-unitarizability | Q4 | RUNNING (at planning) | unclaimed | harvest checklist in task note 2026-07-04 |
| 1d9b5b19 | ym1-treegauge-rect | Q-done | COMPLETE+INTEGRATED | closed | RectTreeGauge.lean |
| 3435c7a3 | ym1-fusion-2dexact v2 | done | COMPLETE+INTEGRATED | closed | historical |
| bf525f23 / 8c4d10be | (non-YM audits) | - | not ours | - | do not touch |

## Parked for user

(none yet)

## Heartbeat log (append-only: `<day>.<HH:MM> <agent> <task> <next-step>`)
