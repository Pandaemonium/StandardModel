import Mathlib.Tactic

/-!
# P1 celestial moment determinant

This module packages the scalar identity behind the celestial-moment rewrite of
the Pluecker mass theorem. The determinant of the observer-normalized Bloch
momentum block is the deficit between the energy monopole and the spatial
dipole.

Physics boundary: this is observer-normalized scalar algebra. It supports the
statement that mass is missing celestial l=1 coherence, but it is not by itself
a dynamical theorem.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1CelestialMoment

/--
Determinant of the observer-normalized `2 x 2` Bloch momentum block with
monopole `E` and dipole components `(px, py, pz)`.
-/
def blochDet (E px py pz : Real) : Real :=
  ((E + pz) / 2) * ((E - pz) / 2) - (px / 2) ^ 2 - (py / 2) ^ 2

/--
The celestial determinant is the monopole-square minus dipole-square deficit.

This is the scalar algebra behind the P1 statement that mass is missing
celestial l=1 coherence.
-/
theorem four_blochDet_eq_monopole_sq_sub_dipole_sq
    (E px py pz : Real) :
    4 * blochDet E px py pz = E ^ 2 - (px ^ 2 + py ^ 2 + pz ^ 2) := by
  unfold blochDet
  ring

end PhysicsSM.Draft.NullEdgeP1CelestialMoment
