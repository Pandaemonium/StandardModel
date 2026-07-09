import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

open Matrix

/-!
# Suite C rung C1 — the carrier → {positive, balanced, protected-null, indefinite} map

A carrier's *sector form* is a real symmetric matrix `S`. We classify its physical sector by the
signature of `S` into four disjoint classes:

* `IsPositive`      — `S` is positive definite (a massive, physical positive-sector code);
* `IsProtectedNull` — `S` is positive semidefinite with a nontrivial kernel and `S ≠ 0`
                       (a protected massless mode);
* `IsIndefinite`    — `S` has a strictly negative direction (an unphysical/ghost sector);
* `IsBalanced`      — `S = 0` (the degenerate/edge case).

We prove the classification is exhaustive (`classification_exhaustive`, `four_way_total`) and
mutually exclusive (the `not_*` lemmas), and exhibit an explicit rational witness in each class
with a distinguishing vector (`witnesses`, `physical_reading`).

Honest scope: this is a finite linear-algebra classification of sector forms by their signature,
**not** a derivation of the Standard-Model particle content.
-/

namespace PositiveSectorClass

variable {n : ℕ}

/-! ## 1. Class predicates -/

/-- POSITIVE: the sector form is positive definite — a massive positive-sector code. -/
def IsPositive (S : Matrix (Fin n) (Fin n) ℝ) : Prop := S.PosDef

/-- PROTECTED-NULL: the sector form is positive semidefinite with a nontrivial kernel and is
nonzero — a protected massless mode. -/
def IsProtectedNull (S : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  S.PosSemidef ∧ ¬ S.PosDef ∧ S ≠ 0

/-- INDEFINITE: the sector form has a strictly negative direction (a witnessing vector `x` with
`xᵀ S x < 0`) — an unphysical/ghost sector. -/
def IsIndefinite (S : Matrix (Fin n) (Fin n) ℝ) : Prop :=
  ∃ x : Fin n → ℝ, x ⬝ᵥ (S *ᵥ x) < 0

/-- BALANCED: the sector form vanishes — the degenerate/edge case. -/
def IsBalanced (S : Matrix (Fin n) (Fin n) ℝ) : Prop := S = 0

/-! ## 2. Exhaustiveness -/

/-- Every nonzero real symmetric sector form is positive, protected-null, or indefinite. -/
theorem classification_exhaustive (S : Matrix (Fin n) (Fin n) ℝ)
    (hS : S.IsHermitian) (hne : S ≠ 0) :
    IsPositive S ∨ IsProtectedNull S ∨ IsIndefinite S := by
  by_cases hpd : S.PosDef
  · exact Or.inl hpd
  · by_cases hpsd : S.PosSemidef
    · exact Or.inr (Or.inl ⟨hpsd, hpd, hne⟩)
    · refine Or.inr (Or.inr ?_)
      rw [Matrix.posSemidef_iff_dotProduct_mulVec] at hpsd
      push_neg at hpsd
      obtain ⟨x, hx⟩ := hpsd hS
      exact ⟨x, by simpa using hx⟩

/-- Every real symmetric sector form falls into one of the four classes. -/
theorem four_way_total (S : Matrix (Fin n) (Fin n) ℝ) (hS : S.IsHermitian) :
    IsPositive S ∨ IsProtectedNull S ∨ IsIndefinite S ∨ IsBalanced S := by
  by_cases hne : S = 0
  · exact Or.inr (Or.inr (Or.inr hne))
  · rcases classification_exhaustive S hS hne with h | h | h
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
    · exact Or.inr (Or.inr (Or.inl h))

/-! ## 3. Mutual exclusivity -/

theorem not_positive_indefinite (S : Matrix (Fin n) (Fin n) ℝ) :
    ¬ (IsPositive S ∧ IsIndefinite S) := by
  rintro ⟨hpos, x, hx⟩
  have h := hpos.posSemidef
  rw [Matrix.posSemidef_iff_dotProduct_mulVec] at h
  have h2 := h.2 x
  simp only [star_trivial] at h2
  linarith

theorem not_positive_protectedNull (S : Matrix (Fin n) (Fin n) ℝ) :
    ¬ (IsPositive S ∧ IsProtectedNull S) := by
  rintro ⟨hpos, _, hnpd, _⟩
  exact hnpd hpos

theorem not_positive_balanced [NeZero n] (S : Matrix (Fin n) (Fin n) ℝ) :
    ¬ (IsPositive S ∧ IsBalanced S) := by
  rintro ⟨hpos, hbal⟩
  rw [IsBalanced] at hbal; subst hbal
  have hx : (Finsupp.single (⟨0, Nat.pos_of_ne_zero (NeZero.ne n)⟩ : Fin n) (1 : ℝ)) ≠ 0 := by
    simp
  have := hpos.2 hx
  simp at this

theorem not_indefinite_protectedNull (S : Matrix (Fin n) (Fin n) ℝ) :
    ¬ (IsIndefinite S ∧ IsProtectedNull S) := by
  rintro ⟨⟨x, hx⟩, hpsd, _, _⟩
  rw [Matrix.posSemidef_iff_dotProduct_mulVec] at hpsd
  have h2 := hpsd.2 x
  simp only [star_trivial] at h2
  linarith

theorem not_indefinite_balanced (S : Matrix (Fin n) (Fin n) ℝ) :
    ¬ (IsIndefinite S ∧ IsBalanced S) := by
  rintro ⟨⟨x, hx⟩, hbal⟩
  rw [IsBalanced] at hbal; subst hbal
  simp at hx

theorem not_protectedNull_balanced (S : Matrix (Fin n) (Fin n) ℝ) :
    ¬ (IsProtectedNull S ∧ IsBalanced S) := by
  rintro ⟨⟨_, _, hne⟩, hbal⟩
  exact hne hbal

/-! ## 4. Witnesses -/

/-- Positive witness: `!![2,0;0,3]`. -/
def wPositive : Matrix (Fin 2) (Fin 2) ℝ := !![2, 0; 0, 3]

/-- Protected-null witness: `!![1,0;0,0]`. -/
def wProtectedNull : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, 0]

/-- Indefinite witness: `!![1,0;0,-1]`. -/
def wIndefinite : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, -1]

/-- Balanced witness: the zero form. -/
def wBalanced : Matrix (Fin 2) (Fin 2) ℝ := 0

/-- The distinguishing kernel vector for the protected-null witness. -/
def kProtectedNull : Fin 2 → ℝ := ![0, 1]

/-- The distinguishing negative-value vector for the indefinite witness. -/
def vIndefinite : Fin 2 → ℝ := ![0, 1]

/-- The kernel vector is nonzero. -/
theorem kProtectedNull_ne_zero : kProtectedNull ≠ 0 := by
  intro h; have := congrFun h 1; simp [kProtectedNull] at this

/-- The negative-value vector is nonzero. -/
theorem vIndefinite_ne_zero : vIndefinite ≠ 0 := by
  intro h; have := congrFun h 1; simp [vIndefinite] at this

/-- The kernel vector lies in the kernel of the protected-null witness. -/
theorem wProtectedNull_kernel : wProtectedNull *ᵥ kProtectedNull = 0 := by
  funext i; fin_cases i <;>
    simp [wProtectedNull, kProtectedNull, mulVec, dotProduct, Fin.sum_univ_two]

/-- The negative-value vector gives a strictly negative value on the indefinite witness. -/
theorem wIndefinite_neg_value : vIndefinite ⬝ᵥ (wIndefinite *ᵥ vIndefinite) < 0 := by
  norm_num [wIndefinite, vIndefinite, mulVec, dotProduct, Fin.sum_univ_two]

theorem wPositive_isPositive : IsPositive wPositive := by
  have h : wPositive = Matrix.diagonal ![2, 3] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [wPositive, Matrix.diagonal]
  rw [IsPositive, h, Matrix.posDef_diagonal_iff]
  intro i; fin_cases i <;> norm_num

theorem wProtectedNull_isProtectedNull : IsProtectedNull wProtectedNull := by
  have h : wProtectedNull = Matrix.diagonal ![1, 0] := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [wProtectedNull, Matrix.diagonal]
  refine ⟨?_, ?_, ?_⟩
  · rw [h, Matrix.posSemidef_diagonal_iff]; intro i; fin_cases i <;> norm_num
  · rw [h, Matrix.posDef_diagonal_iff]; push_neg; exact ⟨1, by norm_num⟩
  · intro hz
    have := congrFun (congrFun hz 0) 0
    simp [wProtectedNull] at this

theorem wIndefinite_isIndefinite : IsIndefinite wIndefinite :=
  ⟨vIndefinite, wIndefinite_neg_value⟩

theorem wBalanced_isBalanced : IsBalanced wBalanced := rfl

/-- The four witnesses are pairwise distinct. -/
theorem witnesses_distinct :
    wPositive ≠ wProtectedNull ∧ wPositive ≠ wIndefinite ∧ wPositive ≠ wBalanced ∧
    wProtectedNull ≠ wIndefinite ∧ wProtectedNull ≠ wBalanced ∧
    wIndefinite ≠ wBalanced := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro h; have := congrFun (congrFun h 0) 0
    simp [wPositive, wProtectedNull] at this
  · intro h; have := congrFun (congrFun h 0) 0
    simp [wPositive, wIndefinite] at this
  · intro h; have := congrFun (congrFun h 0) 0
    simp [wPositive, wBalanced] at this
  · intro h; have := congrFun (congrFun h 1) 1
    simp [wProtectedNull, wIndefinite] at this
  · intro h; have := congrFun (congrFun h 0) 0
    simp [wProtectedNull, wBalanced] at this
  · intro h; have := congrFun (congrFun h 0) 0
    simp [wIndefinite, wBalanced] at this

/-! ## 5. Physical reading (payload) -/

/-- The physical reading of the classification: the massive physical sector is exactly POSITIVE,
protected massless modes are PROTECTED-NULL, ghost/unphysical is INDEFINITE, and the degenerate
edge is BALANCED. Each explicit rational witness lands in its class, with the protected-null kernel
vector and the indefinite negative-value vector exhibited nonzero. -/
theorem physical_reading :
    (IsPositive wPositive) ∧
    (IsProtectedNull wProtectedNull ∧ kProtectedNull ≠ 0 ∧
      wProtectedNull *ᵥ kProtectedNull = 0) ∧
    (IsIndefinite wIndefinite ∧ vIndefinite ≠ 0 ∧
      vIndefinite ⬝ᵥ (wIndefinite *ᵥ vIndefinite) < 0) ∧
    (IsBalanced wBalanced) :=
  ⟨wPositive_isPositive,
   ⟨wProtectedNull_isProtectedNull, kProtectedNull_ne_zero, wProtectedNull_kernel⟩,
   ⟨wIndefinite_isIndefinite, vIndefinite_ne_zero, wIndefinite_neg_value⟩,
   wBalanced_isBalanced⟩

/-! ## Axiom footprint of every headline -/

/-- info: 'PositiveSectorClass.classification_exhaustive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms classification_exhaustive
/-- info: 'PositiveSectorClass.four_way_total' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms four_way_total
/-- info: 'PositiveSectorClass.not_positive_indefinite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms not_positive_indefinite
/-- info: 'PositiveSectorClass.not_positive_protectedNull' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms not_positive_protectedNull
/-- info: 'PositiveSectorClass.not_positive_balanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms not_positive_balanced
/-- info: 'PositiveSectorClass.not_indefinite_protectedNull' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms not_indefinite_protectedNull
/-- info: 'PositiveSectorClass.not_indefinite_balanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms not_indefinite_balanced
/-- info: 'PositiveSectorClass.not_protectedNull_balanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms not_protectedNull_balanced
/-- info: 'PositiveSectorClass.wPositive_isPositive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms wPositive_isPositive
/-- info: 'PositiveSectorClass.wProtectedNull_isProtectedNull' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms wProtectedNull_isProtectedNull
/-- info: 'PositiveSectorClass.wIndefinite_isIndefinite' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms wIndefinite_isIndefinite
/-- info: 'PositiveSectorClass.wBalanced_isBalanced' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms wBalanced_isBalanced
/-- info: 'PositiveSectorClass.kProtectedNull_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms kProtectedNull_ne_zero
/-- info: 'PositiveSectorClass.vIndefinite_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms vIndefinite_ne_zero
/-- info: 'PositiveSectorClass.wProtectedNull_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms wProtectedNull_kernel
/-- info: 'PositiveSectorClass.wIndefinite_neg_value' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms wIndefinite_neg_value
/-- info: 'PositiveSectorClass.witnesses_distinct' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms witnesses_distinct
/-- info: 'PositiveSectorClass.physical_reading' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms physical_reading

end PositiveSectorClass
