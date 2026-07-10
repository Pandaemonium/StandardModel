import PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
import PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger

/-!
# Primitive checkerboard histories as operator histories

The exact scalar sum over all length-`n` direction histories is the matching
matrix entry of the operator assigned by `HistoryOperatorMonoidalDagger` to the
constant history containing `n` copies of the checkerboard transfer gate. This
is the first direct arrow from the primitive direction-history layer into the
operator-valued monoidal composition layer.

The transfer gate is still defined from supplied `mu` and phase data. This
module does not prove that it is unitary, derive those data from a bare graph,
or connect the operator history to the Hodge mass decoder.

Provenance: exact next theorem proposed by Aristotle composition audit
`a05ae72c-97d2-446c-9b76-b17f336a51ec`; proof checked locally by Codex.
-/

namespace PhysicsSM.Draft.NullEdge.CheckerboardOperatorHistoryBridge

open PhysicsSM.Draft.NullEdge.CheckerboardPathSumTransferPower
open PhysicsSM.Draft.NullEdge.HistoryOperatorMonoidalDagger

/-- **Primitive path sum as an operator history.** -/
theorem pathSum_as_operator_history
    (mu : ℂ) (phase : Direction -> ℂ) (n : Nat)
    (start finish : Direction) :
    directionPathSum mu phase n start finish =
      historyOperator (List.replicate n (transfer mu phase)) finish start := by
  rw [directionPathSum_eq_transfer_pow, historyOperator, List.prod_replicate]

def complexWitnessPhase : Direction -> ℂ
  | .left => 3
  | .right => 5

/-- Nonzero bridge fixture: the primitive two-step path sum and the associated
operator-history entry both equal `85`. -/
theorem two_step_operator_history_witness :
    directionPathSum (2 : ℂ) complexWitnessPhase 2
        Direction.right Direction.right = 85 ∧
      historyOperator
          (List.replicate 2 (transfer (2 : ℂ) complexWitnessPhase))
          Direction.right Direction.right = 85 := by
  have hpath : directionPathSum (2 : ℂ) complexWitnessPhase 2
      Direction.right Direction.right = 85 := by
    norm_num [directionPathSum, histories, terminalDirection,
      phasedPathWeight, turnWeight, complexWitnessPhase]
    simp
    norm_num
  refine ⟨hpath, ?_⟩
  rw [← pathSum_as_operator_history]
  exact hpath

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CheckerboardOperatorHistoryBridge.pathSum_as_operator_history' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pathSum_as_operator_history

/-- info: 'PhysicsSM.Draft.NullEdge.CheckerboardOperatorHistoryBridge.two_step_operator_history_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms two_step_operator_history_witness

end PhysicsSM.Draft.NullEdge.CheckerboardOperatorHistoryBridge
