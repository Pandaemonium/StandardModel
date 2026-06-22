import Mathlib

/-!
# Finite P9 mean-zero fluctuation toy model

This focused target isolates a tiny algebraic mechanism for the P9
cosmological-constant/source-visibility branch:

* an antisymmetric source observable under a finite observer-hidden relabeling
  has zero total source;
* a two-point sign source has zero mean but nonzero second moment.

This is not a cosmology theorem. It is a finite guardrail: any later residual
source-fluctuation pilot should prove a mean-zero statement before discussing
variance, scaling, or everpresent-Lambda comparisons.
-/

noncomputable section

namespace NullEdgeP9MeanZeroFluctuation

open BigOperators

/-- A finite source observable has zero total source. -/
def MeanZero {omega : Type*} [Fintype omega] (source : omega -> Real) : Prop :=
  Finset.univ.sum source = 0

/-- Unnormalized second moment of a finite source observable. -/
def secondMoment {omega : Type*} [Fintype omega] (source : omega -> Real) : Real :=
  Finset.univ.sum fun x => source x ^ 2

/--
If a finite source observable changes sign under a bijective relabeling, then
its total source is zero.
-/
theorem meanZero_of_equiv_antisymm
    {omega : Type*} [Fintype omega] [DecidableEq omega]
    (tau : omega ≃ omega) (source : omega -> Real)
    (hanti : forall x, source (tau x) = - source x) :
    MeanZero source := by
  sorry

/-- The simplest sign-paired source: one positive and one negative state. -/
def twoPointSignSource : Fin 2 -> Real :=
  fun i => if i = 0 then 1 else -1

/-- The two-point sign source has zero total source. -/
theorem twoPointSignSource_meanZero :
    MeanZero twoPointSignSource := by
  sorry

/-- The two-point sign source has nonzero second moment. -/
theorem twoPointSignSource_secondMoment_eq_two :
    secondMoment twoPointSignSource = 2 := by
  sorry

/-- The two-point sign source is mean-zero but fluctuation-nontrivial. -/
theorem exists_meanZero_nonzero_secondMoment :
    exists source : Fin 2 -> Real,
      And (MeanZero source) (secondMoment source = 2) := by
  sorry

end NullEdgeP9MeanZeroFluctuation
