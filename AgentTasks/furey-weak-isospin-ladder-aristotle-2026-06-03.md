# Aristotle task: Furey weak-isospin raising and lowering operators

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical Furey electroweak structure
**Prepared**: 2026-06-03
**Submitted**: 2026-06-03
**Job ID**: `a806c342-9f88-4a8c-bf87-dd5ea581d3af`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260603`
**Output**:
**Type**: Furey electroweak operator package

## Goal

Create a trusted module:

```text
PhysicsSM/Algebra/Furey/WeakIsospinLadder.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Furey.T3OpJbar
import PhysicsSM.Algebra.Furey.WeakIsospinDoublets
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.WeakIsospinLadder
```

## Context

`T3OpJbar.lean` defines the diagonal weak-isospin operator `T3End` on
`JbarWavefunction`, with basis vectors `JbarBasisState s`.

`WeakIsospinDoublets.lean` proves the table-level doublet structure:

- lepton doublet: upper `0`, lower `7`;
- quark doublets: upper `4 + k`, lower `1 + k` for `k : Fin 3`;
- equal hypercharge inside each doublet;
- opposite `T3` values inside each doublet.

The missing constructive operator theorem is to define raising/lowering maps
that act like the standard spin-1/2 representation of `su(2)` on these four
doublets.

## Target declarations

Define continuous linear operators:

```lean
noncomputable def TPlusEnd :
    JbarWavefunction ->L[Complex] JbarWavefunction

noncomputable def TMinusEnd :
    JbarWavefunction ->L[Complex] JbarWavefunction
```

Suggested action on basis states:

```text
TPlusEnd  e_7 = e_0
TPlusEnd  e_(1+k) = e_(4+k)
TPlusEnd  e_0 = 0
TPlusEnd  e_(4+k) = 0

TMinusEnd e_0 = e_7
TMinusEnd e_(4+k) = e_(1+k)
TMinusEnd e_7 = 0
TMinusEnd e_(1+k) = 0
```

Use explicit coordinate definitions on `JbarWavefunction = JbarState -> C`;
for example, `(TPlusEnd psi) 0 = psi 7`, `(TPlusEnd psi) 4 = psi 1`, and so
on. This avoids needing a separate basis API.

Prove basis-action theorems:

```lean
theorem TPlusEnd_electron :
    TPlusEnd (JbarBasisState 7) = JbarBasisState 0

theorem TMinusEnd_neutrino :
    TMinusEnd (JbarBasisState 0) = JbarBasisState 7

theorem TPlusEnd_dQuark (k : Fin 3) :
    TPlusEnd (JbarBasisState (1 + k.val)) =
      JbarBasisState (4 + k.val)

theorem TMinusEnd_uQuark (k : Fin 3) :
    TMinusEnd (JbarBasisState (4 + k.val)) =
      JbarBasisState (1 + k.val)
```

Use the exact `Fin 8` terms that typecheck in the existing files, such as
`(⟨1 + k.val, by omega⟩ : JbarState)` if necessary.

Also prove annihilation theorems for upper states under `TPlusEnd` and lower
states under `TMinusEnd`.

## Commutation relations

Define a commutator for continuous linear endomorphisms if no local one exists:

```lean
noncomputable def endComm
    (A B : JbarWavefunction ->L[Complex] JbarWavefunction) :
    JbarWavefunction ->L[Complex] JbarWavefunction :=
  A.comp B - B.comp A
```

Prove the spin-1/2 `su(2)` relations on this finite representation:

```lean
theorem T3_comm_TPlus :
    endComm T3End TPlusEnd = TPlusEnd

theorem T3_comm_TMinus :
    endComm T3End TMinusEnd = -TMinusEnd

theorem TPlus_comm_TMinus :
    endComm TPlusEnd TMinusEnd = (2 : Complex) • T3End
```

Because hypercharge is constant on each doublet, also prove:

```lean
theorem Y_comm_TPlus :
    endComm targetYEnd TPlusEnd = 0

theorem Y_comm_TMinus :
    endComm targetYEnd TMinusEnd = 0
```

## Package

Bundle the theorem surface:

```lean
structure FureyWeakIsospinLadderPackage where
  T3_comm_TPlus : endComm T3End TPlusEnd = TPlusEnd
  T3_comm_TMinus : endComm T3End TMinusEnd = -TMinusEnd
  TPlus_comm_TMinus : endComm TPlusEnd TMinusEnd = (2 : Complex) • T3End
  Y_comm_TPlus : endComm targetYEnd TPlusEnd = 0
  Y_comm_TMinus : endComm targetYEnd TMinusEnd = 0

noncomputable def fureyWeakIsospinLadderPackage :
    FureyWeakIsospinLadderPackage
```

## Claim boundary

This is a table/operator theorem for the finite Jbar wavefunction model. It
does not derive these operators from Furey's octonionic ladder algebra, and it
does not prove the full Standard Model representation category.

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/WeakIsospinLadder.lean
lake build PhysicsSM.Algebra.Furey.WeakIsospinLadder
```
