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
  ladders `T_ij`).
* `tripletSpan_irreducible` (**headline**): the invariant subspace is
  IRREDUCIBLE - any `SU(3)`-invariant subspace of `tripletSpan` is `⊥` or the
  whole triplet. Proof: from any nonzero vector, `H23`/`H13` (with distinct
  eigenvalues) EXTRACT a basis vector, and the six ladders CONNECT all of
  `v4, v5, v6`. With the traceless distinct fundamental weight signature, an
  irreducible 3-dim `SU(3)`-rep with those weights IS the fundamental rep `3`.

Via 1a the acting `SU(3)` is Mathlib's `Matrix.specialUnitaryGroup (Fin 3) ℂ`,
so this is the standard fundamental representation realized on the
complex-octonion ideal.

## Note (red-team audit, 2026-07-05)

The full-repo audit correctly flagged that an EARLIER version proved only
invariance + the weight signature, which is one lemma short of "the fundamental
rep" (it did not rule out a reducible 3-dim rep with those weights). That gap is
now CLOSED by `tripletSpan_irreducible`.

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

/-! ## Irreducibility: the triplet IS the fundamental rep

The extraction lemmas below use that `H23`/`H13` have DISTINCT eigenvalues on
`v4, v5, v6` to isolate a single basis vector from any nonzero combination; the
ladders then connect all three. Hence no proper nonzero invariant subspace. -/

/-- `H23^2 - H23` extracts (twice) the `v4` component: `H23` eigenvalues are
`v4 -> -1`, `v5 -> +1`, `v6 -> 0`, and `(-1)^2-(-1)=2`, `1^2-1=0`, `0^2-0=0`. -/
theorem extract_v4 (a b c : ℂ) :
    H23_op (H23_op (a • v4 + b • v5 + c • v6)) - H23_op (a • v4 + b • v5 + c • v6)
      = (2 * a) • v4 := by
  simp only [map_add, map_smul, H23_op_v4, H23_op_v5, H23_op_v6, smul_zero, map_zero]; module

/-- `H23^2 + H23` extracts (twice) the `v5` component. -/
theorem extract_v5 (a b c : ℂ) :
    H23_op (H23_op (a • v4 + b • v5 + c • v6)) + H23_op (a • v4 + b • v5 + c • v6)
      = (2 * b) • v5 := by
  simp only [map_add, map_smul, H23_op_v4, H23_op_v5, H23_op_v6, smul_zero, map_zero]; module

/-- `H13^2 + H13` extracts (twice) the `v6` component (`H13`: `v4 -> -1`,
`v5 -> 0`, `v6 -> +1`). -/
theorem extract_v6 (a b c : ℂ) :
    H13_op (H13_op (a • v4 + b • v5 + c • v6)) + H13_op (a • v4 + b • v5 + c • v6)
      = (2 * c) • v6 := by
  simp only [map_add, map_smul, H13_op_v4, H13_op_v5, H13_op_v6, smul_zero, map_zero]; module

/-- **1b IRREDUCIBILITY**: any subspace of `tripletSpan` closed under the eight
`SU(3)` generators is `⊥` or all of `tripletSpan`. Together with the traceless
distinct fundamental weights, this makes the color triplet THE `SU(3)`
fundamental representation `3` (not merely some 3-dim rep with those weights). -/
theorem tripletSpan_irreducible (W : Submodule ℂ ComplexOctonion)
    (hle : W ≤ tripletSpan)
    (hH23 : ∀ x ∈ W, H23_op x ∈ W) (hH13 : ∀ x ∈ W, H13_op x ∈ W)
    (hT12 : ∀ x ∈ W, T12_op x ∈ W) (hT21 : ∀ x ∈ W, T21_op x ∈ W)
    (hT13 : ∀ x ∈ W, T13_op x ∈ W) (hT31 : ∀ x ∈ W, T31_op x ∈ W)
    (hT23 : ∀ x ∈ W, T23_op x ∈ W) (hT32 : ∀ x ∈ W, T32_op x ∈ W)
    (hne : W ≠ ⊥) : W = tripletSpan := by
  obtain ⟨w, hwW, hw0⟩ := (Submodule.ne_bot_iff W).mp hne
  have hwsp : w ∈ tripletSpan := hle hwW
  rw [tripletSpan, Submodule.mem_span_triple] at hwsp
  obtain ⟨a, b, c, habc⟩ := hwsp
  have conn : ∀ z ∈ W, z = v4 ∨ z = v5 ∨ z = v6 → v4 ∈ W ∧ v5 ∈ W ∧ v6 ∈ W := by
    rintro z hz (rfl | rfl | rfl)
    · refine ⟨hz, ?_, ?_⟩
      · have := hT32 _ hz; rwa [T32_op_v4] at this
      · have := hT31 _ hz; rw [T31_op_v4] at this; simpa using neg_mem this
    · refine ⟨?_, hz, ?_⟩
      · have := hT23 _ hz; rwa [T23_op_v5] at this
      · have := hT21 _ hz; rwa [T21_op_v5] at this
    · refine ⟨?_, ?_, hz⟩
      · have := hT13 _ hz; rw [T13_op_v6] at this; simpa using neg_mem this
      · have := hT12 _ hz; rwa [T12_op_v6] at this
  have hall : v4 ∈ W ∧ v5 ∈ W ∧ v6 ∈ W := by
    by_cases ha : a = 0
    · by_cases hb : b = 0
      · have hc : c ≠ 0 := by rintro rfl; simp [ha, hb] at habc; exact hw0 habc.symm
        have hmem : (2 * c) • v6 ∈ W := by
          rw [← extract_v6 a b c, habc]; exact add_mem (hH13 _ (hH13 _ hwW)) (hH13 _ hwW)
        have hv6 : v6 ∈ W := by
          have h2c : (2 * c) ≠ 0 := by simp [hc]
          have := Submodule.smul_mem W ((2 * c)⁻¹) hmem
          rwa [smul_smul, inv_mul_cancel₀ h2c, one_smul] at this
        exact conn v6 hv6 (Or.inr (Or.inr rfl))
      · have hmem : (2 * b) • v5 ∈ W := by
          rw [← extract_v5 a b c, habc]; exact add_mem (hH23 _ (hH23 _ hwW)) (hH23 _ hwW)
        have hv5 : v5 ∈ W := by
          have h2b : (2 * b) ≠ 0 := by simp [hb]
          have := Submodule.smul_mem W ((2 * b)⁻¹) hmem
          rwa [smul_smul, inv_mul_cancel₀ h2b, one_smul] at this
        exact conn v5 hv5 (Or.inr (Or.inl rfl))
    · have hmem : (2 * a) • v4 ∈ W := by
        rw [← extract_v4 a b c, habc]; exact sub_mem (hH23 _ (hH23 _ hwW)) (hH23 _ hwW)
      have hv4 : v4 ∈ W := by
        have h2a : (2 * a) ≠ 0 := by simp [ha]
        have := Submodule.smul_mem W ((2 * a)⁻¹) hmem
        rwa [smul_smul, inv_mul_cancel₀ h2a, one_smul] at this
      exact conn v4 hv4 (Or.inl rfl)
  refine le_antisymm hle ?_
  rw [tripletSpan, Submodule.span_le]
  rintro x (rfl | rfl | rfl)
  exacts [hall.1, hall.2.1, hall.2.2]

end PhysicsSM.Algebra.Furey.ColorTripletFundamental
