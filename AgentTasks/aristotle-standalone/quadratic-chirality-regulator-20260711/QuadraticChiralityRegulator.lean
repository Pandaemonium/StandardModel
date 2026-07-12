import Mathlib

/-!
# Quadratic chirality-mixing regulator

This focused target formalizes a concrete escape resource for a chirally split
three-dimensional Dirac tangent. The regulator is zero at the origin and has
zero Frechet derivative there, but is nonzero and chirality-odd away from the
origin. It is not a unitary walk, a no-doubling theorem, or a strict Laurent
construction.
-/

open Matrix

namespace QuadraticChiralityRegulator

abbrev V := Fin 3 -> Real
abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

noncomputable def q (k : V) : Real :=
  ∑ i, k i ^ 2

noncomputable def regulator (R : M4) (k : V) : M4 :=
  (q k : Complex) • R

def XiFixture : M4 :=
  !![1,0,0,0;0,1,0,0;0,0,-1,0;0,0,0,-1]

def RFixture : M4 :=
  !![0,0,1,0;0,0,0,1;1,0,0,0;0,1,0,0]

theorem q_zero : q 0 = 0 := by
  sorry

theorem q_single_one (j : Fin 3) : q (Pi.single j 1) = 1 := by
  sorry

/-- The regulator is invisible to the constant term of the Dirac tangent. -/
theorem regulator_zero (R : M4) : regulator R 0 = 0 := by
  sorry

/-- The regulator is invisible to the complete first jet at the origin. -/
theorem regulator_hasFDerivAt_zero (R : M4) :
    HasFDerivAt (𝕜 := Real) (regulator R) 0 0 := by
  sorry

/-- A one-axis unit fixture sees the regulator exactly, so the construction is
not the zero function. -/
theorem regulator_single_one (R : M4) (j : Fin 3) :
    regulator R (Pi.single j 1) = R := by
  sorry

theorem XiFixture_sq : XiFixture * XiFixture = 1 := by
  sorry

theorem fixture_anticommutes :
    XiFixture * RFixture = -(RFixture * XiFixture) := by
  sorry

theorem fixture_product_ne_zero : XiFixture * RFixture ≠ 0 := by
  sorry

/-- The exact higher-order escape fixture: no constant or linear change at the
origin, but genuine chirality mixing at a finite momentum. -/
theorem explicit_nonzero_chirality_mixing :
    XiFixture * regulator RFixture (Pi.single 0 1) ≠
      regulator RFixture (Pi.single 0 1) * XiFixture := by
  sorry

end QuadraticChiralityRegulator
