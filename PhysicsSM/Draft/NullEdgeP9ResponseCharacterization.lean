import Mathlib.Tactic

/-!
# P9 response characterization

Finite theorem targets for making P9 source invisibility observable-relative:
mean and noise invisibility are characterized by vanishing responses against all
finite observer tests.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9ResponseCharacterization

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
  unfold meanResponse meanSource deltaTest
  simp +decide
  rw [Finset.sum_eq_single c0] <;> aesop

theorem meanInvisible_iff_all_meanResponses_zero
    (s : DiamondNoiseSource Cell Cfg) :
    MeanInvisible s ↔ forall t : Cell -> Real, meanResponse s t = 0 := by
  constructor
  · unfold meanResponse MeanInvisible
    aesop
  · intro h
    exact fun c => by
      simpa [meanResponse_deltaTest_eq_meanSource] using h (deltaTest c)

theorem noiseKernel_symm (s : DiamondNoiseSource Cell Cfg) (c d : Cell) :
    noiseKernel s c d = noiseKernel s d c := by
  unfold noiseKernel
  exact Finset.sum_congr rfl fun _ _ => by ring

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
  rw [Finset.sum_eq_add c d] <;> simp +decide [*]
  · rw [Finset.sum_eq_add c d, Finset.sum_eq_add c d] <;>
      simp +decide [hcd, noiseKernel_symm]
    · ring
    all_goals aesop
  · aesop

theorem noiseInvisible_iff_all_noiseResponses_zero
    (s : DiamondNoiseSource Cell Cfg) :
    NoiseInvisible s ↔ forall t : Cell -> Real, noiseResponse s t = 0 := by
  refine ⟨fun h t => ?_, fun h c d => ?_⟩
  · exact Finset.sum_eq_zero fun c _ =>
      Finset.sum_eq_zero fun d _ => by
        rw [show noiseKernel s c d = 0 from h c d]
        ring
  · by_cases hcd : c = d
    · simpa [hcd, noiseResponse_deltaTest_eq_noiseKernel_self] using h (deltaTest d)
    · have hp := h (pairTest c d)
      rw [noiseResponse_pairTest_eq_diag_diag_cross s c d hcd] at hp
      linarith
        [show noiseKernel s c c = 0 from by
          simpa [noiseResponse_deltaTest_eq_noiseKernel_self] using h (deltaTest c),
        show noiseKernel s d d = 0 from by
          simpa [noiseResponse_deltaTest_eq_noiseKernel_self] using h (deltaTest d)]

theorem gravInvisible_iff_all_responses_zero
    (s : DiamondNoiseSource Cell Cfg) :
    GravInvisible s ↔
      (forall t : Cell -> Real, meanResponse s t = 0) ∧
        (forall t : Cell -> Real, noiseResponse s t = 0) := by
  rw [← meanInvisible_iff_all_meanResponses_zero,
    ← noiseInvisible_iff_all_noiseResponses_zero]
  rfl

end PhysicsSM.Draft.NullEdgeP9ResponseCharacterization
