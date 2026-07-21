import PhysicsSM.Draft.NullEdge.HNUMassiveMaximalMultiplier
import PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator

/-!
# The live massive HNU position-space Hamiltonian

This module specializes the exact Fourier-conjugation infrastructure to the
maximal massive HNU/Pluecker momentum multiplier.  The result is a concrete
self-adjoint closed position-space operator on the exact inverse-Fourier graph
domain, with an exact graph-norm identity.

The operator is defined by unitary conjugation.  This module does not yet prove
that its maximal graph domain equals vector-valued `H1`, nor that its action on
that domain agrees pointwise with a classical differential expression.
-/

noncomputable section

open Complex MeasureTheory
open scoped FourierTransform

set_option autoImplicit false

namespace PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian

open HNUMassiveMaximalMultiplier
open HNUFourierPositionOperator

/-- The live massive HNU position operator, defined by inverse-Fourier unitary
conjugation of the self-adjoint maximal momentum multiplier. -/
def massivePositionHamiltonian (z : Complex) : MomentumL2 →ₗ.[Complex] MomentumL2 :=
  positionDirac (massiveHamiltonian z)

/-- Exact pulled-back maximal domain of the live position operator. -/
theorem massivePositionHamiltonian_domain (z : Complex) :
    (massivePositionHamiltonian z).domain =
      (massiveHamiltonian z).domain.comap
        (Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).toLinearEquiv.toLinearMap := rfl

/-- The live massive HNU position operator is self-adjoint. -/
theorem massivePositionHamiltonian_isSelfAdjoint (z : Complex) :
    IsSelfAdjoint (massivePositionHamiltonian z) :=
  positionDirac_isSelfAdjoint (massiveHamiltonian z)
    (massiveHamiltonian_isSelfAdjoint z)

/-- The live massive HNU position operator is closed. -/
theorem massivePositionHamiltonian_isClosed (z : Complex) :
    (massivePositionHamiltonian z).IsClosed :=
  (massivePositionHamiltonian_isSelfAdjoint z).isClosed

/-- Fourier conjugation preserves both terms of the live graph norm exactly. -/
theorem massivePositionHamiltonian_graph_norm_exact (z : Complex)
    (u : (massivePositionHamiltonian z).domain) :
    ‖(u : MomentumL2)‖ ^ 2 + ‖massivePositionHamiltonian z u‖ ^ 2 =
      ‖𝓕 (u : MomentumL2)‖ ^ 2 +
        ‖massiveHamiltonian z
          ⟨𝓕 (u : MomentumL2), u.property⟩‖ ^ 2 :=
  positionDirac_graph_norm_exact (massiveHamiltonian z) u

end PhysicsSM.Draft.NullEdge.HNUMassivePositionHamiltonian
