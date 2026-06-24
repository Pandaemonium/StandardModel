import Mathlib.Tactic

/-!
# P9 diamond screen visibility core

This standalone file isolates the finite source-visibility algebra behind the
P9 cosmological-constant branch.

Physics context: a local vacuum-bookkeeping source should be invisible to
closed curvature-defect tests when it is boundary-exact. A genuine surviving
cosmological residual should therefore live in a visible source sector or in a
harmonic/global quotient, not in the exact local bookkeeping sector.
-/

namespace NullEdgeP9DiamondScreenVisibility.Core

open BigOperators

/-- A finite screen complex with a face-to-rim incidence map. -/
structure DiamondScreen where
  nFace : Nat
  nRim : Nat
  rimInc : Fin nFace -> Fin nRim -> Real

namespace DiamondScreen

abbrev FaceCochain (S : DiamondScreen) := Fin S.nFace -> Real
abbrev RimCochain (S : DiamondScreen) := Fin S.nRim -> Real

/-- Positive face weights used by the observer/channel pairing. -/
structure Measure (S : DiamondScreen) where
  faceArea : Fin S.nFace -> Real
  faceArea_pos : forall f, 0 < faceArea f

/-- Measure-weighted source/test pairing on screen faces. -/
noncomputable def pairing {S : DiamondScreen} (mu : S.Measure)
    (source test : S.FaceCochain) : Real :=
  Finset.univ.sum fun f => mu.faceArea f * source f * test f

/-- Boundary-exact face source: the weighted adjoint image of a rim cochain. -/
noncomputable def exactSource {S : DiamondScreen} (_mu : S.Measure)
    (a : S.RimCochain) : S.FaceCochain :=
  fun f => Finset.univ.sum fun r => S.rimInc f r * a r

/-- Closed curvature-defect test: it annihilates all exact screen sources. -/
def ClosedTest {S : DiamondScreen} (mu : S.Measure)
    (test : S.FaceCochain) : Prop :=
  forall r : Fin S.nRim,
    (Finset.univ.sum fun f => mu.faceArea f * S.rimInc f r * test f) = 0

/-- Exact local bookkeeping is invisible to every closed curvature-defect test. -/
theorem exactSource_pairing_closedTest_zero {S : DiamondScreen} (mu : S.Measure)
    (a : S.RimCochain) (test : S.FaceCochain) (hclosed : ClosedTest mu test) :
    pairing mu (exactSource mu a) test = 0 := by
  sorry

/-- Rank-one covariance response of an exact source vanishes on closed tests. -/
theorem exactSource_rankOne_noise_closedTest_zero {S : DiamondScreen} (mu : S.Measure)
    (a : S.RimCochain) (test : S.FaceCochain) (hclosed : ClosedTest mu test) :
    (pairing mu (exactSource mu a) test) ^ 2 = 0 := by
  sorry

/--
If all exact sources are invisible to closed tests, any source with a nonzero
closed-test response cannot be exact. This is the finite harmonic/global
survival gate: exact filtering does not remove visible quotient modes.
-/
theorem nonzero_closed_response_not_exact {S : DiamondScreen} (mu : S.Measure)
    (source : S.FaceCochain) (test : S.FaceCochain) (hclosed : ClosedTest mu test)
    (hvis : Not (pairing mu source test = 0)) :
    (exists a : S.RimCochain, source = exactSource mu a) -> False := by
  sorry

end DiamondScreen

end NullEdgeP9DiamondScreenVisibility.Core
