import PhysicsSM.Draft.NullEdge.FourierPartialCorrespondence
import PhysicsSM.Draft.NullEdge.Compact3Plus1DiracRate

/-!
# Aristotle target: exact Schwartz-domain Fourier/Dirac composition

Prove the exact position-to-momentum correspondence for the free `3+1` Dirac
generator on a displayed Schwartz domain. Mathlib's forward Fourier transform
uses `exp (-2 * pi * I * <x,w>)`; consequently the position differential
operator carries the explicit normalization `-I / (2*pi)`.

This target is a generator-symbol theorem on Schwartz functions. It is not a
claim about the domain of the closed `L2` generator, changing-lattice
convergence, or a completed PDE reconstruction.
-/

noncomputable section

open MeasureTheory Complex Real Matrix
open FourierTransform
open scoped RealInnerProductSpace

namespace PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone

open ChangingCellFourierL2 ChangingCellScaledLiveWalk
open Compact3Plus1DiracRate FourierPartialCorrespondence

/-- The bounded spinor action of a fixed `4 x 4` complex matrix. -/
def matrixAction (A : Mat4) : Spinor →L[Complex] Spinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) A

/-- Coordinate derivative of a Schwartz spinor. -/
def coordinateDerivative (g : SchwartzMap FourierMomentum3 Spinor) (j : Fin 3)
    (x : FourierMomentum3) : Spinor :=
  fderiv Real (fun y => g y) x (EuclideanSpace.single j (1 : Real))

/-- Position-space free Dirac differential expression in Mathlib's Fourier
normalization. -/
def positionDirac (m : Real) (g : SchwartzMap FourierMomentum3 Spinor)
    (x : FourierMomentum3) : Spinor :=
  ((-Complex.I / (2 * (Real.pi : Complex))) •
      (matrixAction alpha1 (coordinateDerivative g 0 x) +
        matrixAction alpha2 (coordinateDerivative g 1 x) +
        matrixAction alpha3 (coordinateDerivative g 2 x))) +
    (m : Complex) • matrixAction beta (g x)

/-- Fourier transform commutes with a fixed bounded matrix action. -/
theorem fourier_matrixAction
    (A : Mat4) (f : FourierMomentum3 -> Spinor) (hf : Integrable f) :
    𝓕 (fun x => matrixAction A (f x)) =
      fun w => matrixAction A (𝓕 f w) := by
  sorry

/-- The displayed Dirac differential expression is integrable on every
Schwartz spinor. -/
theorem positionDirac_integrable
    (m : Real) (g : SchwartzMap FourierMomentum3 Spinor) :
    Integrable (positionDirac m g) := by
  sorry

/-- **Schwartz F2 capstone.** The normalized position-space Dirac differential
expression transforms exactly to the repository's free momentum symbol `H`.
All three derivative coordinates and the mass term are composed in one theorem. -/
theorem fourier_positionDirac
    (m : Real) (g : SchwartzMap FourierMomentum3 Spinor) :
    𝓕 (positionDirac m g) =
      fun w => matrixAction (H (w 0) (w 1) (w 2) m)
        (𝓕 (fun x => g x) w) := by
  sorry

/-- Zero-spinor boundary control. -/
theorem fourier_positionDirac_zero (m : Real) :
    𝓕 (positionDirac m (0 : SchwartzMap FourierMomentum3 Spinor)) =
      fun w => matrixAction (H (w 0) (w 1) (w 2) m)
        (𝓕 (fun x => (0 : SchwartzMap FourierMomentum3 Spinor) x) w) := by
  simpa using fourier_positionDirac m (0 : SchwartzMap FourierMomentum3 Spinor)

end PhysicsSM.Draft.NullEdge.FourierDiracSchwartzCapstone
