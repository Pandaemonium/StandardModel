import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
import PhysicsSM.Draft.NullEdge.MinkowskiConvention

/-!
# Intrinsic difference coordinates for the corrected pairing

The corrected weighted-difference form is diagonal in the coordinates
`f(y) - f(x)` based at the marked event `x`.  On the zero-sum probe space these
coordinates are injective: a probe with every based difference zero is a
constant probe, and a constant zero-sum probe vanishes.

An explicit five-event control then supplies four zero-sum difference probes
whose Gram matrix is exactly the project's mostly-minus Minkowski matrix for
one signed star-weight row.  This proves that the corrected finite-difference
architecture can carry Lorentzian inertia without a supplied coordinate
frame.  It does not show that the active causal coefficients realize this
weight row, select such a five-event carrier under refinement, or produce a
stable spectral gap.

Claim grade: `M [orig/comp]`, finite algebra only.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates

open PhysicsSM.Draft.NullEdge.AlexandrovAlgebraGerm
open PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator
open PhysicsSM.Draft.NullEdge.AlexandrovGermPacking
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
open PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

variable {V : Type*} [Fintype V]

/-- Events other than one marked basepoint. -/
abbrev NonBasepoint (x : V) := {y : V // y ≠ x}

/-- Intrinsic based-difference coordinates on the zero-sum probe space. -/
def differenceCoordinates (x : V) :
    zeroSumFieldSubspace V →ₗ[Real] (NonBasepoint x -> Real) where
  toFun f y := f.1 y.1 - f.1 x
  map_add' f h := by
    funext y
    simp
    ring
  map_smul' c f := by
    funext y
    simp
    ring

/-- The corrected form is diagonal in based-difference coordinates. -/
theorem weightedDifferenceForm_eq_differenceCoordinates
    [DecidableEq V]
    (weight : V -> Real) (x : V)
    (f h : zeroSumFieldSubspace V) :
    weightedDifferenceForm weight x f.1 h.1 =
      (2 : Real)⁻¹ *
        ∑ y : NonBasepoint x,
          weight y.1 * differenceCoordinates x f y *
            differenceCoordinates x h y := by
  classical
  unfold weightedDifferenceForm differenceCoordinates
  rw [Fintype.sum_eq_add_sum_subtype_ne _ x]
  simp

/-- Based-difference coordinates are injective on zero-sum probes. -/
theorem differenceCoordinates_injective (x : V) :
    Function.Injective (differenceCoordinates x) := by
  classical
  letI : Nonempty V := ⟨x⟩
  intro f h hcoordinates
  have hpoint : ∀ y : V,
      f.1 y - h.1 y = f.1 x - h.1 x := by
    intro y
    by_cases hyx : y = x
    · subst y
      rfl
    · have hcoord := congrFun hcoordinates (⟨y, hyx⟩ : NonBasepoint x)
      change f.1 y - f.1 x = h.1 y - h.1 x at hcoord
      linarith
  have hsum : ∑ y : V, (f.1 y - h.1 y) = 0 := by
    have hf := f.property
    have hh := h.property
    change (∑ y : V, f.1 y) = 0 at hf
    change (∑ y : V, h.1 y) = 0 at hh
    rw [Finset.sum_sub_distrib]
    rw [hf, hh, sub_self]
  have hcard : (Fintype.card V : Real) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  have hbase : f.1 x - h.1 x = 0 := by
    have hconst :
        (Fintype.card V : Real) * (f.1 x - h.1 x) = 0 := by
      calc
        (Fintype.card V : Real) * (f.1 x - h.1 x) =
            ∑ y : V, (f.1 x - h.1 x) := by simp; ring
        _ = ∑ y : V, (f.1 y - h.1 y) := by
          apply Finset.sum_congr rfl
          intro y _
          exact (hpoint y).symm
        _ = 0 := hsum
    exact (mul_eq_zero.mp hconst).resolve_left hcard
  apply Subtype.ext
  funext y
  have := hpoint y
  linarith

/-! ## Exact five-event Lorentzian control -/

/-- Standard inclusion of the four coordinate labels into the first four of
five events. -/
def fourToFive (i : Fin 4) : Fin 5 := i.castSucc

/-- The zero-sum probe whose based-difference coordinate is the `i`th standard
coordinate. -/
def fiveEventDifferenceProbe (i : Fin 4) :
    zeroSumFieldSubspace (Fin 5) := by
  refine ⟨fun z => if z = fourToFive i then (4 / 5 : Real) else -1 / 5, ?_⟩
  rw [zeroSumFieldSubspace, LinearMap.mem_ker]
  unfold fieldSumLinearMap
  simp only [LinearMap.coe_mk, AddHom.coe_mk]
  have hrewrite : ∀ z : Fin 5,
      (if z = fourToFive i then (4 / 5 : Real) else -1 / 5) =
        -1 / 5 + if z = fourToFive i then 1 else 0 := by
    intro z
    by_cases hzi : z = fourToFive i
    · simp [hzi]
      ring
    · simp [hzi]
  simp_rw [hrewrite]
  rw [Finset.sum_add_distrib]
  norm_num

/-- Every explicit probe has one unit based difference and zero elsewhere. -/
theorem fiveEventDifferenceProbe_difference (i : Fin 4) (z : Fin 5) :
    (fiveEventDifferenceProbe i).1 z -
        (fiveEventDifferenceProbe i).1 4 =
      if z = fourToFive i then 1 else 0 := by
  have hbase : (4 : Fin 5) ≠ fourToFive i := by
    intro h
    have : (4 : Nat) = i.1 := congrArg Fin.val h
    omega
  by_cases hzi : z = fourToFive i
  · subst z
    norm_num [fiveEventDifferenceProbe, hbase]
  · simp [fiveEventDifferenceProbe, hzi, hbase]

/-- The explicit probes have Kronecker based-difference coordinates. -/
theorem fiveEventDifferenceProbe_coordinate (i j : Fin 4) :
    (fiveEventDifferenceProbe i).1 (fourToFive j) -
        (fiveEventDifferenceProbe i).1 4 =
      if i = j then 1 else 0 := by
  rw [fiveEventDifferenceProbe_difference]
  by_cases hij : i = j
  · subst j
    simp
  · have hcast : fourToFive j ≠ fourToFive i := by
      intro h
      apply hij
      exact (Fin.castSucc_injective 4 h).symm
    simp [hij, hcast]

/-- One positive and three negative signed star weights. -/
def fiveEventLorentzWeight (z : Fin 5) : Real :=
  if z = 0 then 2 else if z = 4 then 0 else -2

/-- Arbitrary star weights are diagonal in the explicit difference probes. -/
theorem fiveEventDifferenceProbe_gram_diagonal
    (weight : Fin 5 -> Real) (i j : Fin 4) :
    weightedDifferenceForm weight 4
        (fiveEventDifferenceProbe i).1 (fiveEventDifferenceProbe j).1 =
      if i = j then (2 : Real)⁻¹ * weight (fourToFive i) else 0 := by
  unfold weightedDifferenceForm
  simp_rw [fiveEventDifferenceProbe_difference]
  by_cases hij : i = j
  · subst j
    simp [mul_ite]
  · have hcast : fourToFive i ≠ fourToFive j := by
      intro h
      exact hij (Fin.castSucc_injective 4 h)
    have hterm : ∀ y : Fin 5,
        (if y = fourToFive i then (1 : Real) else 0) *
            (if y = fourToFive j then (1 : Real) else 0) = 0 := by
      intro y
      by_cases hyi : y = fourToFive i
      · subst y
        simp [hcast]
      · simp [hyi]
    have hsum :
        (∑ y : Fin 5,
          weight y * (if y = fourToFive i then (1 : Real) else 0) *
            (if y = fourToFive j then (1 : Real) else 0)) = 0 := by
      apply Finset.sum_eq_zero
      intro y _
      rw [mul_assoc, hterm y, mul_zero]
    rw [hsum]
    simp [hij]

/-- Gram entries of the explicit probe family are the mostly-minus metric. -/
theorem fiveEventDifferenceProbe_gram_eq_eta (i j : Fin 4) :
    weightedDifferenceForm fiveEventLorentzWeight 4
        (fiveEventDifferenceProbe i).1 (fiveEventDifferenceProbe j).1 =
      (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real) i j := by
  unfold weightedDifferenceForm
  simp_rw [fiveEventDifferenceProbe_difference]
  by_cases hij : i = j
  · subst j
    simp [mul_ite]
    fin_cases i <;>
      norm_num [fiveEventLorentzWeight, fourToFive,
        MinkowskiConvention.eta, Fin.ext_iff]
  · have hcast : fourToFive i ≠ fourToFive j := by
      intro h
      apply hij
      exact Fin.castSucc_injective 4 h
    have hterm : ∀ y : Fin 5,
        (if y = fourToFive i then (1 : Real) else 0) *
            (if y = fourToFive j then (1 : Real) else 0) = 0 := by
      intro y
      by_cases hyi : y = fourToFive i
      · subst y
        simp [hcast]
      · simp [hyi]
    have hsum :
        (∑ y : Fin 5,
          fiveEventLorentzWeight y *
            (if y = fourToFive i then (1 : Real) else 0) *
            (if y = fourToFive j then (1 : Real) else 0)) = 0 := by
      apply Finset.sum_eq_zero
      intro y _
      rw [mul_assoc, hterm y, mul_zero]
    rw [hsum]
    simp
    fin_cases i <;> fin_cases j <;>
      simp_all [MinkowskiConvention.eta]

/-- The four explicit difference probes are linearly independent. -/
theorem fiveEventDifferenceProbe_linearIndependent :
    LinearIndependent Real fiveEventDifferenceProbe := by
  rw [Fintype.linearIndependent_iff]
  intro g hsum i
  have hcoordinate := congrArg
    (fun f : zeroSumFieldSubspace (Fin 5) =>
      f.1 (fourToFive i) - f.1 4) hsum
  simp only [Submodule.coe_sum, Finset.sum_apply, SetLike.val_smul,
    Pi.smul_apply, smul_eq_mul, Submodule.coe_zero, Pi.zero_apply,
    sub_zero] at hcoordinate
  rw [<- Finset.sum_sub_distrib] at hcoordinate
  simp_rw [<- mul_sub] at hcoordinate
  simp_rw [fiveEventDifferenceProbe_coordinate] at hcoordinate
  simpa using hcoordinate

/-- The four explicit probes form a basis of the five-event zero-sum space. -/
def fiveEventDifferenceBasis :
    Module.Basis (Fin 4) Real (zeroSumFieldSubspace (Fin 5)) :=
  basisOfLinearIndependentOfCardEqFinrank
    fiveEventDifferenceProbe_linearIndependent (by
      norm_num [finrank_fiveEvent_zeroSum])

/-- **Lorentzian nonvacuity control.** In the explicit difference basis, the
signed weighted-difference form has Gram matrix exactly `diag(1,-1,-1,-1)`. -/
theorem fiveEventDifferenceBasis_gram_eq_eta :
    (fun i j : Fin 4 =>
      weightedDifferenceForm fiveEventLorentzWeight 4
        (fiveEventDifferenceBasis i).1 (fiveEventDifferenceBasis j).1) =
      (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) Real) := by
  ext i j
  simp only [fiveEventDifferenceBasis,
    coe_basisOfLinearIndependentOfCardEqFinrank]
  exact fiveEventDifferenceProbe_gram_eq_eta i j

/-! ## Realization by the local project causal coefficients -/

/-- The five-event three-arm diamond: one bottom, three incomparable internal
events, and one top. -/
def fiveEventLorentzOrder : FiniteCausalOrder (Fin 5) where
  before i j :=
    (i = 0 ∧ j ≠ 0) ∨ (i ≠ 0 ∧ i ≠ 4 ∧ j = 4)
  decidableBefore := by infer_instance
  irrefl := by
    intro i h
    rcases h with h | h <;> omega
  trans := by
    intro i j k hij hjk
    rcases hij with hij | hij <;> rcases hjk with hjk | hjk <;>
      simp_all

/-- At the marked top, the bottom lies in layer three and the three internal
events lie in layer zero. -/
theorem fiveEventLorentzOrder_intervalCounts :
    fiveEventLorentzOrder.openIntervalCount 0 4 = 3 ∧
    fiveEventLorentzOrder.openIntervalCount 1 4 = 0 ∧
    fiveEventLorentzOrder.openIntervalCount 2 4 = 0 ∧
    fiveEventLorentzOrder.openIntervalCount 3 4 = 0 := by
  decide

/-- The five-event order with bottom zero and top four as one marked
Alexandrov diamond. -/
def fiveEventLorentzDiamond : MarkedDiamond fiveEventLorentzOrder where
  bottom := 0
  top := 4
  bottom_before_top := by simp [fiveEventLorentzOrder]

/-- Every event of the five-event order belongs to the same closed marked
diamond. -/
theorem fiveEventLorentzDiamond_inClosed_all (x : Fin 5) :
    inClosed fiveEventLorentzDiamond x := by
  fin_cases x <;>
    simp [inClosed, MarkedDiamond.inOpen, fiveEventLorentzDiamond,
      fiveEventLorentzOrder]

/-- The closed carrier of the marked diamond is exactly the original
five-event type. -/
def fiveEventClosedCarrierEquiv :
    ClosedCarrier fiveEventLorentzDiamond ≃ Fin 5 where
  toFun x := x.1
  invFun x := ⟨x, fiveEventLorentzDiamond_inClosed_all x⟩
  left_inv x := by
    apply Subtype.ext
    rfl
  right_inv _ := rfl

/-- The induced closed-carrier order is isomorphic to the concrete
five-event order without adding decoration. -/
def fiveEventInducedOrderIso :
    OrderIso fiveEventLorentzOrder (inducedOrder fiveEventLorentzDiamond) where
  toEquiv := fiveEventClosedCarrierEquiv.symm
  map_before_iff _ _ := Iff.rfl

/-- The closed marked carrier has exactly five events. -/
theorem fiveEventLorentzDiamond_closedCarrier_card :
    Fintype.card (ClosedCarrier fiveEventLorentzDiamond) = 5 := by
  exact Fintype.card_congr fiveEventClosedCarrierEquiv

/-- The actual project-sign local weight row on the five-event order. -/
def fiveEventProjectLocalWeight (ell : Real) : Fin 5 -> Real :=
  layeredPastWeight fiveEventLorentzOrder
    (-sourceLocal4DPrefactor ell) sourceLocal4DCoefficient 4

/-- The local causal coefficients give one positive layer-three weight, three
negative layer-zero weights, and zero at the marked event. -/
theorem fiveEventProjectLocalWeight_values (ell : Real) :
    fiveEventProjectLocalWeight ell 0 =
        8 * sourceLocal4DPrefactor ell ∧
    fiveEventProjectLocalWeight ell 1 =
        -sourceLocal4DPrefactor ell ∧
    fiveEventProjectLocalWeight ell 2 =
        -sourceLocal4DPrefactor ell ∧
    fiveEventProjectLocalWeight ell 3 =
        -sourceLocal4DPrefactor ell ∧
    fiveEventProjectLocalWeight ell 4 = 0 := by
  rcases fiveEventLorentzOrder_intervalCounts with
    ⟨h0, h1, h2, h3⟩
  constructor
  · unfold fiveEventProjectLocalWeight layeredPastWeight
    rw [if_pos (by simp [fiveEventLorentzOrder]), h0]
    norm_num [sourceLocal4DCoefficient]
    ring
  constructor
  · unfold fiveEventProjectLocalWeight layeredPastWeight
    rw [if_pos (by simp [fiveEventLorentzOrder]), h1]
    norm_num [sourceLocal4DCoefficient]
  constructor
  · unfold fiveEventProjectLocalWeight layeredPastWeight
    rw [if_pos (by simp [fiveEventLorentzOrder]), h2]
    norm_num [sourceLocal4DCoefficient]
  constructor
  · unfold fiveEventProjectLocalWeight layeredPastWeight
    rw [if_pos (by simp [fiveEventLorentzOrder]), h3]
    norm_num [sourceLocal4DCoefficient]
  · unfold fiveEventProjectLocalWeight layeredPastWeight
    rw [if_neg (fiveEventLorentzOrder.irrefl 4)]

/-- Negating the source-sign local operator is exactly the layered operator
with a negated prefactor. -/
theorem projectLocal4DOperator_eq_projectLayered
    {U : Type*} [Fintype U] (C : FiniteCausalOrder U) (ell : Real) :
    projectLocal4DOperator C ell =
      C.layeredOperator (-sourceLocal4DPrefactor ell) (-1)
        sourceLocal4DCoefficient := by
  funext phi x
  unfold projectLocal4DOperator sourceLocal4DOperator
    FiniteCausalOrder.layeredOperator
  ring

/-- The corrected pairing of the actual project-local operator on the
five-event order is the realized weighted-difference form. -/
theorem fiveEventProjectLocal_correctedPairing_eq_weightedDifferenceForm
    (ell : Real) (f h : zeroSumFieldSubspace (Fin 5)) :
    correctedPairingAt
        (projectLocal4DOperator fiveEventLorentzOrder ell) 4 f.1 h.1 =
      weightedDifferenceForm (fiveEventProjectLocalWeight ell) 4 f.1 h.1 := by
  rw [projectLocal4DOperator_eq_projectLayered]
  exact correctedPairingAt_layeredOperator_eq_weightedDifferenceForm
    fiveEventLorentzOrder (-sourceLocal4DPrefactor ell) (-1)
      sourceLocal4DCoefficient 4 f.1 h.1

/-- The actual local causal coefficients give an orthogonal Gram matrix with
one positive coefficient and three equal negative coefficients. -/
theorem fiveEventProjectLocal_differenceProbe_gram
    (ell : Real) (i j : Fin 4) :
    correctedPairingAt
        (projectLocal4DOperator fiveEventLorentzOrder ell) 4
        (fiveEventDifferenceProbe i).1 (fiveEventDifferenceProbe j).1 =
      if i = j then
        if i = 0 then (4 : Real) * sourceLocal4DPrefactor ell
        else -(1 / 2 : Real) * sourceLocal4DPrefactor ell
      else 0 := by
  rw [fiveEventProjectLocal_correctedPairing_eq_weightedDifferenceForm,
    fiveEventDifferenceProbe_gram_diagonal]
  rcases fiveEventProjectLocalWeight_values ell with
    ⟨h0, h1, h2, h3, h4⟩
  have hvalue (k : Fin 4) :
      fiveEventProjectLocalWeight ell (fourToFive k) =
        if k = 0 then 8 * sourceLocal4DPrefactor ell
        else -sourceLocal4DPrefactor ell := by
    fin_cases k
    · simpa [fourToFive] using h0
    · simpa [fourToFive] using h1
    · simpa [fourToFive] using h2
    · simpa [fourToFive] using h3
  rw [hvalue]
  by_cases hij : i = j
  · subst j
    simp
    by_cases hi0 : i = 0
    · simp [hi0]
      ring
    · simp [hi0]
  · simp [hij]

/-- A nonzero local discreteness scale makes the explicit Gram matrix strictly
mostly-minus: one positive diagonal entry and three negative ones. -/
theorem fiveEventProjectLocal_differenceProbe_signs
    (ell : Real) (hell : ell ≠ 0) :
    0 < correctedPairingAt
        (projectLocal4DOperator fiveEventLorentzOrder ell) 4
        (fiveEventDifferenceProbe 0).1 (fiveEventDifferenceProbe 0).1 ∧
    correctedPairingAt
        (projectLocal4DOperator fiveEventLorentzOrder ell) 4
        (fiveEventDifferenceProbe 1).1 (fiveEventDifferenceProbe 1).1 < 0 ∧
    correctedPairingAt
        (projectLocal4DOperator fiveEventLorentzOrder ell) 4
        (fiveEventDifferenceProbe 2).1 (fiveEventDifferenceProbe 2).1 < 0 ∧
    correctedPairingAt
        (projectLocal4DOperator fiveEventLorentzOrder ell) 4
        (fiveEventDifferenceProbe 3).1 (fiveEventDifferenceProbe 3).1 < 0 := by
  have hprefactor : 0 < sourceLocal4DPrefactor ell := by
    unfold sourceLocal4DPrefactor
    positivity
  rw [fiveEventProjectLocal_differenceProbe_gram,
    fiveEventProjectLocal_differenceProbe_gram,
    fiveEventProjectLocal_differenceProbe_gram,
    fiveEventProjectLocal_differenceProbe_gram]
  norm_num [Fin.ext_iff]
  exact hprefactor

end PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.weightedDifferenceForm_eq_differenceCoordinates' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.weightedDifferenceForm_eq_differenceCoordinates

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.differenceCoordinates_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.differenceCoordinates_injective

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventDifferenceBasis_gram_eq_eta' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventDifferenceBasis_gram_eq_eta

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventProjectLocalWeight_values' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventProjectLocalWeight_values

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventLorentzDiamond_closedCarrier_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventLorentzDiamond_closedCarrier_card

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventProjectLocal_differenceProbe_gram' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventProjectLocal_differenceProbe_gram

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventProjectLocal_differenceProbe_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates.fiveEventProjectLocal_differenceProbe_signs
