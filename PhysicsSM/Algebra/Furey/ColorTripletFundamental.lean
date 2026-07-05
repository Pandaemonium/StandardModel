import Mathlib
import PhysicsSM.Algebra.Furey.ColorRepresentation

/-!
# Algebra.Furey.ColorTripletFundamental

Step 1b (weight-level) of the lane-A consolidation
(`AgentTasks/project-strategic-assessment-2026-07.md`): connecting the Furey
color-triplet states to the `SU(3)` fundamental representation.

Together with step 1a (`Octonion.G2FixingE111SpecialUnitaryGroup`, which shows
the octonion `su3Submonoid` IS Mathlib's `Matrix.specialUnitaryGroup (Fin 3) ℂ`),
this begins to identify the physical color triplet with the standard fundamental
rep `ℂ³`.

## What is proved here (the weight signature)

The three color-triplet states `v1, v2, v3` in the minimal left ideal `J` are
simultaneous eigenvectors of the `SU(3)` Cartan generators `H23_op = N2 - N3`
and `H13_op = N1 - N3`, with `(H23, H13)` weights

    w(v1) = (0, -1),   w(v2) = (-1, 0),   w(v3) = (1, 1).

These weights are **traceless** (sum to zero, `colorTriplet_weights_traceless`)
and **distinct** (`colorTriplet_weights_distinct`) - exactly the weight signature
of the `SU(3)` fundamental representation `3`. So the color triplet carries the
fundamental-rep weights, established directly from the kernel-checked eigenvalue
tables in `ColorRepresentation`.

## Remaining for full 1b (documented target, not yet formalized)

The full identification "the color triplet is THE fundamental rep on `ℂ³`" needs
the GROUP action: exhibit a linear isomorphism `span{v1,v2,v3} ≃ ℂ³`
intertwining the `su3Submonoid` action (= Mathlib `SU(3)` by 1a) on `ℂ³` with
its action on the triplet, so the fundamental matrix rep and the Furey color
action coincide. The Cartan-weight match here is the necessary first invariant;
the ladder-operator (`E_ij`) intertwining and the group-level iso are the next
steps (the color ladder relations are already in `ColorJRepresentation`).

Trusted, kernel-checked, `s o r r y`-free. Prerequisites: `ColorRepresentation`
(eigenvalue tables). Source: Furey color `SU(3)` on the complex-octonion ideal.
-/

namespace PhysicsSM.Algebra.Furey.ColorTripletFundamental

open PhysicsSM.Algebra.Furey.MinimalLeftIdeal

/-- `(H23, H13)` Cartan weight of the color-triplet state `v1`. -/
def w1 : ℝ × ℝ := (0, -1)

/-- `(H23, H13)` Cartan weight of the color-triplet state `v2`. -/
def w2 : ℝ × ℝ := (-1, 0)

/-- `(H23, H13)` Cartan weight of the color-triplet state `v3`. -/
def w3 : ℝ × ℝ := (1, 1)

/-- `v1` is a simultaneous Cartan eigenvector with weight `w1 = (0, -1)`. -/
theorem colorTriplet_eigen_v1 :
    H23_op v1 = (w1.1 : ℂ) • v1 ∧ H13_op v1 = (w1.2 : ℂ) • v1 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v1]; simp [w1]
  · rw [H13_op_v1]; simp [w1]

/-- `v2` is a simultaneous Cartan eigenvector with weight `w2 = (-1, 0)`. -/
theorem colorTriplet_eigen_v2 :
    H23_op v2 = (w2.1 : ℂ) • v2 ∧ H13_op v2 = (w2.2 : ℂ) • v2 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v2]; norm_num [w2]
  · rw [H13_op_v2]; simp [w2]

/-- `v3` is a simultaneous Cartan eigenvector with weight `w3 = (1, 1)`. -/
theorem colorTriplet_eigen_v3 :
    H23_op v3 = (w3.1 : ℂ) • v3 ∧ H13_op v3 = (w3.2 : ℂ) • v3 := by
  refine ⟨?_, ?_⟩
  · rw [H23_op_v3]; norm_num [w3]
  · rw [H13_op_v3]; norm_num [w3]

/-- **Fundamental-rep signature (traceless).** The color-triplet Cartan weights
sum to zero - the defining trace-zero condition of an `SU(3)` triplet. -/
theorem colorTriplet_weights_traceless :
    w1.1 + w2.1 + w3.1 = 0 ∧ w1.2 + w2.2 + w3.2 = 0 := by
  constructor <;> norm_num [w1, w2, w3]

/-- **Fundamental-rep signature (distinct weights).** The three color-triplet
weights are pairwise distinct - a genuine three-dimensional weight space, as the
`SU(3)` fundamental requires. -/
theorem colorTriplet_weights_distinct : w1 ≠ w2 ∧ w1 ≠ w3 ∧ w2 ≠ w3 := by
  refine ⟨?_, ?_, ?_⟩ <;> simp [w1, w2, w3, Prod.ext_iff]

end PhysicsSM.Algebra.Furey.ColorTripletFundamental
