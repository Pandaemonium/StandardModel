import Mathlib
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence

/-!
# Gate C2: a certified sign is automatically Hermitian

The finite sign certificate (`OverlapSignCertificate.SignCertificate`) asks only
for an involution `eps` commuting with a gapped Hermitian `H` with `eps * H`
positive semidefinite - it does NOT explicitly require `eps` self-adjoint.  This
module proves that self-adjointness is nonetheless FORCED
(`signCertificate_isHermitian`): the three conditions imply `eps^* = eps`.  Hence
a certified overlap sign is genuinely a self-adjoint involution (an orthogonal
reflection), matching the spectral `sign(H) = H|H|^{-1}` it characterizes.  This
closes a self-consistency gap in the certificate interface noted in the C2
red-team discussion.

Mechanism: `eps * H` is Hermitian (positive semidefinite implies Hermitian), so
`(eps H)^* = eps H`, i.e. `H^* eps^* = eps H`; with `H^* = H` and `eps H = H eps`
this reads `H eps^* = H eps`, and invertibility of `H` cancels to `eps^* = eps`.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (certificate self-consistency).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapSignHermitian

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **A certified sign is automatically Hermitian.**  If `eps` is a sign
certificate for a gapped (invertible) Hermitian `H`, then `eps` is self-adjoint.
So the certificate's three conditions already force `eps` to be a self-adjoint
involution. -/
theorem signCertificate_isHermitian (H eps : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hc : SignCertificate H eps) :
    eps.IsHermitian := by
  -- `eps * H` is Hermitian, so `Hᴴ * epsᴴ = eps * H`.
  have hEq : Hᴴ * epsᴴ = eps * H := by
    have h : (eps * H)ᴴ = eps * H := hc.posSemidef.isHermitian
    rwa [Matrix.conjTranspose_mul] at h
  -- Use `Hᴴ = H` and `eps * H = H * eps`, then cancel `H`.
  rw [hHherm.eq, hc.commute] at hEq
  have hcancel := congrArg (fun M => (⅟H : Matrix n n ℂ) * M) hEq
  simpa only [← mul_assoc, invOf_mul_self, one_mul] using hcancel

/-- **The explicit certified sign is a self-adjoint involution.**  For a gapped
Hermitian `H`, `epsCFC H = |H| H^{-1}` is both Hermitian and an involution - a
genuine orthogonal reflection (`= sign(H)`).  This packages existence
(`OverlapSignExistence.certifiedSign_exists`) with the automatic Hermiticity
above: the certified overlap sign is not merely an involution but a self-adjoint
one, exactly as a spectral `sign(H)` should be. -/
theorem epsCFC_isSelfAdjoint_involution (H : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) :
    (OverlapSignExistence.epsCFC H).IsHermitian
      ∧ OverlapSignExistence.epsCFC H * OverlapSignExistence.epsCFC H = 1 :=
  ⟨signCertificate_isHermitian H _ hHherm
      (OverlapSignExistence.certifiedSign_exists H hHherm),
    (OverlapSignExistence.certifiedSign_exists H hHherm).involution⟩

end OverlapSignHermitian
end GateC2
end NullEdge
end Draft
end PhysicsSM
