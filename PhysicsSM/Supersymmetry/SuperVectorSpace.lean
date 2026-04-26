/-!
# Supersymmetry.SuperVectorSpace

ℤ/2-graded vector spaces (super vector spaces).

A super vector space is a ℤ/2-graded vector space V = V₀ ⊕ V₁ where:
- V₀ is the even (bosonic) subspace
- V₁ is the odd (fermionic) subspace

The parity of a homogeneous element v ∈ Vₚ is |v| = p ∈ ℤ/2.

Super vector spaces form a symmetric monoidal category with the Koszul sign rule:
  τ(v ⊗ w) = (-1)^{|v||w|} (w ⊗ v)

This sign rule is the source of all minus signs in SUSY algebra.

Source: Deligne and Morgan, "Notes on Supersymmetry", in "Quantum Fields and Strings" (1999).

Status: stub — ℤ/2-graded structures to be built on Mathlib grading infrastructure.
-/

namespace PhysicsSM.Supersymmetry.SuperVectorSpace

end PhysicsSM.Supersymmetry.SuperVectorSpace
