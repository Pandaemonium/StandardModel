/-
# General-`N` finite Fourier support-uncertainty (Donoho--Stark)

Standalone Aristotle target. Imports ONLY Mathlib.

## What this generalizes and why

The null-edge cosmological-constant manuscript
(`Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`,
Section 6) makes the "`Lambda` is conjugate to volume" statement native to a
finite information theory by proving a support-uncertainty relation for the
discrete Fourier transform. The landed result
(`PhysicsSM/Draft/NullEdge/LambdaConjugacy.lean`,
`LambdaConjugacy.support_uncertainty`) is proved ONLY for `ZMod 4`, and by a
case-specific argument (either support is a singleton -- forcing the transform to
be everywhere nonzero -- or both supports have card >= 2, so the product is >= 4).
That argument does not scale.

The manuscript names the general-`N` relation as "the natural successor". This
file states it and asks for the honest general proof:

  for every `N >= 1` and every nonzero `f : ZMod N -> C`,
      `N <= (support f).card * (support (DFT f)).card`.

This is the Donoho--Stark support-uncertainty inequality (Donoho & Stark, SIAM
J. Appl. Math. 49 (1989), 906-931; see also Tao's "An uncertainty principle for
cyclic groups of prime order" for the sharper prime-`N` bound, which is NOT what
we ask here -- we want the general-`N` product bound, valid for all `N`).

Proving this retires the "`ZMod 4` witness only" scope caveat in Section 6 and
upgrades the finite-conjugacy claim from a single small register to the whole
family.

## Convention / faithfulness note

We use Mathlib's bundled transform `ZMod.dft` (notation `𝓕`), the counting-measure
DFT on `ZMod N`. The manuscript's `LambdaConjugacy.dft` uses the character
`w (j*k) = i^(j*k).val` on `ZMod 4`; the two agree up to the standard root-of-unity
convention and a global scaling, and -- crucially for THIS statement -- the
support cardinalities `(support f).card` and `(support (𝓕 f)).card` are invariant
under any nonzero rescaling and any relabelling of the frequency index by a group
automorphism. So the inequality proved here transfers verbatim to the manuscript's
convention. (A short lemma `dft_support_card_eq` witnessing "same support cards as
`LambdaConjugacy.dft` at `N = 4`" is optional and NOT required for the headline.)

## Target

Prove `support_uncertainty` below (currently `sorry`). The two `example`s at the
bottom are sanity checks (non-vacuity: the sharp `delta` register saturates the
bound with product exactly `N`); prove them too if convenient, but the headline is
`support_uncertainty`.

## Suggested proof (standard, self-contained)

Write `k = (support f).card`, `m = (support (𝓕 f)).card`. Note `k >= 1` since
`f <> 0`. Goal `N <= k * m`.

1. Plancherel / unitarity of the counting-measure DFT:
       `sum_x ‖𝓕 f x‖^2 = N * sum_x ‖f x‖^2`.
   Mathlib has `ZMod.dft` as a `LinearEquiv` with inversion `ZMod.dft_dft`
   (`𝓕 (𝓕 f) x = N • f (-x)` up to the normalization Mathlib uses) and an
   `invDFT`. If a ready Plancherel lemma is not present, derive this l2 identity
   from the character orthogonality `sum_x e(x*(a-b)/N) = if a=b then N else 0`.
2. `‖𝓕 f‖_infty <= ‖f‖_1`: each `𝓕 f x` is a sum of `f y` times unit-modulus
   characters, so `‖𝓕 f x‖ <= sum_y ‖f y‖ = ‖f‖_1`.
3. Cauchy--Schwarz on the support: `‖f‖_1 = sum_{y in support f} ‖f y‖`
   `<= sqrt k * ‖f‖_2` (i.e. `‖f‖_1^2 <= k * ‖f‖_2^2`), since the sum runs over
   `k` nonzero terms (`Finset.inner_mul_le_norm_mul_norm` /
   `Finset.sum_div_card_le_sum_sq` style, or `Finset.sum_sqrt`... any l1<=sqrt(card)*l2).
4. `‖𝓕 f‖_2^2 = sum_{x in support(𝓕 f)} ‖𝓕 f x‖^2 <= m * ‖𝓕 f‖_infty^2`.

Chain (all real, `‖f‖_2^2 > 0` because `f <> 0`):
    `N * ‖f‖_2^2 = ‖𝓕 f‖_2^2 <= m * ‖𝓕 f‖_infty^2 <= m * ‖f‖_1^2 <= m * k * ‖f‖_2^2`.
Cancel `‖f‖_2^2 > 0`, then move to `Nat` via `Nat.le_of_...` on the cast (both
sides are naturals cast to reals). Done.

Watch: keep everything over `Nat` at the very end; the middle is over `Real`.
`support` here is `Finset.univ.filter (f · <> 0)`; relate it to
`Function.support` if a Mathlib lemma is stated that way.
-/
import Mathlib

open scoped BigOperators
open Finset

namespace LambdaUncertaintyGeneralN

variable {N : ℕ} [NeZero N]

/-- Support of a function on `ZMod N`, as a `Finset` (finite type). Matches
`LambdaConjugacy.supp` at `N = 4`. -/
noncomputable def supp (f : ZMod N → ℂ) : Finset (ZMod N) :=
  Finset.univ.filter (fun j => f j ≠ 0)

/-- A nonzero function has nonempty support. -/
theorem one_le_card_supp {f : ZMod N → ℂ} (hf : f ≠ 0) : 1 ≤ (supp f).card := by
  sorry

/-- **Donoho--Stark support uncertainty on `ZMod N`.**
A nonzero function on `ZMod N` and its discrete Fourier transform cannot both be
sharply localized: the product of their support sizes is at least `N`.

This is the general-`N` successor to `LambdaConjugacy.support_uncertainty`
(which handles only `N = 4`). -/
theorem support_uncertainty (f : ZMod N → ℂ) (hf : f ≠ 0) :
    (N : ℕ) ≤ (supp f).card * (supp (ZMod.dft f)).card := by
  sorry

/-! ## Non-vacuity: the sharp "volume" register saturates the bound.

A single-point (delta) input has `(supp f).card = 1`; its transform is
everywhere nonzero, so `(supp (𝓕 f)).card = N`, and the product is exactly `N`.
These witness that the bound is tight and non-vacuous for every `N`. -/

/-- The delta register at `a`. -/
noncomputable def delta (a : ZMod N) : ZMod N → ℂ := fun j => if j = a then 1 else 0

/-- A delta register is nonzero. -/
example (a : ZMod N) : delta a ≠ 0 := by
  sorry

/-- Saturation: the delta register realizes the bound with product exactly `N`. -/
example (a : ZMod N) :
    (supp (delta a)).card * (supp (ZMod.dft (delta a))).card = N := by
  sorry

end LambdaUncertaintyGeneralN
