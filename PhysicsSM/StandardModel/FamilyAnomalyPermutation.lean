import Mathlib
import PhysicsSM.StandardModel.FamilyAnomalyListFold

/-!
# Anomaly invariance under list permutation

This module proves that the anomaly coefficients and anomaly-freedom
predicates defined in `AnomalyPackage` are invariant under permutation
(`List.Perm`) of the multiplet list. This complements the append and
list-fold family results by showing that the *order* of family copies is
irrelevant.

## Main results

- `gravitationalU1Anomaly_perm`, `u1CubedAnomaly_perm`, etc.: each
  anomaly coefficient is invariant under `List.Perm`.
- `LocalAnomalyFree.perm`, `WittenSU2AnomalyFree.perm`: the anomaly-freedom
  predicates transfer across permutations.
- `anomalyFree_perm`: combined version.
- `familyAnomalyPermutationPackage`: bundled record.

## Claim boundary

This proves finite list/order invariance for anomaly arithmetic. It does
not claim a physical family symmetry, a new anomaly-cancellation mechanism,
or a derivation of the Standard Model.
-/

namespace PhysicsSM.StandardModel.FamilyAnomalyPermutation

open PhysicsSM.StandardModel.AnomalyPackage
open PhysicsSM.StandardModel.FamilyAnomalyListFold

/-! ## Anomaly coefficient invariance -/

theorem gravitationalU1Anomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    gravitationalU1Anomaly xs = gravitationalU1Anomaly ys :=
  (h.map _).sum_eq

theorem u1CubedAnomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    u1CubedAnomaly xs = u1CubedAnomaly ys :=
  (h.map _).sum_eq

theorem su2SquaredU1Anomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    su2SquaredU1Anomaly xs = su2SquaredU1Anomaly ys :=
  (h.map _).sum_eq

theorem su3SquaredU1Anomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    su3SquaredU1Anomaly xs = su3SquaredU1Anomaly ys :=
  (h.map _).sum_eq

theorem su3CubedAnomaly_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    su3CubedAnomaly xs = su3CubedAnomaly ys :=
  (h.map _).sum_eq

theorem weakDoubletCount_perm
    {xs ys : List ChiralMultiplet}
    (h : xs.Perm ys) :
    weakDoubletCount xs = weakDoubletCount ys :=
  (h.map _).sum_eq

/-! ## Predicate-level invariance -/

theorem LocalAnomalyFree.perm
    {xs ys : List ChiralMultiplet}
    (hperm : xs.Perm ys)
    (hxs : LocalAnomalyFree xs) :
    LocalAnomalyFree ys :=
  { gravitational_u1 := gravitationalU1Anomaly_perm hperm ▸ hxs.gravitational_u1
    u1_cubed         := u1CubedAnomaly_perm hperm ▸ hxs.u1_cubed
    su2_squared_u1   := su2SquaredU1Anomaly_perm hperm ▸ hxs.su2_squared_u1
    su3_squared_u1   := su3SquaredU1Anomaly_perm hperm ▸ hxs.su3_squared_u1
    su3_cubed        := su3CubedAnomaly_perm hperm ▸ hxs.su3_cubed }

theorem WittenSU2AnomalyFree.perm
    {xs ys : List ChiralMultiplet}
    (hperm : xs.Perm ys)
    (hxs : WittenSU2AnomalyFree xs) :
    WittenSU2AnomalyFree ys := by
  unfold WittenSU2AnomalyFree
  rw [← weakDoubletCount_perm hperm]
  exact hxs

theorem anomalyFree_perm
    {xs ys : List ChiralMultiplet}
    (hperm : xs.Perm ys)
    (hxs : LocalAnomalyFree xs ∧ WittenSU2AnomalyFree xs) :
    LocalAnomalyFree ys ∧ WittenSU2AnomalyFree ys :=
  ⟨LocalAnomalyFree.perm hperm hxs.1, WittenSU2AnomalyFree.perm hperm hxs.2⟩

/-! ## Bundled package -/

/-- Bundled record certifying that combined anomaly freedom is invariant
under permutation of the multiplet list. -/
structure FamilyAnomalyPermutationPackage where
  anomaly_free_perm :
    ∀ {xs ys : List ChiralMultiplet},
      xs.Perm ys →
      LocalAnomalyFree xs ∧ WittenSU2AnomalyFree xs →
      LocalAnomalyFree ys ∧ WittenSU2AnomalyFree ys

/-- Construction of the family anomaly permutation package. -/
theorem familyAnomalyPermutationPackage :
    FamilyAnomalyPermutationPackage :=
  ⟨fun hp hxs => anomalyFree_perm hp hxs⟩

end PhysicsSM.StandardModel.FamilyAnomalyPermutation
