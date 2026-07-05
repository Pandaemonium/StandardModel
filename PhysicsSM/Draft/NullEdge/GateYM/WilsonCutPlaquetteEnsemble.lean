import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.PlaquetteEnsemble
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight
import PhysicsSM.Draft.NullEdge.GateYM.WilsonCutPlaquettePositivity

/-!
# Gate YM3/Q1: cut-plaquette ensemble bridge from holonomy factorization

This draft module packages the reusable step between concrete cut geometry and
the kernel-algebra theorem in `WilsonCutPlaquettePositivity.lean`.

If a finite plaquette family `P : K -> Plaquette L` has, in mirror coordinates
`config a c b`, holonomies of the symmetric form

`(P k).hol (config a c b) = e k c a * (e k c b)^-1`,

then its genuine Wilson `PlaquetteEnsemble.weight` is exactly the finite
product of Wilson cut kernels. The existing Schur/product PSD theorem then
gives reflection positivity, optionally multiplied by an arbitrary factorized
positive/mirror side contribution.

Scope boundary: this module does not construct the mirror-coordinate
equivalence or prove the holonomy factorization for a particular large
cut-bearing lattice. It is the abstract ensemble bridge that a future concrete
geometry must feed.

Claim label: **finite identity / conditional assembly bridge**. Draft-trust:
kernel-checked; no proof placeholders.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonCutPlaquetteEnsemble

open scoped Matrix ComplexOrder
open GaugeCoreGeneral PlaquetteCore
open WilsonWeightPositivity WilsonCutPlaquettePositivity

variable {G : Type*} [Group G] [Fintype G] {n : ℕ}
variable {Λ : OrientedLattice}
variable {A C K : Type} [Fintype A] [Fintype C] [Fintype K]

omit [Fintype G] [Fintype A] [Fintype C] in
/-- If every plaquette holonomy in mirror coordinates has the symmetric
read-off form `e k c a * (e k c b)^-1`, then the genuine Wilson
`PlaquetteEnsemble.weight` is the finite product of the corresponding Wilson
cut kernels. -/
theorem weight_mirrorConfig_eq_wilsonKernel_prod_of_hol_factorization
    (P : K → Plaquette Λ)
    (config : A → C → A → Λ.LinkField (G := G))
    (e : K → C → A → G)
    (hhol : ∀ k a c b,
      (P k).hol (config a c b) = e k c a * (e k c b)⁻¹)
    (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (a : A) (c : C) (b : A) :
    PlaquetteEnsemble.weight P
        (WilsonLocalWeight.wilsonLocalWeight beta rho) (config a c b)
      = ∏ k : K, wilsonKernel beta rho (e k c a) (e k c b) := by
  simp [PlaquetteEnsemble.weight, productWeight,
    WilsonLocalWeight.wilsonLocalWeight, wilsonKernel, hhol]

set_option linter.unusedFintypeInType false in
/-- Reflection positivity for any finite Wilson cut-plaquette family whose
mirror-coordinate holonomies have the symmetric read-off form. This is the
abstract ensemble bridge; the concrete geometry still has to prove `hhol`. -/
theorem reflectionPositive_of_hol_factorization
    (P : K → Plaquette Λ)
    (config : A → C → A → Λ.LinkField (G := G))
    (e : K → C → A → G)
    (hhol : ∀ k a c b,
      (P k).hol (config a c b) = e k c a * (e k c b)⁻¹)
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1) :
    ReflectionPositivityKernel.IsReflectionPositive (A := A) (C := C)
      (fun a c b =>
        ((PlaquetteEnsemble.weight P
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (config a c b) : ℝ) : ℂ)) := by
  convert
    (reflectionForm_nonneg_of_wilsonFactor_prod
      (A := A) (C := C) (G := G) (n := n)
      (s := (Finset.univ : Finset K))
      beta hbeta rho hmul hone hunit e) using 1
  funext a c b
  simp [weight_mirrorConfig_eq_wilsonKernel_prod_of_hol_factorization
    P config e hhol beta rho a c b]

set_option linter.unusedFintypeInType false in
/-- Mixed reflection positivity for a factorized positive/mirror contribution
times any finite Wilson cut-plaquette family whose mirror-coordinate holonomies
have the symmetric read-off form. -/
theorem factorized_mul_reflectionPositive_of_hol_factorization
    (P : K → Plaquette Λ)
    (config : A → C → A → Λ.LinkField (G := G))
    (e : K → C → A → G)
    (hhol : ∀ k a c b,
      (P k).hol (config a c b) = e k c a * (e k c b)⁻¹)
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (h : A → C → ℂ) :
    ReflectionPositivityKernel.IsReflectionPositive (A := A) (C := C)
      (fun a c b =>
        (h a c * (starRingEnd ℂ) (h b c)) *
          ((PlaquetteEnsemble.weight P
            (WilsonLocalWeight.wilsonLocalWeight beta rho)
            (config a c b) : ℝ) : ℂ)) := by
  convert
    (reflectionForm_nonneg_of_factorized_mul_wilsonFactor_prod
      (A := A) (C := C) (G := G) (n := n)
      (s := (Finset.univ : Finset K))
      beta hbeta rho hmul hone hunit h e) using 1
  funext a c b
  simp [weight_mirrorConfig_eq_wilsonKernel_prod_of_hol_factorization
    P config e hhol beta rho a c b]

end WilsonCutPlaquetteEnsemble
end GateYM
end NullEdge
end Draft
end PhysicsSM
