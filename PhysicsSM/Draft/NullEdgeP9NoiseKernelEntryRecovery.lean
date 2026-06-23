import Mathlib.Tactic

/-!
# P9 noise-kernel entry recovery from observer tests

This focused P9 scaffold strengthens the finite noise-invisibility API. It
shows that delta and pair observer tests recover entries of a finite symmetric
noise kernel, so "all observer noise responses vanish" is not merely a weak
aggregate condition.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9NoiseKernelEntryRecovery

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
  simp [noiseKernel, mul_comm, mul_left_comm]

theorem noiseResponse_deltaTest_eq_noiseKernel_self
    (s : DiamondNoiseSource Cell Cfg) (c0 : Cell) :
    noiseResponse s (deltaTest c0) = noiseKernel s c0 c0 := by
  unfold noiseResponse deltaTest
  rw [Finset.sum_eq_single c0, Finset.sum_eq_single c0] <;> aesop

theorem noiseResponse_pairTest_eq_diag_diag_cross
    (s : DiamondNoiseSource Cell Cfg) (c d : Cell) (hcd : c ≠ d) :
    noiseResponse s (pairTest c d) =
      noiseKernel s c c + noiseKernel s d d + 2 * noiseKernel s c d := by
  unfold noiseResponse pairTest
  rw [Finset.sum_eq_add c d] <;> norm_num
  · rw [Finset.sum_eq_add c d, Finset.sum_eq_add c d] <;> norm_num [hcd]
    · rw [noiseKernel_symm s d c]
      ring
    · grind +suggestions
    · aesop
  · assumption
  · aesop

/--
An off-diagonal noise-kernel entry is recovered from one pair test and the two
corresponding delta tests.
-/
theorem noiseKernel_entry_recovered_from_tests
    (s : DiamondNoiseSource Cell Cfg) (c d : Cell) (hcd : c ≠ d) :
    noiseKernel s c d =
      (noiseResponse s (pairTest c d)
        - noiseResponse s (deltaTest c)
        - noiseResponse s (deltaTest d)) / 2 := by
  rw [noiseResponse_pairTest_eq_diag_diag_cross,
    noiseResponse_deltaTest_eq_noiseKernel_self,
    noiseResponse_deltaTest_eq_noiseKernel_self]
  · ring
  · assumption

end PhysicsSM.Draft.NullEdgeP9NoiseKernelEntryRecovery
