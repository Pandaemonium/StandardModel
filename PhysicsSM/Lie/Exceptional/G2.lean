import Mathlib.Data.Matrix.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic

/-!
# Lie.Exceptional.G2

G₂ root data and the octonion automorphism connection.

G₂ is the 14-dimensional exceptional Lie algebra of rank 2. It has:
- 12 roots (6 positive, 6 negative)
- 2 simple roots with lengths in ratio √3 : 1
- Weyl group of order 12 (dihedral group D₆)

The key connection to octonions: the automorphism group of the octonion algebra 𝕆
is exactly the compact Lie group G₂. This makes G₂ a natural entry point into
the exceptional Lie algebra sequence G₂ ⊂ F₄ ⊂ E₆ ⊂ E₇ ⊂ E₈.

Mathlib has partial G₂ root data in:
  `Mathlib.LinearAlgebra.RootSystem.Finite.G2`

Source: Baez, "The Octonions", §4.1.
Oracle backend: LieART, SageMath `RootSystem(['G',2])`.

Prerequisites:
- `PhysicsSM.Lie.RootData`
- `PhysicsSM.Algebra.Octonion.Basic`

Status: stub — G₂ root data wrapper and automorphism theorem statement to be added.
-/

namespace PhysicsSM.Lie.Exceptional.G2

/-! ## Cartan matrix -/

/--
The rank-two Cartan matrix for `G2`.

Convention: the rows and columns are ordered as `(long simple root,
short simple root)`. With this ordering, the off-diagonal entries are
`a_12 = -1` and `a_21 = -3`. This is the standard Bourbaki/Humphreys
normalization and is the convention used by the Aristotle handoff.

This declaration is intentionally just the concrete integer matrix. It does
not yet claim that we have constructed the full `G2` root system in this file.
Later root-data work can use this as the small, kernel-checked seed.

Provenance: Aristotle job `1c2f1dcd-efa0-49b1-8bb8-bdcb38f738a6`.
-/
def g2CartanMatrix : Matrix (Fin 2) (Fin 2) Int :=
  !![(2 : Int), -1; -3, 2]

/--
The defining matrix entries for `g2CartanMatrix`.

This theorem is deliberately named and explicit so downstream agents can find
the convention without unfolding the definition manually.
-/
theorem g2CartanMatrix_eq_explicit :
    g2CartanMatrix = !![(2 : Int), -1; -3, 2] := by
  rfl

/--
The determinant of the `G2` Cartan matrix is one.

This is the rank-two finite-type check: the determinant is positive, and in
this normalization it is exactly `1`.
-/
theorem g2CartanMatrix_det_eq_one :
    g2CartanMatrix.det = 1 := by
  decide

/--
Both diagonal entries of the `G2` Cartan matrix are `2`, as required for a
Cartan matrix.
-/
theorem g2CartanMatrix_diagonal_entries :
    (∀ i : Fin 2, g2CartanMatrix i i = 2) := by
  intro i
  fin_cases i <;> rfl

/--
The two off-diagonal entries record the long/short asymmetry of `G2`.

The `-3` entry is in row `1`, column `0` because this file orders the simple
roots as `(long, short)`.
-/
theorem g2CartanMatrix_offDiagonal_entries :
    g2CartanMatrix 0 1 = -1 ∧ g2CartanMatrix 1 0 = -3 := by
  exact ⟨rfl, rfl⟩

/--
The diagonal symmetrizer for the chosen `G2` Cartan matrix.

Multiplying on the left by `diag(3, 1)` produces the symmetric matrix
`[[6, -3], [-3, 2]]`. The larger entry corresponds to the long-root row.
-/
def g2CartanSymmetrizer : Matrix (Fin 2) (Fin 2) Int :=
  !![(3 : Int), 0; 0, 1]

/--
The explicit symmetrized `G2` Cartan matrix.
-/
theorem g2CartanSymmetrizer_mul_cartan_eq_explicit :
    g2CartanSymmetrizer * g2CartanMatrix =
      !![(6 : Int), -3; -3, 2] := by
  decide

/--
The chosen diagonal symmetrizer really makes the `G2` Cartan matrix symmetric.
-/
theorem g2CartanSymmetrizer_mul_cartan_symmetric :
    (g2CartanSymmetrizer * g2CartanMatrix).transpose =
      g2CartanSymmetrizer * g2CartanMatrix := by
  decide

end PhysicsSM.Lie.Exceptional.G2
