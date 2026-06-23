import Mathlib.Tactic

/-!
# P9 noise-kernel Cauchy-Schwarz target

Finite covariance/noise kernels with nonnegative weights should be positive
semidefinite. This target asks for the Cauchy-Schwarz inequality for the
finite noise kernel, a key stochastic-gravity guardrail.
-/

noncomputable section

namespace NullEdgeP9NoiseCauchySchwarz

open BigOperators

def weightedDot {Cfg : Type} [Fintype Cfg]
    (weight : Cfg -> Real) (x y : Cfg -> Real) : Real :=
  Finset.univ.sum fun w => weight w * x w * y w

theorem weightedDot_cauchy_schwarz {Cfg : Type} [Fintype Cfg]
    (weight : Cfg -> Real) (x y : Cfg -> Real)
    (hweight : forall w, 0 <= weight w) :
    weightedDot weight x y ^ 2 <=
      weightedDot weight x x * weightedDot weight y y := by
  sorry

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

theorem noiseKernel_cauchy_schwarz
    (s : DiamondNoiseSource Cell Cfg) (c d : Cell)
    (hweight : forall w, 0 <= s.weight w) :
    noiseKernel s c d ^ 2 <= noiseKernel s c c * noiseKernel s d d := by
  sorry

end NullEdgeP9NoiseCauchySchwarz
