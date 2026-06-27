# Wave 16 M14 — anomaly crosswalk & stale-note audit report

Date: 2026-06-27.
Job type: no-build audit / manuscript-crosswalk (no proof obligations).
Canonical prompt: `AgentTasks/null-edge-wave16-m14-anomaly-crosswalk-stale-note-audit-aristotle-2026-06-26.md`.

## TL;DR

The strategy report's suspicion is **confirmed**. The real octonion / Furey /
anomaly stack is present in the project (`PhysicsSM/Algebra/Octonion/*`,
`PhysicsSM/Algebra/Furey/*`, including the coordinate eigenvalue theorems
`AnomalyBridge.Q_op_*`), but two *draft* files still carry "octonion stack
absent / self-contained anomaly package reconstructed" language describing an
older incomplete checkout. The stale text is confined to:

- `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` (module docstring,
  "Import boundary" section), and
- `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md` ("Import boundary
  (this checkout is incomplete)" and "Building" sections).

No Lean *statements* are affected — only docstrings/notes. The two draft
modules' actual theorems remain correct: they intentionally use a lightweight
occupation-lattice stand-in, which is a legitimate modelling choice, not a
forced workaround. The manuscripts (`Working_Plan`, `Roadmap_Improved`) contain
no stale "octonion absent" claims (their "reconstructed/absent" hits are
unrelated physics prose) and need no edits.

These two local doc corrections have been applied as part of this audit (see
"Files changed").

## Answers to the five prompt questions

### 1. Do the null-edge and Furey islands use the same `standardModelOneGeneration` and anomaly predicates?

**Yes — one shared source of truth.** Both islands import
`PhysicsSM.StandardModel.AnomalyPackage` and use *its*
`standardModelOneGeneration : List ChiralMultiplet`,
`LocalAnomalyFree`, and `WittenSU2AnomalyFree`.

- Furey island: `PhysicsSM/Algebra/Furey/AnomalyBridge.lean`,
  `OneGenerationPackage.lean`, and `FureyRealizesOneGeneration.lean` all
  `open PhysicsSM.StandardModel.AnomalyPackage` and refer to that
  `standardModelOneGeneration` / `LocalAnomalyFree` / `WittenSU2AnomalyFree`.
- Null-edge island: `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` defines
  thin wrappers
  `NullEdge.NullEdgeInternalSpectrum.LocalAnomalyFree S :=
  AnomalyPackage.LocalAnomalyFree S.multiplets` and
  `…WittenSU2AnomalyFree S := AnomalyPackage.WittenSU2AnomalyFree S.multiplets`,
  and `RealizesOneGeneration S := S.multiplets = standardModelOneGeneration`
  (the same `standardModelOneGeneration`).
- The computed bridge `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`
  defines `computedFureyJMultiplets := standardModelOneGeneration` and
  `fureyStyleRealization_eq_computedJ : fureyStyleRealization =
  fureyJInternalSpectrum := rfl`, i.e. it reduces to the same table.

There is a single `AnomalyPackage.lean` file in the tree; both islands import
it, so there is **no** divergent "reconstructed" copy living alongside the real
one. The earlier "self-contained reconstruction" is now simply this shared,
Mathlib-only package, which `AnomalyBridge.lean` also imports.

### 2. Which notes/docstrings are now stale or misleading?

Two locations, both documentation only:

(a) `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`, module docstring
section **"Import boundary (why the octonion `Q_op` theorems are not used
directly)"** (≈ lines 30–42). It states the octonion stack
(`ComplexOctonion`, `LadderOperators`, `OperatorRepresentations`,
`MinimalLeftIdeal`, …) "is **absent from this checkout**, so the eigenvalue
theorems `Q_op_omega_bar`, `Q_op_vbar1`, …, `Q_op_nu_bar` cannot be imported."
This is false: those modules exist and the `Q_op_*` theorems are proved in
`PhysicsSM/Algebra/Furey/AnomalyBridge.lean` (lines ≈ 277–449).

(b) `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md`, sections
**"Import boundary (this checkout is incomplete)"** and **"Building"**. They
claim the checkout "is missing the foundational modules" (lists
`ComplexOctonion`, `LadderOperators`, `OperatorRepresentations`,
`AnomalyPackage`, `OneGenerationTable`, …), that "none of the originally-shipped
`.lean` files compiled", that `AnomalyPackage.lean` "was reconstructed here as a
self-contained … development", and that "whole-library `lake build` still fails
on the other absent octonion modules". All of these are stale: the listed
modules are present, and `AnomalyPackage.lean` is the shared package imported by
the live Furey bridge.

Not stale / no change needed:
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` and
  `Sources/NullStrand_Lean_Roadmap_Improved.md`: their "reconstructed/absent"
  occurrences are unrelated physics prose (kinetic-term reconstruction,
  zero-mode absence), not the octonion-stack claim.
- The convention/scope docstrings in both draft files ("all-left vs. physical
  Dirac basis", "no `Φ_H`/Yukawa/Gate-C content", electroweak-bridge boundary)
  are accurate and should be kept verbatim.

### 3. What exact local edits should replace the "octonion stack absent" language?

Two surgical, build-neutral docstring/comment edits (applied in this audit).

**(a) `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean`** — replace the
"Import boundary" paragraph (lines 30–42) with:

```text
## Import boundary (why the octonion `Q_op` theorems are not imported here)

The octonion stack that defines the *coordinate* realization of the `J` states
and the operator `Q_op` — `PhysicsSM.Algebra.Octonion.ComplexOctonion`,
`PhysicsSM.Algebra.Furey.LadderOperators`,
`PhysicsSM.Algebra.Furey.OperatorRepresentations`,
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal`, … — is **present in the project**,
and the eigenvalue theorems `Q_op_omega_bar`, `Q_op_vbar1`, …, `Q_op_nu_bar`
are proved in `PhysicsSM.Algebra.Furey.AnomalyBridge`.  This module
deliberately stays on the lighter occupation-lattice model rather than pulling
in that stack: the lattice lives at exactly the number-operator level on which
those theorems operate, and reproduces the same charge multiset
`{0, -1/3, -1/3, -1/3, -2/3, -2/3, -2/3, -1}` proved there for `Jbar`
(equivalently, the reversed multiset for `J`).  For the fully
coordinate-derived statement see `AnomalyBridge.Q_op_*` and
`FureyRealizesOneGeneration.fureyRealizesOneGenerationPackage`.
```

**(b) `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md`** — replace the
"Import boundary (this checkout is incomplete)" and "Building" sections with a
single accurate "Import boundary / build" section:

```text
## Import boundary and build

The foundational Furey/octonion modules are present in the project
(`PhysicsSM.Algebra.Octonion.ComplexOctonion`,
`PhysicsSM.Algebra.Furey.LadderOperators`,
`PhysicsSM.Algebra.Furey.OperatorRepresentations`,
`PhysicsSM.Algebra.Furey.MinimalLeftIdeal`,
`PhysicsSM.Algebra.Furey.AnomalyBridge`,
`PhysicsSM.StandardModel.AnomalyPackage`, …), and the coordinate eigenvalue
theorems `AnomalyBridge.Q_op_*` are available there.

`AnomalyPackage.lean` is the shared, Mathlib-only anomaly package; it is the
same module imported by the live Furey bridge (`AnomalyBridge.lean`,
`OneGenerationPackage.lean`, `FureyRealizesOneGeneration.lean`) and by the
null-edge API (`NullEdgeInternalSpectrum.lean`).  This draft intentionally
models the Furey `J` states at the number-operator / occupation level — the
exact level on which `Q_op` is diagonal — reproducing the same charge multiset
the coordinate theorems prove, without importing the heavier stack.

Build the bridge DAG explicitly:

    lake build PhysicsSM.StandardModel.AnomalyPackage
    lake build PhysicsSM.Draft.NullEdgeInternalSpectrum
    lake build PhysicsSM.Draft.NullEdgeFureyInternalSpectrum
```

(The "Summary" and "Scope preserved" sections of the notes are accurate and are
left unchanged.)

### 4. Safest canonical theorem citation for one-generation anomaly freedom

`PhysicsSM.StandardModel.AnomalyPackage.standardModelOneGeneration_anomalyFree`

It bundles both halves:
`LocalAnomalyFree standardModelOneGeneration ∧
WittenSU2AnomalyFree standardModelOneGeneration`, built from
`standardModelOneGeneration_localAnomalyFree` (all five perturbative
coefficients vanish, by exact rational arithmetic) and
`standardModelOneGeneration_wittenAnomalyFree` (even doublet count). Cite the
two components when only one is needed. (`AnomalyBridge.sm_localAnomalyFree`
and `AnomalyBridge.sm_wittenAnomalyFree` are convenience re-exports of these
same theorems and may be cited from inside the Furey island, but the package
names are the canonical source.)

### 5. Safest canonical theorem citation for the Furey-to-anomaly bridge

`PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration.fureyRealizesOneGenerationPackage`

This is the cleanest, convention-explicit bridge: it certifies that the Furey
`Jbar` left-handed doublets match the SM left sector (colour/weak/Y), that the
all-left table completed with the conventional right-handed singlets equals
`standardModelOneGeneration`, that the right-handed singlet sector is an
explicit `ClaimBoundary` (not algebraically derived), and that the resulting
table is locally + Witten anomaly free. The coordinate-level provenance is
`AnomalyBridge.Q_op_*` together with
`AnomalyBridge.combined_gravitational_anomaly_vanishes` /
`combined_cubic_anomaly_vanishes`; the bundled package
`OneGenerationPackage.fureyOneGenerationPackage` is an acceptable alternative
citation. For the publication layer, the umbrella instance is
`Publication.FureyBaezDVTMainTheorem.fureyBaezDVTMainTheorem`, whose
`furey_realizes_one_generation` field is exactly
`fureyRealizesOneGenerationPackage`.

## Crosswalk summary table

| Concept | Canonical declaration | Module |
|---|---|---|
| One-generation SM table | `standardModelOneGeneration` | `StandardModel/AnomalyPackage.lean` |
| Perturbative anomaly freedom | `standardModelOneGeneration_localAnomalyFree` | `StandardModel/AnomalyPackage.lean` |
| Witten SU(2) anomaly freedom | `standardModelOneGeneration_wittenAnomalyFree` | `StandardModel/AnomalyPackage.lean` |
| Bundled anomaly freedom | `standardModelOneGeneration_anomalyFree` | `StandardModel/AnomalyPackage.lean` |
| Furey `Q_op` eigenvalues on `Jbar` | `Q_op_omega_bar`, `Q_op_vbar1…6`, `Q_op_nu_bar` | `Algebra/Furey/AnomalyBridge.lean` |
| Combined J ∪ (−Jbar) abelian cancellation | `combined_gravitational_anomaly_vanishes`, `combined_cubic_anomaly_vanishes` | `Algebra/Furey/AnomalyBridge.lean` |
| Furey-to-anomaly bridge (canonical) | `fureyRealizesOneGenerationPackage` | `Algebra/Furey/FureyRealizesOneGeneration.lean` |
| Furey bundled package (alt) | `fureyOneGenerationPackage` | `Algebra/Furey/OneGenerationPackage.lean` |
| Null-edge inheritance | `NullEdgeInternalSpectrum.{localAnomalyFree,wittenAnomalyFree}_of_realizesOneGeneration` | `Draft/NullEdgeInternalSpectrum.lean` |
| Computed Furey-`J` realization | `fureyJ_realizes_nullEdgeInternalSpectrum`, `fureyJ_anomalyFree` | `Draft/NullEdgeFureyInternalSpectrum.lean` |

## Solved targets / changed statements / blockers

- **Solved targets:** all five crosswalk questions answered; stale notes
  located and corrected.
- **Changed statements:** none. No Lean theorem/`def`/`structure` statement was
  altered or weakened. Only docstring/notes prose was corrected in two draft
  files.
- **Remaining blockers:** none for this audit. (This is a no-build job; whole-
  library compilation status was not re-verified here.)
- **Proof holes / handoff markers:** none introduced. The right-handed singlet
  `ClaimBoundary` in `FureyRealizesOneGeneration.lean` is an intentional,
  documented physics boundary, not a proof hole.

## Files changed

- `AgentTasks/null-edge-anomaly-crosswalk-stale-note-audit-report.md` (new — this report).
- `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` (docstring only: "Import boundary" section corrected).
- `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md` (notes only: "Import boundary"/"Building" sections corrected).

No manuscript (`Sources/*.md`) edits were required.
