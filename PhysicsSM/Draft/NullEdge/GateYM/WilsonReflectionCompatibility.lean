import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteReflection
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight

/-!
# Gate YM3: Wilson weights and the opposite reflection convention

This module supplies the Wilson-specific bridge needed after
`PlaquetteReflection.productWeight_reflectLinkField_mirrorPlaquette`.
Reflecting a plaquette boundary reverses noncommutative multiplication order, so
the reflected product naturally lands in `MulOpposite G`. For a representation
`rho : G -> Mat_n(C)`, the honest representation of `MulOpposite G` is

`rhoOppositeInv rho h = rho h.unop^{-1}`.

The inverse is load-bearing: it corrects the order reversal in the opposite
group. Under the usual unitarity hypothesis, the Wilson local weight for this
opposite representation agrees pointwise with the `h.unop` local weight used by
the generic reflection product theorem. This gives Wilson-specialized
single-plaquette, product-weight, and `PlaquetteEnsemble.weight` reflection
identities, still stopping before any cut factorization, same-family reflection
invariance, positive-side algebra, or RP-LINK inequality.

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

/-- The inverse-pulled representation on the opposite group.

For `h : MulOpposite G`, the underlying group element is `h.unop`; the inverse
makes the multiplication law covariant rather than contravariant. -/
noncomputable def rhoOppositeInv
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (h : MulOpposite G) :
    Matrix (Fin n) (Fin n) ℂ :=
  rho h.unop⁻¹

/-- `rhoOppositeInv` is multiplicative when `rho` is multiplicative. -/
theorem rhoOppositeInv_mul
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (g h : MulOpposite G) :
    rhoOppositeInv rho (g * h) = rhoOppositeInv rho g * rhoOppositeInv rho h := by
  simp [rhoOppositeInv, hmul]

/-- `rhoOppositeInv` sends the opposite identity to the identity matrix. -/
theorem rhoOppositeInv_one
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hone : rho 1 = 1) :
    rhoOppositeInv rho 1 = 1 := by
  simp [rhoOppositeInv, hone]

/-- If `rho` is unitary, then the opposite inverse representation is unitary. -/
theorem rhoOppositeInv_unitary
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (h : MulOpposite G) :
    (rhoOppositeInv rho h)ᴴ * rhoOppositeInv rho h = 1 := by
  simp [rhoOppositeInv, hunit]

/-- The Wilson local weight for the opposite inverse representation agrees
with the generic reflected-product local weight `h |-> w(h.unop)`.

The proof uses the existing unitarity-dependent inversion symmetry of the real
character, so no extra reflection or plaquette geometry is hidden here. -/
theorem wilsonLocalWeight_rhoOppositeInv
    (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (h : MulOpposite G) :
    WilsonLocalWeight.wilsonLocalWeight beta (rhoOppositeInv rho) h =
      WilsonLocalWeight.wilsonLocalWeight beta rho h.unop := by
  unfold WilsonLocalWeight.wilsonLocalWeight WilsonWeightPositivity.reChar rhoOppositeInv
  rw [WilsonWeightPositivity.rho_inv_eq_conjTranspose rho hmul hone hunit]
  simp [Matrix.trace_conjTranspose]

/-- Single-plaquette Wilson reflection identity.

The reflected plaquette holonomy for `rho` is measured by the mirrored plaquette
over `opLinkField U` using the opposite inverse representation. -/
theorem localWeight_hol_reflectLinkField_mirrorPlaquette_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    (p : Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (U : Λ.LinkField (G := G)) :
    WilsonLocalWeight.wilsonLocalWeight beta rho (p.hol (R.reflectLinkField U)) =
      WilsonLocalWeight.wilsonLocalWeight beta (rhoOppositeInv rho)
        ((mirrorPlaquette R p).hol (ReflectionCore.Reflection.opLinkField U)) := by
  have hgen := PlaquetteReflection.localWeight_hol_reflectLinkField_mirrorPlaquette R
    (WilsonLocalWeight.wilsonLocalWeight beta rho) p U
  rw [hgen]
  exact (wilsonLocalWeight_rhoOppositeInv beta rho hmul hone hunit
    ((mirrorPlaquette R p).hol (ReflectionCore.Reflection.opLinkField U))).symm

/-- Wilson-specialized reflected product-weight identity.

Reflecting a plaquette family sends the Wilson product for `rho` to the mirrored
plaquette family with the opposite inverse representation `rhoOppositeInv rho`.
This is the precise Wilson/opposite compatibility statement available at the
pure product-weight level. It does not assert reflection invariance of a chosen
plaquette set. -/
theorem productWeight_reflectLinkField_mirrorPlaquette_wilson
    {Λ : OrientedLattice} (R : ReflectionCore.Reflection Λ)
    {ι : Type*} [Fintype ι]
    (P : ι → Plaquette Λ) (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (U : Λ.LinkField (G := G)) :
    PlaquetteCore.productWeight P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (R.reflectLinkField U) =
      PlaquetteCore.productWeight (fun i => mirrorPlaquette R (P i))
        (WilsonLocalWeight.wilsonLocalWeight beta (rhoOppositeInv rho))
        (ReflectionCore.Reflection.opLinkField U) := by
  rw [PlaquetteReflection.productWeight_reflectLinkField_mirrorPlaquette]
  unfold PlaquetteCore.productWeight
  refine Finset.prod_congr rfl ?_
  intro i _hi
  rw [wilsonLocalWeight_rhoOppositeInv beta rho hmul hone hunit]

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
    PlaquetteEnsemble.weight P (WilsonLocalWeight.wilsonLocalWeight beta rho)
        (R.reflectLinkField U) =
      PlaquetteEnsemble.weight (fun i => mirrorPlaquette R (P i))
        (WilsonLocalWeight.wilsonLocalWeight beta (rhoOppositeInv rho))
        (ReflectionCore.Reflection.opLinkField U) := by
  unfold PlaquetteEnsemble.weight
  exact productWeight_reflectLinkField_mirrorPlaquette_wilson R P beta rho hmul hone hunit U

end WilsonReflectionCompatibility
end GateYM
end NullEdge
end Draft
end PhysicsSM
