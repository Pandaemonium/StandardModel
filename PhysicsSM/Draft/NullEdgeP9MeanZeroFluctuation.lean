import Mathlib

/-!
# Finite P9 mean-zero fluctuation toy model

This module records a small algebraic mechanism for the P9
cosmological-constant/source-visibility branch:

* an antisymmetric source observable under a finite observer-hidden relabeling
  has zero total source;
* a two-point sign source has zero mean but nonzero second moment.

This is not a cosmology theorem. It is a finite guardrail: any later residual
source-fluctuation pilot should prove a mean-zero statement before discussing
variance, scaling, or everpresent-Lambda comparisons.

Proven by Aristotle project `11e12028-c36f-4a35-8ecc-156717122f13`
on 2026-06-22 from the focused standalone package
`null-edge-p9-mean-zero-fluctuation-20260622`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation

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
    {omega : Type*} [Fintype omega]
    (tau : omega ≃ omega) (source : omega -> Real)
    (hanti : forall x, source (tau x) = - source x) :
    MeanZero source := by
  unfold MeanZero
  have hcomp :
      (Finset.univ.sum fun x => source (tau x)) = Finset.univ.sum source :=
    Equiv.sum_comp tau source
  have hneg :
      (Finset.univ.sum fun x => source (tau x)) = -Finset.univ.sum source := by
    simp only [hanti, Finset.sum_neg_distrib]
  linarith [hcomp, hneg]

/-- The simplest sign-paired source: one positive and one negative state. -/
def twoPointSignSource : Fin 2 -> Real :=
  fun i => if i = 0 then 1 else -1

/-- The two-point sign source has zero total source. -/
theorem twoPointSignSource_meanZero :
    MeanZero twoPointSignSource := by
  unfold MeanZero twoPointSignSource
  norm_num [Fin.sum_univ_succ]

/-- The two-point sign source has nonzero second moment. -/
theorem twoPointSignSource_secondMoment_eq_two :
    secondMoment twoPointSignSource = 2 := by
  unfold secondMoment twoPointSignSource
  norm_num [Fin.sum_univ_succ]

/-- The two-point sign source is mean-zero but fluctuation-nontrivial. -/
theorem exists_meanZero_nonzero_secondMoment :
    exists source : Fin 2 -> Real,
      And (MeanZero source) (secondMoment source = 2) := by
  refine ⟨twoPointSignSource, twoPointSignSource_meanZero, ?_⟩
  exact twoPointSignSource_secondMoment_eq_two

end PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation
