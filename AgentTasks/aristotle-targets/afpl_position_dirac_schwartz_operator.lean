import PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone
import PhysicsSM.Draft.NullEdge.ExactFlowSchwartzGroup

/-!
# Position-space Dirac generator as a continuous Schwartz operator

Focused Aristotle target, continuum rung T2-A.  The landed Fourier/Dirac
capstone identifies a raw integrable differential expression with the affine
Dirac momentum symbol.  This successor packages that expression as an actual
continuous linear endomorphism of four-component Schwartz space and upgrades
the symbol theorem to the packaged operator.

This is still a fixed-continuum Schwartz-domain result.  It does not yet prove
that the exact time group is differentiable in the Schwartz topology, identify
the closed `L2` generator, or establish the changing-lattice limit.
-/

noncomputable section

open Complex Matrix
open FourierTransform LineDeriv
open scoped RealInnerProductSpace SchwartzMap

namespace PhysicsSM.Draft.NullEdge.PositionDiracSchwartzOperator

open ChangingCellFourierL2 ChangingCellScaledLiveWalk
open Compact3Plus1DiracRate
open FourierDiracSchwartzCapstone ExactFlowSchwartzGroup

/-- Constant matrix action lifted continuously to Schwartz spinors. -/
def matrixActionSchwartzCLM (A : Mat4) :
    SpinorSchwartz →L[Complex] SpinorSchwartz :=
  SchwartzMap.bilinLeftCLM
    (ContinuousLinearMap.apply Complex Spinor)
    (Function.HasTemperateGrowth.const (matrixAction A))

/-- The `j`th unit direction in momentum/position coordinate space. -/
def basisDirection (j : Fin 3) : FourierMomentum3 :=
  EuclideanSpace.single j (1 : Real)

/-- The free position-space Dirac differential expression as a continuous
linear endomorphism of Schwartz spinors, retaining Mathlib's explicit
`-I / (2*pi)` normalization. -/
def positionDiracSchwartzCLM (m : Real) :
    SpinorSchwartz →L[Complex] SpinorSchwartz :=
  ((-Complex.I / (2 * (Real.pi : Complex))) •
      ((matrixActionSchwartzCLM alpha1).comp
          (lineDerivOpCLM Complex SpinorSchwartz (basisDirection 0)) +
        (matrixActionSchwartzCLM alpha2).comp
          (lineDerivOpCLM Complex SpinorSchwartz (basisDirection 1)) +
        (matrixActionSchwartzCLM alpha3).comp
          (lineDerivOpCLM Complex SpinorSchwartz (basisDirection 2)))) +
    (m : Complex) • matrixActionSchwartzCLM beta

/-- The packaged operator evaluates to the already audited raw differential
expression at every point. -/
theorem positionDiracSchwartzCLM_apply (m : Real)
    (g : SpinorSchwartz) (x : FourierMomentum3) :
    positionDiracSchwartzCLM m g x = positionDirac m g x := by
  sorry

/-- **Packaged Schwartz symbol theorem.** Fourier transform conjugates the
continuous position Dirac operator to the exact affine matrix symbol. -/
theorem fourier_positionDiracSchwartzCLM (m : Real) (g : SpinorSchwartz) :
    forall w : FourierMomentum3,
      (SchwartzMap.fourierTransformCLM Complex (positionDiracSchwartzCLM m g)) w =
        matrixAction (H (w 0) (w 1) (w 2) m)
          ((SchwartzMap.fourierTransformCLM Complex g) w) := by
  sorry

/-! ## Boundary control -/

/-- The packaged differential operator sends the zero Schwartz spinor to
zero. -/
theorem positionDiracSchwartzCLM_zero (m : Real) :
    positionDiracSchwartzCLM m (0 : SpinorSchwartz) = 0 := by
  sorry

end PhysicsSM.Draft.NullEdge.PositionDiracSchwartzOperator
