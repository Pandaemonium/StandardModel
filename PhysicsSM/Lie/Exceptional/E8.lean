/-!
# Lie.Exceptional.E8

E₈ root data.

E₈ is the largest exceptional simple Lie algebra. Key facts:
- Rank: 8
- Dimension: 248
- Number of roots: 240 (120 positive, 120 negative)
- Weyl group order: 696,729,600
- Cartan matrix determinant: 1 (E₈ is self-dual)
- E₈ lattice is the unique even unimodular lattice in ℝ⁸

The E₈ root system consists of:
  { ±eᵢ ± eⱼ : 1 ≤ i < j ≤ 8 }  (112 roots)
  { (1/2)(±e₁ ± e₂ ± ... ± e₈) : even number of minus signs }  (128 roots)

## Relevance to physics

E₈ × E₈ is the gauge group of one of the two heterotic string theories.
The decomposition E₈ ⊃ SO(16) ⊃ SO(10) × SO(6) ... connects to
Standard Model representation theory.

Source: Adams, "Lectures on Exceptional Lie Groups" (1996).
Oracle backend: LieART (`RootSystem["E8"]`), SageMath (`RootSystem(['E',8])`).
Convention: Bourbaki simple root labelling.

Planned first theorems:
- `E8.rank_eq : E8.rank = 8`
- `E8.root_card : Fintype.card E8.roots = 240`
- `E8.cartan_det : E8.cartanMatrix.det = 1`

Prerequisites:
- `PhysicsSM.Lie.RootData`

Status: stub — E₈ root data and first theorems to be added.
-/

namespace PhysicsSM.Lie.Exceptional.E8

end PhysicsSM.Lie.Exceptional.E8
