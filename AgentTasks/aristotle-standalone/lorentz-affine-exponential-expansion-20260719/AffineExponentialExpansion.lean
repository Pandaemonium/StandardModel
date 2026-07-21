import Mathlib

noncomputable section

open Filter Topology
open scoped Matrix.Norms.Frobenius

namespace AffineExponentialExpansion

abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

/-- A normalized quadratic expansion at zero with an explicit remainder that
tends to zero. -/
structure QuadraticExpansionAtZero
    {E : Type*} [AddCommGroup E] [TopologicalSpace E] [SMul Real E]
    (curve : Real -> E) (base linear quadratic : E) where
  remainder : Real -> E
  remainder_tendsto : Tendsto remainder (nhds 0) (nhds 0)
  expansion : forall t, curve t =
    base + t • linear + t ^ 2 • quadratic + t ^ 2 • remainder t

/-- Second-order Taylor expansion of a matrix exponential whose exponent has
an affine first jet. -/
def matrixExp_affine_quadraticExpansion (A B : Matrix4R) :
    QuadraticExpansionAtZero
      (fun t : Real => NormedSpace.exp
        (t • A + ((t ^ 2) / 2) • B))
      1 A ((1 / 2 : Real) • (A * A + B)) := by
  sorry

/-- The inverse affine exponential has the sign-reversed first coefficient and
the corresponding sign-reversed affine correction. -/
def matrixExp_affine_inverse_quadraticExpansion (A B : Matrix4R) :
    QuadraticExpansionAtZero
      (fun t : Real => (NormedSpace.exp
        (t • A + ((t ^ 2) / 2) • B))⁻¹)
      1 (-A) ((1 / 2 : Real) • (A * A - B)) := by
  sorry

end AffineExponentialExpansion
