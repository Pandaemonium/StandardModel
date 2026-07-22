import PhysicsSM.Draft.NullEdge.HNUMassiveGlobalGap

/-!
# General spectral reduction for the massive HNU walk

The global HNU gap theorem reduces the four-component shifted determinant only
at the two Floquet gap points `+1` and `-1`.  Spectral pairing requires the
corresponding identity for an arbitrary complex spectral parameter.  This
module proves that exact finite reduction.

For the two opposite-chirality HNU endpoint blocks `U = endpoint k` and
`V = endpoint (-k)`, the characteristic determinant of the complete local-mass
walk reduces to

`det (U * V - lambda * cos(a) * (U + V) + lambda^2 * I)`.

The module then proves that determinant-one of the two chiral endpoint blocks
already forces the reduced polynomial to be reciprocal; neither unitarity nor
equal traces are needed for that algebraic step.  Hence every nonzero
characteristic root of the live massive HNU walk is accompanied by its
reciprocal.  Opposite Cayley eigenvalues, rank-two inertia, physical-sector
selection, and companion removal remain successor gates.

Provenance: clean-room finite block-determinant computation in the live HNU
conventions.  The theorem order is informed by the doubled-Weyl Dirac QCA
architecture in Bisio, D'Ariano, Perinotti, and Tosini, arXiv:1601.04832 and
arXiv:1601.04842.  The proof was completed locally under the pinned toolchain
on 2026-07-21.

Draft-trust status: the theorem is kernel-checked.  The dedicated axiom guard
pins the dependency footprint.
-/

open Matrix Complex
open PhysicsSM.Draft.NullEdge.HNUExactCore
open PhysicsSM.Draft.NullEdge.HNUPlueckerMassiveStay

noncomputable section

namespace PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity

/-- Two-by-two complex matrices used by the reduced characteristic
polynomial. -/
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- The reduced determinant obtained after eliminating the two chiral blocks
of a four-component local-mass walk. -/
def reducedMassPolynomial (U V : M2) (c lambda : Complex) : Complex :=
  (U * V - (lambda * c) • (U + V) +
    lambda ^ 2 • (1 : M2)).det

/-- Determinant-one two-by-two chiral blocks force the reduced massive
characteristic polynomial to be reciprocal.  Equal traces and unitarity are
not needed for this finite algebraic identity. -/
theorem reducedMassPolynomial_reciprocal
    (U V : M2) (c lambda : Complex)
    (hUdet : U.det = 1) (hVdet : V.det = 1) (hlambda : Ne lambda 0) :
    reducedMassPolynomial U V c lambda =
      lambda ^ 4 * reducedMassPolynomial U V c lambda⁻¹ := by
  simp only [reducedMassPolynomial, Matrix.det_fin_two, Matrix.mul_apply,
    Fin.sum_univ_two, Matrix.add_apply, Matrix.sub_apply, Matrix.smul_apply,
    Matrix.one_apply] at *
  simp only [Fin.isValue, one_ne_zero, zero_ne_one, if_true, if_false,
    smul_eq_mul] at *
  field_simp
  ring_nf at hUdet hVdet ⊢
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
    (hUdet : U.det = 1) (hVdet : V.det = 1) (hlambda : Ne lambda 0) :
    reducedMassPolynomial U V c lambda = 0 <->
      reducedMassPolynomial U V c lambda⁻¹ = 0 := by
  rw [reducedMassPolynomial_reciprocal U V c lambda hUdet hVdet hlambda]
  constructor
  · intro h
    exact (mul_eq_zero.mp h).resolve_left (pow_ne_zero 4 hlambda)
  · intro h
    simp [h]

/-- Momentum reversal preserves the exact trace of the two-component HNU
endpoint. -/
theorem endpoint_neg_trace_eq (k : Fin 3 -> Real) :
    (endpoint (fun i => -k i)).trace = (endpoint k).trace := by
  simp [trace_endpoint, neg_div]

set_option maxHeartbeats 6000000 in
/-- General spectral-parameter version of the live massive HNU shifted
determinant reduction. -/
theorem massiveHNU_general_shifted_det_reduction (a : Real)
    (k : Fin 3 -> Real) (lambda : Complex) :
    (massiveHNU (1 : Complex) a k -
        lambda • (1 : Matrix (Fin 4) (Fin 4) Complex)).det =
      (endpoint k * endpoint (fun i => -k i) -
        (lambda * Real.cos a) •
          (endpoint k + endpoint (fun i => -k i)) +
        lambda ^ 2 • (1 : Matrix (Fin 2) (Fin 2) Complex)).det := by
  unfold massiveHNU diracHNU
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.massCoin4
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.mass4
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.beta
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.beta5
    PhysicsSM.Draft.NullEdge.Pluecker3Plus1ComplexMass.gamma5
  unfold diracBasis doubledChiralEndpoint
  norm_num [Matrix.det_succ_row_zero]
  simp +decide [Fin.sum_univ_succ, Fin.succAbove, Matrix.mul_apply,
    Matrix.one_apply] at *
  simp +decide [Matrix.vecMul, Matrix.vecHead, Matrix.vecTail] at *
  ring_nf at *
  norm_cast
  norm_num [show (Real.sqrt 2 : Real) ^ 6 = (Real.sqrt 2 ^ 2) ^ 3 by ring,
    show (Real.sqrt 2 : Real) ^ 8 = (Real.sqrt 2 ^ 2) ^ 4 by ring]
  ring_nf
  norm_cast
  norm_num [show (Real.sqrt 2 : Real) ^ 4 = (Real.sqrt 2 ^ 2) ^ 2 by ring,
    show (Real.sqrt 2 : Real) ^ 2 = 2 by norm_num]
  norm_num [Complex.sin_sq]
  have hsin4 : Complex.sin (a : Complex) ^ 4 =
      (1 - Complex.cos (a : Complex) ^ 2) ^ 2 := by
    rw [show Complex.sin (a : Complex) ^ 4 =
      (Complex.sin (a : Complex) ^ 2) ^ 2 by ring]
    rw [Complex.sin_sq]
  rw [hsin4]
  ring

/-- The full characteristic determinant of the live massive HNU walk is a
reciprocal degree-four polynomial. -/
theorem massiveHNU_shifted_det_reciprocal (a : Real)
    (k : Fin 3 -> Real) (lambda : Complex) (hlambda : Ne lambda 0) :
    (massiveHNU (1 : Complex) a k -
        lambda • (1 : Matrix (Fin 4) (Fin 4) Complex)).det =
      lambda ^ 4 *
        (massiveHNU (1 : Complex) a k -
          lambda⁻¹ • (1 : Matrix (Fin 4) (Fin 4) Complex)).det := by
  rw [massiveHNU_general_shifted_det_reduction,
    massiveHNU_general_shifted_det_reduction]
  exact reducedMassPolynomial_reciprocal
    (endpoint k) (endpoint (fun i => -k i)) (Real.cos a) lambda
    (endpoint_det k) (endpoint_det (fun i => -k i)) hlambda

/-- Nonzero characteristic roots of the live massive HNU walk occur in
reciprocal pairs. -/
theorem massiveHNU_shifted_det_eq_zero_iff_inv (a : Real)
    (k : Fin 3 -> Real) (lambda : Complex) (hlambda : Ne lambda 0) :
    (massiveHNU (1 : Complex) a k -
        lambda • (1 : Matrix (Fin 4) (Fin 4) Complex)).det = 0 <->
      (massiveHNU (1 : Complex) a k -
        lambda⁻¹ • (1 : Matrix (Fin 4) (Fin 4) Complex)).det = 0 := by
  rw [massiveHNU_shifted_det_reciprocal a k lambda hlambda]
  constructor
  · intro h
    exact (mul_eq_zero.mp h).resolve_left (pow_ne_zero 4 hlambda)
  · intro h
    simp [h]

end PhysicsSM.Draft.NullEdge.HNUMassiveSpectralReciprocity
