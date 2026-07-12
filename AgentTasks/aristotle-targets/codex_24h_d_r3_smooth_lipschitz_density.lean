import PhysicsSM.Draft.NullEdge.ChangingMomentumCellSampling
import Mathlib.Analysis.Normed.Lp.SmoothApprox

/-!
# D-R3 successor: arbitrary-L2 smooth Lipschitz density bridge

Close the analytic hinge between the landed compact-support Lipschitz sampler
and arbitrary complex `L2(R^3)` momentum data.  Preserve every theorem
statement.  Do not weaken global Lipschitz continuity to a local statement,
and do not drop the noncompact quadratic boundary control.

The first theorem is a project-facing specialization of Mathlib's continuous
compact-support density theorem.  The second theorem is the load-bearing
finite-dimensional fact: a compactly supported smooth function is globally
Lipschitz.  The final two declarations show that compact support is not a
decorative hypothesis.
-/

noncomputable section

open scoped ENNReal
open MeasureTheory Set

namespace PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density

open ChangingMomentumCellIsometry

/-- Every complex `L2(R^3)` field admits a continuous compactly supported
approximation with arbitrarily small squared error. -/
theorem memLp_exists_continuous_compact_sq_approx
    {f : Momentum3 -> Complex} (hf : MemLp f 2 volume)
    {ε : Real} (hε : 0 < ε) :
    ∃ g : Momentum3 -> Complex,
      HasCompactSupport g ∧
      (∫ x, ‖f x - g x‖ ^ (2 : Real) ∂volume) ≤ ε ∧
      Continuous g ∧ MemLp g 2 volume := by
  sorry

/-- In finite-dimensional momentum space, smoothness plus compact support
supplies the global Lipschitz constant required by the cell sampler. -/
theorem compactSupport_contDiff_exists_global_lipschitz
    {g : Momentum3 -> Complex} (hgK : HasCompactSupport g)
    (hgD : ContDiff Real ⊤ g) :
    ∃ L : Real, 0 ≤ L ∧
      ∀ x y, ‖g x - g y‖ ≤ L * ‖x - y‖ := by
  sorry

/-- Boundary-control function: a smooth quadratic without compact support. -/
def quadraticAxis (x : Momentum3) : Complex :=
  (x 0 : Complex) ^ 2

theorem quadraticAxis_contDiff : ContDiff Real ⊤ quadraticAxis := by
  sorry

/-- Compact support is load-bearing: the smooth quadratic has no global
Lipschitz constant. -/
theorem quadraticAxis_not_global_lipschitz :
    ¬ ∃ L : Real, 0 ≤ L ∧
      ∀ x y, ‖quadraticAxis x - quadraticAxis y‖ ≤ L * ‖x - y‖ := by
  sorry

end PhysicsSM.Draft.NullEdge.ChangingMomentumL2Density
