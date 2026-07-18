import PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates

/-!
# Four-layer coherent-sector sign obstruction

The project-local four-dimensional causal coefficients are supported on open
interval counts `0, 1, 2, 3`, with values `1, -9, 16, -8`. A tempting
larger-carrier selector compresses every populated interval-count layer to one
coherent based-difference coordinate. In that compressed model, the weight of
coordinate `n` is the layer population times the project-sign local weight.

This module proves that the resulting corrected Gram form is diagonal and has
signs `(-,+,-,+)` whenever all four populations are positive. In particular,
it cannot have one positive diagonal direction and three negative diagonal
directions under any choice of distinguished coordinate. This is an exact
finite obstruction to that layer-coherent selector, not an obstruction to
other rank-four selectors.

The model is deliberately compressed: it records the Gram form of one
unnormalized indicator-difference coordinate per disjoint layer. It does not
construct layers from a causal order, select a spatial harmonic sector, prove a
spectral gap, or establish continuum convergence.

Claim grade: `M [orig]`, finite diagonal-form no-go.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo

open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceCoordinates
open PhysicsSM.Draft.NullEdge.CorrectedPairingDifferenceOperator
open PhysicsSM.Draft.NullEdge.FiniteCausalOrderOperator

/-- Aggregate project-local weight of one coherent coordinate for each of the
four supported interval-count layers. The fifth coordinate is the marked top
and has zero weight. -/
def layerCoherentProjectWeight
    (ell : Real) (population : Fin 4 -> Nat) : Fin 5 -> Real :=
  ![
    -(population 0 : Real) * sourceLocal4DPrefactor ell *
      sourceLocal4DCoefficient 0,
    -(population 1 : Real) * sourceLocal4DPrefactor ell *
      sourceLocal4DCoefficient 1,
    -(population 2 : Real) * sourceLocal4DPrefactor ell *
      sourceLocal4DCoefficient 2,
    -(population 3 : Real) * sourceLocal4DPrefactor ell *
      sourceLocal4DCoefficient 3,
    0
  ]

/-- Evaluating the aggregate weight at a layer coordinate recovers that
layer's population times the project-sign source coefficient. -/
theorem layerCoherentProjectWeight_fourToFive
    (ell : Real) (population : Fin 4 -> Nat) (i : Fin 4) :
    layerCoherentProjectWeight ell population (fourToFive i) =
      -(population i : Real) * sourceLocal4DPrefactor ell *
        sourceLocal4DCoefficient i := by
  fin_cases i <;>
    simp [layerCoherentProjectWeight, fourToFive,
      sourceLocal4DCoefficient]

/-- Corrected Gram matrix of the four compressed layer coordinates. -/
def layerCoherentGram
    (ell : Real) (population : Fin 4 -> Nat) :
    Matrix (Fin 4) (Fin 4) Real :=
  fun i j =>
    weightedDifferenceForm (layerCoherentProjectWeight ell population) 4
      (fiveEventDifferenceProbe i).1 (fiveEventDifferenceProbe j).1

/-- The coherent layer Gram is diagonal, with each diagonal entry equal to one
half of its aggregate project-local layer weight. -/
theorem layerCoherentGram_apply (ell : Real) (population : Fin 4 -> Nat)
    (i j : Fin 4) :
    layerCoherentGram ell population i j =
      if i = j then
        (2 : Real)⁻¹ *
          layerCoherentProjectWeight ell population (fourToFive i)
      else 0 := by
  exact fiveEventDifferenceProbe_gram_diagonal
    (layerCoherentProjectWeight ell population) i j

/-- Exact diagonal values inherited from the source-native coefficient row
`(1,-9,16,-8)` after the project-sign reversal. -/
theorem layerCoherentGram_diagonal_values
    (ell : Real) (population : Fin 4 -> Nat) :
    layerCoherentGram ell population 0 0 =
        -(1 / 2 : Real) * population 0 * sourceLocal4DPrefactor ell ∧
    layerCoherentGram ell population 1 1 =
        (9 / 2 : Real) * population 1 * sourceLocal4DPrefactor ell ∧
    layerCoherentGram ell population 2 2 =
        -(8 : Real) * population 2 * sourceLocal4DPrefactor ell ∧
    layerCoherentGram ell population 3 3 =
        (4 : Real) * population 3 * sourceLocal4DPrefactor ell := by
  constructor
  · rw [layerCoherentGram_apply, if_pos rfl,
      layerCoherentProjectWeight_fourToFive]
    norm_num [sourceLocal4DCoefficient]
    ring
  constructor
  · rw [layerCoherentGram_apply, if_pos rfl,
      layerCoherentProjectWeight_fourToFive]
    norm_num [sourceLocal4DCoefficient]
    ring
  constructor
  · rw [layerCoherentGram_apply, if_pos rfl,
      layerCoherentProjectWeight_fourToFive]
    norm_num [sourceLocal4DCoefficient]
    ring
  · rw [layerCoherentGram_apply, if_pos rfl,
      layerCoherentProjectWeight_fourToFive]
    norm_num [sourceLocal4DCoefficient]
    ring

/-- Positive populations force the exact diagonal sign profile
`(-,+,-,+)`. Thus the compressed four-layer form is balanced rather than
mostly minus. -/
theorem layerCoherentGram_signs
    (ell : Real) (population : Fin 4 -> Nat) (hell : ell ≠ 0)
    (hpopulation : forall i, 0 < population i) :
    layerCoherentGram ell population 0 0 < 0 ∧
    0 < layerCoherentGram ell population 1 1 ∧
    layerCoherentGram ell population 2 2 < 0 ∧
    0 < layerCoherentGram ell population 3 3 := by
  have hprefactor : 0 < sourceLocal4DPrefactor ell := by
    unfold sourceLocal4DPrefactor
    positivity
  have h0 : 0 < (population 0 : Real) := by
    exact_mod_cast hpopulation 0
  have h1 : 0 < (population 1 : Real) := by
    exact_mod_cast hpopulation 1
  have h2 : 0 < (population 2 : Real) := by
    exact_mod_cast hpopulation 2
  have h3 : 0 < (population 3 : Real) := by
    exact_mod_cast hpopulation 3
  rcases layerCoherentGram_diagonal_values ell population with
    ⟨hg0, hg1, hg2, hg3⟩
  rw [hg0, hg1, hg2, hg3]
  have hp0 : 0 < (population 0 : Real) * sourceLocal4DPrefactor ell :=
    mul_pos h0 hprefactor
  have hp1 : 0 < (population 1 : Real) * sourceLocal4DPrefactor ell :=
    mul_pos h1 hprefactor
  have hp2 : 0 < (population 2 : Real) * sourceLocal4DPrefactor ell :=
    mul_pos h2 hprefactor
  have hp3 : 0 < (population 3 : Real) * sourceLocal4DPrefactor ell :=
    mul_pos h3 hprefactor
  exact ⟨by nlinarith, by nlinarith, by nlinarith, by nlinarith⟩

/-- A diagonal sign test for a mostly-minus four-sector, allowing any one of
the four coordinates to be designated as the positive direction. -/
def HasOnePositiveThreeNegativeDiagonal
    (gram : Matrix (Fin 4) (Fin 4) Real) : Prop :=
  exists t, 0 < gram t t ∧ forall i, i ≠ t -> gram i i < 0

/-- **Layer-coherent no-go.** With every supported local layer populated, no
choice of one distinguished coordinate turns the coherent four-layer Gram into
a one-positive, three-negative diagonal form. -/
theorem layerCoherentGram_not_onePositiveThreeNegative
    (ell : Real) (population : Fin 4 -> Nat) (hell : ell ≠ 0)
    (hpopulation : forall i, 0 < population i) :
    ¬ HasOnePositiveThreeNegativeDiagonal
        (layerCoherentGram ell population) := by
  rcases layerCoherentGram_signs ell population hell hpopulation with
    ⟨_, hpositiveOne, _, hpositiveThree⟩
  rintro ⟨t, _, hnegative⟩
  by_cases ht : (1 : Fin 4) = t
  · subst t
    have hnegativeThree := hnegative 3 (by decide)
    linarith
  · have hnegativeOne := hnegative 1 ht
    linarith

end PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo.layerCoherentGram_apply' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo.layerCoherentGram_apply

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo.layerCoherentGram_signs' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo.layerCoherentGram_signs

/-- info: 'PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo.layerCoherentGram_not_onePositiveThreeNegative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.CorrectedPairingLayerCoherentNoGo.layerCoherentGram_not_onePositiveThreeNegative
