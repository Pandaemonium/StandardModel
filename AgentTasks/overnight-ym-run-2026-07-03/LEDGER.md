# Ledger: overnight YM run 2026-07-03

Single source of truth for claims, Aristotle registry, and heartbeats.
Protocol in `RUN_PLAN.md`; per-task directions in `TASK_DIRECTIONS.md`.

## Task board

Status values: `open`, `claimed-claude`, `claimed-codex`, `blocked`,
`done`. Add file globs when claiming. One active task per agent.

| Task | Lane | Status | Owner | File globs | Notes |
|---|---|---|---|---|---|
| T0 | Preflight + baseline commit + harvest | open | - | (repo-wide, short-lived) | Baseline commit FIRST; registry reconcile; re-verify oracle 36/36 + Neo4j up (PREP_NOTES s4) |
| T1 | YM3 flagship: charpos -> RP-LINK | open | - | `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean` (scaffolded), `CharacterPositivity.lean` etc. | design:ym3-unitarity (one round); Route B scaffold has 3 handoffs ready |
| T2 | YM1: 2D exact solutions | open | - | `PhysicsSM/Draft/NullEdge/GateYM/Torus*.lean` | ORACLE-TODO-1 done; fusion in CONVOLUTION form; even-cover shared with T5 |
| T3 | YM0 breadth: general-G core + D12 | open | - | `PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean`, `TransferGapDefinition.lean` | Definitional layer needs early cross-review |
| T4 | QCD1 Banks-Casher shadow | open | - | `PhysicsSM/Draft/NullEdge/GateYM/BanksCasher*.lean` | Built on GateC2 spectral assets |
| T5 | YM4 groundwork: KP + polymers | open | - | `PhysicsSM/Draft/NullEdge/GateYM/PolymerKP*.lean` | KP hypotheses BLOCKED on LIT item 3 |
| T6 | YM-LIT verification sprint | open | - | `LIT_LOG.md`, graph/Zotero | Items 1, 3, 8 are load-bearing |
| T7 | Aristotle partner jobs | open | - | `AgentTasks/aristotle-prompts/overnight-ym*.prompt.md` | Red-team after T1 statements exist |
| T8 | Morning report | open | - | `MORNING_REPORT.md` | From 07:00 |

## Aristotle registry

Seeded by the planning session from `aristotle list` (2026-07-03
evening). Reconcile at T0; every new submission/poll/integration gets a
row. Project id is the canonical locator.

| Project id | Name | Rung / freeze section | Status | Owner | Notes |
|---|---|---|---|---|---|
| 203fd831 | gate-c2-flux2d-witness (resubmission) | Gate C2 (not YM) | RUNNING at planning time | - | Poll; harvest on completion; do NOT duplicate |
| a6ebbbf7 | gate-c2-flux2d-witness (first) | Gate C2 (not YM) | IDLE | - | Check prior ledger: likely superseded by 203fd831 |
| f501f8c8 | ym1-elitzur-core-20260703 | YM1 / freeze s3, s13 | IDLE - HARVESTED + INTEGRATED | - | Retired as done (ElitzurCore.lean); no action |
| (backlog) | ~20 IDLE audit/C2 projects | various | IDLE | - | Reconcile against overnight-nerd-run-2026-07-02/LEDGER.md; mark retired rather than re-inspect |

Planned submissions (fill id on submit; cross-review BEFORE submit):

| Package | Rung / freeze section | Targets (short) | Status |
|---|---|---|---|
| ym3-charpos-rp-20260703 | YM3 / s5-s6 | Theorem 3 coefficient extraction; Cor 3a converse; RP-LINK factorization | not submitted |
| ym1-torus-evencover-20260703 | YM1 / s4 | even-cover lemma; Theorem 2' assembly | not submitted |
| ym1-fusion-2dexact-20260703 | YM1 / s4 | Lemma 2a fusion (convolution form); Lemma 2b tree gauge; Theorem 2 | not submitted (unblocked; oracle v0.2 s[9] pins conventions) |
| qcd1-banks-casher-20260703 | QCD1 / s8 | QCD1-i identity; chiral pairing; QCD1-ii sandwich | not submitted |
| ym4-kp-polymer-20260703 | YM4 / s7 | KP criterion; polymer representation | not submitted (LIT item 3 first; capacity-gated) |
| overnight-ym3-semantic-redteam | partner job | red-team report | prompt DRAFTED (template; fill `<<PASTE>>` slots after T1 statements) |
| overnight-ym-ladder-strategy | partner job | strategy report | prompt DRAFTED (fill TONIGHT-STATE block; can submit early) |

## Heartbeat log

Format: `HH:MM agent task next-step` - one line per cycle, append only.

```text
(planning session seeded this file; first heartbeat is T0's)
```

## Parked for user

(unresolved disagreements land here with both positions stated)

## Integration debt

(harvested but not integrated, with reasons - feeds morning report s4)
