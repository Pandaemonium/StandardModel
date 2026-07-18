import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
import PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights
import PhysicsSM.Draft.NullEdge.RankFourCarrierProbeSector

/-!
# Marked Alexandrov shell and conditional mostly-minus inertia

At a marked evaluation event `x`, the zero-open-interval past layer `L_0(x)`
is the immediate-predecessor shell. This module proves that it is an exact
antichain, is disjoint from the proposed positive radial support
`L_1(x) union L_3(x)`, and is transported exactly by finite causal-order
isomorphisms.

The module then proves the algebraic core of the shell-angular `1+3`
proposal. A nonzero time probe supported on the positive radial layers has
positive corrected norm. Three difference-coordinate independent probes
supported on the constant-negative immediate-predecessor shell span a
negative-definite coefficient space. Disjoint support makes the time-space
cross block exactly zero. The capstone states this split directly for the
project-local corrected pairing.

These are conditional finite identities. They do not construct the time
probe or spatial projector, prove a spectral triplet gap, normalize a selected
rank-four sector to the exact Minkowski matrix, establish overlap transport,
or recover continuum Lorentz invariance or general relativity.

Claim grade: `M [orig/comp]`, finite order and corrected-pairing algebra.
The focused proofs were supplied by Aristotle jobs
`4da526c9-e7dd-4607-8c1a-6f8365723d77` and
`868e1d04-83f0-4ffc-8f54-e68dad67d13a`, then replayed locally and adapted to
the existing project definitions without statement weakening.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia

open PhysicsSM.Draft.NullEdge.AlexandrovAlgebraGerm
open PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator
open PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellWeights
open PhysicsSM.Draft.NullEdge.RankFourProbeSector

/-! ## Exact order-theoretic shell gates -/

variable {V W : Type*} [Fintype V] [Fintype W]

/-- A finite set is an antichain when no ordered pair of its elements is
causally related. Quantifying over all ordered pairs includes both directions. -/
def IsAntichain
    (C : FiniteCausalOrder V) (S : Finset V) : Prop :=
  forall y, y ∈ S -> forall z, z ∈ S -> Not (C.before y z)

/-- Two immediate predecessors of one event cannot be causally related. -/
theorem pastLayer_zero_no_before
    (C : FiniteCausalOrder V) (x y z : V)
    (hy : y ∈ C.pastLayer x 0) (hz : z ∈ C.pastLayer x 0) :
    Not (C.before y z) := by
  have hy' : C.before y x ∧ C.openIntervalCount y x = 0 := by
    simpa [FiniteCausalOrder.pastLayer] using hy
  have hz' : C.before z x ∧ C.openIntervalCount z x = 0 := by
    simpa [FiniteCausalOrder.pastLayer] using hz
  intro hyz
  have hpositive : 0 < C.openIntervalCount y x := by
    apply Fintype.card_pos_iff.mpr
    exact ⟨⟨z, hyz, hz'.1⟩⟩
  exact (Nat.ne_of_gt hpositive) hy'.2

/-- The immediate-predecessor shell is an exact antichain. -/
theorem pastLayer_zero_isAntichain
    (C : FiniteCausalOrder V) (x : V) :
    IsAntichain C (C.pastLayer x 0) := by
  intro y hy z hz
  exact pastLayer_zero_no_before C x y z hy hz

/-- Distinct interval-count layers are disjoint. -/
theorem pastLayer_disjoint_of_ne
    (C : FiniteCausalOrder V) (x : V) {m n : Nat} (hmn : m ≠ n) :
    Disjoint (C.pastLayer x m) (C.pastLayer x n) := by
  rw [Finset.disjoint_left]
  intro y hym hyn
  have hm : C.openIntervalCount y x = m := by
    have hm' : C.before y x ∧ C.openIntervalCount y x = m := by
      simpa [FiniteCausalOrder.pastLayer] using hym
    exact hm'.2
  have hn : C.openIntervalCount y x = n := by
    have hn' : C.before y x ∧ C.openIntervalCount y x = n := by
      simpa [FiniteCausalOrder.pastLayer] using hyn
    exact hn'.2
  exact hmn (hm.symm.trans hn)

/-- The negative immediate-predecessor shell is disjoint from the proposed
positive radial support on layers one and three. -/
theorem pastLayer_zero_disjoint_one_union_three
    [DecidableEq V] (C : FiniteCausalOrder V) (x : V) :
    Disjoint (C.pastLayer x 0)
      (C.pastLayer x 1 ∪ C.pastLayer x 3) := by
  rw [Finset.disjoint_union_right]
  exact ⟨pastLayer_disjoint_of_ne C x (by omega),
    pastLayer_disjoint_of_ne C x (by omega)⟩

/-- Membership in every past layer is exactly equivariant under relabeling. -/
theorem OrderIso.mem_pastLayer_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (x y : V) (n : Nat) :
    e.toEquiv y ∈ D.pastLayer (e.toEquiv x) n ↔
      y ∈ C.pastLayer x n := by
  unfold FiniteCausalOrder.pastLayer
  simp [OrderIso.openIntervalCount_eq, e.map_before_iff]

/-! ## Conditional support and inertia algebra -/

/-- Difference coordinate based at `x`. -/
def basedDifference {U : Type*} (x : U) (f : U -> Real) (y : U) : Real :=
  f y - f x

/-- All nonzero based-difference coordinates of `f` lie in `S`. -/
def BasedSupportedOn {U : Type*} [DecidableEq U]
    (x : U) (S : Finset U) (f : U -> Real) : Prop :=
  forall y, y ∉ S -> basedDifference x f y = 0

/-- Linear combination of three spatial probes. -/
def spatialCombination {U : Type*}
    (a : Fin 3 -> Real) (space : Fin 3 -> U -> Real) : U -> Real :=
  fun y => ∑ i, a i * space i y

/-- One positive line orthogonal to a negative-definite three-dimensional
coefficient space. This is the exact conditional `(+---)` split needed before
normalization to a Minkowski frame. -/
def HasConditionalMostlyMinusSplit
    {U : Type*} [Fintype U]
    (weight : U -> Real) (x : U)
    (time : U -> Real) (space : Fin 3 -> U -> Real) : Prop :=
  0 < weightedDifferenceForm weight x time time ∧
    (forall i, weightedDifferenceForm weight x time (space i) = 0) ∧
    forall a : Fin 3 -> Real, a ≠ 0 ->
      weightedDifferenceForm weight x
        (spatialCombination a space) (spatialCombination a space) < 0

/-- Based differences commute with the displayed spatial linear combination. -/
theorem basedDifference_spatialCombination
    {U : Type*} (x y : U) (a : Fin 3 -> Real)
    (space : Fin 3 -> U -> Real) :
    basedDifference x (spatialCombination a space) y =
      ∑ i, a i * basedDifference x (space i) y := by
  unfold basedDifference spatialCombination
  simp [Finset.sum_sub_distrib, mul_sub]

/-- Disjoint based-difference supports make the weighted cross term exactly
zero, independently of the values of the weights. -/
theorem weightedDifferenceForm_cross_zero_of_disjoint
    {U : Type*} [Fintype U] [DecidableEq U]
    (weight : U -> Real) (x : U) (S T : Finset U)
    (hdisjoint : Disjoint S T) (f h : U -> Real)
    (hf : BasedSupportedOn x S f) (hh : BasedSupportedOn x T h) :
    weightedDifferenceForm weight x f h = 0 := by
  have hzero : forall y, (f y - f x) * (h y - h x) = 0 := by
    intro y
    by_cases hyS : y ∈ S <;> by_cases hyT : y ∈ T <;>
      simp_all [Finset.disjoint_left, BasedSupportedOn, basedDifference]
  unfold weightedDifferenceForm
  apply mul_eq_zero_of_right
  apply Finset.sum_eq_zero
  intro y _
  rw [mul_assoc, hzero y, mul_zero]

/-- A nonzero probe supported where every weight is positive has positive
corrected norm. -/
theorem weightedDifferenceForm_pos_of_positive_support
    {U : Type*} [Fintype U] [DecidableEq U]
    (weight : U -> Real) (x : U) (T : Finset U) (f : U -> Real)
    (hweight : forall y, y ∈ T -> 0 < weight y)
    (hf : BasedSupportedOn x T f)
    (hnonzero : exists y, y ∈ T ∧ basedDifference x f y ≠ 0) :
    0 < weightedDifferenceForm weight x f f := by
  obtain ⟨y, hyT, hy⟩ := hnonzero
  refine mul_pos (by norm_num) ?_
  rw [Finset.sum_eq_add_sum_diff_singleton (Finset.mem_univ y)]
  refine add_pos_of_pos_of_nonneg ?_ (Finset.sum_nonneg fun z _ => ?_)
  · simpa only [mul_assoc, ← sq] using
      mul_pos (hweight y hyT) (sq_pos_of_ne_zero hy)
  · by_cases hzT : z ∈ T
    · nlinarith [hweight z hzT, mul_self_nonneg (f z - f x)]
    · have hz := hf z hzT
      simp [basedDifference] at hz
      simp [hz]

/-- A difference-coordinate independent spatial triple supported on a
constant negative shell has a negative-definite coefficient Gram form. -/
theorem weightedDifferenceForm_spatial_negative
    {U : Type*} [Fintype U] [DecidableEq U]
    (weight : U -> Real) (x : U) (S : Finset U)
    (spaceScale : Real) (hscale : 0 < spaceScale)
    (space : Fin 3 -> U -> Real)
    (hweight : forall y, y ∈ S -> weight y = -spaceScale)
    (hsupport : forall i, BasedSupportedOn x S (space i))
    (hindependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ S ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    forall a : Fin 3 -> Real, a ≠ 0 ->
      weightedDifferenceForm weight x
        (spatialCombination a space) (spatialCombination a space) < 0 := by
  intro a ha
  obtain ⟨y, hyS, hy⟩ :
      exists y, y ∈ S ∧ basedDifference x (spatialCombination a space) y ≠ 0 := by
    simpa only [basedDifference_spatialCombination] using hindependent a ha
  have hnegative :
      ∑ y, weight y * basedDifference x (spatialCombination a space) y *
          basedDifference x (spatialCombination a space) y < 0 := by
    have hnegativeOnShell :
        ∑ y ∈ S, weight y * basedDifference x (spatialCombination a space) y *
            basedDifference x (spatialCombination a space) y < 0 := by
      rw [Finset.sum_eq_add_sum_diff_singleton hyS]
      exact add_neg_of_neg_of_nonpos
        (by rw [hweight y hyS]; nlinarith [mul_self_pos.2 hy])
        (Finset.sum_nonpos fun z hz => by
          rw [hweight z (Finset.mem_sdiff.1 hz).1]
          nlinarith [mul_self_nonneg
            (basedDifference x (spatialCombination a space) z)])
    rw [← Finset.sum_subset (Finset.subset_univ S)]
    · exact hnegativeOnShell
    · intro z _ hz
      have houtside :
          basedDifference x (spatialCombination a space) z = 0 := by
        rw [basedDifference_spatialCombination]
        apply Finset.sum_eq_zero
        intro i _
        rw [hsupport i z hz, mul_zero]
      simp [houtside]
  exact mul_neg_of_pos_of_neg (by norm_num) hnegative

/-- Positive radial support, constant-negative shell support, disjointness,
and explicit nondegeneracy imply the exact conditional mostly-minus split. -/
theorem shellAngular_hasConditionalMostlyMinusSplit
    {U : Type*} [Fintype U] [DecidableEq U]
    (weight : U -> Real) (x : U) (shell radial : Finset U)
    (spaceScale : Real) (hscale : 0 < spaceScale)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (hdisjoint : Disjoint shell radial)
    (hshellWeight : forall y, y ∈ shell -> weight y = -spaceScale)
    (hradialWeight : forall y, y ∈ radial -> 0 < weight y)
    (htimeSupport : BasedSupportedOn x radial time)
    (hspaceSupport : forall i, BasedSupportedOn x shell (space i))
    (htimeNonzero : exists y, y ∈ radial ∧ basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ shell ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    HasConditionalMostlyMinusSplit weight x time space := by
  refine ⟨weightedDifferenceForm_pos_of_positive_support weight x radial time
      hradialWeight htimeSupport htimeNonzero, ?_, ?_⟩
  · exact fun i => weightedDifferenceForm_cross_zero_of_disjoint
      weight x radial shell hdisjoint.symm time (space i)
      htimeSupport (hspaceSupport i)
  · exact weightedDifferenceForm_spatial_negative weight x shell spaceScale
      hscale space hshellWeight hspaceSupport hspaceIndependent

/-! ## Exact diagonal normalization in the selected-sector API -/

/-- A diagonal four-frame Gram matrix with one positive time scale and one
common positive magnitude for the three negative spatial entries. -/
def diagonalMostlyMinusGram
    (timeNorm spaceNorm : Real) : Matrix (Fin 4) (Fin 4) Real :=
  fun i j =>
    if i = j then if i = 0 then timeNorm else -spaceNorm else 0

/-- A supplied orthogonal mostly-minus selected-sector frame with positive
diagonal scales can be rescaled to the exact project Minkowski matrix. This
normalizes an existing frame; it does not construct the selected sector or
prove that a shell selector yields an orthogonal frame. -/
theorem hasSectorLorentzianInertia_of_diagonalMostlyMinus
    {U : Type} [Fintype U]
    {C : FiniteCausalOrder U} (A : MarkedDiamond C)
    (P : RankFourCarrierProbeSector A)
    (ell nonlocalityScale : Real) (x : ClosedCarrier A)
    (b : SectorFrame P) (timeNorm spaceNorm : Real)
    (htime : 0 < timeNorm) (hspace : 0 < spaceNorm)
    (hgram : sectorGram A P ell nonlocalityScale x b =
      diagonalMostlyMinusGram timeNorm spaceNorm) :
    HasSectorLorentzianInertia A P ell nonlocalityScale x := by
  refine ⟨b.unitsSMul fun i =>
    Units.mk0 (1 / Real.sqrt (if i = 0 then timeNorm else spaceNorm)) (by
      split_ifs <;> positivity), ?_⟩
  unfold IsSectorLorentzNormalized
  ext i j
  rw [sectorGram_apply]
  simp only [Module.Basis.unitsSMul_apply, Units.smul_def]
  rw [← sectorBilinForm_apply]
  rw [map_smul, map_smul, LinearMap.smul_apply]
  simp only [smul_eq_mul, sectorBilinForm_apply]
  have hentry := congr_fun (congr_fun hgram i) j
  rw [← sectorGram_apply, hentry]
  fin_cases i <;> fin_cases j <;>
    simp +decide [MinkowskiConvention.eta, diagonalMostlyMinusGram]
  all_goals
    ring_nf
    norm_num [htime.le, hspace.le, htime.ne', hspace.ne']

/-! ## Bridge to the actual project-local corrected pairing -/

/-- The corrected pairing of the project-sign local operator is exactly the
project-local marked-shell weighted-difference form. -/
theorem correctedPairingAt_projectLocal4D_eq_weightedDifferenceForm
    {U : Type*} [Fintype U]
    (C : FiniteCausalOrder U) (ell : Real) (x : U) (f h : U -> Real) :
    correctedPairingAt (projectLocal4DOperator C ell) x f h =
      weightedDifferenceForm (projectLocalPastWeight C ell x) x f h := by
  rw [projectLocal4DOperator_eq_projectLayered]
  simpa [projectLocalPastWeight] using
    correctedPairingAt_layeredOperator_eq_weightedDifferenceForm
      C (-sourceLocal4DPrefactor ell) (-1)
        sourceLocal4DCoefficient x f h

/-- Conditional mostly-minus split stated directly for the actual
project-local corrected pairing. -/
def HasProjectLocalConditionalMostlyMinusSplit
    {U : Type*} [Fintype U]
    (C : FiniteCausalOrder U) (ell : Real) (x : U)
    (time : U -> Real) (space : Fin 3 -> U -> Real) : Prop :=
  0 < correctedPairingAt (projectLocal4DOperator C ell) x time time ∧
    (forall i, correctedPairingAt (projectLocal4DOperator C ell) x
      time (space i) = 0) ∧
    forall a : Fin 3 -> Real, a ≠ 0 ->
      correctedPairingAt (projectLocal4DOperator C ell) x
        (spatialCombination a space) (spatialCombination a space) < 0

/-- **Project-local shell-angular inertia.** At nonzero scale, a nonzero time
probe supported on `L_1 union L_3` and a difference-coordinate independent
spatial triple supported on `L_0` have one positive line, a negative-definite
three-space, and an exactly zero cross block under the actual project-local
corrected pairing. -/
theorem projectLocal_shellAngular_hasConditionalMostlyMinusSplit
    {U : Type*} [Fintype U] [DecidableEq U]
    (C : FiniteCausalOrder U) (ell : Real) (hell : ell ≠ 0) (x : U)
    (time : U -> Real) (space : Fin 3 -> U -> Real)
    (htimeSupport : BasedSupportedOn x
      (C.pastLayer x 1 ∪ C.pastLayer x 3) time)
    (hspaceSupport : forall i,
      BasedSupportedOn x (C.pastLayer x 0) (space i))
    (htimeNonzero : exists y,
      y ∈ C.pastLayer x 1 ∪ C.pastLayer x 3 ∧
        basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ C.pastLayer x 0 ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    HasProjectLocalConditionalMostlyMinusSplit C ell x time space := by
  have hprefactor : 0 < sourceLocal4DPrefactor ell := by
    unfold sourceLocal4DPrefactor
    positivity
  have hsplit := shellAngular_hasConditionalMostlyMinusSplit
    (projectLocalPastWeight C ell x) x (C.pastLayer x 0)
      (C.pastLayer x 1 ∪ C.pastLayer x 3)
      (sourceLocal4DPrefactor ell) hprefactor time space
      (pastLayer_zero_disjoint_one_union_three C x)
      (fun y hy => projectLocalPastWeight_layer_zero C ell x y hy)
      (fun y hy =>
        projectLocalPastWeight_pos_on_one_union_three C ell hell x y hy)
      htimeSupport hspaceSupport htimeNonzero hspaceIndependent
  rcases hsplit with ⟨htime, hcross, hspace⟩
  refine ⟨?_, ?_, ?_⟩
  · rw [correctedPairingAt_projectLocal4D_eq_weightedDifferenceForm]
    exact htime
  · intro i
    rw [correctedPairingAt_projectLocal4D_eq_weightedDifferenceForm]
    exact hcross i
  · intro a ha
    rw [correctedPairingAt_projectLocal4D_eq_weightedDifferenceForm]
    exact hspace a ha

end PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.pastLayer_zero_isAntichain' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.pastLayer_zero_isAntichain

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.OrderIso.mem_pastLayer_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.OrderIso.mem_pastLayer_iff

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.hasSectorLorentzianInertia_of_diagonalMostlyMinus' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.hasSectorLorentzianInertia_of_diagonalMostlyMinus

/-- info: 'PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.projectLocal_shellAngular_hasConditionalMostlyMinusSplit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia.projectLocal_shellAngular_hasConditionalMostlyMinusSplit
