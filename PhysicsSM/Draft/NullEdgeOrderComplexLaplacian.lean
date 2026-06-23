import Mathlib.Tactic

/-!
# Order-complex graph Laplacian: quadratic form and positive semidefiniteness

The seed of the finite Kahler-Dirac / topological-Dirac route. From a finite
incidence (coboundary) matrix `d : Fin e -> Fin v -> Real`, build the differential
`diff` (= d) and codifferential `codiff` (= d-transpose) with respect to the
Euclidean pairing, and the vertex Laplacian `L = codiff . diff`. The Laplacian's
quadratic form is the squared norm of the differential, so `L` is positive
semidefinite - the kernel-checked anchor for `D^2 = Laplacian` later.

Standalone (Mathlib only).
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeOrderComplexLaplacian

open BigOperators

/-- Euclidean pairing on finite real vectors. -/
def dot {n : Nat} (x y : Fin n -> Real) : Real :=
  Finset.univ.sum fun i => x i * y i

/-- Coboundary / differential `d : C^0 -> C^1`. -/
def diff {e v : Nat} (d : Fin e -> Fin v -> Real)
    (f : Fin v -> Real) : Fin e -> Real :=
  fun p => Finset.univ.sum fun a => d p a * f a

/-- Adjoint codifferential `delta : C^1 -> C^0` (the transpose of `d`). -/
def codiff {e v : Nat} (d : Fin e -> Fin v -> Real)
    (x : Fin e -> Real) : Fin v -> Real :=
  fun a => Finset.univ.sum fun p => d p a * x p

/-- Vertex Laplacian `L = delta . d`. -/
def laplacian {e v : Nat} (d : Fin e -> Fin v -> Real)
    (f : Fin v -> Real) : Fin v -> Real :=
  codiff d (diff d f)

/-- Adjointness: `<diff f, x> = <f, codiff x>`. -/
theorem diff_codiff_adjoint {e v : Nat} (d : Fin e -> Fin v -> Real)
    (f : Fin v -> Real) (x : Fin e -> Real) :
    dot (diff d f) x = dot f (codiff d x) := by
  unfold diff codiff dot
  simpa only [mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum] using Finset.sum_comm

/-- The Laplacian quadratic form is the squared norm of the differential. -/
theorem laplacian_quadform_eq_normSq_diff {e v : Nat}
    (d : Fin e -> Fin v -> Real) (f : Fin v -> Real) :
    dot f (laplacian d f) = dot (diff d f) (diff d f) := by
  exact (diff_codiff_adjoint d f (diff d f)).symm

/-- The graph Laplacian is positive semidefinite. -/
theorem laplacian_psd {e v : Nat} (d : Fin e -> Fin v -> Real)
    (f : Fin v -> Real) :
    0 ≤ dot f (laplacian d f) := by
  rw [laplacian_quadform_eq_normSq_diff]
  exact Finset.sum_nonneg fun _ _ => mul_self_nonneg _

end PhysicsSM.Draft.NullEdgeOrderComplexLaplacian
