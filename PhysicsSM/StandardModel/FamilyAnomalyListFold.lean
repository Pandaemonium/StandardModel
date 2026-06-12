import Mathlib
import PhysicsSM.StandardModel.FamilyAnomalyAppendTriality

/-!
# Finite-family anomaly closure by list join

This module generalizes append closure of anomaly freedom from two lists
to any finite list of multiplet lists, using `List.flatten`. It then
specializes to arbitrary finite families of relabeled one-generation
tables, including triality-role-indexed families.

## Main results

- `LocalAnomalyFree.nil`, `WittenSU2AnomalyFree.nil`: base cases for
  empty multiplet lists.
- `LocalAnomalyFree.join`, `WittenSU2AnomalyFree.join`: join closure
  for finite families.
- `relabeledOneGenerationFamilies_join_anomalyFree`: anomaly freedom
  for the join of arbitrarily many relabeled one-generation copies.
- `trialityRoleFamilies_join_anomalyFree`: anomaly freedom for
  triality-role-indexed families.
- `familyAnomalyListFoldPackage`: bundled package of results.

## Claim boundary

This is a finite list theorem about anomaly tables and relabeling. It
does not claim that a physical family symmetry exists, and it does not
prove the full Furey–Hughes triality mechanism.
-/

namespace PhysicsSM.StandardModel.FamilyAnomalyListFold

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.FamilyAnomalyNaturality
open PhysicsSM.StandardModel.FamilyRelabeledCopies
open PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
open PhysicsSM.Algebra.Furey

/-! ## Empty-list base cases -/

/-- The empty multiplet list is locally anomaly free. -/
theorem LocalAnomalyFree.nil : LocalAnomalyFree [] := by
  constructor <;> rfl

/-- The empty multiplet list satisfies the Witten SU(2) anomaly
condition. -/
theorem WittenSU2AnomalyFree.nil : WittenSU2AnomalyFree [] := by
  exact ⟨0, rfl⟩

/-- The empty multiplet list is anomaly free (both local and
Witten). -/
theorem anomalyFree_nil :
    LocalAnomalyFree [] ∧ WittenSU2AnomalyFree [] :=
  ⟨LocalAnomalyFree.nil, WittenSU2AnomalyFree.nil⟩

/-! ## Join closure -/

/-- Local anomaly freedom is closed under joining a finite list of
multiplet lists. -/
theorem LocalAnomalyFree.join
    {families : List (List ChiralMultiplet)}
    (h : families.Forall LocalAnomalyFree) :
    LocalAnomalyFree families.flatten := by
  induction families with
  | nil => exact LocalAnomalyFree.nil
  | cons f families ih =>
    simp_all +decide [List.forall_cons]
    exact LocalAnomalyFree.append h.1 ih

/-- Witten SU(2) anomaly freedom is closed under joining a finite list
of multiplet lists. -/
theorem WittenSU2AnomalyFree.join
    {families : List (List ChiralMultiplet)}
    (h : families.Forall WittenSU2AnomalyFree) :
    WittenSU2AnomalyFree families.flatten := by
  induction families <;>
    simp_all +decide [WittenSU2AnomalyFree.append]
  exact ⟨0, rfl⟩

/-- Combined local and Witten anomaly freedom is closed under
joining. -/
theorem anomalyFree_join
    {families : List (List ChiralMultiplet)}
    (h : families.Forall
      (fun ms => LocalAnomalyFree ms ∧ WittenSU2AnomalyFree ms)) :
    LocalAnomalyFree families.flatten ∧
      WittenSU2AnomalyFree families.flatten := by
  induction families <;> simp_all +decide [List.Forall]
  · exact ⟨LocalAnomalyFree.nil, WittenSU2AnomalyFree.nil⟩
  · exact ⟨LocalAnomalyFree.append h.1.1 (by tauto),
           WittenSU2AnomalyFree.append h.1.2 (by tauto)⟩

/-! ## Relabeled one-generation families -/

/-- The list of multiplet lists obtained by relabeling the standard
one-generation table with each label function in `labels`. -/
def relabeledOneGenerationFamilies
    (labels : List (ChiralMultiplet → String)) :
    List (List ChiralMultiplet) :=
  labels.map (fun newLabel =>
    relabelMultiplets newLabel standardModelOneGeneration)

/-- The join of arbitrarily many relabeled one-generation copies is
anomaly free. -/
theorem relabeledOneGenerationFamilies_join_anomalyFree
    (labels : List (ChiralMultiplet → String)) :
    LocalAnomalyFree
      (relabeledOneGenerationFamilies labels).flatten ∧
    WittenSU2AnomalyFree
      (relabeledOneGenerationFamilies labels).flatten := by
  apply anomalyFree_join
  exact List.forall_iff_forall_mem.mpr fun ms hms => by
    obtain ⟨newLabel, _, rfl⟩ := List.mem_map.mp hms
    exact standardModelOneGeneration_relabel_anomalyFree newLabel

/-! ## Triality-role-indexed families -/

/-- The list of multiplet lists obtained by mapping each triality role
to its relabeled one-generation table. -/
def trialityRoleFamilies
    (roles : List TrialityRole)
    (newLabel : TrialityRole → ChiralMultiplet → String) :
    List (List ChiralMultiplet) :=
  roles.map (trialityRoleRelabeledOneGeneration newLabel)

/-- The join of triality-role-indexed relabeled one-generation copies
is anomaly free. -/
theorem trialityRoleFamilies_join_anomalyFree
    (roles : List TrialityRole)
    (newLabel : TrialityRole → ChiralMultiplet → String) :
    LocalAnomalyFree
      (trialityRoleFamilies roles newLabel).flatten ∧
    WittenSU2AnomalyFree
      (trialityRoleFamilies roles newLabel).flatten := by
  apply anomalyFree_join
  simp only [trialityRoleFamilies, List.forall_map_iff]
  exact List.forall_iff_forall_mem.mpr fun r _ =>
    standardModelOneGeneration_relabel_anomalyFree (newLabel r)

/-! ## Paper-facing package -/

/-- Bundled record certifying anomaly freedom for finite families
of relabeled one-generation Standard Model tables. -/
structure FamilyAnomalyListFoldPackage where
  finite_relabel_family_anomaly_free :
    ∀ labels : List (ChiralMultiplet → String),
      LocalAnomalyFree
        (relabeledOneGenerationFamilies labels).flatten ∧
      WittenSU2AnomalyFree
        (relabeledOneGenerationFamilies labels).flatten
  finite_triality_role_family_anomaly_free :
    ∀ (roles : List TrialityRole)
      (newLabel : TrialityRole → ChiralMultiplet → String),
      LocalAnomalyFree
        (trialityRoleFamilies roles newLabel).flatten ∧
      WittenSU2AnomalyFree
        (trialityRoleFamilies roles newLabel).flatten

/-- Construction of the family anomaly list fold package. -/
theorem familyAnomalyListFoldPackage :
    FamilyAnomalyListFoldPackage :=
  ⟨relabeledOneGenerationFamilies_join_anomalyFree,
   trialityRoleFamilies_join_anomalyFree⟩

end PhysicsSM.StandardModel.FamilyAnomalyListFold
