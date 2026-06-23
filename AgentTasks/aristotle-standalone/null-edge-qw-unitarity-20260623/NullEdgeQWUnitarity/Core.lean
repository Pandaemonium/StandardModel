import Mathlib

/-!
# Null-step quantum-walk unitarity

The null-step walk uses closed-form Pauli rotations. This package asks for the
basic unitarity theorem cluster needed before treating the walk as a genuine
finite quantum evolution operator.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace NullEdgeQWUnitarity

abbrev CMat2 := Matrix (Fin 2) (Fin 2) ℂ

def IsUnitary2 (M : CMat2) : Prop :=
  M.conjTranspose * M = 1

def Rz (theta : ℝ) : CMat2 :=
  !![Complex.exp (-(theta : ℂ) * I), 0; 0, Complex.exp ((theta : ℂ) * I)]

def Rx (theta : ℝ) : CMat2 :=
  !![Complex.cos (theta : ℂ), -(I * Complex.sin (theta : ℂ));
     -(I * Complex.sin (theta : ℂ)), Complex.cos (theta : ℂ)]

def Ua (a k mu : ℝ) : CMat2 :=
  Rz (k * a) * Rx (mu * a)

theorem Rz_unitary (theta : ℝ) :
    IsUnitary2 (Rz theta) := by
  sorry

theorem Rx_unitary (theta : ℝ) :
    IsUnitary2 (Rx theta) := by
  sorry

theorem Ua_unitary (a k mu : ℝ) :
    IsUnitary2 (Ua a k mu) := by
  sorry

end NullEdgeQWUnitarity
