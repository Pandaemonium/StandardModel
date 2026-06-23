import Mathlib.Tactic

/-!
# P9 noise kernel determined by observer tests

If all observer test functions have zero quadratic noise response, then the
finite noise kernel is zero entrywise. This is the finite linear-algebra
counterpart of the stochastic-gravity guardrail: source invisibility must kill
the noise response, not merely the mean.
-/

noncomputable section

namespace NullEdgeP9NoiseKernelDeterminedByTests

open BigOperators

structure DiamondNoiseSource (Cell Cfg : Type) [Fintype Cell] [Fintype Cfg] where
  source : Cfg -> Cell -> Real
  weight : Cfg -> Real

variable {Cell Cfg : Type}
variable [Fintype Cell] [Fintype Cfg]

def meanSource (s : DiamondNoiseSource Cell Cfg) (c : Cell) : Real :=
  Finset.univ.sum fun w => s.weight w * s.source w c

def noiseKernel (s : DiamondNoiseSource Cell Cfg) (c d : Cell) : Real :=
  Finset.univ.sum fun w =>
    s.weight w * (s.source w c - meanSource s c) *
      (s.source w d - meanSource s d)

def noiseResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  Finset.univ.sum fun c =>
    Finset.univ.sum fun d => t c * t d * noiseKernel s c d

def deltaTest (c0 : Cell) : Cell -> Real := by
  classical
  exact fun c => if c = c0 then 1 else 0

def pairTest (c d : Cell) : Cell -> Real := by
  classical
  exact fun x => if x = c then 1 else if x = d then 1 else 0

theorem noiseKernel_symm (s : DiamondNoiseSource Cell Cfg) (c d : Cell) :
    noiseKernel s c d = noiseKernel s d c := by
  sorry

theorem noiseResponse_deltaTest_eq_noiseKernel_self
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell) :
    noiseResponse s (deltaTest c0) = noiseKernel s c0 c0 := by
  sorry

theorem noiseResponse_pairTest_eq_diag_diag_cross
    (s : DiamondNoiseSource Cell Cfg) (c d : Cell) (hcd : c ≠ d) :
    noiseResponse s (pairTest c d)
      =
    noiseKernel s c c + noiseKernel s d d + 2 * noiseKernel s c d := by
  sorry

theorem noiseKernel_eq_zero_of_all_noiseResponses_zero
    (s : DiamondNoiseSource Cell Cfg)
    (h : forall t : Cell -> Real, noiseResponse s t = 0) :
    forall c d : Cell, noiseKernel s c d = 0 := by
  sorry

end NullEdgeP9NoiseKernelDeterminedByTests
