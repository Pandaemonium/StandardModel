import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflectionEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight

/-!
# Gate YM3: Wilson weights and the reflection convention

This module supplies the Wilson-specific bridge needed after
`PlaquetteReflection.localWeight_hol_mirrorPlaquette`.

**N3-corrected convention (Route B).** `ReflectionCore.reflectLinkField` now
carries a group inverse (`(theta U) e = (U (reflectE e))^{-1}`), which makes
the genuine mirror-plaquette holonomy the honest GROUP INVERSE of the
original plaquette holonomy at the reflected configuration
(`PlaquetteReflection.hol_mirrorPlaquette_eq_inv`) - a conjugacy-class
invariant, unlike the previous pure word reversal that node N3
(`MirrorHolonomyConjugation.lean`) showed was false for nonabelian gauge
groups. Consequently the Wilson-specific bridge needed here is simply
inversion-invariance of the Wilson local weight
(`WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary`, an immediate
consequence of unitarity), applied directly in `G` - no `MulOpposite`
detour, no separate "opposite representation" `rhoOppositeInv`. (The
previous version of this module built exactly such an opposite-inverse
representation as a workaround for the uncorrected, non-conjugacy-invariant
mirror convention; that workaround is no longer needed and has been
removed.)

This gives Wilson-specialized single-plaquette, product-weight, and
`PlaquetteEnsemble.weight` reflection identities, and rephrases the
mirror-stable/paired-family product and ensemble wrappers with a Wilson
inversion-invariance hypothesis. The module still stops before discharging
that same-family compatibility for a concrete plaquette family, or proving
any cut factorization, positive-side algebra, or RP-LINK inequality; see
`MirrorHolonomyResolution.lean` for the general (independent-configuration)
mirror-plaquette Wilson-weight identity this bridge feeds into.

Draft-trust: kernel-checked, no `s o r r y`, no
`n a t i v e _ d e c i d e`.
Claim label: **finite identity**.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonReflectionCompatibility

open scoped Matrix
open GaugeCoreGeneral ReflectionCore PlaquetteCore PlaquetteReflection

variable {G : Type*} [Group G] {n : ℕ}

/-- Single-plaquette Wilson reflection identity.

For a unitary representation, the mirror plaquette's Wilson weight at `U`
equals the original plaquette's Wilson weight at the reflected link field
`theta U` - a direct consequence of `hol_mirrorPlaquette_eq_inv` plus
inversion-invariance of the Wilson weight. -/
theorem localWeight_hol_reflectLinkField_mirrorPlaquette_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    (p : Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (U : Λ.LinkField (G := G)) :
    WilsonLocalWeight.wilsonLocalWeight beta rho ((mirrorPlaquette R p).hol U) =
      WilsonLocalWeight.wilsonLocalWeight beta rho (p.hol (R.reflectLinkField U)) :=
  PlaquetteReflection.localWeight_hol_mirrorPlaquette R
    (WilsonLocalWeight.wilsonLocalWeight beta rho)
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) p U

/-- Wilson-specialized reflected product-weight identity.

Reflecting a plaquette family sends the Wilson product for `rho` at the
mirror family evaluated at `U` to the original family's Wilson product at
the reflected link field `theta U`. -/
theorem productWeight_reflectLinkField_mirrorPlaquette_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight (fun i => mirrorPlaquette R (P i))
        (WilsonLocalWeight.wilsonLocalWeight beta rho) U =
      PlaquetteCore.productWeight P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (R.reflectLinkField U) :=
  PlaquetteReflection.productWeight_reflectLinkField_mirrorPlaquette R P
    (WilsonLocalWeight.wilsonLocalWeight beta rho)
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) U

/-- `PlaquetteEnsemble.weight` wrapper for the Wilson reflected product-weight
identity. This is just the ensemble-level name for
`productWeight_reflectLinkField_mirrorPlaquette_wilson`. -/
theorem weight_reflectLinkField_mirrorPlaquette_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight (fun i => mirrorPlaquette R (P i))
        (WilsonLocalWeight.wilsonLocalWeight beta rho) U =
      PlaquetteEnsemble.weight P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (R.reflectLinkField U) := by
  unfold PlaquetteEnsemble.weight
  exact productWeight_reflectLinkField_mirrorPlaquette_wilson R P beta rho hmul hone hunit U

/-- Wilson product-weight reflection for a mirror-stable plaquette family. -/
theorem productWeight_reflectLinkField_of_mirrorStable_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hstable : IsMirrorStableFamily R P τ)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (R.reflectLinkField U) =
      PlaquetteCore.productWeight P (WilsonLocalWeight.wilsonLocalWeight beta rho) U :=
  PlaquetteReflection.productWeight_reflectLinkField_of_mirrorStable
    R P τ (WilsonLocalWeight.wilsonLocalWeight beta rho) hstable
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) U

/-- Wilson product-weight reflection for a paired plaquette family whose
halves are explicit mirror partners. -/
theorem productWeight_reflectLinkField_of_mirrorPair_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P Q : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho) (R.reflectLinkField U) =
      PlaquetteCore.productWeight (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho) U :=
  PlaquetteReflection.productWeight_reflectLinkField_of_mirrorPair
    R P Q (WilsonLocalWeight.wilsonLocalWeight beta rho) hPQ hQP
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) U

/-- Wilson same-family weight reflection for a mirror-stable plaquette
family. -/
theorem weight_reflectLinkField_of_mirrorStable_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hstable : IsMirrorStableFamily R P τ)
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (R.reflectLinkField U) =
      PlaquetteEnsemble.weight P (WilsonLocalWeight.wilsonLocalWeight beta rho) U :=
  PlaquetteReflectionEnsemble.weight_reflectLinkField_of_mirrorStable
    R P τ (WilsonLocalWeight.wilsonLocalWeight beta rho) hstable
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) U

/-- Wilson numerator reflection for a mirror-stable plaquette family. -/
theorem numerator_observable_comp_reflectLinkField_of_mirrorStable_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι] [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hstable : IsMirrorStableFamily R P τ)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.numerator P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.numerator P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        observable :=
  PlaquetteReflectionEnsemble.numerator_observable_comp_reflectLinkField_of_mirrorStable
    R P τ (WilsonLocalWeight.wilsonLocalWeight beta rho) hstable
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit)
    observable

/-- Wilson expectation reflection for a mirror-stable plaquette family. -/
theorem expectation_observable_comp_reflectLinkField_of_mirrorStable_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι] [Fintype (Λ.LinkField (G := G))]
    (P : ι → Plaquette Λ) (τ : ι ≃ ι) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hstable : IsMirrorStableFamily R P τ)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.expectation P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        observable :=
  PlaquetteReflectionEnsemble.expectation_observable_comp_reflectLinkField_of_mirrorStable
    R P τ (WilsonLocalWeight.wilsonLocalWeight beta rho) hstable
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit)
    observable

/-- Wilson weight reflection for a paired plaquette family whose halves are
explicit mirror partners. -/
theorem weight_reflectLinkField_of_mirrorPair_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P Q : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (U : Λ.LinkField (G := G)) :
    PlaquetteEnsemble.weight (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho) (R.reflectLinkField U) =
      PlaquetteEnsemble.weight (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho) U :=
  PlaquetteReflectionEnsemble.weight_reflectLinkField_of_mirrorPair
    R P Q (WilsonLocalWeight.wilsonLocalWeight beta rho) hPQ hQP
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) U

/-- Wilson numerator reflection for a paired mirror-family package. -/
theorem numerator_observable_comp_reflectLinkField_of_mirrorPair_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι] [Fintype (Λ.LinkField (G := G))]
    (P Q : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.numerator (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.numerator (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho) observable :=
  PlaquetteReflectionEnsemble.numerator_observable_comp_reflectLinkField_of_mirrorPair
    R P Q (WilsonLocalWeight.wilsonLocalWeight beta rho) hPQ hQP
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) observable

/-- Wilson expectation reflection for a paired mirror-family package. -/
theorem expectation_observable_comp_reflectLinkField_of_mirrorPair_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι] [Fintype (Λ.LinkField (G := G))]
    (P Q : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (hPQ : ∀ i : ι, mirrorPlaquette R (P i) = Q i)
    (hQP : ∀ i : ι, mirrorPlaquette R (Q i) = P i)
    (observable : Λ.LinkField (G := G) → ℝ) :
    PlaquetteEnsemble.expectation (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (fun U => observable (R.reflectLinkField U)) =
      PlaquetteEnsemble.expectation (mirrorPairFamily P Q)
        (WilsonLocalWeight.wilsonLocalWeight beta rho) observable :=
  PlaquetteReflectionEnsemble.expectation_observable_comp_reflectLinkField_of_mirrorPair
    R P Q (WilsonLocalWeight.wilsonLocalWeight beta rho) hPQ hQP
    (WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit) observable

end WilsonReflectionCompatibility
end GateYM
end NullEdge
end Draft
end PhysicsSM
