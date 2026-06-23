import Mathlib.Tactic

/-!
# P9 mass-source additivity under fan combination

Working at the level of total energy `E` and closure vector `C`, the visible
moment mass `mass E C = (E^2 - |C|^2)/4` combines under union of two fans as

```text
mass (E1+E2) (C1+C2) = mass E1 C1 + mass E2 C2 + (E1 E2 - <C1, C2>)/2,
```

so the mass source is additive exactly when `<C1, C2> = E1 E2` (the boundary of
the closure-vs-energy Cauchy-Schwarz regime). This is the finite source-additivity
law for the P9 diamond-source program.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeP9MassCombine

open BigOperators

abbrev Vec3 := Fin 3 -> Real

/-- Euclidean dot product on three-vectors. -/
def vdot (a b : Vec3) : Real := Finset.univ.sum fun k => a k * b k

/-- Squared Euclidean norm. -/
def normSq (a : Vec3) : Real := vdot a a

/-- Visible moment mass square from total energy and closure vector. -/
def mass (E : Real) (C : Vec3) : Real := (E ^ 2 - normSq C) / 4

/-- Mass combination identity for the union of two fans. -/
theorem mass_combine (E1 E2 : Real) (C1 C2 : Vec3) :
    mass (E1 + E2) (fun k => C1 k + C2 k)
      = mass E1 C1 + mass E2 C2 + (E1 * E2 - vdot C1 C2) / 2 := by
  sorry

/-- The mass source is additive exactly when the closure-energy cross term
vanishes. -/
theorem mass_additive_iff (E1 E2 : Real) (C1 C2 : Vec3) :
    mass (E1 + E2) (fun k => C1 k + C2 k) = mass E1 C1 + mass E2 C2
      ↔ vdot C1 C2 = E1 * E2 := by
  sorry

end NullEdgeP9MassCombine
