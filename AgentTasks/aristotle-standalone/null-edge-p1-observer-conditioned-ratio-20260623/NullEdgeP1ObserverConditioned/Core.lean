import Mathlib.Tactic

noncomputable section

namespace NullEdgeP1ObserverConditioned

/-- Observer-conditioned determinant ratio for a unit timelike observer. -/
def observerConditionedDet (m Eu : Real) : Real :=
  m ^ 2 / (4 * Eu ^ 2)

/--
The observer-conditioned celestial determinant gives the mass/energy ratio.

This is the scalar algebra behind
`det rho_{p|u} = m^2 / (4 (p dot u)^2)`.
-/
theorem two_sqrt_observerConditionedDet_eq_mass_over_energy
    (m Eu : Real) (hm : 0 <= m) (hEu : 0 < Eu) :
    2 * Real.sqrt (observerConditionedDet m Eu) = m / Eu := by
  sorry

end NullEdgeP1ObserverConditioned
