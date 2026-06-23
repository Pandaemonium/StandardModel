import Mathlib

/-!
# P4 Pauli no-go for a `2 x 2` mass term

This focused package isolates the finite algebra behind the null-step Dirac
universality conjecture: a single Weyl spinor cannot carry a Dirac mass term.
If a `2 x 2` matrix anticommutes with all three Pauli matrices, it must vanish;
therefore an invertible Clifford mass matrix must live in a doubled
`L plus R` space.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace NullEdgeP4PauliNo2x2Mass

abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

def sigmaX : CMat2 :=
  !![(0 : Complex), 1; 1, 0]

def sigmaY : CMat2 :=
  !![(0 : Complex), -I; I, 0]

def sigmaZ : CMat2 :=
  !![(1 : Complex), 0; 0, -1]

def AnticommutesWithAllPauli (B : CMat2) : Prop :=
  sigmaX * B + B * sigmaX = 0 /\
  sigmaY * B + B * sigmaY = 0 /\
  sigmaZ * B + B * sigmaZ = 0

theorem no_2x2_anticommutant_of_all_pauli
    (B : CMat2) (hB : AnticommutesWithAllPauli B) :
    B = 0 := by
  sorry

theorem mass_term_forces_LR_doubling
    (B : CMat2) (hB : AnticommutesWithAllPauli B) :
    Not (B * B = 1) := by
  sorry

end NullEdgeP4PauliNo2x2Mass
