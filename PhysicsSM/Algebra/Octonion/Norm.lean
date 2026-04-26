/-!
# Algebra.Octonion.Norm

Squared norm and norm on octonions.

The squared norm is defined by:
  normSq(x) = x * conj(x) = a₀² + a₁² + … + a₇²

Key properties:
- `normSq_nonneg`  : 0 ≤ normSq x
- `normSq_eq_zero` : normSq x = 0 ↔ x = 0
- `normSq_mul`     : normSq (x * y) = normSq x * normSq y  (multiplicativity)
- `normSq_conj`    : normSq (conj x) = normSq x

The multiplicativity of the norm is a fundamental property of normed division
algebras and follows (for octonions) from the alternativity laws.

Source: Baez, "The Octonions", §1.
Convention: positive-definite Euclidean norm.
Provenance: clean-room formalization target from literature.

Prerequisites:
- `PhysicsSM.Algebra.Octonion.Basic`
- `PhysicsSM.Algebra.Octonion.Conjugation`

Status: stub — normSq definition and key lemmas to be added.
-/

namespace PhysicsSM.Algebra.Octonion

end PhysicsSM.Algebra.Octonion
