import Mathlib.Tactic

/-!
# P9 bilinear noise-response Cauchy-Schwarz

The quadratic response has an associated bilinear pairing. Under nonnegative
weights it should obey Cauchy-Schwarz, making the finite noise-response API a
positive-semidefinite observer bilinear form.
-/

noncomputable section

namespace NullEdgeP9NoiseBilinearCauchy

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

def noiseBilinear (s : DiamondNoiseSource Cell Cfg)
    (t u : Cell -> Real) : Real :=
  Finset.univ.sum fun c =>
    Finset.univ.sum fun d => t c * u d * noiseKernel s c d

def noiseResponse (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) : Real :=
  noiseBilinear s t t

theorem noiseBilinear_cauchy_schwarz
    (s : DiamondNoiseSource Cell Cfg) (t u : Cell -> Real)
    (hweight : forall w, 0 <= s.weight w) :
    noiseBilinear s t u ^ 2 <= noiseResponse s t * noiseResponse s u := by
  sorry

end NullEdgeP9NoiseBilinearCauchy
