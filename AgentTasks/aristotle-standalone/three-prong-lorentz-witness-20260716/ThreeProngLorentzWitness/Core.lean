import Mathlib

/-!
# Five-event causal-diamond Lorentz witness

Focused Mathlib-only package for the first positive corrected-pairing witness
after the one-sided retarded polynomial-projector no-go.

The order has one bottom event, three incomparable middle events, and one top
event. At the top, the normalized project-sign local four-dimensional causal
row has weight `8` on the bottom and weight `-1` on each middle event. Four
explicit zero-sum probes then have the exact mostly-minus Minkowski Gram
matrix.

This file proves only a finite nonvacuity witness. It does not derive a
universal graph selector, physical scale, overlap transport, a spectral gap,
refinement stability, or a continuum tetrad.
-/

noncomputable section

namespace ThreeProngLorentzWitness

/-- Minimal finite strict-order package used by the focused witness. -/
structure FiniteCausalOrder (V : Type*) [Fintype V] where
  before : V -> V -> Prop
  decidableBefore : DecidableRel before
  irrefl : ∀ x, ¬ before x x
  trans : ∀ {x y z}, before x y -> before y z -> before x z

attribute [instance] FiniteCausalOrder.decidableBefore

/-- Number of events strictly between two endpoints. -/
def FiniteCausalOrder.openIntervalCount
    {V : Type*} [Fintype V] (C : FiniteCausalOrder V) (x y : V) : Nat :=
  (Finset.univ.filter fun z => C.before x z ∧ C.before z y).card

/-- The local four-dimensional Benincasa-Dowker layer coefficients. -/
def sourceLocal4DCoefficient : Nat -> Real
  | 0 => 1
  | 1 => -9
  | 2 => 16
  | 3 => -8
  | _ => 0

/-- Strict-past row weight, including the common prefactor. -/
def layeredPastWeight
    {V : Type*} [Fintype V] (C : FiniteCausalOrder V)
    (prefactor : Real) (coefficient : Nat -> Real) (x y : V) : Real :=
  if C.before y x then
    prefactor * coefficient (C.openIntervalCount y x)
  else 0

/-- Symmetric weighted finite-difference form at one event. -/
def weightedDifferenceForm
    {V : Type*} [Fintype V]
    (weight : V -> Real) (x : V) (f h : V -> Real) : Real :=
  (2 : Real)⁻¹ *
    ∑ y : V, weight y * (f y - f x) * (h y - h x)

/-- Total-sum functional on a finite real scalar field. -/
def fieldSumLinearMap (V : Type*) [Fintype V] :
    (V -> Real) →ₗ[Real] Real where
  toFun phi := ∑ x : V, phi x
  map_add' phi psi := by simp [Finset.sum_add_distrib]
  map_smul' c phi := by simp [Finset.mul_sum]

/-- Canonical zero-sum scalar-probe space. -/
def zeroSumFieldSubspace (V : Type*) [Fintype V] :
    Submodule Real (V -> Real) :=
  LinearMap.ker (fieldSumLinearMap V)

/-- Mostly-minus Minkowski matrix. -/
def eta : Matrix (Fin 4) (Fin 4) Real :=
  !![1, 0, 0, 0; 0, -1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-- Height function for the five-event three-prong diamond: event `0` is the
bottom, events `1,2,3` form the middle antichain, and event `4` is the top. -/
def threeProngLevel (x : Fin 5) : Nat :=
  if x = 0 then 0 else if x = 4 then 2 else 1

/-- The strict order induced by the three levels. -/
def threeProngOrder : FiniteCausalOrder (Fin 5) where
  before x y := threeProngLevel x < threeProngLevel y
  decidableBefore := inferInstance
  irrefl x := Nat.lt_irrefl _
  trans hxy hyz := Nat.lt_trans hxy hyz

/-- Every event lies in the closed interval from `0` to `4`. -/
theorem threeProng_is_closed_diamond :
    (∀ z : Fin 5, z = 0 ∨ threeProngOrder.before 0 z) ∧
      (∀ z : Fin 5, z = 4 ∨ threeProngOrder.before z 4) := by
  sorry

/-- Expected normalized project-sign top-row weights. -/
def normalizedProjectWeight (y : Fin 5) : Real :=
  if y = 0 then 8 else if y = 4 then 0 else -1

/-- The normalized project-sign local four-dimensional causal row has one
positive bottom weight and three negative middle weights. -/
theorem threeProng_layeredPastWeight (y : Fin 5) :
    layeredPastWeight threeProngOrder (-1) sourceLocal4DCoefficient 4 y =
      normalizedProjectWeight y := by
  sorry

/-- Scale of each explicit Lorentz probe in difference coordinates. -/
def lorentzProbeScale (i : Fin 4) : Real :=
  if i = 0 then (2 : Real)⁻¹ else Real.sqrt 2

/-- Four zero-sum probes. Probe `i` differs from the top only in predecessor
`i`; the `4/5,-1/5` centering makes its total sum vanish. -/
def lorentzProbe (i : Fin 4) (z : Fin 5) : Real :=
  if z.val = i.val then
    (4 / 5 : Real) * lorentzProbeScale i
  else
    (-1 / 5 : Real) * lorentzProbeScale i

/-- Each explicit Lorentz probe belongs to the zero-sum space. -/
theorem lorentzProbe_mem_zeroSum (i : Fin 4) :
    lorentzProbe i ∈ zeroSumFieldSubspace (Fin 5) := by
  sorry

/-- The four explicit probes are linearly independent. -/
theorem lorentzProbe_linearIndependent :
    LinearIndependent Real lorentzProbe := by
  sorry

/-- The zero-sum scalar space on five events has real dimension four. -/
theorem finrank_zeroSum_finFive :
    Module.finrank Real (zeroSumFieldSubspace (Fin 5)) = 4 := by
  sorry

/-- Exact normalized Minkowski Gram matrix for the graph-derived causal-row
weights and the explicit zero-sum probes. -/
theorem threeProng_lorentzProbe_gram (i j : Fin 4) :
    weightedDifferenceForm
        (layeredPastWeight threeProngOrder (-1)
          sourceLocal4DCoefficient 4)
        4 (lorentzProbe i) (lorentzProbe j) =
      eta i j := by
  sorry

/-- The explicit probes form a basis of the zero-sum space and realize the
exact mostly-minus Gram matrix. -/
theorem exists_threeProng_lorentzBasis :
    ∃ b : Module.Basis (Fin 4) Real (zeroSumFieldSubspace (Fin 5)),
      (∀ i : Fin 4, (b i).1 = lorentzProbe i) ∧
        ∀ i j : Fin 4,
          weightedDifferenceForm
              (layeredPastWeight threeProngOrder (-1)
                sourceLocal4DCoefficient 4)
              4 (b i).1 (b j).1 = eta i j := by
  sorry

end ThreeProngLorentzWitness
