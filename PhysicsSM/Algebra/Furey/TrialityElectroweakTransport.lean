import Mathlib
import PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
import PhysicsSM.Algebra.Furey.TrialityFamilyNaturality

/-!
# Triality electroweak transport package

Bridge package joining the Furey electroweak paper package to the
role-constant GMN transport theorems from `TrialityFamilyNaturality`.

This module is intended for the manuscript's family-symmetry section: it
certifies that the finite Furey electroweak theorem island is available
alongside the conditional role-constant triality transport lemmas.

## Main declarations

- `roleConstant_triality_cycle_gmn` — wrapper around
  `TrialityFamilyNaturality.roleCycle_gmn`.
- `roleConstant_triality_cycle_gmn_inv` — wrapper around
  `TrialityFamilyNaturality.roleConstant_gmn_cycle_inv`.
- `TrialityElectroweakTransportPackage` — bundled structure combining the
  Furey electroweak package with both cycle-GMN lemmas.
- `trialityElectroweakTransportPackage` — the canonical instance of the
  package, constructed from existing theorems.

## Claim boundary

This is a conditional transport package. It does not prove that triality is
the physical origin of generations and does not formalize the full
`tri(ℂ) + tri(ℍ) + tri(𝕆)` Lie algebra.
-/

namespace PhysicsSM.Algebra.Furey.TrialityElectroweakTransport

open PhysicsSM.Algebra.Furey
open PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
open PhysicsSM.Algebra.Furey.TrialityFamilyNaturality

/-! ## Wrapper theorems -/

/-- The Gell-Mann-Nishijima relation `Q = T3 + Y/2` holds at
`TrialityRole.cycle r` for any table satisfying GMN. -/
theorem roleConstant_triality_cycle_gmn
    (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 (TrialityRole.cycle r) +
        t.hypercharge (TrialityRole.cycle r) / 2 :=
  TrialityFamilyNaturality.roleCycle_gmn t hgmn r

/-- The GMN relation at `TrialityRole.cycle r`, rewritten using charges at `r`
via role-constancy. -/
theorem roleConstant_triality_cycle_gmn_inv
    (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
    (hconst : TrialityFamilyNaturality.RoleConstant t)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 r + t.hypercharge r / 2 :=
  TrialityFamilyNaturality.roleConstant_gmn_cycle_inv t hconst hgmn r

/-! ## Transport package -/

/-- Bundled transport package combining the Furey electroweak paper package
with the role-constant triality cycle GMN lemmas. -/
structure TrialityElectroweakTransportPackage where
  /-- The Furey electroweak paper package (anomaly, operator GMN, Q_op table). -/
  furey_electroweak :
    ElectroweakPaperPackage.FureyElectroweakPaperPackage
  /-- GMN at `cycle r` for role-constant tables. -/
  cycle_gmn :
    ∀ (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
      (_hgmn : t.SatisfiesGMN)
      (r : TrialityRole),
      t.electric (TrialityRole.cycle r) =
        t.weakT3 (TrialityRole.cycle r) +
          t.hypercharge (TrialityRole.cycle r) / 2
  /-- GMN at `cycle r`, rewritten via role-constancy to charges at `r`. -/
  cycle_gmn_inv :
    ∀ (t : TrialityFamilyNaturality.TrialityRoleChargeTable)
      (_hconst : TrialityFamilyNaturality.RoleConstant t)
      (_hgmn : t.SatisfiesGMN)
      (r : TrialityRole),
      t.electric (TrialityRole.cycle r) =
        t.weakT3 r + t.hypercharge r / 2

/-- The triality electroweak transport package, instantiated from existing
theorems. -/
theorem trialityElectroweakTransportPackage :
    TrialityElectroweakTransportPackage where
  furey_electroweak := fureyElectroweakPaperPackage
  cycle_gmn := roleConstant_triality_cycle_gmn
  cycle_gmn_inv := roleConstant_triality_cycle_gmn_inv

end PhysicsSM.Algebra.Furey.TrialityElectroweakTransport
