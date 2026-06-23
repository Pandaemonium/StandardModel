import Mathlib.Tactic

noncomputable section

namespace NullEdgeP1CelestialMoment

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
  sorry

end NullEdgeP1CelestialMoment
