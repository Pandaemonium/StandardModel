import Mathlib
import PhysicsSM.Algebra.Furey.OneGenerationPackage
import PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity

/-!
# Furey electroweak paper package

Citation-friendly theorem package combining the Furey one-generation package
with the operator-level electroweak identity. This module gives the paper one
obvious import for all of:

- The `Q_op` eigenvalue consistency table.
- The Jbar electroweak table (left-handed multiplet matching, anomaly checks).
- The operator-level Gell-Mann–Nishijima identity `Q = T₃ + Y/2`.
- The existing anomaly/one-generation package.

## Claim boundary

This module packages the finite trusted electroweak and anomaly results. It
does **not** claim a full derivation of weak isospin from the octonionic ladder
algebra, nor a full physical derivation of the Standard Model.
-/

namespace PhysicsSM.Algebra.Furey.ElectroweakPaperPackage

open PhysicsSM.Algebra.Furey.OneGenerationPackage
open PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity
open PhysicsSM.Algebra.Furey.ElectroweakBridge
open PhysicsSM.Algebra.Furey.QopElectroweakConsistency
open PhysicsSM.Algebra.Furey.QopJbarEigenBridge
open PhysicsSM.Algebra.Furey.AnomalyBridge
open PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/--
Bundled electroweak paper package. Combines the one-generation package,
the operator-level Gell-Mann–Nishijima identity, and the `Q_op` eigenvalue
table consistency.
-/
structure FureyElectroweakPaperPackage where
  /-- The full one-generation package (anomaly, multiplet matching, etc.). -/
  one_generation :
    PhysicsSM.Algebra.Furey.OneGenerationPackage.FureyOneGenerationPackage
  /-- The operator-level Gell-Mann–Nishijima identity `Q = T₃ + Y/2`. -/
  operator_gell_mann_nishijima :
    PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity.physicalQEnd =
      PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity.targetT3End +
        (1 / 2 : Complex) •
          PhysicsSM.Algebra.Furey.OperatorElectroweakIdentity.targetYEnd
  /-- `Q_op` eigenvalue on each Jbar basis state matches the raw table. -/
  qop_table_consistency :
    ∀ s : PhysicsSM.Algebra.Furey.ElectroweakBridge.JbarState,
      PhysicsSM.Algebra.Furey.MinimalLeftIdeal.Q_op
          (PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState s) =
        PhysicsSM.Algebra.Furey.QopJbarEigenBridge.rawQopComplex s •
          PhysicsSM.Algebra.Furey.AnomalyBridge.JbarBasisState s

/-- The Furey electroweak paper package, instantiated from existing theorems. -/
theorem fureyElectroweakPaperPackage :
    FureyElectroweakPaperPackage where
  one_generation := fureyOneGenerationPackage
  operator_gell_mann_nishijima :=
    physicalQEnd_eq_targetT3End_add_half_targetYEnd
  qop_table_consistency :=
    Q_op_eigenvalue_matches_electroweak_raw_table

/-! ## Wrapper theorems -/

/-- The operator-level Gell-Mann–Nishijima identity `Q = T₃ + Y/2`. -/
theorem furey_operator_gmn :
    physicalQEnd =
      targetT3End + (1 / 2 : Complex) • targetYEnd :=
  physicalQEnd_eq_targetT3End_add_half_targetYEnd

/-- `Q_op` eigenvalue on Jbar basis state `s` matches the raw electroweak table. -/
theorem furey_qop_table_consistency (s : JbarState) :
    Q_op (JbarBasisState s) = rawQopComplex s • JbarBasisState s :=
  Q_op_eigenvalue_matches_electroweak_raw_table s

end PhysicsSM.Algebra.Furey.ElectroweakPaperPackage
