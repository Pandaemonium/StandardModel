import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator

/-!
# Project-local signs on marked Alexandrov shells

The project-sign local four-dimensional causal operator uses the source layer
coefficients `(1, -9, 16, -8)` with an overall sign reversal. Its corrected
weighted-difference row therefore has one constant negative weight on the
immediate-predecessor shell `L_0(x)` and strictly positive weights on
`L_1(x) union L_3(x)` whenever the discreteness scale is nonzero.

This module proves those signs for every finite strict causal order. It does
not construct probes on the layers, select a rank-three angular space, or prove
Lorentzian inertia, overlap compatibility, or a continuum limit.

Claim grade: `M [orig/comp]`, finite coefficient identities.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights

open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

variable {V : Type*} [Fintype V]

/-- The strict-past weight row of the project-sign local four-dimensional
operator at the marked evaluation event `x`. -/
def projectLocalPastWeight
    (C : FiniteCausalOrder V) (ell : Real) (x : V) : V -> Real :=
  layeredPastWeight C (-sourceLocal4DPrefactor ell)
    sourceLocal4DCoefficient x

/-- On every past layer, the project-local row is exactly the corresponding
source coefficient times the sign-reversed prefactor. -/
theorem projectLocalPastWeight_on_pastLayer
    (C : FiniteCausalOrder V) (ell : Real) (x y : V) (n : Nat)
    (hy : y ∈ C.pastLayer x n) :
    projectLocalPastWeight C ell x y =
      -sourceLocal4DPrefactor ell * sourceLocal4DCoefficient n := by
  have hy' : C.before y x ∧ C.openIntervalCount y x = n := by
    simpa [FiniteCausalOrder.pastLayer] using hy
  unfold projectLocalPastWeight layeredPastWeight
  rw [if_pos hy'.1, hy'.2]

/-- The immediate-predecessor shell has one constant negative coefficient
before imposing the nonzero-scale sign condition. -/
theorem projectLocalPastWeight_layer_zero
    (C : FiniteCausalOrder V) (ell : Real) (x y : V)
    (hy : y ∈ C.pastLayer x 0) :
    projectLocalPastWeight C ell x y = -sourceLocal4DPrefactor ell := by
  rw [projectLocalPastWeight_on_pastLayer C ell x y 0 hy]
  norm_num [sourceLocal4DCoefficient]

/-- Layer one has positive coefficient `9 * sourceLocal4DPrefactor ell`. -/
theorem projectLocalPastWeight_layer_one
    (C : FiniteCausalOrder V) (ell : Real) (x y : V)
    (hy : y ∈ C.pastLayer x 1) :
    projectLocalPastWeight C ell x y =
      9 * sourceLocal4DPrefactor ell := by
  rw [projectLocalPastWeight_on_pastLayer C ell x y 1 hy]
  norm_num [sourceLocal4DCoefficient]
  ring

/-- Layer three has positive coefficient `8 * sourceLocal4DPrefactor ell`. -/
theorem projectLocalPastWeight_layer_three
    (C : FiniteCausalOrder V) (ell : Real) (x y : V)
    (hy : y ∈ C.pastLayer x 3) :
    projectLocalPastWeight C ell x y =
      8 * sourceLocal4DPrefactor ell := by
  rw [projectLocalPastWeight_on_pastLayer C ell x y 3 hy]
  norm_num [sourceLocal4DCoefficient]
  ring

/-- At nonzero discreteness scale, every immediate predecessor has strictly
negative project-local weight. -/
theorem projectLocalPastWeight_neg_on_layer_zero
    (C : FiniteCausalOrder V) (ell : Real) (hell : ell ≠ 0) (x y : V)
    (hy : y ∈ C.pastLayer x 0) :
    projectLocalPastWeight C ell x y < 0 := by
  have hprefactor : 0 < sourceLocal4DPrefactor ell := by
    unfold sourceLocal4DPrefactor
    positivity
  rw [projectLocalPastWeight_layer_zero C ell x y hy]
  linarith

/-- At nonzero discreteness scale, the proposed radial support
`L_1(x) union L_3(x)` carries strictly positive project-local weight. -/
theorem projectLocalPastWeight_pos_on_one_union_three
    [DecidableEq V] (C : FiniteCausalOrder V) (ell : Real)
    (hell : ell ≠ 0) (x y : V)
    (hy : y ∈ C.pastLayer x 1 ∪ C.pastLayer x 3) :
    0 < projectLocalPastWeight C ell x y := by
  have hprefactor : 0 < sourceLocal4DPrefactor ell := by
    unfold sourceLocal4DPrefactor
    positivity
  rcases Finset.mem_union.mp hy with hy1 | hy3
  · rw [projectLocalPastWeight_layer_one C ell x y hy1]
    positivity
  · rw [projectLocalPastWeight_layer_three C ell x y hy3]
    positivity

end PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights.projectLocalPastWeight_neg_on_layer_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights.projectLocalPastWeight_neg_on_layer_zero

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights.projectLocalPastWeight_pos_on_one_union_three' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights.projectLocalPastWeight_pos_on_one_union_three
