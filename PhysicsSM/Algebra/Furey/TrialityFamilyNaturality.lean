/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Harmonic/Aristotle
-/
import Mathlib
import PhysicsSM.StandardModel.FamilySymmetry
import PhysicsSM.Algebra.Furey.TrialityPermutationRepresentation
import PhysicsSM.Algebra.Furey.TrialityActionMonoid

/-!
# Triality family naturality

This file instantiates the family-symmetry naturality framework for the
Furey–Hughes triality role-permutation API.

## Overview

We provide:
- `triality_cycle_eigenvector_transport`: specialization to the canonical
  triality cycle `cycleLinearEquiv`, using the generic
  `FamilySymmetry.eigenvector_transport`.
- `TrialityRoleChargeTable`: a charge table indexed by `TrialityRole`.
- `RoleConstant`: predicate expressing that a charge table assigns the same
  values to all three triality roles.
- `RoleConstant.cycle_invariant_*`: cycle invariance for each charge field.
- `roleCycle_gmn`: the Gell-Mann–Nishijima relation evaluated at a cycled
  triality role.

## Claim boundary

This is a formal naturality theorem for role permutations and role-constant
charge tables. It does **not** assert that Furey–Hughes triality is the
physical origin of generations, nor that the project has formalized the full
`tri(ℂ) + tri(ℍ) + tri(𝕆)` Lie algebra.

## Source motivation

Furey and Hughes, "Three Generations and a Trio of Trialities",
arXiv:2409.17948.
-/

namespace PhysicsSM.Algebra.Furey.TrialityFamilyNaturality

open PhysicsSM.Algebra.Furey
open PhysicsSM.StandardModel.FamilySymmetry

/-! ## Triality eigenvector transport -/

/-- Specialization of the generic eigenvector transport theorem to the
canonical triality cycle linear equivalence. -/
theorem triality_cycle_eigenvector_transport
    {K M : Type*} [Semiring K] [AddCommMonoid M] [Module K M]
    (A : Module.End K (TrialityTriple M)) (lambda : K)
    (x : TrialityTriple M)
    (hcomm :
      CommutesWithLinearEquiv A
        (TrialityTriple.cycleLinearEquiv (M := M) K))
    (heig : A x = lambda • x) :
    A (TrialityTriple.cycleLinearEquiv (M := M) K x) =
      lambda • TrialityTriple.cycleLinearEquiv (M := M) K x :=
  eigenvector_transport A (TrialityTriple.cycleLinearEquiv K) lambda x hcomm heig

/-! ## Charge-table naturality over `TrialityRole` -/

/-- A charge table indexed by `TrialityRole`. -/
abbrev TrialityRoleChargeTable :=
  PhysicsSM.StandardModel.FamilySymmetry.ChargeTable TrialityRole

/-- A `TrialityRoleChargeTable` is role-constant when all three charge
functions assign the same value to every triality role. -/
def RoleConstant (t : TrialityRoleChargeTable) : Prop :=
  (∀ r s : TrialityRole, t.electric r = t.electric s) ∧
  (∀ r s : TrialityRole, t.weakT3 r = t.weakT3 s) ∧
  (∀ r s : TrialityRole, t.hypercharge r = t.hypercharge s)

/-- The electric charge is invariant under the triality cycle for a
role-constant charge table. -/
theorem RoleConstant.cycle_invariant_electric
    (t : TrialityRoleChargeTable) (hconst : RoleConstant t) (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) = t.electric r :=
  hconst.1 _ _

/-- The weak isospin T₃ is invariant under the triality cycle for a
role-constant charge table. -/
theorem RoleConstant.cycle_invariant_weakT3
    (t : TrialityRoleChargeTable) (hconst : RoleConstant t) (r : TrialityRole) :
    t.weakT3 (TrialityRole.cycle r) = t.weakT3 r :=
  hconst.2.1 _ _

/-- The hypercharge is invariant under the triality cycle for a
role-constant charge table. -/
theorem RoleConstant.cycle_invariant_hypercharge
    (t : TrialityRoleChargeTable) (hconst : RoleConstant t) (r : TrialityRole) :
    t.hypercharge (TrialityRole.cycle r) = t.hypercharge r :=
  hconst.2.2 _ _

/-- The Gell-Mann-Nishijima relation holds at a cycled triality role whenever
the table satisfies GMN. This theorem is just direct application of GMN; the
role-constant, invariant version is `roleConstant_gmn_cycle_inv`. -/
theorem roleCycle_gmn
    (t : TrialityRoleChargeTable)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 (TrialityRole.cycle r) +
        t.hypercharge (TrialityRole.cycle r) / 2 :=
  hgmn (TrialityRole.cycle r)

/-- Variant: the GMN relation holds at `cycleEquiv r` for role-constant
charge tables satisfying GMN. -/
theorem roleCycle_gmn_cycleEquiv
    (t : TrialityRoleChargeTable)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycleEquiv r) =
      t.weakT3 (TrialityRole.cycleEquiv r) +
        t.hypercharge (TrialityRole.cycleEquiv r) / 2 := by
  simp only [TrialityRole.cycleEquiv_apply]
  exact roleCycle_gmn t hgmn r

/-- Alternative form: the GMN relation at a cycled role can be rewritten
using the original role's charges, via role-constancy. -/
theorem roleConstant_gmn_cycle_inv
    (t : TrialityRoleChargeTable)
    (hconst : RoleConstant t)
    (hgmn : t.SatisfiesGMN)
    (r : TrialityRole) :
    t.electric (TrialityRole.cycle r) =
      t.weakT3 r + t.hypercharge r / 2 := by
  rw [RoleConstant.cycle_invariant_electric t hconst]
  exact hgmn r

end PhysicsSM.Algebra.Furey.TrialityFamilyNaturality
