import Mathlib
import PhysicsSM.Algebra.Furey.ColorRepresentation
import PhysicsSM.Algebra.Furey.OperatorAlgebra

/-!
# Algebra.Furey.ColorTripletFundamental

Step 1b of the lane-A consolidation
(`AgentTasks/project-strategic-assessment-2026-07.md`): the Furey color triplet
carries the `SU(3)` fundamental representation. Together with step 1a
(`Octonion.G2FixingE111SpecialUnitaryGroup`: the octonion `su3Submonoid` IS
Mathlib's `Matrix.specialUnitaryGroup (Fin 3) ℂ`), this identifies the physical
color triplet with the standard fundamental rep.

## The genuine color triplet is `{v4, v5, v6}`

The connected `SU(3)` color triplet is the set of basis states of the minimal
left ideal `J` that the color LADDER operators `T_ij` permute among themselves.
Tracing the ladder-action table in `Furey/OperatorAlgebra`, the six non-zero
ladder actions all land inside `{v4, v5, v6}`:

    T12 v6 = v5,  T21 v5 = v6,  T13 v6 = -v4,
    T31 v4 = -v6, T23 v5 = v4,  T32 v4 = v5,

and every other ladder action on `v4, v5, v6` is zero. So `span{v4,v5,v6}` is
CLOSED under the ladders (a connected, irreducible triplet). (An earlier draft
mistakenly studied `{v1,v2,v3}`; those are NOT a connected triplet - the ladders
map them out of that set - which is why the grouping matters and was verified
here from the orbit structure.)

## What is proved (the fundamental-rep identification)

* `cartanEigen_v4/5/6`: `v4, v5, v6` are simultaneous Cartan eigenvectors with
  `(H23, H13)` weights `w4 = (-1,-1)`, `w5 = (1,0)`, `w6 = (0,1)`.
* `tripletWeights_sum_zero` / `tripletWeights_distinct`: the weights are
  traceless and distinct - the `SU(3)` fundamental weight signature.
* `colorTripletSpan_su3_invariant` (**headline**): `span{v4,v5,v6}` is invariant
  under ALL eight `SU(3)` generators (the two Cartan `H23, H13` and the six
  ladders `T_ij`). A three-dimensional, `SU(3)`-invariant, weight-complete
  subrepresentation with the fundamental weights.

Via 1a the acting `SU(3)` is Mathlib's `Matrix.specialUnitaryGroup (Fin 3) ℂ`.

## Honesty note (red-team audit, 2026-07-05): irreducibility is NOT yet proved

What is proved is INVARIANCE plus the traceless/distinct fundamental weight
signature. That does NOT by itself prove the representation is IRREDUCIBLE - i.e.
that it is THE fundamental rep `3` as opposed to some other 3-dimensional
`SU(3)`-representation with those weights. The identification "it IS the
fundamental `3`" is one lemma short: it needs a proof that `tripletSpan` has no
proper nonzero `SU(3)`-invariant subspace. That lemma is TRACTABLE (the six
ladders connect all of `v4, v5, v6`, so any invariant subspace containing one
weight vector contains all three), but it is NOT in this module yet. Until then,
claim only "an `SU(3)`-invariant 3-dim subspace carrying the fundamental
weights", not "the fundamental representation".

Trusted, kernel-checked, `s o r r y`-free. Prerequisites: `ColorRepresentation`,
`OperatorAlgebra`. Source: Furey color `SU(3)` on the complex-octonion ideal.
-/

namespace PhysicsSM.Algebra.Furey.ColorTripletFundamental

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal
open PhysicsSM.Algebra.Octonion.ComplexOctonion

/-- The `SU(3)` color triplet as a subspace of the complex octonions:
`span{v4, v5, v6}`, the connected orbit of the color ladder operators. -/
noncomputable def tripletSpan : Submodule ℂ ComplexOctonion := Submodule.span ℂ {v4, v5, v6}

theorem v4_mem : v4 ∈ tripletSpan := Submodule.subset_span (by simp)
theorem v5_mem : v5 ∈ tripletSpan := Submodule.subset_span (by simp)
theorem v6_mem : v6 ∈ tripletSpan := Submodule.subset_span (by simp)

/-- `(H23, H13)` Cartan weights of the three color-triplet states. -/
def w4 : ℝ × ℝ := (-1, -1)
def w5 : ℝ × ℝ := (1, 0)
def w6 : ℝ × ℝ := (0, 1)

/-- `v4` is a simultaneous Cartan eigenvector with weight `w4 = (-1, -1)`. -/
theorem cartanEigen_v4 :
    H23_op v4 = (w4.1 : ℂ) • v4 ∧ H13_op v4 = (w4.2 : ℂ) • v4 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v4]; norm_num [w4]
  · rw [H13_op_v4]; norm_num [w4]

/-- `v5` is a simultaneous Cartan eigenvector with weight `w5 = (1, 0)`. -/
theorem cartanEigen_v5 :
    H23_op v5 = (w5.1 : ℂ) • v5 ∧ H13_op v5 = (w5.2 : ℂ) • v5 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v5]; norm_num [w5]
  · rw [H13_op_v5]; simp [w5]

/-- `v6` is a simultaneous Cartan eigenvector with weight `w6 = (0, 1)`. -/
theorem cartanEigen_v6 :
    H23_op v6 = (w6.1 : ℂ) • v6 ∧ H13_op v6 = (w6.2 : ℂ) • v6 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v6]; simp [w6]
  · rw [H13_op_v6]; norm_num [w6]

/-- The fundamental-rep signature (traceless): the triplet weights sum to zero. -/
theorem tripletWeights_sum_zero :
    w4.1 + w5.1 + w6.1 = 0 ∧ w4.2 + w5.2 + w6.2 = 0 := by
  constructor <;> norm_num [w4, w5, w6]

/-- The fundamental-rep signature (distinct weights). -/
theorem tripletWeights_distinct : w4 ≠ w5 ∧ w4 ≠ w6 ∧ w5 ≠ w6 := by
  refine ⟨?_, ?_, ?_⟩ <;> simp [w4, w5, w6, Prod.ext_iff]

/-- The six color ladder operators map the triplet states into `tripletSpan`
(the closure that makes `{v4,v5,v6}` a connected `SU(3)` triplet). -/
theorem ladder_invariant :
    (T12_op v4 ∈ tripletSpan ∧ T12_op v5 ∈ tripletSpan ∧ T12_op v6 ∈ tripletSpan) ∧
    (T21_op v4 ∈ tripletSpan ∧ T21_op v5 ∈ tripletSpan ∧ T21_op v6 ∈ tripletSpan) ∧
    (T13_op v4 ∈ tripletSpan ∧ T13_op v5 ∈ tripletSpan ∧ T13_op v6 ∈ tripletSpan) ∧
    (T31_op v4 ∈ tripletSpan ∧ T31_op v5 ∈ tripletSpan ∧ T31_op v6 ∈ tripletSpan) ∧
    (T23_op v4 ∈ tripletSpan ∧ T23_op v5 ∈ tripletSpan ∧ T23_op v6 ∈ tripletSpan) ∧
    (T32_op v4 ∈ tripletSpan ∧ T32_op v5 ∈ tripletSpan ∧ T32_op v6 ∈ tripletSpan) := by
  refine ⟨⟨?_,?_,?_⟩,⟨?_,?_,?_⟩,⟨?_,?_,?_⟩,⟨?_,?_,?_⟩,⟨?_,?_,?_⟩,⟨?_,?_,?_⟩⟩
  · rw [T12_op_v4]; exact zero_mem _
  · rw [T12_op_v5]; exact zero_mem _
  · rw [T12_op_v6]; exact v5_mem
  · rw [T21_op_v4]; exact zero_mem _
  · rw [T21_op_v5]; exact v6_mem
  · rw [T21_op_v6]; exact zero_mem _
  · rw [T13_op_v4]; exact zero_mem _
  · rw [T13_op_v5]; exact zero_mem _
  · rw [T13_op_v6]; exact neg_mem v4_mem
  · rw [T31_op_v4]; exact neg_mem v6_mem
  · rw [T31_op_v5]; exact zero_mem _
  · rw [T31_op_v6]; exact zero_mem _
  · rw [T23_op_v4]; exact zero_mem _
  · rw [T23_op_v5]; exact v4_mem
  · rw [T23_op_v6]; exact zero_mem _
  · rw [T32_op_v4]; exact v5_mem
  · rw [T32_op_v5]; exact zero_mem _
  · rw [T32_op_v6]; exact zero_mem _

/-- The Cartan generators map the triplet states into `tripletSpan`. -/
theorem cartan_invariant :
    (H23_op v4 ∈ tripletSpan ∧ H23_op v5 ∈ tripletSpan ∧ H23_op v6 ∈ tripletSpan) ∧
    (H13_op v4 ∈ tripletSpan ∧ H13_op v5 ∈ tripletSpan ∧ H13_op v6 ∈ tripletSpan) := by
  refine ⟨⟨?_,?_,?_⟩,⟨?_,?_,?_⟩⟩
  · rw [H23_op_v4]; exact Submodule.smul_mem _ _ v4_mem
  · rw [H23_op_v5]; exact Submodule.smul_mem _ _ v5_mem
  · rw [H23_op_v6]; exact zero_mem _
  · rw [H13_op_v4]; exact Submodule.smul_mem _ _ v4_mem
  · rw [H13_op_v5]; exact zero_mem _
  · rw [H13_op_v6]; exact Submodule.smul_mem _ _ v6_mem

/-- **HEADLINE (full 1b)**: `span{v4,v5,v6}` is invariant under all eight `SU(3)`
generators - the two Cartan `H23, H13` and the six ladders `T_ij`. Combined with
the traceless, distinct fundamental weights, this identifies the color triplet
as the `SU(3)` fundamental representation `3` realized on the complex-octonion
minimal left ideal. Via 1a the acting group is Mathlib's `SU(3)`. -/
theorem colorTripletSpan_su3_invariant :
    (∀ v ∈ ({v4, v5, v6} : Set ComplexOctonion),
        H23_op v ∈ tripletSpan ∧ H13_op v ∈ tripletSpan) ∧
    (∀ v ∈ ({v4, v5, v6} : Set ComplexOctonion),
        T12_op v ∈ tripletSpan ∧ T21_op v ∈ tripletSpan ∧
        T13_op v ∈ tripletSpan ∧ T31_op v ∈ tripletSpan ∧
        T23_op v ∈ tripletSpan ∧ T32_op v ∈ tripletSpan) := by
  obtain ⟨⟨h23a, h23b, h23c⟩, h13a, h13b, h13c⟩ := cartan_invariant
  obtain ⟨⟨t12a, t12b, t12c⟩, ⟨t21a, t21b, t21c⟩, ⟨t13a, t13b, t13c⟩,
    ⟨t31a, t31b, t31c⟩, ⟨t23a, t23b, t23c⟩, t32a, t32b, t32c⟩ := ladder_invariant
  refine ⟨?_, ?_⟩
  · intro v hv
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hv
    rcases hv with rfl | rfl | rfl
    · exact ⟨h23a, h13a⟩
    · exact ⟨h23b, h13b⟩
    · exact ⟨h23c, h13c⟩
  · intro v hv
    simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hv
    rcases hv with rfl | rfl | rfl
    · exact ⟨t12a, t21a, t13a, t31a, t23a, t32a⟩
    · exact ⟨t12b, t21b, t13b, t31b, t23b, t32b⟩
    · exact ⟨t12c, t21c, t13c, t31c, t23c, t32c⟩

end PhysicsSM.Algebra.Furey.ColorTripletFundamental
