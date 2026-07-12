/-
Provenance: Aristotle audit-gap closure, 2026-07-12. KERNEL-ONLY.

Purpose: close the audit gap flagged against `context/SplitStepSchurJetAllNodes.lean`.
That module DERIVES the 8-node charge census from the walk symbol, but ties the
derivation to a MODULE-LOCAL re-declaration of the census (`census`, built from
its local `Jplus_census`/`Jminus_census`/`nodeParity`), described in-source as
"copied verbatim" from the landed `context/SplitStepChargeBalance.lean`.  Nothing
imported forced the local copy to agree with the landed definition, so a silent
divergence ("drift") between the two could have passed unnoticed.

This file IMPORTS BOTH modules and machine-checks that the two `census` functions
are EQUAL as functions on the whole finite domain `(Fin 3 → Bool) × Bool`
(16 points), and states the capstone: the all-nodes module's walk-derived charge
table (`census_chargeOf_gap0`/`census_chargeOf_gapPi`) equals `chargeOf` applied to
the LANDED `SplitStepChargeBalance.census` assignment - i.e. the derivation from
the walk symbol reproduces THE LANDED census, not merely a local copy.

Finding: the two census definitions DO NOT drift; they are equal everywhere, and
the equality is proved kernel-only.  Had they differed, the equality below would be
false and would fail to elaborate; the divergence would then be a first-class
finding requiring a correction notice.
-/
import context.SplitStepChargeBalance
import context.SplitStepSchurJetAllNodes

open PhysicsSM.Draft.NullEdge

namespace CensusDerivationBridge

/-! ## Aliases for the two independently-declared census assignments

* `Local`  = `SplitStepSchurJetAllNodes.census`  — the module-local re-declaration
  living next to the walk-symbol derivation.
* `Landed` = `SplitStepChargeBalance.census`      — the landed fixture census.

We refer to both by fully-qualified names below to make the provenance explicit. -/

/-- **Census agreement (pointwise).**  For every node `n : Fin 3 → Bool` and gap
`g : Bool`, the module-local census of `SplitStepSchurJetAllNodes` equals the
landed census of `SplitStepChargeBalance`.  Both unfold to the same
`if Bool.xor (nodeParity n) g then Jminus else Jplus` with identical matrix
literals and identical parity, so the equality holds by `rfl` (finite/kernel). -/
theorem census_agree (n : Fin 3 → Bool) (g : Bool) :
    SplitStepSchurJetAllNodes.census n g = SplitStepChargeBalance.census n g := by
  rfl

/-- **Census agreement (as functions).**  The two census definitions coincide as
functions on the whole 16-element domain `(Fin 3 → Bool) × Bool`. -/
theorem census_funext :
    (SplitStepSchurJetAllNodes.census) = (SplitStepChargeBalance.census) := by
  funext n g
  exact census_agree n g

/-- **`chargeOf` agreement.**  The two independently-declared sign-charge functions
coincide on every Jacobian. -/
theorem chargeOf_agree (J : Matrix (Fin 3) (Fin 3) ℝ) :
    SplitStepSchurJetAllNodes.chargeOf J = SplitStepChargeBalance.chargeOf J := by
  rfl

/-! ## Capstone: the walk-derived charge table reproduces the LANDED census -/

/-- **Capstone (both gaps).**  The all-nodes module's charge of its (walk-tied)
census equals `chargeOf` applied to the LANDED `SplitStepChargeBalance.census`
assignment, for every node and gap.  This is the tie that was missing: the
derivation is anchored to the landed census, not merely to a local copy. -/
theorem capstone_charge_reproduces_landed (n : Fin 3 → Bool) (g : Bool) :
    SplitStepSchurJetAllNodes.chargeOf (SplitStepSchurJetAllNodes.census n g)
      = SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n g) := by
  rw [census_agree, chargeOf_agree]

/-- **Capstone, gap 0.**  The all-nodes `census_chargeOf_gap0` value equals
`chargeOf` of the landed census at gap 0. -/
theorem capstone_gap0 (n : Fin 3 → Bool) :
    SplitStepSchurJetAllNodes.chargeOf (SplitStepSchurJetAllNodes.census n false)
      = SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n false) :=
  capstone_charge_reproduces_landed n false

/-- **Capstone, gap π.**  The all-nodes `census_chargeOf_gapPi` value equals
`chargeOf` of the landed census at gap π. -/
theorem capstone_gapPi (n : Fin 3 → Bool) :
    SplitStepSchurJetAllNodes.chargeOf (SplitStepSchurJetAllNodes.census n true)
      = SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n true) :=
  capstone_charge_reproduces_landed n true

/-- **Capstone, explicit values (gap 0).**  Chaining the all-nodes derivation
`census_chargeOf_gap0` through the census/chargeOf agreement, the LANDED census
charge at gap 0 equals the parity rule `if nodeParity n then -1 else 1`, exactly
as re-derived from the walk symbol. -/
theorem landed_chargeOf_gap0 (n : Fin 3 → Bool) :
    SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n false)
      = if SplitStepSchurJetAllNodes.nodeParity n then -1 else 1 := by
  rw [← capstone_gap0]
  exact SplitStepSchurJetAllNodes.census_chargeOf_gap0 n

/-- **Capstone, explicit values (gap π).**  As above at gap π, via
`census_chargeOf_gapPi`. -/
theorem landed_chargeOf_gapPi (n : Fin 3 → Bool) :
    SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n true)
      = if Bool.xor (SplitStepSchurJetAllNodes.nodeParity n) true then -1 else 1 := by
  rw [← capstone_gapPi]
  exact SplitStepSchurJetAllNodes.census_chargeOf_gapPi n

/-! ## Tie to the genuine walk-symbol Jacobians

The all-nodes module derives its census from the walk symbol via the documented
`J_recorded = -J_here` bridge: `census n false = -(walkJac0 n)` and
`census n true = -(walkJacPi n)`, where `walkJac0`/`walkJacPi` are compressions of
the exact Bloch symbol.  Hence the landed census charge equals the negation of the
genuine walk-derived Jacobian charge. -/

/-- The landed census charge at gap 0 is the negation of the walk-symbol Jacobian
charge `chargeOf (walkJac0 n)` (documented `J_recorded = -J_here` sign flip). -/
theorem landed_gap0_eq_neg_walk (n : Fin 3 → Bool) :
    SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n false)
      = - SplitStepSchurJetAllNodes.chargeOf (SplitStepSchurJetAllNodes.walkJac0 n) := by
  rw [landed_chargeOf_gap0, SplitStepSchurJetAllNodes.chargeOf_walkJac0]
  cases SplitStepSchurJetAllNodes.nodeParity n <;> simp

/-- The landed census charge at gap π is the negation of the walk-symbol Jacobian
charge `chargeOf (walkJacPi n)`. -/
theorem landed_gapPi_eq_neg_walk (n : Fin 3 → Bool) :
    SplitStepChargeBalance.chargeOf (SplitStepChargeBalance.census n true)
      = - SplitStepSchurJetAllNodes.chargeOf (SplitStepSchurJetAllNodes.walkJacPi n) := by
  rw [landed_chargeOf_gapPi, SplitStepSchurJetAllNodes.chargeOf_walkJacPi]
  cases SplitStepSchurJetAllNodes.nodeParity n <;> simp

end CensusDerivationBridge
