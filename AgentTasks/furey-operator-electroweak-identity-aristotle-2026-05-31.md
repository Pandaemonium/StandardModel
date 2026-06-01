# Aristotle task: operator-level electroweak identity

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `e3d06499-8c59-4151-a136-ded874114d16`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Output**: `AgentTasks/aristotle-output/furey-operator-electroweak-identity-20260531`
**Result bundle**: `AgentTasks/aristotle-output/furey-operator-electroweak-identity-20260531-result`
**Extracted result**: `AgentTasks/aristotle-output/furey-operator-electroweak-identity-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Type**: diagonal operator version of Gell-Mann-Nishijima

## Goal

Create a trusted finite operator theorem saying that the Jbar electroweak
charge table satisfies `Q = T3 + Y/2` as an equality of diagonal linear
operators on the finite state-function space.

This strengthens the existing pointwise table theorem
`ElectroweakBridge.gellMannNishijima_all` without claiming that `T3` and `Y`
have been derived from the full Furey ladder algebra.

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Furey/OperatorElectroweakIdentity.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations include:

- `ElectroweakBridge.JbarState`
- `ElectroweakBridge.physicalQ`
- `ElectroweakBridge.rawQop`
- `ElectroweakBridge.targetT3`
- `ElectroweakBridge.targetY`
- `ElectroweakBridge.gellMannNishijima_all`
- `QopElectroweakConsistency.physicalQ_eq_physicalQFromRawQop`
- `QopElectroweakConsistency.Q_op_eigenvalue_matches_electroweak_raw_table`

## Target declarations

Define the finite state-function space:

```lean
abbrev JbarWavefunction := ElectroweakBridge.JbarState -> Complex
```

Define diagonal linear maps:

```lean
noncomputable def diagonalEnd
    (f : ElectroweakBridge.JbarState -> Complex) :
    JbarWavefunction ->L[Complex] JbarWavefunction := ...
```

Suggested implementation:

```lean
toFun := fun psi s => f s * psi s
map_add' := by ...
map_smul' := by ...
```

Then define:

```lean
noncomputable def physicalQEnd : JbarWavefunction ->L[Complex] JbarWavefunction :=
  diagonalEnd (fun s => (ElectroweakBridge.physicalQ s : Complex))

noncomputable def targetT3End : JbarWavefunction ->L[Complex] JbarWavefunction :=
  diagonalEnd (fun s => (ElectroweakBridge.targetT3 s : Complex))

noncomputable def targetYEnd : JbarWavefunction ->L[Complex] JbarWavefunction :=
  diagonalEnd (fun s => (ElectroweakBridge.targetY s : Complex))
```

Prove application lemmas:

```lean
@[simp] theorem diagonalEnd_apply ...
@[simp] theorem physicalQEnd_apply ...
@[simp] theorem targetT3End_apply ...
@[simp] theorem targetYEnd_apply ...
```

Main theorem:

```lean
theorem physicalQEnd_eq_targetT3End_add_half_targetYEnd :
    physicalQEnd =
      targetT3End + (1 / 2 : Complex) • targetYEnd := ...
```

Also prove a pointwise operator form:

```lean
theorem physicalQEnd_apply_eq_gmn
    (psi : JbarWavefunction) (s : ElectroweakBridge.JbarState) :
    physicalQEnd psi s =
      (targetT3End psi s) +
        (1 / 2 : Complex) * (targetYEnd psi s) := ...
```

If feasible, add a raw-`Q_op` sign-bridge theorem as a finite table wrapper,
but do not block on this if the main operator equality is done.

## Claim boundary

This theorem package proves a diagonal operator equality for the explicit
finite Jbar electroweak table. It does not derive weak isospin from the
octonionic ladder algebra.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the module finite and table-level.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/OperatorElectroweakIdentity.lean
lake build PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
```

## Integration

Integrated by Codex on 2026-05-31.

Live file:

```text
PhysicsSM/Algebra/Furey/OperatorElectroweakIdentity.lean
```

Root import added to `PhysicsSM.lean`.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Furey/OperatorElectroweakIdentity.lean
lake build PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
```

The integrated module is trusted code and contains no `sorry`, `admit`,
`axiom`, `opaque`, or `unsafe` declarations.
