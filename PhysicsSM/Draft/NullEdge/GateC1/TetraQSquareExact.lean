import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.TetrahedralGlobalGap

/-!
# Gate C1: Euclidean tetrahedral `Q` square scalar identity

This Draft module starts the `TetraQSquareExact` -> `TetraQLowerBound` step
recommended by the 2026-06-28 Pro feedback.

It proves the scalar/coframe part of the exact Euclidean Clifford square:

`qExact(s) = (3/4) * sum_A s_A^2 - (1/8) * (sum_A s_A)^2`.

The existing checked coefficient norm in `TetrahedralGlobalGap.lean` is exactly
this scalar expression when `s_A = sin(k_A)`.  This is the finite coframe
normalization check needed before attaching a concrete Euclidean gamma-matrix
representation.

Claim boundary:

* This file proves the tetrahedral scalar/coframe identity and its lower bound.
* It does not yet prove the matrix identity `Q(k)^2 = qExact(k) • I`; that is
  the next Euclidean Clifford representation theorem.
-/

open scoped BigOperators
open scoped Real

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraQSquareExact

open TetrahedralGlobalGap

/-- The exact scalar coefficient in the Euclidean tetrahedral slash square. -/
noncomputable def qExact (s : Fin 4 -> ℝ) : ℝ :=
  (3 / 4 : ℝ) * ∑ A : Fin 4, (s A) ^ 2
    - (1 / 8 : ℝ) * (∑ A : Fin 4, s A) ^ 2

/-- The exported lower-bound coefficient.  Downstream gap theorems should use
this inequality-shaped API rather than depending on exactness. -/
noncomputable def qLower (s : Fin 4 -> ℝ) : ℝ :=
  (1 / 4 : ℝ) * ∑ A : Fin 4, (s A) ^ 2

/-- Four-variable Cauchy form used by the tetrahedral lower-bound corollary. -/
theorem four_sum_sq_sub_sq_sum_nonneg (s : Fin 4 -> ℝ) :
    0 ≤ 4 * (∑ A : Fin 4, (s A) ^ 2) - (∑ A : Fin 4, s A) ^ 2 := by
  have h01 : 0 ≤ (s 0 - s 1) ^ 2 := sq_nonneg _
  have h02 : 0 ≤ (s 0 - s 2) ^ 2 := sq_nonneg _
  have h03 : 0 ≤ (s 0 - s 3) ^ 2 := sq_nonneg _
  have h12 : 0 ≤ (s 1 - s 2) ^ 2 := sq_nonneg _
  have h13 : 0 ≤ (s 1 - s 3) ^ 2 := sq_nonneg _
  have h23 : 0 ≤ (s 2 - s 3) ^ 2 := sq_nonneg _
  simp [Fin.sum_univ_four]
  nlinarith

/-- The exact scalar coefficient is bounded below by one quarter of the sine
square sum. -/
theorem qLower_le_qExact (s : Fin 4 -> ℝ) :
    qLower s ≤ qExact s := by
  have h := four_sum_sq_sub_sq_sum_nonneg s
  unfold qLower qExact
  nlinarith

/-- The checked tetrahedral coefficient norm is exactly the Euclidean
tetrahedral slash-square scalar coefficient. -/
theorem tetraKineticCoeffNormSq_eq_qExact (k : Fin 4 -> ℝ) :
    tetraKineticCoeffNormSq k =
      qExact (fun A : Fin 4 => Real.sin (k A)) := by
  have hsqrt_ne : Real.sqrt 3 ≠ 0 := by positivity
  unfold tetraKineticCoeffNormSq tetraKineticCoeff qExact
  simp [TetrahedralBranchWindow.vTetra, TetrahedralBranchWindow.wTetra,
    Fin.sum_univ_four]
  field_simp [hsqrt_ne]
  rw [Real.sq_sqrt (by norm_num : (0 : ℝ) ≤ 3)]
  ring_nf

/-- Public lower-bound corollary for the checked tetrahedral kinetic scalar. -/
theorem qLower_le_tetraKineticCoeffNormSq (k : Fin 4 -> ℝ) :
    qLower (fun A : Fin 4 => Real.sin (k A)) ≤
      tetraKineticCoeffNormSq k := by
  rw [tetraKineticCoeffNormSq_eq_qExact]
  exact qLower_le_qExact _

/-- The scalar lower-bound form is strictly positive when any component is
nonzero. -/
theorem qLower_pos_of_exists_ne_zero (s : Fin 4 -> ℝ)
    (h : ∃ A : Fin 4, s A ≠ 0) : 0 < qLower s := by
  unfold qLower
  have hsum_pos : 0 < ∑ A : Fin 4, (s A) ^ 2 := by
    rcases h with ⟨A, hA⟩
    exact Finset.sum_pos'
      (fun B _ => sq_nonneg (s B))
      ⟨A, by simp, sq_pos_of_ne_zero hA⟩
  positivity

/-- The exact tetrahedral quadratic form is strictly positive when any
component is nonzero. -/
theorem qExact_pos_of_exists_ne_zero (s : Fin 4 -> ℝ)
    (h : ∃ A : Fin 4, s A ≠ 0) : 0 < qExact s :=
  lt_of_lt_of_le (qLower_pos_of_exists_ne_zero s h) (qLower_le_qExact s)

/-- The exact tetrahedral quadratic form is nonzero away from the origin. -/
theorem qExact_ne_zero_of_exists_ne_zero (s : Fin 4 -> ℝ)
    (h : ∃ A : Fin 4, s A ≠ 0) : qExact s ≠ 0 :=
  ne_of_gt (qExact_pos_of_exists_ne_zero s h)

/-- The exact tetrahedral quadratic form vanishes precisely at the origin. -/
theorem qExact_eq_zero_iff_forall_eq_zero (s : Fin 4 -> ℝ) :
    qExact s = 0 ↔ ∀ A : Fin 4, s A = 0 := by
  constructor
  · intro hzero A
    by_contra hA
    have hpos := qExact_pos_of_exists_ne_zero s ⟨A, hA⟩
    linarith
  · intro hzero
    unfold qExact
    simp [hzero]

/-- Equivalently, the exact tetrahedral quadratic form is nonzero precisely
when at least one component is nonzero. -/
theorem qExact_ne_zero_iff_exists_ne_zero (s : Fin 4 -> ℝ) :
    qExact s ≠ 0 ↔ ∃ A : Fin 4, s A ≠ 0 := by
  constructor
  · intro hne
    by_contra hnone
    have hall : ∀ A : Fin 4, s A = 0 := by
      intro A
      by_contra hA
      exact hnone ⟨A, hA⟩
    exact hne ((qExact_eq_zero_iff_forall_eq_zero s).2 hall)
  · exact qExact_ne_zero_of_exists_ne_zero s

end TetraQSquareExact
end GateC1
end NullEdge
end Draft
end PhysicsSM
