import Mathlib.Tactic

/-!
# P9 delta/pair finite test basis

Delta tests and pair tests are enough to detect every entry of a finite
symmetric noise kernel. This gives a finite operational test basis for P9
noise invisibility.
-/

noncomputable section

namespace NullEdgeP9DeltaPairTestBasis

open BigOperators

structure DiamondNoiseSource (Cell Cfg : Type) [Fintype Cell] [Fintype Cfg] where
  source : Cfg -> Cell -> Real
  weight : Cfg -> Real

variable {Cell Cfg : Type}
variable [Fintype Cell] [Fintype Cfg]

def meanSource (s : DiamondNoiseSource Cell Cfg) (c : Cell) : Real :=
  Finset.univ.sum fun w => s.weight w * s.source w c

def centered (s : DiamondNoiseSource Cell Cfg) (w : Cfg) (c : Cell) : Real :=
  s.source w c - meanSource s c

def noiseKernel (s : DiamondNoiseSource Cell Cfg) (c d : Cell) : Real :=
  Finset.univ.sum fun w => s.weight w * centered s w c * centered s w d

def noiseResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  Finset.univ.sum fun c =>
    Finset.univ.sum fun d => t c * t d * noiseKernel s c d

def NoiseInvisible (s : DiamondNoiseSource Cell Cfg) : Prop :=
  forall c d, noiseKernel s c d = 0

def deltaTest (c0 : Cell) : Cell -> Real := by
  classical
  exact fun c => if c = c0 then 1 else 0

def pairTest (c d : Cell) : Cell -> Real := by
  classical
  exact fun x => if x = c then 1 else if x = d then 1 else 0

theorem noiseResponse_deltaTest_eq_noiseKernel_self
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell) :
    noiseResponse s (deltaTest c0) = noiseKernel s c0 c0 := by
  sorry

theorem noiseResponse_pairTest_eq_diag_diag_cross
    (s : DiamondNoiseSource Cell Cfg) (c d : Cell) (hcd : c ≠ d) :
    noiseResponse s (pairTest c d) =
      noiseKernel s c c + noiseKernel s d d + 2 * noiseKernel s c d := by
  sorry

theorem noiseInvisible_of_delta_pair_tests_zero
    (s : DiamondNoiseSource Cell Cfg)
    (hdelta : forall c, noiseResponse s (deltaTest c) = 0)
    (hpair : forall c d, c ≠ d -> noiseResponse s (pairTest c d) = 0) :
    NoiseInvisible s := by
  sorry

end NullEdgeP9DeltaPairTestBasis
