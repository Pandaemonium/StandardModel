# FUR-H9A conjugate-ideal -> live Jbar coordinate bridge -- returned summary

Provenance: returned `ARISTOTLE_SUMMARY.md` for Summary of changes for run 6386749c-2fab-4e3d-8de9-62a1530f79b5
Full-repo package; the only new file is
`PhysicsSM/Draft/NullEdgeFureyJbarCoordinateBridge.lean`. The package also carried
older snapshot copies of five existing modules (NullEdgeProjectedGateCRelease,
NullEdgeCompositeZeroEscape, NullEdgeSpeciesSplitNodalLine,
NullEdgeFureyAlmostCommutativeProduct, NullEdgeFureyChiE); those differ only by the
pre-commit final-newline fix (repo is newer) and were NOT overwritten. This is the
returned summary, preserved verbatim as the integration record.

---

## Task FUR-H9A — Minimal `ConjugateIdeal` → live `Jbar` coordinate bridge: COMPLETE

I created `PhysicsSM/Draft/NullEdgeFureyJbarCoordinateBridge.lean` (registered in `PhysicsSMDraft.lean`), a kernel-checked compatibility bridge between the conjugate-ideal coordinate model (`PhysicsSM/Algebra/Furey/ConjugateIdeal.lean`) and the live `Jbar` coordinate/eigenvalue machinery (`JbarCoordinateEquiv`, `QopJEigenBridge`, `ElectroweakBridge`, `T3OpJbar`). It builds successfully; the main results depend only on `propext`, `Classical.choice`, `Quot.sound`. No `sorry`, `axiom`, `opaque`, or `unsafe`.

### Key structural finding
Both sides model their 8-state ideal as `Fin 8 → ℂ` with the standard basis `Pi.single i 1`, so the coordinate spaces are *definitionally equal* and the bases agree on the nose. The genuinely new content is the index-ordering relation between the two raw `Q_op` charge tables.

### Theorems proved (namespace `PhysicsSM.Draft.NullEdgeFureyJbarCoordinateBridge`)
- `coordSpace_eq`, `conjIdeal_basis_eq_jbar_basis` — coordinate spaces and bases coincide.
- `coordEquiv`, `coordToJbarSubmodule`, `coordToJbarSubmodule_basis` — an explicit `ℂ`-linear equivalence from the conjugate-ideal coordinate model all the way to the octonionic minimal left ideal `Jbar' ⊆ ℂ⊗𝕆` (reusing the live `jbarCoordinateEquivPackage`), sending `JstarBasis i ↦ JbarBasisState' i`.
- `jbarRelabel = Fin.revPerm` with `qJ_eq_rawQopJ` (same-convention agreement with `rawQopJ`) and `qJ_eq_rawQop_relabel` (`qJ i = rawQop i.rev`, the Furey↔Jbar reversal relabeling matching the neutrino-first `Jbar` order).
- `qJstar_eq_neg_rawQopJ` — the conjugation convention (`qJstar = -rawQopJ`).
- `ConjugateIdealJbarBridge` / `conjugateIdealJbarBridge` — bundled package.

### Conventions recorded
XOR octonion basis, Fano orientation, and Furey labels are inherited unchanged from the imported live modules; the Furey/Jbar relabeling is the index reversal `Fin.rev` (electron-first ↔ neutrino-first), the unique order-reversing map matching the two raw charge tables; conjugation is coordinatewise complex conjugation, negating charges.

### Boundary / what remains conditional
This is a finite coordinate/charge-table bridge; all octonionic content is reused from the live modules. Listed follow-ups (out of scope) in the report: a separate `T₃`/hypercharge action-table bridge for the right-handed singlets (singlets have `T3=0`, so they need a separate table rather than a relabeling of the doublet table), and an operator-level (rather than table-level) intertwining of `Q_op`.

Deliverables: the Lean module, `ARISTOTLE_SUMMARY.md`, and `AgentTasks/null-edge-fur-h9a-jbar-coordinate-bridge-report.md`.

Note: the submission package was missing the optional `SpherePacking` dependency directory required to configure the Lake workspace; I restored it via the existing `lakefile.toml` git require so the project configures. The new module depends only on Mathlib and the Furey modules, not on SpherePacking.

# Aristotle summary — Task FUR-H9A

## Goal

Provide a *minimal* compatibility bridge from the conjugate-ideal coordinate
model in `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean` to the live `Jbar`
coordinate / eigenvalue machinery
(`PhysicsSM/Algebra/Furey/JbarCoordinateEquiv.lean`, `QopJEigenBridge`,
`ElectroweakBridge`, `T3OpJbar`).

## Deliverable

New experimental module
`PhysicsSM/Draft/NullEdgeFureyJbarCoordinateBridge.lean` (registered in
`PhysicsSMDraft.lean`).  It builds cleanly and is kernel-checked: the main
results depend only on `propext`, `Classical.choice`, `Quot.sound`.

## What was proved

All statements are in namespace
`PhysicsSM.Draft.NullEdgeFureyJbarCoordinateBridge`.

1. **Coordinate-space identification** (`coordSpace_eq`): the conjugate-ideal
   coordinate space `ConjugateIdeal.V` and the live wavefunction space
   `OperatorElectroweakIdentity.JbarWavefunction` are the *same* space
   `Fin 8 → ℂ` (definitional equality).

2. **Basis-label agreement** (`conjIdeal_basis_eq_jbar_basis`): the conjugate
   ideal basis `ConjugateIdeal.JstarBasis i` equals the live coordinate basis
   `T3OpJbar.JbarBasisState i` on the nose (both are `Pi.single i 1`).

3. **Bridge to the octonionic ideal** (`coordEquiv`, `coordToJbarSubmodule`,
   `coordToJbarSubmodule_basis`): an explicit `ℂ`-linear equivalence
   `ConjugateIdeal.V ≃ₗ[ℂ] Jbar'` from the conjugate-ideal coordinate model to
   the octonionic minimal left ideal `Jbar' ⊆ ℂ⊗𝕆`, obtained by composing the
   identity coordinate equivalence with the live
   `MinimalLeftIdeal.jbarCoordinateEquivPackage`.  Under this bridge,
   `JstarBasis i` maps to the octonionic basis state `JbarBasisState' i`.

4. **Charge-table compatibility**:
   - `qJ_eq_rawQopJ`: the conjugate-ideal `J`-sector charge table
     `ConjugateIdeal.qJ` equals the live `Q_op` eigenvalue table
     `QopJEigenBridge.rawQopJ` in the same (electron-first) index convention.
   - `qJ_eq_rawQop_relabel`: under the **Furey ↔ Jbar relabeling**
     `jbarRelabel = Fin.revPerm`, `qJ i = ElectroweakBridge.rawQop i.rev`,
     matching the neutrino-first `Jbar` index order.
   - `qJstar_eq_neg_rawQopJ`: the conjugation convention,
     `qJstar i = - rawQopJ i`.

5. **Bundled package** (`ConjugateIdealJbarBridge`,
   `conjugateIdealJbarBridge`): all of the above assembled into one structure.

## Conventions recorded

- **XOR octonion basis / Fano orientation / Furey labels**: inherited verbatim
  from the imported live modules; the bridge introduces no new octonion
  multiplication or Fano line orientation.
- **Furey/Jbar relabeling**: the electron-first `J`-order
  (`0=omega(e), 1..3, 4..6, 7=nu`) of `qJ`/`rawQopJ` maps to the neutrino-first
  `Jbar`-order (`0=nu, 1..3 (d), 4..6 (u), 7=e`) of `rawQop` via the index
  reversal `Fin.rev` — the unique order-reversing map matching the two raw
  charge tables.
- **Conjugation convention**: `ConjugateIdeal.Cconj` is coordinatewise complex
  conjugation; on charges it negates, `qJstar = - qJ = - rawQopJ`.

## Conditional / boundary

This is a finite coordinate / charge-table compatibility bridge, in the style of
the project's existing bridge files. All octonionic content is reused from the
live modules through `jbarCoordinateEquivPackage`; the only genuinely new fact
is that the two index labellings match under the explicit reversal relabeling.
No mass values and no three-generation claim are made. Nothing was weakened and
no axioms/opaque placeholders were introduced.

## Build / environment note

The submission package was missing the optional `SpherePacking` dependency
directory required to configure the Lake workspace; it was restored via
`lake update SpherePacking` (matching the existing `lakefile.toml` git require).
The new module itself depends only on Mathlib and the Furey modules, not on
SpherePacking. It was verified by building the target
`PhysicsSM.Draft.NullEdgeFureyJbarCoordinateBridge` and checking its axioms.
