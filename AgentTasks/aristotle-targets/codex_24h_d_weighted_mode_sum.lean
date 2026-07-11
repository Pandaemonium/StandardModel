import PhysicsSM.Draft.NullEdge.Compact3Plus1GrowingWindowRate
import PhysicsSM.Draft.NullEdge.SobolevTailRate
import PhysicsSM.Draft.NullEdge.CountableL2WavepacketConvergence

/-!
Focused Paper D aggregate coefficient-space target. This handoff file
intentionally contains a proof hole and is not imported by a project root.
-/

noncomputable section

open Filter Topology

namespace PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum

open ChangingModeEmbedding SobolevTailRate

/-- A modewise error with a vanishing scalar rate and a common Sobolev-weighted
envelope has vanishing total squared coefficient error. This is a countable
coefficient-space theorem, not a sampling, interpolation, or PDE theorem. -/
theorem growingWindow_countableWeightedL2_tendsto_zero
    {E : Type*} [NormedAddCommGroup E]
    (r : Nat -> Real)
    (hr : Tendsto r atTop (nhds 0))
    (err : Nat -> Mode -> E)
    (f : Mode -> E)
    (s : Nat)
    (hSob : Summable
      (fun k => ((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2))
    (hpoint : forall k, Tendsto (fun n => err n k) atTop (nhds 0))
    (hdom : forall n k,
      ‖err n k‖ ^ 2 <=
        r n * (((1 + modeRadius k : Nat) ^ s : Real) * ‖f k‖ ^ 2)) :
    Tendsto (fun n => ∑' k, ‖err n k‖ ^ 2) atTop (nhds 0) := by
  sorry

end PhysicsSM.Draft.NullEdge.WeightedGrowingWindowModeSum
