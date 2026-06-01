# Aristotle task: Furey electroweak paper package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `e586b4dc-7b30-467b-8914-124ca778aeb6`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Type**: Furey theorem island for manuscript use

## Goal

Create a citation-friendly theorem package that combines the Furey
one-generation package with the new operator-level electroweak identity.

The goal is to give the paper one obvious import for the statement:
the Furey-side finite table layer includes Q-op eigenvalue consistency, the
Jbar electroweak table, the operator-level Gell-Mann-Nishijima identity, and
the existing anomaly/one-generation package.

## Requested file

Create:

```text
PhysicsSM/Algebra/Furey/ElectroweakPaperPackage.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.OneGenerationPackage
import PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Create:

```lean
structure FureyElectroweakPaperPackage where
  one_generation :
    PhysicsSM.Algebra.Furey.OneGenerationPackage.FureyOneGenerationPackage
  operator_gell_mann_nishijima :
    PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity.physicalQEnd =
      PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity.targetT3End +
        (1 / 2 : Complex) •
          PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity.targetYEnd
  qop_table_consistency :
    ∀ s : PhysicsSM.Algebra.Furey.ElectroweakBridge.JbarState,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.Q_op
          (PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState s) =
        PhysicsSM.Algebra.Furey.QopJbarEigenBridge.rawQopComplex s •
          PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState s

theorem fureyElectroweakPaperPackage :
    FureyElectroweakPaperPackage := ...
```

Add wrapper theorems with short names:

```lean
theorem furey_operator_gmn : ...
theorem furey_qop_table_consistency (s : JbarState) : ...
```

Use existing declarations:

- `OneGenerationPackage.fureyOneGenerationPackage`
- `OperatorElectroweakIdentity.physicalQEnd_eq_targetT3End_add_half_targetYEnd`
- `QopElectroweakConsistency.Q_op_eigenvalue_matches_electroweak_raw_table`

## Claim boundary

This module packages the finite trusted electroweak and anomaly results. It
does not claim a full derivation of weak isospin from the octonionic ladder
algebra, nor a full physical derivation of the Standard Model.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer wrappers and delegation to existing theorem names.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/ElectroweakPaperPackage.lean
lake build PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
```

## Integration result

**Completed**: 2026-05-31
**Result bundle**: `AgentTasks/aristotle-output/furey-electroweak-paper-package-20260531-result`
**Extracted project**: `AgentTasks/aristotle-output/furey-electroweak-paper-package-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Integrated file**: `PhysicsSM/Algebra/Furey/ElectroweakPaperPackage.lean`
**Root import**: `PhysicsSM.Algebra.Furey.ElectroweakPaperPackage`

Aristotle produced a paper-facing theorem package joining the one-generation
Furey table layer with the operator-level electroweak identity and Q-op table
consistency wrapper. The module is a packaging layer over existing trusted
finite theorem islands, not a new derivation of the full Standard Model.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Furey/ElectroweakPaperPackage.lean
lake build PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
```
