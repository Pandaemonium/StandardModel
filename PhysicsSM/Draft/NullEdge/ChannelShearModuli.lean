import Mathlib

/-!
# A one-parameter moduli family of even-channel refinements

The chirality-even part of the carrier square contains three named channels.
This module proves that any linear type constraints on those three components
leave a faithful one-parameter residual mixing symmetry: an explicit
determinant-one shear preserves their total and preserves membership in every
submodule containing the original components.

This is the first abstract moduli rung for the channel-classification program.
It classifies one residual subgroup before quotienting by physical
selector-preserving equivalence; it does not claim that all refinements are
physically equivalent.

Provenance: statements and proofs returned by Aristotle project
`c2852345-f1ec-4e1d-80ab-821626fe6090`, independently compiled before this
clean-room integration. The construction is elementary rational linear
algebra.
-/

open Matrix
open scoped BigOperators

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelShearModuli

/-- Three even-channel coordinates before adjoining the odd soldering
component. -/
abbrev Coord := Fin 3

/-- A one-parameter shear that transfers `t` times the middle channel from the
third component to the first while preserving the total. -/
def shear (t : ℚ) : Matrix Coord Coord ℚ :=
  !![1, t, 0; 0, 1, 0; 0, -t, 1]

/-- Apply a coefficient matrix to an ordered triple of channel vectors. -/
def mix {V : Type*} [AddCommGroup V] [Module ℚ V]
    (M : Matrix Coord Coord ℚ) (b : Coord → V) (i : Coord) : V :=
  ∑ j, M i j • b j

/-- The shear matrices form an additive one-parameter subgroup. -/
theorem shear_add (s t : ℚ) : shear (s + t) = shear s * shear t := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [shear, Matrix.mul_apply, Fin.sum_univ_three] <;> ring

/-- The zero parameter is the identity refinement. -/
theorem shear_zero : shear 0 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [shear]

/-- The inverse shear has the opposite parameter. -/
theorem shear_mul_neg (t : ℚ) : shear t * shear (-t) = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [shear, Matrix.mul_apply, Fin.sum_univ_three]

/-- Every shear has determinant one. -/
theorem shear_det (t : ℚ) : (shear t).det = 1 := by
  simp [shear, Matrix.det_fin_three]

/-- Column sums are one, exactly the condition preserving the total of the
three mixed components. -/
theorem shear_column_sum (t : ℚ) (j : Coord) : ∑ i, shear t i j = 1 := by
  fin_cases j <;> simp [shear, Fin.sum_univ_three]

/-- Different parameters give different channel-coordinate transformations. -/
theorem shear_injective : Function.Injective shear := by
  intro s t h
  have := congrFun (congrFun h 0) 1
  simpa [shear] using this

/-- Mixing by a shear leaves the sum of the three channel vectors unchanged. -/
theorem sum_mix_shear {V : Type*} [AddCommGroup V] [Module ℚ V]
    (t : ℚ) (b : Coord → V) :
    ∑ i, mix (shear t) b i = ∑ i, b i := by
  simp only [mix, shear, Fin.sum_univ_three]
  simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  abel

/-- The first component gains `t` times the middle channel. -/
theorem mix_shear_zero {V : Type*} [AddCommGroup V] [Module ℚ V]
    (t : ℚ) (b : Coord → V) :
    mix (shear t) b 0 = b 0 + t • b 1 := by
  simp [mix, shear, Fin.sum_univ_three]

/-- The middle channel is fixed. -/
theorem mix_shear_one {V : Type*} [AddCommGroup V] [Module ℚ V]
    (t : ℚ) (b : Coord → V) :
    mix (shear t) b 1 = b 1 := by
  simp [mix, shear, Fin.sum_univ_three]

/-- The third component loses `t` times the middle channel. -/
theorem mix_shear_two {V : Type*} [AddCommGroup V] [Module ℚ V]
    (t : ℚ) (b : Coord → V) :
    mix (shear t) b 2 = b 2 - t • b 1 := by
  simp only [mix, shear, Fin.sum_univ_three]
  simp
  abel

/-- Every linear type constraint represented by a submodule is preserved by
arbitrary channel mixing. -/
theorem mix_mem_submodule {V : Type*} [AddCommGroup V] [Module ℚ V]
    (W : Submodule ℚ V) (M : Matrix Coord Coord ℚ) (b : Coord → V)
    (hb : ∀ j, b j ∈ W) (i : Coord) :
    mix M b i ∈ W := by
  apply Submodule.sum_mem
  intro j _
  exact Submodule.smul_mem _ _ (hb j)

/-- A nonzero middle channel makes the family of ordered refinements genuinely
distinct before quotienting by selector-preserving equivalence. -/
theorem mixed_shear_injective {V : Type*} [AddCommGroup V] [Module ℚ V]
    (b : Coord → V) (hb : b 1 ≠ 0) :
    Function.Injective (fun t : ℚ => mix (shear t) b) := by
  intro s t h
  have h0 := congrFun h 0
  simp only [mix_shear_zero] at h0
  have hs : s • b 1 = t • b 1 := add_left_cancel h0
  have hsub : (s - t) • b 1 = 0 := by
    rw [sub_smul, hs]
    abel
  rcases smul_eq_zero.mp hsub with h1 | h1
  · exact sub_eq_zero.mp h1
  · exact absurd h1 hb

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelShearModuli.shear_add' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms shear_add

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelShearModuli.sum_mix_shear' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_mix_shear

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelShearModuli.mixed_shear_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixed_shear_injective

end PhysicsSM.Draft.NullEdge.ChannelShearModuli
