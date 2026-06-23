import Mathlib.Tactic

/-!
# P9 noise-kernel Cauchy-Schwarz target

Finite covariance/noise kernels with nonnegative weights are positive
semidefinite. This module proves the Cauchy-Schwarz inequality for the finite
noise kernel, a key stochastic-gravity guardrail.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoiseCauchySchwarz

open BigOperators

def weightedDot {Cfg : Type} [Fintype Cfg]
    (weight : Cfg -> Real) (x y : Cfg -> Real) : Real :=
  Finset.univ.sum fun w => weight w * x w * y w

theorem weightedDot_cauchy_schwarz {Cfg : Type} [Fintype Cfg]
    (weight : Cfg -> Real) (x y : Cfg -> Real)
    (hweight : forall w, 0 <= weight w) :
    weightedDot weight x y ^ 2 <=
      weightedDot weight x x * weightedDot weight y y := by
  convert Finset.sum_mul_sq_le_sq_mul_sq (Finset.univ : Finset Cfg)
      (fun w => Real.sqrt (weight w) * x w)
      (fun w => Real.sqrt (weight w) * y w) using 1
  · exact congr_arg (· ^ 2)
      (Finset.sum_congr rfl fun _ _ => by
        ring_nf
        rw [Real.sq_sqrt (hweight _)]
        ring)
  · simp +decide only [weightedDot, mul_pow, Real.sq_sqrt (hweight _)]
    simp +decide only [mul_assoc, sq]

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
  exact weightedDot_cauchy_schwarz s.weight
    (fun w => centered s w c) (fun w => centered s w d) hweight

end PhysicsSM.Draft.NullEdgeP9NoiseCauchySchwarz
