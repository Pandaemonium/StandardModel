import Mathlib.Tactic

/-!
# P9 gravitational invisibility API

This package names the distinction forced by the stochastic-gravity guardrail:
mean-source invisibility is not enough. For a finite diamond test, gravitational
invisibility requires both mean response and response-noise invisibility.
-/

noncomputable section

namespace NullEdgeP9GravInvisibleAPI

open BigOperators

structure DiamondNoiseSource (Cell Cfg : Type) [Fintype Cell] [Fintype Cfg] where
  source : Cfg -> Cell -> Real
  weight : Cfg -> Real

structure DiamondBoundary (Cell Pot : Type) where
  bdry : Pot -> Cell -> Real

variable {Cell Cfg Pot : Type}
variable [Fintype Cell] [Fintype Cfg]

def configResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) (w : Cfg) : Real :=
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
  Exists fun p : Cfg -> Pot =>
    forall w c, s.source w c = B.bdry (p w) c

def MeanInvisible (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Prop :=
  meanResponse s t = 0

def NoiseInvisible (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Prop :=
  responseNoise s t = 0

def GravInvisible (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Prop :=
  MeanInvisible s t ∧ NoiseInvisible s t

theorem boundaryExact_configResponse_zero_of_closed
    (B : DiamondBoundary Cell Pot) (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real)
    (hclosed : Closed B t) (hexact : BoundaryExact s B) (w : Cfg) :
    configResponse s t w = 0 := by
  sorry

theorem boundaryExact_gravInvisible_of_closed
    (B : DiamondBoundary Cell Pot) (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real)
    (hclosed : Closed B t) (hexact : BoundaryExact s B) :
    GravInvisible s t := by
  sorry

end NullEdgeP9GravInvisibleAPI
