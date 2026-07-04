# Four-day YM run: ledger (single source of truth)

Rules: claim before touching files; one active task per agent; heartbeat
every 30-45 min; stale claim (no heartbeat 3 h) may be taken over after a
DISCUSSION note. Task ids map to `TASK_DIRECTIONS.md` and program-doc
section 14 (Q-items).

## Task board

| task | queue | status | owner | file globs | notes |
|------|-------|--------|-------|-----------|-------|
| T0 preflight | - | done-claude | claude | (read-only + this dir) | day 1 first cycle; git clean at 6a235b9; oracle/build pending final check |
| T1 Wilson cut factorization | Q1 | claimed-claude | claude | PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity*.lean, ReflectionDouble.lean | flagship; substrate (ReflectionDouble) committed cc9c316; full Wilson instantiation open, plan in design:q1-reflection-orientation |
| T2 transfer Hilbert space | Q2 | open | - | PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert*.lean | design thread first |
| T3 D12 sector decomposition | Q3 | claimed-codex | codex | PhysicsSM/Draft/NullEdge/GateYM/FluxSector*.lean, AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md | design thread first; baseline Z2-torus flux/local split |
| T4 harvest unitarizability | Q4 | done-claude | claude | PhysicsSM/Draft/NullEdge/GateYM/FDRepUnitarizable.lean, WilsonVacuumDominance.lean | d4a9bd1f harvested + integrated; unconditional corollaries added |
| T5 eigenvalue reality/ordering | Q5 | open | - | PhysicsSM/Draft/NullEdge/GateYM/FusionTransferSpectrum.lean (extend) | after T4; T4 now done, ready to claim |
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
| d4a9bd1f | ym-gap-unitarizability | Q4 | COMPLETE+HARVESTED+INTEGRATED | closed | task 955405d9; integrated as FDRepUnitarizable.lean; see task note for full harvest record |
| 1d9b5b19 | ym1-treegauge-rect | Q-done | COMPLETE+INTEGRATED | closed | RectTreeGauge.lean |
| 3435c7a3 | ym1-fusion-2dexact v2 | done | COMPLETE+INTEGRATED | closed | historical |
| bf525f23 / 8c4d10be | (non-YM audits) | - | not ours | - | do not touch |

## Parked for user

(none yet)

## Heartbeat log (append-only: `<day>.<HH:MM> <agent> <task> <next-step>`)

1.09:00 claude T0 git status clean at 6a235b9; aristotle list shows d4a9bd1f IDLE (COMPLETE) -> harvesting per T4 before continuing T0 checks; next: oracle + aggregate build
1.09:20 claude T4 d4a9bd1f harvested: statement byte-identical to skeleton (no Simple R added, literal unitarity eq, Matrix.trace conclusion preserved), local lake env lean clean, axioms [propext, Classical.choice, Quot.sound] on all 4 declarations; integrated as GateYM/FDRepUnitarizable.lean, added norm_wilsonNormalizedGamma_le_one' + wilsonStringTension_nonneg' (unconditional) to WilsonVacuumDominance.lean, wired into aggregator; aggregate GateYM build green (8061 jobs); next: T0 remaining checks (oracle, full lake build), then commit, then claim T1
1.09:03 codex T3 claimed D12 sector lane after independent T0 spot-checks (oracle 36/36, aggregate GateYM build green, d4a9bd1f COMPLETE); next resolve design:q3-flux-sector and add baseline Z2-torus flux/local definitions in FluxSector*.lean
1.09:07 codex T3 added FluxSectorZ2.lean: Z2 winding-flux labels, D12 trivial-flux sector bridge, abstract quantum-number preservation lemmas, and distinct fluxGap/localGlueballGap wrappers; lake env lean file+aggregator, module build, aggregate GateYM build green (8062 jobs); axiom audit: preservation lemmas axiom-free, gap lemmas standard [propext, Classical.choice, Quot.sound]; next: pre-commit and commit, then extend toward concrete winding-cycle labels
1.09:25 claude T1 claimed Wilson cut factorization (Q1, flagship); reviewing ReflectionCutExample/ReflectionCore/WilsonReflectionCompatibility to design the mirror-coordinate equiv before writing Lean; next: produce the LinkField ~ (A->G) x (C->G) x (A->G) split
1.09:11 codex T3 extended FluxSectorZ2 with concrete Z2 torus link fields, XOR products along base horizontal/vertical cycles, `windingLabel`, `HasTrivialWinding`, and nontrivial-flux exclusion lemmas; file/module/aggregator checks and aggregate GateYM build green; axiom audit for concrete winding lemmas [propext]; next pre-commit/full build/commit, then consider gauge invariance of winding labels
1.09:18 codex T3 added link-factor preservation core: pointwise XOR parity lemma plus `applyLinkFactor` and proof that zero-parity link factors on both base cycles preserve `windingLabel`; file/module/aggregator and aggregate GateYM checks green after building Claude's ReflectionDouble import; axiom footprint [propext, Quot.sound]; next pre-commit/full build/commit, then instantiate factors from vertex-gauge coboundaries or plaquette flips
1.10:15 claude T1 attempted concrete instantiation via RectTreeGauge coordinate reflection; found and verified (direct Fin computation) a genuine construction failure: uniform-orientation reflection of a 2D lattice through either axis violates ReflectionCore.Reflection's endpoint-swap axioms for transverse edges. Derived + built the fix: ReflectionDouble.lean (doubled lattice, reversed orientation on negative copy, canonical Reflection with no cut links, mirror-coordinate equiv LinkField ~ L0.LinkField x L0.LinkField). Verified lake env lean clean, axioms [propext]/[Quot.sound] (smaller than standard). Committed cc9c316 with full design writeup in DISCUSSION.md design:q1-reflection-orientation. Full Wilson (gauge-invariant, plaquette-based) instantiation NOT closed this cycle - naive per-side plaquette lift does not give the same-h factorized shape; concrete route through PlaquetteReflection.mirrorPlaquette + WilsonReflectionCompatibility.rhoOppositeInv recorded precisely. Explicitly rejected a per-link toy-weight shortcut as not gauge-invariant / not real Wilson RP-LINK. Aggregate GateYM build green (8063 jobs). Next: thread mirrorPlaquette+rhoOppositeInv through doubleLattice to close T1 baseline tier.
