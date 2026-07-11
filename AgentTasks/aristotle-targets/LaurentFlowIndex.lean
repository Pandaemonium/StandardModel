import PhysicsSM.Draft.NullEdge.LaurentUnitResource

/-!
# Additive determinant exponent for a strict Laurent matrix

Successor target to `LaurentUnitResource`.  The unique monomial exponent of an
invertible Laurent determinant is packaged as an additive algebraic flow index.
Identity and pure-shift normalizations plus a two-shift noninvertibility control
make the invariant nonvacuous.

This is one-dimensional ring algebra.  It does not identify the exponent with
the physical GNVW index or imply a three-dimensional no-doubling theorem.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LaurentFlowIndex

open LaurentUnitResource

variable {K : Type*} [Field K]

/-- A proposed exponent for a square Laurent matrix determinant. -/
def DetExponent {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (n : Int) : Prop :=
  Exists fun c : K => Ne c 0 /\
    M.det = LaurentPolynomial.C c * LaurentPolynomial.T n

/-- An invertible finite Laurent matrix has a unique determinant exponent. -/
theorem detExponent_existsUnique {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M) :
    ExistsUnique fun n : Int => DetExponent M n := by
  sorry

/-- The selected algebraic flow exponent. -/
noncomputable def flowExponent {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M) : Int :=
  Classical.choose (detExponent_existsUnique M hM)

theorem flowExponent_spec {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M) :
    DetExponent M (flowExponent M hM) := by
  sorry

theorem flowExponent_eq_of_spec {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M)
    {n : Int} (hn : DetExponent M n) :
    flowExponent M hM = n := by
  sorry

/-- Determinant exponents add under matrix composition. -/
theorem detExponent_mul {r : Nat}
    {M N : Matrix (Fin r) (Fin r) (LaurentPolynomial K)}
    {m n : Int} (hm : DetExponent M m) (hn : DetExponent N n) :
    DetExponent (M * N) (m + n) := by
  sorry

/-- The selected flow exponent is additive under composition. -/
theorem flowExponent_mul {r : Nat}
    (M N : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
    (hM : IsUnit M) (hN : IsUnit N) :
    flowExponent (M * N) (hM.mul hN) =
      flowExponent M hM + flowExponent N hN := by
  sorry

/-- The identity matrix has zero flow exponent. -/
theorem flowExponent_one (r : Nat) :
    flowExponent (1 : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
      isUnit_one = 0 := by
  sorry

/-- A one-channel pure translation. -/
def scalarShift (n : Int) :
    Matrix (Fin 1) (Fin 1) (LaurentPolynomial K) := !![LaurentPolynomial.T n]

theorem scalarShift_isUnit (n : Int) : IsUnit (scalarShift (K := K) n) := by
  sorry

/-- Pure translation has exactly its displayed integer exponent. -/
theorem flowExponent_scalarShift (n : Int) :
    flowExponent (scalarShift (K := K) n) (scalarShift_isUnit n) = n := by
  sorry

/-- Negative control: a one-channel symbol with two distinct nonzero shifts is
not invertible over the Laurent ring. -/
theorem scalar_two_shift_not_isUnit
    {c d : K} (hc : Ne c 0) (hd : Ne d 0)
    {m n : Int} (hmn : Ne m n) :
    Not (IsUnit
      (!![LaurentPolynomial.C c * LaurentPolynomial.T m +
        LaurentPolynomial.C d * LaurentPolynomial.T n] :
        Matrix (Fin 1) (Fin 1) (LaurentPolynomial K))) := by
  sorry

end PhysicsSM.Draft.NullEdge.LaurentFlowIndex
