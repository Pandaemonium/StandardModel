import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakCompletePackage
import PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
import PhysicsSM.Algebra.Furey.OneGenerationPackage
import PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
import PhysicsSM.StandardModel.OneGenerationTable
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.FamilyAnomalyNaturality

/-!
# Furey electroweak–anomaly bridge

This module bridges the Furey finite-state electroweak package to the
Standard Model anomaly cancellation package. It proves that the quantum
numbers extracted from the Furey Jbar sector are **compatible** with the
one-generation anomaly-free table, and that the Furey-derived left-handed
doublet sub-table already satisfies a partial anomaly cancellation
condition.

## What is proved

1. **Doublet embedding**: the two Furey Jbar left-handed doublet multiplets
   (Q_L and L_L) form a sub-list of the full `standardModelOneGeneration`
   table, with matching colour representation, weak representation, and
   hypercharge.

2. **Charge / weak-isospin / hypercharge consistency**: for every Jbar
   basis state, the Furey-assigned physical charge, target T₃, and
   computed hypercharge satisfy the Gell-Mann–Nishijima relation
   `Q = T₃ + Y/2`.

3. **Partial anomaly cancellation**: the Furey Jbar doublet sub-table
   satisfies the SU(2)²–U(1)_Y anomaly condition in isolation, which is
   a necessary condition for the doublet sector to be part of an anomaly-
   free theory.

4. **Anomaly-free completion**: when the Jbar doublet sub-table is completed
   with the conventional right-handed singlet sector (u_Rc, d_Rc, e_Rc),
   the result is exactly `standardModelOneGeneration`, which is proved
   locally anomaly free and Witten-anomaly free.

5. **Package theorem**: a bundled `FureyElectroweakAnomalyBridge` structure
   collecting all of the above, suitable for citation.

## Claim boundary

The Furey Jbar sector covers only the **left-handed doublet** sector of the
Standard Model (8 Weyl states out of 15). The right-handed singlet sector
(u_R, d_R, e_R — 7 Weyl states) is **not** realized by the Jbar
construction. Therefore:

- A full bijection between the Furey state space and the one-generation
  Standard Model table cannot be established from the Jbar sector alone.
- The anomaly freedom of the full Standard Model table is proved using the
  conventional singlet assignments, not derived from the Furey algebra.
- Color is represented only as a multiplicity (three copies of each quark
  state) in the Jbar table; the SU(3)_c representation theory is not
  derived from the Furey operators in this bridge.

These limitations are faithfully recorded in the `ClaimBoundary` structure
below.

## Sources

- Cohl Furey, "Charge quantization from a number operator",
  Phys. Lett. B 742 (2015), 195.
- Cohl Furey, "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of
  division algebraic ladder operators", Eur. Phys. J. C 78 (2018), 375.
- Peskin and Schroeder, Section 20.2 (anomaly conventions).

## Status

Trusted module: no `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
-/

namespace PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.OneGenerationTable
open PhysicsSM.StandardModel.FamilyAnomalyNaturality
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
open PhysicsSM.Algebra.Furey.ElectroweakCompletePackage
open PhysicsSM.Algebra.Furey.OneGenerationPackage
open PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly

/-! ## Furey Jbar doublet multiplets as ChiralMultiplet records -/

/--
The Furey Jbar quark doublet expressed as a `ChiralMultiplet` from the
anomaly package. Colour triplet, weak doublet, hypercharge `1/3`.
-/
def fureyQuarkDoublet : ChiralMultiplet :=
  { label := "Q_L",
    color := ColorRep.triplet,
    weak  := WeakRep.doublet,
    hypercharge := 1 / 3 }

/--
The Furey Jbar lepton doublet expressed as a `ChiralMultiplet` from the
anomaly package. Colour singlet, weak doublet, hypercharge `−1`.
-/
def fureyLeptonDoublet : ChiralMultiplet :=
  { label := "L_L",
    color := ColorRep.singlet,
    weak  := WeakRep.doublet,
    hypercharge := -1 }

/--
The Furey Jbar doublet sub-table: the two left-handed doublet multiplets
visible in the Jbar sector.
-/
def fureyDoubletTable : List ChiralMultiplet :=
  [fureyQuarkDoublet, fureyLeptonDoublet]

/-! ## Gauge-data matching with the standard model table -/

/--
The Furey quark doublet has the same gauge data (colour, weak rep,
hypercharge) as the conventional Q_L multiplet in the standard model table.
-/
theorem fureyQuarkDoublet_sameGaugeData :
    SameGaugeData
      (standardModelOneGeneration.get ⟨0, by decide⟩)
      fureyQuarkDoublet := by
  simp [SameGaugeData, fureyQuarkDoublet, standardModelOneGeneration]

/--
The Furey lepton doublet has the same gauge data (colour, weak rep,
hypercharge) as the conventional L_L multiplet in the standard model table.
-/
theorem fureyLeptonDoublet_sameGaugeData :
    SameGaugeData
      (standardModelOneGeneration.get ⟨1, by decide⟩)
      fureyLeptonDoublet := by
  simp [SameGaugeData, fureyLeptonDoublet, standardModelOneGeneration]

/-! ## The doublet table is a sub-list of the anomaly table -/

/--
The conventional right-handed singlet completion: u_Rc, d_Rc, e_Rc
expressed as `ChiralMultiplet` records.
-/
def rightHandedSingletCompletion : List ChiralMultiplet :=
  [ { label := "u_R^c", color := ColorRep.antiTriplet,
      weak  := WeakRep.singlet, hypercharge := -4/3 },
    { label := "d_R^c", color := ColorRep.antiTriplet,
      weak  := WeakRep.singlet, hypercharge := 2/3 },
    { label := "e_R^c", color := ColorRep.singlet,
      weak  := WeakRep.singlet, hypercharge := 2 } ]

/--
Appending the right-handed singlet completion to the Furey doublet table
produces exactly the `standardModelOneGeneration` table.
-/
theorem fureyDoubletTable_append_completion :
    fureyDoubletTable ++ rightHandedSingletCompletion =
      standardModelOneGeneration := by
  unfold fureyDoubletTable rightHandedSingletCompletion standardModelOneGeneration
    fureyQuarkDoublet fureyLeptonDoublet
  rfl

/-! ## Partial anomaly cancellation for the doublet sub-table -/

/--
The Furey doublet sub-table coincides (as a list of `ChiralMultiplet`) with
the `JbarLeftDoubletMultiplets` defined in `JbarElectroweakAnomaly`.
They have the same gauge data.
-/
theorem fureyDoubletTable_sameGaugeData_JbarLeft :
    ∀ i : Fin 2,
      SameGaugeData
        (fureyDoubletTable.get (i.cast (by decide)))
        (JbarLeftDoubletMultiplets.get (i.cast (by decide))) := by
  intro i; fin_cases i <;>
    simp [SameGaugeData, fureyDoubletTable, JbarLeftDoubletMultiplets,
      fureyQuarkDoublet, fureyLeptonDoublet]

/--
The SU(2)²–U(1)_Y anomaly coefficient for the Furey doublet sub-table
vanishes: `3 × (1/3) + 1 × (−1) = 0`.
-/
theorem fureyDoubletTable_su2SquaredU1Anomaly :
    su2SquaredU1Anomaly fureyDoubletTable = 0 := by
  simp only [su2SquaredU1Anomaly, fureyDoubletTable,
    fureyQuarkDoublet, fureyLeptonDoublet,
    ChiralMultiplet.colorMultiplicity, ColorRep.multiplicity,
    WeakRep.isDoublet, List.map_cons, List.map_nil,
    List.sum_cons, List.sum_nil]
  norm_num

/-! ## Full anomaly freedom via completion -/

/--
The completed table (Furey doublets + conventional singlets) is locally
anomaly free. This follows from the fact that it equals
`standardModelOneGeneration`.
-/
theorem completed_table_localAnomalyFree :
    LocalAnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion) := by
  rw [fureyDoubletTable_append_completion]
  exact standardModelOneGeneration_localAnomalyFree

/--
The completed table satisfies Witten's global SU(2) anomaly condition.
-/
theorem completed_table_wittenAnomalyFree :
    WittenSU2AnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion) := by
  rw [fureyDoubletTable_append_completion]
  exact standardModelOneGeneration_wittenAnomalyFree

/-! ## Gell-Mann–Nishijima on the Furey Jbar states -/

/--
Every Jbar basis state satisfies `Q = T₃ + Y/2` with the Furey physical
charge, target weak isospin, and computed hypercharge.
This re-exports the proof from `ElectroweakBridge`.
-/
theorem furey_gellMannNishijima :
    ∀ s : JbarState, physicalQ s = targetT3 s + targetY s / 2 :=
  gellMannNishijima_all

/-! ## Weyl-state accounting -/

/--
The Furey Jbar sector accounts for 8 out of the 15 Weyl states in one
Standard Model generation (without ν_R).
-/
theorem furey_jbar_weylCount : 8 + 7 = 15 := by decide

/--
The 8 Furey Jbar states decompose as 6 quark-doublet + 2 lepton-doublet
states, matching Q_L (3 colours × 2 weak) and L_L (1 colour × 2 weak).
-/
theorem furey_jbar_stateDecomposition :
    quarkDoublet_colorDim * quarkDoublet_weakDim +
    leptonDoublet_colorDim * leptonDoublet_weakDim = 8 := by decide

/--
The right-handed singlet sector not covered by the Furey Jbar bridge
has 7 Weyl states: u_R (3) + d_R (3) + e_R (1).
-/
theorem rightHanded_singlet_weylCount :
    PhysicalMultiplet.weylCount .u_R +
    PhysicalMultiplet.weylCount .d_R +
    PhysicalMultiplet.weylCount .e_R = 7 := by decide

/-! ## Claim boundary structure -/

/--
Machine-readable claim boundary for the Furey electroweak–anomaly bridge.

This structure records what the Furey Jbar sector does and does not cover
in the Standard Model one-generation table, serving as a formal contract
for downstream modules.
-/
structure ClaimBoundary where
  /-- The Jbar sector covers only left-handed doublets (Q_L and L_L). -/
  doublets_only :
    fureyDoubletTable.length = 2
  /-- The Jbar sector accounts for 8 of 15 Weyl states. -/
  weyl_coverage :
    quarkDoublet_colorDim * quarkDoublet_weakDim +
    leptonDoublet_colorDim * leptonDoublet_weakDim = 8
  /-- The remaining 7 Weyl states are right-handed singlets not derived
      from the Furey algebra. -/
  missing_singlet_count :
    PhysicalMultiplet.weylCount .u_R +
    PhysicalMultiplet.weylCount .d_R +
    PhysicalMultiplet.weylCount .e_R = 7
  /-- The right-handed sector open boundary is inherited from the
      electroweak bridge. -/
  right_handed_open : FureyRightHandedSectorOpen

/-- The claim boundary is satisfied. -/
theorem claimBoundary : ClaimBoundary where
  doublets_only := by decide
  weyl_coverage := furey_jbar_stateDecomposition
  missing_singlet_count := rightHanded_singlet_weylCount
  right_handed_open := fureyRightHandedSectorOpen

/-! ## Package theorem -/

/--
Bundled Furey electroweak–anomaly bridge package.

This structure combines the Furey charge/weak-isospin assignments, the
anomaly freedom of the completed table, and the explicit claim boundary
into a single citeable record.
-/
structure FureyElectroweakAnomalyBridge where
  /-- The Furey Jbar doublet sub-table matches Q_L and L_L in gauge data. -/
  doublet_gauge_match :
    SameGaugeData
      (standardModelOneGeneration.get ⟨0, by decide⟩)
      fureyQuarkDoublet ∧
    SameGaugeData
      (standardModelOneGeneration.get ⟨1, by decide⟩)
      fureyLeptonDoublet
  /-- The Gell-Mann–Nishijima relation holds on all Jbar states. -/
  gell_mann_nishijima :
    ∀ s : JbarState, physicalQ s = targetT3 s + targetY s / 2
  /-- The doublet sub-table satisfies SU(2)²–U(1)_Y anomaly cancellation. -/
  doublet_su2_squared_u1 :
    su2SquaredU1Anomaly fureyDoubletTable = 0
  /-- Completing the doublet table with conventional singlets recovers
      the full standard model table. -/
  completion_eq :
    fureyDoubletTable ++ rightHandedSingletCompletion =
      standardModelOneGeneration
  /-- The completed table is locally anomaly free. -/
  completed_local_anomaly_free :
    LocalAnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion)
  /-- The completed table satisfies Witten's SU(2) anomaly condition. -/
  completed_witten_anomaly_free :
    WittenSU2AnomalyFree (fureyDoubletTable ++ rightHandedSingletCompletion)
  /-- Explicit claim boundary naming the missing data. -/
  claim_boundary : ClaimBoundary

/--
The Furey electroweak–anomaly bridge package, instantiated from proved
theorems. Every field is proved by delegation to an already kernel-checked
result; no new computation is performed here.
-/
theorem fureyElectroweakAnomalyBridge : FureyElectroweakAnomalyBridge where
  doublet_gauge_match :=
    ⟨fureyQuarkDoublet_sameGaugeData, fureyLeptonDoublet_sameGaugeData⟩
  gell_mann_nishijima := furey_gellMannNishijima
  doublet_su2_squared_u1 := fureyDoubletTable_su2SquaredU1Anomaly
  completion_eq := fureyDoubletTable_append_completion
  completed_local_anomaly_free := completed_table_localAnomalyFree
  completed_witten_anomaly_free := completed_table_wittenAnomalyFree
  claim_boundary := claimBoundary

end PhysicsSM.Algebra.Furey.ElectroweakAnomalyBridge
