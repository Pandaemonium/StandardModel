import Mathlib
import PhysicsSM.StandardModel.FamilyRelabeledCopies
import PhysicsSM.Algebra.Furey.TrialityRolePermutation

/-!
# Anomaly append closure and triality-role copies

This module proves two things:

1. **Append closure**: local and Witten anomaly freedom are closed under
   appending multiplet lists. This follows from the fact that each anomaly
   coefficient is a sum over multiplets, and sums distribute over list
   concatenation.

2. **Triality-role-labeled copies**: using the `TrialityRole` labels
   (`spinorPlus`, `spinorMinus`, `vector`) from the Furey–Hughes triality
   triple, we define three independently relabeled one-generation tables
   and prove the combined table is anomaly free.

## Claim boundary

This is a finite list theorem about relabeled Standard Model anomaly tables.
It does not claim that physical generations are literally triality roles, and
it does not formalize the full Furey-Hughes triality mechanism.
-/

namespace PhysicsSM.StandardModel.FamilyAnomalyAppendTriality

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.FamilyAnomalyNaturality
open PhysicsSM.StandardModel.FamilyRelabeledCopies
open PhysicsSM.Algebra.Furey

/-! ## Append-linearity lemmas for anomaly coefficients -/

theorem gravitationalU1Anomaly_append
    (xs ys : List ChiralMultiplet) :
    gravitationalU1Anomaly (xs ++ ys) =
      gravitationalU1Anomaly xs + gravitationalU1Anomaly ys := by
  simp only [gravitationalU1Anomaly, List.map_append, List.sum_append]

theorem u1CubedAnomaly_append
    (xs ys : List ChiralMultiplet) :
    u1CubedAnomaly (xs ++ ys) =
      u1CubedAnomaly xs + u1CubedAnomaly ys := by
  simp only [u1CubedAnomaly, List.map_append, List.sum_append]

theorem su2SquaredU1Anomaly_append
    (xs ys : List ChiralMultiplet) :
    su2SquaredU1Anomaly (xs ++ ys) =
      su2SquaredU1Anomaly xs + su2SquaredU1Anomaly ys := by
  simp only [su2SquaredU1Anomaly, List.map_append, List.sum_append]

theorem su3SquaredU1Anomaly_append
    (xs ys : List ChiralMultiplet) :
    su3SquaredU1Anomaly (xs ++ ys) =
      su3SquaredU1Anomaly xs + su3SquaredU1Anomaly ys := by
  simp only [su3SquaredU1Anomaly, List.map_append, List.sum_append]

theorem su3CubedAnomaly_append
    (xs ys : List ChiralMultiplet) :
    su3CubedAnomaly (xs ++ ys) =
      su3CubedAnomaly xs + su3CubedAnomaly ys := by
  simp only [su3CubedAnomaly, List.map_append, List.sum_append]

theorem weakDoubletCount_append
    (xs ys : List ChiralMultiplet) :
    weakDoubletCount (xs ++ ys) =
      weakDoubletCount xs + weakDoubletCount ys := by
  simp only [weakDoubletCount, List.map_append, List.sum_append]

/-! ## Append closure for anomaly-freedom predicates -/

/--
Local anomaly freedom is closed under appending multiplet lists.

If both `xs` and `ys` are locally anomaly free (all five perturbative
anomaly coefficients vanish), then `xs ++ ys` is also locally anomaly free,
because each anomaly coefficient is additive over list concatenation and
`0 + 0 = 0`.
-/
theorem LocalAnomalyFree.append
    {xs ys : List ChiralMultiplet}
    (hx : LocalAnomalyFree xs) (hy : LocalAnomalyFree ys) :
    LocalAnomalyFree (xs ++ ys) where
  gravitational_u1 := by
    rw [gravitationalU1Anomaly_append, hx.gravitational_u1, hy.gravitational_u1]
    simp
  u1_cubed := by
    rw [u1CubedAnomaly_append, hx.u1_cubed, hy.u1_cubed]; simp
  su2_squared_u1 := by
    rw [su2SquaredU1Anomaly_append, hx.su2_squared_u1, hy.su2_squared_u1]
    simp
  su3_squared_u1 := by
    rw [su3SquaredU1Anomaly_append, hx.su3_squared_u1, hy.su3_squared_u1]
    simp
  su3_cubed := by
    rw [su3CubedAnomaly_append, hx.su3_cubed, hy.su3_cubed]; simp

/--
Witten SU(2) anomaly freedom is closed under appending multiplet lists.

If both `xs` and `ys` have an even number of weak doublets, then so does
`xs ++ ys`, because the doublet count is additive and the sum of two even
numbers is even.
-/
theorem WittenSU2AnomalyFree.append
    {xs ys : List ChiralMultiplet}
    (hx : WittenSU2AnomalyFree xs) (hy : WittenSU2AnomalyFree ys) :
    WittenSU2AnomalyFree (xs ++ ys) := by
  unfold WittenSU2AnomalyFree
  rw [weakDoubletCount_append]
  exact Even.add hx hy

/--
Combined local and Witten anomaly freedom is closed under appending.
-/
theorem anomalyFree_append
    {xs ys : List ChiralMultiplet}
    (hx : LocalAnomalyFree xs ∧ WittenSU2AnomalyFree xs)
    (hy : LocalAnomalyFree ys ∧ WittenSU2AnomalyFree ys) :
    LocalAnomalyFree (xs ++ ys) ∧
      WittenSU2AnomalyFree (xs ++ ys) :=
  ⟨LocalAnomalyFree.append hx.1 hy.1,
   WittenSU2AnomalyFree.append hx.2 hy.2⟩

/-! ## Triality-role-labeled relabeled copies -/

/--
A single one-generation table relabeled according to a triality role.

Given a labeling function `newLabel` that depends on the triality role
and the original multiplet, this produces a relabeled copy of the
standard one-generation table for a specific role.
-/
def trialityRoleRelabeledOneGeneration
    (newLabel : TrialityRole → ChiralMultiplet → String)
    (r : TrialityRole) : List ChiralMultiplet :=
  relabelMultiplets (newLabel r) standardModelOneGeneration

/--
Three copies of the one-generation table, one for each triality role.

The copies are concatenated in the order: `spinorPlus`, `spinorMinus`, `vector`.
-/
def trialityThreeRoleCopies
    (newLabel : TrialityRole → ChiralMultiplet → String) :
    List ChiralMultiplet :=
  trialityRoleRelabeledOneGeneration newLabel TrialityRole.spinorPlus ++
  trialityRoleRelabeledOneGeneration newLabel TrialityRole.spinorMinus ++
  trialityRoleRelabeledOneGeneration newLabel TrialityRole.vector

/--
The three triality-role-labeled copies of the one-generation table are
anomaly free.

Each copy is individually anomaly free (by relabeling naturality and the
one-generation anomaly freedom result), and anomaly freedom is closed
under appending.
-/
theorem trialityThreeRoleCopies_anomalyFree
    (newLabel : TrialityRole → ChiralMultiplet → String) :
    LocalAnomalyFree (trialityThreeRoleCopies newLabel) ∧
      WittenSU2AnomalyFree (trialityThreeRoleCopies newLabel) := by
  unfold trialityThreeRoleCopies
  apply anomalyFree_append
  · apply anomalyFree_append
    · exact standardModelOneGeneration_relabel_anomalyFree _
    · exact standardModelOneGeneration_relabel_anomalyFree _
  · exact standardModelOneGeneration_relabel_anomalyFree _

/-! ## Paper-facing package -/

/--
A bundled record certifying that triality-role-labeled three-generation
copies of the Standard Model are anomaly free.
-/
structure FamilyAnomalyAppendTrialityPackage where
  triality_three_role_copies_anomaly_free :
    ∀ newLabel : TrialityRole → ChiralMultiplet → String,
      LocalAnomalyFree (trialityThreeRoleCopies newLabel) ∧
        WittenSU2AnomalyFree (trialityThreeRoleCopies newLabel)

/--
Construction of the family anomaly append triality package.
-/
theorem familyAnomalyAppendTrialityPackage :
    FamilyAnomalyAppendTrialityPackage :=
  ⟨trialityThreeRoleCopies_anomalyFree⟩

end PhysicsSM.StandardModel.FamilyAnomalyAppendTriality
