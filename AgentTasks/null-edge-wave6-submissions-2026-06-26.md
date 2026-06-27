# Null-edge Aristotle wave 6 submissions - 2026-06-26

Context: launched after the integrated Gate A/B/C/Krein/native-decision wave. The batch is designed to preserve honest gate discipline while continuing useful finite/proof-engineering work.

## Submitted jobs

| Slug | Aristotle project id | Kind | Expected deliverable |
| --- | --- | --- | --- |
| `native-decision-audit` | `ddcfe2e0-fe40-4da5-85c6-83df29696166` | focused Lean/proof-engineering audit | `AgentTasks/null-edge-native-decision-structuralization-report.md` |
| `gate-c-redesign` | `d469c75e-dd37-4b60-8c59-d0a4033855f8` | no-build strategy/audit | `AgentTasks/null-edge-gate-c-redesign-roadmap.md` |
| `gate-a-closeout` | `dfb12c77-cb53-4ad4-a526-d2e436696bd0` | no-build theorem-interface/conventions audit | `AgentTasks/null-edge-gate-a-closeout.md` |
| `b4-square-rebase` | `282407b7-e751-4783-bebc-b0eb43de4977` | no-build proof-planning | `AgentTasks/null-edge-b4-square-rebase-plan.md` |
| `furey-null-edge-internal-spectrum` | `700ef21a-df8e-42d0-b842-3d229c968bb3` | no-build formal-interface strategy | `AgentTasks/null-edge-furey-internal-spectrum-bridge.md` |
| `publication-split` | `722ffd82-505a-4a4e-9dca-ae9a1e2172fa` | no-build publication strategy | `AgentTasks/null-edge-publication-split-after-wave6.md` |
| `promotion-bridge` | `72faceb1-fc4d-4fe8-8c0d-6dccc378cf96` | no-build integration/promotion triage | `AgentTasks/null-edge-wave6-promotion-bridge.md` |

## Packaging notes

- The first attempt to submit `native-decision-audit` against the full repo failed because Aristotle does not support the repo's local `SpherePacking` dependency in full-project packaging.
- The job was resubmitted as a focused file bundle containing Lean files with the native decision tactic token, the null-edge sign-audit report, conventions/build notes, and AGENTS guidance.
- Aristotle warned that the focused native-decision bundle has Lean files but no full `lean-toolchain` / `.lake` dependency context. Treat that job primarily as an audit and structural-replacement proposal unless it returns independently checkable patches.

## Guardrails sent

- Draft code may temporarily use the native decision tactic for fast iteration when kernel `decide` is slow.
- Published/trusted code should prefer structural proofs or certified finite tables.
- The ideal target is a structural replacement that is at least as fast as native evaluation and avoids both slow `decide` and native evaluation.
- No finite-square promotion before Gate A.
- No continuum/no-doubling promotion before Gate C.
- Krein self-adjointness remains Lorentzian hygiene, not stability.

## Integration (2026-06-26)

All seven jobs integrated. Six are no-build strategy/audit deliverables placed at their
expected `AgentTasks/` paths; the `native-decision-audit` additionally shipped a verified
code improvement.

| Job | Deliverable | Notable content |
| --- | --- | --- |
| `native-decision-audit` | `null-edge-native-decision-structuralization-report.md` **+ structuralized `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean`** | Replaced the 4 `native_decide` matrix proofs with structural kernel-checked proofs (statements unchanged by diff; axioms now `propext, Classical.choice, Quot.sound`; trust holes gone). Companion super-Dirac report updated. Inventory of 354 native uses across 40 files classified (trusted-tree E8/coding fixtures documented as draft-trust, safe to leave). |
| `gate-c-redesign` | `null-edge-gate-c-redesign-roadmap.md` | Gate C verdict **FATAL-FOR-NAIVE-FLAT (settled)**; per-branch classification PENDING; 8-column checklist; 6 ranked redesign families each with a fast finite falsification test. |
| `gate-a-closeout` | `null-edge-gate-a-closeout.md` | Gate A **pass-ready** bar one bridge theorem `super_dirac_square_named` + A3 CONVENTIONS edits; 4-layer promotion-safe interface; 6 convention-lock recommendations. |
| `b4-square-rebase` | `null-edge-b4-square-rebase-plan.md` | Rebase plan routing `C_a` through `NullSolderFrame.cliffordCoeff` (dualBasis carrier); B0->B1->B3->B2->B4 order; `NullEdgeFiniteSquareRebase` skeleton. |
| `furey-null-edge-internal-spectrum` | `null-edge-furey-internal-spectrum-bridge.md` | `NullEdgeInternalSpectrum` interface; Furey supplies spectrum/anomaly **not** mass; F1-F5 follow-up jobs. |
| `publication-split` | `null-edge-publication-split-after-wave6.md` | 5-manuscript sequence (P1 -> P1.5 -> Gate C no-go -> position paper -> Furey appendix) with per-paper theorem inventories and reviewer-risk table. |
| `promotion-bridge` | `null-edge-wave6-promotion-bridge.md` | Per-file promotion buckets; EW stabilizer + SM anomaly arithmetic are promotion-ready (clean), with the caveat that none yet carries the machine-checkable convention banner. |

Verification: structuralized Lean builds (full `lake build PhysicsSMDraft` exit 0, 8675 jobs),
axioms clean; six markdown docs are no-build; pre-commit clean. The six strategy/audit docs
are recommendations, not proofs -- no CONVENTIONS.md / manuscript / Lean promotion is performed
here. Two are flagged for deliberate follow-up: the Gate A closeout's `super_dirac_square_named`
bridge theorem (the last thing gating Gate A pass), and the promotion-bridge's prerequisite
that a convention banner be attached before promoting the EW/anomaly files.
