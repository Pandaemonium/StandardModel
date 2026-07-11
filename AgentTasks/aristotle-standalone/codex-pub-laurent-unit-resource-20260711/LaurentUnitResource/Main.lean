import Mathlib.Algebra.Polynomial.Laurent

/-!
# Units of a finite Laurent-polynomial ring

Focused strict-QCA resource target.  First classify the algebraic units.  Any
QCA flow-index or de-aliasing consequence must be stated separately and cannot
be inferred merely from this ring theorem.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace LaurentUnitResource

variable {K : Type*} [Field K]

/-- Every invertible finite Laurent polynomial over a field is a nonzero
coefficient times one Laurent monomial. -/
theorem isUnit_iff_exists_C_mul_T (p : LaurentPolynomial K) :
    IsUnit p <->
      Exists fun c : K => c ≠ 0 /\
        Exists fun n : Int => p = LaurentPolynomial.C c * LaurentPolynomial.T n := by
  sorry

/-- The exponent of a unit Laurent polynomial is unique. -/
theorem unit_monomial_exponent_unique
    {c d : K} (hc : c ≠ 0) (hd : d ≠ 0) {m n : Int}
    (h : LaurentPolynomial.C c * LaurentPolynomial.T m =
      LaurentPolynomial.C d * LaurentPolynomial.T n) :
    m = n := by
  sorry

/-- A two-term Laurent polynomial with distinct exponents and nonzero
coefficients is not a unit. -/
theorem two_term_not_isUnit
    {c d : K} (hc : c ≠ 0) (hd : d ≠ 0) {m n : Int} (hmn : m ≠ n) :
    Not (IsUnit (LaurentPolynomial.C c * LaurentPolynomial.T m +
      LaurentPolynomial.C d * LaurentPolynomial.T n)) := by
  sorry

end LaurentUnitResource
