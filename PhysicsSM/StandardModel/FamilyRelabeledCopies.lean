import Mathlib
import PhysicsSM.StandardModel.AnomalyPackage
import PhysicsSM.StandardModel.FamilyAnomalyNaturality

/-!
# Family-relabeled copies anomaly package

This module proves that any number of relabeled copies of the one-generation
Standard Model table remains anomaly-free. It connects the `nCopies` scaling
theorems from `AnomalyPackage` with the relabeling naturality theorems from
`FamilyAnomalyNaturality`.

Family copies that preserve gauge data do not disturb the already verified
anomaly cancellation arithmetic: relabeling only changes human-readable
string labels, and replication only multiplies each anomaly coefficient
by a natural number factor — zero stays zero, and even stays even.

## Claim boundary

This proves a finite table/anomaly theorem. It does not prove that a
particular family symmetry is physically realized and does not derive
the Standard Model.
-/

namespace PhysicsSM.StandardModel.FamilyRelabeledCopies

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.FamilyAnomalyNaturality

/-! ## Witten anomaly freedom scales with copies -/

/--
Witten SU(2) anomaly freedom is preserved by `nCopies`.

If the weak doublet count of a multiplet list is even, then `n` copies
of that list also have an even doublet count, since `n × (even number)`
is even.
-/
theorem WittenSU2AnomalyFree.nCopies
    (n : Nat) (ms : List ChiralMultiplet)
    (h : WittenSU2AnomalyFree ms) :
    WittenSU2AnomalyFree (nCopies n ms) := by
  unfold WittenSU2AnomalyFree
  rw [weakDoubletCount_nCopies]
  exact Even.mul_left h n

/-! ## Combined local + Witten anomaly freedom for arbitrary copies -/

/--
`n` copies of an anomaly-free multiplet list are anomaly free, both locally
(all five perturbative conditions) and globally (Witten SU(2)).
-/
theorem nCopies_anomalyFree
    (n : Nat) (ms : List ChiralMultiplet)
    (hlocal : LocalAnomalyFree ms)
    (hwitten : WittenSU2AnomalyFree ms) :
    LocalAnomalyFree (nCopies n ms) ∧
      WittenSU2AnomalyFree (nCopies n ms) :=
  ⟨nCopies_localAnomalyFree n ms hlocal,
   WittenSU2AnomalyFree.nCopies n ms hwitten⟩

/-! ## Relabeled copies of the standard one-generation table -/

/--
Arbitrary relabelings and copies of the conventional one-generation
Standard Model table remain fully anomaly free.

This combines three ingredients:
1. Relabeling preserves anomaly freedom (`LocalAnomalyFree.relabel`,
   `WittenSU2AnomalyFree_relabel`).
2. Copying preserves anomaly freedom (`nCopies_localAnomalyFree`,
   `WittenSU2AnomalyFree.nCopies`).
3. The one-generation table is anomaly free
   (`standardModelOneGeneration_localAnomalyFree`,
    `standardModelOneGeneration_wittenAnomalyFree`).
-/
theorem relabeledNCopies_standardModelOneGeneration_anomalyFree
    (n : Nat) (newLabel : ChiralMultiplet → String) :
    LocalAnomalyFree
        (nCopies n
          (relabelMultiplets newLabel standardModelOneGeneration)) ∧
      WittenSU2AnomalyFree
        (nCopies n
          (relabelMultiplets newLabel standardModelOneGeneration)) :=
  let ⟨hl, hw⟩ := standardModelOneGeneration_relabel_anomalyFree newLabel
  nCopies_anomalyFree n _ hl hw

/-! ## Paper-facing package -/

/--
A bundled record certifying that relabeled copies of the Standard Model
one-generation table are anomaly free for every number of copies and
every relabeling function.
-/
structure FamilyRelabeledCopiesPackage where
  relabeled_copies_anomaly_free :
    ∀ (n : Nat) (newLabel : ChiralMultiplet → String),
      LocalAnomalyFree
          (nCopies n
            (relabelMultiplets newLabel standardModelOneGeneration)) ∧
        WittenSU2AnomalyFree
          (nCopies n
            (relabelMultiplets newLabel standardModelOneGeneration))

/--
Construction of the family-relabeled copies anomaly package.

This is the top-level theorem: for any number of copies `n` and any
relabeling function, the resulting multiplet list is both locally and
globally anomaly free.
-/
theorem familyRelabeledCopiesPackage :
    FamilyRelabeledCopiesPackage :=
  ⟨relabeledNCopies_standardModelOneGeneration_anomalyFree⟩

end PhysicsSM.StandardModel.FamilyRelabeledCopies
