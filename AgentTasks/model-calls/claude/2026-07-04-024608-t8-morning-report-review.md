# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-04T02:44:39`
- Finished: `2026-07-04T02:46:08`
- Timeout seconds: `600`
- Max budget USD: `1.00`
- Return code: `0`

## Command

```text
claude -p --bare --model opus --max-budget-usd 1.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write Bash' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are reviewing the overnight YM run morning report for a Lean 4 mathematical physics repo. Context: the report is a coordination artifact, not a paper. Please review for correctness and useful morning handoff.

Review tasks:
1. Check that MORNING_REPORT.md satisfies the nine-section RUN_PLAN spec.
2. Look for overclaims: RP-LINK, mass gap, continuum theory, trusted promotion, theorem-2 closure, or Aristotle completion claims not justified by the report/ledger.
3. Look for missing high-value facts that the user would need for next-day promotion decisions.
4. Check consistency against LEDGER.md and DISCUSSION.md where possible.
5. Return concise findings ordered by severity. If no blockers, say so clearly. For each finding, include the exact file/section and a concrete edit suggestion.

Do not rewrite the whole report. Do not ask for more context. The source files are embedded below by the wrapper.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### AgentTasks/overnight-ym-run-2026-07-03/MORNING_REPORT.md (114 lines)

```markdown
# Morning report: overnight YM run 2026-07-03

## 1. Executive summary

- GateYM went from scattered YM scaffolds to a coherent finite-group lattice ensemble stack, with Wilson local weights, reflection scaffolding, D12 gap vocabulary, and full-repo `lake build` green.
- YM3 Route B closed the Wilson kernel PSD engine; RP-LINK proper was deliberately not claimed, because the lattice cut/factorization/PSD assembly is still real work.
- YM1 closed the Z2 rectangular-loop Theorem 2' combinatorial formula and submitted the finite-group Lemma 2a character-fusion step to Aristotle after catching and fixing a normalization bug.
- Literature sprint verified the standing register, found two important novelty/claim-language constraints, and unblocked the KP statement freeze.
- No trusted promotion happened; all new Lean is draft GateYM code, with explicit remaining gaps and no hidden `s o r r y` in the project modules.

## 2. Theorems landed

Verification shorthand: every module below was covered by targeted `lake env lean` / `lake build PhysicsSM.Draft.NullEdge.GateYM...` checks recorded in `LEDGER.md`, repeated aggregate GateYM builds, final `lake build` (8295 jobs), and `pre-commit run --all-files`. Axiom footprints below are the audited footprints recorded during the run.

### YM3 PSD and transfer atoms

- `wilsonKernel_posSemidef`, `reCharGram_posSemidef`, `hadamard_posSemidef`, `hadamard_pow_posSemidef` in `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean`.
  Verification: `lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity`, aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `transferMatrix_posSemidef`, `compression_posSemidef`, `singleLinkWilsonKernel_diagCongruence_posSemidef` in `TransferPositivity.lean`.
  Verification: targeted module build, aggregate GateYM build; Aristotle red-team led to the rename/re-scope in `9c4b4d2`. Axioms: `[propext, Classical.choice, Quot.sound]`.

### YM1 2D exact-solution core

- `eq_empty_or_univ_of_zero_boundary_bits`, `eq_or_compl_of_sameBoundary`, `sum_zeroBoundary_weights`, `sum_sameBoundary_weights`, `ratio_sameBoundary_zeroBoundary_weights`, `rectInside_card`, `ratio_rectInside` in `TorusEvenCover.lean`.
  Verification: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/TorusEvenCover.lean`, aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `convLeft`, `iterConv`, `iterConv_eigen`, `iterConv_eigen_at_one` in `FusionConvolution.lean`.
  Verification: targeted file/module checks and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- Lemma 2a finite-group character fusion is not landed in the repo. Corrected standalone statement parses with the expected proof placeholder; Aristotle project `3435c7a3` is running.

### YM0/T3 finite-group lattice and reflection stack

- `stepHol_gauge`, `hol_gauge`, `classFunction_hol_gauge_closed`, `gaugeEquiv`, `sum_comp_gauge`, `Walk.append`, `Walk.reverse`, `hol_append`, `hol_reverse` in `GaugeCoreGeneral.lean`.
  Verification: targeted file/module checks and aggregate GateYM builds. Axioms: standard project footprint where audited.
- `Plaquette.hol_gauge`, `Plaquette.classFunction_hol_gauge`, `actionSum_gauge`, `productWeight_gauge` in `PlaquetteCore.lean`.
  Verification: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean`, aggregate GateYM build. Axioms: standard project footprint.
- `partition`, `numerator`, `expectation`, positivity, gauge-change-of-variables, and `gaugeOrbitAverageObservable` numerator equality in `LatticeEnsemble.lean`.
  Verification: targeted/module/aggregate checks. Axioms: standard project footprint.
- `PlaquetteEnsemble.lean` and `WilsonLocalWeight.lean`: finite product-plaquette partition/numerator/expectation, positive local weight -> positive partition, Wilson local weight class-function invariance, Wilson partition positivity.
  Verification: targeted checks and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `TransferGapDefinition.lean`: D12 shell separating Gauss invariance, zero momentum, and trivial 't Hooft flux; finite real spectral-ratio gap with nonnegativity/positivity lemmas.
  Verification: targeted check and aggregate GateYM build.
- `ReflectionCore.lean`, `ReflectionCutExample.lean`, `ReflectionWalk.lean`, `ReflectionEnsemble.lean`, `PlaquetteReflection.lean`: link-reflection structure, two-layer cut sanity model, opposite-group reflected-walk theorem, reflection finite-sum change-of-variables, plaquette holonomy lift, and product-weight reflection bridge.
  Key names: `reflectLinkField_involutive`, `twoLayerCutReflection_cutLink`, `op_hol_reflectLinkField_mirrorWalk`, `reflectLinkFieldEquiv`, `expectation_observable_comp_reflectLinkField_of_weight_invariant`, `op_hol_reflectLinkField_mirrorPlaquette`, `productWeight_reflectLinkField_mirrorPlaquette`.
  Verification: targeted file/module checks, axiom audits, aggregate GateYM build. Axioms: `[propext]` or `[propext, Quot.sound]` for the reflected-step/walk/plaquette/product bridge facts.

### QCD1 and YM4 side lanes

- `Dov_sub_one_unitary`, `gamma5_mul_Dov_isHermitian` in `BanksCasherShadow.lean`.
  Verification: targeted check and aggregate GateYM build. Axioms: `[propext, Classical.choice, Quot.sound]`.
- `PolymerSystem` and `KPCondition` in `PolymerKPCriterion.lean`.
  Verification: targeted check and aggregate GateYM build. This is a statement freeze only; no cluster-expansion conclusion is claimed.

## 3. Aristotle registry final state

- `ac230cc8` `ym-ladder-strategy-20260703`: COMPLETE + HARVESTED. Findings drove sequencing: harden finite results, U(1) Fourier RP before Peter-Weyl, QCD1 before KP/Peter-Weyl, and keep finite-volume/finite-G disclaimers sharp.
- `cb437537` `ym3-semantic-redteam-20260703`: COMPLETE + HARVESTED. Findings integrated in `9c4b4d2`: TransferPositivity was renamed/re-scoped and one inert hypothesis removed.
- `9627f7ea` `ym1-fusion-2dexact-20260704` v1: CANCELED/IDLE after a real normalization bug was found. The v1 theorem had an extra `|G|` factor; trivial representation with `w=1` refutes it.
- `3435c7a3` `ym1-fusion-2dexact-20260704b` v2: RUNNING at last poll. Corrected statement removes the extra factor and preserves the oracle-pinned `h^-1 * A` convolution order.
- `203fd831` `gate-c2-flux2d-witness`: RUNNING at last poll; non-YM Gate C2 carryover, do not duplicate.
- Older visible IDLE projects remain retired/previous-run-ledgered unless the user asks to reopen them.

## 4. Integration debt

- Harvest `3435c7a3`. If it succeeds, integrate Lemma 2a into `FusionConvolution.lean` or a successor file and then assemble finite-G Theorem 2; if it returns a no-go, record the missing character-theory API precisely.
- Harvest `203fd831` when it completes; it is Gate C2, not tonight's YM ladder, but it is still owned by the carryover registry.
- RP-LINK is not assembled. Missing pieces: reflection-stable plaquette family, Wilson local-weight symmetry across `MulOpposite`, cut factorization, positive-side observable algebra, and PSD assembly.
- QCD1-i/ii are not proved. The banked C2/GW-circle facts need a designed `lambda_hat` spectral map and chiral-pairing theorem.
- KP conclusion is not proved. `PolymerKPCriterion.lean` freezes the condition; Ursell/cluster combinatorics and convergence statements are future infrastructure.
- Primary-source Osterwalder-Seiler PDF text was not extracted; LINK-vs-SITE geometry is strongly corroborated by secondary sources but still wants primary-source confirmation before paper claim language.

## 5. Decisions and reviews

- `design:ym3-unitarity`: adopted explicit unitarity hypotheses for Wilson representation facts; unitarizability remains future work.
- `review:t1-routeB`: ACCEPTED with scope note. Route B proves the PSD kernel engine, not the character-coefficient positivity/Bochner chain.
- `review:t2-even-cover-core`: ACCEPTED; follow-up added kernel-checked wraparound redundancy/global constancy lemmas.
- `idea:rp-link-scope`: accepted. RP-LINK proper needs the lattice probability/reflection/cut layer, not just more PSD algebra.
- `review:t3-general-gauge-core`: ACCEPTED; multiplication order and reverse-step convention checked.
- `review:reflection-core-first-pass`: ACCEPTED as finite scaffolding, with claim gate until reflection/source convention and downstream compatibility are checked.
- Reflection walk attempted theorem was rejected: naive nonabelian same-group inverse identity has an order obstruction. Correct formulation uses `MulOpposite`.
- `review:t2-lemma2a-aristotle-submission`: v1 rejected for normalization; corrected v2 submitted as `3435c7a3`.
- `review:t3-plaquette-reflection`: ACCEPTED; then extended with product-weight bridge.
- No disagreements are parked for the user; the main open issues are ordinary integration debt above.

## 6. Build and hygiene status

- `lake build PhysicsSM.Draft.NullEdge.GateYM`: passed repeatedly; final aggregate was 8050 jobs with known unrelated warnings in Elitzur/Transfer/GateC2 files.
- `lake build`: passed after live-tree changes, 8295 jobs. Existing info/linter/deprecation messages appeared outside the new YM changes; no errors.
- `pre-commit run --all-files`: passed before the final commits.
- Baseline checks recorded at T0: GateYM build green, oracle v0.2 `validate_lgt_core.py` 36/36, Neo4j reachable, Aristotle list reconciled.
- Standalone Lemma 2a statement check: `lake env lean AgentTasks/aristotle-standalone/ym1-fusion-2dexact-20260704/Ym1Fusion/Lemma2a.lean` parsed with the expected proof-placeholder warning. The focused submit-package local check failed before typechecking because that ignored package lacked materialized Mathlib `.olean`s; the root-project check is the reliable local parse check.

## 7. Ideas raised but out of scope

- U(1) Fourier RP as the next flagship route before full Peter-Weyl.
- Finite-G RP as a separate publication unit, but only with a sharp finite-volume disclaimer.
- Shared Schur/Hadamard PSD lemmas as future Mathlib upstream candidates.
- Character-basis completeness for class functions over finite groups as the real Mathlib/representation-theory bottleneck for Lemma 2a.
- Site reflection is distinct from link reflection and should not be mixed into the current RP-LINK layer.
- YM6 / continuum mass gap language must be re-audited in light of arXiv:2606.19362 before any summit-facing claims are made.

## 8. Recommended next three actions

1. Poll/harvest `3435c7a3` first. A successful proof is the shortest path to full finite-G YM1 Theorem 2; a no-go will still identify the exact Mathlib character-theory gap.
2. Assemble the next YM3 finite identity, not RP-LINK yet: define a reflection-stable plaquette family and prove Wilson local-weight compatibility across the `MulOpposite` bridge. That is the closest YM3 paper unit after tonight's T3 work.
3. Keep the one-job Aristotle budget rule lifted only for focused Mathlib-only or audit jobs until `3435c7a3` and `203fd831` finish, then restore the rule. The lifted rule paid off, but the v1 Lemma 2a bug showed why cross-review and narrow packages still matter.

## 9. Literature log summary

- Verified/cross-confirmed: Osterwalder-Seiler citation existence, Elitzur 1975, KP/Ueltschi criterion shape, Wegner 1971, Wilson 1974, Banks-Casher 1980, Jaffe-Witten/CMI rules, 2D YM rigorous constructions, Balaban/Magnen-Rivasseau-Seneor scope.
- Novelty check found no prior formalization of lattice gauge theory, Wilson-action gauge invariance, or interacting gauge-theory reflection positivity, but did find important adjacent art: Douglas et al. 2026 Lean formalization of free-field OS/GJ axioms and LeanMillenniumPrizeProblems statement-only work.
- Major caution: arXiv:2606.19362 claims a full SU(N) YM mass-gap/confinement construction. It is not treated as settled prior art, but the user should personally review it before the program's YM6/summit language is touched.
- LINK-vs-SITE reflection geometry: secondary sources strongly confirm link reflection cuts temporal links between time slices, matching `ReflectionCore.lean`'s no-on-plane-vertices design.
- No load-bearing new paper was ingested into Zotero/Neo4j tonight; the Faizal/Shabir paper was intentionally left for user review before ingestion.

```

### AgentTasks/overnight-ym-run-2026-07-03/LEDGER.md (117 lines)

```markdown
# Ledger: overnight YM run 2026-07-03

Single source of truth for claims, Aristotle registry, and heartbeats.
Protocol in `RUN_PLAN.md`; per-task directions in `TASK_DIRECTIONS.md`.

## Task board

Status values: `open`, `claimed-claude`, `claimed-codex`, `blocked`,
`done`. Add file globs when claiming. One active task per agent.

| Task | Lane | Status | Owner | File globs | Notes |
|---|---|---|---|---|---|
| T0 | Preflight + baseline commit + harvest | done | Codex | `AgentTasks/overnight-ym-run-2026-07-03/LEDGER.md`, repo-wide checks only | 00:02 baseline clean enough for lane work: GateYM build green, oracle 36/36, Neo4j reachable; Aristotle list limit 100 reconciled against 2026-07-02 ledger |
| T1 | YM3 flagship: charpos -> RP-LINK | paused-claude | Claude | `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean`, `TransferPositivity.lean` (both CLOSED) | Route B (PSD kernel engine, `fb4df44`) + Cor 3b (`576697d`) CLOSED and cross-reviewed. Route A deprioritized (FDRep API harder than assessed, see freeze s17); RP-LINK proper deferred pending T3 (see `idea:rp-link-scope`). Resume if T3 lands or Route A gets fresh appetite. |
| T2 | YM1: 2D exact solutions | claimed-claude | Claude | `PhysicsSM/Draft/NullEdge/GateYM/Torus*.lean`, `PhysicsSM/Draft/NullEdge/GateYM/Fusion*.lean`, `PhysicsSM/Draft/NullEdge/GateYM.lean`, shared run files | Z2 torus cover-ratio core (Codex) plus theorem 2' fully closed for a genuine rectangular loop (`rectInside`/`ratio_rectInside`, `8bcd861`); abstract finite-group convolution iteration core (Codex, `FusionConvolution.lean`) still needs the character-orthogonality fusion lemma (Lemma 2a) for Theorem 2 proper - real character theory, next target if time allows. |
| T3 | YM0 breadth: general-G core + D12 | claimed-codex | Codex | `PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean`, `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean`, `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteEnsemble.lean`, `PhysicsSM/Draft/NullEdge/GateYM/WilsonLocalWeight.lean`, `PhysicsSM/Draft/NullEdge/GateYM/LatticeEnsemble*.lean`, `PhysicsSM/Draft/NullEdge/GateYM/Reflection*.lean`, `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean`, `PhysicsSM/Draft/NullEdge/GateYM/TransferGapDefinition.lean`, `PhysicsSM/Draft/NullEdge/GateYM.lean`, shared run files | General-G typed-walk/gauge/finite-ensemble stack landed; Wilson local weight plugged in; D12 flux-qualified gap shell landed; reflection/cut core, reflected-walk opposite-group theorem, reflection finite-measure layer, and plaquette/product reflection bridge landed. RP-LINK proper remains open: no reflection-stable Wilson action, cut factorization, or PSD assembly yet. |
| T4 | QCD1 Banks-Casher shadow | paused-claude | Claude | `PhysicsSM/Draft/NullEdge/GateYM/BanksCasherShadow.lean` (structural fact CLOSED, `ace9b36`) | GW-circle unitarity fact banked; QCD1-i/ii proper genuinely need more design (`lambda_hat`, chiral pairing) - see `idea:qcd1-scope`. Resume with fresh design input. |
| T5 | YM4 groundwork: KP + polymers | done-claude | Claude | `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean` (`6659f53`) | Statement freeze landed: abstract polymer system + KP condition as precise Finset inequality; conclusion (cluster expansion) needs new Ursell infrastructure, documented as handoff |
| T6 | YM-LIT verification sprint | done-claude | Claude | `LIT_LOG.md` | ALL 11 standing items verified or substantially advanced; 2 major novelty-check finds (arXiv:2606.19362 flagged with skepticism case, arXiv:2603.15770 genuine adjacent art) |
| T7 | Aristotle partner jobs | done | Claude | `AgentTasks/aristotle-prompts/overnight-ym*.prompt.md` | Both COMPLETE + HARVESTED. Red-team found real naming/scope overreach + one inert hypothesis - fixed in commit `9c4b4d2`. |
| T8 | Morning report | claimed-codex | Codex | `MORNING_REPORT.md` | Draft created; needs cross-review before final stop |

## Aristotle registry

Seeded by the planning session from `aristotle list` (2026-07-03
evening). Reconcile at T0; every new submission/poll/integration gets a
row. Project id is the canonical locator.

| Project id | Name | Rung / freeze section | Status | Owner | Notes |
|---|---|---|---|---|---|
| 203fd831 | gate-c2-flux2d-witness (resubmission) | Gate C2 (not YM) | RUNNING at 05:45 poll | Codex/T0 | Poll; harvest on completion; do NOT duplicate |
| cb437537 | ym3-semantic-redteam-20260703 (T7 partner job) | YM3 chain statement-vs-intent audit | COMPLETE + HARVESTED 03:00 | claude/T7 | Prompt = `AgentTasks/aristotle-prompts/overnight-ym3-semantic-redteam.prompt.md`; findings integrated in `9c4b4d2` (renamed/re-scoped TransferPositivity result; inert hypothesis removed). |
| ac230cc8 | ym-ladder-strategy-20260703 (T7 partner job) | strategy audit, all rungs | COMPLETE + HARVESTED 01:50 | claude/T7 | Report at `AgentTasks/aristotle-output/ym-ladder-strategy-20260703/.../YM_Ladder_Strategy_Audit.md` (gitignored dir). Key findings below. |
| a6ebbbf7 | gate-c2-flux2d-witness (first) | Gate C2 (not YM) | IDLE - RETIRED/SUPERSEDED | Codex/T0 | Superseded by 203fd831 per prior-run ledger context |
| f501f8c8 | ym1-elitzur-core-20260703 | YM1 / freeze s3, s13 | IDLE - HARVESTED + INTEGRATED | - | Retired as done (ElitzurCore.lean); no action |
| 9627f7ea | ym1-fusion-2dexact-20260704 (Lemma 2a, v1 - BUGGY) | YM1 / freeze s4 | CANCELED early (~4 min) - normalization bug found (extra `Fintype.card G` factor on RHS) | claude/T2 | Superseded by `3435c7a3`. Kept for the record: a real self-caught error, not a wasted run - the cancellation likely reflects Aristotle's own sanity-check pass hitting the same bug. |
| 3435c7a3 | ym1-fusion-2dexact-20260704b (Lemma 2a, v2 - corrected) | YM1 / freeze s4 | RUNNING at 05:45 poll | claude/T2 | Standalone Mathlib-only package `AgentTasks/aristotle-submit/ym1-fusion-2dexact-20260704b-project`, statement file `AgentTasks/aristotle-standalone/ym1-fusion-2dexact-20260704/Ym1Fusion/Lemma2a.lean` (fixed `cface21`). Prompt `AgentTasks/aristotle-prompts/overnight-ym1-fusion-2dexact.prompt.md`. Uses the CORRECTED `FDRep`/`Simple` API (freeze s17 item 2), not the nonexistent `Representation.character`. Real open question flagged in-prompt: whether "characters span class functions" exists in this pinned Mathlib. Poll and harvest next cycle. |
| (backlog) | visible IDLE audit/C2/checkerboard projects | various | IDLE - RETIRED/PREVIOUS-RUN LEDGERED | Codex/T0 | `aristotle list --limit 100` checked 00:02; recent C2/I1/checkerboard rows are already harvested, integrated, superseded, or assigned in the 2026-07-02 ledger; no duplicate harvest tonight |

Planned submissions (fill id on submit; cross-review BEFORE submit):

| Package | Rung / freeze section | Targets (short) | Status |
|---|---|---|---|
| ym3-charpos-rp-20260703 | YM3 / s5-s6 | Theorem 3 coefficient extraction; Cor 3a converse; RP-LINK factorization | not submitted |
| ym1-torus-evencover-20260703 | YM1 / s4 | even-cover lemma; Theorem 2' assembly | not submitted |
| ym1-fusion-2dexact-20260703 | YM1 / s4 | Lemma 2a fusion (convolution form); Lemma 2b tree gauge; Theorem 2 | Lemma 2a v1 `9627f7ea` canceled for normalization bug; corrected v2 **RUNNING** as `3435c7a3`; Lemma 2b/Theorem 2 remain not submitted |
| qcd1-banks-casher-20260703 | QCD1 / s8 | QCD1-i identity; chiral pairing; QCD1-ii sandwich | not submitted |
| ym4-kp-polymer-20260703 | YM4 / s7 | KP criterion; polymer representation | not submitted (LIT item 3 first; capacity-gated) |
| overnight-ym3-semantic-redteam | partner job | red-team report | prompt DRAFTED (template; fill `<<PASTE>>` slots after T1 statements) |
| overnight-ym-ladder-strategy | partner job | strategy report | **SUBMITTED 01:15** as project `ac230cc8-2e92-4a88-b0be-63266b9f3d06`; TONIGHT-STATE filled; owner claude, poll next cycle |

## Heartbeat log

Format: `HH:MM agent task next-step` - one line per cycle, append only.

```text
(planning session seeded this file; first heartbeat is T0's)
00:00 Codex T0 started preflight; next run GateYM build, oracle v0.2, Aristotle list, and Neo4j search check.
00:05 Claude claims T1 (YM3 flagship). Resolving design:ym3-unitarity (adopting option 1, planning session's recommendation, no objection posted), then closing the three WilsonWeightPositivity.lean handoffs locally before authoring CharacterPositivity.lean (Route A).
00:06 Codex T0 done: GateYM build green with expected scaffold warnings, oracle v0.2 36/36, Neo4j paper search reachable, Aristotle list reconciled; next claim T2 because Claude owns T1.
00:07 Codex T2 claimed YM1 exact-solutions lane; next inspect GateYM style and draft the torus even-cover statement layer.
00:13 Codex T2 kernel-checked `TorusEvenCover`: locally constant finite-grid plaquette subsets are empty or universal; GateYM build green; next grow toward the even-incidence/boundary layer.
00:35 Claude T1: closed 2/3 scaffold handoffs locally - `rho_inv_eq_conjTranspose`+`reChar_inv_of_unitary` (cancellation bookkeeping) and `reCharGram_posSemidef` (vectorized Gram: flatten rho into A, A*Aᴴ = complex kernel C via `posSemidef_self_mul_conjTranspose`, bridge to the real matrix via `re_dotProduct_nonneg` + `Complex.re_sum`/`re_ofReal_mul`). Only `wilsonKernel_posSemidef` (entrywise-exp/Hadamard tsum bookkeeping) remains; attempting locally next, will package for Aristotle if it resists.
00:36 Codex T2 extended `TorusEvenCover` with Z2 boundary bits and same-boundary/complement theorem; target build green, placeholder scan clean, dependency footprint standard; next rerun aggregate after Claude T1 update and then draft exact-formula statement layer.
00:40 Codex T2 added predicate wrappers `ZeroBoundary`/`SameBoundary` plus iff/API theorems; target build green and aggregate GateYM build green again with only existing draft warnings/sorries.
00:48 Codex T2 added finite cover-sum identities `sum_zeroBoundary_weights` and `sum_sameBoundary_weights`; target build and aggregate GateYM build green, dependency footprint `[propext, Classical.choice, Quot.sound]`; next consider exact torus formula statement or fusion route.
00:52 Codex T2 added capstone ratio theorem `ratio_sameBoundary_zeroBoundary_weights`, matching `(t^A + t^(P-A))/(1+t^P)` at the cover-expansion layer; target and aggregate builds green, placeholder scan clean.
01:05 Claude T1: CLOSED all three `WilsonWeightPositivity.lean` handoffs, no Aristotle job needed. `reCharGram_posSemidef` done as planned (vectorized Gram). `wilsonKernel_posSemidef` done via `Real.summable_pow_div_factorial` + `Summable.tsum_finsetSum` (finite-sum/tsum swap) + `tsum_nonneg`. EN ROUTE discovered a real Mathlib gap: `Matrix.PosSemidef.hadamard` (Schur product theorem) does NOT exist in this repo's pinned Mathlib (commit `8f9d9cf`) despite PREP_NOTES claiming "VERIFIED present" via lean-explore - corrected in PREP_NOTES.md and derived it myself as new lemma `hadamard_posSemidef` (from `kronecker` + `submatrix` along the diagonal embedding, both genuinely present) plus `hadamard_pow_posSemidef` by induction. All kernel-checked, dependency footprint `[propext, Classical.choice, Quot.sound]`, zero `s o r r y`. `lake build PhysicsSM.Draft.NullEdge.GateYM` green (8031 jobs). Committed `fb4df44`. Opening `review:t1-routeB` in DISCUSSION for Codex's convenience (not blocking). Next: Cor 3b (transfer positivity, tensor step) building on `wilsonKernel_posSemidef`, then RP-LINK proper; also submitting the pre-drafted `overnight-ym-ladder-strategy` prompt (T7) since it needs no new statements.
01:08 Codex T2 added `FusionConvolution.lean`: oracle-order convolution operator and `iterConv_eigen`; target and aggregate builds green, placeholder scan clean, dependency footprint `[propext, Classical.choice, Quot.sound]`. Next answer Claude's `review:t1-routeB`.
01:15 Claude T7: submitted `overnight-ym-ladder-strategy` (project `ac230cc8`) via `aristotle submit` with the filled TONIGHT-STATE block; also completed `review:t2-even-cover-core` (ACCEPTED). Resuming T1: drafting `TransferPositivity.lean` (Cor 3b) on top of `wilsonKernel_posSemidef`.
01:25 Claude T1: landed `TransferPositivity.lean` (Cor 3b) - `transferMatrix_posSemidef` (diagonal V^(1/2) conjugation preserves PSD), `compression_posSemidef` (Gauss-projector-shaped compression preserves PSD), `transferPositivity_wilsonKernel_diag` (connects to the Wilson kernel). Both bare citations of `mul_mul_conjTranspose_same`, kept lattice-indexing-agnostic so it doesn't block on T3. `lake build` green (8033 jobs), dependency footprint standard, committed `576697d`. Codex's review noted RP-LINK/Theorem-3-chain still needs Route A - PIVOTING to `CharacterPositivity.lean` (Route A) next rather than starting RP-LINK's full lattice-probability apparatus (config space, action, partition function, reflection, cut structure) solo: that's a large, genuinely-T3-adjacent undertaking better scoped with input first. Route A has a complete Mathlib API map already (freeze s15) and is more bounded.
01:16 Codex review:t1-routeB ACCEPTED with scope note: Route B proves RP kernel PSD, not Route A character-coefficient positivity/Bochner converse; WilsonWeightPositivity build and dependency audit green.
01:24 Codex T2 follow-up to review:t2-even-cover-core: added kernel-checked global-constancy/redundant-wrap lemmas; target and aggregate builds green; shared-note raw-placeholder scan clean.
01:31 Codex T2 added `iterConv_eigen_at_one`, giving the exact `d * gamma^n` factor from the oracle-order convolution eigenstatement; target and aggregate builds green, placeholder scan clean.
01:34 Codex releases T2 partial and claims T3 shared finite-G lattice/probability layer after Claude's `idea:rp-link-scope`; next draft definitional core and open early review.
01:43 Codex T3 added `GaugeCoreGeneral.lean`: oriented links, typed walks, reverse inverse convention, gauge action, `stepHol_gauge`, `hol_gauge`, closed-walk class-function invariance, `gauge_one`, `gauge_comp`; target and aggregate builds green, review thread opened.
01:50 Claude T7: `ac230cc8` COMPLETE fast (~13 min); harvested via `aristotle download` (tar.gz despite `.zip` name). Report agrees with `idea:rp-link-scope`: Route B is "one atom" of RP, not RP itself. KEY FINDINGS: (1) sequencing recommendation - harden tonight's results > U(1) Fourier RP (bypasses Peter-Weyl via Bessel positivity) > Wegner duality > QCD1 > Kotecky-Preiss > Peter-Weyl; (2) flagged risk that a real-only Schur product could be an unnoticed gap for complex reps - checked: not a bug, our chain only ever needs the REAL M kernel, never a complex one; (3) suggested checking `hunit`/`hbeta` aren't vacuously unused via `lean_minimal_hypotheses` - RAN IT: ALL SIX hypotheses of `wilsonKernel_posSemidef` (beta, hbeta, rho, hmul, hone, hunit) are load-bearing, confirmed by the tool; (4) verdict: flagship-first is right only paired with U(1) + explicit finite-volume disclaimer, warns against burning "first RP" novelty on the trivial-without-Lie-group case alone; (5) named literature attributions to verify (Osterwalder-Seiler for lattice RP, Luscher for the self-adjoint transfer matrix/H=-log T - explicitly NOT Osterwalder-Schrader) - feeds T6. Full report saved (gitignored dir, not committed - key findings preserved here per protocol). Given #4/QCD1 ranks above KP/Peter-Weyl and is unclaimed, considering T4 next.
01:52 Codex T3 extended `GaugeCoreGeneral` with `gauge_inv_apply` and `gaugeEquiv`, the finite change-of-variables core; target and aggregate builds green, placeholder scan clean.
01:55 Claude T7: submitted `overnight-ym3-semantic-redteam` as project `cb437537`, prompt filled with verbatim closed T1 source (WilsonWeightPositivity + TransferPositivity), context corrected to state precisely what is/is not proved yet. T7 now fully worked (both partner jobs submitted, one harvested). Claiming T4 (QCD1 Banks-Casher shadow) next - unclaimed, ranks above KP/Peter-Weyl in the strategy report's sequencing, builds on existing GateC2 spectral assets (different file globs from T1/T2/T3, low collision risk).
01:57 Codex T3 added `sum_comp_gauge`, finite change-of-variables under any fixed gauge transformation; target and aggregate builds green, dependency footprint standard.
02:13 Codex T3 added `LatticeEnsemble.lean`: partition, numerator, expectation, strict-positive partition positivity, and gauge change-of-variables for all three; target and aggregate builds green, dependency footprint standard; no Wilson/RP/transfer claim yet.
02:00 Claude T4: landed `BanksCasherShadow.lean` - `Dov_sub_one_unitary` (shifted overlap `Dov-1=gamma5*eps` unitary, both Hermitian involutions) and `gamma5_mul_Dov_isHermitian`, instantiated at the C2 certified sign `epsCFC H`. First-try clean compile, zero `s o r r y`, dependency footprint `[propext, Classical.choice, Quot.sound]`. Committed `ace9b36`. The full QCD1-i/ii identity needs substantially more setup than the task directions suggested (a `lambda_hat` spectral map with a genuine design choice, plus the chiral-pairing lemma the task itself flags as semantically risky) - posted `idea:qcd1-scope`, pausing T4 rather than guessing. Also cross-reviewed `review:t3-general-gauge-core` (ACCEPTED, no bugs - verified gauge formula/reverse-inverse/composition-order by hand). Claiming T6 (YM-LIT) next: unclaimed, zero Lean-collision risk, uses Neo4j (already running) and addresses items surfaced by both the standing register and the strategy-audit harvest.
02:31 Codex T3 added `PlaquetteCore.lean`: abstract plaquette as a typed closed 4-walk, class-function plaquette holonomy invariance, and finite action-sum/product-weight invariance; target build green, aggregate check pending.
02:43 Codex T3 extended `LatticeEnsemble.lean` with generic numerator/expectation invariance for gauge-transformed observables under a fixed gauge-invariant weight; target check green, aggregate/dependency audit pending.
02:55 Codex T3 added `PlaquetteEnsemble.lean`: finite product-plaquette partition/numerator/expectation, positive local weight -> positive partition, and observable gauge invariance under class-function local weights; target check green, aggregate/dependency audit pending.
02:35 Claude T6: verified items 1 (Osterwalder-Seiler), 2 (Elitzur), 4 (Wegner), 5 (Wilson 1974), 6 (Banks-Casher), 7 (Jaffe-Witten + CMI rules) exact citations via web search; cross-confirmed item 3 (Kotecky-Preiss/Ueltschi) against 3 independent secondary restatements matching the freeze's own citation, UNBLOCKING T5. Item 8 (novelty check) substantially advanced with TWO major finds - full detail in LIT_LOG: (a) arXiv:2606.19362 (Faizal/Shabir) informally CLAIMS the full Millennium Prize YM solution, flagged with a detailed skepticism case, NOT treated as settled prior art (also: CMI's own 2-year post-publication rule makes "solved" premature regardless of correctness); (b) arXiv:2603.15770 (Douglas et al.) IS a genuine, community-visible Lean+Mathlib formalization of OS/GJ axioms for the FREE bosonic field - does not preempt this program's lattice-GAUGE-theory RP scope but narrows any future "first ever OS formalization" claim. Also found lean-dojo/LeanMillenniumPrizeProblems (Lean statements only, no proofs, relevant for future YM8 work). All committed (`5aec7a1` findings; freeze/PREP_NOTES corrections earlier at `6e1ff2f`).
03:00 Claude T7: harvested `cb437537` (COMPLETE, ~16 min). Careful, disciplined adversarial audit - no statement found false or vacuous, but a real over-claiming risk in naming/framing (top finding, independently matching Codex's own review scope note) plus a genuinely inert `hv` hypothesis (confirming what I'd already partially suspected). ACTED on both: renamed `transferPositivity_wilsonKernel_diag` -> `singleLinkWilsonKernel_diagCongruence_posSemidef`, rewrote `TransferPositivity.lean`'s docstring to stop implying a lattice transfer matrix exists, removed the inert hypothesis. `lake build` green (8042 jobs), committed `9c4b4d2`. T7 fully done. Next: checking in on Codex's T3 progress (now quite extensive - GaugeCoreGeneral, PlaquetteCore, LatticeEnsemble, PlaquetteEnsemble) to see if RP-LINK's remaining apparatus is close enough to resume T1, otherwise continuing T6's remaining lower-priority items (9/10/11) or starting the morning report groundwork given the substantial night so far.
03:08 Codex T3 added `TransferGapDefinition.lean`: D12 vacuum-sector predicate explicitly separates Gauss invariance, zero momentum, and trivial 't Hooft flux; finite real spectral-ratio gap `-log(lambda1/lambda0)` plus nonnegative/positive lemmas; target check green, aggregate/dependency audit pending.
03:20 Codex T3 repaired and integrated Claude's proposed `WilsonLocalWeight.lean`: Wilson local weight is a class function, Wilson plaquette-product weight/expectation inherit gauge invariance, and Wilson partition is positive; target check green, aggregate/dependency audit pending.
03:20 Claude: thanks Codex for the repair + `wilsonPartition_pos` addition - nice collaborative save (my draft had lint-only issues, now clean). Full `lake build` green (8044 jobs), already committed (`2a13101` picked up the final state). Taking stock: T3's ensemble stack (GaugeCoreGeneral + PlaquetteCore + LatticeEnsemble + PlaquetteEnsemble + TransferGapDefinition + WilsonLocalWeight) is now a real, coherent finite-ensemble apparatus with the ACTUAL Wilson weight pluggable - genuinely good progress, but reflection map `theta`, the positive-side sub-algebra, cut structure, and the tensor-product-of-per-link kernel are all still absent, so RP-LINK proper remains a real design task, not yet a quick assembly. Given that gap needs collaborative design (per `idea:rp-link-scope`) rather than solo continuation, pivoting to T5 (KP groundwork) next: now UNBLOCKED by tonight's T6 lit verification (item 3 cross-confirmed), unclaimed, and ranked above Peter-Weyl in the strategy audit's sequencing. Will do statement-freeze-only per the freeze document's own guidance (full analysis is not a one-night target), sourced from the arXiv rederivation math-ph/0605041 found during T6.
03:30 Claude T5 DONE: `PolymerKPCriterion.lean` - abstract `PolymerSystem` structure (incompatibility relation, weight, nonneg energy) and `KPCondition` as a precise Finset-sum inequality, matching the freeze's own citation and cross-confirmed against 3 independent secondary sources (primary CMP 1986 text unextractable this session). Deliberately did NOT attempt the conclusion (cluster-expansion convergence needs new Ursell/cluster combinatorial infrastructure, absent from Mathlib and genuinely undesigned) - documented as an explicit handoff rather than guessed at, consistent with F-YM-LIT. Explicitly NOT duplicating T2's even-cover machinery (different combinatorial object: torus-specific character expansion vs generic-beta strong coupling). `lake build` green (8045 jobs), committed `6659f53`. T5 is now the freeze deliverable it was meant to be tonight - no further push planned unless someone wants to attempt the cluster-coefficient design.
03:35 Claude posted `design:reflection-cut-layer` in DISCUSSION - a concrete proposed shape for RP-LINK's reflection/positive-side/cut apparatus (abstract `Reflection` structure over `OrientedLattice`), with 3 explicit open questions (on-plane vertices, `A_+` definition, `theta` lifted to link fields) flagged as needing resolution before any statement freeze, given how much semantic risk lives specifically in the reflection convention. Not claiming implementation tonight - de-risking the design per the ambition-calibration protocol. T6 also now DONE: all 11 standing register items verified or substantially advanced (added items 9, 11 this cycle - 2D YM rigorous constructions and the full Balaban paper list + MRS 1993 exact scope, both matching the freeze's citations precisely). Polling `203fd831` (flux2d, Codex's, not mine) in background; will harvest/report if it completes on my watch, otherwise leaving it for Codex/T0's owner.
03:40 Codex T3 follow-up: added normalized `gaugeOrbitAverageObservable` and proved its numerator equals the original numerator under any gauge-invariant finite weight; target/module/aggregate GateYM checks green, axiom footprint standard, pre-commit all-files green. Committed `02ea2a9`. Not touching untracked `ReflectionCore.lean`; treating it as parallel reflection-design work pending cross-review.
04:00 Codex/Claude T3/T1 reflection follow-up: kept the new single-step `stepHol_reflectLinkField_fwd`/`stepHol_reflectLinkField_rev` compatibility lemmas, fixed the section-variable build issue by making `reflectLinkField` group-free, and added Codex's `ReflectionCutExample.lean` two-layer cut-lattice sanity model. Targeted file checks, module build, axiom audits, and aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM` green. Walk-level mirrored/reversed holonomy remains open before RP-LINK.
04:10 Claude: committed the stepHol lemmas + ReflectionCutExample integration (`d807eb2`) - my own copy of the state Codex's 04:00 entry already describes; confirmed axiom footprints `[propext]` for both new stepHol lemmas and `twoLayerCutReflection_cutLink`, full aggregate build green (8047 jobs). `review:reflection-core-first-pass` thread now fully resolved on both open items (compatibility theorem, sanity instantiation). Next: attempting the walk-level mirrored/reversed-holonomy generalization flagged as the remaining pre-RP-LINK reflection target, since it's genuinely new content both of us have now flagged twice - will open a design/review note first if the `Walk` reversal operation isn't already sitting in `GaugeCoreGeneral.lean`.
04:20 Codex T3 reflection no-go/formulation pass: added reusable typed-walk API in `GaugeCoreGeneral.lean` (`Step.castEndpoints`, `Walk.append`, `Walk.reverse`, `hol_append`, `stepHol_castEndpoints`, `stepHol_reverse`, `hol_reverse`) and found the naive nonabelian walk-level mirror theorem has an order obstruction (`C` vs `C^-1` in the cons step). `ReflectionWalk.lean` remains uncommitted draft work; do not claim RP-LINK from it. Next formulation should use opposite-group/order-reversing holonomy or a class-function/closed-loop target.
04:30 Codex T3 reflection walk resolution: added `ReflectionWalk.lean` with the correct opposite-group order-reversal theorem `op_hol_reflectLinkField_mirrorWalk`, plus `opLinkField`, `reflectStep`, `mirrorWalk`, and single reflected-step packaging. Targeted file check, module build, axiom audits, and aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM` green (8048 jobs). Naive inverse theorem remains rejected; RP-LINK still needs Wilson action/cut factorization and positivity assembly.
04:40 Codex T3 reflection finite-measure layer: added `ReflectionEnsemble.lean`, proving `reflectLinkField` is an equivalence of finite configuration space and giving partition/numerator/expectation change-of-variables lemmas under reflection-invariant weights. Targeted file check, module build, axiom audits, and aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM` green (8049 jobs). Still not RP-LINK: Wilson action reflection covariance, cut factorization, and PSD assembly remain.
04:35 Claude T1/T3 collab: independently attempted the same walk-level generalization in parallel (unaware Codex was already mid-fix on the same file), and by direct hand-computation on a 2-step and 3-step walk hit the IDENTICAL obstruction Codex found (order reversal; also checked and rejected a class-function-weakened version, since class-function symmetry only reaches cyclic permutations of a product, not full reversal, so it fails for walks of length >= 3 even for a genuine character) - good independent cross-validation of Codex's negative result. On pulling the live file, found commit `678b386`'s `mirrorWalk` did NOT actually typecheck (`lake env lean` failed: "Function expected at mirrorWalk ?m" from a redundant explicit `(R : Reflection Λ)` parameter shadowing the section variable) despite the commit message claiming a green aggregate build - the aggregate target likely only rebuilt cached `.olean`s from before this specific edit landed. Fixed by dropping the redundant parameter (matching `reflectStep`'s already-working section-variable pattern), re-verified `lake env lean` clean and `lake build PhysicsSM.Draft.NullEdge.GateYM` green (8048 jobs) from a fresh invocation, axiom footprints `[propext]`/`[propext, Quot.sound]`. Committed `1033caa`. Discarding my own now-redundant local negative-finding writeup since Codex's DISCUSSION.md entry already covers the same conclusion. RP-LINK's real content still needs the kernel-PSD/Gram route already banked (`WilsonWeightPositivity`+`TransferPositivity`) or a plaquette/closed-loop-specific statement, not per-walk holonomy algebra - both flagged converging on this. Next: checking in on T2/T3 or starting morning-report groundwork given the hour.
04:50 Claude claims T2 (unclaimed, no file collision with Codex's active GaugeCoreGeneral/Reflection*/ReflectionEnsemble work). Closed the exact gap `TorusEvenCover.lean`'s own docstring flagged as remaining: `finRange`/`finRange_card` (a `Fin L` index range has the expected cardinality, via `Finset.card_bij` against `Finset.Ico` on `ℕ`), `rectInside`/`rectInside_card` (a genuine non-wrapping/contractible rectangular loop's inside plaquette set, cardinality literally `dx*dy`), and `ratio_rectInside` (theorem 2' fully assembled for that concrete loop, matching the freeze's displayed `<W>=(t^A+t^{P-A})/(1+t^P)` verbatim with `A` a real geometric area, not an abstract Finset parameter). `lake env lean` clean, aggregate build green (8049 jobs, on top of Codex's concurrent `ReflectionEnsemble.lean` - no collision), axiom footprint `[propext, Classical.choice, Quot.sound]`, zero `s o r r y`. Committed `8bcd861`. Still pure finite combinatorics - connecting this ratio to an actual Wilson-loop expectation value needs a bridge to `LatticeEnsemble`/`PlaquetteEnsemble`, analogous to what `WilsonLocalWeight.lean` did for T1/T3. Theorem 2 proper (general finite `G`, not just Z2) still needs `FusionConvolution.lean`'s missing Lemma 2a (character-orthogonality fusion identity) - real character theory, candidate next target or Aristotle handoff given the hour. Next: assessing whether to attempt Lemma 2a, help with T3's ensemble bridge, or start morning-report groundwork.
04:55 Claude T2/T7: submitted Lemma 2a as a focused standalone Aristotle package, project `9627f7ea` (`ym1-fusion-2dexact-20260704`, was on the planned-submissions list since the planning session). Independently re-verified the freeze document's own Mathlib API citation by direct source grep against the pinned commit before writing the statement (found the SAME `Representation.character` vs `FDRep.character`/`Simple` mistake already documented in freeze s17 item 2, this time in section 4/15's own text rather than a new lean-explore hit - good confirmation the s17 correction is real and needs to be the reference, not the original section 15 text). Statement is a cross-multiplied (division-free) form of the freeze's Lemma 2a, with the convolution argument order `h^-1 * A` preserved exactly (oracle-pinned, not weakened), and an explicit honest flag in the prompt that "characters span class functions" was not found in this pinned Mathlib by search - told Aristotle a precise no-go is a valid outcome, do not force a shortcut. Posted `review:t2-lemma2a-aristotle-submission` in DISCUSSION (non-blocking, submitted given the 05:30 cutoff). `lake env lean` on the statement file (with its one `s o r r y`) verified clean before submission. Ledger/registry updated. Next: poll `9627f7ea` next cycle; otherwise start morning-report groundwork given the approaching cutoff.
05:05 Claude reviewed Codex's untracked `PlaquetteReflection.lean` (lifts `ReflectionWalk`'s opposite-group reflected-holonomy identity to the concrete 4-step plaquette shape from `PlaquetteCore`). `lake env lean` clean, aggregate build green (8050 jobs), axiom footprint `[propext, Quot.sound]` on the main theorem - tighter than most of tonight's results, no `Classical.choice` needed. `mirrorPlaquette_walk` closes by `rfl`, confirming the plaquette's `.walk` projection composes cleanly with `mirrorWalk`'s convention. Posted `review:t3-plaquette-reflection` ACCEPTED, no bugs, no requested changes - a clean, honestly-scoped building block. Committed the review (`517d8d5`); `PlaquetteReflection.lean`/`GateYM.lean` remain Codex's uncommitted work, not touched. Approaching the 05:30 no-new-submissions mark with T1 (paused, sound), T2 (two real closures + one Aristotle submission), T3 (very active, Codex), T4/T5/T6/T7 (done/paused with clear reasons) all in good, honestly-documented states. Next: light morning-report groundwork, or poll `9627f7ea`/`203fd831`, whichever is more useful next cycle.
05:08 Claude: found `9627f7ea` (Lemma 2a v1) had a genuine normalization bug - a spurious extra `Fintype.card G` factor on the RHS from mis-cross-multiplying the freeze's ratio form (the `1/|G|` already built into `w_hat_R` cancels the `|G|`, it should not reappear). Sanity check: trivial rep + `w=1` gives LHS=`|G|`, buggy RHS gave `|G|^2`. The job had already CANCELED itself early (~4 min, mid sanity-check-looking THINKING trace) - plausibly Aristotle caught the same bug and stopped rather than proving a false statement, which is exactly the honest-no-go behavior the prompt asked for. Fixed the statement (commit `cface21`), re-verified `lake env lean` clean, regenerated the submission package, and resubmitted as `3435c7a3` (prompt updated to flag this as a resubmission with the bug description). Ledger/registry updated.
05:12 Codex T3 committed `PlaquetteReflection.lean` as `45eb172` after targeted file/module checks, axiom audit, aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM`, and `pre-commit run --all-files` all passed. I also independently caught the same Lemma 2a normalization counterexample while answering `review:t2-lemma2a-aristotle-submission`; no duplicate resubmission made, current poll has corrected `3435c7a3` running and `203fd831` still running.
05:20 Codex T3 extended `PlaquetteReflection.lean` with `localWeight_hol_reflectLinkField_mirrorPlaquette` and `productWeight_reflectLinkField_mirrorPlaquette`, giving the finite product-weight bridge from reflected link fields to mirrored plaquette families over `MulOpposite G`. Targeted file/module checks, axiom audit (`[propext, Quot.sound]`), aggregate GateYM build, aggregator check, and pre-commit all-files passed; committed `eb0a90b`. This is still not RP-LINK: no reflection-stable plaquette family, Wilson-opposite symmetry, cut factorization, or PSD assembly is claimed.
05:30 Codex final integration sweep: full `lake build` passed (8295 jobs) with existing info/linter/deprecation warnings outside the new YM changes; no errors. No new proof submissions after this point.
05:40 Codex T8 drafted `MORNING_REPORT.md` per RUN_PLAN sections, including theorem groups, Aristotle final state, integration debt, decisions, build hygiene, next actions, and lit summary; next pre-commit/commit and request cross-review.
05:45 Codex T8 committed morning-report draft `544dd63`, opened cross-review request, and polled Aristotle: corrected Lemma 2a `3435c7a3` and Gate C2 `203fd831` both still RUNNING.

## Parked for user

(unresolved disagreements land here with both positions stated)

## Integration debt

(harvested but not integrated, with reasons - feeds morning report s4)

```

### AgentTasks/overnight-ym-run-2026-07-03/DISCUSSION.md (1034 lines)

```markdown
# Discussion: overnight YM run 2026-07-03

Partner-to-partner exchange, self-logging. Thread naming: `idea:<slug>`,
`review:<short-id>`, `design:<slug>`, `triage:<slug>`, `corrections:<slug>`.
Substantive posts only; heartbeats go in the ledger.

---

## design:ym3-unitarity [SEEDED - resolve in ONE round, gates T1]

Planning session: Theorem 3 step (i) needs `conj(chi(g)) = chi(g^{-1})`,
which holds for unitary representations and is not packaged in Mathlib
(freeze s15: `char_dual` gives `chi(g^{-1})`, `char_conj` is the
class-function property, NOT complex conjugation). Two options from the
freeze, decision deliberately left to tonight:

1. **Explicit unitarity hypothesis** on the representation (e.g.
   `rho : G ->* Matrix.unitaryGroup n C`, or carry
   `(rho g)^H * (rho g) = 1`). Physically free - Wilson actions use
   unitary representations by construction. Freeze RECOMMENDS this:
   smallest Lean surface, matches the repo's explicit-hypothesis style.
2. **Prove unitarizability in-repo** (finite-order linear maps in char 0
   are diagonalizable with root-of-unity eigenvalues). Self-contained
   but real new content; candidate Aristotle target if option 1 proves
   too restrictive for the future compact-G generalization.

Planning session's position: take option 1 tonight; note option 2 as a
named future target in the module docstring. One round of argument, then
record the verdict here and move.

**VERDICT (00:05, claude, claiming T1):** adopting option 1. No
counter-argument posted; the physical-freeness point stands (Wilson
actions always use unitary reps) and it is already the hypothesis shape
used in the `WilsonWeightPositivity.lean` scaffold
(`hunit : ∀ g, (rho g)ᴴ * rho g = 1`). Option 2 (prove
unitarizability in-repo) stays as a named future target for the eventual
compact-G generalization - noting it in that file's docstring rather than
opening a new module tonight. Proceeding to close the scaffold's three
handoffs under this hypothesis shape.

**Codex concurrence (00:07, T2):** agreed. I will inherit option 1 for the
T2 fusion/Wilson-weight corollaries rather than reopening the design:
explicit unitarity is the right overnight surface, and the general
unitarizability theorem is a future Mathlib/project target.

## ambition-targets [SEEDED - both agents post in first cycle]

Nominate your flagship attempt(s) for the night and the tier you are
aiming at. Planning session's nominations: RP-LINK kernel-checked for
arbitrary finite G (T1 shocking); both 2D exact solutions closed (T2
shocking).

**Codex nomination (00:07):** I am taking T2 at the shocking tier: first
PKG-YM1-B even-cover/Z2 torus statement and local combinatorics, then
PKG-YM1-C fusion in the oracle-pinned convolution form if the first file
stabilizes quickly. If a statement is nontrivial enough for Aristotle, I
will open the required review thread before submission.

## triage:wave-1-composition [SEEDED]

Which packages go out in wave 1? Planning session's proposal:
`ym3-charpos-rp-20260703` and `ym1-torus-evencover-20260703` as soon as
their statement files are cross-reviewed; `qcd1-banks-casher-20260703`
mid-evening; `ym1-fusion-2dexact-20260703` after ORACLE-TODO-1;
`ym4-kp-polymer-20260703` capacity-gated after LIT item 3. Adjust here
with reasons.

## idea:shared-gram-module [SEEDED - low priority, note-only]

Freeze s5's structural remark: Cor 3a's Gram move is the same lemma
shape as `GateMP.SCGGramPositivity`. If tonight's PSD bookkeeping starts
duplicating that module, note the shared-lemma candidates here for a
future refactor - do NOT refactor GateMP tonight (scope rule).

---

(new threads below this line)

## review:t1-routeB

Claude 01:10. Requesting lightweight semantic review when Codex has a
cycle; not blocking T1 continuation (Cor 3b / RP-LINK next).

Source: `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean`,
all three former handoffs now kernel-checked (commit `fb4df44`).

Kernel-checked statements (intended reading separate from the Lean):

- `reChar_inv_of_unitary`: for a unitary rep, `Re chi(g^-1) = Re chi(g)`.
- `reCharGram_posSemidef`: `M(g,h) := Re chi(g h^-1)` is PSD as a real
  matrix, via vectorizing `rho` into a flat row-matrix `A`, noting
  `A * Aᴴ` (complex) is exactly the trace-kernel `C(g,h) = tr(rho g *
  (rho h)ᴴ)` (PSD by `posSemidef_self_mul_conjTranspose`), then bridging
  to the REAL matrix `M = Re C` via `PosSemidef.re_dotProduct_nonneg`
  specialized at real-cast test vectors.
- `hadamard_posSemidef`: the Schur product theorem (Hadamard product of
  two real PSD matrices is PSD) - genuinely NOT present in this repo's
  pinned Mathlib under any name (checked directly against
  `.lake/packages/mathlib`, commit `8f9d9cf`), despite an earlier
  lean-explore-based PREP_NOTES claim that it was. Derived here from
  `Matrix.PosSemidef.kronecker` (present) + `Matrix.PosSemidef.submatrix`
  along the diagonal embedding `i ↦ (i,i)` (present, no injectivity
  needed) - `A ⊙ B = (A ⊗ₖ B).submatrix diag diag`.
- `hadamard_pow_posSemidef`: entrywise `k`-th power of a PSD matrix is
  PSD, by induction (base case: all-ones matrix via
  `posSemidef_vecMulVec_self_star` at the constant-1 vector).
- `wilsonKernel_posSemidef` (THE deliverable): `K(g,h) =
  exp(beta*Re chi(g h^-1))` is PSD for `beta >= 0`. Via
  `Real.exp = fun x => tsum (x^k/k!)` (`Real.exp_eq_exp_ℝ` +
  `NormedSpace.exp_eq_tsum_div`), swap the finite `G x G` quadratic-form
  sum with the `tsum` over `k` (`Summable.tsum_finsetSum`, row
  summability from `Real.summable_pow_div_factorial`), then
  `tsum_nonneg` termwise using `hadamard_pow_posSemidef`.

Questions per protocol: (1) does swapping to Route B (bypassing the
character expansion entirely) change what the eventual flagship claim
can say - I believe NO, since RP-LINK's proof route (freeze section 6)
only needs kernel PSD as an input, agnostic to which route supplied it;
(2) what would demote the claim - if the `design:ym3-unitarity` option-1
hypothesis (`(rho g)ᴴ * rho g = 1`) turns out too strong for some Wilson
weight class not built from a literal unitary matrix representation
(I don't think this arises for compact/finite gauge groups, but flagging
since it's the one nontrivial hypothesis threaded through every lemma
here); (3) most ambitious defensible strengthening - generalize
`hadamard_posSemidef`/`hadamard_pow_posSemidef` to complex PSD matrices
(currently real-only, since that's all Route B needs) and consider
upstreaming to Mathlib, since the Schur product theorem is a real,
citable gap.

Demotion conditions: a hidden non-unitary Wilson weight case, a sign or
argument-order slip in the kernel definition (`K(g,h) = w(g h^-1)`, not
`w(h g^-1)` - though `reChar_inv_of_unitary` makes the two agree for this
specific weight, so this is low risk), or a scope mismatch between what
Cor 3b (transfer positivity, next) actually needs vs. what this file
supplies.

**Codex review verdict (01:16): ACCEPTED with scope note.** Verified
`lake build PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity`,
placeholder scan (no raw proof placeholders; only prose dependency
footprint language), and dependency prints for `reChar_inv_of_unitary`,
`reCharGram_posSemidef`, `hadamard_posSemidef`, and
`wilsonKernel_posSemidef`, all `[propext, Classical.choice, Quot.sound]`.

Semantic check:

- `rho_inv_eq_conjTranspose`/`reChar_inv_of_unitary`: the cancellation
  argument is sound under the explicit option-1 unitarity hypothesis.
- `reCharGram_posSemidef`: the vectorized matrix `A` really gives the
  trace kernel `C(g,h) = tr(rho g * (rho h)^H)`, and the bridge to the
  real matrix uses complex PSD only on real-cast test vectors, which is
  exactly what the real PSD target needs.
- `hadamard_posSemidef`: deriving Schur product from `kronecker` plus
  diagonal `submatrix` is semantically correct and reusable.
- `wilsonKernel_posSemidef`: the series/Hadamard-power route proves the
  PSD input RP-LINK needs.

Scope note: this closes Route B, the kernel-PSD engine for RP-LINK and
transfer positivity. It does not by itself prove freeze Theorem 3 as a
character-coefficient positivity statement (`w_hat_R >= 0`) or the finite
Bochner converse. So flagship/RP claims may cite this immediately, but
the paper-facing "character positivity chain" still needs Route A (or an
explicit note that RP used Route B while Theorem 3 remains separate).

No requested code changes. Minor hygiene only: the module docstring still
uses dependency-footprint prose matching existing local style, but broad
placeholder scans would be quieter after a later wording cleanup.

## review:t2-even-cover-core

Codex 00:36. Requesting lightweight semantic review when Claude has a
cycle; not blocking T2 continuation.

Source:
`PhysicsSM/Draft/NullEdge/GateYM/TorusEvenCover.lean`.

Kernel-checked statements:

- `mem_iff_origin_of_adjacent`: adjacent equality in both coordinate
  directions makes plaquette membership equivalent to membership at the
  origin.
- `eq_empty_or_univ_of_zero_boundary_bits`: if every Z2 dual-edge boundary
  bit is zero, the plaquette subset is empty or universal.
- `eq_or_compl_of_same_boundary_bits`: if two plaquette subsets have the
  same Z2 boundary bits, they are equal or complements.
- `zeroBoundary_iff_eq_empty_or_univ`: predicate-form wrapper for the two
  vacuum covers.
- `eq_or_compl_of_sameBoundary`: predicate-form wrapper for the inside or
  outside pair.
- `sum_zeroBoundary_weights`: the zero-boundary cover sum is
  `1 + t^P` with `P = card (Fin Lx × Fin Ly)`.
- `sum_sameBoundary_weights`: the same-boundary cover sum is
  `t^A + t^(P-A)` in complement-card form,
  `t ^ A.card + t ^ (Finset.univ \ A).card`.
- `ratio_sameBoundary_zeroBoundary_weights`: the cover-expansion ratio is
  `(t ^ A.card + t ^ (P - A.card)) / (1 + t ^ P)`.

Intended reading: this is the finite dual-connectivity core of freeze
section 4, theorem 2'. It does not yet prove the cosh expansion, the
partition-function formula, or the identification of a rectangular loop's
inside set. It proves the combinatorial spine: zero boundary gives the
two vacuum covers, and matching a fixed loop boundary gives the inside or
  outside pair. The last two theorems are the exact finite cover-sum
  cores before multiplying by the physics prefactors (`2^E`,
  `cosh(beta)^P`). The ratio theorem performs the numerator/denominator
  division at the cover-expansion layer.

Demotion conditions: a semantic mismatch in the boundary-bit orientation,
a hidden dependence on non-wrapping edges that fails for the intended
torus-to-dual-grid reduction, or any claim that this already proves the
full exact solution.

**Claude review verdict (01:10): ACCEPTED.** Checked against freeze
section 4 Theorem 2' intent (survival of a plaquette-set monomial iff
every link has even incidence, on the torus every link borders exactly 2
plaquettes so this is exactly "adjacent plaquettes across each dual edge
have equal membership"). Findings:

1. `xBoundaryBit`/`yBoundaryBit` correctly encode "same membership on
   both sides of a dual edge" as XOR-false - matches the intended even-
   incidence reduction precisely.
2. `mem_iff_origin_of_adjacent` / `eq_empty_or_univ_of_adjacent`: the
   induction-to-origin connectivity argument is a correct, standard grid
   argument, and the observation that WRAPAROUND (periodic) dual edges
   are not needed for empty-or-universal is genuinely correct - a plain
   (non-periodic) rectangular grid is already connected via its interior
   edges alone, so this is a real, honest strengthening, not a
   loophole. Confirmed by hand: since `ZeroBoundary`/`SameBoundary`
   only constrain INTERIOR (non-wrapping) dual edges, the classification
   theorems conclude from a WEAKER hypothesis set than "every real torus
   link has even incidence" - which only makes the conclusion stronger,
   not wrong.
3. What changes the theorem target: this file's `ZeroBoundary`/
   `SameBoundary` are, by construction, interior-edge-only. The NEXT
   layer (deriving `hx`/`hy` from "every physical torus link, including
   periodic ones, has even incidence") must separately confirm the
   periodic-link constraints are either redundant once emptyOrFull is
   known (true for `ZeroBoundary`'s two vacuum covers, since both are
   trivially constant - see `zeroBoundary_empty`/`zeroBoundary_univ`) or
   handled explicitly when identifying a rectangular loop's actual inside
   region for `SameBoundary`. Worth a one-line docstring flag on
   `ZeroBoundary`/`SameBoundary` themselves (not just on the connectivity
   theorem) so the next module's author does not assume periodic edges
   are already covered.
4. `sum_zeroBoundary_weights`/`sum_sameBoundary_weights`/
   `ratio_sameBoundary_zeroBoundary_weights`: the two-element-Finset sum
   bookkeeping (with the `hne`/`ne_univ_sdiff_self` non-degeneracy guards
   requiring `hLx, hLy > 0`) is correct and carefully done.
5. Most ambitious defensible next step: thread the wraparound-edge
   argument explicitly (even if it turns out to be the "redundant given
   emptyOrFull" case) so the docstring claim "the wraparound torus edges
   are not needed" is itself a PROVED lemma, not just an assessment -
   that closes the one soft spot above with a kernel-checked guarantee
   rather than a comment.

No bugs found; scope claims match the code exactly. Cleared to continue
toward the exact-formula/cosh-prefactor assembly layer.

**Codex follow-up (01:24):** addressed the wraparound-soft-spot review
item in Lean. Added `mem_iff_origin_of_zeroBoundary`,
`mem_iff_mem_of_zeroBoundary`, and
`zeroBoundary_z2SymmDiff_of_sameBoundary` to `TorusEvenCover.lean`; target
and aggregate builds green. This makes the "non-wrapping dual edges already
force global constancy" point kernel-checked, so periodic-edge constraints
are explicitly redundant for the zero-boundary classification layer.

## idea:rp-link-scope

Claude 01:25. Flagging before anyone (including me, later tonight)
attempts RP-LINK proper: its remaining content is NOT more PSD algebra
(that's fully supplied now by `WilsonWeightPositivity` +
`TransferPositivity`, both closed) but the LATTICE PROBABILITY FRAMEWORK
connecting "the ensemble's Boltzmann weight" to "PSD of the per-cut
kernel" - concretely: the configuration space `G^E`, the Wilson action
`S_beta`, the partition function `Z`, the expectation `<.>`, the
reflection `theta` and the sub-algebra `A_+`, and the cut structure.
Once that apparatus exists, the actual inequality
`<(theta F)* F> >= 0` reduces almost immediately to the already-proved
kernel PSD (condition on the cut, `K = sum_j lambda_j v_j(-) conj(v_j(+))`
is just PSD's own spectral decomposition, giving a sum of `|integral|^2`
terms - freeze section 6's proof sketch).

This apparatus overlaps heavily with T3's scope (D11 transfer matrix,
D12 gap definition also need `G^E`, the action, and the partition
function) - building it twice would be wasteful. Proposal: whoever picks
up T3 builds the SHARED lattice/probability layer
(`GaugeCoreGeneral.lean` or a new `LatticeEnsemble.lean`), and RP-LINK
consumes it plus `TransferPositivity.transferMatrix_posSemidef`/
`compression_posSemidef` as the PSD inputs. I am pivoting to Route A
(`CharacterPositivity.lean`) rather than starting this solo, since it
duplicates territory and is exactly the kind of "uncertain formulation"
target the protocol says gets a discussion round first. If nobody claims
T3 tonight, RP-LINK's concrete lattice instantiation is the honest
"remaining assembly work" for the morning report, with the PSD engine
banked and ready.

**Codex response (01:34):** agreed. I am releasing T2 as partial with its
verified cover/fusion cores banked and claiming T3 for the shared finite-G
lattice/probability definitional layer. First target is deliberately
small: a general finite oriented-link configuration space, walk holonomy
with inverses, gauge action, and the telescoping L2 statement. I will open
an early review thread before building any RP-LINK-facing ensemble claims
on top of it.

## review:t3-general-gauge-core

Codex 01:43. Requesting early definitional review before using this layer
for RP-LINK, transfer-matrix, or D12 statements.

Source: `PhysicsSM/Draft/NullEdge/GateYM/GaugeCoreGeneral.lean`.

Kernel-checked statements:

- `OrientedLattice.Step`: typed forward/reverse traversal; reverse
  traversal contributes `(U e)^{-1}`.
- `OrientedLattice.Walk`: typed composable walks by endpoints.
- `OrientedLattice.gauge`: `(g.U)_e = g(src e) * U e * (g(tgt e))^{-1}`.
- `stepHol_gauge`: one-step covariance.
- `hol_gauge`: telescoping covariance
  `hol(g.U,w) = g(x) * hol(U,w) * g(y)^{-1}`.
- `hol_gauge_closed` and `classFunction_hol_gauge_closed`: closed-walk
  holonomy is conjugated at the basepoint, so class functions of closed
  holonomy are gauge invariant.
- `gauge_one` and `gauge_comp`: local gauge transformations act on link
  fields.
- `gauge_inv_apply` and `gaugeEquiv`: each fixed gauge transformation is
  an explicit equivalence of configuration space.
- `sum_comp_gauge`: finite change of variables under a gauge transformation.

Intended reading: this is the L1/L2/L4 definitional spine for arbitrary
groups, convention C-1. It is not yet a finite probability ensemble:
there is no partition function, action, plaquette list, reflection, cut
structure, transfer matrix, or D12 sector here.

Demotion conditions: wrong multiplication order in `gauge`, wrong inverse
placement for reverse steps, a typed-walk design that cannot express the
plaquette/cut walks needed by T1/T3, or any hidden commutativity/abelian
assumption.

**Claude review verdict (02:00): ACCEPTED, no bugs.** Checked against
freeze D3/L1/L2/L4 and the C-1 convention. Findings:

1. `gauge` matches D3's formula
   `(g.U)_e = g(src e) U_e g(tgt e)^{-1}` verbatim.
2. `stepHol_gauge`'s `rev` case verified by hand:
   `stepHol(gauge g U, rev e) = ((gauge g U) e)^{-1}
   = g(tgt e) (U e)^{-1} g(src e)^{-1}`, and since a `rev e` step runs
   `tgt e -> src e` (so `x = tgt e, y = src e` in the covariance
   statement), this is exactly `g x * stepHol(U, rev e) * (g y)^{-1}` -
   the inverse-placement convention is correct, not just plausible.
3. `gauge_comp`'s composition order verified algebraically: expanding
   both `gauge g (gauge h U) e` and `gauge (g*h) U e` gives the identical
   string `g(src e) h(src e) U_e h(tgt e)^{-1} g(tgt e)^{-1}` - this is a
   genuine LEFT action (`(gh).U = g.(h.U)`), not an anti-action; no
   reordering slip.
4. `hol_gauge_closed`/`classFunction_hol_gauge_closed` correctly deliver
   L2 (gauge invariance of any class function of closed-walk holonomy);
   `gauge_one`/`gauge_comp`/`gaugeEquiv` correctly deliver L4's action
   structure; `sum_comp_gauge` correctly delivers L3-style finite
   change-of-variables (docstring appropriately says "algebraic core of
   finite measure invariance," not claiming Haar/compact-group L3 yet).
5. What changes the theorem target: none identified - the typed-walk
   design (endpoints as type indices, not a separate well-formedness
   predicate) looks like it will compose cleanly for plaquette
   (4-step closed walk) and cut (crossing-link) walks later, though that
   is untested until T1/T3 actually build one.
6. Most ambitious defensible next step: instantiate `Step`/`Walk` at the
   4-cycle plaquette shape (freeze C-2, D5) as a concrete `Walk` term and
   confirm `hol_gauge_closed` reproduces the already-proved
   `Z2GaugeCore.plaqSpins_gauge` special case - a good regression/
   consistency check before this layer is trusted for D11/D12.

No requested changes. Cleared for T1/T3 use.

**Codex extension (02:13):** added the next shared layer,
`PhysicsSM/Draft/NullEdge/GateYM/LatticeEnsemble.lean`.

Kernel-checked statements:

- `partition`: finite sum of an arbitrary real weight over link fields.
- `numerator`: weighted observable sum.
- `expectation`: total ratio `numerator / partition`, with nonzero/positive
  hypotheses left to theorems rather than hidden in the definition.
- `partition_pos`: strictly positive finite weights have strictly positive
  partition sum.
- `partition_comp_gauge`, `numerator_comp_gauge`,
  `expectation_comp_gauge`: fixed gauge transformations are finite
  change-of-variables symmetries for these sums.

Intended reading: this is only the finite-sum ensemble skeleton requested in
`idea:rp-link-scope`; it deliberately has no Wilson action, plaquette list,
reflection/cut data, transfer matrix, or RP inequality. The theorem
dependency footprint is `[propext, Classical.choice, Quot.sound]`.

**Claude ack (02:20):** exactly the layer requested - thank you. Once
this exists with a Wilson action, T1's `TransferPositivity.transferMatrix_posSemidef`/
`compression_posSemidef` are ready to consume it directly (they are
already stated abstractly over any finite index type and any PSD kernel/
diagonal weight, so no rework needed on the T1 side). Will resume RP-LINK
proper once the action/plaquette/reflection layer lands.

**Codex extension (02:31):** added
`PhysicsSM/Draft/NullEdge/GateYM/PlaquetteCore.lean` as the next
D5/D7 bridge.

Kernel-checked statements:

- `Plaquette`: a based typed closed 4-walk, with no coordinate-lattice
  convention chosen yet.
- `Plaquette.hol_gauge`: plaquette holonomy is conjugated by the gauge
  value at the basepoint.
- `Plaquette.classFunction_hol_gauge`: class functions of plaquette
  holonomy are gauge invariant.
- `actionSum_gauge`: finite sums of local class-function plaquette actions
  are gauge invariant.
- `productWeight_gauge`: finite products of local class-function plaquette
  weights are gauge invariant.

Intended reading: this supplies the abstract plaquette/action invariance
layer that `idea:rp-link-scope` needs before Wilson action and RP
factorization can be stated. It is still not a concrete C-2 rectangular
plaquette list, reflection/cut structure, transfer matrix, or D12 sector.

**Codex extension (02:43):** extended `LatticeEnsemble.lean` with the
generic finite-measure consequence of gauge-invariant weights:
`numerator_observable_comp_gauge_of_weight_invariant` and
`expectation_observable_comp_gauge_of_weight_invariant`. These say that
if a weight is invariant under a fixed gauge transformation, applying that
gauge transformation only to the observable leaves the weighted numerator
and expectation unchanged. This is still finite-sum bookkeeping, not an
orbit-average theorem or reflection-positivity statement.

**Codex extension (02:55):** added
`PhysicsSM/Draft/NullEdge/GateYM/PlaquetteEnsemble.lean`, combining the
abstract plaquette and ensemble layers for arbitrary local plaquette
weights.

Kernel-checked statements:

- `weight`, `partition`, `numerator`, `expectation`: product-plaquette
  weight and the corresponding finite ensemble sums.
- `weight_pos` and `partition_pos`: positive local weights give positive
  product weights and positive partition function.
- `weight_gauge`: class-function local weights make the product plaquette
  weight gauge invariant.
- `numerator_observable_comp_gauge` and
  `expectation_observable_comp_gauge`: with a class-function local weight,
  gauge-transforming only the observable leaves the numerator/expectation
  unchanged.

Intended reading: this is a finite Wilson-ensemble-shaped surface, but the
local weight is still arbitrary and no concrete Wilson character weight,
reflection plane, cut factorization, transfer matrix, or D12 sector is
claimed.

**Codex extension (03:08):** added
`PhysicsSM/Draft/NullEdge/GateYM/TransferGapDefinition.lean`, a D12
definition shell.

Kernel-checked statements:

- `SymmetrySector`: separate predicates for Gauss invariance,
  zero momentum, and trivial 't Hooft flux.
- `SymmetrySector.vacuum`: the D12 vacuum-sector predicate requiring all
  three qualifiers.
- `vacuum_gaussInvariant`, `vacuum_zeroMomentum`,
  `vacuum_trivialFlux`: projection lemmas, keeping the qualifiers
  discoverable.
- `finiteMassGap`: real-valued spectral-ratio convention
  `-Real.log (lambda1 / lambda0)`.
- `finiteMassGap_nonneg` and `finiteMassGap_pos`: elementary log lemmas
  under `0 < lambda1 <= lambda0` and `0 < lambda1 < lambda0`.

Intended reading: this is the flux-qualified gap definition slot, not a
transfer-matrix construction, not a spectral theorem, and not a concrete
oracle-number evaluation. The docstring cites the freeze's D12 convention
and points to `LIT_LOG.md` for the still-tracked 't Hooft attribution debt.

## idea:qcd1-scope

Claude 02:05 (T4). Landed `PhysicsSM/Draft/NullEdge/GateYM/BanksCasherShadow.lean`:
the GW-circle structural fact (`Dov_sub_one_unitary`: the shifted overlap
`Dov gamma5 eps - 1 = gamma5 * eps` is unitary, given both Hermitian
involutions; `gamma5_mul_Dov_isHermitian`: `gamma5 * Dov` is Hermitian),
instantiated at the C2 certified sign `epsCFC H`. Kernel-checked, zero
`s o r r y`, committed `ace9b36`.

Flagging before anyone (including me) attempts QCD1-i/ii proper: the
task directions' framing ("pure finite linear algebra adjacent to
`epsCFC_trace_eq_inertia`") undersold the remaining setup. What is
actually needed beyond tonight's structural fact:

1. The explicit `lambda_hat` Mobius map `lambda -> lambda / (1 - lambda/2)`
   sending the GW circle `|lambda-1|=1` to the imaginary axis, well-defined
   away from the doubler point `lambda=2`. Needs a design decision on
   which Mathlib normal-operator/spectral-theorem route gives eigenvalues
   of the unitary `Dov - 1` (hence of `Dov` itself) in a form usable for
   a finite SUM over the spectrum - `Matrix.IsHermitian`-style spectral
   API does not directly apply since `Dov` itself is not Hermitian (only
   `gamma5 * Dov` is, and `gamma5`/`gamma5*Dov` do not commute in general,
   so their spectra do not simultaneously diagonalize the naive way).
2. Zero-mode / nonzero-mode separation and the CHIRAL PAIRING lemma
   (nonzero-mode eigenvalues pair under `gamma5`) - this is the step the
   task directions explicitly flag as having real semantic risk ("which
   map is lambda_hat, where does the GW circle enter") and says needs a
   `review:qcd1-pairing` round before any attempt, not a blind proof.
3. The condensate sum `Sigma_Lambda(m)` as an explicit finite sum over
   the spectral data, and the exact QCD1-i decomposition identity itself.

None of this is attempted yet. Given the genuine design uncertainty in
item 1 (which spectral-theorem route) and the task's own explicit
warning on item 2, I am NOT pushing further on this solo tonight -
parking it here for either a design round with Codex/the user, or a
future Aristotle strategy-job question, rather than guessing at the
right formalization and risking a silently-wrong `lambda_hat`. T4's
honest state: the structural fact is banked; QCD1-i/ii proper are
open with a precise list of what's missing.

## idea:wilson-local-weight-connector

Claude 03:05. `PlaquetteEnsemble.lean`'s `weight_gauge` needs
`localWeight : G -> R` a CLASS FUNCTION (`localWeight (a*b*a^-1) = localWeight b`).
The Wilson weight `exp(beta * Re chi(h))` from
`WilsonWeightPositivity.reChar` is exactly such a class function, and
NEEDS NO UNITARITY for that specific fact - `tr(rho(a h a^-1)) =
tr(rho a * rho h * rho a^-1) = tr(rho h)` by trace cyclicity and
`rho a * rho a^-1 = 1` alone, for ANY representation. I'm planning a
small NEW file, `WilsonLocalWeight.lean` (imports both
`WilsonWeightPositivity` and `PlaquetteEnsemble`, does not edit either),
proving `reChar` is a class function and instantiating
`PlaquetteEnsemble.weight_gauge`/`expectation_observable_comp_gauge` at
the real Wilson weight - the connecting tissue between T1's kernel-PSD
engine and T3's ensemble skeleton, one step closer to RP-LINK's action
layer. Flagging before I start in case it collides with where T3 is
already headed (Codex: if you're about to add the Wilson weight
yourself, say so and I'll do something else instead).

**Codex response (03:20):** good connector target; I repaired the
untracked file's trace-cyclicity proof by making the trace rotation an
explicit calc, then added the partition-positivity instantiation.

Kernel-checked statements:

- `wilsonLocalWeight`: the concrete local weight
  `Real.exp (beta * reChar rho h)`.
- `wilsonLocalWeight_class`: this weight is a class function under
  multiplicativity/identity of `rho`; no unitarity hypothesis is needed for
  this class-function fact.
- `wilsonWeight_gauge`: the Wilson plaquette-product weight is gauge
  invariant.
- `wilsonExpectation_observable_comp_gauge`: with Wilson plaquette-product
  weight, gauge-transforming only the observable leaves expectation
  unchanged.
- `wilsonLocalWeight_pos` and `wilsonPartition_pos`: positivity of the
  local exponential weight and resulting finite partition function.

Intended reading: this connects T1's `reChar` Wilson weight to T3's finite
product-plaquette ensemble. It still does not define reflection planes, cut
factorization, tensor-product transfer kernels, or RP-LINK.

## idea:gauge-orbit-average

Codex 03:35. Added a finite orbit-sum identity to
`PhysicsSM/Draft/NullEdge/GateYM/LatticeEnsemble.lean`.

Kernel-checked statements:

- `gaugeOrbitSumObservable`: the unnormalized sum of an observable over all
  finite gauge transformations of a configuration.
- `numerator_gaugeOrbitSumObservable_of_weight_invariant`: under a weight
  invariant under every finite gauge transformation, the numerator of that
  gauge-orbit-summed observable is `Fintype.card (V -> G)` times the
  original numerator.

Intended reading: this is the finite orbit-average precursor needed by
Elitzur/gauge-projection bookkeeping. It intentionally avoids normalization
by the gauge-group cardinality for now, since the unnormalized identity is
the kernel-checked finite-sum core and has no denominator side condition.

Codex follow-up. Normalized the same orbit sum inside the finite setting.

Additional kernel-checked statements:

- `gaugeOrbitAverageObservable`: the orbit sum multiplied by
  `(Fintype.card (V -> G) : Real)^-1`.
- `numerator_gaugeOrbitAverageObservable_of_weight_invariant`: because
  `V -> G` is inhabited by the constant identity gauge transformation, its
  finite cardinality is nonzero over the reals; the normalized orbit average
  has exactly the same numerator as the original observable under any
  gauge-invariant weight.

Intended reading: this is now the actual finite gauge-projection averaging
identity. It is still an averaging identity for numerators, not a theorem
about Elitzur vanishing or reflection positivity.

## design:reflection-cut-layer

Claude 03:35. Proposing a concrete shape for RP-LINK's remaining
apparatus (reflection map `theta`, positive-side algebra `A_+`, cut
structure) so it's ready whenever someone (either of us, or a future
session) has bandwidth for it - not claiming this tonight, just
de-risking the design per the "one idea round before ambitious targets"
rule, since a wrong reflection convention would be exactly the kind of
silent semantic error the red-team's finding 1 already warned about.

Minimal abstract shape, staying at `GaugeCoreGeneral.OrientedLattice`'s
level of abstraction (no concrete coordinates needed):

```
structure Reflection (Lambda : OrientedLattice) where
  reflectV : Lambda.V -> Lambda.V
  reflectE : Lambda.E -> Lambda.E
  reflectV_involutive : Function.Involutive reflectV
  reflectE_involutive : Function.Involutive reflectE
  -- a "positive side" predicate on vertices, with the plane itself as
  -- the fixed-point boundary
  posSide : Lambda.V -> Prop
  posSide_iff_not_reflect : forall v, posSide v <-> not (posSide (reflectV v)) -- v and its
    mirror are on opposite sides (or both on the plane - needs a third case
    for on-plane vertices, see below)
  -- reflectE must respect src/tgt so that a link entirely on one side maps
  -- to a link entirely on the other; a CUT link (crossing the plane) maps
  -- to itself reversed
  reflect_src : forall e, Lambda.src (reflectE e) = reflectV (Lambda.tgt e)  -- reversal
  reflect_tgt : forall e, Lambda.tgt (reflectE e) = reflectV (Lambda.src e)
```

Open design questions I do NOT think should be resolved solo:
1. On-plane vertices/cut links need a THIRD case (neither positive nor
   negative side) - does `posSide` need to be `Lambda.V -> Bool` with a
   third value, or a separate `onPlane : Lambda.V -> Prop` predicate,
   or do we sidestep this by defining the cut as "edges whose src and
   tgt are on opposite sides" (no on-plane vertices at all, matching the
   physical picture of a plane BETWEEN two layers of sites, cutting only
   TEMPORAL links) - I believe this last option matches freeze section 6
   ("a plane bisecting a layer of temporal links") and avoids the
   three-valued mess, but should be confirmed against Osterwalder-Seiler's
   actual construction before being locked in (T6 item 1 flagged this
   exact LINK-reflection detail as still needing primary-source
   verification).
2. `A_+` (freeze: "the algebra of functions of links strictly on the
   positive side") - is this `Lambda.LinkField G -> R` functions that
   factor through the restriction to positive-side links only, or
   something else? I'd model it as: `F : Lambda.LinkField G -> R` such
   that `F` only depends on `U e` for `e` with both endpoints on the
   positive side (a `Prop`, not a subtype, to avoid restructuring
   `LinkField`).
3. The REFLECTED expectation `<(theta F)* F>` needs `theta` lifted from
   vertices/edges to link FIELDS: `(theta . U) e := U (reflectE e)`
   composed with possibly a group-element involution (complex conjugation
   analog) if `R` is complex - for real Wilson actions this may just be
   `(theta . U) e := U (reflectE e)` with no extra conjugation, but this
   needs checking against the actual RP inequality's complex-conjugate
   structure if the observable ring is ever complex.

If Codex wants to take a pass at this (matches your T3 momentum) - happy
to co-review; if not, I may attempt a first cut later tonight or leave it
as the clearly-scoped next-session target. Either way, DO NOT let a
statement here get submitted to Aristotle or promoted without a
cross-review round given how much semantic risk lives in the reflection
convention specifically.

**Codex review of untracked `ReflectionCore.lean` draft:** compile/hygiene
check passed locally:

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean`
- raw-placeholder scan over the file: no hits

Verdict: ACCEPT as a first-pass combinatorial scaffold, with a hard
claim-language gate before it is wired into any RP theorem. The `Reflection`
structure cleanly models the "plane between layers" option: no on-plane
vertices, edge reflection reverses endpoints, positive links map to negative
links, cut links map to cut links, and `reflectLinkField` is an involution.
Those are good finite identities, not yet physics content.

Required before RP-LINK use: prove a compatibility theorem showing that this
specific `reflectLinkField U e := U (reflectE e)` convention is the right
`theta` for the Wilson action/cut kernel in the existing `OrientedLattice`
API. In that API, reverse traversal is represented by `Step.rev e` and
contributes `(U e)^-1`; the reflection draft instead bakes endpoint reversal
into `reflectE` and then pulls back the raw link value. That may be the right
LINK-reflection convention, but it must be justified by a downstream
action/cut factorization theorem or by the still-open primary-source check in
`LIT_LOG.md` item 1. Until then: do not submit, promote, or cite this as
RP-LINK.

## review:reflection-core-first-pass

Claude 03:55. Implemented `design:reflection-cut-layer` as
`PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean` (commit `cfa1b65`)
rather than waiting further, per the ambition-calibration protocol - one
idea round posted, no immediate pushback, proceeding with the most
defensible version and flagging for review now (per the file's own
docstring, this needs review before anything cites it in claim language
or an Aristotle submission).

Resolved the three open design questions as explicit choices (not
silent assumptions):

1. NO on-plane vertices - `posSide v <-> not posSide (reflectV v)` (every
   vertex strictly one side, reflection swaps). Cut is an EDGE notion:
   `cutLink e := posSide (src e) <-> not posSide (tgt e)` (opposite
   sides). Matches freeze section 6's "plane bisecting a LAYER of
   temporal links" phrasing.
2. `A_+` = `DependsOnPositiveSide F`: `F` agrees on any two link fields
   agreeing on every positive-side link.
3. `theta` on link fields = direct pullback `(theta U) e := U (reflectE
   e)`, no extra group inverse - justified post-hoc by
   `reflectLinkField_involutive` (it works cleanly), not derived as a
   necessity.

Kernel-checked (all first-try or one `tauto` after unfolding):
`reflectE_positiveLink`, `reflectE_negativeLink`, `reflectE_cutLink`
(reflection preserves the three link classes appropriately),
`reflectLinkField_involutive`. Dependency footprint
`[propext, Classical.choice, Quot.sound]`, zero `s o r r y`.

Questions per protocol: (1) does this change any theorem TARGET - no,
it's new scaffolding, doesn't touch T1/T3's existing statements;
(2) what would demote it - if design choice 1 (no on-plane vertices)
turns out to NOT match Osterwalder-Seiler's actual construction once
LIT_LOG item 1's primary-source detail is checked, the whole `Reflection`
structure would need rebuilding around a three-valued vertex predicate
instead - flagging this as the single biggest risk; (3) most ambitious
defensible next step - instantiate `Reflection` concretely on a Z2 torus
lattice (reusing `TorusEvenCover`'s coordinate structure) as a sanity
check that a real reflection plane actually satisfies the abstract
axioms, before building the Wilson-weighted RP inequality on top.

Demotion conditions: design choice 1 turning out wrong against the
primary source (see above); a hidden asymmetry in `reflect_src`/
`reflect_tgt`'s reversal convention that doesn't match how Osterwalder-
Seiler define the reflected observable; `DependsOnPositiveSide` failing
to compose correctly once an actual `A_+`-typed Wilson observable is
built on top of it.

**Codex review verdict:** ACCEPTED as first-pass scaffolding, with the same
claim gate as above. I rechecked after `ReflectionCore.lean` was committed
and imported by the aggregator:

- `lake build PhysicsSM.Draft.NullEdge.GateYM` passed post-merge.
- raw-placeholder scan over `ReflectionCore.lean` and this discussion file
  had no hits.
- Axiom audit: `reflectE_cutLink` depends on the standard
  `[propext, Classical.choice, Quot.sound]`; `reflectLinkField_involutive`
  reports `[Quot.sound]`.

No code bugs found in the finite combinatorial layer. The biggest demotion
condition is exactly the one Claude names: if Osterwalder-Seiler's link
reflection needs on-plane sites or a different reflected-link convention,
this structure is the wrong abstraction for RP-LINK. I would also require
one new compatibility theorem before any RP theorem consumes it: the direct
pullback `reflectLinkField` must be shown to make the Wilson/action/cut
factorization transform as intended inside our `Step.rev` convention, where
reverse traversal contributes `(U e)^-1`. Until that theorem or the primary
source check lands, this is safe finite scaffolding, not RP-LINK.

**Claude response (03:50):** thanks for the review. Good news on the
demotion condition you both named (design choice 1, on-plane sites) -
just resolved it via lit search (see LIT_LOG "item 1 supplement", 03:45):
two independent secondary sources, worded almost identically, confirm
link reflection's hyperplane "cuts time links in half" with NO site on
the plane, while site reflection is the (different, harder) plane-
through-vertices case - exactly matching `ReflectionCore.lean`'s design
choice 1. Primary-source (Osterwalder-Seiler 1978 itself) text still not
directly extracted this session (PDF tooling limits), so I'd call this
"strongly corroborated, not yet primary-source-certain" rather than
fully closed - but the biggest named risk is now low.

Your compatibility-theorem point is exactly right and I hadn't nailed it
down: `reflectLinkField` needs to interact correctly with `stepHol`'s
`Step.rev` convention (`(U e)^-1` for reverse traversal) before any
walk/plaquette holonomy statement can be pushed through the reflection.
Concretely I think the needed lemma is something like: for a walk `w`
from `x` to `y` and its "mirror" walk under `reflectE` (composing
`reflectE` with each step, using `reflectV_involutive`/`reflect_src`/
`reflect_tgt` to retype the endpoints), `hol (reflectLinkField U) w` !=
`hol U (mirrored walk)` in general - the two are related by the reversal
baked into `reflect_src`/`reflect_tgt`, so I'd expect an identity like
`hol (reflectLinkField U) w = (hol U (walk retraced through reflectE in
REVERSE order))^-1` or similar, which needs actually defining what a
"mirrored walk" is (reversing step order AND applying reflectE to each
step) - real new content, not yet attempted. Will take a look if I have
a cycle free later; flagging it in the ledger either way as the next
concrete ReflectionCore task, not claiming it done.

**Codex follow-up:** kept the single-step compatibility lemmas
`stepHol_reflectLinkField_fwd` / `stepHol_reflectLinkField_rev`, fixed their
section-variable build issue by making `reflectLinkField` group-free and
introducing `[Group G]` only for the `stepHol` lemmas, and added
`ReflectionCutExample.lean`.

New sanity-check module:

- `twoLayerCutLattice`: vertices are `(side, spatial label)`, with every
  edge a temporal cut link from the negative side to the positive side.
- `twoLayerCutReflection`: flips the side coordinate and fixes the cut-link
  label, giving an explicit inhabitant of `Reflection`.
- `twoLayerCutReflection_cutLink`,
  `twoLayerCutReflection_not_positiveLink`,
  `twoLayerCutReflection_not_negativeLink`: every edge is cut, and no edge is
  strictly positive-side or negative-side.

Verification: targeted file checks, `lake build
PhysicsSM.Draft.NullEdge.GateYM.ReflectionCutExample`, axiom audits for the
new compatibility/example lemmas, and aggregate `lake build
PhysicsSM.Draft.NullEdge.GateYM` all passed. This closes the concrete
inhabitation sanity check and the single-step `Step.rev` compatibility check;
the walk-level mirrored/reversed holonomy theorem remains open and should be
the next reflection-content target before RP-LINK.

**Codex walk-level attempt / obstruction:** I added general typed-walk
infrastructure in `GaugeCoreGeneral.lean` (`Walk.append`, `Walk.reverse`,
`hol_append`, `stepHol_reverse`, `hol_reverse`) and a small
`Step.castEndpoints` helper for reflected endpoint casts. Then I tested the
natural `ReflectionWalk` theorem sketched above:

`hol (reflectLinkField U) w = (hol U (mirrorWalk w))^-1`.

The induction exposes a real order problem. For `w = cons s w'`, the reflected
field holonomy multiplies the reflected first-step contribution on the LEFT:

`C * (hol U (mirrorWalk w'))^-1`.

But if `mirrorWalk (cons s w')` is built by reversing order and appending the
reflected first step at the end, then

`(hol U (mirrorWalk (cons s w')))^-1 = C^-1 * (hol U (mirrorWalk w'))^-1`.

The proof goal collapses to `C = C^-1`, which is false for a general finite
group. So the proposed full-walk identity is not the right nonabelian target.
Next formulation should use an opposite-group/order-reversing statement, an
explicit anti-holonomy accumulator, or a later class-function/closed-loop
statement where the order reversal is absorbed by inversion/conjugation
hypotheses. Do not promote the naive walk theorem to RP-LINK.

**Codex resolution:** implemented the opposite-group formulation in
`PhysicsSM/Draft/NullEdge/GateYM/ReflectionWalk.lean`.

New kernel-checked statements:

- `opLinkField`: promotes a link field pointwise to `MulOpposite G`.
- `reflectStep`: reflects a typed step and reverses its endpoints using
  `ReflectionCore`'s endpoint-swap convention.
- `stepHol_reflectLinkField_reflectStep`: packages the fwd/rev single-step
  compatibility lemmas into one reflected-step theorem.
- `mirrorWalk`: reverses step order and reflects each step, yielding a typed
  walk from `reflectV y` to `reflectV x`.
- `op_hol_reflectLinkField_mirrorWalk`:
  `op (hol (reflectLinkField U) w) = hol (opLinkField U) (mirrorWalk w)`.

Verification: `lake env lean ReflectionWalk.lean`, targeted module build,
axiom audits for the reflected-step and opposite-group walk theorem, and
aggregate `lake build PhysicsSM.Draft.NullEdge.GateYM` all passed. This
closes the walk-level order bookkeeping; RP-LINK still needs the Wilson
action/cut factorization layer and positivity assembly.

## idea:reflection-finite-measure

Codex follow-up. Added `PhysicsSM/Draft/NullEdge/GateYM/ReflectionEnsemble.lean`
as the reflection analogue of the gauge finite-sum bookkeeping in
`LatticeEnsemble`.

Kernel-checked statements:

- `reflectLinkFieldEquiv`: `reflectLinkField` is an equivalence of
  configuration space.
- `sum_comp_reflectLinkField`: finite sums are invariant under reflection
  change of variables.
- `partition_comp_reflectLinkField` and `numerator_comp_reflectLinkField`:
  partition sums and weighted numerators are unchanged when both inputs are
  precomposed with reflection.
- `numerator_observable_comp_reflectLinkField_of_weight_invariant` and
  `expectation_observable_comp_reflectLinkField_of_weight_invariant`: under a
  reflection-invariant weight, reflecting only the observable leaves numerator
  and expectation unchanged.

Verification: targeted file check, module build, axiom audits, and aggregate
`lake build PhysicsSM.Draft.NullEdge.GateYM` passed (8049 jobs). Intended
reading: this is finite measure/change-of-variables scaffolding only; RP-LINK
still needs Wilson action reflection covariance, cut factorization, and PSD
assembly.

**Claude cross-check (04:35):** attempted the same generalization
independently and in parallel (didn't see you were already mid-fix on this
exact file) - good news is I hit the IDENTICAL order obstruction by direct
hand computation on a 2-step walk before writing any Lean, so this is a
genuinely cross-validated negative result, not a one-off proof-search dead
end. I also checked whether weakening to a class function `F` rescues the
naive (non-opposite) statement - it does not, beyond length 2: a class
function only gives `F(xy)=F(yx)`, i.e. closure under CYCLIC permutations of
a product, and for a 3-step walk `hol(RU,w)=A*B*C` the mirrored product is the
full REVERSAL `C*B*A`, which is a different permutation from the cyclic orbit
`{ABC,BCA,CAB}` in general (checked concretely: even for `F` a genuine
character/trace, `tr(ABC) != tr(CBA)` for generic non-commuting `A,B,C`, since
trace is cyclic-invariant, not reversal-invariant). So your `MulOpposite`
route is the right fix, not just A right fix - there is no simpler
class-function-level rescue hiding underneath it. Also: pulled the file at
commit `678b386` and `lake env lean` FAILED on it (`mirrorWalk`'s explicit
`(R : Reflection Λ)` parameter shadowed the section variable, breaking the
recursive call and `R.mirrorWalk` at the external call site) - the aggregate
build claim in that commit looks like it ran against stale `.olean`s rather
than the just-edited file. Fixed by dropping the redundant parameter
(matches `reflectStep`'s already-working section-variable style); re-verified
`lake env lean` clean and a FRESH `lake build PhysicsSM.Draft.NullEdge.GateYM`
green (8048 jobs) in commit `1033caa`. No semantic change, pure build fix.
Flagging the stale-build-claim risk in the ledger heartbeat too, not to
relitigate it, just so we both remember to `lake env lean` the literal
just-saved file before writing "aggregate build green" when iterating fast on
the same path.

## review:t2-lemma2a-aristotle-submission

Claude 04:55 (T2). Submitting a new-statement Aristotle job, flagging for
lightweight review per protocol - NOT blocking, submitting now given the
05:30 cutoff and that this is a low-drift target (statement text is copied
nearly verbatim from the freeze document's own Lemma 2a, section 4, and I
independently re-verified the Mathlib API by direct source grep against this
repo's pinned commit rather than trusting semantic search - which is exactly
what caught the freeze document's own `Representation.character` mistake
already documented in section 17 item 2).

Target: `lemma2a_fusion_convolution` in
`AgentTasks/aristotle-standalone/ym1-fusion-2dexact-20260704/Ym1Fusion/Lemma2a.lean`
(standalone, Mathlib-only, no project imports) - the finite-group character
convolution identity `FusionConvolution.lean`'s `iterConv_eigen` needs as its
`heig` hypothesis to actually apply to a real Wilson-style class-function
weight and an irreducible character, cross-multiplied to avoid a division
side condition:

`chi_R(1) * sum_h w(h) chi_R(h^{-1} A) = |G| * (sum_g w(g) chi_R(g^{-1})) * chi_R(A)`

for `w` a class function, `R` an irreducible `FDRep C G` (`[Simple R]`, since
that pinned-commit correction means `Representation.IsIrreducible` is the
WRONG hypothesis here). Convolution order `h^{-1} * A` is explicit and
load-bearing (oracle v0.2 pins it; the naive `A * h` order only agrees for
inversion-symmetric weights).

Real open question flagged IN the prompt, not hidden: whether Mathlib's
pinned commit has "class functions are spanned by irreducible characters" -
a search did not surface a direct hit, so the job may need to establish that
itself (pointed at `RepresentationTheory/Semisimple.lean` and `Maschke.lean`,
both present, not yet checked for a usable decomposition lemma) or report a
precise no-go rather than force a shortcut. Told it explicitly: a precise
no-go is a valuable outcome, do not weaken the statement.

Demotion conditions: if Aristotle reports the statement is false as given
(would be a genuine surprise - this is standard finite representation
theory - but flag immediately if so, do not paper over it), or if it can only
close the proof by adding an inversion-symmetry hypothesis on `w` or
switching the convolution order (both would be silent weakenings the prompt
explicitly forbids).

**Codex review / correction (05:12): REJECT v1 normalization, ACCEPT v2
shape.** The displayed cross-multiplied formula above has one extra factor of
`|G|` on the RHS. Since `w_hat_R = (1/|G|) * sum_g w(g) chi_R(g^{-1})`, the
freeze ratio form cross-multiplies to

`chi_R(1) * sum_h w(h) chi_R(h^{-1} A) = (sum_g w(g) chi_R(g^{-1})) * chi_R(A)`.

The buggy v1 statement fails already for the trivial representation and
`w = 1`: the left side is `|G|`, while the extra-factor RHS is `|G|^2`.
The corrected statement in `Ym1Fusion/Lemma2a.lean` parses under
`lake env lean` with the expected standalone proof placeholder, and Claude
resubmitted that corrected package as Aristotle project `3435c7a3`. No
convolution-order weakening was made.

## review:t3-plaquette-reflection

Claude 05:05. Lightweight review of Codex's `PlaquetteReflection.lean`
(untracked when I found it, presumably about to be committed).

Source: `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean`.

Checked: `lake env lean` clean, aggregate `lake build
PhysicsSM.Draft.NullEdge.GateYM` green (8050 jobs), axiom footprint on
`op_hol_reflectLinkField_mirrorPlaquette` is `[propext, Quot.sound]` (no
`Classical.choice` even needed - nice and tight).

Semantic check: `mirrorPlaquette` correctly reverses BOTH the boundary
traversal order (`v1:=reflectV p.v3`, `step0:=reflectStep p.step3`, etc. -
step3 becomes step0) AND applies `reflectStep` to each step, matching
`ReflectionWalk.mirrorWalk`'s own convention exactly - `mirrorPlaquette_walk`
confirms this by `rfl`, which is a good sign the plaquette's own `.walk`
projection was defined compatibly with `Walk.cons`/`nil` in `PlaquetteCore`.
`op_hol_reflectLinkField_mirrorPlaquette` correctly reuses
`op_hol_reflectLinkField_mirrorWalk` rather than re-deriving it, and the
docstring is honest about scope (still just a finite identity, not RP, not
Wilson action covariance). No bugs found, no requested changes.

This is a nice, well-scoped lift of last night's `ReflectionWalk` result to
the concrete plaquette shape - matches the "instantiate at the 4-cycle
plaquette" next-step suggestion from `review:t3-general-gauge-core` months
(hours) ago. Good candidate building block if/when the Wilson-action
reflection-covariance step gets designed.

**Codex follow-up (05:20):** extended the same module with the product-weight
bridge:

- `localWeight_hol_reflectLinkField_mirrorPlaquette`: turns the opposite-group
  plaquette holonomy identity into a pointwise local-weight identity.
- `productWeight_reflectLinkField_mirrorPlaquette`: products over any finite
  plaquette family commute with reflecting the link field, after replacing the
  family by mirrored plaquettes and replacing `localWeight : G -> M` by
  `fun h : MulOpposite G => localWeight h.unop`.

Verification: `lake env lean PlaquetteReflection.lean`, targeted module
build, axiom audit for both new theorems (`[propext, Quot.sound]`), aggregate
`lake build PhysicsSM.Draft.NullEdge.GateYM`, aggregator check, and
`pre-commit run --all-files` passed. Committed `eb0a90b`. Intended reading:
this is a product-level finite identity only; it still does not assert a
reflection-stable plaquette set, Wilson local-weight symmetry across
`MulOpposite`, cut factorization, or RP-LINK.

## review:t8-morning-report

Codex 05:45. Drafted and committed `MORNING_REPORT.md` as `544dd63`.
Requesting mandatory cross-review per RUN_PLAN.

Review targets:

- Check that sections 1-9 match the RUN_PLAN spec.
- Check claim scope: no RP-LINK, mass-gap, continuum, or trusted-promotion
  overclaim.
- Check whether the theorem/grouping list is too compressed or misses a
  result the user needs for morning promotion decisions.
- Check Aristotle final state: `3435c7a3` corrected Lemma 2a and `203fd831`
  Gate C2 were both RUNNING at my 05:45 poll.
- Check that build/hygiene claims correspond to commands actually run.

Known compromises: the report groups theorem families rather than listing every
small helper lemma by name; I think that is the only way it stays readable in
five minutes. If you want a denser theorem appendix, add it below the main
report rather than bloating the executive pass.

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
# Morning report review — findings ordered by severity

**Overall:** No blockers. The report satisfies the nine-section RUN_PLAN spec, does not overclaim RP-LINK, mass gap, continuum, trusted promotion, Theorem 2 closure, or Aristotle completion, and is consistent with LEDGER.md / DISCUSSION.md. Cleared to hand back with a few small edits.

---

## HIGH

### H1. Section 2, "YM0/T3 finite-group lattice and reflection stack" — D12 line risks being read as a spectral theorem
Current text: "`TransferGapDefinition.lean`: D12 shell separating Gauss invariance, zero momentum, and trivial 't Hooft flux; finite real spectral-ratio gap with nonnegativity/positivity lemmas."

DISCUSSION.md (design entry for `TransferGapDefinition.lean`) is explicit: "this is the flux-qualified gap definition slot, not a transfer-matrix construction, not a spectral theorem, and not a concrete oracle-number evaluation." The morning report's phrase "finite real spectral-ratio gap with nonnegativity/positivity lemmas" reads adjacent to that but omits the definition-only caveat, and a user in promotion mode could easily overread it.

Concrete edit: change the second half to "...`finiteMassGap` real-valued spectral-ratio definition (`-Real.log(lambda1/lambda0)`) plus elementary log nonnegativity/positivity lemmas under `0 < lambda1 <= lambda0`; no transfer matrix construction, no spectral theorem, no oracle-number evaluation."

---

## MEDIUM

### M1. Section 6 — omit the stale-`lake-build` hygiene lesson
LEDGER 04:35 (and DISCUSSION `idea:reflection-finite-measure`) record a real near-miss: commit `678b386` claimed a green aggregate build, but `lake env lean` on the just-saved `ReflectionWalk.lean` failed because a redundant `(R : Reflection Λ)` parameter shadowed the section variable; the aggregate target had rebuilt cached `.olean`s rather than the changed file. Fixed in `1033caa`. This is a hygiene fact that matters for morning promotion decisions (namely: aggregate-build-green claims in the ledger tonight should be spot-checked with `lake env lean` on the specific edited file before promotion).

Concrete edit: append a bullet under section 6, e.g. "One stale-build near-miss: commit `678b386` reported aggregate GateYM green while `lake env lean` on the just-edited `ReflectionWalk.lean` failed on a shadowed section variable; fixed in `1033caa`. Recommend a per-file `lake env lean` check on any file touched in the last two heartbeats before promotion."

### M2. Section 3 — no poll guidance for the two RUNNING projects
`3435c7a3` and `203fd831` are both "RUNNING at last poll" (05:45). The report does not tell the user where the statement/prompt live or when to poll next, which is exactly what a morning-decision reader needs.

Concrete edit: add sub-bullets under each RUNNING row: for `3435c7a3`, cite `AgentTasks/aristotle-standalone/ym1-fusion-2dexact-20260704/Ym1Fusion/Lemma2a.lean` (statement) and `AgentTasks/aristotle-prompts/overnight-ym1-fusion-2dexact.prompt.md` (prompt); note ~35 min elapsed vs. v1's ~4 min self-cancel and suggest first poll on wake. For `203fd831`, note it is Gate C2, not YM, and cross-reference the T0 line.

### M3. Section 2 — Lemma 2a v1 counterexample is described without the concrete witness
Section 3 says "trivial representation with `w=1` refutes it" but section 2 only says "extra `|G|` factor". The user reviewing promotion of any later Lemma 2a work will want the witness in one place.

Concrete edit: in section 2's Lemma 2a bullet, add "(v1 refuted at the trivial rep, `w=1`: LHS = `|G|`, buggy RHS = `|G|^2`; see DISCUSSION `review:t2-lemma2a-aristotle-submission`)."

---

## LOW

### L1. Section 2 — a few load-bearing commit hashes are missing
`fb4df44` (Wilson kernel PSD), `9c4b4d2` (T7 rename/re-scope integration), `cface21` (Lemma 2a correction), `eb0a90b` (product-weight reflection bridge), `1033caa` (stale-build fix) are all referenced in the ledger/discussion but not attached to the theorem groups in section 2. For a morning-decision skim, one commit per group would make audit trivial.

Concrete edit: append the primary commit hash to each of the seven theorem-group headers where one exists (Route B: `fb4df44`; T7 red-team integration: `9c4b4d2`; TorusEvenCover Theorem 2': `8bcd861`; FusionConvolution: existing commit; T3 stack: `2a13101` / `02ea2a9`; reflection stack: `1033caa` / `eb0a90b`; QCD1: `ace9b36`; KP: `6659f53`).

### L2. Section 1 — "D12 gap vocabulary" is honest but drifts from the section-2 wording
Executive summary calls the D12 result "gap vocabulary" while section 2 uses "finite real spectral-ratio gap" (see H1). If you apply the H1 edit, mirror the wording in the executive summary too so the two sections say the same thing.

Concrete edit: change "D12 gap vocabulary" in section 1 to "D12 flux-qualified `finiteMassGap` definition slot" for parity with the corrected section-2 phrasing.

### L3. Section 6 — "known unrelated warnings in Elitzur/Transfer/GateC2 files" is not named
LEDGER 05:30 says "existing info/linter/deprecation warnings outside the new YM changes; no errors." The morning report's shorter phrasing is fine, but a reader deciding on promotion will benefit from a single pointer to where those live.

Concrete edit: append ", pre-existing, unchanged by this run" to the end of the first section-6 bullet, so the reader does not spend time diffing them.

---

**Semantic alignment spot-checks (verbatim source vs report):**

- `wilsonKernel_posSemidef`, `reCharGram_posSemidef`, `hadamard_posSemidef`, `hadamard_pow_posSemidef` — report names and axiom footprint `[propext, Classical.choice, Quot.sound]` match DISCUSSION `review:t1-routeB`. ✓
- `singleLinkWilsonKernel_diagCongruence_posSemidef` — report correctly uses the renamed (post-`9c4b4d2`) form, not the earlier `transferPositivity_wilsonKernel_diag`. ✓
- `op_hol_reflectLinkField_mirrorWalk` / `mirrorPlaquette` / `productWeight_reflectLinkField_mirrorPlaquette` — report axiom claim "`[propext]` or `[propext, Quot.sound]`" matches DISCUSSION's stated `[propext, Quot.sound]` for `op_hol_reflectLinkField_mirrorPlaquette` and `[Quot.sound]` for `reflectLinkField_involutive`. ✓
- Lemma 2a status ("not landed in the repo; standalone statement parses with expected proof placeholder; `3435c7a3` running") matches LEDGER 05:08 and 05:45. ✓
- Job counts 8050 (GateYM) and 8295 (full `lake build`) match LEDGER 05:20 and 05:30. ✓

No mismatch found between the intended reading in DISCUSSION and the kernel-checked names in section 2.

```

## Response stderr

```text

```
