/-!
# Algebra.Octonion.Conjugation

Conjugation involution on the octonions.

For x = a₀ e₀ + a₁ e₁ + … + a₇ e₇, conjugation is:
  conj(x) = a₀ e₀ - a₁ e₁ - … - a₇ e₇

Key properties:
- `conj_conj` : conj (conj x) = x
- `conj_add`  : conj (x + y) = conj x + conj y
- `conj_mul`  : conj (x * y) = conj y * conj x  (note reversed order)
- `mul_conj`  : x * conj x = normSq x • 1

Source: Baez, "The Octonions", §1.
Convention: follows `PhysicsSM.Algebra.Octonion.Basic` basis convention.

Prerequisites:
- `PhysicsSM.Algebra.Octonion.Basic`

Status: stub — conjugation definition and basic lemmas to be added.
-/

namespace PhysicsSM.Algebra.Octonion

end PhysicsSM.Algebra.Octonion
