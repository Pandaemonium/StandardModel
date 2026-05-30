import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTripleModule
import PhysicsSM.Algebra.Furey.TrialityRolePermutation

/-!
# Linear equivalences from triality role permutations

This trusted module upgrades the finite role-permutation API to a
linear-equivalence API on `TrialityTriple M`.

Every `Equiv.Perm TrialityRole` induces a genuine `K`-linear automorphism
of the componentwise module `TrialityTriple M`, via the pullback action
`TrialityTriple.permute`.

## Main declarations

- `TrialityTriple.permuteLinearEquiv` — the linear equivalence induced by a
  role permutation.
- `TrialityTriple.cycleLinearEquiv` — specialization to the canonical triality
  cycle.
- `TrialityTriple.cycleLinearEquiv_three` — the third power of the cycle is
  the identity.

## Convention

Follows the pullback convention from `TrialityTriple.permute`: the component
at role `r` of `t.permute e` is `t.proj (e.symm r)`.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.

Provenance: integrated from Aristotle job
`22f1a9eb-7eb3-4b0f-9b90-79b159492197`; see
`AgentTasks/furey-triality-permutation-linear-aristotle-2026-05-29.md`.
-/

namespace PhysicsSM.Algebra.Furey

variable {M : Type*}

/-! ## Linearity of permute -/

/-- `TrialityTriple.permute e` preserves addition. -/
theorem TrialityTriple.permute_add [Add M]
    (e : Equiv.Perm TrialityRole) (a b : TrialityTriple M) :
    (a + b).permute e = a.permute e + b.permute e := by
  apply TrialityTriple.ext <;>
    simp only [TrialityTriple.permute, TrialityTriple.ofFun, TrialityTriple.proj] <;>
    cases e.symm TrialityRole.spinorPlus <;>
    cases e.symm TrialityRole.spinorMinus <;>
    cases e.symm TrialityRole.vector <;>
    rfl

/-- `TrialityTriple.permute e` preserves scalar multiplication. -/
theorem TrialityTriple.permute_smul {K : Type*} [SMul K M]
    (e : Equiv.Perm TrialityRole) (c : K) (t : TrialityTriple M) :
    (c • t).permute e = c • (t.permute e) := by
  apply TrialityTriple.ext <;>
    simp only [TrialityTriple.permute, TrialityTriple.ofFun, TrialityTriple.proj] <;>
    cases e.symm TrialityRole.spinorPlus <;>
    cases e.symm TrialityRole.spinorMinus <;>
    cases e.symm TrialityRole.vector <;>
    rfl

/-- `TrialityTriple.permute e` preserves zero. -/
theorem TrialityTriple.permute_zero [Zero M]
    (e : Equiv.Perm TrialityRole) :
    (0 : TrialityTriple M).permute e = 0 := by
  apply TrialityTriple.ext <;>
    simp only [TrialityTriple.permute, TrialityTriple.ofFun, TrialityTriple.proj] <;>
    cases e.symm TrialityRole.spinorPlus <;>
    cases e.symm TrialityRole.spinorMinus <;>
    cases e.symm TrialityRole.vector <;>
    rfl

/-! ## The linear equivalence -/

/-- The `K`-linear equivalence on `TrialityTriple M` induced by a role permutation `e`.

The forward map is `fun t => t.permute e` and the inverse is
`fun t => t.permute e.symm`. -/
def TrialityTriple.permuteLinearEquiv
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (e : Equiv.Perm TrialityRole) :
    TrialityTriple M ≃ₗ[K] TrialityTriple M where
  toFun t := t.permute e
  invFun t := t.permute e.symm
  left_inv t := by
    change (t.permute e).permute e.symm = t
    rw [TrialityTriple.permute_trans, Equiv.self_trans_symm]
    exact TrialityTriple.permute_refl t
  right_inv t := by
    change (t.permute e.symm).permute e = t
    rw [TrialityTriple.permute_trans, Equiv.symm_trans_self]
    exact TrialityTriple.permute_refl t
  map_add' := TrialityTriple.permute_add e
  map_smul' := TrialityTriple.permute_smul e

/-! ## Simp lemmas -/

@[simp]
theorem TrialityTriple.permuteLinearEquiv_apply
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (e : Equiv.Perm TrialityRole) (t : TrialityTriple M) :
    TrialityTriple.permuteLinearEquiv K e t = t.permute e :=
  rfl

@[simp]
theorem TrialityTriple.permuteLinearEquiv_symm_apply
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (e : Equiv.Perm TrialityRole) (t : TrialityTriple M) :
    (TrialityTriple.permuteLinearEquiv K e).symm t = t.permute e.symm :=
  rfl

/-! ## Structural lemmas -/

/-- The linear equivalence for `Equiv.refl` is the identity. -/
theorem TrialityTriple.permuteLinearEquiv_refl
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M] :
    TrialityTriple.permuteLinearEquiv K (Equiv.refl TrialityRole) =
      LinearEquiv.refl K (TrialityTriple M) := by
  apply LinearEquiv.ext
  intro t
  exact TrialityTriple.permute_refl t

/-- Composition of role permutations corresponds to `LinearEquiv.trans`. -/
theorem TrialityTriple.permuteLinearEquiv_trans
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (e f : Equiv.Perm TrialityRole) :
    LinearEquiv.trans (M₂ := TrialityTriple M)
      (TrialityTriple.permuteLinearEquiv K e)
      (TrialityTriple.permuteLinearEquiv K f) =
      TrialityTriple.permuteLinearEquiv K (e.trans f) := by
  have : ∀ t : TrialityTriple M,
      (TrialityTriple.permuteLinearEquiv K e).trans
        (TrialityTriple.permuteLinearEquiv K f) t =
      TrialityTriple.permuteLinearEquiv K (e.trans f) t := fun t =>
    TrialityTriple.permute_trans e f t
  exact LinearEquiv.ext this

/-! ## The triality cycle linear equivalence -/

/-- The `K`-linear equivalence induced by the canonical triality cycle
`spinorPlus → spinorMinus → vector → spinorPlus`. -/
def TrialityTriple.cycleLinearEquiv
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M] :
    TrialityTriple M ≃ₗ[K] TrialityTriple M :=
  TrialityTriple.permuteLinearEquiv K TrialityRole.cycleEquiv

@[simp]
theorem TrialityTriple.cycleLinearEquiv_apply
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (t : TrialityTriple M) :
    TrialityTriple.cycleLinearEquiv K t = t.permute TrialityRole.cycleEquiv :=
  rfl

/-- The third power of the triality cycle linear equivalence is the identity:
for all triples `t`, applying `cycleLinearEquiv` three times returns `t`. -/
theorem TrialityTriple.cycleLinearEquiv_three
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M]
    (t : TrialityTriple M) :
    TrialityTriple.cycleLinearEquiv K (TrialityTriple.cycleLinearEquiv K
      (TrialityTriple.cycleLinearEquiv K t)) = t := by
  simp only [cycleLinearEquiv_apply]
  exact TrialityTriple.cycle_three t

end PhysicsSM.Algebra.Furey
