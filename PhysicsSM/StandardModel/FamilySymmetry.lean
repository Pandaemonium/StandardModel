/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Harmonic/Aristotle
-/
import Mathlib

/-!
# Family-Symmetry Naturality

This file provides a generic mathematical theorem package for
**family-symmetry naturality**: if a family symmetry commutes with a charge
or gauge operator, then eigenvectors and charge-table identities transport
across the family orbit.

## Overview

We define:
- `CommutesWithLinearEquiv`: a predicate saying a linear operator commutes
  with a linear equivalence.
- `eigenvector_transport` / `eigenvector_transport_symm`: eigenvectors are
  transported along the family equivalence and its inverse.
- `InvariantUnderFamilyAction`: a predicate saying a function on an index
  type is invariant under a group action.
- `ChargeTable`: a bundled table of electric charge, weak isospin T₃,
  and hypercharge for each family index.
- `ChargeTable.SatisfiesGMN`: the Gell-Mann–Nishijima relation Q = T₃ + Y/2.
- `ChargeTable.SatisfiesGMN.apply`: the GMN relation can be evaluated at any
  family index.

## Claim boundary

This file proves an abstract naturality theorem. It does **not** assert that
any particular family action is realized physically, and it does **not** claim
a full three-generation Standard Model derivation.
-/

namespace PhysicsSM.StandardModel.FamilySymmetry

/-! ### Linear operator naturality -/

/-- A linear operator `A` commutes with a linear equivalence `e` when
`A` after `e` equals `e` after `A` pointwise. -/
def CommutesWithLinearEquiv
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M →ₗ[K] M) (e : M ≃ₗ[K] M) : Prop :=
  ∀ x, A (e x) = e (A x)

/-- If `A` commutes with `e` and `x` is a `λ`-eigenvector of `A`, then
`e x` is also a `λ`-eigenvector. -/
theorem eigenvector_transport
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M →ₗ[K] M) (e : M ≃ₗ[K] M) (lambda : K) (x : M)
    (hcomm : CommutesWithLinearEquiv A e)
    (heig : A x = lambda • x) :
    A (e x) = lambda • e x := by
  rw [hcomm x, heig, map_smul]

/-- Symmetric version: if `A` commutes with `e`, then `e.symm x` is also
a `λ`-eigenvector whenever `x` is. -/
theorem eigenvector_transport_symm
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : M →ₗ[K] M) (e : M ≃ₗ[K] M) (lambda : K) (x : M)
    (hcomm : CommutesWithLinearEquiv A e)
    (heig : A x = lambda • x) :
    A (e.symm x) = lambda • e.symm x := by
  have hcomm_symm : CommutesWithLinearEquiv A e.symm := fun y => by
    have h := hcomm (e.symm y)
    simp only [LinearEquiv.apply_symm_apply] at h
    rw [h]
    simp only [LinearEquiv.symm_apply_apply]
  exact eigenvector_transport A e.symm lambda x hcomm_symm heig

/-! ### Finite table naturality -/

/-- A function `q : I → A` is invariant under a `G`-action on `I` when
`q (g • i) = q i` for all `g` and `i`. -/
def InvariantUnderFamilyAction
    (G : Type*) {I A : Type*} [SMul G I] (q : I → A) : Prop :=
  ∀ (g : G) (i : I), q (g • i) = q i

/-- Direct consequence of invariance: `q` at `g • i` equals `q` at `i`. -/
theorem table_value_transport
    (G : Type*) {I A : Type*} [SMul G I] (q : I → A)
    (h : InvariantUnderFamilyAction G q) (g : G) (i : I) :
    q (g • i) = q i :=
  h g i

/-! ### Charge tables and the Gell-Mann–Nishijima relation -/

/-- A charge table assigns electric charge, weak isospin T₃, and
hypercharge to each member of a family index type `I`. -/
structure ChargeTable (I : Type*) where
  /-- Electric charge Q -/
  electric : I → ℚ
  /-- Weak isospin third component T₃ -/
  weakT3 : I → ℚ
  /-- Hypercharge Y -/
  hypercharge : I → ℚ

/-- A charge table is invariant under a family action when all three
fields are individually invariant. -/
def ChargeTable.InvariantUnderFamilyAction
    (G : Type*) {I : Type*} [SMul G I] (t : ChargeTable I) : Prop :=
  (∀ (g : G) (i : I), t.electric (g • i) = t.electric i) ∧
  (∀ (g : G) (i : I), t.weakT3 (g • i) = t.weakT3 i) ∧
  (∀ (g : G) (i : I), t.hypercharge (g • i) = t.hypercharge i)

/-- The Gell-Mann–Nishijima relation: Q = T₃ + Y/2. -/
def ChargeTable.SatisfiesGMN {I : Type*} (t : ChargeTable I) : Prop :=
  ∀ i, t.electric i = t.weakT3 i + t.hypercharge i / 2

/-- Direct application of the Gell-Mann-Nishijima relation at an index. -/
theorem ChargeTable.SatisfiesGMN.apply
    {I : Type*} (t : ChargeTable I)
    (hgmn : t.SatisfiesGMN)
    (i : I) :
    t.electric i = t.weakT3 i + t.hypercharge i / 2 :=
  hgmn i

/-- Alternative form of GMN transport that rewrites the transformed
charges back to the original index using invariance. -/
theorem ChargeTable.gmn_transport_inv
    {G I : Type*} [SMul G I] (t : ChargeTable I)
    (hinv : t.InvariantUnderFamilyAction G)
    (hgmn : t.SatisfiesGMN)
    (g : G) (i : I) :
    t.electric (g • i) = t.weakT3 i + t.hypercharge i / 2 := by
  rw [hinv.1 g i]
  exact hgmn i

end PhysicsSM.StandardModel.FamilySymmetry
