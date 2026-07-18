import Mathlib

/-!
# Conditional mostly-minus split from disjoint shell supports

Focused Mathlib-only package for the algebraic part of the marked-Alexandrov
`1+3` proposal. A time probe is supported on a positive-weight radial set and
three spatial probes are supported on a disjoint shell carrying one constant
negative weight. Difference-coordinate independence of the spatial triple and
nonvanishing of the time probe then imply one positive line, a negative-
definite three-dimensional coefficient space, and an exactly zero cross block.

This theorem does not construct the supports or probes, prove that a spectral
selector finds them, or establish typicality, stability, overlap transport,
Lorentz invariance, or continuum convergence.
-/

noncomputable section

namespace MarkedShellConditionalInertia

variable {V : Type*} [Fintype V] [DecidableEq V]

/-- Symmetric weighted finite-difference form based at `x`. -/
def weightedDifferenceForm
    (weight : V -> Real) (x : V) (f h : V -> Real) : Real :=
  (2 : Real)⁻¹ *
    ∑ y, weight y * (f y - f x) * (h y - h x)

/-- Difference coordinate based at `x`. -/
def basedDifference (x : V) (f : V -> Real) (y : V) : Real :=
  f y - f x

/-- All nonzero based-difference coordinates of `f` lie in `S`. -/
def BasedSupportedOn (x : V) (S : Finset V) (f : V -> Real) : Prop :=
  forall y, y ∉ S -> basedDifference x f y = 0

/-- Linear combination of three spatial probes. -/
def spatialCombination
    (a : Fin 3 -> Real) (s : Fin 3 -> V -> Real) : V -> Real :=
  fun y => ∑ i, a i * s i y

/-- One positive line orthogonal to a negative-definite three-dimensional
coefficient space. This is the exact conditional `(+---)` split needed before
normalization to a Minkowski frame. -/
def HasConditionalMostlyMinusSplit
    (weight : V -> Real) (x : V)
    (time : V -> Real) (space : Fin 3 -> V -> Real) : Prop :=
  0 < weightedDifferenceForm weight x time time ∧
    (forall i, weightedDifferenceForm weight x time (space i) = 0) ∧
    forall a : Fin 3 -> Real, a ≠ 0 ->
      weightedDifferenceForm weight x
        (spatialCombination a space) (spatialCombination a space) < 0

/-- Based differences commute with the displayed spatial linear combination. -/
theorem basedDifference_spatialCombination
    (x y : V) (a : Fin 3 -> Real) (space : Fin 3 -> V -> Real) :
    basedDifference x (spatialCombination a space) y =
      ∑ i, a i * basedDifference x (space i) y := by
  sorry

/-- Disjoint based-difference supports make the weighted cross term exactly
zero, independently of the values of the weights. -/
theorem weightedDifferenceForm_cross_zero_of_disjoint
    (weight : V -> Real) (x : V) (S T : Finset V)
    (hdisjoint : Disjoint S T) (f h : V -> Real)
    (hf : BasedSupportedOn x S f) (hh : BasedSupportedOn x T h) :
    weightedDifferenceForm weight x f h = 0 := by
  sorry

/-- A nonzero probe supported where every weight is positive has positive
corrected norm. -/
theorem weightedDifferenceForm_pos_of_positive_support
    (weight : V -> Real) (x : V) (T : Finset V) (f : V -> Real)
    (hweight : forall y, y ∈ T -> 0 < weight y)
    (hf : BasedSupportedOn x T f)
    (hnonzero : exists y, y ∈ T ∧ basedDifference x f y ≠ 0) :
    0 < weightedDifferenceForm weight x f f := by
  sorry

/-- A difference-coordinate independent spatial triple supported on a
constant negative shell has a negative-definite coefficient Gram form. -/
theorem weightedDifferenceForm_spatial_negative
    (weight : V -> Real) (x : V) (S : Finset V)
    (spaceScale : Real) (hscale : 0 < spaceScale)
    (space : Fin 3 -> V -> Real)
    (hweight : forall y, y ∈ S -> weight y = -spaceScale)
    (hsupport : forall i, BasedSupportedOn x S (space i))
    (hindependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ S ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    forall a : Fin 3 -> Real, a ≠ 0 ->
      weightedDifferenceForm weight x
        (spatialCombination a space) (spatialCombination a space) < 0 := by
  sorry

/-- Conditional shell-angular inertia theorem: positive radial support,
constant-negative shell support, disjointness, and explicit nondegeneracy imply
the exact one-positive/three-negative orthogonal split. -/
theorem shellAngular_hasConditionalMostlyMinusSplit
    (weight : V -> Real) (x : V) (shell radial : Finset V)
    (spaceScale : Real) (hscale : 0 < spaceScale)
    (time : V -> Real) (space : Fin 3 -> V -> Real)
    (hdisjoint : Disjoint shell radial)
    (hshellWeight : forall y, y ∈ shell -> weight y = -spaceScale)
    (hradialWeight : forall y, y ∈ radial -> 0 < weight y)
    (htimeSupport : BasedSupportedOn x radial time)
    (hspaceSupport : forall i, BasedSupportedOn x shell (space i))
    (htimeNonzero : exists y, y ∈ radial ∧
      basedDifference x time y ≠ 0)
    (hspaceIndependent : forall a : Fin 3 -> Real, a ≠ 0 ->
      exists y, y ∈ shell ∧
        (∑ i, a i * basedDifference x (space i) y) ≠ 0) :
    HasConditionalMostlyMinusSplit weight x time space := by
  sorry

end MarkedShellConditionalInertia
