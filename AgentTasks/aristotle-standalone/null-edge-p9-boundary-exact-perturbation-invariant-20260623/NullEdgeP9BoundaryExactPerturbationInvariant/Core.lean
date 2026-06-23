import Mathlib.Tactic

/-!
# P9 boundary-exact perturbations are invisible to closed tests

This package strengthens the boundary-exact result from "a boundary-exact source
has zero closed-test response" to "adding a boundary-exact perturbation does not
change closed-test mean response or response noise."
-/

noncomputable section

namespace NullEdgeP9BoundaryExactPerturbationInvariant

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

def addSource (s p : DiamondNoiseSource Cell Cfg) : DiamondNoiseSource Cell Cfg where
  source w c := s.source w c + p.source w c
  weight := s.weight

theorem boundaryExact_perturb_configResponse_eq
    (B : DiamondBoundary Cell Pot) (s p : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real) (hclosed : Closed B t) (hexact : BoundaryExact p B)
    (w : Cfg) :
    configResponse (addSource s p) t w = configResponse s t w := by
  sorry

theorem boundaryExact_perturb_meanResponse_eq
    (B : DiamondBoundary Cell Pot) (s p : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real) (hclosed : Closed B t) (hexact : BoundaryExact p B) :
    meanResponse (addSource s p) t = meanResponse s t := by
  sorry

theorem boundaryExact_perturb_responseNoise_eq
    (B : DiamondBoundary Cell Pot) (s p : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real) (hclosed : Closed B t) (hexact : BoundaryExact p B) :
    responseNoise (addSource s p) t = responseNoise s t := by
  sorry

end NullEdgeP9BoundaryExactPerturbationInvariant
