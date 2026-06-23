import Mathlib.Tactic

/-!
# P9 noise response zero iff test amplitudes vanish

Under strictly positive configuration weights, a finite noise response vanishes
exactly when every centered test amplitude vanishes.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoiseResponseAmplitudeZero

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
  convert Finset.sum_comm using 1
  simp +decide [testAmplitude, noiseKernel, sq, mul_assoc, mul_comm, mul_left_comm,
    Finset.mul_sum _ _ _]
  exact Finset.sum_comm.trans (Finset.sum_congr rfl fun _ _ => Finset.sum_comm)

theorem noiseResponse_eq_zero_iff_testAmplitude_zero
    (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real)
    (hpos : forall w, 0 < s.weight w) :
    noiseResponse s t = 0 ↔ forall w, testAmplitude s t w = 0 := by
  have h_sum_zero_iff :
      (∑ w : Cfg, s.weight w * (testAmplitude s t w) ^ 2) = 0 ↔
        ∀ w : Cfg, (testAmplitude s t w) ^ 2 = 0 := by
    rw [Finset.sum_eq_zero_iff_of_nonneg]
    · simp +decide [ne_of_gt (hpos _)]
    · exact fun _ _ => mul_nonneg (le_of_lt (hpos _)) (sq_nonneg _)
  rw [noiseResponse_eq_weighted_square_sum, h_sum_zero_iff]
  simp +decide

end PhysicsSM.Draft.NullEdgeP9NoiseResponseAmplitudeZero
