import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionEnsemble

/-!
# Gate YM3: reflection identities for plaquette-product ensembles

This module lifts `PlaquetteReflection.productWeight_reflectLinkField_of_mirrorStable`
from product weights to the finite partition, numerator, and expectation
bookkeeping of `PlaquetteEnsemble`. It also provides paired-family corollaries
for the common case where a finite plaquette family is packaged together with
its reflected partner.

The hypotheses are intentionally explicit:

* a finite plaquette family is mirror-stable up to a finite reindexing;
* the local weight has the required opposite-group compatibility on that
  family and link field.

No Wilson-specific opposite-compatibility theorem, cut factorization, positive
side algebra, or RP-LINK inequality is proved here.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace PlaquetteReflectionEnsemble

open GaugeCoreGeneral ReflectionCore PlaquetteCore PlaquetteReflection

variable {Λ : OrientedLattice}
variable (R : ReflectionCore.Reflection Λ)
variable {G : Type*} [Group G]
variable {ι : Type*} [Fintype ι]

/-- Plaquette-ensemble weight invariance under reflection for a mirror-stable
plaquette family, assuming the local opposite-group compatibility needed by the
product-level theorem. -/
theorem weight_reflectLinkField_of_mirrorStable
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → ℝ)
    (hstable : IsMirrorStableFamily R P τ)
    (hop : ∀ U : Λ.LinkField (G := G), ∀ i : ι,
      (fun h : MulOpposite G => localWeight h.unop)
        ((P i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight ((P i).hol U))
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight P localWeight (R.reflectLinkField U) =
      PlaquetteEnsemble.weight P localWeight U := by
  unfold PlaquetteEnsemble.weight
  exact productWeight_reflectLinkField_of_mirrorStable R P τ localWeight hstable U (hop U)

/-- Under mirror-stability and local opposite-compatibility, reflecting only
the observable leaves the plaquette-product numerator unchanged. -/
theorem numerator_observable_comp_reflectLinkField_of_mirrorStable
    [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → ℝ)
    (hstable : IsMirrorStableFamily R P τ)
    (hop : ∀ U : Λ.LinkField (G := G), ∀ i : ι,
      (fun h : MulOpposite G => localWeight h.unop)
        ((P i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight ((P i).hol U))
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.numerator P localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.numerator P localWeight observable := by
  unfold PlaquetteEnsemble.numerator
  exact ReflectionEnsemble.numerator_observable_comp_reflectLinkField_of_weight_invariant
    R (PlaquetteEnsemble.weight P localWeight) observable
    (weight_reflectLinkField_of_mirrorStable R P τ localWeight hstable hop)

/-- Under mirror-stability and local opposite-compatibility, reflecting only
the observable leaves the plaquette-product expectation unchanged. -/
theorem expectation_observable_comp_reflectLinkField_of_mirrorStable
    [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → ℝ)
    (hstable : IsMirrorStableFamily R P τ)
    (hop : ∀ U : Λ.LinkField (G := G), ∀ i : ι,
      (fun h : MulOpposite G => localWeight h.unop)
        ((P i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight ((P i).hol U))
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation P localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.expectation P localWeight observable := by
  unfold PlaquetteEnsemble.expectation
  exact ReflectionEnsemble.expectation_observable_comp_reflectLinkField_of_weight_invariant
    R (PlaquetteEnsemble.weight P localWeight) observable
    (weight_reflectLinkField_of_mirrorStable R P τ localWeight hstable hop)

/-- Plaquette-ensemble weight invariance for a paired family whose two halves
are explicitly identified as mirror partners. The local opposite-compatibility
hypothesis is still stated over the resulting paired family. -/
theorem weight_reflectLinkField_of_mirrorPair
    (P Q : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hop : ∀ U : Λ.LinkField (G := G), ∀ i : Bool × ι,
      (fun h : MulOpposite G => localWeight h.unop)
        (((mirrorPairFamily P Q) i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight (((mirrorPairFamily P Q) i).hol U))
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight (mirrorPairFamily P Q) localWeight (R.reflectLinkField U) =
      PlaquetteEnsemble.weight (mirrorPairFamily P Q) localWeight U := by
  exact weight_reflectLinkField_of_mirrorStable R (mirrorPairFamily P Q)
    (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hop U

/-- Numerator reflection identity for a paired plaquette family. This is the
paired-family specialization of
`numerator_observable_comp_reflectLinkField_of_mirrorStable`. -/
theorem numerator_observable_comp_reflectLinkField_of_mirrorPair
    [Fintype (Λ.LinkField (G := G))]
    (P Q : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hop : ∀ U : Λ.LinkField (G := G), ∀ i : Bool × ι,
      (fun h : MulOpposite G => localWeight h.unop)
        (((mirrorPairFamily P Q) i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight (((mirrorPairFamily P Q) i).hol U))
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.numerator (mirrorPairFamily P Q) localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.numerator (mirrorPairFamily P Q) localWeight observable := by
  exact numerator_observable_comp_reflectLinkField_of_mirrorStable R
    (mirrorPairFamily P Q) (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hop observable

/-- Expectation reflection identity for a paired plaquette family. This is the
paired-family specialization of
`expectation_observable_comp_reflectLinkField_of_mirrorStable`. -/
theorem expectation_observable_comp_reflectLinkField_of_mirrorPair
    [Fintype (Λ.LinkField (G := G))]
    (P Q : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hop : ∀ U : Λ.LinkField (G := G), ∀ i : Bool × ι,
      (fun h : MulOpposite G => localWeight h.unop)
        (((mirrorPairFamily P Q) i).hol (ReflectionCore.Reflection.opLinkField U)) =
      localWeight (((mirrorPairFamily P Q) i).hol U))
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation (mirrorPairFamily P Q) localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.expectation (mirrorPairFamily P Q) localWeight observable := by
  exact expectation_observable_comp_reflectLinkField_of_mirrorStable R
    (mirrorPairFamily P Q) (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hop observable

end PlaquetteReflectionEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
