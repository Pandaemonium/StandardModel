import PhysicsSM.Draft.NullEdge.HNUExactCore
import PhysicsSM.Draft.NullEdge.HNULocalChargeBalance

/-!
# HNU global zero/pi crossing ledger and its missing datum

This module connects the exact HNU endpoint census to the local `+1` Weyl
Jacobian without inventing a global signed charge.  It proves unconditionally
that both the zero and pi Floquet sectors contain exact crossings.  It then
proves a partner theorem under a displayed finite zero-total-charge premise.

The central negative result is `no_endpoint_value_charge_adapter`: endpoint
values alone cannot recover local orientation, since oppositely oriented Weyl
Jacobians can share the same endpoint value at a crossing.  A global signed
ledger therefore requires derivative, micromotion, Berry, or equivalent
oriented data beyond the endpoint census.

The concrete two-entry `hnuLedger` is only a nonvacuity fixture.  Its `+1` and `-1`
charge assignment is not derived from the endpoint and is not a Brillouin-zone
classification.

Provenance: Aristotle project `c626cb61-f1db-49ff-aa41-a9d96e9152ad`, task
`e686ea99-0229-497c-ad7c-39fdba417a96`.  The return was independently retargeted
and replayed against the live imports in
`AutonomousLab/reviews/CLAUDE_REVIEW_HNUGlobalZeroPiChargeLedger_2026-07-13.md`.
-/

noncomputable section

open Matrix
open scoped BigOperators
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.SU2LocalCrossingCharge
open PhysicsSM.Draft.NullEdge.HNUInfraredWeylCharge
open PhysicsSM.Draft.NullEdge.ChargeBalanceForcesPartner
open PhysicsSM.Draft.NullEdge.HNULocalChargeBalance

namespace PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger

/-- The two distinguished Floquet crossing sectors. -/
inductive Sector
  | zero
  | pi
  deriving DecidableEq, Repr

/-- A momentum tagged by its zero or pi quasienergy sector. -/
abbrev TaggedPoint := (Fin 3 -> Real) × Sector

/-- Exact unsigned crossing predicate for the live HNU endpoint. -/
def IsHNUCrossing : TaggedPoint -> Prop
  | (k, Sector.zero) => (endpoint k - 1).det = 0
  | (k, Sector.pi) => (endpoint k + 1).det = 0

/-- The exact origin is a zero-sector crossing. -/
theorem hnu_origin_zero_crossing : IsHNUCrossing (0, Sector.zero) := by
  show (endpoint 0 - 1).det = 0
  rw [endpoint_zero, sub_self, Matrix.det_zero ⟨0⟩]

/-- Every exact HNU face with one coordinate equal to pi is a pi-sector
crossing. -/
theorem hnu_pi_crossing_of_face {k : Fin 3 -> Real} {i : Fin 3}
    (h : k i = Real.pi) :
    IsHNUCrossing (k, Sector.pi) := by
  show (endpoint k + 1).det = 0
  rw [endpoint_pi k (i := i) h, neg_add_cancel, Matrix.det_zero ⟨0⟩]

/-- A concrete exact pi-sector crossing. -/
theorem hnu_pi_crossing_face0 :
    IsHNUCrossing (![Real.pi, 0, 0], Sector.pi) :=
  hnu_pi_crossing_of_face (i := 0) rfl

/-- Both distinguished Floquet sectors are populated by the exact endpoint. -/
theorem hnu_both_sectors_populated :
    IsHNUCrossing (0, Sector.zero) ∧
      IsHNUCrossing (![Real.pi, 0, 0], Sector.pi) :=
  ⟨hnu_origin_zero_crossing, hnu_pi_crossing_face0⟩

/-- A finite exact-crossing ledger with zero total signed charge and one
nonzero-charge member contains a distinct exact crossing.  The balance premise
is supplied data, not a consequence of `IsHNUCrossing`. -/
theorem exists_distinct_tagged_crossing_of_total_zero
    (S : Finset TaggedPoint) (charge : TaggedPoint -> Int)
    (hS : ∀ x ∈ S, IsHNUCrossing x)
    (x0 : TaggedPoint) (hx0 : x0 ∈ S) (hcharge0 : charge x0 ≠ 0)
    (hbal : ∑ x ∈ S, charge x = 0) :
    ∃ x ∈ S, x ≠ x0 ∧ IsHNUCrossing x := by
  obtain ⟨x1, hx1, hne, _⟩ :=
    exists_second_nonzero_of_sum_eq_zero S charge x0 hx0 hcharge0 hbal
  exact ⟨x1, hx1, hne, hS x1 hx1⟩

/-- The exact local HNU infrared charge is `+1`. -/
theorem hnu_local_charge_one : localCrossingCharge weylJacobian = 1 :=
  hnuLocalCrossingCharge_eq_one

/-- If the exact HNU origin charge is placed in a finite zero/pi ledger whose
total signed charge is supplied to be zero, a distinct exact crossing follows. -/
theorem hnu_zero_pi_ledger_forces_partner
    (S : Finset TaggedPoint) (charge : TaggedPoint -> Int)
    (hS : ∀ x ∈ S, IsHNUCrossing x)
    (hmem : (0, Sector.zero) ∈ S)
    (hcharge : charge (0, Sector.zero) =
      localCrossingCharge weylJacobian)
    (hbal : ∑ x ∈ S, charge x = 0) :
    ∃ x ∈ S, x ≠ (0, Sector.zero) ∧ IsHNUCrossing x := by
  refine exists_distinct_tagged_crossing_of_total_zero S charge hS
    (0, Sector.zero) hmem ?_ hbal
  rw [hcharge, hnu_local_charge_one]
  norm_num

/-- The same conditional partner result through the live Jacobian API. -/
theorem hnu_jacobian_ledger_forces_partner
    {ι : Type*} (S : Finset ι) (J : ι -> J3)
    (i0 : ι) (hi0 : i0 ∈ S) (hHNU : J i0 = weylJacobian)
    (hsum : ∑ i ∈ S, localCrossingCharge (J i) = 0) :
    ∃ i1 ∈ S, i1 ≠ i0 ∧ (J i1).det ≠ 0 :=
  exists_distinct_partner_of_total_charge_zero S J i0 hi0 hHNU hsum

/-- **Endpoint-value insufficiency.** No integer-valued function of the
endpoint value at the origin can simultaneously recover the charges of the
oppositely oriented Weyl Jacobian controls. -/
theorem no_endpoint_value_charge_adapter :
    ¬ ∃ g : Matrix (Fin 2) (Fin 2) Complex -> Int,
      g (endpoint 0) = localCrossingCharge weylPlusJacobian ∧
      g (endpoint 0) = localCrossingCharge weylMinusJacobian := by
  rintro ⟨g, hplus, hminus⟩
  rw [weylPlus_charge] at hplus
  rw [weylMinus_charge] at hminus
  have hbad : (1 : Int) = -1 := hplus.symm.trans hminus
  norm_num at hbad

/-- Without a balance certificate, the singleton origin ledger has no partner. -/
theorem singleton_origin_no_partner :
    ¬ ∃ x ∈ ({(0, Sector.zero)} : Finset TaggedPoint),
      x ≠ (0, Sector.zero) ∧ IsHNUCrossing x := by
  rintro ⟨x, hx, hne, _⟩
  rw [Finset.mem_singleton] at hx
  exact hne hx

/-- Fixture-only opposite sector charges; these are not endpoint-derived. -/
def hnuSectorCharge : TaggedPoint -> Int
  | (_, Sector.zero) => 1
  | (_, Sector.pi) => -1

/-- A two-entry nonvacuity fixture using exact crossings in both sectors. -/
noncomputable def hnuLedger : Finset TaggedPoint :=
  {(0, Sector.zero), (![Real.pi, 0, 0], Sector.pi)}

theorem hnuLedger_origin_charge :
    hnuSectorCharge (0, Sector.zero) =
      localCrossingCharge weylJacobian := by
  rw [hnu_local_charge_one]
  rfl

theorem hnuLedger_origin_mem : (0, Sector.zero) ∈ hnuLedger := by
  simp [hnuLedger]

theorem hnuLedger_entries_distinct :
    ((0 : Fin 3 -> Real), Sector.zero) ≠
      (![Real.pi, 0, 0], Sector.pi) := by
  intro h
  exact absurd (congrArg Prod.snd h) (by decide)

theorem hnuLedger_all_crossings :
    ∀ x ∈ hnuLedger, IsHNUCrossing x := by
  intro x hx
  simp only [hnuLedger, Finset.mem_insert, Finset.mem_singleton] at hx
  rcases hx with rfl | rfl
  · exact hnu_origin_zero_crossing
  · exact hnu_pi_crossing_face0

theorem hnuLedger_total_charge_zero :
    ∑ x ∈ hnuLedger, hnuSectorCharge x = 0 := by
  rw [hnuLedger, Finset.sum_insert (by
    rw [Finset.mem_singleton]
    exact hnuLedger_entries_distinct), Finset.sum_singleton]
  rfl

/-- Applying the conditional theorem to the explicit fixture is nonvacuous. -/
theorem hnuLedger_forces_partner :
    ∃ x ∈ hnuLedger, x ≠ (0, Sector.zero) ∧ IsHNUCrossing x := by
  exact hnu_zero_pi_ledger_forces_partner hnuLedger hnuSectorCharge
    hnuLedger_all_crossings hnuLedger_origin_mem hnuLedger_origin_charge
    hnuLedger_total_charge_zero

/-- The singleton fixture fails the zero-total-charge premise. -/
theorem singleton_origin_charge_sum_ne_zero :
    ∑ x ∈ ({(0, Sector.zero)} : Finset TaggedPoint),
      hnuSectorCharge x ≠ 0 := by
  rw [Finset.sum_singleton]
  decide

end PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger

/-! Build-enforced assumption-footprint guards. -/

open PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger.hnu_both_sectors_populated' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hnu_both_sectors_populated

open PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger.hnu_zero_pi_ledger_forces_partner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hnu_zero_pi_ledger_forces_partner

open PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger.no_endpoint_value_charge_adapter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_endpoint_value_charge_adapter

open PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger.hnuLedger_forces_partner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hnuLedger_forces_partner

open PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger in
/-- info: 'PhysicsSM.Draft.NullEdge.HNUGlobalZeroPiChargeLedger.singleton_origin_no_partner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms singleton_origin_no_partner
