import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.WilsonWeightPositivity
import PhysicsSM.Draft.NullEdge.GateYM.ReflectionPositivityKernel

/-!
# Gate YM3 Q1: the Wilson cut-plaquette PSD bridge (kernel-algebra layer)

This module supplies the missing abstract connector that turns the Route-B
Wilson one-plaquette kernel `WilsonWeightPositivity.wilsonKernel_posSemidef`
into a `ReflectionPositivityKernel.cutKernel` PSD fact for a single
cut-plaquette factor, WITHOUT going through the spectral / nonnegative-mixture
route (`cutKernel_posSemidef_of_mixture`).

## The point

A single Wilson cut plaquette, in mirror coordinates, contributes a weight of
the shape

  `W a c b = exp(beta * Re chi(e c a * (e c b)^{-1}))`

where `e : C -> A -> G` is the (reflection-symmetric) map that reads off the
group element the positive side (`a`, at cut `c`) and, by the SAME functional
form, the mirrored negative side (`b`, at cut `c`) contribute to the plaquette
holonomy. Because both sides are read by the SAME map `e c`, the cut kernel at
fixed `c` is a PRINCIPAL submatrix of the Wilson one-plaquette kernel:

  `cutKernel W c = ((wilsonKernel beta rho).map ofReal).submatrix (e c) (e c)`

(up to the inversion symmetry `reChar_inv_of_unitary`), and
`Matrix.PosSemidef.submatrix` + a real-to-complex cast finish it. Spectral
decomposition is NOT needed for a single factor; the mixture corollary is only
needed for genuinely non-single-word PSD cut couplings.

Once each single factor is PSD, finite products of cut-plaquette factors are
handled by the existing Hadamard/Schur connectors
(`cutKernel_finset_prod_posSemidef`), so the whole cut-plaquette layer closes
from finite-product PSD plus `reflectionForm_nonneg` - see
`reflectionForm_nonneg_of_wilsonFactor_prod`.

## What is NOT here

No lattice geometry. This module does NOT prove that the genuine Wilson
`PlaquetteEnsemble.weight` of a lattice with cut plaquettes actually HAS the
`exp(beta * Re chi(e c a * (e c b)^{-1}))` shape at mirror coordinates; that is
the geometric plumbing (a concrete minimal cut-plaquette lattice + a
`LinkField ~ (A -> G) x (C -> G) x (A -> G)` mirror-coordinate equiv), queued
separately. This is the kernel-algebra half only.

Claim label: **finite identity**. Prerequisites: Mathlib,
`WilsonWeightPositivity`, `ReflectionPositivityKernel`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace WilsonCutPlaquettePositivity

open scoped Matrix ComplexOrder
open WilsonWeightPositivity ReflectionPositivityKernel

variable {G : Type*} [Group G] [Fintype G] {n : ℕ}
variable {A C : Type} [Fintype A] [Fintype C]

set_option linter.unusedFintypeInType false in
/-- Entrywise cast of a real PSD matrix to `ℂ` stays PSD. Small reusable
kernel-algebra bridge (the Wilson kernel is real-valued but the RP cut kernel
lives over `ℂ`). -/
theorem posSemidef_map_ofReal {ι : Type*} [Fintype ι] {M : Matrix ι ι ℝ}
    (hM : M.PosSemidef) : (M.map (Complex.ofReal)).PosSemidef := by
  refine' ⟨ _, _ ⟩ <;> simp_all +decide [ Matrix.IsHermitian, Matrix.PosSemidef ];
  · ext i j; simp +decide [Complex.ext_iff]
    exact congr_fun ( congr_fun hM.1 i ) j ▸ rfl;
  · intro x
    set ReX : ι → ℝ := fun i => (x i).re
    set ImX : ι → ℝ := fun i => (x i).im
    have h_quad_form_real : (x.sum (fun i xi => x.sum (fun j xj => (starRingEnd ℂ) xi * (M i j : ℂ) * xj))).re = (Finsupp.sum (Finsupp.equivFunOnFinite.symm ReX) (fun i xi => Finsupp.sum (Finsupp.equivFunOnFinite.symm ReX) (fun j xj => xi * M i j * xj))) + (Finsupp.sum (Finsupp.equivFunOnFinite.symm ImX) (fun i xi => Finsupp.sum (Finsupp.equivFunOnFinite.symm ImX) (fun j xj => xi * M i j * xj))) := by
      simp +decide [Finsupp.sum_fintype] ; ring_nf; (
      simp +decide only [Finset.sum_add_distrib] ; ring_nf!;)
    generalize_proofs at *; (
    refine' Complex.le_def.mpr ⟨ _, _ ⟩ <;> simp_all +decide;
    · exact add_nonneg ( hM.2 _ ) ( hM.2 _ );
    · simp +decide [ Finsupp.sum, Complex.mul_re, Complex.mul_im ];
      rw [ Finset.sum_comm ] ; simp +decide [ Finset.sum_add_distrib, mul_comm, mul_left_comm ] ; ring_nf;
      rw [ ← Finset.sum_comm ] ; simp +decide [ mul_comm, mul_left_comm, ← Matrix.ext_iff ] at * ; aesop;)

set_option linter.unusedFintypeInType false in
set_option linter.unusedSectionVars false in
/-- **The Wilson cut-plaquette PSD bridge.** For a unitary representation and
`beta >= 0`, a single Wilson cut-plaquette factor - one whose weight at mirror
coordinates is `exp(beta * Re chi(e c a * (e c b)^{-1}))`, i.e. the entry
`wilsonKernel beta rho (e c a) (e c b)` cast to `ℂ` - has a positive
semidefinite cut kernel at every cut configuration. Proved by identifying the
cut kernel with a principal submatrix of `wilsonKernel` (reindexed by `e c`)
and casting to `ℂ`; no spectral decomposition. -/
theorem cutKernel_posSemidef_of_wilsonFactor
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (e : C → A → G) (c : C) :
    (cutKernel (A := A) (C := C)
      (fun a c' b => ((wilsonKernel beta rho (e c' a) (e c' b) : ℝ) : ℂ)) c).PosSemidef := by
  convert Matrix.PosSemidef.submatrix ( posSemidef_map_ofReal ( WilsonWeightPositivity.wilsonKernel_posSemidef beta hbeta rho hmul hone hunit ) ) ( e c ) using 1;
  ext a b; simp +decide [ cutKernel, Matrix.submatrix_apply ] ;
  unfold wilsonKernel; simp +decide;
  exact Or.inl ( WilsonWeightPositivity.reChar_inv_of_unitary rho hmul hone hunit _ ▸ by group )

set_option linter.unusedFintypeInType false in
/-- End-to-end reflection positivity for a single Wilson cut-plaquette factor. -/
theorem reflectionForm_nonneg_of_wilsonFactor
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (e : C → A → G) :
    IsReflectionPositive (A := A) (C := C)
      (fun a c b => ((wilsonKernel beta rho (e c a) (e c b) : ℝ) : ℂ)) :=
  reflectionForm_nonneg _
    (fun c => cutKernel_posSemidef_of_wilsonFactor beta hbeta rho hmul hone hunit e c)

set_option linter.unusedFintypeInType false in
/-- End-to-end reflection positivity for a finite PRODUCT of Wilson
cut-plaquette factors - the whole cut-plaquette layer, assembled through the
existing Hadamard/Schur finite-product connector once each factor is PSD. -/
theorem reflectionForm_nonneg_of_wilsonFactor_prod {K : Type} (s : Finset K)
    (beta : ℝ) (hbeta : 0 ≤ beta)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (e : K → C → A → G) :
    IsReflectionPositive (A := A) (C := C)
      (fun a c b => ∏ k ∈ s, ((wilsonKernel beta rho (e k c a) (e k c b) : ℝ) : ℂ)) :=
  reflectionForm_nonneg_of_finset_prod_posSemidef s
    (fun k a c b => ((wilsonKernel beta rho (e k c a) (e k c b) : ℝ) : ℂ))
    (fun k _ c => cutKernel_posSemidef_of_wilsonFactor beta hbeta rho hmul hone hunit (e k) c)

end WilsonCutPlaquettePositivity
end GateYM
end NullEdge
end Draft
end PhysicsSM
