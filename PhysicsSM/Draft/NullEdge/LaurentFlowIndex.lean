import PhysicsSM.Draft.NullEdge.LaurentUnitResource

/-!
# Additive determinant exponent for strict Laurent matrices

The unique monomial exponent of an invertible finite Laurent determinant is
packaged here as an additive algebraic flow invariant.  It is additive under
matrix composition, vanishes on the identity, and assigns a one-channel pure
translation its displayed integer exponent.  A one-channel symbol containing
two distinct nonzero shifts is not invertible over the Laurent ring.

Scope: one Laurent variable over a field and invertibility over the Laurent
ring.  This module does not identify the exponent with the physical GNVW index,
derive a QCA representation, remove aliases, or prove a three-dimensional
no-doubling theorem.

Provenance: Aristotle project `de5baafe-fb03-4e3a-aab6-dd33a73d80eb`,
proof-complete returned source independently compiled against the pinned
repository toolchain on 2026-07-11.  It builds on the clean-room Laurent unit
classification in `LaurentUnitResource`.

Lean 4.28.0.
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
  exact qca_det_is_unique_monomial M hM

/-- The selected algebraic flow exponent. -/
noncomputable def flowExponent {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M) : Int :=
  Classical.choose (detExponent_existsUnique M hM)

theorem flowExponent_spec {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M) :
    DetExponent M (flowExponent M hM) := by
  exact (Classical.choose_spec (detExponent_existsUnique M hM)).1

theorem flowExponent_eq_of_spec {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial K)) (hM : IsUnit M)
    {n : Int} (hn : DetExponent M n) :
    flowExponent M hM = n := by
  exact ((Classical.choose_spec (detExponent_existsUnique M hM)).2 n hn).symm

/-- Determinant exponents add under matrix composition. -/
theorem detExponent_mul {r : Nat}
    {M N : Matrix (Fin r) (Fin r) (LaurentPolynomial K)}
    {m n : Int} (hm : DetExponent M m) (hn : DetExponent N n) :
    DetExponent (M * N) (m + n) := by
  obtain ⟨c, hc, hMc⟩ := hm
  obtain ⟨d, hd, hNd⟩ := hn
  refine ⟨c * d, mul_ne_zero hc hd, ?_⟩
  rw [Matrix.det_mul, hMc, hNd, map_mul, LaurentPolynomial.T_add]
  ring

/-- The selected flow exponent is additive under composition. -/
theorem flowExponent_mul {r : Nat}
    (M N : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
    (hM : IsUnit M) (hN : IsUnit N) :
    flowExponent (M * N) (hM.mul hN) =
      flowExponent M hM + flowExponent N hN := by
  exact flowExponent_eq_of_spec (M * N) (hM.mul hN)
    (detExponent_mul (flowExponent_spec M hM) (flowExponent_spec N hN))

/-- The identity matrix has zero flow exponent. -/
theorem flowExponent_one (r : Nat) :
    flowExponent (1 : Matrix (Fin r) (Fin r) (LaurentPolynomial K))
      isUnit_one = 0 := by
  apply flowExponent_eq_of_spec
  refine ⟨1, one_ne_zero, ?_⟩
  simp [Matrix.det_one, LaurentPolynomial.T_zero]

/-- A one-channel pure translation. -/
def scalarShift (n : Int) :
    Matrix (Fin 1) (Fin 1) (LaurentPolynomial K) := !![LaurentPolynomial.T n]

theorem scalarShift_isUnit (n : Int) : IsUnit (scalarShift (K := K) n) := by
  rw [Matrix.isUnit_iff_isUnit_det, scalarShift, Matrix.det_fin_one_of]
  exact LaurentPolynomial.isUnit_T n

/-- Pure translation has exactly its displayed integer exponent. -/
theorem flowExponent_scalarShift (n : Int) :
    flowExponent (scalarShift (K := K) n) (scalarShift_isUnit n) = n := by
  apply flowExponent_eq_of_spec
  refine ⟨1, one_ne_zero, ?_⟩
  rw [scalarShift, Matrix.det_fin_one_of, map_one, one_mul]

/-- Negative control: a one-channel symbol with two distinct nonzero shifts is
not invertible over the Laurent ring. -/
theorem scalar_two_shift_not_isUnit
    {c d : K} (hc : Ne c 0) (hd : Ne d 0)
    {m n : Int} (hmn : Ne m n) :
    Not (IsUnit
      (!![LaurentPolynomial.C c * LaurentPolynomial.T m +
        LaurentPolynomial.C d * LaurentPolynomial.T n] :
        Matrix (Fin 1) (Fin 1) (LaurentPolynomial K))) := by
  rw [Matrix.isUnit_iff_isUnit_det, Matrix.det_fin_one_of]
  exact two_term_not_isUnit hc hd hmn

/-! ## Build-enforced axiom pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFlowIndex.flowExponent_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flowExponent_mul

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFlowIndex.flowExponent_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flowExponent_one

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFlowIndex.flowExponent_scalarShift' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms flowExponent_scalarShift

/-- info: 'PhysicsSM.Draft.NullEdge.LaurentFlowIndex.scalar_two_shift_not_isUnit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms scalar_two_shift_not_isUnit

end PhysicsSM.Draft.NullEdge.LaurentFlowIndex
