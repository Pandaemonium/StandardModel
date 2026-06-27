# Null-edge Wave 16 Aristotle submissions

Date: 2026-06-26.

Purpose: follow up on the returned null-edge/Furey/Baez/true-gauge strategy job without colliding with Claude's integration of `9afa6db8-c23a-4aa2-8411-45938eedecc4` or the still-running Wave 15 jobs.

Source report:

- `AgentTasks/null-edge-furey-gauge-integration-strategy-report.md`

Context pack:

- `AgentTasks/context-packs/null-edge-wave16-furey-gatec-followups-20260626-222118.md`

| ID | Task note | Aristotle project | Task | Status |
| --- | --- | --- | --- | --- |
| FUR-G1 | `AgentTasks/null-edge-wave16-fur-g1-octonion-occupation-bridge-aristotle-2026-06-26.md` | 2ccea9b0-9781-4994-9a96-8a258303efed | aff5c1a0-e708-4c45-bebf-3449cd2fbcc1 | submitted |
| FUR-G2 | `AgentTasks/null-edge-wave16-fur-g2-true-gauge-phih-descent-aristotle-2026-06-26.md` | 102e5d55-2e9c-4fd3-acf1-277d67c28844 | 67470909-c75a-45ac-85cc-70ea3317d1d9 | submitted |
| FUR-G3 | `AgentTasks/null-edge-wave16-fur-g3-involution-distinctness-aristotle-2026-06-26.md` | 6e18cb1e-59ce-4150-83ca-1943c667287c | 193cb6d9-18e2-4c35-89c6-a736408bf47d | submitted |
| M14 | `AgentTasks/null-edge-wave16-m14-anomaly-crosswalk-stale-note-audit-aristotle-2026-06-26.md` | ec05debe-65e4-452a-ba35-8b8c30a8dc80 | bafd7ff0-c4b8-40da-a25c-8d00bbcc54f1 | submitted |
| C66 | `AgentTasks/null-edge-wave16-c66-cyclotomic-nodal-set-aristotle-2026-06-26.md` | 69eeea7d-c900-40ab-bc2c-041199181144 | 197fa034-2759-4317-acde-797880b74589 | submitted |
| C69 | `AgentTasks/null-edge-wave16-c69-off-branch-zero-sector-audit-aristotle-2026-06-26.md` | b779fab8-584e-4401-9fd5-2367ae5ff624 | 910a387c-aa68-463a-815c-bfd4ddd3a2d9 | submitted |

Non-duplication notes:

- Do not submit the FUR-H10/Yukawa moduli audit again while `40b43a57-f6c6-4f66-ab48-54e377697bc9` is running.
- Do not submit a conjugate-ideal coordinate bridge while Claude is integrating `9afa6db8-c23a-4aa2-8411-45938eedecc4`.
- `c594a01d-78a7-474a-b613-c993c86a6f30` is still running, so avoid overlapping its target until it lands.

## Integration - 2026-06-27

Three Wave-16 jobs were idle and are integrated (C69, FUR-G2, M14); FUR-G1
(`2ccea9b0`), FUR-G3 (`6e18cb1e`), C66 (`69eeea7d`) are still running. The
source strategy job (`91143892`) report was also saved. All new theorems depend
only on `propext, Classical.choice, Quot.sound` (no `sorry`/`native_decide`).
Both packages were full-repo; only the genuinely-new modules were taken.
Verified `lake build PhysicsSMDraft` exit 0 (8714 jobs).

| Job | Lean | Report | Headline |
| --- | --- | --- | --- |
| C69 | **new** `PhysicsSM/Draft/NullEdgeOffBranchZeroSector.lean` | `null-edge-off-branch-zero-sector-audit-report.md` | **Off-branch zero sector audit (the C64 blocker, characterized).** For the C64 off-branch zero `q* = (2pi/3,0,0,4pi/3)`, the per-branch Gate-C machinery (branch label, projected-sector membership, Krein sign, residue, ghost class) is **undefined**: it is all indexed by the four-branch label `Fin 4`, and `q*` provably lies on no branch line (two vanishing retarded components, not one). Only the universal null-covector Weyl split applies, and it does not discriminate/clear `q*`. `OffBranchZero` predicate; `OffBranchZero.mink_zero` (genuine null-slash determinant zero); `offBranch_nonempty` (the C64 witness inhabits it); `OffBranchSectorDischarged` + `offBranch_discharged_ghostSafe` + `offBranch_audit_status` package the honest status: the off-branch sector is a separate, currently-undischarged Gate-C obligation, not coverable by the existing four-branch projected-release certificate. Kernel-clean (4 theorems). |
| FUR-G2 | **new** `PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean` | `null-edge-fur-g2-true-gauge-phih-note.md` | **`Phi_H` descends to the TRUE Standard Model gauge surface.** Wires the legal `GaugeCovariantPhiH` interface (parametric over `Monoid G`) to `SMCoveringQuotient` -- the actual `Z6`-quotient of the `U(1)xSU(2)xSU(3)` cover proven equivalent to `S(U(2)xU(3))`. `phiH_proper_trueQuotient`, `phiH_gauge_covariant_trueQuotient`: `Phi_H` is gauge-covariant for the true quotient group, not just an abstract block. `CoverFactoringPhiH` + `descend_op`/`descend_act_mk`/`descend_kernel_trivial` (the `Z6` kernel acts trivially, so the cover action **factors through** the quotient)/`descend_isProperPhiH`. Upgrades the internal mass block from "gauge-covariant for some group" to "gauge-covariant for the physical SM gauge group with its correct global structure". Kernel-clean (8 theorems incl. nested `CoverFactoringPhiH`). |
| M14 | (none -- report-only docstring audit) | `null-edge-anomaly-crosswalk-stale-note-audit-report.md` | **Stale-note audit.** Confirms the real octonion/Furey/anomaly stack IS present (`Algebra/Octonion/*`, `Algebra/Furey/*` incl. `AnomalyBridge.Q_op_*`), but two draft files' **docstrings/NOTES** still describe an older incomplete checkout as if the octonion stack were absent and a self-contained anomaly package had to be reconstructed. Stale text is docstring-only -- no Lean statements affected. Recommends docstring corrections (not auto-applied). |
| (source) | (none -- strategy) | `null-edge-furey-gauge-integration-strategy-report.md` | The Wave-16 source strategy report. Key finding: the repo holds three strong but **largely disjoint** formal islands (Furey octonion `J`/anomaly, true-gauge `Z6`, null-edge operator) plus the conditional Gate C island; **no null-edge file imports any `Algebra/Furey/*` or `Algebra/Octonion/*` module** -- the null-edge "Furey" bridge connects only through the shared `standardModelOneGeneration` table and an occupation-lattice stand-in. The "octonion stack absent" docstring claim is stale; the gap is closeable today (FUR-G1/G2 are the closers). |

K3 (`bdc375cc-4a52-4650-b5ce-220e2454e5ca`, Wave 15) was already integrated separately
as `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean` (no new file in its package). Its
verdict: **no-go** -- the branch Krein pattern is totally free (`krein_pattern_totally_free`:
all 2^4 sign patterns are realized by some valid fundamental symmetry), so the retained
`{0,2}` sector is only canonical *relative to a locked Krein-sign input*, and `-kreinJ`
(the retarded<->advanced sheet exchange) is an equally valid metric flipping `{0,2}<->{1,3}`.

### Integration note: C66 completed, 2026-06-27

Project `69eeea7d-c900-40ab-bc2c-041199181144` returned complete and was integrated as `PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean`, with report `AgentTasks/null-edge-wave16-c66-cyclotomic-nodal-set-REPORT.md`.

## Integration update, 2026-06-27

- FUR-G2 (`102e5d55-2e9c-4fd3-acf1-277d67c28844`) is integrated; target `PhysicsSM/Draft/NullEdgeFureyTrueGaugePhiH.lean` was already byte-identical and the summary is preserved.
- M14 (`ec05debe-65e4-452a-ba35-8b8c30a8dc80`) is integrated; full report and stale-note/doc corrections are applied.
- C69 (`b779fab8-584e-4401-9fd5-2367ae5ff624`) is integrated; full report is applied and the Lean module was already byte-identical.
