import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionCore
import PhysicsSM.Draft.NullEdge.GateYM.LatticeEnsemble

/-!
# Gate YM3: finite reflection change of variables

This draft module is the reflection analogue of the finite gauge
change-of-variables lemmas in `LatticeEnsemble`. A `Reflection` acts as an
involution on link fields, hence as an equivalence of finite configuration
space. The partition function, weighted numerators, and expectations inherit
the corresponding finite-sum identities.

This is still only measure/bookkeeping scaffolding. It does not prove Wilson
action covariance, cut factorization, or reflection positivity.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace ReflectionEnsemble

open GaugeCoreGeneral ReflectionCore

variable {Λ : OrientedLattice}
variable {G : Type*} [Group G]

/-- Reflection is an equivalence of link-field configuration space. -/
def reflectLinkFieldEquiv (R : ReflectionCore.Reflection Λ) :
    Λ.LinkField (G := G) ≃ Λ.LinkField (G := G) where
  toFun := R.reflectLinkField
  invFun := R.reflectLinkField
  left_inv U := R.reflectLinkField_involutive U
  right_inv U := R.reflectLinkField_involutive U

/-- Finite change of variables under link-field reflection. -/
theorem sum_comp_reflectLinkField (R : ReflectionCore.Reflection Λ) {A : Type*}
    [AddCommMonoid A] [Fintype (Λ.LinkField (G := G))]
    (F : Λ.LinkField (G := G) → A) :
    (∑ U, F (R.reflectLinkField U)) = ∑ U, F U := by
  simpa [reflectLinkFieldEquiv] using
    (Equiv.sum_comp (reflectLinkFieldEquiv (G := G) R) F)

/-- The finite partition sum is unchanged by precomposing the weight with
reflection. -/
theorem partition_comp_reflectLinkField (R : ReflectionCore.Reflection Λ)
    [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ) :
    LatticeEnsemble.partition Λ (fun U => weight (R.reflectLinkField U))
      = LatticeEnsemble.partition Λ weight := by
  unfold LatticeEnsemble.partition
  exact sum_comp_reflectLinkField R weight

/-- The finite numerator is unchanged if both the weight and observable are
precomposed with reflection. -/
theorem numerator_comp_reflectLinkField (R : ReflectionCore.Reflection Λ)
    [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ) :
    LatticeEnsemble.numerator Λ
        (fun U => weight (R.reflectLinkField U))
        (fun U => observable (R.reflectLinkField U))
      = LatticeEnsemble.numerator Λ weight observable := by
  unfold LatticeEnsemble.numerator
  exact sum_comp_reflectLinkField R (fun U => observable U * weight U)

/-- Under a reflection-invariant weight, reflecting only the observable leaves
the numerator unchanged. -/
theorem numerator_observable_comp_reflectLinkField_of_weight_invariant
    (R : ReflectionCore.Reflection Λ)
    [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ U, weight (R.reflectLinkField U) = weight U) :
    LatticeEnsemble.numerator Λ weight (fun U => observable (R.reflectLinkField U))
      = LatticeEnsemble.numerator Λ weight observable := by
  unfold LatticeEnsemble.numerator
  calc
    (∑ U, observable (R.reflectLinkField U) * weight U)
        = ∑ U, observable (R.reflectLinkField U) * weight (R.reflectLinkField U) := by
            refine Finset.sum_congr rfl ?_
            intro U _hU
            rw [hweight U]
    _ = ∑ U, observable U * weight U := by
            exact sum_comp_reflectLinkField R (fun U => observable U * weight U)

/-- Under a reflection-invariant weight, reflecting only the observable leaves
the expectation unchanged. -/
theorem expectation_observable_comp_reflectLinkField_of_weight_invariant
    (R : ReflectionCore.Reflection Λ)
    [Fintype (Λ.LinkField (G := G))]
    (weight : Λ.LinkField (G := G) → ℝ)
    (observable : Λ.LinkField (G := G) → ℝ)
    (hweight : ∀ U, weight (R.reflectLinkField U) = weight U) :
    LatticeEnsemble.expectation Λ weight (fun U => observable (R.reflectLinkField U))
      = LatticeEnsemble.expectation Λ weight observable := by
  unfold LatticeEnsemble.expectation
  rw [numerator_observable_comp_reflectLinkField_of_weight_invariant R weight observable hweight]

end ReflectionEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
