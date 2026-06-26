import Mathlib

/-!
# NullStrand graph support powers target

Finite matrix-support lemma: support of powers lies in relation powers.
-/

noncomputable section

namespace NullStrandGraphSupportPowers

open scoped BigOperators
open Matrix

/-- Matrix support constrained by a relation. -/
def SupportedOn {Alpha : Type*} (A : Matrix Alpha Alpha Real) (R : Alpha -> Alpha -> Prop) : Prop :=
  ∀ i j, A i j ≠ 0 -> R i j

/-- Relation composition. -/
def RelComp {Alpha : Type*} (R S : Alpha -> Alpha -> Prop) : Alpha -> Alpha -> Prop :=
  fun i k => ∃ j, R i j ∧ S j k

/-- Relation powers, with power zero equal to equality. -/
def RelPow {Alpha : Type*} (R : Alpha -> Alpha -> Prop) : Nat -> Alpha -> Alpha -> Prop
  | 0 => fun i j => i = j
  | n + 1 => RelComp (RelPow R n) R

/-- Support of a matrix product lies in the composed support relation. -/
theorem support_mul_subset_relComp {Alpha : Type*} [Fintype Alpha]
    (A B : Matrix Alpha Alpha Real) (R S : Alpha -> Alpha -> Prop)
    (hA : SupportedOn A R) (hB : SupportedOn B S) :
    SupportedOn (A * B) (RelComp R S) := by
  intro i k h_nonzero
  have h_sum_nonzero : ∃ j, A i j * B j k ≠ 0 := by
    exact not_forall.mp fun h => h_nonzero <| by
      simp +decide [h, Matrix.mul_apply]
  exact ⟨h_sum_nonzero.choose,
    hA _ _ (by
      simpa using h_sum_nonzero.choose_spec |> fun h => by aesop),
    hB _ _ (by
      simpa using h_sum_nonzero.choose_spec |> fun h => by aesop)⟩

/-- Support of `A^n` lies in the `n`th relation power of the support relation. -/
theorem support_pow_subset_relPow {Alpha : Type*} [Fintype Alpha] [DecidableEq Alpha]
    (A : Matrix Alpha Alpha Real) (R : Alpha -> Alpha -> Prop)
    (hA : SupportedOn A R) (n : Nat) :
    SupportedOn (A ^ n) (RelPow R n) := by
  induction' n with n ih
  · intro i j
    by_cases hij : i = j <;> simp_all +decide
    exact rfl
  · convert support_mul_subset_relComp _ _ _ _ ih hA using 1

end NullStrandGraphSupportPowers
