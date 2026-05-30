# Aristotle task: Jbar SU(2)^2 U(1) anomaly sanity theorem

**Agent**: Aristotle
**Status**: Complete and integrated
**Priority**: High
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `c0bec408-e620-410c-a9f6-110d3ff36160`
**Submission project**: `AgentTasks/aristotle-submit/furey-jbar-su2-anomaly-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-jbar-su2-anomaly-20260529`
**Extracted output**: `AgentTasks/aristotle-output/furey-jbar-su2-anomaly-20260529-extracted`
**Integrated file**: `PhysicsSM/Algebra/Furey/JbarElectroweakAnomaly.lean`
**Type**: finite anomaly bridge / electroweak bookkeeping

## Goal

Prove that the Jbar left-handed doublet bridge has the expected
`SU(2)^2 U(1)_Y` anomaly cancellation:

```text
3 * (1/3) + 1 * (-1) = 0.
```

This is a narrow sanity theorem connecting:

- the Jbar electroweak bridge,
- the conventional Standard Model anomaly package,
- the finite hypercharge table already proved in Lean.

## Sources and claim boundary

Source motivation:

- Cohl Furey, "Charge quantization from a number operator",
  arXiv:1603.04078.
- Cohl Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of
  division algebraic ladder operators", arXiv:1806.00612.
- Standard Model anomaly conventions from the local module
  `PhysicsSM.StandardModel.AnomalyPackage`.

Claim boundary:

- This theorem only checks the left-doublet contribution visible in the Jbar
  bridge.
- Do not claim the full one-generation anomaly theorem follows from Furey's
  algebra here.
- Do not claim weak isospin is derived from `Q_op`; the `targetT3` table in
  `ElectroweakBridge` is conventional electroweak input.

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/JbarElectroweakAnomaly.lean
```

Suggested imports:

```lean
import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency
import PhysicsSM.StandardModel.AnomalyPackage
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define the two Jbar left-handed multiplets as anomaly-package multiplets:

```lean
def JbarLeftDoubletMultiplets : List ChiralMultiplet :=
  [ { label := "Jbar Q_L", color := ColorRep.triplet,
      weak := WeakRep.doublet, hypercharge := 1 / 3 },
    { label := "Jbar L_L", color := ColorRep.singlet,
      weak := WeakRep.doublet, hypercharge := -1 } ]
```

Prove:

```lean
theorem JbarLeftDoublet_su2SquaredU1Anomaly :
    su2SquaredU1Anomaly JbarLeftDoubletMultiplets = 0
```

Prove the same cancellation in explicit arithmetic form:

```lean
theorem JbarLeftDoublet_hypercharge_weighted_sum :
    (3 : Rat) * (1 / 3) + (1 : Rat) * (-1) = 0
```

Connect the list back to the Jbar bridge:

```lean
theorem JbarLeftDoublet_multiplets_match_bridge :
    ElectroweakBridge.quarkDoublet_colorDim = 3 /\
    ElectroweakBridge.quarkDoublet_weakDim = 2 /\
    ElectroweakBridge.leptonDoublet_colorDim = 1 /\
    ElectroweakBridge.leptonDoublet_weakDim = 2
```

If useful, also prove:

```lean
theorem JbarLeftDoublet_matches_Q_L_L_L :
    ElectroweakBridge.Jbar_left_multiplets_match_Q_L_L_L
```

or re-export it under this namespace.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep proofs finite by unfolding, `simp`, and `norm_num`.
- Keep the module docstring explicit about the claim boundary.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/JbarElectroweakAnomaly.lean
lake build PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
lake build PhysicsSM
```

## Deliverable

Return files changed, theorem names proved, whether the file is sorry-free, and
exact verification commands run.

## Integration result

Integrated on 2026-05-29 into trusted code as
`PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly`.

Main declarations added:

- `JbarLeftDoubletMultiplets`
- `JbarLeftDoublet_su2SquaredU1Anomaly`
- `JbarLeftDoublet_hypercharge_weighted_sum`
- `JbarLeftDoublet_multiplets_match_bridge`
- `JbarLeftDoublet_matches_Q_L_L_L`

Verification run during integration:

```bash
lake env lean PhysicsSM\Algebra\Furey\JbarElectroweakAnomaly.lean
lake build PhysicsSM.Algebra.Furey.TrialityActionMonoid PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly PhysicsSM.Algebra.Octonion.G2ComplexLine PhysicsSM.Algebra.Jordan.DVTStabilizerRestriction
```

Status: sorry-free trusted integration. The targeted build passed with
pre-existing warnings in older modules.
