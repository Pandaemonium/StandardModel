import Mathlib.Tactic

/-!
# Gram determinant: Cauchy-Schwarz and the concurrence/mass foundation

The 2x2 Gram determinant of two finite real vectors is nonnegative (the finite
Cauchy-Schwarz inequality), and vanishes when the vectors are parallel. This is
the kernel-checked foundation for the Gram-weighted P6 mass and the
concurrence/reduced-density theorems, where the visible mass defect is a Gram
determinant.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeGramDeterminant

open BigOperators

abbrev Vec (n : Nat) := Fin n -> Real

/-- Euclidean dot product. -/
def dot {n : Nat} (u v : Vec n) : Real := Finset.univ.sum fun i => u i * v i

/-- 2x2 Gram determinant of a vector pair. -/
def gramDet {n : Nat} (u v : Vec n) : Real := dot u u * dot v v - dot u v ^ 2

/-- The Gram determinant is nonnegative (finite Cauchy-Schwarz). -/
theorem gramDet_nonneg {n : Nat} (u v : Vec n) : 0 ≤ gramDet u v := by
  -- The square of the inner product is at most the product of the squared norms.
  have h_cauchy_schwarz :
      (Finset.sum Finset.univ (fun i => u i * v i)) ^ 2 ≤
        (Finset.sum Finset.univ (fun i => u i ^ 2)) *
          (Finset.sum Finset.univ (fun i => v i ^ 2)) :=
    Finset.sum_mul_sq_le_sq_mul_sq Finset.univ u v
  exact sub_nonneg_of_le <| by simpa only [sq, dot] using h_cauchy_schwarz

/-- Parallel vectors have vanishing Gram determinant. -/
theorem gramDet_eq_zero_of_parallel {n : Nat} (u v : Vec n) (t : Real)
    (h : ∀ i, v i = t * u i) : gramDet u v = 0 := by
  unfold gramDet dot
  simp +decide [h, mul_comm, mul_left_comm, sq, Finset.mul_sum _ _ _]

end PhysicsSM.Draft.NullEdgeGramDeterminant
