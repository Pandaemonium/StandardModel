import PhysicsSM.Draft.NullEdge.ChannelSelectorRigidity
import PhysicsSM.Draft.NullEdge.CarrierRigidity

/-!
# Trace profiles do not rigidify channel refinements

Unlike raw word degree, matrix trace is already an intrinsic invariant of a
represented operator and is unchanged by conjugation. This module tests the
componentwise trace profile as a selector on the live concrete rational
carrier. A nonzero trace-zero matrix gives a zero-sum shear that preserves the
trace of every component. Therefore the trace profile is not injective on the
complete shift group and, by the exact selector criterion, cannot rigidify the
fixed-total refinement fibre.

This is a negative result about one natural infinite-valued selector. It does
not show that all spectral, locality, positivity, or information-theoretic
selectors fail, and it does not identify the physical quotient.

Provenance: elementary finite matrix argument designed in the Paper F
classification lane after the raw solder-degree selector was killed by
`ChannelSolderDegreeNoGo`. Lean 4.28.0.
-/

namespace PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGo

open ChannelRefinementTorsor ChannelSelectorRigidity
open CarrierRigidity.Concrete

/-- Componentwise matrix trace on the zero-sum refinement shift group. -/
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

/-- A nonzero aperture/closure shear that is invisible to every component
trace. -/
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

/-- Componentwise trace data cannot uniquely recover a fixed-total channel
refinement. -/
theorem traceProfile_does_not_rigidify {S : N} :
    ¬ (∀ b c : Refinement S,
      traceProfile (difference b c) = 0 → b = c) := by
  rw [selector_rigid_iff_injective]
  exact traceProfile_not_injective

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGo.traceProfile_invisible' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms traceProfile_invisible

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGo.traceProfile_does_not_rigidify' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms traceProfile_does_not_rigidify

end PhysicsSM.Draft.NullEdge.ChannelTraceSelectorNoGo
