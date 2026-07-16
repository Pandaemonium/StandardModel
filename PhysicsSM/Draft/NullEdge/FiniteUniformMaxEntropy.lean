import Mathlib

/-!
# Uniform distributions uniquely maximize finite Shannon entropy

For a finite nonempty type, this module proves that every nonnegative
normalized probability vector has Shannon entropy at most the logarithm of the
cardinality, with equality exactly for the uniform distribution. An explicit
point-mass witness makes the inequality strict on `Fin 2`.

This is a scalar classical theorem. It does not characterize density matrices,
include a nontrivial energy expectation constraint, or prove uniqueness of a
matrix Gibbs state. Those are separate requirements of `DYN-MODULAR-001`.

Provenance: clean-room integration of Aristotle project
`273a28be-611b-4929-807e-a865a5e2b640`, task
`7b8e1367-026d-4b26-8a13-b6e46c7dfa78`. Both submitted target statements were
returned unchanged and independently replayed under the repository toolchain
on 2026-07-12.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- Shannon entropy using `Real.negMulLog`, including its value at zero. -/
def shannonEntropy (r : k -> Real) : Real :=
  ∑ i, Real.negMulLog (r i)

/-- Tangent-line bound used termwise in the entropy estimate. -/
lemma term_bound {D : Real} (hD : 0 < D) {x : Real} (hx : 0 <= x) :
    Real.negMulLog x <= 1 / D - x + x * Real.log D := by
  by_cases hx0 : x = 0 <;>
    simp_all +decide [Real.negMulLog]
  · linarith
  · have hlog := Real.log_le_sub_one_of_pos
        (show 0 < D⁻¹ * x⁻¹ by positivity)
    rw [Real.log_mul] at hlog <;> norm_num at * <;>
      nlinarith [inv_pos.2 hD,
        inv_pos.2 (lt_of_le_of_ne hx (Ne.symm hx0)),
        mul_inv_cancel₀ hD.ne', mul_inv_cancel₀ hx0]

/-- Equality in the tangent-line bound occurs exactly at `x = 1 / D`. -/
lemma term_bound_eq_iff {D : Real} (hD : 0 < D) {x : Real} (hx : 0 <= x) :
    Real.negMulLog x = 1 / D - x + x * Real.log D <-> x = 1 / D := by
  constructor <;> intro h <;> by_cases hx' : x = 0 <;> simp_all +decide
  · contrapose! h
    have hstrict := Real.log_lt_sub_one_of_pos
      (show 0 < 1 / (D * x) by positivity) ?_ <;>
      simp_all +decide [Real.log_mul, ne_of_gt]
    · rw [Real.negMulLog_def]
      cases lt_or_gt_of_ne hx' <;>
        nlinarith [inv_mul_cancel_left₀ hx' D⁻¹,
          inv_mul_cancel₀ hx', inv_pos.2 hD, mul_inv_cancel₀ hD.ne']
    · grind
  · simp +decide [Real.negMulLog, Real.log_inv]

/-- Shannon entropy of a finite probability vector is at most the logarithm
of the cardinality. -/
theorem entropy_le_log_card [Nonempty k] (p : k -> Real)
    (hp : ∀ i, 0 <= p i) (hpsum : ∑ i, p i = 1) :
    shannonEntropy p <= Real.log (Fintype.card k) := by
  convert Finset.sum_le_sum fun i _ =>
    term_bound (show 0 < (Fintype.card k : Real) by positivity) (hp i) using 1
  simp +decide [Finset.sum_add_distrib, ← Finset.sum_mul, hpsum]

/-- The entropy bound is saturated exactly by the uniform distribution. -/
theorem entropy_eq_log_card_iff [Nonempty k] (p : k -> Real)
    (hp : ∀ i, 0 <= p i) (hpsum : ∑ i, p i = 1) :
    shannonEntropy p = Real.log (Fintype.card k) <->
      ∀ i, p i = (Fintype.card k : Real)⁻¹ := by
  constructor
  · intro h i
    have hterm :
        ∀ j, Real.negMulLog (p j) =
          1 / (Fintype.card k : Real) - p j +
            p j * Real.log (Fintype.card k) := by
      have hsum :
          ∑ j, Real.negMulLog (p j) =
            ∑ j, (1 / (Fintype.card k : Real) - p j +
              p j * Real.log (Fintype.card k)) := by
        convert h using 1
        simp +decide [Finset.sum_add_distrib, ← Finset.sum_mul, hpsum]
      have hle :
          ∀ j, Real.negMulLog (p j) <=
            1 / (Fintype.card k : Real) - p j +
              p j * Real.log (Fintype.card k) :=
        fun j => term_bound (Nat.cast_pos.mpr Fintype.card_pos) (hp j)
      exact fun j => le_antisymm (hle j) (by
        simpa [hsum] using Finset.single_le_sum
          (fun ell _ => sub_nonneg_of_le (hle ell)) (Finset.mem_univ j))
    simpa [one_div] using (term_bound_eq_iff
      (show 0 < (Fintype.card k : Real) by
        exact Nat.cast_pos.mpr Fintype.card_pos)
      (hp i)).mp (hterm i)
  · intro h
    simp [h, shannonEntropy]
    norm_num [Real.negMulLog]

/-- Point mass on the first point of `Fin 2`. -/
def pointMassTwo : Fin 2 -> Real := fun i => if i = 0 then 1 else 0

/-- Nondegenerate control: a point mass is strictly below the two-point
uniform entropy maximum. -/
theorem pointMassTwo_entropy_strict :
    shannonEntropy pointMassTwo < Real.log (Fintype.card (Fin 2)) := by
  simp [shannonEntropy, pointMassTwo, Real.negMulLog]
  exact Real.log_pos (by norm_num)

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy.entropy_le_log_card' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms entropy_le_log_card

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy.entropy_eq_log_card_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms entropy_eq_log_card_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy.pointMassTwo_entropy_strict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pointMassTwo_entropy_strict

end PhysicsSM.Draft.NullEdge.FiniteUniformMaxEntropy
