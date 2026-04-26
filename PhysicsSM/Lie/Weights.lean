/-!
# Lie.Weights

Weight lattice and highest-weight representations.

For a semisimple Lie algebra 𝔤 of rank r, the weight lattice Λ ⊂ 𝔥* is spanned
by the fundamental weights ω₁, …, ωᵣ, dual to the simple coroots.

Dominant integral weights parameterize finite-dimensional irreducible representations.
The dimension formula (Weyl character formula) gives:
  dim V(λ) = ∏_{α > 0} (⟨λ + ρ, α⟩ / ⟨ρ, α⟩)

where ρ = (1/2) Σ_{α > 0} α is the Weyl vector.

Source: Humphreys, "Introduction to Lie Algebras", §§20–24.

Prerequisites:
- `PhysicsSM.Lie.RootData`

Status: stub — weight lattice and dimension formula to be added.
-/

namespace PhysicsSM.Lie.Weights

end PhysicsSM.Lie.Weights
