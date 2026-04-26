/-!
# Supersymmetry.SuperLie

Super Lie algebras.

A super Lie algebra 𝔤 = 𝔤₀ ⊕ 𝔤₁ is a ℤ/2-graded vector space with a
graded bracket [·, ·] satisfying:
  - Grading: [𝔤ₚ, 𝔤_q] ⊆ 𝔤_{p+q}
  - Graded antisymmetry: [x, y] = -(-1)^{|x||y|} [y, x]
  - Graded Jacobi: [x, [y, z]] = [[x, y], z] + (-1)^{|x||y|} [y, [x, z]]

Note: For odd elements [x, x] = 2[x, x] ≠ 0 in general (anticommutator).

Source: Kac, "Lie Superalgebras", Advances in Mathematics (1977).

Status: stub — super Lie algebra typeclass to be defined.
-/

namespace PhysicsSM.Supersymmetry.SuperLie

end PhysicsSM.Supersymmetry.SuperLie
