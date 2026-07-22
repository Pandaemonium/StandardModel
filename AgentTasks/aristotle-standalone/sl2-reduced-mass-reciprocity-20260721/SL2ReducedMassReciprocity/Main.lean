import Mathlib

open Matrix Complex

noncomputable section

namespace SL2ReducedMassReciprocity

abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- The reduced determinant obtained after eliminating the two chiral blocks
of a four-component local-mass walk. -/
def reducedMassPolynomial (U V : M2) (c lambda : Complex) : Complex :=
  (U * V - (lambda * c) • (U + V) +
    lambda ^ 2 • (1 : M2)).det

/-- Determinant-one two-by-two blocks with equal trace give a reciprocal
reduced mass polynomial.  No unitarity hypothesis is needed for this algebraic
identity. -/
theorem reducedMassPolynomial_reciprocal
    (U V : M2) (c lambda : Complex)
    (hUdet : U.det = 1) (hVdet : V.det = 1)
    (htrace : U.trace = V.trace) (hlambda : Ne lambda 0) :
    reducedMassPolynomial U V c lambda =
      lambda ^ 4 * reducedMassPolynomial U V c lambda⁻¹ := by
  simp only [reducedMassPolynomial, Matrix.det_fin_two, Matrix.mul_apply,
    Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply,
    Matrix.one_apply, Matrix.trace_fin_two] at *
  simp only [Fin.isValue, one_ne_zero, zero_ne_one, if_true, if_false,
    smul_eq_mul] at *
  field_simp
  ring_nf at hUdet hVdet htrace ⊢
  linear_combination
    (-(lambda - 1) * (lambda + 1) *
      (-(c * lambda) * (V 0 0 + V 1 1) +
        (lambda ^ 2 + 1) * (V 0 0 * V 1 1 - V 0 1 * V 1 0))) * hUdet +
    ((lambda - 1) * (lambda + 1) *
      ((c * lambda) * (U 0 0 + U 1 1) - lambda ^ 2 - 1)) * hVdet

/-- Away from zero, roots of the reduced polynomial occur in reciprocal
pairs. -/
theorem reducedMassPolynomial_eq_zero_iff_inv
    (U V : M2) (c lambda : Complex)
    (hUdet : U.det = 1) (hVdet : V.det = 1)
    (htrace : U.trace = V.trace) (hlambda : Ne lambda 0) :
    reducedMassPolynomial U V c lambda = 0 <->
      reducedMassPolynomial U V c lambda⁻¹ = 0 := by
  rw [reducedMassPolynomial_reciprocal U V c lambda hUdet hVdet htrace hlambda]
  constructor
  · intro h
    exact (mul_eq_zero.mp h).resolve_left (pow_ne_zero 4 hlambda)
  · intro h
    simp [h]

end SL2ReducedMassReciprocity
