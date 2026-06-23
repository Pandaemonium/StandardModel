import Mathlib

/-!
# P4 scalar flip from Pauli isotropy

This draft module formalizes the finite algebra behind the statement that the
Dirac mass is the scalar part of the off-diagonal chirality-flip block. A
Pauli-vector component in the flip generator is not isotropic; it is a vector
coupling.

Proven by Aristotle project `b6f7bbc8-2376-461d-98aa-253cda38ed21` on
2026-06-23 from the focused package
`null-edge-p4-scalar-flip-isotropy-20260623`.
-/

open Complex Matrix
open scoped Matrix

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy

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

/--
Scalar plus Pauli-vector chirality-flip block. The scalar coefficient is the
candidate mass; the vector coefficients are anisotropic couplings.
-/
def flipGenerator (mu vx vy vz : Complex) : CMat2 :=
  mu • (1 : CMat2) + vx • sigmaX + vy • sigmaY + vz • sigmaZ

/-- Isotropy proxy: the flip block commutes with all Pauli directions. -/
def CommutesWithAllPauli (Phi : CMat2) : Prop :=
  sigmaX * Phi = Phi * sigmaX /\
  sigmaY * Phi = Phi * sigmaY /\
  sigmaZ * Phi = Phi * sigmaZ

/-- A Pauli-isotropic flip generator has no vector part. -/
theorem isotropicFlip_iff_scalar
    (mu vx vy vz : Complex)
    (h : CommutesWithAllPauli (flipGenerator mu vx vy vz)) :
    vx = 0 /\ vy = 0 /\ vz = 0 := by
  unfold flipGenerator at h
  unfold CommutesWithAllPauli at h
  norm_num [← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply] at h
  simp +decide [sigmaX, sigmaY, sigmaZ] at *
  ring_nf at *
  grind +suggestions

/-- The pure scalar flip generator commutes with all Pauli directions. -/
theorem scalarFlip_commutes_all
    (mu : Complex) :
    CommutesWithAllPauli (flipGenerator mu 0 0 0) := by
  unfold CommutesWithAllPauli flipGenerator
  simp +decide

end PhysicsSM.Draft.NullEdgeP4ScalarFlipIsotropy
