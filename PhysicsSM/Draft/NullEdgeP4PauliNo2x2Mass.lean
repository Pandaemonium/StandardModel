import Mathlib

/-!
# P4 Pauli no-go for a `2 x 2` mass term

This draft module isolates the finite algebra behind the null-step Dirac
universality conjecture: a single Weyl spinor cannot carry a Dirac mass term.
If a `2 x 2` matrix anticommutes with all three Pauli matrices, it must vanish;
therefore an invertible Clifford mass matrix must live in a doubled
`L plus R` space.

Proven by Aristotle project `a3346e59-dd7a-4760-a761-31a048aa19a6` on
2026-06-23 from the focused package `null-edge-p4-pauli-no-2x2-mass-20260623`.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass

abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

/-- First Pauli matrix. -/
def sigmaX : CMat2 :=
  !![(0 : Complex), 1; 1, 0]

/-- Second Pauli matrix. -/
def sigmaY : CMat2 :=
  !![(0 : Complex), -I; I, 0]

/-- Third Pauli matrix. -/
def sigmaZ : CMat2 :=
  !![(1 : Complex), 0; 0, -1]

/-- A candidate single-Weyl mass matrix anticommutes with every Pauli matrix. -/
def AnticommutesWithAllPauli (B : CMat2) : Prop :=
  sigmaX * B + B * sigmaX = 0 /\
  sigmaY * B + B * sigmaY = 0 /\
  sigmaZ * B + B * sigmaZ = 0

/-- A `2 x 2` complex matrix anticommuting with all Pauli matrices is zero. -/
theorem no_2x2_anticommutant_of_all_pauli
    (B : CMat2) (hB : AnticommutesWithAllPauli B) :
    B = 0 := by
  simp_all +decide [AnticommutesWithAllPauli]
  simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_two, sigmaX, sigmaY, sigmaZ]
  norm_num [Matrix.vecMul, Matrix.mul_apply] at *
  norm_num [Complex.ext_iff] at *
  exact ⟨⟨⟨by linarith!, by linarith!⟩, ⟨by linarith!, by linarith!⟩⟩,
    ⟨⟨by linarith!, by linarith!⟩, ⟨by linarith!, by linarith!⟩⟩⟩

/--
Consequently an invertible Clifford mass matrix cannot be a single `2 x 2`
matrix anticommuting with the Pauli matrices.
-/
theorem mass_term_forces_LR_doubling
    (B : CMat2) (hB : AnticommutesWithAllPauli B) :
    Not (B * B = 1) := by
  exact fun h => by
    have := no_2x2_anticommutant_of_all_pauli B hB
    simp_all +decide

end PhysicsSM.Draft.NullEdgeP4PauliNo2x2Mass
