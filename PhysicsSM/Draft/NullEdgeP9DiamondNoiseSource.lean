import Mathlib.Tactic

/-!
# P9 diamond noise source core

This finite scaffold separates mean source invisibility from noise-source
invisibility. The central guardrail is that mean-zero bookkeeping need not be
gravitationally invisible when its noise response remains nonzero.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9DiamondNoiseSource

open BigOperators

structure DiamondNoiseSource (Cell Cfg : Type) [Fintype Cell] [Fintype Cfg] where
  source : Cfg -> Cell -> Real
  weight : Cfg -> Real

variable {Cell Cfg Pot : Type}
variable [Fintype Cell] [Fintype Cfg] [Fintype Pot]

def meanSource (s : DiamondNoiseSource Cell Cfg) (c : Cell) : Real :=
  Finset.univ.sum fun w => s.weight w * s.source w c

def noiseKernel (s : DiamondNoiseSource Cell Cfg) (c d : Cell) : Real :=
  Finset.univ.sum fun w =>
    s.weight w * (s.source w c - meanSource s c) *
      (s.source w d - meanSource s d)

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

structure DiamondBoundary (Cell Pot : Type) where
  bdry : (Pot -> Real) -> Cell -> Real

def Closed (B : DiamondBoundary Cell Pot) (t : Cell -> Real) : Prop :=
  forall p, (Finset.univ.sum fun c => t c * B.bdry p c) = 0

def BoundaryExact (s : DiamondNoiseSource Cell Cfg)
    (B : DiamondBoundary Cell Pot) : Prop :=
  Exists fun p : Cfg -> Pot -> Real =>
    forall w c, s.source w c = B.bdry (p w) c

def MeanBoundaryExact (s : DiamondNoiseSource Cell Cfg)
    (B : DiamondBoundary Cell Pot) : Prop :=
  Exists fun p : Pot -> Real =>
    forall c, meanSource s c = B.bdry p c

def oneCellMeanZeroNoise : DiamondNoiseSource (Fin 1) (Fin 2) where
  source := fun w _ => if w = 0 then 1 else -1
  weight := fun _ => (1 / 2 : Real)

def zeroBoundary (Cell Pot : Type) : DiamondBoundary Cell Pot where
  bdry := fun _ _ => 0

theorem oneCell_mean_zero :
    MeanInvisible oneCellMeanZeroNoise := by
  simp [MeanInvisible, oneCellMeanZeroNoise, meanSource]

theorem oneCell_noise_nonzero :
    noiseKernel oneCellMeanZeroNoise 0 0 ≠ 0 := by
  simp [noiseKernel, oneCellMeanZeroNoise, meanSource]

theorem exists_meanZero_noise_nonzero :
    Exists fun s : DiamondNoiseSource (Fin 1) (Fin 2) =>
      MeanInvisible s ∧ Exists fun c : Fin 1 =>
        Exists fun d : Fin 1 => noiseKernel s c d ≠ 0 := by
  refine ⟨oneCellMeanZeroNoise, oneCell_mean_zero, 0, 0, ?_⟩
  exact oneCell_noise_nonzero

theorem noiseKernel_self_nonneg (s : DiamondNoiseSource Cell Cfg)
    (hweight : forall w, 0 <= s.weight w) (c : Cell) :
    0 <= noiseKernel s c c := by
  exact Finset.sum_nonneg fun w _ => by
    nlinarith [hweight w, mul_self_nonneg (s.source w c - meanSource s c)]

theorem meanInvisible_imp_meanResponse_zero
    (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real)
    (h : MeanInvisible s) :
    meanResponse s t = 0 := by
  apply Finset.sum_eq_zero
  intro c _
  rw [h c]
  simp

theorem noiseInvisible_imp_noiseResponse_zero
    (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real)
    (h : NoiseInvisible s) :
    noiseResponse s t = 0 := by
  exact Finset.sum_eq_zero fun c _ =>
    Finset.sum_eq_zero fun d _ => by
      rw [h c d]
      simp

theorem gravInvisible_imp_allResponses_zero
    (s : DiamondNoiseSource Cell Cfg) (t : Cell -> Real)
    (h : GravInvisible s) :
    meanResponse s t = 0 ∧ noiseResponse s t = 0 := by
  exact ⟨meanInvisible_imp_meanResponse_zero s t h.left,
    noiseInvisible_imp_noiseResponse_zero s t h.right⟩

theorem exists_meanZero_noiseResponse_nonzero :
    Exists fun s : DiamondNoiseSource (Fin 1) (Fin 2) =>
      Exists fun t : Fin 1 -> Real =>
        MeanInvisible s ∧ noiseResponse s t ≠ 0 := by
  refine ⟨oneCellMeanZeroNoise, (fun _ => 1), oneCell_mean_zero, ?_⟩
  simp [noiseResponse]
  exact oneCell_noise_nonzero

omit [Fintype Pot] in
theorem meanBoundaryExact_meanResponse_zero_of_closed
    (B : DiamondBoundary Cell Pot) (s : DiamondNoiseSource Cell Cfg)
    (t : Cell -> Real)
    (hclosed : Closed B t) (hexact : MeanBoundaryExact s B) :
    meanResponse s t = 0 := by
  obtain ⟨p, hp⟩ := hexact
  convert hclosed p using 1
  exact Finset.sum_congr rfl fun _ _ => hp _ ▸ rfl

theorem exists_meanBoundaryExact_closed_noiseResponse_nonzero :
    Exists fun s : DiamondNoiseSource (Fin 1) (Fin 2) =>
      Exists fun B : DiamondBoundary (Fin 1) (Fin 1) =>
        Exists fun t : Fin 1 -> Real =>
          MeanBoundaryExact s B ∧ Closed B t ∧ noiseResponse s t ≠ 0 := by
  refine ⟨oneCellMeanZeroNoise, zeroBoundary (Fin 1) (Fin 1), (fun _ => 1),
    ?_, ?_, ?_⟩
  · simp [MeanBoundaryExact, meanSource, zeroBoundary, oneCellMeanZeroNoise]
  · simp [Closed, zeroBoundary]
  · simp [noiseResponse, noiseKernel, oneCellMeanZeroNoise, meanSource]

end PhysicsSM.Draft.NullEdgeP9DiamondNoiseSource
