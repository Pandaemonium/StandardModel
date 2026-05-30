# Aristotle task: Furey electroweak hypercharge bridge

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-05-29
**Submitted**: 2026-05-29
**Job ID**: `9d206a15-53b7-4350-9f42-3292d67e2444`
**Submission project**: `AgentTasks/aristotle-submit/furey-electroweak-hypercharge-bridge-20260529-project`
**Output**: `AgentTasks/aristotle-output/furey-electroweak-hypercharge-bridge-20260529`
**Type**: finite table / proof / representation bookkeeping

## Integration result

Aristotle job `9d206a15-53b7-4350-9f42-3292d67e2444` completed and was
integrated into:

```text
PhysicsSM/Algebra/Furey/ElectroweakBridge.lean
PhysicsSM.lean
```

The integrated module was reviewed locally and kept in trusted source. It
contains the finite Jbar state table, the physical-charge/raw-`Q_op` sign
bridge, target weak-isospin table, computed hypercharge table, multiplet
classification, comparison with `OneGenerationTable`, and an explicit
right-handed-sector claim boundary.

Raw Aristotle artifacts were downloaded to:

```text
AgentTasks/aristotle-output/furey-electroweak-hypercharge-bridge-20260529
AgentTasks/aristotle-output/furey-electroweak-hypercharge-bridge-20260529-extracted
```

Verification run after integration:

```bash
lake env lean PhysicsSM/Algebra/Furey/ElectroweakBridge.lean
lake build PhysicsSM.Algebra.Furey.ElectroweakBridge
lake env lean PhysicsSM.lean
```

Local hygiene checks on the new trusted file passed:

```bash
rg -n "[^\x00-\x7F]" PhysicsSM\Algebra\Furey\ElectroweakBridge.lean
rg -n "\bsorry\b|\badmit\b|\baxiom\b|\bopaque\b|\bunsafe\b" PhysicsSM\Algebra\Furey\ElectroweakBridge.lean
git diff --check -- PhysicsSM.lean PhysicsSM\Algebra\Furey\ElectroweakBridge.lean
```

## Goal

Formalize the next honest bridge between the Furey minimal-left-ideal
calculation and the conventional Standard Model one-generation table.

The project already proves the finite `Q_op` eigenvalues on the Furey `J` and
`Jbar` basis states. The missing safe next step is **not** to claim that weak
isospin has been derived from the octonions. The missing safe next step is to
define an explicit target weak-isospin assignment, compute

```text
Y = 2 * (Q - T3)
```

and prove that the grouped Furey states match the conventional multiplet table
already in `PhysicsSM.StandardModel.OneGenerationTable` and
`PhysicsSM.StandardModel.AnomalyPackage`.

The most valuable output is a trusted, sorry-free module that makes the claim
boundary machine-readable:

```text
Furey Q_op eigenvalues + target T3 table -> conventional hypercharge table
```

No theorem should say that `T3` itself has been derived from the Furey algebra.

## Source and convention notes

Sources:

- Cohl Furey, "Charge quantization from a number operator", 2015/2016.
- Cohl Furey, "SU(3)_C x SU(2)_L x U(1)_Y (x U(1)_X) as a symmetry of
  division algebraic ladder operators", 2018.
- Peskin and Schroeder, Section 20.2, for the conventional SM table.
- Weinberg, QFT volume 2, for `Q = T3 + Y / 2`.

Conventions:

- Project hypercharge convention: `Q = T3 + Y / 2`.
- The current Furey operator `Q_op` is electric charge, not hypercharge.
- `J` and `Jbar` are Furey sectors inside `ComplexOctonion`.
- The weak-isospin table in this job is conventional bookkeeping, not derived
  from octonion multiplication.

## Existing trusted inputs

Read these files first:

```text
PhysicsSM/Algebra/Furey/MinimalLeftIdeal.lean
PhysicsSM/Algebra/Furey/OperatorRepresentations.lean
PhysicsSM/Algebra/Furey/OperatorAlgebra.lean
PhysicsSM/Algebra/Furey/AnomalyBridge.lean
PhysicsSM/Algebra/Furey/HyperchargeBridge.lean
PhysicsSM/StandardModel/OneGenerationTable.lean
PhysicsSM/StandardModel/AnomalyPackage.lean
AgentTasks/furey-anomaly-cancellation.md
```

Useful existing declarations include:

- `omega`, `v1`, `v2`, `v3`, `v4`, `v5`, `v6`, `nu`
- `omega_bar`, `vbar1`, `vbar2`, `vbar3`, `vbar4`, `vbar5`, `vbar6`, `nu_bar`
- `Q_op`
- `Q_omega`, `Q_v1`, ..., `Q_nu`
- Jbar `Q_op` eigenvalue theorems in `AnomalyBridge.lean`
- `OneGenerationTable.PhysicalMultiplet`
- `OneGenerationTable.AllLeftMultiplet`
- `AnomalyPackage.ChiralMultiplet`
- `standardModelOneGeneration`
- `standardModelOneGeneration_anomalyFree`

## Requested file

Prefer a new trusted file:

```text
PhysicsSM/Algebra/Furey/ElectroweakBridge.lean
```

It should import:

```lean
import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.StandardModel.OneGenerationTable
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Furey.ElectroweakBridge
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target statements

### 1. Finite state labels for the physical Jbar sector

Define an inductive or `Fin 8`-based state type for the eight Jbar states:

```lean
abbrev JbarState := Fin 8
```

Define rational physical electric charge values:

```lean
def physicalQ : JbarState -> Rat
```

Use the physical particle convention:

```text
0: neutrino      Q = 0
1,2,3: down     Q = -1/3
4,5,6: up       Q = 2/3
7: electron     Q = -1
```

If this differs from the raw `Q_op` eigenvalue signs in `AnomalyBridge`, add a
docstring explaining the convention and prove a sign-bridge theorem if easy.

### 2. Target weak-isospin and hypercharge table

Define:

```lean
def targetT3 : JbarState -> Rat
def targetY : JbarState -> Rat := fun s => 2 * (physicalQ s - targetT3 s)
```

Use the left-handed doublet assignments:

```text
neutrino: +1/2, electron: -1/2
up:       +1/2, down:     -1/2
```

Then prove:

```lean
theorem gellMannNishijima_all :
    forall s : JbarState, physicalQ s = targetT3 s + targetY s / 2
```

Also prove the concrete list:

```lean
theorem targetY_values :
    (List.finRange 8).map targetY =
      [-1, 1/3, 1/3, 1/3, 1/3, 1/3, 1/3, -1]
```

### 3. Group states into SM multiplets

Define a target multiplet classification for Jbar:

```lean
inductive JbarMultiplet where
  | leptonDoublet
  | quarkDoublet
```

or use an explicit `stateMultiplet : JbarState -> ...`.

Prove:

```text
lepton doublet has 2 states, color dimension 1, weak dimension 2, Y = -1
quark doublet has 6 states, color dimension 3, weak dimension 2, Y = 1/3
```

These theorems can be exact list-count theorems by `decide` / `norm_num`.

### 4. Compare with `OneGenerationTable`

Prove that the two Jbar multiplets match the left-handed physical multiplets
`Q_L` and `L_L` from `OneGenerationTable`:

```lean
theorem Jbar_left_multiplets_match_Q_L_L_L :
  ...
```

Keep the statement modest. It is enough to prove equality of dimensions and
hypercharges:

```text
Q_L: colorDim = 3, weakDim = 2, hypercharge = 1/3
L_L: colorDim = 1, weakDim = 2, hypercharge = -1
```

### 5. Optional: explicit open-right-sector theorem

Add a theorem or definition documenting the gap:

```lean
def FureyRightHandedSectorOpen : Prop := True
```

or a structure with fields identifying the missing right-handed singlets. This
should not pretend to prove the right-handed sector. It should make the claim
boundary explicit.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not rename `Q_op` as hypercharge.
- Do not claim that `T3` has been derived from the Furey algebra.
- Prefer exact rational arithmetic with `norm_num`.
- Keep the file small and reviewable.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Furey/ElectroweakBridge.lean
lake env lean PhysicsSM.lean
```

## Deliverable

Return:

- files changed;
- theorem names proved;
- whether all output is sorry-free;
- exact verification commands run;
- a short note on the remaining weak-isospin/right-handed-sector gaps.
