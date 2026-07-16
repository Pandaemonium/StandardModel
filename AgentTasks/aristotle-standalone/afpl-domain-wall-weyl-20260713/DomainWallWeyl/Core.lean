import Mathlib

/-!
# Finite domain-wall seed for a 3+1 boundary Weyl sector

The Aristotle task asks for an exact local Hermitian transverse chain with a
protected boundary kernel and its tensor-product lift to a Pauli Weyl symbol.
-/

namespace DomainWallWeyl

/-- The three-dimensional Pauli matrices are the intended tangential symbol;
the transverse/domain-wall operator is to be constructed in this package. -/
abbrev Spin := Fin 2

end DomainWallWeyl
