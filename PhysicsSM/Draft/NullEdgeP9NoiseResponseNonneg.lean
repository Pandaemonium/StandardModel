import Mathlib.Tactic

/-!
# P9 nonnegative finite noise response

For nonnegative configuration weights, the finite quadratic noise response is a
weighted sum of squares. This is the finite version of the stochastic-gravity
guardrail that a noise kernel is positive semidefinite.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoiseResponseNonneg

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

def testAmplitude (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real)
    (w : Cfg) : Real :=
  Finset.univ.sum fun c => t c * centered s w c

theorem noiseResponse_eq_weighted_square_sum
    (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real) :
    noiseResponse s t =
      Finset.univ.sum fun w => s.weight w * (testAmplitude s t w) ^ 2 := by
  unfold noiseResponse testAmplitude
  have h1 : ∀ c d, noiseKernel s c d =
      ∑ w, s.weight w * centered s w c * centered s w d := by
    intro c d
    rfl
  simp +decide only [h1, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, pow_two]
  refine Eq.symm (Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ => ?_))
  exact Finset.sum_comm.trans
    (Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring)

theorem noiseResponse_nonneg_of_weights_nonneg
    (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real)
    (hw : forall w, 0 <= s.weight w) :
    0 <= noiseResponse s t := by
  rw [noiseResponse_eq_weighted_square_sum]
  exact Finset.sum_nonneg fun w _ =>
    mul_nonneg (hw w) (sq_nonneg (testAmplitude s t w))

end PhysicsSM.Draft.NullEdgeP9NoiseResponseNonneg
