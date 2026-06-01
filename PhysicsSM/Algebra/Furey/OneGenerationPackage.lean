import Mathlib
import PhysicsSM.Algebra.Furey.AnomalyBridge
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.OneGenerationTable

/-!
# Furey one-generation theorem package

This module bundles the existing Furey charge, electroweak, anomaly, and
conventional one-generation table results into a single citation-friendly
landing page.

## What is proved

The `FureyOneGenerationPackage` structure collects:

1. **Jbar left-handed multiplet matching**: the Jbar left-handed doublets
   (quark doublet Q_L and lepton doublet L_L) match the conventional
   Standard Model table in colour dimension, weak dimension, and hypercharge.

2. **SU(2)²–U(1)_Y anomaly cancellation**: the two Jbar left-handed doublet
   multiplets satisfy the SU(2)²–U(1)_Y anomaly cancellation condition.

3. **All-left table equivalence**: the all-left-handed multiplet list
   (without ν_R^c) maps to the same anomaly-package table used in
   `standardModelOneGeneration`.

4. **Standard Model anomaly freedom**: the one-generation Standard Model
   multiplet table is locally anomaly free and satisfies Witten's global
   SU(2) anomaly condition.

5. **Combined charge sums**: the gravitational and cubic anomaly sums
   vanish for the combined J ∪ (−Jbar) spectrum.

## What remains open

6. **Right-handed sector boundary**: the right-handed singlet sector
   (u_R, d_R, e_R, ν_R) is not realized by the Jbar-left-doublet bridge.
   This is explicitly preserved as a machine-readable claim boundary.

## Claim boundary

This package does **not** claim that Furey's algebra has fully derived the
physical one-generation Standard Model. It is a theorem index over the
current trusted bridge results and explicitly preserves the
right-handed-sector/open-realization boundary.

## Sources

- Cohl Furey, "Charge quantization from a number operator", Phys. Lett. B 742
  (2015), 195.
- Cohl Furey, "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of
  division algebraic ladder operators", Eur. Phys. J. C 78 (2018), 375.

## Status

Trusted module: all proofs are complete and no placeholder declarations are used.
-/

namespace PhysicsSM.Algebra.Furey.OneGenerationPackage

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
open PhysicsSM.Algebra.Furey.QopElectroweakConsistency
open PhysicsSM.Algebra.Furey.AnomalyBridge

/-! ## Package structure -/

/--
Bundled theorem package for the Furey one-generation programme.

Each field records a proved result from the existing bridge modules.
The structure separates what is already proved from the Furey
operator/eigenvalue tables, what is conventional Standard Model bookkeeping,
and what remains an explicit right-handed-sector/open-realization boundary.
-/
structure FureyOneGenerationPackage where
  /-- The Jbar left-handed multiplets match Q_L and L_L in colour dimension,
      weak dimension, and hypercharge. -/
  jbar_left_matches_Q_L_L_L :
    (quarkDoublet_colorDim = PhysicalMultiplet.colorDim .Q_L ∧
      quarkDoublet_weakDim = PhysicalMultiplet.weakDim .Q_L ∧
      ∀ s : JbarState, stateMultiplet s = .quarkDoublet →
        targetY s = PhysicalMultiplet.hypercharge .Q_L) ∧
    (leptonDoublet_colorDim = PhysicalMultiplet.colorDim .L_L ∧
      leptonDoublet_weakDim = PhysicalMultiplet.weakDim .L_L ∧
      ∀ s : JbarState, stateMultiplet s = .leptonDoublet →
        targetY s = PhysicalMultiplet.hypercharge .L_L)
  /-- The SU(2)²–U(1)_Y anomaly coefficient for the Jbar left-handed
      doublets vanishes. -/
  jbar_su2_squared_u1 : su2SquaredU1Anomaly JbarLeftDoubletMultiplets = 0
  /-- The all-left-handed multiplet list maps to the standard model
      one-generation anomaly-package table. -/
  all_left_table_eq :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration
  /-- The one-generation Standard Model is locally anomaly free and
      satisfies Witten's global SU(2) anomaly condition. -/
  standard_model_anomaly_free :
    LocalAnomalyFree standardModelOneGeneration ∧
    WittenSU2AnomalyFree standardModelOneGeneration
  /-- The gravitational anomaly sum vanishes for the combined
      J ∪ (−Jbar) spectrum. -/
  combined_charge_sum_zero :
    (-1 : Rat) * 1 + (-2/3) * 3 + (-1/3) * 3 + 0 * 1 +
    1 * 1 + (2/3) * 3 + (1/3) * 3 + 0 * 1 = 0
  /-- The cubic anomaly sum vanishes for the combined
      J ∪ (−Jbar) spectrum. -/
  combined_charge_cube_sum_zero :
    (-1 : Rat) ^ 3 * 1 + (-2/3) ^ 3 * 3 + (-1/3) ^ 3 * 3 +
    0 ^ 3 * 1 +
    (1 : Rat) ^ 3 * 1 + (2/3) ^ 3 * 3 + (1/3) ^ 3 * 3 +
    0 ^ 3 * 1 = 0
  /-- The right-handed singlet sector is not realized by the Jbar bridge.
      This is an explicit claim boundary. -/
  right_handed_sector_boundary : FureyRightHandedSectorOpen

/-! ## Package instantiation -/

/--
The Furey one-generation theorem package, instantiated from existing
trusted bridge results. Every field is proved by delegation to an
already kernel-checked theorem; no new coordinate computation is performed.
-/
theorem fureyOneGenerationPackage : FureyOneGenerationPackage where
  jbar_left_matches_Q_L_L_L := Jbar_left_multiplets_match_Q_L_L_L
  jbar_su2_squared_u1 := JbarLeftDoublet_su2SquaredU1Anomaly
  all_left_table_eq := allLeftList15_toChiralMultiplet_eq
  standard_model_anomaly_free := standardModelOneGeneration_anomalyFree
  combined_charge_sum_zero := combined_gravitational_anomaly_vanishes
  combined_charge_cube_sum_zero := combined_cubic_anomaly_vanishes
  right_handed_sector_boundary := fureyRightHandedSectorOpen

/-! ## Source-facing wrapper theorems -/

/--
The Jbar left-handed doublets match the conventional Standard Model Q_L and L_L
multiplets in colour dimension, weak dimension, and hypercharge.

This wraps `ElectroweakBridge.Jbar_left_multiplets_match_Q_L_L_L`.
-/
theorem furey_jbar_left_doublets_match_standard_model :
    (quarkDoublet_colorDim = PhysicalMultiplet.colorDim .Q_L ∧
      quarkDoublet_weakDim = PhysicalMultiplet.weakDim .Q_L ∧
      ∀ s : JbarState, stateMultiplet s = .quarkDoublet →
        targetY s = PhysicalMultiplet.hypercharge .Q_L) ∧
    (leptonDoublet_colorDim = PhysicalMultiplet.colorDim .L_L ∧
      leptonDoublet_weakDim = PhysicalMultiplet.weakDim .L_L ∧
      ∀ s : JbarState, stateMultiplet s = .leptonDoublet →
        targetY s = PhysicalMultiplet.hypercharge .L_L) :=
  Jbar_left_multiplets_match_Q_L_L_L

/--
The all-left-handed multiplet list (without ν_R^c) maps to the same table
used in `standardModelOneGeneration`.

This wraps `OneGenerationTable.allLeftList15_toChiralMultiplet_eq`.
-/
theorem furey_all_left_table_is_standardModelOneGeneration :
    allLeftList15.map AllLeftMultiplet.toChiralMultiplet =
      standardModelOneGeneration :=
  allLeftList15_toChiralMultiplet_eq

/--
The one-generation Standard Model fermion table is locally anomaly free
and satisfies Witten's global SU(2) anomaly condition.

This wraps `AnomalyPackage.standardModelOneGeneration_anomalyFree`.
-/
theorem furey_standardModelOneGeneration_anomalyFree :
    LocalAnomalyFree standardModelOneGeneration ∧
    WittenSU2AnomalyFree standardModelOneGeneration :=
  standardModelOneGeneration_anomalyFree

/--
The Q_op eigenvalue on every Jbar basis state matches the raw electroweak
table entry.

This wraps `QopElectroweakConsistency.Q_op_eigenvalue_matches_electroweak_raw_table`.
-/
theorem furey_qop_eigenvalue_matches_electroweak_raw_table
    (s : JbarState) :
    PhysicsSM.Algebra.Furey.MinimalLeftIdeal.Q_op (JbarBasisState s) =
      PhysicsSM.Algebra.Furey.QopJbarEigenBridge.rawQopComplex s •
        JbarBasisState s :=
  Q_op_eigenvalue_matches_electroweak_raw_table s

/--
The SU(2)²–U(1)_Y anomaly coefficient for the Jbar left-handed doublets
vanishes.

This wraps `JbarElectroweakAnomaly.JbarLeftDoublet_su2SquaredU1Anomaly`.
-/
theorem furey_jbar_su2_squared_u1_anomaly :
    su2SquaredU1Anomaly JbarLeftDoubletMultiplets = 0 :=
  JbarLeftDoublet_su2SquaredU1Anomaly

end PhysicsSM.Algebra.Furey.OneGenerationPackage
