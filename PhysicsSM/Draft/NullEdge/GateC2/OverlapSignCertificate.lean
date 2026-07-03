import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson

/-!
# Gate C2: the certified overlap sign is unique (no functional calculus)

This Draft module supplies the theoretical backbone for **C2b**, the hard half of
the gauge overlap program flagged by the Aristotle Gate-C2 design brief: how to
pin `eps_U = sign(H_U)` for a gauge-Wilson operator `H_U` WITHOUT building a
functional calculus, once the free `H^2 = scalar` shortcut is gone.

The idea (a finite positivity certificate) is to *characterize* the sign
algebraically.  For a gapped (invertible) Hermitian `H`, a **sign certificate**
for `H` is a matrix `eps` that is

* an involution (`eps * eps = 1`),
* commuting with `H` (`eps * H = H * eps`), and
* such that `eps * H` is positive semidefinite.

These are exactly the defining properties of `sign(H) = H |H|^{-1}` restated
without any functional calculus.  The main theorem `certifiedSign_unique` proves
that a sign certificate is **unique**: any two matrices satisfying the
certificate for the same `H` are equal.  Hence one may DEFINE the overlap sign of
a specific gauge `H_U` by exhibiting a single certified `eps_U` and checking the
three finite conditions - the sign is then well-defined, and the overlap
`Dov = 1 + gamma5 . eps_U` satisfies the Ginsparg-Wilson relation via the existing
`OverlapGinspargWilson.dov_ginsparg_wilson` (`eps_U^2 = 1`).

## Proof (slick, no eigendecomposition)

If `eps` is a certificate then `(eps * H)^2 = eps H eps H = eps (eps H) H =
H^2` (using commutation and `eps^2 = 1`), and `eps * H` is positive semidefinite,
so `eps * H` is *the* positive-semidefinite square root of `H^2`.  The
positive-semidefinite square root is unique
(`Matrix.PosSemidef.sqrt_eq_iff_eq_sq`), so `eps_1 * H = sqrt(H^2) = eps_2 * H`,
and invertibility of `H` cancels to `eps_1 = eps_2`.

Note: the STATEMENT is purely algebraic + Loewner-order (no functional calculus);
the PROOF borrows Mathlib's positive-semidefinite square-root uniqueness as a
tool.  This is legitimate - it does not build the overlap sign by spectral
calculus, it certifies a given one.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (finite certified-sign uniqueness; the
abstract admissible-sign interface for gauge overlap C2b).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapSignCertificate

open Matrix
open scoped ComplexOrder

-- The Loewner (positive-semidefinite) order on complex matrices is an `abbrev`,
-- not a global instance; activate it locally for the CFC square-root API.
attribute [local instance] Matrix.instPartialOrder Matrix.instStarOrderedRing
  Matrix.instNonnegSpectrumClass

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A finite **sign certificate** for a Hermitian operator `H`: an involution
commuting with `H` whose product `eps * H` is positive semidefinite.  This is
`eps = sign(H)` characterized without functional calculus. -/
structure SignCertificate (H eps : Matrix n n ℂ) : Prop where
  /-- `eps` is an involution. -/
  involution : eps * eps = 1
  /-- `eps` commutes with `H`. -/
  commute : eps * H = H * eps
  /-- `eps * H` is positive semidefinite (fixes the sign, not just `eps^2 = 1`). -/
  posSemidef : (eps * H).PosSemidef

/-- For a certificate, `eps * H` squares to `H^2` (commutation + involution). -/
theorem signCertificate_mul_sq (H eps : Matrix n n ℂ)
    (hc : SignCertificate H eps) : (eps * H) ^ 2 = H ^ 2 := by
  rw [pow_two, pow_two]
  rw [show (eps * H) * (eps * H) = eps * (H * eps) * H by noncomm_ring]
  rw [← hc.commute]
  rw [show eps * (eps * H) * H = (eps * eps) * (H * H) by noncomm_ring]
  rw [hc.involution, one_mul]

/-- **Uniqueness of the certified overlap sign.**  For a gapped (invertible)
Hermitian `H`, any two sign certificates coincide: the finite positivity
certificate determines `eps = sign(H)` uniquely, without functional calculus. -/
theorem certifiedSign_unique (H eps1 eps2 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian)
    (h1 : SignCertificate H eps1) (h2 : SignCertificate H eps2) :
    eps1 = eps2 := by
  have hHsq : ((H : Matrix n n ℂ) ^ 2).PosSemidef := by
    rw [pow_two]
    nth_rewrite 1 [← hHherm]
    exact Matrix.posSemidef_conjTranspose_mul_self H
  have hs1 : CFC.sqrt (H ^ 2) = eps1 * H :=
    (Matrix.PosSemidef.sqrt_eq_iff_eq_sq hHsq h1.posSemidef).mpr
      (signCertificate_mul_sq H eps1 h1).symm
  have hs2 : CFC.sqrt (H ^ 2) = eps2 * H :=
    (Matrix.PosSemidef.sqrt_eq_iff_eq_sq hHsq h2.posSemidef).mpr
      (signCertificate_mul_sq H eps2 h2).symm
  have heq : eps1 * H = eps2 * H := by rw [← hs1, hs2]
  have hcancel := congrArg (· * (⅟H : Matrix n n ℂ)) heq
  simpa [mul_assoc, mul_invOf_self, mul_one] using hcancel

end OverlapSignCertificate
end GateC2
end NullEdge
end Draft
end PhysicsSM
