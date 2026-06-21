import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
import PhysicsSM.Algebra.Furey.ElectroweakCompletePackage
import PhysicsSM.Algebra.Furey.OneGenerationPackage
import PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# Furey realizes one Standard Model generation

This module proves the main Furey claim-boundary theorem: a precise,
convention-explicit connection between the Furey Jbar finite-state data
and the conventional `standardModelOneGeneration` anomaly table.

## What is proved

The `FureyRealizesOneGenerationPackage` structure collects:

1. **Jbar left-handed doublet matching**: the Furey Jbar doublets (quark
   doublet Q_L and lepton doublet L_L) match the Standard Model left-handed
   sector in colour dimension, weak dimension, and hypercharge.

2. **Gell-Mann–Nishijima relation**: every Jbar basis state satisfies
   `Q = T₃ + Y/2` with the Furey-assigned physical charge, target weak
   isospin, and computed hypercharge.

3. **SU(2)²–U(1)_Y anomaly cancellation** for the Furey doublet sub-table.

4. **One-generation table match**: the all-left-handed multiplet list
   (without ν_R^c) maps to exactly `standardModelOneGeneration` after
   appending the conventional right-handed singlet completion.

5. **Full anomaly freedom**: `standardModelOneGeneration` is locally
   anomaly free and satisfies Witten's global SU(2) anomaly condition.

6. **Right-handed singlet boundary**: an explicit `ClaimBoundary` recording
   that the right-handed singlet sector (u_R, d_R, e_R, ν_R) remains
   conventional rather than algebraically derived from the Furey algebra.

## Claim boundary

This package does **not** claim that Furey's algebra has fully derived the
physical one-generation Standard Model. The right-handed singlet sector is
identified by conventional physics input, not by the octonionic ladder
operators. The claim boundary makes this explicit as a machine-readable
proposition.

## Handedness convention

The Jbar sector produces left-handed fermion states. Physical right-handed
fermions enter the anomaly-free table as their left-handed charge conjugates
with negated hypercharge. The charge conjugation map is explicit in
`OneGenerationTable.hypercharge_conversion`.

## Sources

- Cohl Furey, "Charge quantization from a number operator", Phys. Lett. B 742
  (2015), 195.
- Cohl Furey, "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of
  division algebraic ladder operators", Eur. Phys. J. C 78 (2018), 375.
- Peskin and Schroeder, Section 20.2 (anomaly conventions).

## Status

Trusted module: all proofs are complete and no placeholder declarations are
used. No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e`.
-/

namespace PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
open PhysicsSM.Algebra.Furey.OneGenerationPackage
open PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
open PhysicsSM.Algebra.Furey.QopElectroweakConsistency
open PhysicsSM.Algebra.Furey.AnomalyBridge

/-! ## Claim boundary -/

/--
Machine-readable claim boundary for the right-handed singlet sector.

This structure records exactly which Standard Model multiplets are **not**
derived from the Furey Jbar algebra, and why. Each field is a kernel-checked
statement, not a comment.
-/
structure RightSingletBoundary where
  /-- The right-handed sector is not realized by the Jbar bridge.
      (`FureyRightHandedSectorOpen` is `True` by construction,
      serving as a documented marker.) -/
  right_handed_open : FureyRightHandedSectorOpen
  /-- There are exactly four unmatched right-handed multiplets:
      u_R, d_R, e_R, and ν_R. -/
  unmatched_count : unmatchedRightHandedMultiplets.length = 4
  /-- Every unmatched multiplet is right-handed. -/
  unmatched_chirality :
    ∀ m : PhysicalMultiplet,
      m ∈ unmatchedRightHandedMultiplets → m.chirality = .right
  /-- The Jbar sector covers 8 of 15 Weyl states (without ν_R). -/
  jbar_weyl_coverage :
    quarkDoublet_colorDim * quarkDoublet_weakDim +
    leptonDoublet_colorDim * leptonDoublet_weakDim = 8
  /-- The missing singlets contribute 7 Weyl states. -/
  missing_weyl_count :
    PhysicalMultiplet.weylCount .u_R +
    PhysicalMultiplet.weylCount .d_R +
    PhysicalMultiplet.weylCount .e_R = 7

/-- The right-handed singlet claim boundary is satisfied. -/
theorem rightSingletBoundary : RightSingletBoundary where
  right_handed_open := fureyRightHandedSectorOpen
  unmatched_count := unmatchedRightHanded_count
  unmatched_chirality := unmatchedRightHanded_chirality
  jbar_weyl_coverage := by decide
  missing_weyl_count := by decide

/-! ## Main package -/

/--
The main Furey one-generation realization package.

This is the cleanest high-impact Furey theorem for the paper: it separates
what the algebra now proves (left-handed doublet sector) from what is still
a physical/conventional identification (right-handed singlet sector).

Convention: all multiplets are in the all-left-handed basis. Physical
right-handed fermions enter as charge conjugates with negated hypercharge.
The handedness convention is documented in `OneGenerationTable`.
-/
structure FureyRealizesOneGenerationPackage where
  /-- The Jbar left-handed doublets have the same SU(2)/Y/Q data as
      the left-handed sector of `standardModelOneGeneration`. -/
  jbar_left_doublets_match :
    (quarkDoublet_colorDim = PhysicalMultiplet.colorDim .Q_L ∧
      quarkDoublet_weakDim = PhysicalMultiplet.weakDim .Q_L ∧
      ∀ s : JbarState, stateMultiplet s = .quarkDoublet →
        targetY s = PhysicalMultiplet.hypercharge .Q_L) ∧
    (leptonDoublet_colorDim = PhysicalMultiplet.colorDim .L_L ∧
      leptonDoublet_weakDim = PhysicalMultiplet.weakDim .L_L ∧
      ∀ s : JbarState, stateMultiplet s = .leptonDoublet →
        targetY s = PhysicalMultiplet.hypercharge .L_L)
  /-- The right-handed singlet sector remains conventional rather than
      algebraically derived. -/
  right_singlet_boundary : RightSingletBoundary
  /-- The Furey doublet table, completed with conventional right-handed
      singlets, equals `standardModelOneGeneration` (up to the documented
      handedness convention: all multiplets are in the all-left basis). -/
  one_generation_table_match :
    fureyDoubletTable ++ rightHandedSingletCompletion =
      standardModelOneGeneration
  /-- The one-generation Standard Model table is locally anomaly free
      (all five perturbative anomaly coefficients vanish). -/
  local_anomaly_free :
    LocalAnomalyFree standardModelOneGeneration
  /-- The one-generation Standard Model table satisfies Witten's global
      SU(2) anomaly condition (the doublet count is even). -/
  witten_anomaly_free :
    WittenSU2AnomalyFree standardModelOneGeneration

/--
**Main theorem**: the Furey one-generation realization package is satisfied.

Every field is proved by delegation to an already kernel-checked theorem
from the bridge modules. No new coordinate computation is performed.
-/
theorem fureyRealizesOneGenerationPackage :
    FureyRealizesOneGenerationPackage where
  jbar_left_doublets_match := Jbar_left_multiplets_match_Q_L_L_L
  right_singlet_boundary := rightSingletBoundary
  one_generation_table_match := fureyDoubletTable_append_completion
  local_anomaly_free := standardModelOneGeneration_localAnomalyFree
  witten_anomaly_free := standardModelOneGeneration_wittenAnomalyFree

/-! ## Supplementary results -/

/--
The Gell-Mann–Nishijima relation `Q = T₃ + Y/2` holds on every Jbar basis
state, connecting the Furey charge assignment to the electroweak quantum
numbers.
-/
theorem furey_gellMannNishijima_all :
    ∀ s : JbarState, physicalQ s = targetT3 s + targetY s / 2 :=
  gellMannNishijima_all

/--
The SU(2)²–U(1)_Y anomaly coefficient for the Furey doublet sub-table
vanishes: `3 × (1/3) + 1 × (−1) = 0`.
-/
theorem furey_doublet_su2_squared_u1_anomaly :
    su2SquaredU1Anomaly fureyDoubletTable = 0 :=
  fureyDoubletTable_su2SquaredU1Anomaly

/--
The gravitational anomaly sum vanishes for the combined J ∪ (−Jbar) spectrum.
-/
theorem furey_combined_gravitational_anomaly :
    (-1 : Rat) * 1 + (-2/3) * 3 + (-1/3) * 3 + 0 * 1 +
    1 * 1 + (2/3) * 3 + (1/3) * 3 + 0 * 1 = 0 :=
  combined_gravitational_anomaly_vanishes

/--
The cubic anomaly sum vanishes for the combined J ∪ (−Jbar) spectrum.
-/
theorem furey_combined_cubic_anomaly :
    (-1 : Rat) ^ 3 * 1 + (-2/3) ^ 3 * 3 + (-1/3) ^ 3 * 3 +
    0 ^ 3 * 1 +
    (1 : Rat) ^ 3 * 1 + (2/3) ^ 3 * 3 + (1/3) ^ 3 * 3 +
    0 ^ 3 * 1 = 0 :=
  combined_cubic_anomaly_vanishes

/--
The all-left-handed multiplet list (without ν_R^c) maps to exactly
`standardModelOneGeneration` when converted to `ChiralMultiplet` records.
-/
theorem furey_allLeftList15_eq_standardModel :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration :=
  allLeftList15_toChiralMultiplet_eq

end PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration
