import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Sqrt

/-!
# P7 mass-ratio monotonicity under unital Bloch contraction

This module contains the proof that the mass-ratio increases or stays the same under a unital Bloch contraction.
This represents relative-entropy/distinguishability monotonicity under observer channels.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeMassRatioMonotone

abbrev Vec3 := Fin 3 -> Real

def normSq (r : Vec3) : Real :=
  Finset.univ.sum fun i => r i ^ 2

def massRatio (r : Vec3) : Real :=
  Real.sqrt (1 - normSq r)

theorem massRatio_monotone_under_unital_bloch_contraction
    (r : Vec3) (f : Vec3 -> Vec3)
    (h_norm_le : normSq r ≤ 1)
    (h_contract : normSq (f r) ≤ normSq r) :
    massRatio r ≤ massRatio (f r) := by
  exact Real.sqrt_le_sqrt <| by linarith;

end PhysicsSM.Draft.NullEdgeMassRatioMonotone
