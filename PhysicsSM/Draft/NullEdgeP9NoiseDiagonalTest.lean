import Mathlib.Tactic

/-!
# P9 local diagonal noise test

A cell-local observer test reads the diagonal of the finite noise kernel.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoiseDiagonalTest

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

def deltaTest (c0 : Cell) : Cell -> Real :=
  by
    classical
    exact fun c => if c = c0 then 1 else 0

theorem noiseResponse_deltaTest_eq_noiseKernel_self
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell) :
    noiseResponse s (deltaTest c0) = noiseKernel s c0 c0 := by
  classical
  -- By definition of `deltaTest`, we know that `deltaTest c0 c = 1` if `c = c0` and `0` otherwise.
  simp [noiseResponse, deltaTest]

theorem exists_test_noiseResponse_nonzero_of_diagonal_nonzero
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell)
    (h : noiseKernel s c0 c0 ≠ 0) :
    Exists fun t : Cell -> Real => noiseResponse s t ≠ 0 := by
  exact ⟨ _, by rw [ noiseResponse_deltaTest_eq_noiseKernel_self ] ; exact h ⟩

end PhysicsSM.Draft.NullEdgeP9NoiseDiagonalTest
