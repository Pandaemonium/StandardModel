import Mathlib.Tactic
import PhysicsSM.Algebra.Furey.ElectroweakBridge
import PhysicsSM.Algebra.Furey.QopElectroweakConsistency
import PhysicsSM.StandardModel.AnomalyPackage

/-!
# Jbar SU(2)² U(1)_Y anomaly sanity theorem

This module proves that the two Jbar left-handed doublet multiplets
(quark doublet Q_L and lepton doublet L_L) satisfy the SU(2)²–U(1)_Y
anomaly cancellation condition:

```text
3 × (1/3) + 1 × (−1) = 0
```

where:
- `3` is the colour dimension of Q_L (triplet),
- `1/3` is its hypercharge,
- `1` is the colour dimension of L_L (singlet),
- `−1` is its hypercharge.

## Claim boundary

- This theorem only checks the left-doublet contribution visible in the
  Jbar bridge.
- It does **not** claim the full one-generation anomaly theorem follows
  from Furey's algebra here.
- Weak isospin is **not** derived from `Q_op`; the `targetT3` table in
  `ElectroweakBridge` is conventional electroweak input.

## Sources

- Cohl Furey, "Charge quantization from a number operator",
  arXiv:1603.04078.
- Cohl Furey, "SU(3)_C × SU(2)_L × U(1)_Y (× U(1)_X) as a symmetry of
  division algebraic ladder operators", arXiv:1806.00612.
- Standard Model anomaly conventions from the local module
  `PhysicsSM.StandardModel.AnomalyPackage`.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.StandardModel.OneGenerationTable

/-! ## Jbar left-handed doublet multiplets as anomaly-package multiplets -/

/--
The two Jbar left-handed multiplets expressed as `ChiralMultiplet` records
from `AnomalyPackage`:

- `Jbar Q_L`: colour triplet, weak doublet, hypercharge `1/3`.
- `Jbar L_L`: colour singlet, weak doublet, hypercharge `−1`.
-/
def JbarLeftDoubletMultiplets : List ChiralMultiplet :=
  [ { label := "Jbar Q_L", color := ColorRep.triplet,
      weak := WeakRep.doublet, hypercharge := 1 / 3 },
    { label := "Jbar L_L", color := ColorRep.singlet,
      weak := WeakRep.doublet, hypercharge := -1 } ]

/-! ## SU(2)² U(1) anomaly cancellation -/

/--
The SU(2)²–U(1)_Y anomaly coefficient for the Jbar left-handed doublets
vanishes: `3 × (1/3) + 1 × (−1) = 0`.
-/
theorem JbarLeftDoublet_su2SquaredU1Anomaly :
    su2SquaredU1Anomaly JbarLeftDoubletMultiplets = 0 := by
  simp only [su2SquaredU1Anomaly, JbarLeftDoubletMultiplets, List.map,
    ChiralMultiplet.colorMultiplicity, ColorRep.multiplicity,
    WeakRep.isDoublet, List.sum_cons, List.sum_nil]
  norm_num

/--
The same cancellation in explicit rational arithmetic.
-/
theorem JbarLeftDoublet_hypercharge_weighted_sum :
    (3 : Rat) * (1 / 3) + (1 : Rat) * (-1) = 0 := by
  norm_num

/-! ## Connection to the Jbar electroweak bridge -/

/--
The Jbar left-doublet multiplet list matches the electroweak bridge in
colour dimension, weak dimension for both quark and lepton doublets.
-/
theorem JbarLeftDoublet_multiplets_match_bridge :
    ElectroweakBridge.quarkDoublet_colorDim = 3 ∧
    ElectroweakBridge.quarkDoublet_weakDim = 2 ∧
    ElectroweakBridge.leptonDoublet_colorDim = 1 ∧
    ElectroweakBridge.leptonDoublet_weakDim = 2 := by
  exact ⟨rfl, rfl, rfl, rfl⟩

/--
Re-export of the main bridge theorem from `ElectroweakBridge`: the Jbar
left-handed multiplets match `Q_L` and `L_L` in colour dimension, weak
dimension, and hypercharge.
-/
theorem JbarLeftDoublet_matches_Q_L_L_L :
    (quarkDoublet_colorDim = PhysicalMultiplet.colorDim .Q_L ∧
      quarkDoublet_weakDim = PhysicalMultiplet.weakDim .Q_L ∧
      ∀ s : JbarState, stateMultiplet s = .quarkDoublet →
        targetY s = PhysicalMultiplet.hypercharge .Q_L) ∧
    (leptonDoublet_colorDim = PhysicalMultiplet.colorDim .L_L ∧
      leptonDoublet_weakDim = PhysicalMultiplet.weakDim .L_L ∧
      ∀ s : JbarState, stateMultiplet s = .leptonDoublet →
        targetY s = PhysicalMultiplet.hypercharge .L_L) :=
  Jbar_left_multiplets_match_Q_L_L_L

end PhysicsSM.Algebra.Furey.JbarElectroweakAnomaly
