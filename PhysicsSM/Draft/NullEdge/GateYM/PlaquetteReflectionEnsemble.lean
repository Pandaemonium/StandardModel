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

**N3-corrected convention.** `ReflectionCore.reflectLinkField` now carries a
group inverse (see that module's docstring), so the hypothesis needed here is
plain group-inversion invariance of the local weight (`hinv : ∀ g, localWeight
g⁻¹ = localWeight g`) rather than an opposite-group (`MulOpposite`)
compatibility condition. For a concrete Wilson weight, `hinv` is exactly the
unitary-representation inversion symmetry `Re chi(g^-1) = Re chi(g)`.

The hypotheses are intentionally explicit:

* a finite plaquette family is mirror-stable up to a finite reindexing;
* the local weight is invariant under group inversion.

The Wilson bridge lives in `WilsonReflectionCompatibility.lean`; this module
still does not discharge cut factorization, positive-side algebra, or
RP-LINK inequality.

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
plaquette family, assuming the local weight is invariant under group
inversion. -/
theorem weight_reflectLinkField_of_mirrorStable
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → ℝ)
    (hstable : IsMirrorStableFamily R P τ)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight P localWeight (R.reflectLinkField U) =
      PlaquetteEnsemble.weight P localWeight U := by
  unfold PlaquetteEnsemble.weight
  exact productWeight_reflectLinkField_of_mirrorStable R P τ localWeight hstable hinv U

/-- Under mirror-stability and local inversion-invariance, reflecting only
the observable leaves the plaquette-product numerator unchanged. -/
theorem numerator_observable_comp_reflectLinkField_of_mirrorStable
    [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → ℝ)
    (hstable : IsMirrorStableFamily R P τ)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.numerator P localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.numerator P localWeight observable := by
  unfold PlaquetteEnsemble.numerator
  exact ReflectionEnsemble.numerator_observable_comp_reflectLinkField_of_weight_invariant
    R (PlaquetteEnsemble.weight P localWeight) observable
    (weight_reflectLinkField_of_mirrorStable R P τ localWeight hstable hinv)

/-- Under mirror-stability and local inversion-invariance, reflecting only
the observable leaves the plaquette-product expectation unchanged. -/
theorem expectation_observable_comp_reflectLinkField_of_mirrorStable
    [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (localWeight : G → ℝ)
    (hstable : IsMirrorStableFamily R P τ)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation P localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.expectation P localWeight observable := by
  unfold PlaquetteEnsemble.expectation
  exact ReflectionEnsemble.expectation_observable_comp_reflectLinkField_of_weight_invariant
    R (PlaquetteEnsemble.weight P localWeight) observable
    (weight_reflectLinkField_of_mirrorStable R P τ localWeight hstable hinv)

/-- Plaquette-ensemble weight invariance for a paired family whose two halves
are explicitly identified as mirror partners. The local inversion-invariance
hypothesis is still stated over the resulting paired family. -/
theorem weight_reflectLinkField_of_mirrorPair
    (P Q : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight (mirrorPairFamily P Q) localWeight (R.reflectLinkField U) =
      PlaquetteEnsemble.weight (mirrorPairFamily P Q) localWeight U := by
  exact weight_reflectLinkField_of_mirrorStable R (mirrorPairFamily P Q)
    (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hinv U

/-- Numerator reflection identity for a paired plaquette family. This is the
paired-family specialization of
`numerator_observable_comp_reflectLinkField_of_mirrorStable`. -/
theorem numerator_observable_comp_reflectLinkField_of_mirrorPair
    [Fintype (Λ.LinkField (G := G))]
    (P Q : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.numerator (mirrorPairFamily P Q) localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.numerator (mirrorPairFamily P Q) localWeight observable := by
  exact numerator_observable_comp_reflectLinkField_of_mirrorStable R
    (mirrorPairFamily P Q) (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hinv observable

/-- Expectation reflection identity for a paired plaquette family. This is the
paired-family specialization of
`expectation_observable_comp_reflectLinkField_of_mirrorStable`. -/
theorem expectation_observable_comp_reflectLinkField_of_mirrorPair
    [Fintype (Λ.LinkField (G := G))]
    (P Q : ι → Plaquette Λ) (localWeight : G → ℝ)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (hinv : ∀ g : G, localWeight g⁻¹ = localWeight g)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation (mirrorPairFamily P Q) localWeight
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.expectation (mirrorPairFamily P Q) localWeight observable := by
  exact expectation_observable_comp_reflectLinkField_of_mirrorStable R
    (mirrorPairFamily P Q) (mirrorPairIndexEquiv (ι := ι)) localWeight
    (mirrorPairFamily_isMirrorStable R P Q hPQ hQP) hinv observable

end PlaquetteReflectionEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
