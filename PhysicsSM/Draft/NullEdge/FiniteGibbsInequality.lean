import Mathlib

/-!
# Finite Gibbs inequality

This module proves nonnegativity and the equality condition for classical
relative entropy on a finite type. It is the scalar information-theory core
needed by the `DYN-MODULAR-001` maximum-entropy successor, but it does not by
itself prove a matrix Klein inequality, characterize density matrices, or
select a physical dynamics.

Provenance: Aristotle project `6bb9f7bb-57e0-43ab-801d-ca64409e9d66`, task
`c6ec88b8-88c3-431e-83ba-541bb9d993ed`, independently replayed by Codex under
Lean 4.28.0 before integration. The target statements are unchanged from the
standalone package. The two-point witness and boundary control were added
locally.

Trust: kernel-checked. No compiled-evaluator shortcut is used.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.FiniteGibbsInequality

open scoped BigOperators

variable {k : Type*} [Fintype k]

/-- Finite classical relative entropy, with the convention inherited from
`Real.log 0 = 0`. -/
def relEntropy (p q : k -> Real) : Real :=
  ∑ i, p i * Real.log (p i / q i)

/-- Pointwise logarithmic tangent bound, including its equality condition. -/
theorem term_ge (a b : Real) (ha : 0 <= a) (hb : 0 < b) :
    a - b <= a * Real.log (a / b)
      ∧ (a * Real.log (a / b) = a - b ↔ a = b) := by
  by_cases ha' : a = 0 <;> by_cases hb' : b = 0 <;>
    simp_all +decide [Real.log_div, hb.ne']
  · exact ⟨hb.le, hb.ne' |> Ne.symm⟩
  · constructor
    · have hlog := Real.log_le_sub_one_of_pos
          (div_pos hb (lt_of_le_of_ne ha (Ne.symm ha')))
      rw [Real.log_div] at hlog <;>
        cases lt_or_gt_of_ne ha' <;>
          nlinarith [mul_div_cancel₀ b ha']
    · constructor <;> intro h
      · have hlog := Real.log_lt_sub_one_of_pos
            (div_pos hb (lt_of_le_of_ne ha (Ne.symm ha')))
        by_cases h' : b / a = 1 <;>
          simp_all +decide [Real.log_div, ne_of_gt]
        · exact eq_of_div_eq_one h' ▸ rfl
        · rw [div_sub_one, lt_div_iff₀] at hlog <;>
            nlinarith [mul_self_pos.mpr ha', mul_self_pos.mpr hb.ne']
      · aesop

/-- Gibbs' inequality: finite classical relative entropy is nonnegative. -/
theorem relEntropy_nonneg (p q : k -> Real)
    (hp : ∀ i, 0 <= p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    0 <= relEntropy p q := by
  convert Finset.sum_le_sum fun i (_ : i ∈ Finset.univ) =>
    (term_ge (p i) (q i) (hp i) (hq i)).1 using 1
  simp +decide [hps, hqs]

/-- Equality in Gibbs' inequality holds exactly when the distributions agree. -/
theorem relEntropy_eq_zero_iff (p q : k -> Real)
    (hp : ∀ i, 0 <= p i) (hq : ∀ i, 0 < q i)
    (hps : ∑ i, p i = 1) (hqs : ∑ i, q i = 1) :
    relEntropy p q = 0 ↔ p = q := by
  constructor
  · intro h
    have h_eq : ∀ i, p i * Real.log (p i / q i) = p i - q i := by
      have hsum : ∑ i, (p i * Real.log (p i / q i) - (p i - q i)) = 0 := by
        simp_all +decide [relEntropy]
      rw [Finset.sum_eq_zero_iff_of_nonneg] at hsum
      · exact fun i => eq_of_sub_eq_zero (hsum i (Finset.mem_univ i))
      · exact fun i _ => by
          linarith [term_ge (p i) (q i) (hp i) (hq i)]
    exact funext fun i =>
      (term_ge (p i) (q i) (hp i) (hq i)).2.mp (h_eq i)
  · intro h
    unfold relEntropy
    aesop

/-- Point mass on the first point of `Fin 2`. -/
def pointMassTwo : Fin 2 -> Real := fun i => if i = 0 then 1 else 0

/-- Uniform probability distribution on `Fin 2`. -/
def uniformTwo : Fin 2 -> Real := fun _ => 1 / 2

/-- Nondegenerate control: a point mass has strictly positive relative entropy
against the uniform two-point distribution. -/
theorem pointMass_uniform_relEntropy_pos :
    0 < relEntropy pointMassTwo uniformTwo := by
  simp [relEntropy, pointMassTwo, uniformTwo]
  exact Real.log_pos (by norm_num)

/-- Boundary control: a distribution has zero relative entropy from itself. -/
theorem uniform_relEntropy_self_zero :
    relEntropy uniformTwo uniformTwo = 0 := by
  norm_num [relEntropy, uniformTwo, Fin.sum_univ_two]

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGibbsInequality.relEntropy_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relEntropy_nonneg

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGibbsInequality.relEntropy_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms relEntropy_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.FiniteGibbsInequality.pointMass_uniform_relEntropy_pos' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pointMass_uniform_relEntropy_pos

end PhysicsSM.Draft.NullEdge.FiniteGibbsInequality
