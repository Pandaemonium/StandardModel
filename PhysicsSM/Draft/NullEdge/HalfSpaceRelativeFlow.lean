import Mathlib
import PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift

/-!
# Half-space relative flow and unilateral-shift controls

For the unit right shift on `ℤ`, the difference between the translated
half-space occupation and the original occupation is finitely supported at the
cut.  This module proves that its finite sum is `-1`, that exactly one lattice
site crosses the cut in the opposite sign convention, and that every finite
closed permutation has zero total transported weight.  It also proves the
elementary range defect of the unilateral sequence shift.

These are relative-sum and crossing-count identities.  The module does not
define a Fredholm operator, analytic index, operator-theoretic spectral flow,
or bulk-edge correspondence.  It also proves no continuum Dirac limit,
single-Weyl statement, or boundary spectral gap.

Provenance: Aristotle job `a8178bce-aebf-40b1-98a1-b85869538183`, with the
operator-theoretic terminology narrowed during integration to match the actual
Lean statements.
-/

namespace PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow

open scoped BigOperators

/-! ## Half-space relative defect -/

/-- Half-space occupation weight: `1` on the closed right half-line, `0` left. -/
def halfProj (n : ℤ) : ℤ := if 0 ≤ n then 1 else 0

/-- The bulk unit right shift as a permutation of `ℤ`. -/
def shift : Equiv.Perm ℤ := Equiv.addRight (1 : ℤ)

@[simp] theorem shift_apply (n : ℤ) : shift n = n + 1 := rfl
@[simp] theorem shift_symm_apply (n : ℤ) : shift.symm n = n - 1 := rfl

/-- Diagonal integrand of the regularized relative trace `Tr (U P U⁻¹ − P)`
for `U = shift`, `P = halfProj`. -/
def relDefect (n : ℤ) : ℤ := halfProj (shift.symm n) - halfProj n

/-- The relative-trace integrand is supported at the single cut site `0`,
where it equals `−1`. -/
theorem relDefect_apply (n : ℤ) : relDefect n = if n = 0 then -1 else 0 := by
  simp only [relDefect, halfProj, shift_symm_apply]
  split_ifs <;> omega

theorem relDefect_support : Function.support relDefect = {0} := by
  ext n
  simp only [Function.mem_support, relDefect_apply, Set.mem_singleton_iff]
  split_ifs with h <;> simp [h]

/-- The relative defect is finitely supported and its finite sum is `-1`.

This is the algebraic quantity that a later analytic compression theorem may
identify with an index; no Fredholm operator or analytic trace is defined here.
-/
theorem relTrace_eq : ∑ᶠ n, relDefect n = -1 := by
  rw [finsum_eq_single relDefect 0
    (by intro j hj; rw [relDefect_apply]; simp [hj])]
  simp [relDefect_apply]

/-! ### The same defect in the range of a unilateral sequence shift -/

/-- The unilateral (half-line) right shift on sequences `ℕ → ℂ`: push every
value one site to the right and set the new boundary value at site `0` to zero.
This is the Toeplitz compression of the bulk shift to the half-space. -/
def upShift (f : ℕ → ℂ) : ℕ → ℂ := fun n => if n = 0 then 0 else f (n - 1)

/-- The half-line shift has trivial kernel: it is injective. -/
theorem upShift_injective : Function.Injective upShift := by
  intro f g h
  funext n
  have := congrFun h (n + 1)
  simpa [upShift] using this

/-- The range of the half-line shift is exactly the set of sequences vanishing
at the boundary site `0`. -/
theorem upShift_range : Set.range upShift = {g : ℕ → ℂ | g 0 = 0} := by
  ext g
  constructor
  · rintro ⟨f, rfl⟩
    simp [upShift]
  · intro hg
    refine ⟨fun n => g (n + 1), ?_⟩
    funext n
    cases n with
    | zero => simpa [upShift] using hg.symm
    | succ m => simp [upShift]

/-- The half-line shift is not surjective, witnessed by the sequence supported
at the boundary site `0`.  No quotient-space dimension is asserted here. -/
theorem upShift_not_surjective : ¬ Function.Surjective upShift := by
  intro hsurj
  obtain ⟨f, hf⟩ := hsurj (fun n => if n = 0 then 1 else 0)
  have := congrFun hf 0
  simp [upShift] at this

/-! ### A signed crossing count across the cut -/

/-- Sites crossing the cut rightwards: from the strictly negative half-line into
the nonnegative half-line under one bulk step. -/
def crossR : Set ℤ := {n | n < 0 ∧ 0 ≤ shift n}

/-- Sites crossing the cut leftwards. -/
def crossL : Set ℤ := {n | 0 ≤ n ∧ shift n < 0}

theorem crossR_eq : crossR = {-1} := by
  ext n; simp only [crossR, Set.mem_setOf_eq, shift_apply, Set.mem_singleton_iff]
  omega

theorem crossL_eq : crossL = (∅ : Set ℤ) := by
  ext n; simp only [crossL, Set.mem_setOf_eq, shift_apply, Set.mem_empty_iff_false,
    iff_false, not_and]
  omega

/-- Net rightward flow of weight across the cut. -/
noncomputable def flow : ℤ := (crossR.ncard : ℤ) - (crossL.ncard : ℤ)

/-- Exactly one site crosses rightward and none crosses leftward, so the signed
crossing count is `1`.  This is not an operator spectral-flow theorem. -/
theorem flow_eq : flow = 1 := by
  simp [flow, crossR_eq, crossL_eq]

/-- The signed crossing count and the relative-defect sum cancel.  This is an
arithmetic compatibility lemma, not yet a bulk-edge correspondence theorem. -/
theorem relative_flow_balance : flow + (∑ᶠ n, relDefect n) = 0 := by
  rw [flow_eq, relTrace_eq]; ring

/-! ## Target 2 : permutation-flow cancellation on a finite closed system -/

/-- **Permutation-flow cancellation.**  On any finite closed system, a
permutation supports no net flow: for every weight `P`, the net transported
weight `∑ (P (σ a) − P a)` is exactly `0`.  This is the honest statement that
the *finite* global trace of a permutation cancels, in contrast to the nonzero
half-space relative trace above. -/
theorem finite_flow_cancel {α : Type*} [Fintype α] (σ : Equiv.Perm α)
    (P : α → ℤ) : ∑ a, (P (σ a) - P a) = 0 := by
  rw [Finset.sum_sub_distrib, Equiv.sum_comp σ P, sub_self]

/-- The closed reflecting walk of `ReflectingShift.lean` has vanishing net flow
for every weight: its honest finite global trace is `0`. -/
theorem reflecting_flow_cancel (N : ℕ)
    (P : PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.State N → ℤ) :
    ∑ s, (P ((PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.stepEquiv N) s) - P s) = 0 :=
  finite_flow_cancel
    (PhysicsSM.Draft.NullEdge.OpenBoundaryReflectingShift.stepEquiv N) P

end PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow

/-! ### Build-enforced standard-axiom guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow.relTrace_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow.relTrace_eq

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow.upShift_range' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow.upShift_range

/-- info: 'PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow.relative_flow_balance' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.HalfSpaceRelativeFlow.relative_flow_balance
