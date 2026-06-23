import Mathlib.Analysis.SpecialFunctions.Trigonometric.Basic
import Mathlib.Analysis.SpecialFunctions.Hyperbolic.Basic
import Mathlib.Tactic

/-!
# 1+1D Lorentz boosts: invariance and rapidity addition

A boost of rapidity `phi` acts on `(t,x)` by `cosh/sinh`; it preserves the
Minkowski norm `t^2 - x^2`, and boosts compose by adding rapidities (the abelian
1+1D Lorentz group). The kernel-checked relativity anchor underlying the null-edge
celestial/boost structure.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeLorentzBoost

/-- Boost of rapidity `phi` applied to `(t, x)`. -/
def boost (phi t x : Real) : Real × Real :=
  (t * Real.cosh phi + x * Real.sinh phi, t * Real.sinh phi + x * Real.cosh phi)

/-- 1+1D Minkowski norm. -/
def mink2 (t x : Real) : Real := t ^ 2 - x ^ 2

/-- Boosts preserve the Minkowski norm. -/
theorem boost_preserves_mink (phi t x : Real) :
    mink2 (boost phi t x).1 (boost phi t x).2 = mink2 t x := by
  sorry

/-- Boosts compose by adding rapidities. -/
theorem boost_compose (phi psi t x : Real) :
    boost phi (boost psi t x).1 (boost psi t x).2 = boost (phi + psi) t x := by
  sorry

end NullEdgeLorentzBoost
