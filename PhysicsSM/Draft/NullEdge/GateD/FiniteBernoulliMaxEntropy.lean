import PhysicsSM.Draft.NullEdge.GateD.FiniteFirstLaw

/-!
# Gate D1: finite product-marginal maximum entropy

This Draft module proves the finite classical entropy subadditivity step used
by the Gate D maximum-entropy program.  It reuses the finite Shannon and
relative-entropy conventions from
`PhysicsSM.Draft.NullEdge.GateD.FiniteFirstLaw`:

* `shannon p = - sum_i p_i log p_i`;
* `relEntropy p q = sum_i p_i (log p_i - log q_i)`.

For a finite joint distribution `p : alpha x beta -> R`, we define the two
one-site marginals and their product distribution.  In the interior case where
both marginals are strictly positive, Gibbs' inequality for
`relEntropy p (productOfMarginals p)` gives

`S(p) <= S(p_left) + S(p_right)`.

Claim label: **finite structural theorem**.  This is classical finite
subadditivity / the product-marginal maximum-entropy principle, not a continuum
modular-flow theorem and not a quantum matrix-entropy statement.

Status: draft-trust; no `s o r r y`, no `n a t i v e _ d e c i d e`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateD
namespace FiniteBernoulliMaxEntropy

open scoped BigOperators

variable {α β : Type*} [Fintype α] [Fintype β]

/-- Left marginal of a finite joint weight vector. -/
def marginalLeft (p : α × β -> ℝ) (a : α) : ℝ :=
  ∑ b, p (a, b)

/-- Right marginal of a finite joint weight vector. -/
def marginalRight (p : α × β -> ℝ) (b : β) : ℝ :=
  ∑ a, p (a, b)

/-- Product distribution with the same one-site marginals as `p`. -/
def productOfMarginals (p : α × β -> ℝ) (ab : α × β) : ℝ :=
  marginalLeft p ab.1 * marginalRight p ab.2

omit [Fintype α] in
/-- Nonnegative joint weights have nonnegative left marginals. -/
theorem marginalLeft_nonneg (p : α × β -> ℝ)
    (hp : ∀ ab, 0 <= p ab) (a : α) :
    0 <= marginalLeft p a := by
  unfold marginalLeft
  exact Finset.sum_nonneg fun b _ => hp (a, b)

omit [Fintype β] in
/-- Nonnegative joint weights have nonnegative right marginals. -/
theorem marginalRight_nonneg (p : α × β -> ℝ)
    (hp : ∀ ab, 0 <= p ab) (b : β) :
    0 <= marginalRight p b := by
  unfold marginalRight
  exact Finset.sum_nonneg fun a _ => hp (a, b)

/-- Summing the left marginal recovers the joint total mass. -/
theorem marginalLeft_sum (p : α × β -> ℝ) :
    (∑ a, marginalLeft p a) = ∑ ab, p ab := by
  unfold marginalLeft
  rw [← Finset.univ_product_univ, Finset.sum_product]

/-- Summing the right marginal recovers the joint total mass. -/
theorem marginalRight_sum (p : α × β -> ℝ) :
    (∑ b, marginalRight p b) = ∑ ab, p ab := by
  unfold marginalRight
  calc
    (∑ b, ∑ a, p (a, b)) = ∑ a, ∑ b, p (a, b) := by
      rw [Finset.sum_comm]
    _ = ∑ ab : α × β, p ab := by
      rw [← Finset.univ_product_univ, Finset.sum_product]

/-- Strictly positive marginals make the product-marginal reference positive. -/
theorem productOfMarginals_pos (p : α × β -> ℝ)
    (hleft : ∀ a, 0 < marginalLeft p a)
    (hright : ∀ b, 0 < marginalRight p b) :
    ∀ ab, 0 < productOfMarginals p ab := by
  intro ab
  exact mul_pos (hleft ab.1) (hright ab.2)

/-- A normalized joint distribution has a normalized product-marginal reference. -/
theorem productOfMarginals_sum_one (p : α × β -> ℝ)
    (hpsum : ∑ ab, p ab = 1) :
    (∑ ab, productOfMarginals p ab) = 1 := by
  unfold productOfMarginals
  calc
    (∑ ab : α × β, marginalLeft p ab.1 * marginalRight p ab.2)
        = ∑ a, ∑ b, marginalLeft p a * marginalRight p b := by
          rw [← Finset.univ_product_univ, Finset.sum_product]
    _ = ∑ a, marginalLeft p a * (∑ b, marginalRight p b) := by
          apply Finset.sum_congr rfl
          intro a _
          rw [Finset.mul_sum]
    _ = ∑ a, marginalLeft p a := by
          simp [marginalRight_sum p, hpsum]
    _ = 1 := by
          rw [marginalLeft_sum p, hpsum]

/-- Fold a joint sum whose logarithmic factor depends only on the left index. -/
theorem sum_joint_log_left (p : α × β -> ℝ) (L : α -> ℝ) :
    (∑ ab, p ab * Real.log (L ab.1)) =
      ∑ a, marginalLeft p a * Real.log (L a) := by
  calc
    (∑ ab : α × β, p ab * Real.log (L ab.1))
        = ∑ a, ∑ b, p (a, b) * Real.log (L a) := by
          rw [← Finset.univ_product_univ, Finset.sum_product]
    _ = ∑ a, marginalLeft p a * Real.log (L a) := by
          unfold marginalLeft
          apply Finset.sum_congr rfl
          intro a _
          rw [Finset.sum_mul]

/-- Fold a joint sum whose logarithmic factor depends only on the right index. -/
theorem sum_joint_log_right (p : α × β -> ℝ) (R : β -> ℝ) :
    (∑ ab, p ab * Real.log (R ab.2)) =
      ∑ b, marginalRight p b * Real.log (R b) := by
  calc
    (∑ ab : α × β, p ab * Real.log (R ab.2))
        = ∑ a, ∑ b, p (a, b) * Real.log (R b) := by
          rw [← Finset.univ_product_univ, Finset.sum_product]
    _ = ∑ b, ∑ a, p (a, b) * Real.log (R b) := by
          rw [Finset.sum_comm]
    _ = ∑ b, marginalRight p b * Real.log (R b) := by
          unfold marginalRight
          apply Finset.sum_congr rfl
          intro b _
          rw [Finset.sum_mul]

/--
Cross-entropy against the product-marginal reference splits into the two
marginal Shannon entropies.
-/
theorem crossEntropy_productOfMarginals (p : α × β -> ℝ)
    (hleft : ∀ a, 0 < marginalLeft p a)
    (hright : ∀ b, 0 < marginalRight p b) :
    FiniteFirstLaw.crossEntropy p (productOfMarginals p) =
      FiniteFirstLaw.shannon (marginalLeft p) +
        FiniteFirstLaw.shannon (marginalRight p) := by
  unfold FiniteFirstLaw.shannon FiniteFirstLaw.crossEntropy productOfMarginals
  simp_rw [Real.log_mul (ne_of_gt (hleft _)) (ne_of_gt (hright _))]
  simp_rw [mul_add]
  rw [Finset.sum_add_distrib]
  rw [sum_joint_log_left, sum_joint_log_right]
  ring

/--
Gate D1 finite subadditivity / product-marginal maximum-entropy theorem.

For a finite nonnegative normalized joint distribution whose marginals are
strictly positive, the joint Shannon entropy is bounded above by the sum of the
two marginal entropies.  The proof is the KL-to-product argument:
`0 <= S_rel(p || p_left p_right)`.
-/
theorem d1_joint_entropy_subadditivity (p : α × β -> ℝ)
    (hp : ∀ ab, 0 <= p ab)
    (hpsum : ∑ ab, p ab = 1)
    (hleft : ∀ a, 0 < marginalLeft p a)
    (hright : ∀ b, 0 < marginalRight p b) :
    FiniteFirstLaw.shannon p <=
      FiniteFirstLaw.shannon (marginalLeft p) +
        FiniteFirstLaw.shannon (marginalRight p) := by
  let q : α × β -> ℝ := productOfMarginals p
  have hqpos : ∀ ab, 0 < q ab := by
    intro ab
    exact productOfMarginals_pos p hleft hright ab
  have hqsum : ∑ ab, q ab = 1 := by
    simpa [q] using productOfMarginals_sum_one p hpsum
  have hrel := FiniteFirstLaw.relEntropy_nonneg p q hp hqpos hpsum hqsum
  rw [FiniteFirstLaw.relEntropy_eq] at hrel
  have hle : FiniteFirstLaw.shannon p <= FiniteFirstLaw.crossEntropy p q := by
    linarith
  simpa [q, crossEntropy_productOfMarginals p hleft hright] using hle

end FiniteBernoulliMaxEntropy
end GateD
end NullEdge
end Draft
end PhysicsSM
