import Mathlib
import PhysicsSM.Algebra.Furey.TrialityTripleModule
import PhysicsSM.Algebra.Furey.TrialityRolePermutation

/-!
# Triality action permutation intertwiner

This trusted module proves the finite equivariance law relating role
permutations on `TrialityTriple` to the corresponding role permutations of
`TrialityActionData`.

This is scaffolding only. It does not assert a `Spin(8)` triality theorem or a
Standard Model gauge embedding theorem.

Convention:
- `spinorPlus` maps to `actC`.
- `spinorMinus` maps to `actH`.
- `vector` maps to `actO`.
- `permuteRoles e rho` pulls the endomorphism assignment back along `e`.

Provenance: integrated from Aristotle job
`aa3f9867-36d3-4ada-9e7e-42d59e12c820`, with local review and provenance
cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold

open PhysicsSM.Algebra.Furey

variable {K : Type*} [CommSemiring K]
variable {M : Type*} [AddCommMonoid M] [Module K M]

/-! ## Role-indexed accessor -/

/--
Extract the endomorphism corresponding to a given `TrialityRole`.

Convention:
- `spinorPlus` maps to `actC`.
- `spinorMinus` maps to `actH`.
- `vector` maps to `actO`.
-/
def TrialityActionData.actAtRole
    (rho : TrialityActionData K M) : TrialityRole → Module.End K M
  | .spinorPlus => rho.actC
  | .spinorMinus => rho.actH
  | .vector => rho.actO

@[simp]
theorem TrialityActionData.actAtRole_spinorPlus (rho : TrialityActionData K M) :
    rho.actAtRole .spinorPlus = rho.actC := rfl

@[simp]
theorem TrialityActionData.actAtRole_spinorMinus (rho : TrialityActionData K M) :
    rho.actAtRole .spinorMinus = rho.actH := rfl

@[simp]
theorem TrialityActionData.actAtRole_vector (rho : TrialityActionData K M) :
    rho.actAtRole .vector = rho.actO := rfl

/-! ## Constructor from role-indexed endomorphisms -/

/-- Build a `TrialityActionData` from an endomorphism assigned to each role. -/
def TrialityActionData.ofRoleEnd
    (f : TrialityRole → Module.End K M) : TrialityActionData K M where
  actC := f .spinorPlus
  actH := f .spinorMinus
  actO := f .vector

@[simp]
theorem TrialityActionData.ofRoleEnd_actC (f : TrialityRole → Module.End K M) :
    (TrialityActionData.ofRoleEnd f).actC = f .spinorPlus := rfl

@[simp]
theorem TrialityActionData.ofRoleEnd_actH (f : TrialityRole → Module.End K M) :
    (TrialityActionData.ofRoleEnd f).actH = f .spinorMinus := rfl

@[simp]
theorem TrialityActionData.ofRoleEnd_actO (f : TrialityRole → Module.End K M) :
    (TrialityActionData.ofRoleEnd f).actO = f .vector := rfl

/-! ## Round-trip lemmas -/

/-- `ofRoleEnd` after `actAtRole` recovers the original datum. -/
theorem TrialityActionData.ofRoleEnd_actAtRole (rho : TrialityActionData K M) :
    TrialityActionData.ofRoleEnd rho.actAtRole = rho := by
  ext <;> rfl

/-- `actAtRole` after `ofRoleEnd` recovers the original function. -/
theorem TrialityActionData.actAtRole_ofRoleEnd
    (f : TrialityRole → Module.End K M) (r : TrialityRole) :
    (TrialityActionData.ofRoleEnd f).actAtRole r = f r := by
  cases r <;> rfl

/-! ## Projection lemma: `actAtRole` and `actTriple` -/

/--
The projection of `actTriple` at role `r` equals `actAtRole r` applied to the
projection of the triple at role `r`.
-/
@[simp]
theorem TrialityActionData.actAtRole_actTriple
    (rho : TrialityActionData K M) (t : TrialityTriple M) (r : TrialityRole) :
    (rho.actTriple t).proj r = (rho.actAtRole r) (t.proj r) := by
  cases r <;> rfl

/-! ## Extensionality via `actAtRole` -/

/-- Two `TrialityActionData` values are equal when `actAtRole` agrees on all roles. -/
theorem TrialityActionData.ext_actAtRole {rho sigma : TrialityActionData K M}
    (h : ∀ r, rho.actAtRole r = sigma.actAtRole r) :
    rho = sigma := by
  apply TrialityActionData.ext'
  · exact h .spinorPlus
  · exact h .spinorMinus
  · exact h .vector

/-! ## Role permutation of action data -/

/--
Permute the roles of a `TrialityActionData` by pulling back along `e`.
The endomorphism at role `r` in the result is the endomorphism at role
`e.symm r` in the original.
-/
def TrialityActionData.permuteRoles
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M) :
    TrialityActionData K M :=
  TrialityActionData.ofRoleEnd (fun r => rho.actAtRole (e.symm r))

/-- `actAtRole` after `permuteRoles` pulls back through `e`. -/
@[simp]
theorem TrialityActionData.actAtRole_permuteRoles
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M) (r : TrialityRole) :
    (rho.permuteRoles e).actAtRole r = rho.actAtRole (e.symm r) := by
  simp [TrialityActionData.permuteRoles, TrialityActionData.actAtRole_ofRoleEnd]

/-! ## Main intertwining theorem -/

/--
Intertwining theorem: permuting the roles of the action data and permuting the
triple commute.
-/
theorem TrialityActionData.actTriple_permuteRoles
    (e : Equiv.Perm TrialityRole) (rho : TrialityActionData K M)
    (t : TrialityTriple M) :
    (rho.permuteRoles e).actTriple (t.permute e) =
      (rho.actTriple t).permute e := by
  ext <;> simp only [TrialityActionData.actTriple, TrialityTriple.permute,
    TrialityTriple.ofFun, TrialityActionData.permuteRoles,
    TrialityActionData.ofRoleEnd] <;>
  cases e.symm TrialityRole.spinorPlus <;>
  cases e.symm TrialityRole.spinorMinus <;>
  cases e.symm TrialityRole.vector <;>
  rfl

/-! ## Identity and composition for `permuteRoles` -/

/-- Permuting roles by the identity permutation is the identity. -/
theorem TrialityActionData.permuteRoles_refl
    (rho : TrialityActionData K M) :
    rho.permuteRoles (Equiv.refl TrialityRole) = rho := by
  ext <;> rfl

/--
Composing two role permutations.

Convention follows `Equiv.trans`: `(e.trans f) x = f (e x)`, so
`permuteRoles (e.trans f) = permuteRoles f` after `permuteRoles e`.
-/
theorem TrialityActionData.permuteRoles_trans
    (e f : Equiv.Perm TrialityRole) (rho : TrialityActionData K M) :
    (rho.permuteRoles e).permuteRoles f = rho.permuteRoles (e.trans f) := by
  apply TrialityActionData.ext_actAtRole
  intro r
  simp [Equiv.symm_trans_apply]

end PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
