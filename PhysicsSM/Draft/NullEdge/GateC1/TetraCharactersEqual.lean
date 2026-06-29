import Mathlib.Analysis.Fourier.FiniteAbelian.PontryaginDuality
import PhysicsSM.Draft.NullEdge.GateC1.FiniteFourierParseval
import PhysicsSM.Draft.NullEdge.GateC1.TetraFiniteTorusEqual

/-!
# Equal-side finite tetrahedral characters

This module begins the Fourier-character layer for the equal-side finite torus
`SiteN N = Fin 4 -> ZMod N`.

It defines momentum angles, unit complex phases, finite characters, raw
Parseval, and the unitary normalization factor.  The full normalized Fourier
operator and free-symbol diagonalization are later concrete targets.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraCharactersEqual

open scoped BigOperators
open TetraFiniteTorusEqual

/-- Coordinate projection from the rank-4 site torus to its `A`-th cyclic
factor, as an additive monoid homomorphism. -/
def coordHom (N : ℕ) [NeZero N] (A : Fin 4) : SiteN N →+ ZMod N where
  toFun := fun x => x A
  map_zero' := rfl
  map_add' := by
    intro x y
    rfl

/-- One coordinate character, pulled back to the full rank-4 site torus. -/
def coordAddChar (N : ℕ) [NeZero N] (m : MomN N) (A : Fin 4) :
    AddChar (SiteN N) ℂ :=
  (AddChar.zmodAddEquiv (m A)).compAddMonoidHom (coordHom N A)

/--
The theorem-facing additive character for the rank-4 equal-side torus.

This wraps the low-level `ZMod.val` phase convention in Mathlib's additive
character API, so shift/eigenvalue proofs can use character laws rather than
case-splitting on representatives.
-/
def siteAddChar (N : ℕ) [NeZero N] (m : MomN N) : AddChar (SiteN N) ℂ :=
  ∏ A : Fin 4, coordAddChar N m A

/-- Evaluation formula for the rank-4 additive character. -/
theorem siteAddChar_apply (N : ℕ) [NeZero N] (m : MomN N) (x : SiteN N) :
    siteAddChar N m x =
      ∏ A : Fin 4, AddChar.zmodAddEquiv (m A) (x A) := by
  unfold siteAddChar coordAddChar coordHom
  simp [Finset.prod_apply]

/-- Unit site vector in the `A`-th cyclic direction. -/
def basisSite (N : ℕ) [NeZero N] (A : Fin 4) : SiteN N :=
  fun B => if B = A then 1 else 0

/-- Embed a one-dimensional cyclic coordinate into the `A`-th site coordinate. -/
def coordEmbed (N : ℕ) [NeZero N] (A : Fin 4) : ZMod N →+ SiteN N where
  toFun := fun y B => if B = A then y else 0
  map_zero' := by
    funext B
    by_cases h : B = A
    · simp [h]
    · simp [h]
  map_add' := by
    intro x y
    funext B
    by_cases h : B = A
    · simp [h]
    · simp [h]

/-- A coordinate shift is addition of the corresponding unit site vector. -/
theorem shiftSite_eq_add_basisSite (N : ℕ) [NeZero N] (A : Fin 4) (x : SiteN N) :
    shiftSite N A x = x + basisSite N A := by
  funext B
  unfold shiftSite basisSite
  by_cases h : B = A
  · simp [h]
  · simp [h]

/-- The phase/eigenvalue attached to shifting in direction `A`. -/
def expectedPhase (N : ℕ) [NeZero N] (m : MomN N) (A : Fin 4) : ℂ :=
  siteAddChar N m (basisSite N A)

/-- Character law for coordinate shifts, in theorem-facing additive-character
form. -/
theorem siteAddChar_shiftSite (N : ℕ) [NeZero N] (m : MomN N)
    (A : Fin 4) (x : SiteN N) :
    siteAddChar N m (shiftSite N A x) =
      siteAddChar N m x * expectedPhase N m A := by
  rw [shiftSite_eq_add_basisSite]
  exact AddChar.map_add_eq_mul (siteAddChar N m) x (basisSite N A)

/-- Restricting the rank-4 character to one coordinate recovers the
corresponding one-dimensional `ZMod` character. -/
theorem siteAddChar_coordEmbed (N : ℕ) [NeZero N] (m : MomN N) (A : Fin 4) :
    (siteAddChar N m).compAddMonoidHom (coordEmbed N A) =
      AddChar.zmodAddEquiv (m A) := by
  apply AddChar.ext
  intro y
  unfold siteAddChar coordAddChar coordHom coordEmbed
  simp [Finset.prod_apply]
  rw [Finset.prod_eq_single A]
  · simp
  · intro B _hB hBA
    simp [hBA]
  · intro hA
    exact False.elim (hA (Finset.mem_univ A))

/-- Momentum labels inject into theorem-facing rank-4 additive characters. -/
theorem siteAddChar_injective (N : ℕ) [NeZero N] :
    Function.Injective (siteAddChar N) := by
  intro m m' h
  funext A
  have hc := congrArg
    (fun ψ : AddChar (SiteN N) ℂ => ψ.compAddMonoidHom (coordEmbed N A)) h
  simpa [siteAddChar_coordEmbed] using hc

/-- Momentum labels bijectively enumerate the complex characters of the site
torus. -/
theorem siteAddChar_bijective (N : ℕ) [NeZero N] :
    Function.Bijective (siteAddChar N : MomN N -> AddChar (SiteN N) ℂ) := by
  classical
  refine (Fintype.bijective_iff_injective_and_card (siteAddChar N)).2 ?_
  constructor
  · exact siteAddChar_injective N
  · exact (AddChar.card_eq (α := SiteN N)).symm

/--
Mathlib-backed character orthogonality adapter for the rank-4 site torus:
the sum of a character is the group cardinality for the trivial character and
zero otherwise.
-/
theorem siteAddChar_sum_eq_ite (N : ℕ) [NeZero N] (m : MomN N) :
    ∑ x : SiteN N, siteAddChar N m x =
      if siteAddChar N m = 0 then (Fintype.card (SiteN N) : ℂ) else 0 := by
  classical
  simpa using AddChar.sum_eq_ite (siteAddChar N m)

/--
Pairwise additive-character orthogonality on the rank-4 site torus, stated in
terms of character equality.  A later injectivity lemma for `siteAddChar` can
rewrite the condition to `m = m'`.
-/
theorem siteAddChar_pair_orthogonality_eq_ite
    (N : ℕ) [NeZero N] (m m' : MomN N) :
    ∑ x : SiteN N, (-siteAddChar N m + siteAddChar N m') x =
      if siteAddChar N m = siteAddChar N m'
      then (Fintype.card (SiteN N) : ℂ)
      else 0 := by
  classical
  simpa [neg_add_eq_zero] using
    (AddChar.sum_eq_ite
      (-siteAddChar N m + siteAddChar N m' : AddChar (SiteN N) ℂ))

/-- Pairwise additive-character orthogonality indexed by momentum labels. -/
theorem siteAddChar_pair_orthogonality_mom_eq_ite
    (N : ℕ) [NeZero N] (m m' : MomN N) :
    ∑ x : SiteN N, (-siteAddChar N m + siteAddChar N m') x =
      if m = m' then (Fintype.card (SiteN N) : ℂ) else 0 := by
  classical
  rw [siteAddChar_pair_orthogonality_eq_ite]
  have hinj := siteAddChar_injective N
  by_cases h : m = m'
  · simp [h]
  · have hchar : siteAddChar N m ≠ siteAddChar N m' := by
      intro hc
      exact h (hinj hc)
    simp [h, hchar]

/-- The Fourier-side character convention: use the negative additive character
in the transform kernel. -/
def fourierChar (N : ℕ) [NeZero N] (m : MomN N) : AddChar (SiteN N) ℂ :=
  -siteAddChar N m

/-- The Fourier-convention characters also bijectively enumerate all complex
characters of the site torus. -/
theorem fourierChar_bijective (N : ℕ) [NeZero N] :
    Function.Bijective (fourierChar N : MomN N -> AddChar (SiteN N) ℂ) := by
  classical
  have hinj : Function.Injective
      (fourierChar N : MomN N -> AddChar (SiteN N) ℂ) := by
    intro m m' h
    apply siteAddChar_injective N
    have hneg := congrArg Neg.neg h
    simpa [fourierChar] using hneg
  refine (Fintype.bijective_iff_injective_and_card (fourierChar N)).2 ?_
  constructor
  · exact hinj
  · exact (AddChar.card_eq (α := SiteN N)).symm

/-- Summing the Fourier-convention characters over momentum labels gives the
finite delta function on the site torus. -/
theorem fourierChar_sum_apply_eq_ite
    (N : ℕ) [NeZero N] (x : SiteN N) :
    ∑ m : MomN N, fourierChar N m x =
      if x = 0 then (Fintype.card (SiteN N) : ℂ) else 0 := by
  classical
  let e : MomN N ≃ AddChar (SiteN N) ℂ :=
    Equiv.ofBijective (fourierChar N) (fourierChar_bijective N)
  calc
    ∑ m : MomN N, fourierChar N m x =
        ∑ ψ : AddChar (SiteN N) ℂ, ψ x := by
          simpa [e] using
            (Equiv.sum_comp e (fun ψ : AddChar (SiteN N) ℂ => ψ x))
    _ = if x = 0 then (Fintype.card (SiteN N) : ℂ) else 0 := by
          simpa using AddChar.sum_apply_eq_ite (α := SiteN N) x

/-- Column orthogonality for the Fourier-convention character table. -/
theorem fourierChar_column_orthogonality
    (N : ℕ) [NeZero N] (x y : SiteN N) :
    ∑ m : MomN N, star (fourierChar N m x) * fourierChar N m y =
      if x = y then (Fintype.card (SiteN N) : ℂ) else 0 := by
  classical
  calc
    ∑ m : MomN N, star (fourierChar N m x) * fourierChar N m y =
        ∑ m : MomN N, fourierChar N m (-x + y) := by
          apply Finset.sum_congr rfl
          intro m _hm
          have hstar :
              star (fourierChar N m x) = fourierChar N m (-x) := by
            simpa using (AddChar.map_neg_eq_conj (fourierChar N m) x).symm
          rw [hstar]
          exact (AddChar.map_add_eq_mul (fourierChar N m) (-x) y).symm
    _ = if -x + y = 0 then (Fintype.card (SiteN N) : ℂ) else 0 := by
          simpa using fourierChar_sum_apply_eq_ite N (-x + y)
    _ = if x = y then (Fintype.card (SiteN N) : ℂ) else 0 := by
          have hzero : -x + y = 0 ↔ x = y := by
            rw [add_comm, ← sub_eq_add_neg, sub_eq_zero, eq_comm]
          by_cases hxy : x = y
          · simp [hxy, hzero]
          · simp [hxy, hzero]

/-- Unnormalized finite Fourier transform using the theorem-facing additive
character convention. -/
def rawFourier (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) : Spin -> ℂ :=
  fun s => ∑ x : SiteN N, fourierChar N m x * Psi x s

/-- Raw Parseval identity for the equal-side tetrahedral Fourier transform. -/
theorem rawFourier_l2NormSq_siteN (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (Psi : SiteN N -> Spin -> ℂ) :
    FiniteBlockDiagonalGap.blockL2NormSq (rawFourier N Psi) =
      (Fintype.card (SiteN N) : ℝ) *
        TetraFiniteTorusEqual.fieldL2NormSq N Psi := by
  simpa [rawFourier, FiniteFourierParseval.rawFourierGeneric,
    TetraFiniteTorusEqual.fieldL2NormSq] using
    (FiniteFourierParseval.rawFourier_l2NormSq_of_column_orthogonality
      (Site := SiteN N) (Mom := MomN N) (Spin := Spin)
      (chi := fun m x => fourierChar N m x)
      (coeff := (Fintype.card (SiteN N) : ℝ))
      (by
        intro x y
        simpa using fourierChar_column_orthogonality N x y)
      Psi)

/-- Shift eigenvalue for the Fourier convention used by `rawFourier`. -/
def shiftEigenvalue (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) : ℂ :=
  fourierChar N m (basisSite N A)

/-- Positive phase used by the canonical free transport shift. -/
def phasePlus (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) : ℂ :=
  siteAddChar N m (basisSite N A)

/-- The positive transport phase is exactly the one-coordinate `ZMod` character
in direction `A`. -/
theorem phasePlus_eq_zmodAddEquiv_one (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    phasePlus N m A = AddChar.zmodAddEquiv (m A) (1 : ZMod N) := by
  unfold phasePlus
  rw [siteAddChar_apply]
  rw [Finset.prod_eq_single A]
  · simp [basisSite]
  · intro B _hB hBA
    simp [basisSite, hBA]
  · intro hA
    exact False.elim (hA (Finset.mem_univ A))

/-- The inverse of a positive transport phase is its complex conjugate. -/
theorem phasePlus_inv_eq_conj (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    (phasePlus N m A)⁻¹ = star (phasePlus N m A) := by
  unfold phasePlus
  simpa using AddChar.inv_apply_eq_conj (siteAddChar N m) (basisSite N A)

/-- Character law for coordinate shifts under the Fourier convention. -/
theorem fourierChar_shiftSite (N : ℕ) [NeZero N] (m : MomN N)
    (A : Fin 4) (x : SiteN N) :
    fourierChar N m (shiftSite N A x) =
      fourierChar N m x * shiftEigenvalue N m A := by
  rw [shiftSite_eq_add_basisSite]
  exact AddChar.map_add_eq_mul (fourierChar N m) x (basisSite N A)

/-- Character law for inverse coordinate shifts under the Fourier convention. -/
theorem fourierChar_unshiftSite (N : ℕ) [NeZero N] (m : MomN N)
    (A : Fin 4) (x : SiteN N) :
    fourierChar N m (unshiftSite N A x) =
      fourierChar N m x * phasePlus N m A := by
  have h :
      unshiftSite N A x = x + (-basisSite N A) := by
    funext B
    unfold unshiftSite basisSite
    by_cases hB : B = A
    · simp [hB, sub_eq_add_neg]
    · simp [hB]
  rw [h]
  unfold phasePlus fourierChar
  rw [AddChar.map_add_eq_mul]
  congr 1
  simp [AddChar.neg_apply]

/--
Convention test for coordinate shifts: with the current pullback shift
`shiftField`, the unnormalized Fourier transform picks up `shiftEigenvalue`.

This theorem pins the sign convention before the free-symbol diagonalization.
-/
theorem rawFourier_shiftField (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    rawFourier N (shiftField N A Psi) m =
      fun s => shiftEigenvalue N m A * rawFourier N Psi m s := by
  funext s
  unfold rawFourier shiftField
  have hsum := Equiv.sum_comp (shiftEquiv N A)
    (fun x : SiteN N => fourierChar N m x * Psi (unshiftSite N A x) s)
  rw [← hsum]
  simp only [shiftEquiv, Equiv.coe_fn_mk, unshift_shift, fourierChar_shiftSite]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro x _hx
  ring

/--
Positive-phase convention test: the inverse/transport field shift has
eigenvalue `phasePlus`, matching the symbol convention `T_A -> exp(+i k_A)`.
-/
theorem rawFourier_invShiftField (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    rawFourier N (invShiftField N A Psi) m =
      fun s => phasePlus N m A * rawFourier N Psi m s := by
  funext s
  unfold rawFourier invShiftField
  have hsum := Equiv.sum_comp ((shiftEquiv N A).symm)
    (fun x : SiteN N => fourierChar N m x * Psi (shiftSite N A x) s)
  rw [← hsum]
  change
    (∑ x : SiteN N,
      fourierChar N m (unshiftSite N A x) *
        Psi (shiftSite N A (unshiftSite N A x)) s) =
      phasePlus N m A *
        (∑ x : SiteN N, fourierChar N m x * Psi x s)
  simp only [shift_unshift, fourierChar_unshiftSite]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro x _hx
  ring

/-- Transport-shift version of `rawFourier_invShiftField`. -/
theorem rawFourier_transportShift (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    rawFourier N (transportShift N A Psi) m =
      fun s => phasePlus N m A * rawFourier N Psi m s := by
  simpa [transportShift] using rawFourier_invShiftField N A Psi m

/-- The pullback shift eigenvalue is the inverse of the positive transport
phase. -/
theorem shiftEigenvalue_eq_phasePlus_inv (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    shiftEigenvalue N m A = (phasePlus N m A)⁻¹ := by
  unfold shiftEigenvalue phasePlus fourierChar
  rw [AddChar.neg_apply]
  exact AddChar.map_neg_eq_inv (siteAddChar N m) (basisSite N A)

/-- Centered finite difference built from the canonical transport orientation. -/
def centeredTransportDiff (N : ℕ) [NeZero N] {Spin : Type*} (A : Fin 4)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x s => transportShift N A Psi x s - shiftField N A Psi x s

/--
Phase-level diagonalization of the centered transport difference.

The trigonometric conversion `phase - phase^{-1} = 2 i sin(k)` is intentionally
kept separate.
-/
theorem rawFourier_centeredTransportDiff (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    rawFourier N (centeredTransportDiff N A Psi) m =
      fun s =>
        (phasePlus N m A - (phasePlus N m A)⁻¹) * rawFourier N Psi m s := by
  funext s
  unfold rawFourier centeredTransportDiff
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib]
  have hplus := congrFun (rawFourier_transportShift N A Psi m) s
  have hminus := congrFun (rawFourier_shiftField N A Psi m) s
  unfold rawFourier at hplus hminus
  rw [hplus, hminus, shiftEigenvalue_eq_phasePlus_inv]
  ring

/-- Wilson one-direction laplacian built from the canonical transport
orientation. -/
def wilsonLaplacianField (N : ℕ) [NeZero N] {Spin : Type*} (A : Fin 4)
    (Psi : SiteN N -> Spin -> ℂ) : SiteN N -> Spin -> ℂ :=
  fun x s => (2 : ℂ) * Psi x s - transportShift N A Psi x s -
    shiftField N A Psi x s

/--
Phase-level diagonalization of the one-direction Wilson laplacian.

The conversion `2 - phase - phase^{-1} = 2(1 - cos k)` is intentionally kept
separate from this finite-character theorem.
-/
theorem rawFourier_wilsonLaplacianField (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    rawFourier N (wilsonLaplacianField N A Psi) m =
      fun s =>
        (2 - phasePlus N m A - (phasePlus N m A)⁻¹) *
          rawFourier N Psi m s := by
  funext s
  unfold rawFourier wilsonLaplacianField
  simp_rw [mul_sub]
  rw [Finset.sum_sub_distrib, Finset.sum_sub_distrib]
  have hplus := congrFun (rawFourier_transportShift N A Psi m) s
  have hminus := congrFun (rawFourier_shiftField N A Psi m) s
  unfold rawFourier at hplus hminus
  rw [hplus, hminus, shiftEigenvalue_eq_phasePlus_inv]
  have htwo :
      ∑ x : SiteN N, (fourierChar N m) x * (2 * Psi x s) =
        2 * ∑ x : SiteN N, (fourierChar N m) x * Psi x s := by
    rw [Finset.mul_sum]
    apply Finset.sum_congr rfl
    intro x _hx
    ring
  rw [htwo]
  ring

/-- Real angle associated to an equal-side `ZMod N` momentum coordinate. -/
def zmodAngle (N : ℕ) [NeZero N] (m : ZMod N) : ℝ :=
  2 * Real.pi * (m.val : ℝ) / (N : ℝ)

/-- Momentum angles for all four rank-4 cyclic directions. -/
def momentumAngles (N : ℕ) [NeZero N] (m : MomN N) : Fin 4 -> ℝ :=
  fun A => zmodAngle N (m A)

/-- Unit complex phase `exp(i theta)`. -/
def phase (theta : ℝ) : ℂ :=
  Complex.exp ((theta : ℂ) * Complex.I)

/-- The phase `exp(i theta)` has complex norm square one. -/
theorem phase_normSq (theta : ℝ) : Complex.normSq (phase theta) = 1 := by
  unfold phase
  change
    (Complex.exp ((theta : ℂ) * Complex.I)).re *
        (Complex.exp ((theta : ℂ) * Complex.I)).re +
      (Complex.exp ((theta : ℂ) * Complex.I)).im *
        (Complex.exp ((theta : ℂ) * Complex.I)).im = 1
  rw [Complex.exp_ofReal_mul_I_re, Complex.exp_ofReal_mul_I_im]
  have h := Real.sin_sq_add_cos_sq theta
  nlinarith

/-- Character angle pairing momentum and site coordinates. -/
def characterAngle (N : ℕ) [NeZero N] (m : MomN N) (x : SiteN N) : ℝ :=
  2 * Real.pi *
    (∑ A : Fin 4, ((m A).val : ℝ) * ((x A).val : ℝ)) / (N : ℝ)

/-- Finite character on the equal-side rank-4 torus. -/
def character (N : ℕ) [NeZero N] (m : MomN N) (x : SiteN N) : ℂ :=
  phase (characterAngle N m x)

/-- Every finite character value has complex norm square one. -/
theorem character_normSq (N : ℕ) [NeZero N] (m : MomN N) (x : SiteN N) :
    Complex.normSq (character N m x) = 1 := by
  exact phase_normSq (characterAngle N m x)

/-- Cardinality of the equal-side site torus is positive. -/
theorem site_card_pos (N : ℕ) [NeZero N] :
    0 < Fintype.card (SiteN N) := by
  exact Fintype.card_pos_iff.mpr inferInstance

/-- Unitary Fourier normalization factor `1 / sqrt(|SiteN N|)`. -/
def fourierNormFactor (N : ℕ) [NeZero N] : ℝ :=
  1 / Real.sqrt (Fintype.card (SiteN N) : ℝ)

/-- The unitary Fourier normalization factor is positive. -/
theorem fourierNormFactor_pos (N : ℕ) [NeZero N] :
    0 < fourierNormFactor N := by
  unfold fourierNormFactor
  have hcard : 0 < (Fintype.card (SiteN N) : ℝ) := by
    exact_mod_cast site_card_pos N
  positivity

/-- Multiplying every finite momentum/spin coefficient by a constant scales
block L2 norm square by the complex norm square of that constant. -/
theorem blockL2NormSq_const_mul
    {Mom Spin : Type*} [Fintype Mom] [Fintype Spin]
    (c : ℂ) (Phi : Mom -> Spin -> ℂ) :
    FiniteBlockDiagonalGap.blockL2NormSq
        (fun m : Mom => fun s : Spin => c * Phi m s) =
      Complex.normSq c * FiniteBlockDiagonalGap.blockL2NormSq Phi := by
  unfold FiniteBlockDiagonalGap.blockL2NormSq TetraScalarWilsonSymbol.l2NormSq
  simp [Complex.normSq_mul, Finset.mul_sum]

/-- The square of the Fourier normalization cancels the site-torus cardinality. -/
theorem fourierNormFactor_sq_mul_card (N : ℕ) [NeZero N] :
    fourierNormFactor N * fourierNormFactor N *
        (Fintype.card (SiteN N) : ℝ) = 1 := by
  unfold fourierNormFactor
  have hcard : 0 < (Fintype.card (SiteN N) : ℝ) := by
    exact_mod_cast site_card_pos N
  have hsqrt :
      Real.sqrt (Fintype.card (SiteN N) : ℝ) *
          Real.sqrt (Fintype.card (SiteN N) : ℝ) =
        (Fintype.card (SiteN N) : ℝ) := by
    exact Real.mul_self_sqrt hcard.le
  have hsqrt_ne :
      Real.sqrt (Fintype.card (SiteN N) : ℝ) ≠ 0 :=
    (Real.sqrt_pos_of_pos hcard).ne'
  field_simp [hsqrt_ne]
  rw [sq]
  exact hsqrt.symm

/-- Normalized finite Fourier transform on the equal-side tetrahedral torus. -/
def fourierUnitary (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) : Spin -> ℂ :=
  fun s => (fourierNormFactor N : ℂ) * rawFourier N Psi m s

/-- The normalized equal-side tetrahedral Fourier transform preserves finite
field L2 norm square. -/
theorem fourierUnitary_l2NormSq_siteN (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (Psi : SiteN N -> Spin -> ℂ) :
    FiniteBlockDiagonalGap.blockL2NormSq (fourierUnitary N Psi) =
      TetraFiniteTorusEqual.fieldL2NormSq N Psi := by
  unfold fourierUnitary
  rw [blockL2NormSq_const_mul, rawFourier_l2NormSq_siteN]
  rw [Complex.normSq_ofReal]
  calc
    (fourierNormFactor N * fourierNormFactor N) *
        ((Fintype.card (SiteN N) : ℝ) *
          TetraFiniteTorusEqual.fieldL2NormSq N Psi)
        =
      (fourierNormFactor N * fourierNormFactor N *
          (Fintype.card (SiteN N) : ℝ)) *
        TetraFiniteTorusEqual.fieldL2NormSq N Psi := by
          ring
    _ = TetraFiniteTorusEqual.fieldL2NormSq N Psi := by
          rw [fourierNormFactor_sq_mul_card N]
          ring

/-- Normalized Fourier diagonalization of the older pullback shift. -/
theorem fourierUnitary_shiftField (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (shiftField N A Psi) m =
      fun s => (phasePlus N m A)⁻¹ * fourierUnitary N Psi m s := by
  funext s
  unfold fourierUnitary
  have hraw := congrFun (rawFourier_shiftField N A Psi m) s
  rw [hraw, shiftEigenvalue_eq_phasePlus_inv]
  ring

/-- Normalized Fourier diagonalization of the canonical positive transport
shift. -/
theorem fourierUnitary_transportShift (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (transportShift N A Psi) m =
      fun s => phasePlus N m A * fourierUnitary N Psi m s := by
  funext s
  unfold fourierUnitary
  have hraw := congrFun (rawFourier_transportShift N A Psi m) s
  rw [hraw]
  ring

/-- Normalized Fourier diagonalization of the centered transport difference. -/
theorem fourierUnitary_centeredTransportDiff (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (centeredTransportDiff N A Psi) m =
      fun s =>
        (phasePlus N m A - (phasePlus N m A)⁻¹) *
          fourierUnitary N Psi m s := by
  funext s
  unfold fourierUnitary
  have hraw := congrFun (rawFourier_centeredTransportDiff N A Psi m) s
  rw [hraw]
  ring

/-- Normalized Fourier diagonalization of the one-direction Wilson laplacian. -/
theorem fourierUnitary_wilsonLaplacianField (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (wilsonLaplacianField N A Psi) m =
      fun s =>
        (2 - phasePlus N m A - (phasePlus N m A)⁻¹) *
          fourierUnitary N Psi m s := by
  funext s
  unfold fourierUnitary
  have hraw := congrFun (rawFourier_wilsonLaplacianField N A Psi m) s
  rw [hraw]
  ring

end TetraCharactersEqual
end GateC1
end NullEdge
end Draft
end PhysicsSM
