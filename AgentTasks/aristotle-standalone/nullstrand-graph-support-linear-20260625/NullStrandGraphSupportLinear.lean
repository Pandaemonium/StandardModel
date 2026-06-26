import Mathlib

/-!
# NullStrand graph support under linear operations

Focused graph-operator support algebra: support constraints are stable under
scalar multiplication and addition with relation union.
-/

noncomputable section

namespace NullStrandGraphSupportLinear

open Matrix

/-- Matrix support constrained by a relation. -/
def SupportedOn {Alpha : Type*} (A : Matrix Alpha Alpha Real) (R : Alpha -> Alpha -> Prop) : Prop :=
  ∀ i j, A i j ≠ 0 -> R i j

/-- Scalar multiples do not enlarge support. -/
theorem support_smul_subset {Alpha : Type*}
    (c : Real) (A : Matrix Alpha Alpha Real) (R : Alpha -> Alpha -> Prop)
    (hA : SupportedOn A R) :
    SupportedOn (c • A) R := by
  intro i j hij
  apply hA i j
  intro h
  simp [Matrix.smul_apply, h] at hij

/-- Sums are supported on the union of the two support relations. -/
theorem support_add_subset_or {Alpha : Type*}
    (A B : Matrix Alpha Alpha Real) (R S : Alpha -> Alpha -> Prop)
    (hA : SupportedOn A R) (hB : SupportedOn B S) :
    SupportedOn (A + B) (fun i j => R i j ∨ S i j) := by
  intro i j hij
  by_cases hAij : A i j = 0
  · right
    apply hB i j
    intro h
    simp [Matrix.add_apply, hAij, h] at hij
  · left
    exact hA i j hAij

end NullStrandGraphSupportLinear
