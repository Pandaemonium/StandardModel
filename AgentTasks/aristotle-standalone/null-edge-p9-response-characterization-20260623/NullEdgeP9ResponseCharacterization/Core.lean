import Mathlib.Tactic

/-!
# P9 response characterization

Finite theorem targets for making P9 source invisibility observable-relative:
mean and noise invisibility should be characterized by vanishing responses
against a spanning family of finite observer tests.
-/

noncomputable section

namespace NullEdgeP9ResponseCharacterization

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

def meanResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  Finset.univ.sum fun c => t c * meanSource s c

def noiseResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  Finset.univ.sum fun c =>
    Finset.univ.sum fun d => t c * t d * noiseKernel s c d

def MeanInvisible (s : DiamondNoiseSource Cell Cfg) : Prop :=
  forall c, meanSource s c = 0

def NoiseInvisible (s : DiamondNoiseSource Cell Cfg) : Prop :=
  forall c d, noiseKernel s c d = 0

def GravInvisible (s : DiamondNoiseSource Cell Cfg) : Prop :=
  MeanInvisible s ∧ NoiseInvisible s

def deltaTest (c0 : Cell) : Cell -> Real := by
  classical
  exact fun c => if c = c0 then 1 else 0

def pairTest (c d : Cell) : Cell -> Real := by
  classical
  exact fun x => if x = c then 1 else if x = d then 1 else 0

theorem meanResponse_deltaTest_eq_meanSource
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell) :
    meanResponse s (deltaTest c0) = meanSource s c0 := by
  sorry

theorem meanInvisible_iff_all_meanResponses_zero
    (s : DiamondNoiseSource Cell Cfg) :
    MeanInvisible s ↔ forall t : Cell -> Real, meanResponse s t = 0 := by
  sorry

theorem noiseKernel_symm (s : DiamondNoiseSource Cell Cfg) (c d : Cell) :
    noiseKernel s c d = noiseKernel s d c := by
  sorry

theorem noiseResponse_deltaTest_eq_noiseKernel_self
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell) :
    noiseResponse s (deltaTest c0) = noiseKernel s c0 c0 := by
  sorry

theorem noiseResponse_pairTest_eq_diag_diag_cross
    (s : DiamondNoiseSource Cell Cfg) (c d : Cell) (hcd : c ≠ d) :
    noiseResponse s (pairTest c d) =
      noiseKernel s c c + noiseKernel s d d + 2 * noiseKernel s c d := by
  sorry

theorem noiseInvisible_iff_all_noiseResponses_zero
    (s : DiamondNoiseSource Cell Cfg) :
    NoiseInvisible s ↔ forall t : Cell -> Real, noiseResponse s t = 0 := by
  sorry

theorem gravInvisible_iff_all_responses_zero
    (s : DiamondNoiseSource Cell Cfg) :
    GravInvisible s ↔
      (forall t : Cell -> Real, meanResponse s t = 0) ∧
        (forall t : Cell -> Real, noiseResponse s t = 0) := by
  sorry

end NullEdgeP9ResponseCharacterization
