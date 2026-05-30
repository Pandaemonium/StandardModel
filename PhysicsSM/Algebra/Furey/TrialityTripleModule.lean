import Mathlib
import PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold

/-!
# Triality triple module structure

This trusted module upgrades `TrialityTriple` with componentwise algebraic
instances (`AddCommMonoid`, `AddCommGroup`, `Module`) and shows that a
`TrialityActionData` induces a genuine `K`-linear endomorphism of the triple
module.

Main declarations:
- `PhysicsSM.Algebra.Furey.instAddCommMonoidTrialityTriple`
- `PhysicsSM.Algebra.Furey.instAddCommGroupTrialityTriple`
- `PhysicsSM.Algebra.Furey.instModuleTrialityTriple`
- `PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold.TrialityActionData.toLinearEnd`

Source notes:
- `PhysicsSM.Algebra.Furey.TrialityTriple`, for the component record and
  pointwise operations.
- `PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold`, for the three endomorphism
  action datum.

Provenance: integrated from Aristotle job
`d6740f6d-59c8-47a4-a733-6c1f9a5f4202`, with local review and provenance
cleanup.

Status: trusted module; all proofs are kernel-checked without placeholder
declarations.
-/

namespace PhysicsSM.Algebra.Furey

open TrialityAlgebraScaffold

variable {M : Type*}

/-! ## Projection lemmas for existing pointwise operations -/

@[simp]
theorem TrialityTriple.proj_zero [Zero M] (r : TrialityRole) :
    (0 : TrialityTriple M).proj r = 0 := by
  cases r <;> rfl

@[simp]
theorem TrialityTriple.proj_add [Add M] (a b : TrialityTriple M) (r : TrialityRole) :
    (a + b).proj r = a.proj r + b.proj r := by
  cases r <;> rfl

@[simp]
theorem TrialityTriple.proj_neg [Neg M] (a : TrialityTriple M) (r : TrialityRole) :
    (-a).proj r = -(a.proj r) := by
  cases r <;> rfl

@[simp]
theorem TrialityTriple.proj_smul {R : Type*} [SMul R M] (c : R)
    (a : TrialityTriple M) (r : TrialityRole) :
    (c • a).proj r = c • (a.proj r) := by
  cases r <;> rfl

/-! ## Field-level projection lemmas -/

@[simp] theorem TrialityTriple.psiPlus_zero [Zero M] :
    (0 : TrialityTriple M).psiPlus = 0 := rfl

@[simp] theorem TrialityTriple.psiMinus_zero [Zero M] :
    (0 : TrialityTriple M).psiMinus = 0 := rfl

@[simp] theorem TrialityTriple.vector_zero [Zero M] :
    (0 : TrialityTriple M).vector = 0 := rfl

@[simp] theorem TrialityTriple.psiPlus_add [Add M] (a b : TrialityTriple M) :
    (a + b).psiPlus = a.psiPlus + b.psiPlus := rfl

@[simp] theorem TrialityTriple.psiMinus_add [Add M] (a b : TrialityTriple M) :
    (a + b).psiMinus = a.psiMinus + b.psiMinus := rfl

@[simp] theorem TrialityTriple.vector_add [Add M] (a b : TrialityTriple M) :
    (a + b).vector = a.vector + b.vector := rfl

@[simp] theorem TrialityTriple.psiPlus_neg [Neg M] (a : TrialityTriple M) :
    (-a).psiPlus = -a.psiPlus := rfl

@[simp] theorem TrialityTriple.psiMinus_neg [Neg M] (a : TrialityTriple M) :
    (-a).psiMinus = -a.psiMinus := rfl

@[simp] theorem TrialityTriple.vector_neg [Neg M] (a : TrialityTriple M) :
    (-a).vector = -a.vector := rfl

@[simp] theorem TrialityTriple.psiPlus_smul {R : Type*} [SMul R M] (c : R)
    (a : TrialityTriple M) : (c • a).psiPlus = c • a.psiPlus := rfl

@[simp] theorem TrialityTriple.psiMinus_smul {R : Type*} [SMul R M] (c : R)
    (a : TrialityTriple M) : (c • a).psiMinus = c • a.psiMinus := rfl

@[simp] theorem TrialityTriple.vector_smul {R : Type*} [SMul R M] (c : R)
    (a : TrialityTriple M) : (c • a).vector = c • a.vector := rfl

/-! ## Componentwise algebraic instances -/

instance instSubTrialityTriple [Sub M] : Sub (TrialityTriple M) where
  sub a b := {
    psiPlus := a.psiPlus - b.psiPlus
    psiMinus := a.psiMinus - b.psiMinus
    vector := a.vector - b.vector
  }

private theorem tt_ext {a b : TrialityTriple M}
    (h1 : a.psiPlus = b.psiPlus) (h2 : a.psiMinus = b.psiMinus)
    (h3 : a.vector = b.vector) :
    a = b :=
  TrialityTriple.ext h1 h2 h3

/-- Componentwise additive commutative monoid structure on triality triples. -/
instance instAddCommMonoidTrialityTriple [AddCommMonoid M] :
    AddCommMonoid (TrialityTriple M) where
  add_assoc _ _ _ := tt_ext (add_assoc _ _ _) (add_assoc _ _ _) (add_assoc _ _ _)
  zero_add _ := tt_ext (zero_add _) (zero_add _) (zero_add _)
  add_zero _ := tt_ext (add_zero _) (add_zero _) (add_zero _)
  add_comm _ _ := tt_ext (add_comm _ _) (add_comm _ _) (add_comm _ _)
  nsmul n a := {
    psiPlus := n • a.psiPlus
    psiMinus := n • a.psiMinus
    vector := n • a.vector
  }
  nsmul_zero _ := tt_ext (zero_nsmul _) (zero_nsmul _) (zero_nsmul _)
  nsmul_succ _ _ := tt_ext (succ_nsmul _ _) (succ_nsmul _ _) (succ_nsmul _ _)

/-- Componentwise additive commutative group structure on triality triples. -/
instance instAddCommGroupTrialityTriple [AddCommGroup M] :
    AddCommGroup (TrialityTriple M) where
  toAddCommMonoid := instAddCommMonoidTrialityTriple
  zsmul n a := {
    psiPlus := n • a.psiPlus
    psiMinus := n • a.psiMinus
    vector := n • a.vector
  }
  zsmul_zero' _ := tt_ext (zero_zsmul _) (zero_zsmul _) (zero_zsmul _)
  zsmul_succ' n _ := tt_ext
    (SubNegMonoid.zsmul_succ' n _) (SubNegMonoid.zsmul_succ' n _)
    (SubNegMonoid.zsmul_succ' n _)
  zsmul_neg' n _ := tt_ext
    (SubNegMonoid.zsmul_neg' n _) (SubNegMonoid.zsmul_neg' n _)
    (SubNegMonoid.zsmul_neg' n _)
  neg_add_cancel _ := tt_ext (neg_add_cancel _) (neg_add_cancel _) (neg_add_cancel _)
  sub_eq_add_neg _ _ := tt_ext (sub_eq_add_neg _ _) (sub_eq_add_neg _ _) (sub_eq_add_neg _ _)

/-- Componentwise module structure on triality triples. -/
instance instModuleTrialityTriple
    (K : Type*) [Semiring K] [AddCommMonoid M] [Module K M] :
    Module K (TrialityTriple M) where
  one_smul _ := tt_ext (one_smul _ _) (one_smul _ _) (one_smul _ _)
  mul_smul _ _ _ := tt_ext (mul_smul _ _ _) (mul_smul _ _ _) (mul_smul _ _ _)
  smul_zero _ := tt_ext (smul_zero _) (smul_zero _) (smul_zero _)
  smul_add _ _ _ := tt_ext (smul_add _ _ _) (smul_add _ _ _) (smul_add _ _ _)
  add_smul _ _ _ := tt_ext (add_smul _ _ _) (add_smul _ _ _) (add_smul _ _ _)
  zero_smul _ := tt_ext (zero_smul _ _) (zero_smul _ _) (zero_smul _ _)

end PhysicsSM.Algebra.Furey

/-! ## Linear endomorphism from `TrialityActionData` -/

namespace PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold

open PhysicsSM.Algebra.Furey

variable {K : Type*} [CommSemiring K]
variable {M : Type*} [AddCommMonoid M] [Module K M]

/-- Lift a triality action datum to a `K`-linear endomorphism of the triple module. -/
def TrialityActionData.toLinearEnd
    (rho : TrialityActionData K M) :
    Module.End K (TrialityTriple M) where
  toFun := rho.actTriple
  map_add' _ _ := TrialityTriple.ext
    (map_add rho.actC _ _) (map_add rho.actH _ _) (map_add rho.actO _ _)
  map_smul' _ _ := TrialityTriple.ext
    (map_smul rho.actC _ _) (map_smul rho.actH _ _) (map_smul rho.actO _ _)

/-- `toLinearEnd` agrees with `actTriple` on elements. -/
theorem TrialityActionData.toLinearEnd_apply
    (rho : TrialityActionData K M) (t : TrialityTriple M) :
    rho.toLinearEnd t = rho.actTriple t :=
  rfl

/-- The identity action datum maps to the identity linear endomorphism. -/
theorem TrialityActionData.toLinearEnd_id :
    (TrialityActionData.id (K := K) (M := M)).toLinearEnd =
      LinearMap.id := by
  apply LinearMap.ext
  intro t
  exact TrialityTriple.ext
    (LinearMap.id_apply _) (LinearMap.id_apply _) (LinearMap.id_apply _)

/-- Composition of action data corresponds to composition of linear maps. -/
theorem TrialityActionData.toLinearEnd_comp
    (rho sigma : TrialityActionData K M) :
    (rho.comp sigma).toLinearEnd =
      rho.toLinearEnd.comp sigma.toLinearEnd := by
  apply LinearMap.ext
  intro t
  exact TrialityTriple.ext rfl rfl rfl

end PhysicsSM.Algebra.Furey.TrialityAlgebraScaffold
