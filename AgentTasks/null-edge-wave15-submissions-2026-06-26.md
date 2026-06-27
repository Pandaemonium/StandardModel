
# Null-edge Aristotle Wave 15 submissions - 2026-06-26

Purpose: follow-up after partial Wave 14 integration. `c65` succeeded and is integrated. `c63` and `c64` remain running. The broad Furey bridge jobs `fur-h7`, `fur-h8`, and `fur-h9` ended out of budget without summaries, so this wave splits them into narrower targets.

| Job | Status | Prompt | Aristotle project ID | Submission project |
|---|---|---|---|---|
| fur-h7a-phi-h-coordinate-bridge | pending | `AgentTasks/aristotle-wave15-20260626-prompts/fur-h7a-phi-h-coordinate-bridge.md` | | |
| fur-h8a-number-parity-occupation-api | pending | `AgentTasks/aristotle-wave15-20260626-prompts/fur-h8a-number-parity-occupation-api.md` | | |
| fur-h9a-jbar-coordinate-minimal-bridge | pending | `AgentTasks/aristotle-wave15-20260626-prompts/fur-h9a-jbar-coordinate-minimal-bridge.md` | | |
| fur-h10-yukawa-intertwiner-dimension-audit | pending | `AgentTasks/aristotle-wave15-20260626-prompts/fur-h10-yukawa-intertwiner-dimension-audit.md` | | |
| k3-krein-lock-origin-or-nogo | pending | `AgentTasks/aristotle-wave15-20260626-prompts/k3-krein-lock-origin-or-nogo.md` | | |

## Intended outputs

| Job | Intended output |
|---|---|
| FUR-H7A | `PhysicsSM/Draft/NullEdgeFureyPhiHCoordinateBridge.lean` plus report if useful. |
| FUR-H8A | `PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean` plus report if useful. |
| FUR-H9A | `PhysicsSM/Draft/NullEdgeFureyJbarCoordinateBridge.lean` plus report if useful. |
| FUR-H10 | `PhysicsSM/Draft/NullEdgeFureyYukawaIntertwinerAudit.lean` or report-only audit. |
| K3 | `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean` or precise no-go report. |

## Submission results - 2026-06-26

Submission project: `AgentTasks/aristotle-submit/null-edge-wave15-furey-krein-narrow-20260626-project`

| Job | Return code | Aristotle project ID | Raw result |
|---|---:|---|---|
| fur-h7a-phi-h-coordinate-bridge | 0 | `c594a01d-78a7-474a-b613-c993c86a6f30` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: c594a01d-78a7-474a-b613-c993c86a6f30` |
| fur-h8a-number-parity-occupation-api | 0 | `a7de5ef8-3050-4aeb-8008-d45afc1ef85f` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: a7de5ef8-3050-4aeb-8008-d45afc1ef85f` |
| fur-h9a-jbar-coordinate-minimal-bridge | 0 | `9afa6db8-c23a-4aa2-8411-45938eedecc4` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: 9afa6db8-c23a-4aa2-8411-45938eedecc4` |
| fur-h10-yukawa-intertwiner-dimension-audit | 0 | `40b43a57-f6c6-4f66-ab48-54e377697bc9` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: 40b43a57-f6c6-4f66-ab48-54e377697bc9` |
| k3-krein-lock-origin-or-nogo | 0 | `bdc375cc-4a52-4650-b5ce-220e2454e5ca` | `WARNING: Your project contains .lean files but no .lake folder. Aristotle works better with access to your project's dependencies. Did you forget to run `lake build`? Project created: bdc375cc-4a52-4650-b5ce-220e2454e5ca` |

## Integration - 2026-06-26

FUR-H8A (`a7de5ef8-3050-4aeb-8008-d45afc1ef85f`) and FUR-H9A
(`9afa6db8-c23a-4aa2-8411-45938eedecc4`) completed and are integrated; the other
three wave-15 jobs (fur-h7a `c594a01d`, fur-h10 `40b43a57`, k3 `bdc375cc`) are
still running. (Note: a `NullEdgeKreinLockOrigin` module is already present in the
tree, so k3's target may have been integrated separately.)

| Job | Lean | Report | Headline |
| --- | --- | --- | --- |
| FUR-H9A | **new** `PhysicsSM/Draft/NullEdgeFureyJbarCoordinateBridge.lean` | `null-edge-fur-h9a-jbar-coordinate-bridge-report.md` | **Conjugate-ideal -> live Jbar coordinate/charge bridge** (the right-handed/antiparticle-sector connection flagged as the next Furey gap). Connects the `Furey/ConjugateIdeal` coordinate model to the live `Jbar` eigenvalue machinery (`JbarCoordinateEquiv`, `QopJEigenBridge`, `ElectroweakBridge`, `T3OpJbar`). `coordSpace_eq` / `conjIdeal_basis_eq_jbar_basis`: both model the 8-state ideal as `Fin 8 -> C` with `Pi.single` basis, definitionally equal. `coordToJbarSubmodule_basis`: explicit C-linear equivalence all the way to the octonionic minimal left ideal `Jbar' subset C(x)O` (reusing `jbarCoordinateEquivPackage`), `JstarBasis i |-> JbarBasisState' i`. Charge-table compatibility: `qJ_eq_rawQopJ` (same convention), `qJ_eq_rawQop_relabel` (Furey<->Jbar relabel is the index reversal `Fin.rev`, electron-first <-> neutrino-first), `qJstar_eq_neg_rawQopJ` (conjugation negates charges). Bundled as `conjugateIdealJbarBridge`. Boundary: finite coordinate/charge-table bridge; the separate `T3`/hypercharge action table for right-handed singlets (which have `T3=0`) and an operator-level `Q_op` intertwining are noted as out-of-scope follow-ups. Full-repo package; only this module is new (5 other "changed" files were stale snapshot copies differing only by the final-newline fix -- NOT overwritten). Kernel-clean (7 theorems; `propext, Classical.choice, Quot.sound`; no `sorry`/`native_decide`). Verified `lake build PhysicsSMDraft` exit 0 (8712 jobs). |
| FUR-H8A | **new** `PhysicsSM/Draft/NullEdgeFureyOccupationParityChiE.lean` | `null-edge-fur-h8a-occupation-parity-chiE-note.md` | **Concrete internal `chi_E` = occupation-number parity on the Furey 8-state model.** Realizes the abstract null-edge internal grading on the same `Occ = Finset (Fin 3)` occupation states that power `NullEdgeFureyInternalSpectrum`: `occParitySign s = (-1)^|s|`, `chiEParity = diagonal occParitySign`. Proves it is an honest `Z/2` grading (`chiEParity_mul_self`, `chiEParity_isZ2Grading`); **distinct from the FUR-H2 complex structure** (`chiEParity_not_complexStructure`/`chiEParity_ne_complexStructure` -- squares to `+1` not `-1`, the genuine non-complex involution FUR-H2 found missing); **separates the spectrum** into two charge-disjoint 4-state classes `{0,-2/3,-2/3,-2/3}` vs `{-1/3,-1/3,-1/3,-1}` swapped by charge conjugation (occupation complement). Mass-sector kept honest: `H7A PhiH := IsOdd chiEParity PhiH` is a named hypothesis (not forced); `chiEParity_tachyonic_under_H7A` gives `(chiEParity.PhiH)^2 = -(PhiH^2)` under it; `H7A_satisfiable` shows it non-vacuous. Full-repo package; only this module is new (all other tree files unchanged context). Structural theorems kernel-clean (`propext, Classical.choice, Quot.sound`); finite-enumeration theorems use `native_decide` (draft-trust, documented in docstring per policy, matching the sibling `NullEdgeFureyInternalSpectrum`). Verified: `lake build PhysicsSMDraft` exit 0 (8708 jobs). |


## Missed-result integration addendum - 2026-06-26

A follow-up sweep found that `k3-krein-lock-origin-or-nogo` had completed after
Claude's note. It has now been integrated.

| Job | File | Result |
|---|---|---|
| K3 | `PhysicsSM/Draft/NullEdgeKreinLockOrigin.lean`; `AgentTasks/null-edge-k3-krein-lock-origin-report.md` | Proves a no-go: the branch Krein pattern is not derivable from the currently formalized data. All sign patterns are compatible with the abstract fundamental-symmetry axioms, and the global orientation flip exchanges the retained sector. An explicit sheet/causal orientation lock is the missing datum that feeds C65. |

### Integration note: FUR-H7A completed, 2026-06-27

Project `c594a01d-78a7-474a-b613-c993c86a6f30` returned complete and was integrated as `PhysicsSM/Draft/NullEdgeFureyPhiHCoordinateBridge.lean`, with report `AgentTasks/null-edge-fur-h7a-phi-h-coordinate-bridge-report.md`.

The draft aggregator imports `PhysicsSM.Draft.NullEdgeFureyPhiHCoordinateBridge`.
