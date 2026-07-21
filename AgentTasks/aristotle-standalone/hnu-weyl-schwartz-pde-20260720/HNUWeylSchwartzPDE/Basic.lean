import Mathlib

/-!
# Exact two-component Weyl generator under Fourier transform

Focused Aristotle target for the HNU continuum endpoint. The theorem uses
Mathlib's forward Fourier convention, whose kernel contains `-2 * pi * I`.
Consequently the position-space derivative is normalized by
`-I / (2 * pi)`.

Do not weaken the target to a fixed momentum, a four-component Dirac field, or
an assumed Fourier-symbol identity. The point is to prove the exact
two-component Schwartz-domain correspondence used by the live HNU Weyl flow.
-/

noncomputable section

open MeasureTheory Complex Real Matrix
open FourierTransform
open scoped RealInnerProductSpace

namespace HNUWeylSchwartzPDE

abbrev Momentum3 := EuclideanSpace Real (Fin 3)
abbrev WeylSpinor := EuclideanSpace Complex (Fin 2)
abbrev Mat2 := Matrix (Fin 2) (Fin 2) Complex

def sigma1 : Mat2 := !![0, 1; 1, 0]
def sigma2 : Mat2 := !![0, -Complex.I; Complex.I, 0]
def sigma3 : Mat2 := !![1, 0; 0, -1]

def weylSymbol (q : Momentum3) : Mat2 :=
  (q 0 : Complex) • sigma1 +
    (q 1 : Complex) • sigma2 +
    (q 2 : Complex) • sigma3

def matrixAction (A : Mat2) : WeylSpinor →L[Complex] WeylSpinor :=
  Matrix.toEuclideanCLM (𝕜 := Complex) A

def coordinateDerivative (g : SchwartzMap Momentum3 WeylSpinor) (j : Fin 3)
    (x : Momentum3) : WeylSpinor :=
  fderiv Real (fun y => g y) x (EuclideanSpace.single j (1 : Real))

/-- The position-space Weyl differential expression in Mathlib's Fourier
normalization. -/
def positionWeyl (g : SchwartzMap Momentum3 WeylSpinor)
    (x : Momentum3) : WeylSpinor :=
  (-Complex.I / (2 * (Real.pi : Complex))) •
    (matrixAction sigma1 (coordinateDerivative g 0 x) +
      matrixAction sigma2 (coordinateDerivative g 1 x) +
      matrixAction sigma3 (coordinateDerivative g 2 x))

/-- The Fourier transform of a coordinate derivative has the exact positive
`2*pi*I*w_j` multiplier under Mathlib's convention. -/
theorem fourier_partial_correspondence
    (g : SchwartzMap Momentum3 WeylSpinor) (j : Fin 3) :
    (𝓕 fun x => coordinateDerivative g j x) =
      fun w =>
        (2 * (Real.pi : Complex) * Complex.I * (w j : Complex)) •
          𝓕 (fun x => g x) w := by
  sorry

/-- Fourier transform commutes with a fixed bounded `2 x 2` matrix action. -/
theorem fourier_matrixAction
    (A : Mat2) (f : Momentum3 -> WeylSpinor) (hf : Integrable f) :
    𝓕 (fun x => matrixAction A (f x)) =
      fun w => matrixAction A (𝓕 f w) := by
  sorry

/-- The displayed Weyl differential expression is integrable for every
Schwartz two-spinor. -/
theorem positionWeyl_integrable (g : SchwartzMap Momentum3 WeylSpinor) :
    Integrable (positionWeyl g) := by
  sorry

/-- Exact position-to-momentum Weyl generator identity. -/
theorem fourier_positionWeyl (g : SchwartzMap Momentum3 WeylSpinor) :
    𝓕 (positionWeyl g) =
      fun w => matrixAction (weylSymbol w)
        (𝓕 (fun x => g x) w) := by
  sorry

/-- The Weyl symbol is genuinely nonzero on a coordinate-axis momentum. -/
theorem weylSymbol_axis_nonzero :
    weylSymbol (EuclideanSpace.single (0 : Fin 3) (1 : Real)) ≠ 0 := by
  sorry

/-- Zero-state boundary control for the full Fourier/Weyl identity. -/
theorem fourier_positionWeyl_zero :
    𝓕 (positionWeyl (0 : SchwartzMap Momentum3 WeylSpinor)) =
      fun w => matrixAction (weylSymbol w)
        (𝓕 (fun x => (0 : SchwartzMap Momentum3 WeylSpinor) x) w) := by
  sorry

end HNUWeylSchwartzPDE
