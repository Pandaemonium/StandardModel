import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.FusionConvolution
import PhysicsSM.Draft.NullEdge.GateYM.WilsonLocalWeight

/-!
# Gate YM1: Theorem 2 area-law iteration, specialized to the Wilson weight

Recommended next action (morning report, `AgentTasks/overnight-ym-run-2026-07-03/
MORNING_REPORT.md` section 8, item 1): now that `FusionConvolution.lean`'s
`lemma2a_fusion_convolution` is Aristotle-integrated, specialize it to the
concrete Wilson local weight (`WilsonLocalWeight.wilsonLocalWeight`) and feed
the result into `iterConv_eigen_at_one`, keeping every remaining assumption
explicit rather than derived.

## What this file proves

1. `wilsonLocalWeightC`: the Wilson local weight cast to `C`, and
   `wilsonLocalWeightC_class`: it is a class function (a direct corollary of
   `WilsonLocalWeight.wilsonLocalWeight_class`, real-to-complex cast).
   `wilsonLocalWeightC_inv_of_unitary` records the corresponding
   unitarity-dependent inversion symmetry for the complex-cast weight.
2. `wilson_gamma`: the one-step fusion eigenvalue
   `gamma_R := (sum_g w(g) chi_R(g^-1)) / chi_R(1)` for the Wilson weight `w`,
   derived from `lemma2a_fusion_convolution` by dividing through by
   `chi_R(1) != 0` (nonzero since `R` is `Simple`, hence nontrivial).
3. `wilson_iterConv_eigen_at_one`: the assembled area-law iteration,
   `iterConv w chi_R n 1 = chi_R(1) * gamma_R^n`, by feeding `wilson_gamma`
   into `FusionConvolution.iterConv_eigen_at_one`.
4. `wilson_iterConv_normalized_at_one`: the same raw convolution divided by
   the one-plaquette normalization scalar, whose nonzero proof is supplied by
   positivity of the real Wilson weights.
5. `wilsonNormalizedGamma` and
   `wilson_iterConv_normalizedGamma_at_one`: the same normalized iteration with
   the area-law scalar named explicitly for downstream statements.
6. `wilson_iterConv_normalizedGamma_cross_at_one`: the same named-scalar
   identity cross-multiplied by the one-plaquette normalization power, useful
   for future partition-prefactor statements without carrying a division.

## What this file does NOT prove (explicit, not silently assumed)

This is the "iteration/fusion" half of freeze Theorem 2 only. It does NOT
prove:

- Lemma 2b (tree-gauge/independence): that an actual finite-lattice Wilson
  loop EXPECTATION VALUE `<W_R(C_A)>` (as defined by `LatticeEnsemble`/
  `PlaquetteEnsemble`) equals `iterConv w chi_R A 1` in the first place. That
  identification needs the comb-tree change-of-variables argument reducing
  the ensemble to `A` independent plaquette variables - genuinely new content
  belonging to the `LatticeEnsemble`/`PlaquetteEnsemble` (T3) layer, not
  attempted here.
- The partition-function prefactor formula `Z_open = |G|^(V-1) (|G| w_hat_0)^P`.
- The proof that the normalization scalar below is the exact lattice
  partition-function prefactor after tree gauge.

So this theorem is exactly what its name says: an iterated-convolution
identity at the concrete Wilson weight, matching the SHAPE of Theorem 2's
displayed area law once the (still-missing) ensemble/ tree-gauge bridge
connects `iterConv` to a real expectation value.

Draft-trust: kernel-checked, no `s o r r y`, no `n a t i v e _ d e c i d e`.
Claim label: **finite identity**. Prerequisites: `FusionConvolution`,
`WilsonLocalWeight`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace Theorem2AreaLaw

open scoped Matrix

open FusionConvolution CategoryTheory

variable {G : Type} [Group G] [Fintype G] {n : ℕ}

/-- The Wilson local weight, cast from `R` to `C` so it can be fed to
`FusionConvolution`'s complex-valued convolution machinery. -/
noncomputable def wilsonLocalWeightC (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (h : G) : ℂ :=
  (WilsonLocalWeight.wilsonLocalWeight beta rho h : ℂ)

/-- The single-plaquette Wilson normalization scalar in complex form.

This is the algebraic scalar by which the raw convolution is normalized below;
identifying its powers with the finite-lattice partition prefactor is the
separate tree-gauge/ensemble bridge not proved in this file. -/
noncomputable def wilsonPlaquetteSumC (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) : ℂ :=
  ∑ g : G, wilsonLocalWeightC beta rho g

/-- The normalized Wilson fusion scalar appearing in the algebraic area-law
iteration. This packages the ratio of the representation-specific one-step
fusion scalar and the one-plaquette normalization scalar. -/
noncomputable def wilsonNormalizedGamma (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) (R : FDRep ℂ G) : ℂ :=
  ((∑ g : G, wilsonLocalWeightC beta rho g * R.character g⁻¹) / R.character 1) /
    wilsonPlaquetteSumC beta rho

/-- The real single-plaquette Wilson normalization scalar is positive: it is a
nonempty finite sum of positive exponentials. -/
theorem wilsonPlaquetteSum_pos (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    0 < ∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g := by
  refine Finset.sum_pos (fun g _hg => WilsonLocalWeight.wilsonLocalWeight_pos beta rho g) ?_
  exact ⟨1, Finset.mem_univ 1⟩

/-- The complex-cast one-plaquette Wilson normalization scalar is nonzero. -/
theorem wilsonPlaquetteSumC_ne_zero (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ) :
    wilsonPlaquetteSumC beta rho ≠ 0 := by
  have hpos := wilsonPlaquetteSum_pos (G := G) beta rho
  have hcast :
      wilsonPlaquetteSumC beta rho =
        ((∑ g : G, WilsonLocalWeight.wilsonLocalWeight beta rho g : ℝ) : ℂ) := by
    simp [wilsonPlaquetteSumC, wilsonLocalWeightC]
  rw [hcast]
  exact_mod_cast (ne_of_gt hpos)

omit [Fintype G] in
/-- The complex-cast Wilson local weight is a class function - a direct
corollary of `WilsonLocalWeight.wilsonLocalWeight_class` (which needs only
multiplicativity of `rho`, not unitarity). -/
theorem wilsonLocalWeightC_class (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1) :
    IsClassFunction (wilsonLocalWeightC beta rho) := by
  intro a h
  unfold wilsonLocalWeightC
  rw [WilsonLocalWeight.wilsonLocalWeight_class beta rho hmul hone]

omit [Fintype G] in
/-- The complex-cast Wilson local weight is inversion-symmetric for a unitary
representation. This is the form used by the complex-valued convolution layer. -/
theorem wilsonLocalWeightC_inv_of_unitary (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h)
    (hone : rho 1 = 1)
    (hunit : ∀ g : G, (rho g)ᴴ * rho g = 1)
    (g : G) :
    wilsonLocalWeightC beta rho g⁻¹ = wilsonLocalWeightC beta rho g := by
  unfold wilsonLocalWeightC
  rw [WilsonLocalWeight.wilsonLocalWeight_inv_of_unitary beta rho hmul hone hunit]

/-- The one-step Wilson fusion eigenvalue: `gamma_R := (sum_g w(g) chi_R(g^-1))
/ chi_R(1)`, derived from `lemma2a_fusion_convolution` by dividing through by
`chi_R(1) != 0` (nonzero since `R` is `Simple`, hence a nontrivial
representation with positive finite dimension). -/
theorem wilson_gamma (beta : ℝ) (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (R : FDRep ℂ G) [Simple R] (A : G) :
    convLeft (wilsonLocalWeightC beta rho) R.character A
      = ((∑ g : G, wilsonLocalWeightC beta rho g * R.character g⁻¹) / R.character 1)
        * R.character A := by
  have hchar1 : R.character 1 ≠ 0 := by
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
  have hkey := lemma2a_fusion_convolution R (wilsonLocalWeightC beta rho)
    (wilsonLocalWeightC_class beta rho hmul hone) A
  unfold convLeft
  field_simp
  linear_combination hkey

/-- The assembled area-law iteration at the Wilson weight: applying the
independent-plaquette convolution `n` times to `chi_R`, evaluated at the
identity, is exactly `chi_R(1) * gamma_R^n` - matching the shape of freeze
Theorem 2's `d_R gamma_R^A` display, with the ensemble/tree-gauge
identification (Lemma 2b) an explicit, undischarged prerequisite. -/
theorem wilson_iterConv_eigen_at_one (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (R : FDRep ℂ G) [Simple R] (m : ℕ) :
    iterConv (wilsonLocalWeightC beta rho) R.character m 1
      = R.character 1
        * ((∑ g : G, wilsonLocalWeightC beta rho g * R.character g⁻¹) / R.character 1) ^ m :=
  iterConv_eigen_at_one (wilsonLocalWeightC beta rho) R.character
    ((∑ g : G, wilsonLocalWeightC beta rho g * R.character g⁻¹) / R.character 1)
    (R.character 1) rfl (wilson_gamma beta rho hmul hone R) m

/-- Normalized Wilson-weight iteration at the identity.

Dividing the raw iterated convolution by the `m`th power of the one-plaquette
normalization scalar gives the expected `chi_R(1) * normalizedGamma^m` algebraic
shape. This is still not the finite-lattice expectation theorem: the tree-gauge
bridge must identify the normalized convolution with the Wilson-loop
expectation. -/
theorem wilson_iterConv_normalized_at_one (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (R : FDRep ℂ G) [Simple R] (m : ℕ) :
    iterConv (wilsonLocalWeightC beta rho) R.character m 1 /
        wilsonPlaquetteSumC beta rho ^ m =
      R.character 1
        * (((∑ g : G, wilsonLocalWeightC beta rho g * R.character g⁻¹) /
            R.character 1) / wilsonPlaquetteSumC beta rho) ^ m := by
  have _hZpow : wilsonPlaquetteSumC beta rho ^ m ≠ 0 :=
    pow_ne_zero m (wilsonPlaquetteSumC_ne_zero beta rho)
  rw [wilson_iterConv_eigen_at_one beta rho hmul hone R m]
  rw [div_pow]
  ring_nf

/-- Compact named-scalar form of `wilson_iterConv_normalized_at_one`.

The right-hand side is `chi_R(1) * wilsonNormalizedGamma^m`, matching the
area-law scalar shape while still leaving the ensemble/tree-gauge bridge as a
separate future theorem. -/
theorem wilson_iterConv_normalizedGamma_at_one (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (R : FDRep ℂ G) [Simple R] (m : ℕ) :
    iterConv (wilsonLocalWeightC beta rho) R.character m 1 /
        wilsonPlaquetteSumC beta rho ^ m =
      R.character 1 * wilsonNormalizedGamma beta rho R ^ m := by
  simpa [wilsonNormalizedGamma] using
    (wilson_iterConv_normalized_at_one (G := G) beta rho hmul hone R m)

/-- Cross-multiplied named-scalar form of
`wilson_iterConv_normalizedGamma_at_one`.

This avoids division by the one-plaquette scalar in downstream statements. It
is still only the algebraic convolution identity; the tree-gauge bridge and the
partition-prefactor interpretation remain separate future work. -/
theorem wilson_iterConv_normalizedGamma_cross_at_one (beta : ℝ)
    (rho : G → Matrix (Fin n) (Fin n) ℂ)
    (hmul : ∀ g h : G, rho (g * h) = rho g * rho h) (hone : rho 1 = 1)
    (R : FDRep ℂ G) [Simple R] (m : ℕ) :
    iterConv (wilsonLocalWeightC beta rho) R.character m 1 =
      wilsonPlaquetteSumC beta rho ^ m * R.character 1 *
        wilsonNormalizedGamma beta rho R ^ m := by
  have hZpow : wilsonPlaquetteSumC beta rho ^ m ≠ 0 :=
    pow_ne_zero m (wilsonPlaquetteSumC_ne_zero beta rho)
  have h := wilson_iterConv_normalizedGamma_at_one (G := G) beta rho hmul hone R m
  field_simp [hZpow] at h
  simpa using h

end Theorem2AreaLaw
end GateYM
end NullEdge
end Draft
end PhysicsSM
