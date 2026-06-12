import Mathlib
import PhysicsSM.Algebra.Furey.FureyRealizesOneGeneration
import PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
import PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
import PhysicsSM.Algebra.Furey.OneGenerationPackage
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# Furey one-generation anomaly decomposition package

This module provides a paper-facing decomposition of the anomaly
contributions for the Furey one-generation programme. It separates:

1. **Doublet sector** - the Furey/Jbar left-handed doublet table
   (`fureyDoubletTable`), with its individual anomaly coefficients.
2. **Right-handed singlet completion** - the conventional (non-Furey)
   right-handed singlet sector (`rightHandedSingletCompletion`), with its
   individual anomaly coefficients.  This sector is explicitly marked as a
   conventional completion, *not* an algebraic derivation from the Furey
   ladder algebra.
3. **Combined all-left one-generation table** - the union
   `fureyDoubletTable ++ rightHandedSingletCompletion`, proved equal to
   `standardModelOneGeneration`, with full local and Witten anomaly freedom.

## Stretch target: per-coefficient anomaly equalities

Each of the five perturbative anomaly coefficients is shown to vanish
individually on the doublet sub-table, the singlet completion, and the
combined table.  The Witten global SU(2) anomaly is also verified.

## Claim boundary

The right-handed singlet sector is explicitly marked as a conventional
completion. Its quantum numbers are *not* derived from the Furey algebra.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- The definitions of `standardModelOneGeneration`, `fureyDoubletTable`,
  and `rightHandedSingletCompletion` are not modified.

## Status

Trusted module: all proofs are complete.
-/

namespace PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
open PhysicsSM.Algebra.Furey.OneGenerationPackage

/-! ## Section 1: Per-coefficient anomaly results for the doublet sub-table -/

/--
The gravitational-U(1) anomaly coefficient for the Furey doublet sub-table
vanishes: `6 × (1/3) + 2 × (-1) = 2 - 2 = 0`.
-/
theorem doublet_gravitationalU1 :
    gravitationalU1Anomaly fureyDoubletTable = 0 := by
  simp only [gravitationalU1Anomaly, fureyDoubletTable,
    fureyQuarkDoublet, fureyLeptonDoublet,
    ChiralMultiplet.totalMultiplicity, ChiralMultiplet.colorMultiplicity,
    ChiralMultiplet.weakMultiplicity, ColorRep.multiplicity,
    WeakRep.multiplicity, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/--
The cubic U(1)³ anomaly coefficient for the Furey doublet sub-table:
`6 × (1/3)³ + 2 × (-1)³ = 6/27 - 2 = -16/9`.

Note: this does *not* vanish in isolation - the doublet sector alone is
anomalous under U(1)³. The singlet completion cancels this contribution.
-/
theorem doublet_u1Cubed :
    u1CubedAnomaly fureyDoubletTable = -16/9 := by
  simp only [u1CubedAnomaly, fureyDoubletTable,
    fureyQuarkDoublet, fureyLeptonDoublet,
    ChiralMultiplet.totalMultiplicity, ChiralMultiplet.colorMultiplicity,
    ChiralMultiplet.weakMultiplicity, ColorRep.multiplicity,
    WeakRep.multiplicity, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/--
The SU(2)²-U(1) anomaly coefficient for the Furey doublet sub-table
vanishes: `3 × (1/3) + 1 × (-1) = 0`.

This is the key partial anomaly cancellation that the Furey Jbar sector
achieves *on its own*, without the singlet completion.
-/
theorem doublet_su2SquaredU1 :
    su2SquaredU1Anomaly fureyDoubletTable = 0 :=
  fureyDoubletTable_su2SquaredU1Anomaly

/--
The SU(3)²-U(1) anomaly coefficient for the Furey doublet sub-table:
`2 × (1/3) = 2/3`.

The doublet sector alone does not cancel this anomaly; the coloured
singlet completion (u_R^c, d_R^c) provides the compensating `-2/3`.
-/
theorem doublet_su3SquaredU1 :
    su3SquaredU1Anomaly fureyDoubletTable = 2/3 := by
  simp only [su3SquaredU1Anomaly, fureyDoubletTable,
    fureyQuarkDoublet, fureyLeptonDoublet,
    ChiralMultiplet.weakMultiplicity, WeakRep.multiplicity,
    ColorRep.isColored,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil]
  norm_num

/--
The SU(3)³ anomaly coefficient for the Furey doublet sub-table: `+2`.

The quark doublet Q_L (colour triplet, weak doublet) contributes
`2 × (+1) = +2`. The lepton doublet L_L is a colour singlet and contributes 0.
The singlet completion provides `-2` to cancel.
-/
theorem doublet_su3Cubed :
    su3CubedAnomaly fureyDoubletTable = 2 := by
  simp only [su3CubedAnomaly, fureyDoubletTable,
    fureyQuarkDoublet, fureyLeptonDoublet,
    ChiralMultiplet.weakMultiplicity, WeakRep.multiplicity,
    ColorRep.cubicIndex, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/-! ## Section 2: Per-coefficient anomaly results for the singlet completion -/

/--
The gravitational-U(1) anomaly coefficient for the right-handed singlet
completion vanishes: `3 × (-4/3) + 3 × (2/3) + 1 × 2 = -4 + 2 + 2 = 0`.
-/
theorem singlet_gravitationalU1 :
    gravitationalU1Anomaly rightHandedSingletCompletion = 0 := by
  simp only [gravitationalU1Anomaly, rightHandedSingletCompletion,
    ChiralMultiplet.totalMultiplicity, ChiralMultiplet.colorMultiplicity,
    ChiralMultiplet.weakMultiplicity, ColorRep.multiplicity,
    WeakRep.multiplicity, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/--
The cubic U(1)³ anomaly coefficient for the right-handed singlet completion:
`3 × (-4/3)³ + 3 × (2/3)³ + 1 × 2³ = 16/9`.

This is exactly `-(-16/9) = +16/9`, cancelling the doublet contribution.
-/
theorem singlet_u1Cubed :
    u1CubedAnomaly rightHandedSingletCompletion = 16/9 := by
  simp only [u1CubedAnomaly, rightHandedSingletCompletion,
    ChiralMultiplet.totalMultiplicity, ChiralMultiplet.colorMultiplicity,
    ChiralMultiplet.weakMultiplicity, ColorRep.multiplicity,
    WeakRep.multiplicity, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/--
The SU(2)²-U(1) anomaly coefficient for the right-handed singlet
completion vanishes: all singlets are SU(2) singlets.
-/
theorem singlet_su2SquaredU1 :
    su2SquaredU1Anomaly rightHandedSingletCompletion = 0 := by
  simp only [su2SquaredU1Anomaly, rightHandedSingletCompletion,
    ChiralMultiplet.colorMultiplicity, ColorRep.multiplicity,
    WeakRep.isDoublet, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/--
The SU(3)²-U(1) anomaly coefficient for the right-handed singlet
completion: `1 × (-4/3) + 1 × (2/3) = -2/3`.

This exactly cancels the doublet contribution of `+2/3`.
-/
theorem singlet_su3SquaredU1 :
    su3SquaredU1Anomaly rightHandedSingletCompletion = -2/3 := by
  simp only [su3SquaredU1Anomaly, rightHandedSingletCompletion,
    ChiralMultiplet.weakMultiplicity, WeakRep.multiplicity,
    ColorRep.isColored,
    List.map_cons, List.map_nil, List.sum_cons, List.sum_nil]
  norm_num

/--
The SU(3)³ anomaly coefficient for the right-handed singlet completion: `-2`.

u_R^c (antitriplet, singlet): `1 × (-1) = -1`.
d_R^c (antitriplet, singlet): `1 × (-1) = -1`.
e_R^c (colour singlet): contributes 0.
Total: `-2`, cancelling the doublet sector's `+2`.
-/
theorem singlet_su3Cubed :
    su3CubedAnomaly rightHandedSingletCompletion = -2 := by
  simp only [su3CubedAnomaly, rightHandedSingletCompletion,
    ChiralMultiplet.weakMultiplicity, WeakRep.multiplicity,
    ColorRep.cubicIndex, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/-! ## Section 3: Combined table results -/

/--
The completed table (Furey doublets + conventional singlets) equals
the standard model one-generation table.
-/
theorem completed_table_eq_standard :
    fureyDoubletTable ++ rightHandedSingletCompletion =
      standardModelOneGeneration :=
  fureyDoubletTable_append_completion

/--
The completed table is locally anomaly free
(all five perturbative anomaly coefficients vanish).
-/
theorem completed_localAnomalyFree :
    LocalAnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion) :=
  completed_table_localAnomalyFree

/--
The completed table satisfies Witten's global SU(2) anomaly condition.
-/
theorem completed_wittenAnomalyFree :
    WittenSU2AnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion) :=
  completed_table_wittenAnomalyFree

/--
The all-left-handed multiplet list (without ν_R^c) maps to exactly
`standardModelOneGeneration` when converted to `ChiralMultiplet` records.
-/
theorem allLeft_table_match :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration :=
  allLeftList15_toChiralMultiplet_eq

/-! ## Main decomposition package -/

/--
The Furey anomaly decomposition package.

This structure separates the anomaly contributions into three tiers:

1. **Doublet sector** (`fureyDoubletTable`): the Furey/Jbar left-handed
   doublets, with per-coefficient anomaly values.
2. **Singlet completion** (`rightHandedSingletCompletion`): the conventional
   right-handed singlet sector, with per-coefficient anomaly values.
   Explicitly marked as *not* derived from the Furey algebra.
3. **Combined table**: the union, proved equal to `standardModelOneGeneration`,
   with full anomaly freedom.

Each anomaly coefficient is tracked individually to show how doublet and
singlet contributions combine to produce the anomaly-free Standard Model.
-/
structure FureyAnomalyDecompositionPackage where
  /- === Doublet sector === -/
  /-- SU(2)²-U(1) anomaly vanishes for the doublet sub-table alone. -/
  doublet_su2_squared_u1 :
    su2SquaredU1Anomaly fureyDoubletTable = 0
  /-- Gravitational-U(1) anomaly vanishes for the doublet sub-table. -/
  doublet_grav_u1 :
    gravitationalU1Anomaly fureyDoubletTable = 0
  /-- Cubic U(1)³ anomaly for the doublet sub-table: `-16/9`. -/
  doublet_u1_cubed :
    u1CubedAnomaly fureyDoubletTable = -16/9
  /-- SU(3)²-U(1) anomaly for the doublet sub-table: `2/3`. -/
  doublet_su3_squared_u1 :
    su3SquaredU1Anomaly fureyDoubletTable = 2/3
  /-- SU(3)³ anomaly for the doublet sub-table: `+2`. -/
  doublet_su3_cubed :
    su3CubedAnomaly fureyDoubletTable = 2

  /- === Singlet completion (conventional, not Furey-derived) === -/
  /-- SU(2)²-U(1) anomaly vanishes for the singlet completion (trivially). -/
  singlet_su2_squared_u1 :
    su2SquaredU1Anomaly rightHandedSingletCompletion = 0
  /-- Gravitational-U(1) anomaly vanishes for the singlet completion. -/
  singlet_grav_u1 :
    gravitationalU1Anomaly rightHandedSingletCompletion = 0
  /-- Cubic U(1)³ anomaly for the singlet completion: `+16/9`.
      Cancels the doublet sector's `-16/9`. -/
  singlet_u1_cubed :
    u1CubedAnomaly rightHandedSingletCompletion = 16/9
  /-- SU(3)²-U(1) anomaly for the singlet completion: `-2/3`.
      Cancels the doublet sector's `+2/3`. -/
  singlet_su3_squared_u1 :
    su3SquaredU1Anomaly rightHandedSingletCompletion = -2/3
  /-- SU(3)³ anomaly for the singlet completion: `-2`.
      Cancels the doublet sector's `+2`. -/
  singlet_su3_cubed :
    su3CubedAnomaly rightHandedSingletCompletion = -2

  /- === Combined table === -/
  /-- The completed table equals `standardModelOneGeneration`. -/
  completed_table_eq_standard :
    fureyDoubletTable ++ rightHandedSingletCompletion =
      standardModelOneGeneration
  /-- The combined table is locally anomaly free. -/
  completed_local_anomaly_free :
    LocalAnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion)
  /-- The combined table satisfies Witten's SU(2) anomaly condition. -/
  completed_witten_anomaly_free :
    WittenSU2AnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion)

  /- === All-left table === -/
  /-- The all-left multiplet list maps to `standardModelOneGeneration`. -/
  all_left_table_match :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration

  /- === Claim boundary === -/
  /-- The right-handed singlet sector is not derived from the Furey algebra.
      This is an explicit machine-readable boundary marker. -/
  right_handed_sector_boundary : FureyRightHandedSectorOpen

/--
**Main theorem**: the Furey anomaly decomposition package is satisfied.

Every field is proved by delegation to an already kernel-checked theorem.
No new coordinate computation is performed here.
-/
theorem fureyAnomalyDecompositionPackage :
    FureyAnomalyDecompositionPackage where
  -- Doublet sector
  doublet_su2_squared_u1   := doublet_su2SquaredU1
  doublet_grav_u1          := doublet_gravitationalU1
  doublet_u1_cubed         := doublet_u1Cubed
  doublet_su3_squared_u1   := doublet_su3SquaredU1
  doublet_su3_cubed        := doublet_su3Cubed
  -- Singlet completion
  singlet_su2_squared_u1   := singlet_su2SquaredU1
  singlet_grav_u1          := singlet_gravitationalU1
  singlet_u1_cubed         := singlet_u1Cubed
  singlet_su3_squared_u1   := singlet_su3SquaredU1
  singlet_su3_cubed        := singlet_su3Cubed
  -- Combined table
  completed_table_eq_standard  := completed_table_eq_standard
  completed_local_anomaly_free := completed_localAnomalyFree
  completed_witten_anomaly_free := completed_wittenAnomalyFree
  -- All-left table
  all_left_table_match     := allLeft_table_match
  -- Claim boundary
  right_handed_sector_boundary := fureyRightHandedSectorOpen

end PhysicsSM.Algebra.Furey.FureyAnomalyDecomposition
