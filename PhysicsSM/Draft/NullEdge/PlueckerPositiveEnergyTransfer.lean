import PhysicsSM.Draft.NullEdge.PlueckerMassOperator
import PhysicsSM.Draft.NullEdge.FiniteHamiltonianTransferPole

/-!
# Positive-energy Pluecker transfer and visible pole

This module composes the derived Pluecker rest operator with the finite
Hamiltonian-to-transfer ladder. For a nonzero spinor wedge `z`, the positive
rest eigenline has energy `norm z`, exact Euclidean decay, logarithmic energy
reconstruction, and positive transfer-denominator weight. No independent mass
parameter is introduced.

The opposite eigenline is retained as a control: its Euclidean transfer factor
is greater than one at positive spacing. Thus the full indefinite rest
operator is not being smuggled in as a positive Hamiltonian. A physical
positive-energy selection remains an explicit reconstruction hypothesis.

Scope: exact finite quadratic dynamics. This is not a derivation of an
interacting reflection-positive action, an infinite-volume pole, or LSZ.
-/

noncomputable section

open scoped BigOperators Matrix.Norms.L2Operator

namespace PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer

open PhysicsSM.Draft.NullEdge.PlueckerMassOperator
open PhysicsSM.Draft.NullEdge.FiniteHamiltonianTransferPole
open Matrix

abbrev Two := Fin 2

/-- Explicit positive-rest eigenvector of the Pluecker operator. -/
def positiveRestVector (z : Complex) : Two -> Complex :=
  ![z, (norm z : Complex)]

/-- Explicit negative-rest eigenvector retained as the selection control. -/
def negativeRestVector (z : Complex) : Two -> Complex :=
  ![z, -(norm z : Complex)]

theorem positiveRestVector_ne_zero (z : Complex) (hz : z ≠ 0) :
    positiveRestVector z ≠ 0 := by
  simpa [positiveRestVector] using (rest_eigenvectors z).2.2 hz

theorem negativeRestVector_ne_zero (z : Complex) (hz : z ≠ 0) :
    negativeRestVector z ≠ 0 := by
  intro h
  have h0 := congrFun h 0
  simp [negativeRestVector] at h0
  exact hz h0

/-- The selected line has the positive energy derived from the wedge norm. -/
theorem positiveRestVector_eigen (z : Complex) :
    Bz z *ᵥ positiveRestVector z =
      (norm z : Complex) • positiveRestVector z := by
  simpa [positiveRestVector] using (rest_eigenvectors z).1

/-- The discarded line has the opposite rest energy. -/
theorem negativeRestVector_eigen (z : Complex) :
    Bz z *ᵥ negativeRestVector z =
      (-(norm z : Complex)) • negativeRestVector z := by
  simpa [negativeRestVector] using (rest_eigenvectors z).2.1

/-- Exact one-step Euclidean decay on the positive Pluecker eigenline. -/
theorem positiveRestVector_transfer (z : Complex) (a : Real) :
    transfer a (Bz z) *ᵥ positiveRestVector z =
      (Real.exp (-a * norm z) : Complex) • positiveRestVector z := by
  exact transfer_mulVec_eigenmode a (norm z) (Bz z)
    (positiveRestVector z) (positiveRestVector_eigen z)

/-- Exact one-step Euclidean growth on the negative Pluecker eigenline. -/
theorem negativeRestVector_transfer (z : Complex) (a : Real) :
    transfer a (Bz z) *ᵥ negativeRestVector z =
      (Real.exp (a * norm z) : Complex) • negativeRestVector z := by
  have hv : Bz z *ᵥ negativeRestVector z =
      ((-norm z : Real) : Complex) • negativeRestVector z := by
    simpa using negativeRestVector_eigen z
  convert transfer_mulVec_eigenmode a (-norm z) (Bz z)
    (negativeRestVector z) hv using 1
  ring

/-- Positive spacing and nonzero wedge make the selected transfer eigenvalue
strictly contractive. -/
theorem positiveRestFactor_between_zero_one (z : Complex) (hz : z ≠ 0)
    (a : Real) (ha : 0 < a) :
    0 < Real.exp (-a * norm z) ∧ Real.exp (-a * norm z) < 1 := by
  constructor
  · exact Real.exp_pos _
  · rw [Real.exp_lt_one_iff]
    nlinarith [mul_pos ha (norm_pos_iff.mpr hz)]

/-- The negative branch expands under the same positive Euclidean step. This
is the finite control showing why positive-energy selection cannot be omitted. -/
theorem negativeRestFactor_gt_one (z : Complex) (hz : z ≠ 0)
    (a : Real) (ha : 0 < a) :
    1 < Real.exp (a * norm z) := by
  rw [Real.one_lt_exp_iff]
  exact mul_pos ha (norm_pos_iff.mpr hz)

/-- Complete finite chain from a noncollinear spinor pair to a visible positive
transfer mode. The determinant identity, decay rate, reconstructed energy, and
pole weight are all controlled by the same wedge `z = psi wedge phi`. -/
theorem pluecker_positive_mode_chain
    (psi phi : Two -> Complex) (hz : wedge psi phi ≠ 0)
    (a : Real) (ha : 0 < a) :
    (P psi phi).det = (Complex.normSq (wedge psi phi) : Complex) ∧
      (∀ n : Nat,
        (transfer a (Bz (wedge psi phi)) ^ n) *ᵥ
            positiveRestVector (wedge psi phi) =
          (Real.exp (-a * norm (wedge psi phi) * n) : Complex) •
            positiveRestVector (wedge psi phi)) ∧
      -(Real.log (Real.exp (-a * norm (wedge psi phi)))) / a =
        norm (wedge psi phi) ∧
      0 < Real.exp (-a * norm (wedge psi phi)) ∧
      Real.exp (-a * norm (wedge psi phi)) < 1 ∧
      0 < vecNormSq (positiveRestVector (wedge psi phi)) ∧
      (∀ s : Real, s ≠ (Real.exp (-a * norm (wedge psi phi)))⁻¹ ->
        (1 - s * Real.exp (-a * norm (wedge psi phi))) *
            modeResolvent (Real.exp (-a * norm (wedge psi phi)))
              (vecNormSq (positiveRestVector (wedge psi phi))) s =
          vecNormSq (positiveRestVector (wedge psi phi))) := by
  refine ⟨(Bz_sq psi phi).2, ?_⟩
  exact visible_mode_chain a (norm (wedge psi phi)) (Bz (wedge psi phi))
    (positiveRestVector (wedge psi phi)) ha (norm_pos_iff.mpr hz)
    (positiveRestVector_ne_zero _ hz) (positiveRestVector_eigen _)

/-- Nondegenerate rational-complex control: the wedge of the standard basis
is one, so the selected energy is exactly one and the discarded factor grows. -/
theorem standard_pair_control :
    wedge ![(1 : Complex), 0] ![0, (1 : Complex)] = 1 ∧
      norm (wedge ![(1 : Complex), 0] ![0, (1 : Complex)]) = 1 ∧
      1 < Real.exp
        (1 * norm (wedge ![(1 : Complex), 0] ![0, (1 : Complex)])) := by
  norm_num [wedge, Real.one_lt_exp_iff]

end PhysicsSM.Draft.NullEdge.PlueckerPositiveEnergyTransfer
