import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.QopJbarEigenBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge

/-!
# Q_op electroweak table consistency

This trusted module provides table-consistency lemmas bridging the
operator-eigenvalue results in `QopJbarEigenBridge` with the electroweak
bookkeeping table in `ElectroweakBridge`.

The weak-isospin table `ElectroweakBridge.targetT3` remains conventional
electroweak input. It is not derived here from `Q_op`.

Main declarations:
- `rawQop_values`
- `physicalQ_values`
- `targetT3_values`
- `physicalQFromRawQop`
- `physicalQ_eq_physicalQFromRawQop`
- `Q_op_eigenvalue_matches_electroweak_raw_table`

Provenance: integrated from Aristotle job
`b29d7fb2-d8a7-4a40-968f-1194445e213e`, with local review and provenance
cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.QopElectroweakConsistency

open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.QopJbarEigenBridge
open PhysicsSM.Algebra.Furey.AnomalyBridge
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-! ## Explicit table lemmas -/

/-- The raw `Q_op` eigenvalue table as a list. -/
theorem rawQop_values :
    (List.finRange 8).map ElectroweakBridge.rawQop =
      [0, -1 / 3, -1 / 3, -1 / 3, -2 / 3, -2 / 3, -2 / 3, -1] := by
  change [ElectroweakBridge.rawQop 0, ElectroweakBridge.rawQop 1,
          ElectroweakBridge.rawQop 2, ElectroweakBridge.rawQop 3,
          ElectroweakBridge.rawQop 4, ElectroweakBridge.rawQop 5,
          ElectroweakBridge.rawQop 6, ElectroweakBridge.rawQop 7] =
    [0, -1 / 3, -1 / 3, -1 / 3, -2 / 3, -2 / 3, -2 / 3, -1]
  simp [ElectroweakBridge.rawQop]

/-- The physical electric-charge table as a list. -/
theorem physicalQ_values :
    (List.finRange 8).map ElectroweakBridge.physicalQ =
      [0, -1 / 3, -1 / 3, -1 / 3, 2 / 3, 2 / 3, 2 / 3, -1] := by
  change [ElectroweakBridge.physicalQ 0, ElectroweakBridge.physicalQ 1,
          ElectroweakBridge.physicalQ 2, ElectroweakBridge.physicalQ 3,
          ElectroweakBridge.physicalQ 4, ElectroweakBridge.physicalQ 5,
          ElectroweakBridge.physicalQ 6, ElectroweakBridge.physicalQ 7] =
    [0, -1 / 3, -1 / 3, -1 / 3, 2 / 3, 2 / 3, 2 / 3, -1]
  simp [ElectroweakBridge.physicalQ]

/-- The target weak-isospin third-component table as a list. -/
theorem targetT3_values :
    (List.finRange 8).map ElectroweakBridge.targetT3 =
      [1 / 2, -1 / 2, -1 / 2, -1 / 2, 1 / 2, 1 / 2, 1 / 2, -1 / 2] := by
  change [ElectroweakBridge.targetT3 0, ElectroweakBridge.targetT3 1,
          ElectroweakBridge.targetT3 2, ElectroweakBridge.targetT3 3,
          ElectroweakBridge.targetT3 4, ElectroweakBridge.targetT3 5,
          ElectroweakBridge.targetT3 6, ElectroweakBridge.targetT3 7] =
    [1 / 2, -1 / 2, -1 / 2, -1 / 2, 1 / 2, 1 / 2, 1 / 2, -1 / 2]
  simp [ElectroweakBridge.targetT3]

/-! ## Sign correction function -/

/--
Finite sign correction converting raw `Q_op` eigenvalues to physical electric
charges. For up-quark states, indices `4`, `5`, and `6`, the raw eigenvalue is
negated. For all other states it is unchanged.
-/
def physicalQFromRawQop (s : ElectroweakBridge.JbarState) : Rat :=
  match s.val with
  | 4 => -ElectroweakBridge.rawQop s
  | 5 => -ElectroweakBridge.rawQop s
  | 6 => -ElectroweakBridge.rawQop s
  | _ => ElectroweakBridge.rawQop s

/-- The finite sign correction reproduces the physical charge table exactly. -/
theorem physicalQ_eq_physicalQFromRawQop :
    ∀ s : ElectroweakBridge.JbarState,
      ElectroweakBridge.physicalQ s = physicalQFromRawQop s := by
  intro s
  fin_cases s <;> simp [ElectroweakBridge.physicalQ, physicalQFromRawQop,
    ElectroweakBridge.rawQop] <;> norm_num

/-! ## Combined operator/electroweak bridge -/

/--
The `Q_op` eigenvalue on every Jbar basis state matches the raw electroweak
table entry. This is a named re-export of `Q_op_JbarBasisState_eigen` under the
table bookkeeping namespace, giving downstream files one obvious import.
-/
theorem Q_op_eigenvalue_matches_electroweak_raw_table
    (s : ElectroweakBridge.JbarState) :
    MinimalLeftIdeal.Q_op (AnomalyBridge.JbarBasisState s) =
      QopJbarEigenBridge.rawQopComplex s • AnomalyBridge.JbarBasisState s :=
  QopJbarEigenBridge.Q_op_JbarBasisState_eigen s

end PhysicsSM.Algebra.Furey.QopElectroweakConsistency
