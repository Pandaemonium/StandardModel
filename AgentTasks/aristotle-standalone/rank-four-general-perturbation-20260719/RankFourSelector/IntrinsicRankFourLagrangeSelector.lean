import Mathlib

/-!
# Exact rank-four polynomial selector from isolated finite spectrum

For a finite coordinate-diagonal operator with pairwise distinct real
eigenvalues, Lagrange interpolation gives an exact polynomial projector onto
any selected eigenvalue set. A four-element set therefore has an idempotent
polynomial-filter range of dimension four.

This is the constructive algebraic predecessor to an intrinsic causal-order
rank-four sector. It does not prove that a proposed causal operator has simple
or gapped spectrum, Lorentzian inertia on the selected range, or stability
under refinement. Those remain separate analytic and physical gates.

Provenance: clean-room focused formalization completed by Aristotle project
`695bcfb3-f956-4c37-8894-2713905d91d8` and adapted into the project namespace.
-/

open Polynomial

noncomputable section

namespace PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector

variable {ι : Type*} [Fintype ι] [DecidableEq ι]

/-- Coordinate-diagonal real-linear endomorphism. -/
def diagonalOperator (eigenvalue : ι → Real) :
    Module.End Real (ι → Real) where
  toFun v i := eigenvalue i * v i
  map_add' v w := by
    funext i
    simp [mul_add]
  map_smul' r v := by
    funext i
    simp [mul_assoc, mul_left_comm]

/-- Evaluate a real polynomial at an endomorphism. -/
def polynomialFilter (A : Module.End Real (ι → Real)) (p : Real[X]) :
    Module.End Real (ι → Real) :=
  aeval A p

/-- Lagrange basis polynomial at one listed eigenvalue. -/
def lagrangeBasis (eigenvalue : ι → Real) (i : ι) : Real[X] :=
  ∏ j ∈ Finset.univ.erase i,
    C ((eigenvalue i - eigenvalue j)⁻¹) * (X - C (eigenvalue j))

/-- Polynomial indicator of a selected eigenvalue set. -/
def selectorPolynomial (eigenvalue : ι → Real) (selected : Finset ι) :
    Real[X] :=
  ∑ i ∈ selected, lagrangeBasis eigenvalue i

/-- Coordinate projector onto selected indices. -/
def coordinateProjector (selected : Finset ι) :
    Module.End Real (ι → Real) where
  toFun v i := if i ∈ selected then v i else 0
  map_add' v w := by
    funext i
    by_cases hi : i ∈ selected <;> simp [hi]
  map_smul' r v := by
    funext i
    by_cases hi : i ∈ selected <;> simp [hi]

theorem eval_lagrangeBasis
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (i j : ι) :
    (lagrangeBasis eigenvalue i).eval (eigenvalue j) =
      if j = i then 1 else 0 := by
  by_cases hij : j = i <;> simp +decide [hij, lagrangeBasis]
  · simp +decide [Polynomial.eval_prod, Finset.prod_eq_zero_iff,
      sub_eq_zero, hinjective.eq_iff]
    exact Finset.prod_eq_one fun x hx => by
      rw [inv_mul_cancel₀]
      exact sub_ne_zero_of_ne <| hinjective.ne <| by aesop
  · rw [Polynomial.eval_prod,
      Finset.prod_eq_zero (Finset.mem_erase_of_ne_of_mem hij (Finset.mem_univ j))]
    simp +decide [sub_eq_zero, hinjective.eq_iff]

theorem eval_selectorPolynomial
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) (j : ι) :
    (selectorPolynomial eigenvalue selected).eval (eigenvalue j) =
      if j ∈ selected then 1 else 0 := by
  have h_eval :
      ∑ i ∈ selected, (lagrangeBasis eigenvalue i).eval (eigenvalue j) =
        if j ∈ selected then 1 else 0 := by
    rw [Finset.sum_congr rfl fun i hi =>
      eval_lagrangeBasis eigenvalue hinjective i j]
    aesop
  unfold selectorPolynomial
  simp +decide [Polynomial.eval_finset_sum, h_eval]

theorem polynomialFilter_diagonal_apply
    (eigenvalue : ι → Real) (p : Real[X]) (v : ι → Real) (j : ι) :
    polynomialFilter (diagonalOperator eigenvalue) p v j =
      p.eval (eigenvalue j) * v j := by
  unfold polynomialFilter
  induction' p using Polynomial.induction_on' with p q hp hq
  · simp +decide [*, add_mul]
  · rename_i n a
    induction' n with n ih generalizing v j <;>
      simp_all +decide [pow_succ, mul_assoc, mul_left_comm, mul_add, add_mul,
        aeval_X, aeval_C, diagonalOperator]
    cases ih (fun i => eigenvalue i * v i) j <;>
      simp_all +decide [mul_assoc, mul_comm, mul_left_comm]

/-- The Lagrange polynomial filter is exactly the coordinate projector. -/
theorem polynomialFilter_selector_eq_coordinateProjector
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) :
    polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected) =
      coordinateProjector selected := by
  ext v j
  simp +decide [polynomialFilter_diagonal_apply, eval_selectorPolynomial,
    coordinateProjector]
  split_ifs <;>
    simp_all +decide [eval_selectorPolynomial, Pi.single_apply]

theorem coordinateProjector_idempotent (selected : Finset ι) :
    (coordinateProjector selected).comp (coordinateProjector selected) =
      coordinateProjector selected := by
  ext v
  simp [coordinateProjector]
  tauto

theorem finrank_range_coordinateProjector (selected : Finset ι) :
    Module.finrank Real (LinearMap.range (coordinateProjector selected)) =
      selected.card := by
  have h_iso :
      LinearMap.range (coordinateProjector selected) ≃ₗ[Real]
        (selected → Real) := by
    refine' (LinearEquiv.ofBijective _ ⟨_, _⟩)
    refine' { .. }
    refine' fun x i => x.val i
    all_goals norm_num [Function.Injective, Function.Surjective]
    · exact fun _ _ => rfl
    · exact fun _ _ => rfl
    · intro a b h
      ext i
      by_cases hi : i ∈ selected <;>
        simp_all +decide [funext_iff, coordinateProjector]
    · intro b
      use fun i => if hi : i ∈ selected then b ⟨i, hi⟩ else 0
      ext i
      simp +decide [coordinateProjector]
  simpa using LinearEquiv.finrank_eq h_iso

theorem polynomialFilter_selector_idempotent
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) :
    (polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected)).comp
          (polynomialFilter (diagonalOperator eigenvalue)
            (selectorPolynomial eigenvalue selected)) =
      polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected) := by
  rw [polynomialFilter_selector_eq_coordinateProjector eigenvalue hinjective selected]
  exact coordinateProjector_idempotent selected

/-- Four selected simple eigenvalues give an exact idempotent polynomial filter
with four-dimensional range. -/
theorem rankFour_polynomial_selector
    (eigenvalue : ι → Real) (hinjective : Function.Injective eigenvalue)
    (selected : Finset ι) (hcard : selected.card = 4) :
    (polynomialFilter (diagonalOperator eigenvalue)
        (selectorPolynomial eigenvalue selected)).comp
          (polynomialFilter (diagonalOperator eigenvalue)
            (selectorPolynomial eigenvalue selected)) =
        polynomialFilter (diagonalOperator eigenvalue)
          (selectorPolynomial eigenvalue selected) ∧
      Module.finrank Real
          (LinearMap.range
            (polynomialFilter (diagonalOperator eigenvalue)
              (selectorPolynomial eigenvalue selected))) = 4 := by
  constructor
  · exact polynomialFilter_selector_idempotent eigenvalue hinjective selected
  · rw [polynomialFilter_selector_eq_coordinateProjector eigenvalue hinjective selected,
      finrank_range_coordinateProjector, hcard]

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector.rankFour_polynomial_selector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rankFour_polynomial_selector

end PhysicsSM.Draft.NullEdge.IntrinsicRankFourLagrangeSelector
