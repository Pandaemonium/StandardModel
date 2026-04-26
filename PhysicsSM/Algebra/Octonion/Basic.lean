/-!
# Algebra.Octonion.Basic

Octonion type and multiplication table.

The octonions 𝕆 are the 8-dimensional normed division algebra over ℝ. They are
non-associative and non-commutative. The standard basis is {e₀, e₁, ..., e₇}
where e₀ = 1 is the unit.

Multiplication is determined by the Fano plane (for the imaginary units e₁–e₇):
each line of the Fano plane gives a quaternionic triple (eᵢ, eⱼ, eₖ) with
  eᵢ * eⱼ = eₖ,  eⱼ * eᵢ = -eₖ.

Source: Baez, "The Octonions", Bull. Amer. Math. Soc. 39 (2002) 145–205.
Convention: Fano plane orientation follows Baez (2002) Table 1.
  Basis order: e₀=1, e₁=i, e₂=j, e₃=k, e₄=l, e₅=il, e₆=jl, e₇=kl.
  Lines: (1,2,3), (1,4,5), (2,4,6), (3,4,7), (1,6,7), (2,5,7), (3,5,6)
  where indices are 1-based imaginary units.

WARNING: Octonion multiplication is NOT associative. Never use associativity
rewrites without an explicit proof that the subexpression is associative.

Prerequisites:
- `PhysicsSM.Algebra.Division.Basic`

Successor modules:
- `PhysicsSM.Algebra.Octonion.Conjugation`
- `PhysicsSM.Algebra.Octonion.Norm`
- `PhysicsSM.Algebra.Octonion.Alternativity`

Status: stub — Octonion structure to be defined.
-/

namespace PhysicsSM.Algebra.Octonion

-- The Fano plane lines encoding octonion multiplication (1-based imaginary indices).
-- Lines: (1,2,3), (1,4,5), (2,4,6), (3,4,7), (1,6,7), (2,5,7), (3,5,6)

end PhysicsSM.Algebra.Octonion
