import Mathlib
import PhysicsSM.Algebra.Furey.ColorRepresentation

/-!
# Algebra.Furey.ColorJRepresentation

This module promotes the color-generator API from endomorphisms of
`ComplexOctonion` with `EqOnJ` equalities to genuine induced endomorphisms
of the minimal left ideal submodule `J`.

## Contents

- `ColorGen.toEnd_mem_J`: every color generator preserves `J`.
- `ColorGen.toJEnd`: the induced ℂ-linear endomorphism of `J`.
- `ColorGen.toJEnd_apply`: simp lemma relating `toJEnd` to `toEnd`.
- Bracket equalities as literal equalities of endomorphisms of `J`.

Source: Furey, arXiv:1806.00612.
Provenance: clean-room formalization building on kernel-checked operator
tables in `OperatorAlgebra.lean`, `OperatorRepresentations.lean`, and
`ColorRepresentation.lean`.
-/

namespace PhysicsSM.Algebra.Furey.MinimalLeftIdeal

open PhysicsSM.Algebra.Octonion.ComplexOctonion
open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Furey.LadderOperators

/-!
## Helper: each basis state belongs to `J`
-/

theorem basisState_mem_J (i : Fin 8) : basisState i ∈ J :=
  Submodule.subset_span ⟨i, rfl⟩

theorem omega_mem_J : omega ∈ J := basisState_mem_J 0
theorem v1_mem_J : v1 ∈ J := basisState_mem_J 1
theorem v2_mem_J : v2 ∈ J := basisState_mem_J 2
theorem v3_mem_J : v3 ∈ J := basisState_mem_J 3
theorem v4_mem_J : v4 ∈ J := basisState_mem_J 4
theorem v5_mem_J : v5 ∈ J := basisState_mem_J 5
theorem v6_mem_J : v6 ∈ J := basisState_mem_J 6
theorem nu_mem_J : nu ∈ J := basisState_mem_J 7

/-!
## Each color generator preserves `J`

The proof strategy: for each generator, show that it maps every basis state
to an element of `J` (either 0 or a scalar multiple of a basis state), then
extend by span induction.
-/

/-- Helper: a linear map preserves `J` if it maps every basis state into `J`. -/
private theorem map_mem_J_of_basis
    (f : ComplexOctonion →ₗ[Complex] ComplexOctonion)
    (hf : ∀ i : Fin 8, f (basisState i) ∈ J)
    {x : ComplexOctonion} (hx : x ∈ J) : f x ∈ J := by
  change x ∈ Submodule.span Complex (Set.range basisState) at hx
  refine Submodule.span_induction (p := fun x _ => f x ∈ J) ?_ ?_ ?_ ?_ hx
  · rintro y ⟨i, rfl⟩; exact hf i
  · simp [J.zero_mem]
  · intro a b _ _ ha hb; rw [f.map_add]; exact J.add_mem ha hb
  · intro c a _ ha; rw [f.map_smul]; exact J.smul_mem c ha



private theorem T12_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : T12_op x ∈ J := by
  apply map_mem_J_of_basis T12_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [T12_op_omega, T12_op_v1, T12_op_v2, T12_op_v3,
      T12_op_v4, T12_op_v5, T12_op_v6, T12_op_nu]
  all_goals (first | exact J.zero_mem | exact v1_mem_J | exact v5_mem_J)

private theorem T21_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : T21_op x ∈ J := by
  apply map_mem_J_of_basis T21_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [T21_op_omega, T21_op_v1, T21_op_v2, T21_op_v3,
      T21_op_v4, T21_op_v5, T21_op_v6, T21_op_nu]
  all_goals (first | exact J.zero_mem | exact v2_mem_J | exact v6_mem_J)

private theorem T13_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : T13_op x ∈ J := by
  apply map_mem_J_of_basis T13_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [T13_op_omega, T13_op_v1, T13_op_v2, T13_op_v3,
      T13_op_v4, T13_op_v5, T13_op_v6, T13_op_nu]
  all_goals (first | exact J.zero_mem | exact v1_mem_J | exact J.neg_mem v4_mem_J)

private theorem T31_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : T31_op x ∈ J := by
  apply map_mem_J_of_basis T31_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [T31_op_omega, T31_op_v1, T31_op_v2, T31_op_v3,
      T31_op_v4, T31_op_v5, T31_op_v6, T31_op_nu]
  all_goals (first | exact J.zero_mem | exact v3_mem_J | exact J.neg_mem v6_mem_J)

private theorem T23_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : T23_op x ∈ J := by
  apply map_mem_J_of_basis T23_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [T23_op_omega, T23_op_v1, T23_op_v2, T23_op_v3,
      T23_op_v4, T23_op_v5, T23_op_v6, T23_op_nu]
  all_goals (first | exact J.zero_mem | exact v2_mem_J | exact v4_mem_J)

private theorem T32_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : T32_op x ∈ J := by
  apply map_mem_J_of_basis T32_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [T32_op_omega, T32_op_v1, T32_op_v2, T32_op_v3,
      T32_op_v4, T32_op_v5, T32_op_v6, T32_op_nu]
  all_goals (first | exact J.zero_mem | exact v3_mem_J | exact v5_mem_J)

private theorem H12_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : H12_op x ∈ J := by
  apply map_mem_J_of_basis H12_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [H12_op_omega, H12_op_v1, H12_op_v2, H12_op_v3,
      H12_op_v4, H12_op_v5, H12_op_v6, H12_op_nu]
  all_goals first
    | exact J.zero_mem
    | exact J.smul_mem _ v1_mem_J
    | exact J.smul_mem _ v2_mem_J
    | exact J.smul_mem _ v5_mem_J
    | exact J.smul_mem _ v6_mem_J

private theorem H23_op_mem_J {x : ComplexOctonion} (hx : x ∈ J) : H23_op x ∈ J := by
  apply map_mem_J_of_basis H23_op _ hx
  intro i; fin_cases i <;> dsimp [basisState] <;>
    simp only [H23_op_omega, H23_op_v1, H23_op_v2, H23_op_v3,
      H23_op_v4, H23_op_v5, H23_op_v6, H23_op_nu]
  all_goals first
    | exact J.zero_mem
    | exact J.smul_mem _ v2_mem_J
    | exact J.smul_mem _ v3_mem_J
    | exact J.smul_mem _ v4_mem_J
    | exact J.smul_mem _ v5_mem_J

/-- Every color generator maps elements of `J` back into `J`. -/
theorem ColorGen.toEnd_mem_J
    (c : ColorGen) {x : ComplexOctonion} (hx : x ∈ J) :
    c.toEnd x ∈ J := by
  cases c <;> simp only [ColorGen.toEnd]
  · exact T12_op_mem_J hx
  · exact T21_op_mem_J hx
  · exact T13_op_mem_J hx
  · exact T31_op_mem_J hx
  · exact T23_op_mem_J hx
  · exact T32_op_mem_J hx
  · exact H12_op_mem_J hx
  · exact H23_op_mem_J hx

/-!
## The induced endomorphism on `J`
-/

/-- The induced ℂ-linear endomorphism of `J` for each color generator. -/
noncomputable def ColorGen.toJEnd
    (c : ColorGen) : J →ₗ[ℂ] J where
  toFun x := ⟨c.toEnd x.val, c.toEnd_mem_J x.property⟩
  map_add' x y := Subtype.ext (c.toEnd.map_add x.val y.val)
  map_smul' r x := Subtype.ext (c.toEnd.map_smul r x.val)

@[simp] theorem ColorGen.toJEnd_apply
    (c : ColorGen) (x : J) :
    (c.toJEnd x).val = c.toEnd x.val := rfl

/-!
## Bracket equalities on `J` as literal endomorphism equalities

We define a local commutator on `J` and prove bracket identities as
genuine equalities of linear maps `J →ₗ[ℂ] J`.
-/

/-- The commutator of two endomorphisms of `J`. -/
noncomputable def opCommJ (A B : J →ₗ[ℂ] J) : J →ₗ[ℂ] J :=
  A.comp B - B.comp A

set_option maxHeartbeats 400000 in
-- Higher heartbeat limit is needed to unfold `toJEnd`, `opCommJ`, and the
-- inherited `ColorGen.toEnd` / `opComm` definitions in this bracket proof.
/-- `[E₁₂, E₂₁] = −H₁₂` as endomorphisms of `J`. -/
theorem colorJ_bracket_E12_E21 :
    opCommJ ColorGen.E12.toJEnd ColorGen.E21.toJEnd =
      -ColorGen.H12.toJEnd := by
  apply LinearMap.ext; intro ⟨x, hx⟩; apply Subtype.ext
  simp only [opCommJ, LinearMap.sub_apply, LinearMap.comp_apply,
    ColorGen.toJEnd, LinearMap.coe_mk, AddHom.coe_mk,
    LinearMap.neg_apply, NegMemClass.coe_neg, ColorGen.toEnd]
  have := color_bracket_E12_E21 x hx
  simp only [opComm, LinearMap.sub_apply, LinearMap.comp_apply,
    LinearMap.neg_apply] at this
  exact this

set_option maxHeartbeats 400000 in
-- Higher heartbeat limit is needed to unfold `toJEnd`, `opCommJ`, and the
-- inherited `ColorGen.toEnd` / `opComm` definitions in this bracket proof.
/-- `[E₂₃, E₃₂] = −H₂₃` as endomorphisms of `J`. -/
theorem colorJ_bracket_E23_E32 :
    opCommJ ColorGen.E23.toJEnd ColorGen.E32.toJEnd =
      -ColorGen.H23.toJEnd := by
  apply LinearMap.ext; intro ⟨x, hx⟩; apply Subtype.ext
  simp only [opCommJ, LinearMap.sub_apply, LinearMap.comp_apply,
    ColorGen.toJEnd, LinearMap.coe_mk, AddHom.coe_mk,
    LinearMap.neg_apply, NegMemClass.coe_neg, ColorGen.toEnd]
  have := color_bracket_E23_E32 x hx
  simp only [opComm, LinearMap.sub_apply, LinearMap.comp_apply,
    LinearMap.neg_apply] at this
  exact this

set_option maxHeartbeats 400000 in
-- Higher heartbeat limit is needed to unfold `toJEnd`, `opCommJ`, and the
-- inherited `ColorGen.toEnd` / `opComm` definitions in this bracket proof.
/-- `[E₁₂, E₂₃] = E₁₃` as endomorphisms of `J`. -/
theorem colorJ_bracket_E12_E23 :
    opCommJ ColorGen.E12.toJEnd ColorGen.E23.toJEnd =
      ColorGen.E13.toJEnd := by
  apply LinearMap.ext; intro ⟨x, hx⟩; apply Subtype.ext
  simp only [opCommJ, LinearMap.sub_apply, LinearMap.comp_apply,
    ColorGen.toJEnd, LinearMap.coe_mk, AddHom.coe_mk, ColorGen.toEnd]
  have := color_bracket_E12_E23 x hx
  simp only [opComm, LinearMap.sub_apply, LinearMap.comp_apply] at this
  exact this

set_option maxHeartbeats 400000 in
-- Higher heartbeat limit is needed to unfold `toJEnd`, `opCommJ`, and the
-- inherited `ColorGen.toEnd` / `opComm` definitions in this bracket proof.
/-- `[E₂₁, E₃₂] = −E₃₁` as endomorphisms of `J`. -/
theorem colorJ_bracket_E21_E32 :
    opCommJ ColorGen.E21.toJEnd ColorGen.E32.toJEnd =
      -ColorGen.E31.toJEnd := by
  apply LinearMap.ext; intro ⟨x, hx⟩; apply Subtype.ext
  simp only [opCommJ, LinearMap.sub_apply, LinearMap.comp_apply,
    ColorGen.toJEnd, LinearMap.coe_mk, AddHom.coe_mk,
    LinearMap.neg_apply, NegMemClass.coe_neg, ColorGen.toEnd]
  have := color_bracket_E21_E32 x hx
  simp only [opComm, LinearMap.sub_apply, LinearMap.comp_apply,
    LinearMap.neg_apply] at this
  exact this

end PhysicsSM.Algebra.Furey.MinimalLeftIdeal
