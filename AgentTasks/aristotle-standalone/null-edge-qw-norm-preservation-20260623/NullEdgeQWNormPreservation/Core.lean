import Mathlib

/-!
# Null-step QW norm preservation

The unitarity theorem should imply concrete norm preservation for the
two-component spinor state used by the null-step quantum walk.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace NullEdgeQWNormPreservation

abbrev CMat2 := Matrix (Fin 2) (Fin 2) ℂ
abbrev CVec2 := Fin 2 -> ℂ

def normSq (v : CVec2) : Real :=
  ‖v 0‖ ^ 2 + ‖v 1‖ ^ 2

def Rz (theta : ℝ) : CMat2 :=
  !![Complex.exp (-(theta : ℂ) * I), 0; 0, Complex.exp ((theta : ℂ) * I)]

def Rx (theta : ℝ) : CMat2 :=
  !![Complex.cos (theta : ℂ), -(I * Complex.sin (theta : ℂ));
     -(I * Complex.sin (theta : ℂ)), Complex.cos (theta : ℂ)]

def Ua (a k mu : ℝ) : CMat2 :=
  Rz (k * a) * Rx (mu * a)

theorem Rz_preserves_normSq (theta : ℝ) (v : CVec2) :
    normSq ((Rz theta).mulVec v) = normSq v := by
  sorry

theorem Rx_preserves_normSq (theta : ℝ) (v : CVec2) :
    normSq ((Rx theta).mulVec v) = normSq v := by
  sorry

theorem Ua_preserves_normSq (a k mu : ℝ) (v : CVec2) :
    normSq ((Ua a k mu).mulVec v) = normSq v := by
  sorry

end NullEdgeQWNormPreservation
