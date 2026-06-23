import Mathlib.Tactic

/-!
# P1 observer-conditioned mass ratio

This module isolates the scalar algebra behind the observer-conditioned
celestial determinant:

```text
det(rho_{p|u}) = m^2 / (4 * E_u^2)
```

The invariant quantity is `m^2 = det(P)`. The normalized determinant here is
frame- or observer-conditioned; it records the mass-to-observer-energy ratio
`m / E_u`, not bare invariant mass.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1ObserverConditioned

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
  unfold observerConditionedDet
  rw [Real.sqrt_div (by positivity), Real.sqrt_sq hm,
    Real.sqrt_mul (by positivity), Real.sqrt_sq (by positivity)]
  ring

end PhysicsSM.Draft.NullEdgeP1ObserverConditioned
