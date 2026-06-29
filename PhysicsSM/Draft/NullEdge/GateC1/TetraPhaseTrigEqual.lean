import PhysicsSM.Draft.NullEdge.GateC1.TetraCharactersEqual

/-!
# Equal-side tetrahedral phase-to-trigonometry bridge

This draft module isolates the convention bridge from finite additive
characters to the trigonometric symbols used by the scalar Wilson free symbol.

The intended proof chain is:

`phasePlus = one-coordinate AddChar phase`
  -> `phasePlus = exp(i k_A)`
  -> Euler form
  -> finite-symbol identities for `phasePlus - phasePlus^{-1}` and
     `2 - phasePlus - phasePlus^{-1}`.

Keeping this bridge separate prevents the Fourier/Parseval layer from being
cluttered with trigonometric convention rewrites.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace TetraPhaseTrigEqual

open scoped BigOperators
open TetraCharactersEqual
open TetraFiniteTorusEqual
open TetraScalarWilsonSymbol

/-- Momentum angle in coordinate `A`, using the same convention as the
low-level `zmodAngle` definition. -/
def kAngle (N : ℕ) [NeZero N] (m : MomN N) (A : Fin 4) : ℝ :=
  zmodAngle N (m A)

/-- Symbol-facing momentum map from finite momenta to real rank-4 angles. -/
def kOfMom (N : ℕ) [NeZero N] (m : MomN N) : Fin 4 -> ℝ :=
  fun A => kAngle N m A

/-- One-coordinate character form of the positive transport phase. -/
theorem phasePlus_eq_coordAddChar (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    phasePlus N m A = AddChar.zmodAddEquiv (m A) (1 : ZMod N) := by
  exact phasePlus_eq_zmodAddEquiv_one N m A

/-- The one-coordinate `ZMod` character at `1` is the expected complex
exponential.

This is the single low-level convention bridge from Mathlib's additive
characters to the trigonometric symbol convention.
-/
theorem coordAddChar_one_eq_cexp (N : ℕ) [NeZero N] (z : ZMod N) :
    AddChar.zmodAddEquiv z (1 : ZMod N) =
      Complex.exp (((zmodAngle N z : ℝ) : ℂ) * Complex.I) := by
  rw [AddChar.zmodAddEquiv_apply]
  change ((AddChar.zmod N z) (1 : ZMod N) : ℂ) =
    Complex.exp (((zmodAngle N z : ℝ) : ℂ) * Complex.I)
  rw [← ZMod.natCast_zmod_val z]
  rw [show (1 : ZMod N) = ((1 : ℤ) : ZMod N) by norm_num]
  have hvalCast : ((z.val : ℤ) : ZMod N) = (z.val : ZMod N) := by
    norm_num
  rw [← hvalCast]
  have hzC := congrArg (fun c : Circle => (c : ℂ))
    (AddChar.zmod_intCast (n := N) (x := (z.val : ℤ)) (y := (1 : ℤ)))
  calc
    ((AddChar.zmod N ((z.val : ℤ) : ZMod N)) ((1 : ℤ) : ZMod N) : ℂ)
        = Complex.exp
            (2 * (Real.pi : ℂ) *
              ((((ZMod.cast ((z.val : ℤ) : ZMod N) : ℝ) : ℂ) /
                (N : ℂ))) *
              Complex.I) := by
          simpa [Circle.coe_exp] using hzC
    _ = Complex.exp
          (((zmodAngle N ((z.val : ℤ) : ZMod N) : ℝ) : ℂ) *
            Complex.I) := by
          unfold zmodAngle
          congr 1
          rw [ZMod.cast_eq_val]
          simp [Complex.ofReal_mul]
          ring_nf

/-- Positive transport phase as a complex exponential. -/
theorem phasePlus_eq_cexp (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    phasePlus N m A =
      Complex.exp (((kAngle N m A : ℝ) : ℂ) * Complex.I) := by
  rw [phasePlus_eq_coordAddChar, coordAddChar_one_eq_cexp]
  rfl

/-- Positive transport phase in Euler form. -/
theorem phasePlus_eq_cos_add_i_sin (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    phasePlus N m A =
      (Real.cos (kAngle N m A) : ℂ) +
        (Real.sin (kAngle N m A) : ℂ) * Complex.I := by
  rw [phasePlus_eq_cexp]
  simpa using Complex.exp_mul_I (kAngle N m A : ℂ)

/-- The inverse of a positive transport phase is its complex conjugate. -/
theorem phasePlus_inv_eq_conj (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    (phasePlus N m A)⁻¹ = star (phasePlus N m A) := by
  exact TetraCharactersEqual.phasePlus_inv_eq_conj N m A

/-- Inverse positive transport phase in Euler form. -/
theorem phasePlus_inv_eq_cos_sub_i_sin (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    (phasePlus N m A)⁻¹ =
      (Real.cos (kAngle N m A) : ℂ) -
        (Real.sin (kAngle N m A) : ℂ) * Complex.I := by
  rw [phasePlus_inv_eq_conj, phasePlus_eq_cos_add_i_sin]
  simp [← Complex.ofReal_cos, ← Complex.ofReal_sin,
    Complex.conj_ofReal, Complex.conj_I]
  ring_nf

/-- Centered-difference phase symbol in trigonometric form. -/
theorem phasePlus_sub_inv_eq_two_i_sin (N : ℕ) [NeZero N]
    (m : MomN N) (A : Fin 4) :
    phasePlus N m A - (phasePlus N m A)⁻¹ =
      2 * (Real.sin (kAngle N m A) : ℂ) * Complex.I := by
  rw [phasePlus_inv_eq_cos_sub_i_sin, phasePlus_eq_cos_add_i_sin]
  ring_nf

/-- Wilson-laplacian phase symbol in trigonometric form. -/
theorem two_sub_phasePlus_sub_inv_eq_two_one_sub_cos
    (N : ℕ) [NeZero N] (m : MomN N) (A : Fin 4) :
    (2 : ℂ) - phasePlus N m A - (phasePlus N m A)⁻¹ =
      2 * (1 - (Real.cos (kAngle N m A) : ℂ)) := by
  rw [phasePlus_inv_eq_cos_sub_i_sin, phasePlus_eq_cos_add_i_sin]
  ring_nf

/-- `sinCoeffs` applied to finite momenta is exactly the coordinatewise sine of
`kAngle`. -/
theorem sinCoeffs_kOfMom (N : ℕ) [NeZero N] (m : MomN N) :
    sinCoeffs (kOfMom N m) = fun A => Real.sin (kAngle N m A) := by
  rfl

/-- The Wilson cosine coefficient convention applied to finite momenta is
definitionally coordinatewise. -/
theorem wilsonCosCoeff_kOfMom (N : ℕ) [NeZero N] (m : MomN N) :
    (fun A => 1 - Real.cos ((kOfMom N m) A)) =
      fun A => 1 - Real.cos (kAngle N m A) := by
  rfl

/-- Normalized Fourier diagonalization of the centered transport difference,
rewritten into trigonometric symbol form. -/
theorem fourierUnitary_centeredTransportDiff_trig
    (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (centeredTransportDiff N A Psi) m =
      fun s =>
        (2 * (Real.sin ((kOfMom N m) A) : ℂ) * Complex.I) *
          fourierUnitary N Psi m s := by
  funext s
  have h := congrFun
    (fourierUnitary_centeredTransportDiff N A Psi m) s
  rw [h, phasePlus_sub_inv_eq_two_i_sin]
  rfl

/-- Normalized Fourier diagonalization of the one-direction Wilson laplacian,
rewritten into trigonometric symbol form. -/
theorem fourierUnitary_wilsonLaplacianField_trig
    (N : ℕ) [NeZero N]
    {Spin : Type*} [Fintype Spin]
    (A : Fin 4) (Psi : SiteN N -> Spin -> ℂ) (m : MomN N) :
    fourierUnitary N (wilsonLaplacianField N A Psi) m =
      fun s =>
        (2 * (1 - (Real.cos ((kOfMom N m) A) : ℂ))) *
          fourierUnitary N Psi m s := by
  funext s
  have h := congrFun
    (fourierUnitary_wilsonLaplacianField N A Psi m) s
  rw [h, two_sub_phasePlus_sub_inv_eq_two_one_sub_cos]
  rfl

end TetraPhaseTrigEqual
end GateC1
end NullEdge
end Draft
end PhysicsSM
