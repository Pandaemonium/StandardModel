import Mathlib.Tactic

/-!
# P9 per-configuration boundary exactness kills closed-test noise

Mean-boundary-exactness kills only the mean response. Per-configuration
boundary exactness is stronger: a closed test annihilates every realization, so
both mean and variance/noise response vanish.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9BoundaryExactNoiseInvisible

open BigOperators

structure DiamondNoiseSource (Cell Cfg : Type) [Fintype Cell] [Fintype Cfg] where
  source : Cfg -> Cell -> Real
  weight : Cfg -> Real

structure DiamondBoundary (Cell Pot : Type) where
  bdry : (Pot -> Real) -> Cell -> Real

variable {Cell Cfg Pot : Type}
variable [Fintype Cell] [Fintype Cfg] [Fintype Pot]

def configResponse (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real) (w : Cfg) : Real :=
  Finset.univ.sum fun c => t c * s.source w c

def meanResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  Finset.univ.sum fun w => s.weight w * configResponse s t w

def responseNoise (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  Finset.univ.sum fun w =>
    s.weight w * (configResponse s t w - meanResponse s t) ^ 2

def Closed (B : DiamondBoundary Cell Pot) (t : Cell -> Real) : Prop :=
  forall p, (Finset.univ.sum fun c => t c * B.bdry p c) = 0

def BoundaryExact (s : DiamondNoiseSource Cell Cfg)
    (B : DiamondBoundary Cell Pot) : Prop :=
  Exists fun p : Cfg -> Pot -> Real =>
    forall w c, s.source w c = B.bdry (p w) c

omit [Fintype Pot] in
theorem boundaryExact_configResponse_zero_of_closed
    (B : DiamondBoundary Cell Pot) (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real)
    (hclosed : Closed B t) (hexact : BoundaryExact s B) (w : Cfg) :
    configResponse s t w = 0 := by
  obtain ⟨ p, hp ⟩ := hexact;
  unfold configResponse;
  simpa [ hp ] using hclosed ( p w )

omit [Fintype Pot] in
theorem boundaryExact_meanResponse_zero_of_closed
    (B : DiamondBoundary Cell Pot) (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real)
    (hclosed : Closed B t) (hexact : BoundaryExact s B) :
    meanResponse s t = 0 := by
  refine Finset.sum_eq_zero fun w _ => mul_eq_zero_of_right _ ?_
  exact boundaryExact_configResponse_zero_of_closed B s t hclosed hexact w

omit [Fintype Pot] in
theorem boundaryExact_responseNoise_zero_of_closed
    (B : DiamondBoundary Cell Pot) (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real)
    (hclosed : Closed B t) (hexact : BoundaryExact s B) :
    responseNoise s t = 0 := by
  refine Finset.sum_eq_zero fun w _ => ?_
  rw [boundaryExact_configResponse_zero_of_closed B s t hclosed hexact w,
    boundaryExact_meanResponse_zero_of_closed B s t hclosed hexact]
  ring

end PhysicsSM.Draft.NullEdgeP9BoundaryExactNoiseInvisible
