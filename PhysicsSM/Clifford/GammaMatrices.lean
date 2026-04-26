/-!
# Clifford.GammaMatrices

Concrete gamma matrix families.

Gamma matrices γᵘ are generators of a Clifford algebra satisfying:
  {γᵘ, γᵛ} = γᵘ γᵛ + γᵛ γᵘ = 2 ηᵘᵛ · 1

where η is the metric tensor (signature-dependent).

## Convention

Metric signature: mostly-minus  η = diag(+1, -1, -1, -1)  unless stated otherwise.

The chirality matrix (γ₅ or γ⁵) is:
  γ₅ = i · γ⁰ · γ¹ · γ² · γ³

satisfying (γ₅)² = 1, {γ₅, γᵘ} = 0.

## Families provided

- Dirac representation (4D Minkowski)
- Weyl/chiral representation (4D Minkowski)
- Euclidean representation (for instanton calculations)

Source: Peskin and Schroeder, "Introduction to Quantum Field Theory", Appendix A.
Convention: Peskin-Schroeder metric and gamma matrix conventions.

Status: stub — gamma matrix definitions and Clifford relation proofs to be added.
-/

namespace PhysicsSM.Clifford.GammaMatrices

end PhysicsSM.Clifford.GammaMatrices
