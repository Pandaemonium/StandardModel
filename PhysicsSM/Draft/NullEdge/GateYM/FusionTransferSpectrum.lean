import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.Theorem2AreaLaw
import PhysicsSM.Draft.NullEdge.GateYM.IndependentPlaquetteEnsemble

/-!
# Gate YM1/YM-gap lane: the fusion convolution as a transfer operator with
kernel-checked spectrum

The 2D lattice-gauge transfer operator in the class-function sector IS the
fusion convolution `convLeft w` of `FusionConvolution.lean`. This module
upgrades the pointwise fusion identities to genuine SPECTRAL statements in
Mathlib's `Module.End` eigenvector language, which is the language the D12
mass-gap definition (`TransferGapDefinition.lean`) will eventually consume:

- `convLeftLinear w`: the convolution as a linear endomorphism of the
  function space `G -> C`.
- `hasEigenvector_const_one`: the constant function `1` (the "vacuum"
  vector, i.e. the character of the trivial representation) is an
  eigenvector with eigenvalue `sum_g w g` - the one-plaquette normalization
  scalar itself. No representation theory needed.
- `character_one_ne_zero` / `character_ne_zero`: a simple complex `FDRep`
  has `chi(1) != 0`, hence a nonzero character.
- `convLeft_character_eigen`: the general class-function form of the fusion
  eigen-identity (the Wilson-weight case in `Theorem2AreaLaw.wilson_gamma`
  is the specialization).
- `hasEigenvector_character` / `hasEigenvalue_character`: the character of
  ANY simple complex `FDRep` is an eigenvector of `convLeftLinear w` with
  eigenvalue `(sum_g w g * chi_R(g^-1)) / chi_R(1)`, for any class function
  `w`.
- `wilsonStringTension` and `norm_wilson_loop_expectation_exp`: the
  confinement-language restatement of the independent-plaquette area law:
  `|<W_R>| = |chi_R(1)| * exp(-sigma * area)` with
  `sigma := -log |wilsonNormalizedGamma|`, under the explicit nondegeneracy
  hypothesis `wilsonNormalizedGamma != 0`.

## What this module does NOT claim (explicit)

- No identification with `TransferGapDefinition.finiteMassGap` yet: that
  definition wants REAL ordered eigenvalues `0 < lambda1 <= lambda0`.
  Missing prerequisites, deliberately not smuggled in: reality of the
  Wilson fusion eigenvalues (needs conjugation symmetry of characters),
  the character bound `|chi_R(g)| <= chi_R(1)` giving
  `|gamma| <= 1` (spectral dominance of the vacuum), and strict
  positivity. These are the next honest targets for the gap lane.
- No claim that `convLeftLinear` restricted to class functions is the FULL
  transfer matrix of a concrete lattice; that identification goes through
  the tree-gauge layer (`TreeGaugeBridge.lean` and Aristotle job
  `1d9b5b19`).

Claim label: **finite identity**. Draft-trust: kernel-checked, no
`s o r r y`, no `n a t i v e _ d e c i d e`. Prerequisites:
`FusionConvolution`, `Theorem2AreaLaw`, `IndependentPlaquetteEnsemble`.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace FusionTransferSpectrum

open scoped Matrix

open FusionConvolution CategoryTheory

variable {G : Type} [Group G] [Fintype G]

/-- The fusion convolution as a linear endomorphism of `G -> C`:
`(convLeftLinear w) chi = fun A => sum_h w h * chi (h^-1 * A)`. -/
def convLeftLinear (w : G → ℂ) : (G → ℂ) →ₗ[ℂ] (G → ℂ) where
  toFun chi := convLeft w chi
  map_add' f g := by
    funext A
    simp only [convLeft, Pi.add_apply, mul_add]
    rw [Finset.sum_add_distrib]
  map_smul' c f := by
    funext A
    simp only [convLeft, Pi.smul_apply, smul_eq_mul, RingHom.id_apply,
      Finset.mul_sum]
    refine Finset.sum_congr rfl ?_
    intro h _hh
    ring

@[simp] lemma convLeftLinear_apply (w chi : G → ℂ) (A : G) :
    convLeftLinear w chi A = convLeft w chi A := rfl

/-- The constant function `1` (the trivial-representation character) is an
eigenvector of the fusion convolution with eigenvalue `sum_g w g` - the
one-plaquette normalization scalar. This is the "vacuum" eigenpair of the
2D transfer operator, and needs no representation theory. -/
theorem hasEigenvector_const_one (w : G → ℂ) :
    Module.End.HasEigenvector (convLeftLinear w) (∑ g : G, w g)
      (fun _ : G => (1 : ℂ)) := by
  constructor
  · rw [Module.End.mem_eigenspace_iff]
    funext A
    simp [convLeft]
  · intro h
    have h1 := congrFun h (1 : G)
    simp at h1

omit [Fintype G] in
/-- A simple complex `FDRep` has nonzero character at the identity: its
underlying space is nontrivial, so `chi(1) = finrank > 0`. Extracted from
the `hchar1` step of `Theorem2AreaLaw.wilson_gamma`. -/
theorem character_one_ne_zero (R : FDRep ℂ G) [Simple R] :
    R.character 1 ≠ 0 := by
  rw [FDRep.char_one]
  have : Nontrivial R := by
    have hfin : Module.finrank ℂ (Representation.linHom R.ρ R.ρ).invariants = 1 := by
      rw [LinearEquiv.finrank_eq
        (Representation.linHom.invariantsEquivFDRepHom R R),
        FDRep.finrank_hom_simple_simple R R]
      simp
    by_contra hsub
    rw [not_nontrivial_iff_subsingleton] at hsub
    have : Module.finrank ℂ (Representation.linHom R.ρ R.ρ).invariants = 0 :=
      Module.finrank_zero_of_subsingleton
    omega
  exact_mod_cast Module.finrank_pos.ne'

/-- The character of a simple complex `FDRep` is nonzero as a function. -/
theorem character_ne_zero (R : FDRep ℂ G) [Simple R] :
    (R.character : G → ℂ) ≠ 0 := by
  intro h
  exact character_one_ne_zero R (congrFun h 1)

/-- General class-function form of the one-step fusion eigen-identity:
`convLeft w chi_R = ((sum_g w g * chi_R(g^-1)) / chi_R(1)) * chi_R`.
`Theorem2AreaLaw.wilson_gamma` is the Wilson-weight specialization. -/
theorem convLeft_character_eigen (w : G → ℂ) (hw : IsClassFunction w)
    (R : FDRep ℂ G) [Simple R] (A : G) :
    convLeft w R.character A
      = ((∑ g : G, w g * R.character g⁻¹) / R.character 1) * R.character A := by
  have hchar1 : R.character 1 ≠ 0 := character_one_ne_zero R
  have hkey := lemma2a_fusion_convolution R w hw A
  unfold convLeft
  field_simp
  linear_combination hkey

/-- **Transfer-spectrum form of Lemma 2a.** For any class function `w`, the
character of any simple complex `FDRep` is an eigenvector of the fusion
convolution operator, with eigenvalue
`(sum_g w g * chi_R(g^-1)) / chi_R(1)`. -/
theorem hasEigenvector_character (w : G → ℂ) (hw : IsClassFunction w)
    (R : FDRep ℂ G) [Simple R] :
    Module.End.HasEigenvector (convLeftLinear w)
      ((∑ g : G, w g * R.character g⁻¹) / R.character 1)
      (R.character : G → ℂ) := by
  constructor
  · rw [Module.End.mem_eigenspace_iff]
    funext A
    simp only [convLeftLinear_apply, Pi.smul_apply, smul_eq_mul]
    exact convLeft_character_eigen w hw R A
  · exact character_ne_zero R

/-- Eigenvalue form of `hasEigenvector_character`. -/
theorem hasEigenvalue_character (w : G → ℂ) (hw : IsClassFunction w)
    (R : FDRep ℂ G) [Simple R] :
    Module.End.HasEigenvalue (convLeftLinear w)
      ((∑ g : G, w g * R.character g⁻¹) / R.character 1) :=
  Module.End.hasEigenvalue_of_hasEigenvector (hasEigenvector_character w hw R)

/-- Wilson specialization: the vacuum eigenvalue of the Wilson fusion
convolution is exactly the one-plaquette normalization scalar
`wilsonPlaquetteSumC`. -/
theorem hasEigenvector_const_one_wilson {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    Module.End.HasEigenvector
      (convLeftLinear (Theorem2AreaLaw.wilsonLocalWeightC beta rho))
      (Theorem2AreaLaw.wilsonPlaquetteSumC beta rho)
      (fun _ : G => (1 : ℂ)) := by
  have := hasEigenvector_const_one (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
  simpa [Theorem2AreaLaw.wilsonPlaquetteSumC] using this

/-- Wilson specialization: characters of simple complex `FDRep`s are
eigenvectors of the Wilson fusion convolution. Together with
`hasEigenvector_const_one_wilson`, the eigenvalue RATIO is exactly
`wilsonNormalizedGamma * (chi_R(1) cancellation)`-free form used by the area
law. -/
theorem hasEigenvector_character_wilson {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (R : FDRep ℂ G) [Simple R] :
    Module.End.HasEigenvector
      (convLeftLinear (Theorem2AreaLaw.wilsonLocalWeightC beta rho))
      ((∑ g : G, Theorem2AreaLaw.wilsonLocalWeightC beta rho g
          * R.character g⁻¹) / R.character 1)
      (R.character : G → ℂ) :=
  hasEigenvector_character _
    (Theorem2AreaLaw.wilsonLocalWeightC_class beta rho hmul hone) R

/-! ## String-tension language for the area law -/

section StringTension

variable {ν : Type} [Fintype ν] [DecidableEq ν]

open IndependentPlaquetteEnsemble

/-- The (finite, independent-plaquette) Wilson string tension:
`sigma := -log |wilsonNormalizedGamma|`. Positive exactly when
`|gamma| < 1`; the spectral-dominance statement `|gamma| <= 1` is future
work (needs the character bound `|chi(g)| <= chi(1)`). -/
def wilsonStringTension {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℝ :=
  -Real.log ‖Theorem2AreaLaw.wilsonNormalizedGamma beta rho R‖

/-- **Confinement-language area law.** In the independent-plaquette Wilson
ensemble, for nondegenerate `gamma`, the Wilson-loop expectation decays as
`exp(-sigma * area)` with `sigma` the string tension:
`|<W_R>| = |chi_R(1)| * exp(-sigma * m)`. -/
theorem norm_wilson_loop_expectation_exp {n : ℕ} (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (R : FDRep ℂ G) [Simple R]
    (hgamma : Theorem2AreaLaw.wilsonNormalizedGamma beta rho R ≠ 0)
    {m : ℕ} (hm : m ≤ Fintype.card ν) (e : Fin m ↪ ν) :
    ‖loopExpectation (Theorem2AreaLaw.wilsonLocalWeightC beta rho)
        R.character e‖
      = ‖R.character 1‖
        * Real.exp (-(wilsonStringTension beta rho R) * m) := by
  rw [norm_wilson_loop_expectation beta rho hmul hone hunit R hm e]
  congr 1
  have hpos : 0 < ‖Theorem2AreaLaw.wilsonNormalizedGamma beta rho R‖ :=
    norm_pos_iff.mpr hgamma
  have hpowpos : 0 < ‖Theorem2AreaLaw.wilsonNormalizedGamma beta rho R‖ ^ m :=
    pow_pos hpos m
  rw [← Real.exp_log hpowpos, Real.log_pow, wilsonStringTension]
  ring_nf

end StringTension

end FusionTransferSpectrum
end GateYM
end NullEdge
end Draft
end PhysicsSM
