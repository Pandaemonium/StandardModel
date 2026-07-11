import PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity
import PhysicsSM.Draft.NullEdge.CarrierRigidity

namespace PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGoCheck

open ChannelRefinementTorsor ChannelSelectorRigidity
open CarrierRigidity.Concrete

def traceProfile : ZeroSumShift N →+ (Fin 3 → ℚ) where
  toFun h i := Matrix.trace (h.1 i)
  map_zero' := by funext i; simp
  map_add' a b := by funext i; simp

def traceZeroDirection : N :=
  !![1,0,0,0; 0,-1,0,0; 0,0,0,0; 0,0,0,0]

theorem traceZeroDirection_trace : Matrix.trace traceZeroDirection = 0 := by
  simp +decide [traceZeroDirection, Matrix.trace, Fin.sum_univ_four]

theorem traceZeroDirection_nonzero : traceZeroDirection ≠ 0 := by
  intro h
  have h00 := congrFun (congrFun h 0) 0
  norm_num [traceZeroDirection] at h00

def traceInvisibleShift : ZeroSumShift N :=
  ⟨![traceZeroDirection, -traceZeroDirection, 0], by
    change Finset.univ.sum ![traceZeroDirection, -traceZeroDirection, 0] = 0
    simp [Fin.sum_univ_three]⟩

theorem traceInvisibleShift_nonzero : traceInvisibleShift ≠ 0 := by
  intro h
  apply traceZeroDirection_nonzero
  have h0 := congrArg (fun k : ZeroSumShift N => k.1 0) h
  simpa [traceInvisibleShift] using h0

theorem traceProfile_invisible : traceProfile traceInvisibleShift = 0 := by
  funext i
  fin_cases i <;>
    simp [traceProfile, traceInvisibleShift, traceZeroDirection_trace]

theorem traceProfile_not_injective : ¬ Function.Injective traceProfile := by
  intro hinj
  apply traceInvisibleShift_nonzero
  apply hinj
  rw [traceProfile_invisible, map_zero]

theorem traceProfile_does_not_rigidify {S : N} :
    ¬ (∀ b c : Refinement S,
      traceProfile (difference b c) = 0 → b = c) := by
  rw [selector_rigid_iff_injective]
  exact traceProfile_not_injective

end PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGoCheck
