import Mathlib
import PhysicsSM.Algebra.Furey.ColorRepresentation

/-!
# Algebra.Furey.ColorTripletFundamental

Cartan-weight data for three basis states of the Furey color representation, as a
partial input toward step 1b of the lane-A consolidation
(`AgentTasks/project-strategic-assessment-2026-07.md`): identifying the physical
`SU(3)` color triplet with the standard fundamental representation `ℂ³`.

## What is proved here (Cartan weights of v1, v2, v3)

The basis states `v1, v2, v3` in the minimal left ideal `J` are simultaneous
eigenvectors of the `SU(3)` Cartan generators `H23_op = N2 - N3` and
`H13_op = N1 - N3`, with `(H23, H13)` weights

    w(v1) = (0, -1),   w(v2) = (-1, 0),   w(v3) = (1, 1).

These weights sum to zero (`v123_weights_sum_zero`) and are distinct
(`v123_weights_distinct`), established directly from the kernel-checked
eigenvalue tables in `ColorRepresentation`.

## IMPORTANT caveat: these three states are NOT a connected color triplet

Deeper inspection (2026-07-05) of the ladder actions in
`Furey/OperatorAlgebra` shows the color ladder operators `T_ij` MIX the index
groups `{v1,v2,v3}` and `{v4,v5,v6}` (e.g. `alpha2† v6 = v3`, `alpha1 v3 = v5`,
`alpha1† v4 = v2`), so `span{v1,v2,v3}` is NOT `SU(3)`-invariant and `v1,v2,v3`
do NOT form a single connected color triplet. The physical color triplets are
grouped by particle (anti-up `= a1†ν, a2†ν, a3†ν`; anti-down
`= a1†a3†ν, a2†a3†ν, a1†a2†ν`, per `SMStates`) and interleave `v1..v6`.

Consequently the sum-to-zero here is a property of THIS particular triple of
states, NOT evidence that they carry the fundamental representation. This module
is therefore only a weight-datum contribution; it does NOT establish the
fundamental-rep identification.

## What full 1b actually requires (corrected target)

Identify the genuine connected color triplet (the `SU(3)`-invariant
`span` on which the `T_ij` close), show its `span ≃ ℂ³` intertwines the
`su3Submonoid` action (= Mathlib `SU(3)` by 1a), and match the fundamental
matrix rep. The non-zero `T_ij` actions on the triplet (which cross the
`v1..v6` grouping) are the missing computations; the boundary-zero `T_ij`
actions are already in `OperatorAlgebra`.

Trusted, kernel-checked, `s o r r y`-free. Prerequisites: `ColorRepresentation`.
Source: Furey color `SU(3)` on the complex-octonion ideal.
-/

namespace PhysicsSM.Algebra.Furey.ColorTripletFundamental

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-- `(H23, H13)` Cartan weight of the basis state `v1`. -/
def w1 : ℝ × ℝ := (0, -1)

/-- `(H23, H13)` Cartan weight of the basis state `v2`. -/
def w2 : ℝ × ℝ := (-1, 0)

/-- `(H23, H13)` Cartan weight of the basis state `v3`. -/
def w3 : ℝ × ℝ := (1, 1)

/-- `v1` is a simultaneous Cartan eigenvector with weight `w1 = (0, -1)`. -/
theorem cartanEigen_v1 :
    H23_op v1 = (w1.1 : ℂ) • v1 ∧ H13_op v1 = (w1.2 : ℂ) • v1 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v1]; simp [w1]
  · rw [H13_op_v1]; simp [w1]

/-- `v2` is a simultaneous Cartan eigenvector with weight `w2 = (-1, 0)`. -/
theorem cartanEigen_v2 :
    H23_op v2 = (w2.1 : ℂ) • v2 ∧ H13_op v2 = (w2.2 : ℂ) • v2 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v2]; norm_num [w2]
  · rw [H13_op_v2]; simp [w2]

/-- `v3` is a simultaneous Cartan eigenvector with weight `w3 = (1, 1)`. -/
theorem cartanEigen_v3 :
    H23_op v3 = (w3.1 : ℂ) • v3 ∧ H13_op v3 = (w3.2 : ℂ) • v3 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v3]; norm_num [w3]
  · rw [H13_op_v3]; norm_num [w3]

/-- The `(H23, H13)` weights of `v1, v2, v3` sum to zero. (A property of this
particular triple; see the module caveat - they are NOT a connected triplet.) -/
theorem v123_weights_sum_zero :
    w1.1 + w2.1 + w3.1 = 0 ∧ w1.2 + w2.2 + w3.2 = 0 := by
  constructor <;> norm_num [w1, w2, w3]

/-- The three weights are pairwise distinct. -/
theorem v123_weights_distinct : w1 ≠ w2 ∧ w1 ≠ w3 ∧ w2 ≠ w3 := by
  refine ⟨?_, ?_, ?_⟩ <;> simp [w1, w2, w3, Prod.ext_iff]

end PhysicsSM.Algebra.Furey.ColorTripletFundamental
