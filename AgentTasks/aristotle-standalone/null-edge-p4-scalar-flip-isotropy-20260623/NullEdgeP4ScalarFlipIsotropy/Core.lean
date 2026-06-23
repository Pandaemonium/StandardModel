import Mathlib

/-!
# P4 scalar flip from Pauli isotropy

This package formalizes the finite algebra behind the statement that the Dirac
mass is the scalar part of the off-diagonal chirality-flip block. A Pauli-vector
component in the flip generator is not isotropic; it is a vector coupling.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace NullEdgeP4ScalarFlipIsotropy

abbrev CMat2 := Matrix (Fin 2) (Fin 2) Complex

def sigmaX : CMat2 :=
  !![(0 : Complex), 1; 1, 0]

def sigmaY : CMat2 :=
  !![(0 : Complex), -I; I, 0]

def sigmaZ : CMat2 :=
  !![(1 : Complex), 0; 0, -1]

def flipGenerator (mu vx vy vz : Complex) : CMat2 :=
  mu • (1 : CMat2) + vx • sigmaX + vy • sigmaY + vz • sigmaZ

def CommutesWithAllPauli (Phi : CMat2) : Prop :=
  sigmaX * Phi = Phi * sigmaX /\
  sigmaY * Phi = Phi * sigmaY /\
  sigmaZ * Phi = Phi * sigmaZ

theorem isotropicFlip_iff_scalar
    (mu vx vy vz : Complex)
    (h : CommutesWithAllPauli (flipGenerator mu vx vy vz)) :
    vx = 0 /\ vy = 0 /\ vz = 0 := by
  sorry

theorem scalarFlip_commutes_all
    (mu : Complex) :
    CommutesWithAllPauli (flipGenerator mu 0 0 0) := by
  sorry

end NullEdgeP4ScalarFlipIsotropy
