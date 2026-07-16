import PhysicsSM.Draft.NullEdge.Strict3Plus1Frontier

/-!
# Tagged zero/pi Floquet crossing balance

This module repairs the bookkeeping interface exposed by
`Strict3Plus1Frontier`: a discrete-time walk has two distinguished crossing
sectors, quasienergy zero (`+1` eigenvalue) and quasienergy pi (`-1`
eigenvalue). A global balance theorem must count both sectors before it can
support a universal doubling conclusion.

The principal theorem here is deliberately a reduction lemma. It proves that
a finite tagged crossing set with total integer charge zero and nonzero charge
at the physical origin contains another crossing. It does not construct the
charge, prove finiteness/transversality of the crossing set, or establish the
global Floquet degree theorem. Those are the genuine successor obligations.

The live split walk and body-center operator provide exact nondegenerate
fixtures for the zero and pi tags.
-/

namespace PhysicsSM.Draft.NullEdge.FloquetTaggedCrossingBalance

open Strict3Plus1Frontier
open Finite3Plus1BrillouinAudit

/-- The two distinguished Floquet crossing sectors. -/
inductive FloquetSector
  | zero
  | pi
  deriving DecidableEq, Repr

/-- A Brillouin momentum together with its Floquet crossing sector. -/
abbrev TaggedMomentum := (Fin 3 -> Real) × FloquetSector

/--
Exact determinant-level crossing predicate. The zero sector detects a `+1`
eigenvalue, while the pi sector detects a `-1` eigenvalue.
-/
def IsTaggedCrossing (U : Sym) : TaggedMomentum -> Prop
  | (q, .zero) => Matrix.det (U q - 1) = 0
  | (q, .pi) => Matrix.det (U q + 1) = 0

theorem zero_crossing_iff (U : Sym) (q : Fin 3 -> Real) :
    IsTaggedCrossing U (q, .zero) ↔ Matrix.det (U q - 1) = 0 :=
  Iff.rfl

theorem pi_crossing_iff (U : Sym) (q : Fin 3 -> Real) :
    IsTaggedCrossing U (q, .pi) ↔ Matrix.det (U q + 1) = 0 :=
  Iff.rfl

/--
Finite zero-plus-pi balance reduction. If every tagged point in `S` is an
actual crossing, the integer charge sums to zero, and `x0` has nonzero charge,
then a distinct tagged crossing exists.

This is the Floquet-sector repair of `doubling_from_balance`. The hard physics
and topology remain in constructing a canonical charge and proving its balance
on the complete crossing set.
-/
theorem tagged_doubling_from_balance
    (U : Sym) (S : Finset TaggedMomentum) (chi : TaggedMomentum -> Int)
    (hS : ∀ x ∈ S, IsTaggedCrossing U x)
    (hbal : ∑ x ∈ S, chi x = 0)
    (x0 : TaggedMomentum) (hx0 : x0 ∈ S) (hchi0 : chi x0 ≠ 0) :
    ∃ x ∈ S, x ≠ x0 ∧ IsTaggedCrossing U x := by
  classical
  by_contra hcon
  push_neg at hcon
  have hsingle : ∀ x ∈ S, x = x0 := by
    intro x hx
    by_contra hne
    exact hcon x hx hne (hS x hx)
  have hsum : ∑ x ∈ S, chi x = chi x0 := by
    refine Finset.sum_eq_single_of_mem x0 hx0 ?_
    intro x hx hne
    exact absurd (hsingle x hx) hne
  rw [hsum] at hbal
  exact hchi0 hbal

/-- The physical origin tagged in the zero-quasienergy sector. -/
def originZero : TaggedMomentum := (fun _ => 0, .zero)

/-- Every admissible walk has the intended tagged zero crossing at the origin. -/
theorem admissible_origin_tagged_crossing (W : AdmissibleWalk) :
    IsTaggedCrossing W.U originZero := by
  exact admissible_origin_alias W

/-- The body-center momentum used by the live exact crossing fixture. -/
noncomputable def bodyCenterMomentum : Fin 3 -> Real := fun _ => Real.pi / 2

/-- A constant symbol used only to test the zero/pi crossing tags. -/
noncomputable def bodyCenterSymbol (theta : Real) : Sym := fun _ => bodyCenterWalk theta

/--
The live body-center operator populates both tags exactly for every mass angle.
This is a sector-bookkeeping fixture, not a global Brillouin-zone census.
-/
theorem body_center_both_tagged_crossings (theta : Real) :
    IsTaggedCrossing (bodyCenterSymbol theta) (bodyCenterMomentum, .zero) ∧
      IsTaggedCrossing (bodyCenterSymbol theta) (bodyCenterMomentum, .pi) := by
  exact body_center_persistent_crossings theta

/-- The zero and pi tagged body-center crossings are distinct records. -/
theorem body_center_tags_distinct :
    (bodyCenterMomentum, FloquetSector.zero) ≠
      (bodyCenterMomentum, FloquetSector.pi) := by
  simp

/-- The exact two-sector body-center fixture. -/
noncomputable def bodyCenterTaggedSet : Finset TaggedMomentum :=
  {(bodyCenterMomentum, .zero), (bodyCenterMomentum, .pi)}

/-- Opposite unit charges on the zero and pi tags. -/
def sectorCharge : TaggedMomentum -> Int
  | (_, .zero) => 1
  | (_, .pi) => -1

/-- Every member of the body-center fixture is an exact tagged crossing. -/
theorem body_center_tagged_set_crossings (theta : Real) :
    ∀ x ∈ bodyCenterTaggedSet,
      IsTaggedCrossing (bodyCenterSymbol theta) x := by
  intro x hx
  simp [bodyCenterTaggedSet] at hx
  rcases hx with rfl | rfl
  · exact (body_center_both_tagged_crossings theta).1
  · exact (body_center_both_tagged_crossings theta).2

/-- The opposite fixture charges balance exactly. -/
theorem body_center_sector_charge_balance :
    ∑ x ∈ bodyCenterTaggedSet, sectorCharge x = 0 := by
  simp [bodyCenterTaggedSet, sectorCharge]

/--
Nonvacuity control for `tagged_doubling_from_balance`: the body-center zero tag
has nonzero charge, the two-sector charges balance, and the reduction returns a
distinct exact crossing (necessarily the pi tag in this two-element fixture).
-/
theorem body_center_balance_gate_nonvacuous (theta : Real) :
    ∃ x ∈ bodyCenterTaggedSet,
      x ≠ (bodyCenterMomentum, FloquetSector.zero) ∧
        IsTaggedCrossing (bodyCenterSymbol theta) x := by
  apply tagged_doubling_from_balance
      (bodyCenterSymbol theta) bodyCenterTaggedSet sectorCharge
      (body_center_tagged_set_crossings theta)
      body_center_sector_charge_balance
      (bodyCenterMomentum, FloquetSector.zero)
  · simp [bodyCenterTaggedSet]
  · simp [sectorCharge]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetTaggedCrossingBalance.tagged_doubling_from_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tagged_doubling_from_balance

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetTaggedCrossingBalance.body_center_both_tagged_crossings' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_both_tagged_crossings

/-- info: 'PhysicsSM.Draft.NullEdge.FloquetTaggedCrossingBalance.body_center_balance_gate_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms body_center_balance_gate_nonvacuous

end PhysicsSM.Draft.NullEdge.FloquetTaggedCrossingBalance
