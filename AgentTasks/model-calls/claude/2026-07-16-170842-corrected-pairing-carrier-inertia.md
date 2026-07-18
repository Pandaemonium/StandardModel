# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-16T17:08:33`
- Finished: `2026-07-16T17:08:42`
- Timeout seconds: `900`
- Max budget USD: `2.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are independently auditing one finite Lean theorem in the StandardModel null-edge GR program. The broader program is speculative; the theorem must be judged only by its exact kernel statement and definitions.

Current gate: the raw retarded polynomial-selector route has a proved nilpotent no-go. The active escape uses the production corrected pairing on the zero-sum carrier probe subspace. A concrete five-event three-arm marked diamond was proved to have project-local Gram diagonal (4s,-s/2,-s/2,-s/2), with s = sourceLocal4DPrefactor ell > 0. The new exact theorem is:
fiveEventLorentzDiamond_hasLorentzianInertia (ell : Real) (hell : ell != 0) :
  HasLorentzianInertia fiveEventLorentzDiamond ell ell (carrierTop fiveEventLorentzDiamond).

Audit the verbatim Lean sources embedded below. Check:
1. The theorem really targets the existing production HasLorentzianInertia and MinkowskiConvention.eta, rather than a replacement predicate.
2. The marked diamond and carrier are nonvacuous and the transported basis spans the actual production carrierProbeSubspace.
3. Equal-scale projectSmeared4DOperator is correctly reduced to the project-local operator with the active sign convention.
4. Corrected-pairing equivariance and basis transport preserve the exact Gram matrix.
5. Basis.unitsSMul uses nonzero reciprocal-square-root units and the scalar algebra really normalizes to (+---).
6. There is no statement weakening, hidden new assumption, placeholder, false-shape theorem, or prose overclaim.
7. State precise scope exclusions: this finite witness does not establish canonical carrier selection, genericity, overlap/refinement persistence, or continuum GR.

Return exactly one verdict, APPROVED or BLOCKED, followed by concise findings ordered by severity. If approved, explicitly identify any residual interpretation risks. Cite exact declaration names and source lines where useful. Do not edit files.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/CorrectedPairingCarrierInertiaWitness.lean (126 lines)

```lean
import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
import PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-!
# Five-event carrier Lorentz-inertia normalization target

`CorrectedPairingDifferenceCoordinates.lean` constructs a genuine five-event
marked Alexandrov diamond and proves that the production project-local
corrected pairing has one positive and three negative diagonal entries in an
explicit basis.  This module isolates the remaining normalization statement
against the production carrier API.

The intended proof transports the explicit basis along
`fiveEventInducedOrderIso`, rescales its four vectors by nonzero real units,
uses equal nonzero scales to reduce the smeared operator to the local one, and
checks that the resulting carrier Gram matrix is exactly
`MinkowskiConvention.eta`.

This target does not derive a canonical carrier-selection rule, a spectral
gap, overlap compatibility, refinement persistence, or continuum convergence.

Claim grade: `M [orig]` finite witness.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness

open PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
open PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
open PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

/-- Transport the explicit five-event difference basis into the production
closed-carrier probe space. -/
def fiveEventCarrierProbeBasis : CarrierProbeFrame fiveEventLorentzDiamond :=
  fiveEventDifferenceBasis.map
    (zeroSumProbeSector.spaceLinearEquiv fiveEventInducedOrderIso)

/-- The transported carrier basis has the same strict mostly-minus diagonal
Gram matrix at equal nonzero scales. -/
theorem fiveEventCarrierProbeBasis_gram
    (ell : Real) (hell : ell ≠ 0) (i j : Fin 4) :
    carrierProbePairing fiveEventLorentzDiamond ell ell
        (carrierTop fiveEventLorentzDiamond)
        (fiveEventCarrierProbeBasis i) (fiveEventCarrierProbeBasis j) =
      if i = j then
        if i = 0 then (4 : Real) * sourceLocal4DPrefactor ell
        else -(1 / 2 : Real) * sourceLocal4DPrefactor ell
      else 0 := by
  have hsmeared :
      projectSmeared4DOperator
          (inducedOrder fiveEventLorentzDiamond) ell ell =
        projectLocal4DOperator
          (inducedOrder fiveEventLorentzDiamond) ell := by
    funext phi x
    unfold projectSmeared4DOperator projectLocal4DOperator
    rw [sourceSmeared4DOperator_same_scale _ _ hell]
  unfold carrierProbePairing
  rw [hsmeared]
  change correctedPairingAt
      (projectLocal4DOperator
        (inducedOrder fiveEventLorentzDiamond) ell)
      (fiveEventInducedOrderIso.toEquiv 4)
      (fiveEventInducedOrderIso.relabelField
        (fiveEventDifferenceBasis i).1)
      (fiveEventInducedOrderIso.relabelField
        (fiveEventDifferenceBasis j).1) = _
  rw [fiveEventInducedOrderIso.correctedPairingAt_projectLocal4D_equivariant]
  simpa [fiveEventDifferenceBasis] using
    fiveEventProjectLocal_differenceProbe_gram ell i j

/-- **Normalization target.** The concrete five-event marked carrier realizes
the production mostly-minus inertia predicate at equal nonzero scales. -/
theorem fiveEventLorentzDiamond_hasLorentzianInertia
    (ell : Real) (hell : ell ≠ 0) :
    HasLorentzianInertia fiveEventLorentzDiamond ell ell
      (carrierTop fiveEventLorentzDiamond) := by
  let s := sourceLocal4DPrefactor ell
  have hs : 0 < s := by
    dsimp [s, sourceLocal4DPrefactor]
    positivity
  let d : Fin 4 -> Real := fun i =>
    if i = 0 then Real.sqrt (4 * s) else Real.sqrt ((1 / 2 : Real) * s)
  have hd : forall i, d i ≠ 0 := by
    intro i
    dsimp [d]
    split_ifs
    · exact ne_of_gt (Real.sqrt_pos.2 (by nlinarith [hs]))
    · exact ne_of_gt (Real.sqrt_pos.2 (by nlinarith [hs]))
  let u : Fin 4 -> Units Real := fun i => (Units.mk0 (d i) (hd i))⁻¹
  refine ⟨fiveEventCarrierProbeBasis.unitsSMul u, ?_⟩
  unfold IsLorentzNormalized
  ext i j
  rw [carrierProbeGram_apply]
  simp only [Module.Basis.unitsSMul_apply, Units.smul_def]
  rw [← carrierProbeBilinForm_apply]
  rw [map_smul, map_smul, LinearMap.smul_apply]
  simp only [smul_eq_mul, carrierProbeBilinForm_apply]
  rw [fiveEventCarrierProbeBasis_gram ell hell i j]
  fin_cases i <;> fin_cases j <;>
    simp [u, d, s, MinkowskiConvention.eta]
  all_goals
    have hsqrt_s_ne : Real.sqrt (sourceLocal4DPrefactor ell) ≠ 0 :=
      ne_of_gt (Real.sqrt_pos.2 hs)
    have hsqrt_s_sq :
        Real.sqrt (sourceLocal4DPrefactor ell) *
            Real.sqrt (sourceLocal4DPrefactor ell) =
          sourceLocal4DPrefactor ell :=
      Real.mul_self_sqrt hs.le
    have hsqrt_two_sq : Real.sqrt (2 : Real) * Real.sqrt 2 = 2 :=
      Real.mul_self_sqrt (by norm_num)
    have hsqrt_four : Real.sqrt (4 : Real) = 2 := by norm_num
    try rw [hsqrt_four]
    field_simp [hsqrt_s_ne]
    nlinarith

end PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness.fiveEventLorentzDiamond_hasLorentzianInertia' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingCarrierInertiaWitness.fiveEventLorentzDiamond_hasLorentzianInertia

```

### PhysicsSM/Draft/NullEdge/CorrectedPairingDifferenceCoordinates.lean (489 lines)

```lean
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

```

### PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean (390 lines)

```lean
import PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace
import PhysicsSM.Draft.NullEdge.MinkowskiConvention

/-!
# Gauge-relative four-probe frames and Lorentzian carrier forms

`IntrinsicProbeSubspace.lean` shows that a scalar-probe subspace can be natural
under every finite-order isomorphism even when no ordered list of nonzero
probes can be selected pointwise naturally. This module supplies the next
finite tetrad bridge.

The active smeared causal operator is first bundled as a real-linear map. Its
corrected principal-symbol pairing therefore becomes a genuine symmetric
bilinear form on each closed Alexandrov carrier's zero-sum probe subspace. A
four-probe frame is a basis of that subspace indexed by `Fin 4`, and its Gram
matrix is the matrix of the corrected bilinear form in that basis.

Mathlib's change-of-basis theorem then gives the exact congruence law

`G_c = M^T G_b M`.

Consequently, if one frame normalizes the pairing to the project convention
`eta = diag(1,-1,-1,-1)`, a second frame has the same normalization exactly
when its transition matrix is `eta`-orthogonal. Thus a successful four-mode
operator reconstruction determines a Lorentz gauge class of probe frames,
not a preferred tetrad. The existence of such a normalized frame is also
preserved and reflected by every ambient causal-order isomorphism.

This is a finite conditional reconstruction theorem. It does not prove that a
four-probe frame exists on physical refinement carriers, that the corrected
form has Lorentzian inertia there, or that either object converges to a smooth
cotangent frame and metric.

Claim grade: `M [orig]` for the finite linearity, congruence, gauge, and
order-covariance statements. Provenance: program-internal composition of the
active Benincasa-Dowker operator, the intrinsic probe-subspace bridge,
Mathlib's bilinear-form change-of-basis theorem, and the project's
`MinkowskiConvention` grounded in Mathlib's `indefiniteDiagonal`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator
open IntrinsicProbeSubspace
open Matrix

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## The active operator as a linear map -/

/-- The layered past sum is additive in its scalar field. -/
theorem layeredPastSum_add_real
    (C : FiniteCausalOrder V) (coefficient : Nat → ℝ)
    (f h : V → ℝ) (x : V) :
    C.layeredPastSum coefficient (f + h) x =
      C.layeredPastSum coefficient f x +
        C.layeredPastSum coefficient h x := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hbefore : C.before y x <;> simp [hbefore, mul_add]

/-- The layered past sum is homogeneous in its scalar field. -/
theorem layeredPastSum_smul_real
    (C : FiniteCausalOrder V) (coefficient : Nat → ℝ)
    (c : ℝ) (f : V → ℝ) (x : V) :
    C.layeredPastSum coefficient (c • f) x =
      c * C.layeredPastSum coefficient f x := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro y _
  by_cases hbefore : C.before y x <;> simp [hbefore]
  ring

/-- Every real layered operator is a linear map on finite scalar fields. -/
def layeredOperatorLinearMap
    (C : FiniteCausalOrder V) (prefactor diagonal : ℝ)
    (coefficient : Nat → ℝ) : (V → ℝ) →ₗ[ℝ] (V → ℝ) where
  toFun := C.layeredOperator prefactor diagonal coefficient
  map_add' f h := by
    funext x
    unfold FiniteCausalOrder.layeredOperator
    rw [layeredPastSum_add_real]
    simp only [Pi.add_apply]
    ring
  map_smul' c f := by
    funext x
    change C.layeredOperator prefactor diagonal coefficient (c • f) x =
      c * C.layeredOperator prefactor diagonal coefficient f x
    unfold FiniteCausalOrder.layeredOperator
    rw [layeredPastSum_smul_real]
    simp only [Pi.smul_apply, smul_eq_mul]
    ring

/-- Linear-map packaging of the source-native local four-dimensional
operator. -/
def sourceLocal4DLinearMap (C : FiniteCausalOrder V) (ell : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  layeredOperatorLinearMap C (sourceLocal4DPrefactor ell) (-1)
    sourceLocal4DCoefficient

/-- Linear-map packaging of the source-native smeared four-dimensional
operator, including its equal-scale branch. -/
def sourceSmeared4DLinearMap
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  if smearingEpsilon ell nonlocalityScale = 1 then
    sourceLocal4DLinearMap C ell
  else
    layeredOperatorLinearMap C
      (4 / (Real.sqrt 6 * nonlocalityScale ^ 2)) (-1)
      (sourceSmeared4DCoefficient
        (smearingEpsilon ell nonlocalityScale))

/-- Linear-map packaging of the active project-sign smeared operator. -/
def projectSmeared4DLinearMap
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) :
    (V → ℝ) →ₗ[ℝ] (V → ℝ) :=
  -sourceSmeared4DLinearMap C ell nonlocalityScale

/-- The bundled linear map has exactly the previously defined active operator
as its underlying function. -/
@[simp] theorem projectSmeared4DLinearMap_apply
    (C : FiniteCausalOrder V) (ell nonlocalityScale : ℝ) (f : V → ℝ) :
    projectSmeared4DLinearMap C ell nonlocalityScale f =
      projectSmeared4DOperator C ell nonlocalityScale f := by
  ext x
  simp only [projectSmeared4DLinearMap, sourceSmeared4DLinearMap,
    sourceLocal4DLinearMap, layeredOperatorLinearMap,
    projectSmeared4DOperator, sourceSmeared4DOperator,
    LinearMap.neg_apply, Pi.neg_apply]
  split_ifs <;> rfl

/-! ## Corrected pairing as a symmetric bilinear form -/

/-- A linear finite-field operator produces a bilinear corrected pairing at
each event. -/
def correctedPairingBilinFormAt
    (B : (V → ℝ) →ₗ[ℝ] (V → ℝ)) (x : V) :
    LinearMap.BilinForm ℝ (V → ℝ) :=
  LinearMap.mk₂ ℝ (fun f h => correctedPairingAt B x f h)
    (by
      intro f g h
      simp [correctedPairingAt, add_mul]
      ring)
    (by
      intro c f h
      simp [correctedPairingAt]
      ring)
    (by
      intro f h k
      simp [correctedPairingAt, mul_add]
      ring)
    (by
      intro c f h
      simp [correctedPairingAt]
      ring)

omit [Fintype V] in
/-- The bilinear packaging evaluates to the original corrected pairing. -/
@[simp] theorem correctedPairingBilinFormAt_apply
    (B : (V → ℝ) →ₗ[ℝ] (V → ℝ)) (x : V) (f h : V → ℝ) :
    correctedPairingBilinFormAt B x f h = correctedPairingAt B x f h :=
  rfl

/-- The active corrected pairing restricted to one carrier's natural probe
subspace, as a genuine bilinear form. -/
def carrierProbeBilinForm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    LinearMap.BilinForm ℝ (carrierProbeSubspace A) :=
  (correctedPairingBilinFormAt
      (projectSmeared4DLinearMap (inducedOrder A) ell nonlocalityScale) x).comp
    (carrierProbeSubspace A).subtype (carrierProbeSubspace A).subtype

/-- The carrier bilinear form is definitionally the existing basis-free
carrier pairing. -/
@[simp] theorem carrierProbeBilinForm_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbeBilinForm A ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x f h := by
  change correctedPairingAt
      (⇑(projectSmeared4DLinearMap (inducedOrder A) ell nonlocalityScale))
      x f.1 h.1 =
    correctedPairingAt
      (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
      x f.1 h.1
  congr 1
  funext u
  exact projectSmeared4DLinearMap_apply
    (inducedOrder A) ell nonlocalityScale u

/-- The active carrier form is symmetric. -/
theorem carrierProbeBilinForm_isSymm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    (carrierProbeBilinForm A ell nonlocalityScale x).IsSymm := by
  refine LinearMap.BilinForm.isSymm_def.mpr (fun f h => ?_)
  simp only [carrierProbeBilinForm_apply]
  exact carrierProbePairing_comm A ell nonlocalityScale x f h

/-! ## Four-probe frames, Gram congruence, and Lorentz gauge -/

/-- A four-probe carrier frame is a basis of the natural probe subspace. Its
existence is a substantive rank-four condition. -/
abbrev CarrierProbeFrame
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :=
  Module.Basis (Fin 4) ℝ (carrierProbeSubspace A)

/-- Matrix of the active corrected pairing in a four-probe frame. -/
def carrierProbeGram
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Matrix (Fin 4) (Fin 4) ℝ :=
  LinearMap.BilinForm.toMatrix b
    (carrierProbeBilinForm A ell nonlocalityScale x)

/-- Entries of the frame Gram matrix are the corrected pairings of its probe
vectors. -/
theorem carrierProbeGram_apply
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) (i j : Fin 4) :
    carrierProbeGram A ell nonlocalityScale x b i j =
      carrierProbePairing A ell nonlocalityScale x (b i) (b j) := by
  simp [carrierProbeGram]

/-- **Exact tetrad change law.** Corrected-pairing matrices in any two
four-probe frames are related by matrix congruence. -/
theorem carrierProbeGram_change
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A) :
    (b.toMatrix c)ᵀ * carrierProbeGram A ell nonlocalityScale x b *
        b.toMatrix c =
      carrierProbeGram A ell nonlocalityScale x c := by
  exact LinearMap.BilinForm.toMatrix_mul_basis_toMatrix (b := b) c
    (carrierProbeBilinForm A ell nonlocalityScale x)

/-- A frame is Lorentz-normalized when the reconstructed pairing matrix is the
project's mostly-minus Minkowski matrix. -/
def IsLorentzNormalized
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) : Prop :=
  carrierProbeGram A ell nonlocalityScale x b =
    (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ)

/-- Basis-free Lorentzian-inertia gate: some four-probe frame normalizes the
active carrier form to `(+---)`. -/
def HasLorentzianInertia
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) : Prop :=
  ∃ b : CarrierProbeFrame A,
    IsLorentzNormalized A ell nonlocalityScale x b

/-- **Recovered local gauge group, conditional on the signature gate.** Once
one probe frame is Lorentz-normalized, another is Lorentz-normalized exactly
when their basis-change matrix is `eta`-orthogonal. -/
theorem isLorentzNormalized_change_iff
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b c : CarrierProbeFrame A)
    (hb : IsLorentzNormalized A ell nonlocalityScale x b) :
    IsLorentzNormalized A ell nonlocalityScale x c ↔
      (b.toMatrix c)ᵀ *
          (MinkowskiConvention.eta : Matrix (Fin 4) (Fin 4) ℝ) *
          b.toMatrix c = MinkowskiConvention.eta := by
  unfold IsLorentzNormalized at hb ⊢
  rw [← carrierProbeGram_change A ell nonlocalityScale x b c, hb]

/-- Lorentzian inertia implies nondegeneracy of the reconstructed carrier
bilinear form. -/
theorem carrierProbeBilinForm_nondegenerate_of_lorentzian
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (hLorentz : HasLorentzianInertia A ell nonlocalityScale x) :
    (carrierProbeBilinForm A ell nonlocalityScale x).Nondegenerate := by
  rcases hLorentz with ⟨b, hb⟩
  apply (LinearMap.BilinForm.nondegenerate_iff_det_ne_zero b).2
  change (carrierProbeGram A ell nonlocalityScale x b).det ≠ 0
  rw [hb, MinkowskiConvention.eta_det]
  norm_num

/-! ## Exact transport under causal-order isomorphism -/

/-- Push a four-probe frame along the intrinsic carrier equivalence. -/
def mapCarrierProbeFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (b : CarrierProbeFrame A) : CarrierProbeFrame (A.map e) :=
  b.map (carrierProbeLinearEquiv e A)

/-- Pull a four-probe frame back along the intrinsic carrier equivalence. -/
def pullCarrierProbeFrame
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (b : CarrierProbeFrame (A.map e)) : CarrierProbeFrame A :=
  b.map (carrierProbeLinearEquiv e A).symm

/-- Pushing a frame along an order isomorphism leaves its corrected-pairing
matrix exactly unchanged. -/
theorem carrierProbeGram_mapOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame A) :
    carrierProbeGram (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) (mapCarrierProbeFrame e A b) =
      carrierProbeGram A ell nonlocalityScale x b := by
  ext i j
  rw [carrierProbeGram_apply, carrierProbeGram_apply]
  change carrierProbePairing (A.map e) ell nonlocalityScale
      (closedCarrierEquiv e A x)
      (carrierProbeLinearEquiv e A (b i))
      (carrierProbeLinearEquiv e A (b j)) =
    carrierProbePairing A ell nonlocalityScale x (b i) (b j)
  exact carrierProbePairing_equivariant e A ell nonlocalityScale x (b i) (b j)

/-- Pulling a target frame back along an order isomorphism also leaves its Gram
matrix exactly unchanged. -/
theorem carrierProbeGram_pullOrderIso
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (b : CarrierProbeFrame (A.map e)) :
    carrierProbeGram A ell nonlocalityScale x
        (pullCarrierProbeFrame e A b) =
      carrierProbeGram (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) b := by
  ext i j
  rw [carrierProbeGram_apply, carrierProbeGram_apply]
  change carrierProbePairing A ell nonlocalityScale x
      ((carrierProbeLinearEquiv e A).symm (b i))
      ((carrierProbeLinearEquiv e A).symm (b j)) =
    carrierProbePairing (A.map e) ell nonlocalityScale
      (closedCarrierEquiv e A x) (b i) (b j)
  symm
  simpa using carrierProbePairing_equivariant e A ell nonlocalityScale x
    ((carrierProbeLinearEquiv e A).symm (b i))
    ((carrierProbeLinearEquiv e A).symm (b j))

/-- The basis-free Lorentzian-inertia gate is exactly invariant under every
ambient causal-order isomorphism. -/
theorem hasLorentzianInertia_orderIso_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A) :
    HasLorentzianInertia (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x) ↔
      HasLorentzianInertia A ell nonlocalityScale x := by
  constructor
  · rintro ⟨b, hb⟩
    refine ⟨pullCarrierProbeFrame e A b, ?_⟩
    unfold IsLorentzNormalized at hb ⊢
    rw [carrierProbeGram_pullOrderIso]
    exact hb
  · rintro ⟨b, hb⟩
    refine ⟨mapCarrierProbeFrame e A b, ?_⟩
    unfold IsLorentzNormalized at hb ⊢
    rw [carrierProbeGram_mapOrderIso]
    exact hb

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.carrierProbeGram_change' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.carrierProbeGram_change

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.isLorentzNormalized_change_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.isLorentzNormalized_change_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.hasLorentzianInertia_orderIso_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge.hasLorentzianInertia_orderIso_iff

end PhysicsSM.Draft.NullEdge.ProbeFrameLorentzGauge

```

### PhysicsSM/Draft/NullEdge/IntrinsicProbeSubspace.lean (301 lines)

```lean
import PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator

/-!
# Intrinsic scalar-probe subspaces without a preferred basis

An individually natural ordered probe list is fixed pointwise by every order
automorphism.  `FiniteCausalOrderOperator.lean` already proves that such probes
are constant on automorphism-transitive orders.  This module implements the
required escape: a probe **subspace** is transported under relabeling, while a
basis inside that subspace is gauge-relative and need not be fixed.

The canonical finite example is the zero-sum scalar-field subspace.  Relabeling
is a linear equivalence of scalar-field spaces and preserves the total sum, so
the zero-sum subspace is exactly natural under every finite-order isomorphism.
On the five-event antichain this subspace has real dimension four.  In contrast,
every individually natural probe that is also zero-sum vanishes there.  This
is an exact positive/negative split: bare-order symmetry permits a rank-four
probe space but forbids a canonical ordered basis of nonzero probes.

For a closed Alexandrov carrier, the same subspace feeds directly into the
induced smeared causal-operator corrected pairing.  The pairing is symmetric
and relabels exactly with the subspace.  No basis, coordinates, tetrad, or
target metric enters this statement.

The five-event antichain is a representation-theoretic control, not a physical
spacetime reconstruction.  Rank four there follows from carrier cardinality,
not causal dimension, and the module proves neither Lorentzian signature nor
slowly varying affine probes on a refinement family.

Claim grade: `M [orig]` for the finite linear-algebra and covariance results.
Provenance: program-internal response to the intrinsic ordered-probe
automorphism obstruction in `FiniteCausalOrderOperator.lean`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

open scoped BigOperators

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator

variable {V W : Type} [Fintype V] [Fintype W]

/-! ## Linear relabeling and zero-sum fields -/

/-- Relabeling scalar fields along an order isomorphism is a real-linear
equivalence. -/
def fieldRelabelLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : (V → ℝ) ≃ₗ[ℝ] (W → ℝ) where
  toFun := e.relabelField
  invFun := (reverseOrderIso e).relabelField
  left_inv phi := by
    funext x
    simp [OrderIso.relabelField, reverseOrderIso]
  right_inv psi := by
    funext y
    simp [OrderIso.relabelField, reverseOrderIso]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-- Total scalar-field sum as a linear functional. -/
def fieldSumLinearMap (U : Type*) [Fintype U] : (U → ℝ) →ₗ[ℝ] ℝ where
  toFun phi := ∑ x : U, phi x
  map_add' phi psi := by
    simp [Finset.sum_add_distrib]
  map_smul' c phi := by
    simp [Finset.mul_sum]

/-- Canonical codimension-one candidate probe space: scalar fields with zero
total sum. -/
def zeroSumFieldSubspace (U : Type*) [Fintype U] :
    Submodule ℝ (U → ℝ) :=
  LinearMap.ker (fieldSumLinearMap U)

/-- Relabeling preserves the total field sum. -/
theorem fieldSum_relabel
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (phi : V → ℝ) :
    fieldSumLinearMap W (e.relabelField phi) =
      fieldSumLinearMap V phi := by
  unfold fieldSumLinearMap
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro x
  simp only [OrderIso.relabelField_apply]

/-- Membership in the zero-sum subspace is exactly preserved by relabeling. -/
theorem mem_zeroSum_relabel_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (phi : V → ℝ) :
    e.relabelField phi ∈ zeroSumFieldSubspace W ↔
      phi ∈ zeroSumFieldSubspace V := by
  simp [zeroSumFieldSubspace, LinearMap.mem_ker, fieldSum_relabel]

/-! ## Basis-free intrinsic probe sectors -/

/-- A relabeling-natural scalar-probe subspace.  Unlike
`IntrinsicProbeSector`, this interface does not require individual basis
vectors to be fixed by automorphisms. -/
structure IntrinsicProbeSubspaceSector where
  space : ∀ {U : Type} [Fintype U],
    FiniteCausalOrder U → Submodule ℝ (U → ℝ)
  equivariant : ∀ {U Z : Type} [Fintype U] [Fintype Z]
    {C : FiniteCausalOrder U} {D : FiniteCausalOrder Z}
    (e : OrderIso C D) (phi : U → ℝ),
    phi ∈ @space U _ C ↔ e.relabelField phi ∈ @space Z _ D

/-- The zero-sum field assignment is an intrinsic probe-subspace sector. -/
def zeroSumProbeSector : IntrinsicProbeSubspaceSector where
  space := fun {U} _ _ => zeroSumFieldSubspace U
  equivariant := fun e phi => (mem_zeroSum_relabel_iff e phi).symm

/-- The subspace-level covariance law can equivalently be stated as exact
equality after `Submodule.map`. -/
theorem IntrinsicProbeSubspaceSector.map_space_eq
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) :
    (P.space C).map (fieldRelabelLinearEquiv e).toLinearMap =
      P.space D := by
  ext psi
  constructor
  · rintro ⟨phi, hphi, rfl⟩
    exact (P.equivariant e phi).1 hphi
  · intro hpsi
    let phi : V → ℝ := (fieldRelabelLinearEquiv e).symm psi
    have hphi : phi ∈ P.space C := by
      apply (P.equivariant e phi).2
      change fieldRelabelLinearEquiv e
        ((fieldRelabelLinearEquiv e).symm psi) ∈ P.space D
      simpa using hpsi
    exact ⟨phi, hphi, by simp [phi]⟩

/-- Relabeling restricts to a linear equivalence between the two natural
probe subspaces. -/
def IntrinsicProbeSubspaceSector.spaceLinearEquiv
    (P : IntrinsicProbeSubspaceSector)
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) : P.space C ≃ₗ[ℝ] P.space D where
  toFun phi := ⟨e.relabelField phi.1, (P.equivariant e phi.1).1 phi.2⟩
  invFun psi :=
    ⟨(reverseOrderIso e).relabelField psi.1,
      (P.equivariant (reverseOrderIso e) psi.1).1 psi.2⟩
  left_inv phi := by
    apply Subtype.ext
    funext x
    simp [OrderIso.relabelField, reverseOrderIso]
  right_inv psi := by
    apply Subtype.ext
    funext y
    simp [OrderIso.relabelField, reverseOrderIso]
  map_add' _ _ := rfl
  map_smul' _ _ := rfl

/-! ## Symmetric controls and the rank-four split -/

/-- The antichain on five events, with full permutation symmetry. -/
def fiveEventAntichain : FiniteCausalOrder (Fin 5) where
  before := fun _ _ => False
  decidableBefore := inferInstance
  irrefl := by simp
  trans := by simp

/-- Every event of the five-event antichain lies in one automorphism orbit. -/
theorem fiveEventAntichain_automorphismTransitive :
    fiveEventAntichain.AutomorphismTransitive := by
  intro x y
  let swap : Fin 5 ≃ Fin 5 := Equiv.swap x y
  refine ⟨{
    toEquiv := swap
    map_before_iff := ?_
  }, ?_⟩
  · intro a b
    simp [fiveEventAntichain]
  · simp [swap]

/-- The total-sum functional on five events is onto. -/
theorem finFive_fieldSum_surjective :
    Function.Surjective (fieldSumLinearMap (Fin 5)) := by
  intro value
  refine ⟨fun x => if x = 0 then value else 0, ?_⟩
  simp [fieldSumLinearMap]

/-- The canonical zero-sum probe subspace on five events has dimension four. -/
theorem finrank_fiveEvent_zeroSum :
    Module.finrank ℝ (zeroSumFieldSubspace (Fin 5)) = 4 := by
  have hrange : LinearMap.range (fieldSumLinearMap (Fin 5)) = ⊤ :=
    LinearMap.range_eq_top.2 finFive_fieldSum_surjective
  have hrank :=
    LinearMap.finrank_range_add_finrank_ker (fieldSumLinearMap (Fin 5))
  rw [hrange] at hrank
  simp [zeroSumFieldSubspace] at hrank ⊢
  omega

/-- On the same symmetric order, an individually natural probe that is also
zero-sum must vanish pointwise. -/
theorem intrinsicProbe_zero_of_fiveEvent_meanZero
    {r : Nat} (P : IntrinsicProbeSector r) (a : Fin r)
    (hzeroSum : P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) (x : Fin 5) :
    P.probe fiveEventAntichain a x = 0 := by
  have hconstant : ∀ y : Fin 5,
      P.probe fiveEventAntichain a y =
        P.probe fiveEventAntichain a 0 := by
    intro y
    exact P.probe_constant_of_automorphismTransitive fiveEventAntichain
      fiveEventAntichain_automorphismTransitive a y 0
  have hsum :
      (∑ y : Fin 5, P.probe fiveEventAntichain a y) = 0 := by
    exact hzeroSum
  simp_rw [hconstant] at hsum
  have hbase : P.probe fiveEventAntichain a 0 = 0 := by
    norm_num at hsum ⊢
    exact hsum
  rw [hconstant x, hbase]

/-- The positive/negative split on the five-event symmetric control: the
natural zero-sum subspace has rank four, while every individually natural
zero-sum probe vanishes. -/
theorem fiveEvent_rankFour_subspace_but_no_natural_vectors
    {r : Nat} (P : IntrinsicProbeSector r)
    (hzeroSum : ∀ a, P.probe fiveEventAntichain a ∈
      zeroSumFieldSubspace (Fin 5)) :
    Module.finrank ℝ (zeroSumProbeSector.space fiveEventAntichain) = 4 ∧
      ∀ a x, P.probe fiveEventAntichain a x = 0 := by
  constructor
  · exact finrank_fiveEvent_zeroSum
  · intro a x
    exact intrinsicProbe_zero_of_fiveEvent_meanZero P a (hzeroSum a) x

/-! ## Basis-free carrier pairing -/

/-- Zero-sum probe subspace on one closed Alexandrov carrier. -/
def carrierProbeSubspace
    {C : FiniteCausalOrder V} (A : MarkedDiamond C) :
    Submodule ℝ (ClosedCarrier A → ℝ) :=
  zeroSumFieldSubspace (ClosedCarrier A)

/-- Corrected causal-operator pairing restricted to the basis-free carrier
probe subspace. -/
def carrierProbePairing
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) : ℝ :=
  correctedPairingAt
    (projectSmeared4DOperator (inducedOrder A) ell nonlocalityScale)
    x f.1 h.1

/-- The restricted pairing remains symmetric without a chosen probe basis. -/
theorem carrierProbePairing_comm
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbePairing A ell nonlocalityScale x f h =
      carrierProbePairing A ell nonlocalityScale x h f := by
  exact correctedPairingAt_comm _ _ _ _

/-- Relabeling equivalence between zero-sum probe subspaces of isomorphic
closed carriers. -/
def carrierProbeLinearEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C) :
    carrierProbeSubspace A ≃ₗ[ℝ] carrierProbeSubspace (A.map e) :=
  zeroSumProbeSector.spaceLinearEquiv (inducedOrderIso e A)

/-- The basis-free carrier pairing is exactly covariant under ambient order
isomorphisms. -/
theorem carrierProbePairing_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (A : MarkedDiamond C)
    (ell nonlocalityScale : ℝ) (x : ClosedCarrier A)
    (f h : carrierProbeSubspace A) :
    carrierProbePairing (A.map e) ell nonlocalityScale
        (closedCarrierEquiv e A x)
        (carrierProbeLinearEquiv e A f)
        (carrierProbeLinearEquiv e A h) =
      carrierProbePairing A ell nonlocalityScale x f h := by
  exact OrderIso.correctedPairingAt_projectSmeared4D_equivariant
    (inducedOrderIso e A) ell nonlocalityScale x f.1 h.1

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.IntrinsicProbeSubspaceSector.map_space_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.IntrinsicProbeSubspaceSector.map_space_eq

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.fiveEvent_rankFour_subspace_but_no_natural_vectors' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.fiveEvent_rankFour_subspace_but_no_natural_vectors

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.carrierProbePairing_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace.carrierProbePairing_equivariant

end PhysicsSM.Draft.NullEdge.IntrinsicProbeSubspace

```

### PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean (611 lines)

```lean
import PhysicsSM.Draft.NullEdge.CausalOperatorMetric

/-!
# Finite causal-order construction of the scalar metric operator

This module closes one finite boundary in the operator-first GR program: the
operator is constructed from a strict finite causal order and open-interval
cardinalities instead of being supplied as an arbitrary map.

For a finite order `C`, `openIntervalCount C y x` counts events strictly
between `y` and `x`. The generic `layeredOperator` weights every causal
predecessor by a function of this count. Its four-dimensional local and
smeared specializations implement the Benincasa-Dowker coefficients. The
source-sign operator is the Benincasa-Dowker `(-+++)` formula. At the purely
algebraic level, each project-facing operator is defined to be its exact
negative, encoding the intended overall wave-operator sign change for the
project `(+---)` convention. No metric, curvature-sign convention, or
continuum-limit identification is proved here.

Every construction is equivariant under an isomorphism of finite causal
orders, at fixed numerical scales and with scalar fields transported by the
carrier equivalence. This proves invariance under event relabeling that
preserves the order relation. The definitions take no embedding argument, but
the covariance theorems do not compare embeddings or transport scale
assignments, probe-selection rules, a manifold embedding, a tetrad, or a spin
structure. The local normalization also has exact inverse-length-squared
scaling under the stated nonzero algebraic hypotheses; physical scale choices
remain additional positive inputs.

The final section lifts the corrected principal-symbol pairing to actual
finite scalar fields. This is the application-level counterpart of the
pointwise scalar algebra in `CausalOperatorMetric`. At a common probe zero it
also identifies twice the pairing with the operator response on the probe
product, the exact algebraic anchor for quadratic-moment normalization.

Scope boundary: the order, dimension-four kernel, positive scales, scalar
fields, and probe fields remain inputs. This file does not derive a
manifoldlike phase, density, a scale-selection rule, compact probes, rank,
signature, volume agreement, or continuum convergence.

Provenance: clean-room formalization of equations (2), (8), and (9) of
D. M. T. Benincasa and F. Dowker, arXiv:1001.2725, with the continuum
convention cross-check from A. Belenchia, D. M. T. Benincasa, and F. Dowker,
arXiv:1510.04656. Claim grade: `M [comp]` for the finite algebra and
covariance; continuum reconstruction remains conjectural and separately
gated.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-! ## Finite strict causal orders and their intervals -/

/-- A finite strict causal order. Irreflexivity and transitivity exclude
directed causal cycles. -/
structure FiniteCausalOrder (V : Type*) [Fintype V] where
  before : V -> V -> Prop
  decidableBefore : DecidableRel before
  irrefl : forall x, ¬ before x x
  trans : forall {x y z}, before x y -> before y z -> before x z

instance {V : Type*} [Fintype V] (C : FiniteCausalOrder V) :
    DecidableRel C.before :=
  C.decidableBefore

variable {V W : Type*} [Fintype V] [Fintype W]

/-- The subtype of events strictly between `y` and `x`. -/
def FiniteCausalOrder.OpenInterval
    (C : FiniteCausalOrder V) (y x : V) :=
  {z : V // C.before y z ∧ C.before z x}

instance (C : FiniteCausalOrder V) (y x : V) :
    Fintype (C.OpenInterval y x) := by
  unfold FiniteCausalOrder.OpenInterval
  infer_instance

/-- Number of events in the strict open interval from `y` to `x`. -/
def FiniteCausalOrder.openIntervalCount
    (C : FiniteCausalOrder V) (y x : V) : Nat :=
  Fintype.card (C.OpenInterval y x)

/-- The `n`th past layer of `x`: predecessors with exactly `n` intervening
events. -/
def FiniteCausalOrder.pastLayer
    (C : FiniteCausalOrder V) (x : V) (n : Nat) : Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ C.openIntervalCount y x = n

/-- An isomorphism of finite causal orders. -/
structure OrderIso (C : FiniteCausalOrder V) (D : FiniteCausalOrder W) where
  toEquiv : V ≃ W
  map_before_iff : forall x y,
    D.before (toEquiv x) (toEquiv y) ↔ C.before x y

/-- An order isomorphism induces an equivalence of every open interval. -/
def OrderIso.openIntervalEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    C.OpenInterval y x ≃
      D.OpenInterval (e.toEquiv y) (e.toEquiv x) where
  toFun z := ⟨e.toEquiv z.1,
    (e.map_before_iff y z.1).2 z.property.1,
    (e.map_before_iff z.1 x).2 z.property.2⟩
  invFun z := ⟨e.toEquiv.symm z.1,
    (e.map_before_iff y (e.toEquiv.symm z.1)).1
      (by simpa using z.property.1),
    (e.map_before_iff (e.toEquiv.symm z.1) x).1
      (by simpa using z.property.2)⟩
  left_inv z := by
    apply Subtype.ext
    simp
  right_inv z := by
    apply Subtype.ext
    simp

/-- Open-interval cardinality is intrinsic to the finite order. -/
theorem OrderIso.openIntervalCount_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    D.openIntervalCount (e.toEquiv y) (e.toEquiv x) =
      C.openIntervalCount y x := by
  exact (Fintype.card_congr (e.openIntervalEquiv y x)).symm

/-- Relabel a scalar field along an order isomorphism. -/
def OrderIso.relabelField
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) : W -> K :=
  fun w => phi (e.toEquiv.symm w)

@[simp] theorem OrderIso.relabelField_apply
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} (phi : V -> K) (x : V) :
    e.relabelField phi (e.toEquiv x) = phi x := by
  simp [OrderIso.relabelField]

/-! ## Layered order/count operators -/

/-- Weighted sum over all strict causal predecessors. The weight may depend
only on the open-interval count. -/
def FiniteCausalOrder.layeredPastSum
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (coefficient : Nat -> K) (phi : V -> K) (x : V) : K :=
  ∑ y : V, if C.before y x then
    coefficient (C.openIntervalCount y x) * phi y else 0

/-- A normalized diagonal-plus-past layered operator. -/
def FiniteCausalOrder.layeredOperator
    {K : Type*} [Semiring K] (C : FiniteCausalOrder V)
    (prefactor diagonal : K) (coefficient : Nat -> K)
    (phi : V -> K) (x : V) : K :=
  prefactor * (diagonal * phi x + C.layeredPastSum coefficient phi x)

/-- The weighted past sum commutes with every order isomorphism. -/
theorem OrderIso.layeredPastSum_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} [Semiring K]
    (coefficient : Nat -> K) (phi : V -> K) (x : V) :
    D.layeredPastSum coefficient (e.relabelField phi) (e.toEquiv x) =
      C.layeredPastSum coefficient phi x := by
  unfold FiniteCausalOrder.layeredPastSum
  symm
  apply Fintype.sum_equiv e.toEquiv
  intro y
  by_cases hbefore : C.before y x
  · have hmap : D.before (e.toEquiv y) (e.toEquiv x) :=
      (e.map_before_iff y x).2 hbefore
    simp [hbefore, hmap, e.openIntervalCount_eq]
  · have hmap : ¬ D.before (e.toEquiv y) (e.toEquiv x) :=
      fun h => hbefore ((e.map_before_iff y x).1 h)
    simp [hbefore, hmap]

/-- Every layered operator commutes with order isomorphisms. -/
theorem OrderIso.layeredOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) {K : Type*} [Semiring K]
    (prefactor diagonal : K) (coefficient : Nat -> K)
    (phi : V -> K) (x : V) :
    D.layeredOperator prefactor diagonal coefficient
        (e.relabelField phi) (e.toEquiv x) =
      C.layeredOperator prefactor diagonal coefficient phi x := by
  unfold FiniteCausalOrder.layeredOperator
  rw [e.layeredPastSum_equivariant]
  simp

/-! ## Four-dimensional Benincasa-Dowker specializations -/

/-- Source-native local four-dimensional layer coefficients, indexed by open
interval cardinality. -/
def sourceLocal4DCoefficient : Nat -> Real
  | 0 => 1
  | 1 => -9
  | 2 => 16
  | 3 => -8
  | _ => 0

/-- Source-native four-dimensional normalization. -/
def sourceLocal4DPrefactor (ell : Real) : Real :=
  4 / (Real.sqrt 6 * ell ^ 2)

/-- Local source-native four-dimensional causal-set d'Alembertian. -/
def sourceLocal4DOperator
    (C : FiniteCausalOrder V) (ell : Real)
    (phi : V -> Real) (x : V) : Real :=
  C.layeredOperator (sourceLocal4DPrefactor ell) (-1)
    sourceLocal4DCoefficient phi x

/-- Project `(+---)` local operator, obtained by negating the source-native
`(-+++)` operator. -/
def projectLocal4DOperator
    (C : FiniteCausalOrder V) (ell : Real)
    (phi : V -> Real) (x : V) : Real :=
  -sourceLocal4DOperator C ell phi x

/-- Mesoscopic smearing ratio `epsilon = (ell / L)^4`. -/
def smearingEpsilon (ell nonlocalityScale : Real) : Real :=
  (ell / nonlocalityScale) ^ 4

/-- Broad-layer kernel from source equation (9). -/
def sourceSmearedKernel (epsilon : Real) (n : Nat) : Real :=
  let nr : Real := n
  (1 - epsilon) ^ n *
    (1 - 9 * epsilon * nr / (1 - epsilon) +
      8 * epsilon ^ 2 * nr * (nr - 1) / (1 - epsilon) ^ 2 -
      (4 / 3) * epsilon ^ 3 * nr * (nr - 1) * (nr - 2) /
        (1 - epsilon) ^ 3)

/-- Full source-native broad-layer weight, including the leading `epsilon`. -/
def sourceSmeared4DCoefficient (epsilon : Real) (n : Nat) : Real :=
  epsilon * sourceSmearedKernel epsilon n

/-- Smeared source-native operator. The explicit branch at `epsilon = 1`
records the source statement that the smeared operator reduces to the local
one, avoiding a spurious totalized-division value in equation (9). -/
def sourceSmeared4DOperator
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) : Real :=
  let epsilon := smearingEpsilon ell nonlocalityScale
  if epsilon = 1 then sourceLocal4DOperator C ell phi x
  else C.layeredOperator
    (4 / (Real.sqrt 6 * nonlocalityScale ^ 2)) (-1)
    (sourceSmeared4DCoefficient epsilon) phi x

/-- Project `(+---)` smeared operator. -/
def projectSmeared4DOperator
    (C : FiniteCausalOrder V) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) : Real :=
  -sourceSmeared4DOperator C ell nonlocalityScale phi x

/-- The source-native local operator is intrinsic under order relabeling. -/
theorem OrderIso.sourceLocal4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell : Real) (phi : V -> Real) (x : V) :
    sourceLocal4DOperator D ell (e.relabelField phi) (e.toEquiv x) =
      sourceLocal4DOperator C ell phi x := by
  exact e.layeredOperator_equivariant _ _ _ _ _

/-- The project-sign local operator is intrinsic under order relabeling. -/
theorem OrderIso.projectLocal4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell : Real) (phi : V -> Real) (x : V) :
    projectLocal4DOperator D ell (e.relabelField phi) (e.toEquiv x) =
      projectLocal4DOperator C ell phi x := by
  unfold projectLocal4DOperator
  rw [e.sourceLocal4DOperator_equivariant]

/-- The source-native smeared operator is intrinsic under order relabeling. -/
theorem OrderIso.sourceSmeared4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) :
    sourceSmeared4DOperator D ell nonlocalityScale
        (e.relabelField phi) (e.toEquiv x) =
      sourceSmeared4DOperator C ell nonlocalityScale phi x := by
  simp only [sourceSmeared4DOperator]
  by_cases hepsilon : smearingEpsilon ell nonlocalityScale = 1
  · simp only [hepsilon, if_true]
    exact e.sourceLocal4DOperator_equivariant ell phi x
  · simp only [hepsilon, if_false]
    exact e.layeredOperator_equivariant _ _ _ _ _

/-- The project-sign smeared operator is intrinsic under order relabeling. -/
theorem OrderIso.projectSmeared4DOperator_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell nonlocalityScale : Real)
    (phi : V -> Real) (x : V) :
    projectSmeared4DOperator D ell nonlocalityScale
        (e.relabelField phi) (e.toEquiv x) =
      projectSmeared4DOperator C ell nonlocalityScale phi x := by
  unfold projectSmeared4DOperator
  rw [e.sourceSmeared4DOperator_equivariant]

/-- Equal nonzero discreteness and nonlocality scales reduce the smeared
operator exactly to the local operator. -/
theorem sourceSmeared4DOperator_same_scale
    (C : FiniteCausalOrder V) (ell : Real) (hell : ell ≠ 0)
    (phi : V -> Real) (x : V) :
    sourceSmeared4DOperator C ell ell phi x =
      sourceLocal4DOperator C ell phi x := by
  have hepsilon : smearingEpsilon ell ell = 1 := by
    simp [smearingEpsilon, hell]
  simp [sourceSmeared4DOperator, hepsilon]

/-- The local prefactor has exact inverse-square scale weight. -/
theorem sourceLocal4DPrefactor_scale
    (lambda ell : Real) (hlambda : lambda ≠ 0) (hell : ell ≠ 0) :
    sourceLocal4DPrefactor (lambda * ell) =
      (lambda ^ 2)⁻¹ * sourceLocal4DPrefactor ell := by
  have hsqrt : Real.sqrt 6 ≠ 0 :=
    ne_of_gt (Real.sqrt_pos.2 (by norm_num))
  unfold sourceLocal4DPrefactor
  field_simp [hlambda, hell, hsqrt]

/-- The local source operator inherits inverse-square scale weight. -/
theorem sourceLocal4DOperator_scale
    (C : FiniteCausalOrder V) (lambda ell : Real)
    (hlambda : lambda ≠ 0) (hell : ell ≠ 0)
    (phi : V -> Real) (x : V) :
    sourceLocal4DOperator C (lambda * ell) phi x =
      (lambda ^ 2)⁻¹ * sourceLocal4DOperator C ell phi x := by
  unfold sourceLocal4DOperator FiniteCausalOrder.layeredOperator
  rw [sourceLocal4DPrefactor_scale lambda ell hlambda hell]
  ring

/-! ## Corrected principal-symbol pairing on finite scalar fields -/

/-- Corrected pairing evaluated at one event for an operator on finite scalar
fields. Pointwise multiplication is the probe-algebra product. -/
def correctedPairingAt
    (B : (V -> Real) -> V -> Real) (x : V)
    (f h : V -> Real) : Real :=
  (2 : Real)⁻¹ *
    (B (f * h) x - f x * B h x - h x * B f x +
      f x * h x * B 1 x)

/-- Add a pointwise scalar potential to a finite scalar-field operator. -/
def addScalarPotentialField
    (B : (V -> Real) -> V -> Real) (potential : V -> Real) :
    (V -> Real) -> V -> Real :=
  fun f x => B f x + potential x * f x

omit [Fintype V] in
/-- The corrected finite-field pairing is symmetric for every operator. -/
theorem correctedPairingAt_comm
    (B : (V -> Real) -> V -> Real) (x : V) (f h : V -> Real) :
    correctedPairingAt B x f h = correctedPairingAt B x h f := by
  unfold correctedPairingAt
  rw [mul_comm f h]
  ring

omit [Fintype V] in
/-- At a common zero of two probes, twice the corrected pairing is exactly the
operator response on their pointwise product. This is the finite algebra behind
quadratic-moment normalization; obtaining a geometric normalization still
requires a justified probe and a convergent operator response. -/
theorem operator_mul_eq_two_correctedPairingAt_of_centered
    (B : (V -> Real) -> V -> Real) (x : V) (f h : V -> Real)
    (hf : f x = 0) (hh : h x = 0) :
    B (f * h) x = 2 * correctedPairingAt B x f h := by
  unfold correctedPairingAt
  simp only [hf, hh, zero_mul, mul_zero, sub_zero]
  ring

omit [Fintype V] in
/-- Pointwise scalar potentials cancel exactly from the finite-field pairing. -/
theorem correctedPairingAt_addScalarPotentialField
    (B : (V -> Real) -> V -> Real) (potential : V -> Real)
    (x : V) (f h : V -> Real) :
    correctedPairingAt (addScalarPotentialField B potential) x f h =
      correctedPairingAt B x f h := by
  unfold correctedPairingAt addScalarPotentialField
  simp only [Pi.mul_apply, Pi.one_apply]
  ring

/-- Any finite scalar-field operator that commutes with an order isomorphism
has an intrinsic corrected pairing under simultaneous relabeling of the event
and both probes. -/
theorem OrderIso.correctedPairingAt_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D)
    (operatorC : (V -> Real) -> V -> Real)
    (operatorD : (W -> Real) -> W -> Real)
    (hoperator : forall phi x,
      operatorD (e.relabelField phi) (e.toEquiv x) = operatorC phi x)
    (x : V) (f h : V -> Real) :
    correctedPairingAt operatorD (e.toEquiv x)
        (e.relabelField f) (e.relabelField h) =
      correctedPairingAt operatorC x f h := by
  have hmul :
      e.relabelField f * e.relabelField h = e.relabelField (f * h) := by
    rfl
  have hone : (1 : W -> Real) = e.relabelField (1 : V -> Real) := by
    funext w
    simp [OrderIso.relabelField]
  unfold correctedPairingAt
  rw [hmul, hoperator]
  rw [hoperator]
  rw [hoperator]
  rw [hone, hoperator]
  simp

/-- The corrected pairing built from the project local operator is intrinsic
under simultaneous relabeling of order, event, and probes. -/
theorem OrderIso.correctedPairingAt_projectLocal4D_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell : Real) (x : V) (f h : V -> Real) :
    correctedPairingAt (projectLocal4DOperator D ell) (e.toEquiv x)
        (e.relabelField f) (e.relabelField h) =
      correctedPairingAt (projectLocal4DOperator C ell) x f h := by
  apply e.correctedPairingAt_equivariant
  intro phi y
  exact e.projectLocal4DOperator_equivariant ell phi y

/-- The corrected pairing built from the project smeared operator is intrinsic
under simultaneous relabeling of order, event, and probes. -/
theorem OrderIso.correctedPairingAt_projectSmeared4D_equivariant
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (ell nonlocalityScale : Real)
    (x : V) (f h : V -> Real) :
    correctedPairingAt
        (projectSmeared4DOperator D ell nonlocalityScale) (e.toEquiv x)
        (e.relabelField f) (e.relabelField h) =
      correctedPairingAt
        (projectSmeared4DOperator C ell nonlocalityScale) x f h := by
  apply e.correctedPairingAt_equivariant
  intro phi y
  exact e.projectSmeared4DOperator_equivariant
    ell nonlocalityScale phi y

/-! ## Intrinsic probes and varying-carrier convergence -/

/-- A finite probe family selected naturally from the order under every order
isomorphism. This interface certifies label independence only; it does not say
that the probes are slowly varying, coordinate-like, independent, or
geometrically complete. -/
structure IntrinsicProbeSector (r : Nat) where
  probe : forall {U : Type} [Fintype U],
    FiniteCausalOrder U -> Fin r -> U -> Real
  equivariant : forall {U Z : Type} [Fintype U] [Fintype Z]
    {C : FiniteCausalOrder U} {D : FiniteCausalOrder Z}
    (e : OrderIso C D) (a : Fin r),
    e.relabelField (K := Real) (@probe U _ C a) = @probe Z _ D a

/-- A finite causal order is automorphism-transitive when every event can be
carried to every other event by an order automorphism. -/
def FiniteCausalOrder.AutomorphismTransitive
    (C : FiniteCausalOrder V) : Prop :=
  forall x y, exists e : OrderIso C C, e.toEquiv x = y

/-- Every individually natural probe is fixed pointwise along each order-
automorphism orbit. This is the finite obstruction to treating a canonical
probe list as a gauge-relative frame. -/
theorem IntrinsicProbeSector.probe_orderAutomorphism_invariant
    {r : Nat} (P : IntrinsicProbeSector r)
    {U : Type} [Fintype U]
    (C : FiniteCausalOrder U) (e : OrderIso C C)
    (a : Fin r) (x : U) :
    P.probe C a (e.toEquiv x) = P.probe C a x := by
  have h := congrFun (P.equivariant e a) (e.toEquiv x)
  simpa [OrderIso.relabelField] using h.symm

/-- On an automorphism-transitive order, every probe in an individually
natural probe family is constant. A physical probe sector on symmetric orders
must therefore be transported as a subspace up to basis change, rather than as
a pointwise-fixed ordered basis. -/
theorem IntrinsicProbeSector.probe_constant_of_automorphismTransitive
    {r : Nat} (P : IntrinsicProbeSector r)
    {U : Type} [Fintype U]
    (C : FiniteCausalOrder U) (htrans : C.AutomorphismTransitive)
    (a : Fin r) (x y : U) :
    P.probe C a x = P.probe C a y := by
  obtain ⟨e, he⟩ := htrans x y
  simpa [he] using
    (P.probe_orderAutomorphism_invariant C e a x).symm

/-- The two-event antichain is a concrete symmetric strict causal order. -/
def twoEventAntichain : FiniteCausalOrder (Fin 2) where
  before := fun _ _ => False
  decidableBefore := inferInstance
  irrefl := by simp
  trans := by simp

/-- Every event of the two-event antichain lies in one order-automorphism
orbit. This witnesses that the symmetry hypothesis in the probe no-go is
nonvacuous. -/
theorem twoEventAntichain_automorphismTransitive :
    twoEventAntichain.AutomorphismTransitive := by
  intro x y
  let swap : Fin 2 ≃ Fin 2 := Equiv.swap x y
  refine ⟨{
    toEquiv := swap
    map_before_iff := ?_
  }, ?_⟩
  · intro a b
    simp [twoEventAntichain]
  · simp [swap]

/-- Individually natural probes cannot distinguish the two distinct events of
the symmetric antichain. -/
theorem IntrinsicProbeSector.twoEventAntichain_probe_eq
    {r : Nat} (P : IntrinsicProbeSector r) (a : Fin r) :
    P.probe twoEventAntichain a 0 = P.probe twoEventAntichain a 1 := by
  exact P.probe_constant_of_automorphismTransitive
    twoEventAntichain twoEventAntichain_automorphismTransitive a 0 1

open Filter in
/-- Four-evaluation convergence for intrinsically selected probes on varying
finite carriers. The limit is constructed from the six displayed scalar
limits; no metric, product rule, rank, signature, or convergence premise is
hidden in the conclusion. -/
theorem tendsto_intrinsicProbePairing_projectSmeared4D
    {I : Type*} {l : Filter I} {r : Nat}
    {U : I -> Type} [forall i, Fintype (U i)]
    (C : forall i, FiniteCausalOrder (U i))
    (P : IntrinsicProbeSector r) (a b : Fin r)
    (ell nonlocalityScale : I -> Real) (x : forall i, U i)
    (f0 h0 qProd qRight qLeft qOne : Real)
    (hf : Tendsto (fun i => P.probe (C i) a (x i)) l (nhds f0))
    (hh : Tendsto (fun i => P.probe (C i) b (x i)) l (nhds h0))
    (hProd : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        (P.probe (C i) a * P.probe (C i) b) (x i)) l (nhds qProd))
    (hRight : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        (P.probe (C i) b) (x i)) l (nhds qRight))
    (hLeft : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        (P.probe (C i) a) (x i)) l (nhds qLeft))
    (hOne : Tendsto (fun i =>
      projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i)
        1 (x i)) l (nhds qOne)) :
    Tendsto (fun i => correctedPairingAt
        (projectSmeared4DOperator (C i) (ell i) (nonlocalityScale i))
        (x i) (P.probe (C i) a) (P.probe (C i) b)) l
      (nhds ((2 : Real)⁻¹ *
        (qProd - f0 * qRight - h0 * qLeft + f0 * h0 * qOne))) := by
  have hFRight := hf.mul hRight
  have hHLeft := hh.mul hLeft
  have hFHOne := (hf.mul hh).mul hOne
  have hBracket := ((hProd.sub hFRight).sub hHLeft).add hFHOne
  have hHalf :
      Tendsto (fun _ : I => (2 : Real)⁻¹) l (nhds (2 : Real)⁻¹) :=
    tendsto_const_nhds
  simpa only [correctedPairingAt, Pi.mul_apply, Pi.one_apply] using
    hHalf.mul hBracket

/-! ## Non-vacuity controls -/

/-- The strict order on two events is a concrete finite causal order. -/
def twoEventOrder : FiniteCausalOrder (Fin 2) where
  before := fun x y => x < y
  decidableBefore := inferInstance
  irrefl := fun x => lt_irrefl x
  trans := fun hxy hyz => lt_trans hxy hyz

/-- The unique causal link in the two-event order has an empty open interval. -/
theorem twoEvent_openIntervalCount :
    twoEventOrder.openIntervalCount 0 1 = 0 := by
  decide

/-- Scalar field supported on the first event of the two-event order. -/
def twoEventLinkedField : Fin 2 -> Real :=
  fun x => if x = 0 then 1 else 0

/-- The linked predecessor contributes exactly the first source layer
coefficient. This is a nonzero order/count witness for the operator kernel. -/
theorem twoEvent_layeredPastSum_witness :
    twoEventOrder.layeredPastSum sourceLocal4DCoefficient
      twoEventLinkedField 1 = 1 := by
  unfold FiniteCausalOrder.layeredPastSum
  rw [Fin.sum_univ_two, twoEvent_openIntervalCount]
  norm_num [twoEventOrder, twoEventLinkedField,
    sourceLocal4DCoefficient]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.openIntervalCount_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms OrderIso.openIntervalCount_eq

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.projectSmeared4DOperator_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms OrderIso.projectSmeared4DOperator_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.sourceLocal4DOperator_scale' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sourceLocal4DOperator_scale

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.twoEvent_layeredPastSum_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms twoEvent_layeredPastSum_witness

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.OrderIso.correctedPairingAt_projectSmeared4D_equivariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms OrderIso.correctedPairingAt_projectSmeared4D_equivariant

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.operator_mul_eq_two_correctedPairingAt_of_centered' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms operator_mul_eq_two_correctedPairingAt_of_centered

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.tendsto_intrinsicProbePairing_projectSmeared4D' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms tendsto_intrinsicProbePairing_projectSmeared4D

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator.IntrinsicProbeSector.probe_constant_of_automorphismTransitive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms IntrinsicProbeSector.probe_constant_of_automorphismTransitive

end PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
