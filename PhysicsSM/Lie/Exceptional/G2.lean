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

end PhysicsSM.Lie.Exceptional.G2
