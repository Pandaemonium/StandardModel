import Mathlib.Tactic

/-!
# P9 positive-weight noise-zero characterization

If all configuration weights are strictly positive, a zero self-noise entry
forces the corresponding centered source to vanish in every configuration. This
turns noise invisibility into a concrete finite source constraint.
-/

noncomputable section

namespace NullEdgeP9PositiveWeightNoiseZero

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

def NoiseInvisible (s : DiamondNoiseSource Cell Cfg) : Prop :=
  forall c d, noiseKernel s c d = 0

theorem weighted_square_sum_eq_zero_iff {Cfg : Type} [Fintype Cfg]
    (weight x : Cfg -> Real) (hpos : forall w, 0 < weight w) :
    (Finset.univ.sum fun w => weight w * x w ^ 2) = 0 ↔ forall w, x w = 0 := by
  sorry

theorem centered_eq_zero_of_self_noise_zero
    (s : DiamondNoiseSource Cell Cfg) (c : Cell)
    (hpos : forall w, 0 < s.weight w)
    (hzero : noiseKernel s c c = 0) :
    forall w, centered s w c = 0 := by
  sorry

theorem noiseInvisible_iff_centered_zero_all_cells
    (s : DiamondNoiseSource Cell Cfg)
    (hpos : forall w, 0 < s.weight w) :
    NoiseInvisible s ↔ forall w c, centered s w c = 0 := by
  sorry

end NullEdgeP9PositiveWeightNoiseZero
