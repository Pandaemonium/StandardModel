/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Harmonic/Aristotle
-/
import Mathlib
import PhysicsSM.StandardModel.FamilySymmetry

/-!
# Family-Orbit Naturality

This file extends the generic family-symmetry naturality API with
orbit-level helper theorems: invariant functions and invariant charge
tables have the same values after one or two formal family
transformations, and the Gell-Mann–Nishijima relation is stable under
these transformations.

## Main results

- `ChargeTable.same_charges_of_related`: one-action charge equality.
- `table_value_transport_two`: two-action transport for arbitrary
  invariant functions.
- `ChargeTable.same_charges_after_two_actions`: two-action charge equality.
- `ChargeTable.gmn_transport_two`: GMN at a doubly-transformed index.
- `ChargeTable.gmn_transport_two_inv`: GMN rewritten back via invariance.
- `FamilyOrbitNaturalityPackage`: bundled package of the main results.

## Claim boundary

This is an abstract invariance theorem for charge tables under formal
family actions. It does not assert that any particular physical family
action exists.
-/

namespace PhysicsSM.StandardModel.FamilyOrbitNaturality

open PhysicsSM.StandardModel.FamilySymmetry

/-- One-action charge equality: all three charges at `g • i` equal
those at `i` when the charge table is invariant. -/
theorem ChargeTable.same_charges_of_related
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G) (g : G) (i : I) :
    t.electric (SMul.smul g i) = t.electric i ∧
      t.weakT3 (SMul.smul g i) = t.weakT3 i ∧
      t.hypercharge (SMul.smul g i) = t.hypercharge i :=
  ⟨hinv.1 g i, hinv.2.1 g i, hinv.2.2 g i⟩

/-- Two-action transport for an arbitrary invariant function: applying
two successive `SMul` actions preserves the value, using invariance
twice without any group laws. -/
theorem table_value_transport_two
    {G I A : Type*} [SMul G I] (q : I → A)
    (h : InvariantUnderFamilyAction G q)
    (g hG : G) (i : I) :
    q (SMul.smul g (SMul.smul hG i)) = q i :=
  (h g (hG • i)).trans (h hG i)

/-- Two-action charge equality: all three charges at `g • (hG • i)`
equal those at `i`. -/
theorem ChargeTable.same_charges_after_two_actions
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G) (g hG : G) (i : I) :
    t.electric (SMul.smul g (SMul.smul hG i)) = t.electric i ∧
      t.weakT3 (SMul.smul g (SMul.smul hG i)) = t.weakT3 i ∧
      t.hypercharge (SMul.smul g (SMul.smul hG i)) = t.hypercharge i :=
  ⟨table_value_transport_two _ hinv.1 g hG i,
   table_value_transport_two _ hinv.2.1 g hG i,
   table_value_transport_two _ hinv.2.2 g hG i⟩

/-- The GMN relation holds at a doubly-transformed index `g • (hG • i)`,
directly from `SatisfiesGMN`. -/
theorem ChargeTable.gmn_transport_two
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hgmn : t.SatisfiesGMN) (g hG : G) (i : I) :
    t.electric (SMul.smul g (SMul.smul hG i)) =
      t.weakT3 (SMul.smul g (SMul.smul hG i)) +
        t.hypercharge (SMul.smul g (SMul.smul hG i)) / 2 :=
  hgmn _

/-- The GMN relation at a doubly-transformed index, rewritten back to
the original index using invariance. -/
theorem ChargeTable.gmn_transport_two_inv
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G)
    (hgmn : t.SatisfiesGMN) (g hG : G) (i : I) :
    t.electric (SMul.smul g (SMul.smul hG i)) =
      t.weakT3 i + t.hypercharge i / 2 := by
  have h := same_charges_after_two_actions t hinv g hG i
  rw [show t.electric (SMul.smul g (SMul.smul hG i)) = t.electric i from h.1]
  exact hgmn i

/-- Bundled package of orbit-naturality results for charge tables. -/
structure FamilyOrbitNaturalityPackage where
  same_charges :
    ∀ {G I : Type*} [SMul G I] (t : ChargeTable I),
      t.InvariantUnderFamilyAction G →
        ∀ (g : G) (i : I),
          t.electric (SMul.smul g i) = t.electric i ∧
          t.weakT3 (SMul.smul g i) = t.weakT3 i ∧
          t.hypercharge (SMul.smul g i) = t.hypercharge i
  same_charges_two :
    ∀ {G I : Type*} [SMul G I] (t : ChargeTable I),
      t.InvariantUnderFamilyAction G →
        ∀ (g hG : G) (i : I),
          t.electric (SMul.smul g (SMul.smul hG i)) = t.electric i ∧
          t.weakT3 (SMul.smul g (SMul.smul hG i)) = t.weakT3 i ∧
          t.hypercharge (SMul.smul g (SMul.smul hG i)) = t.hypercharge i

/-- The family-orbit naturality package is satisfied by the theorems
proved in this file. -/
theorem familyOrbitNaturalityPackage : FamilyOrbitNaturalityPackage :=
  ⟨fun t hinv g i => ChargeTable.same_charges_of_related t hinv g i,
   fun t hinv g hG i => ChargeTable.same_charges_after_two_actions t hinv g hG i⟩

end PhysicsSM.StandardModel.FamilyOrbitNaturality
