import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

/-!
# Gate C2: gauge invariance of the overlap index

This Draft module proves that the finite overlap chiral index is **invariant under
unitary conjugation** (a gauge transformation), and that a sign certificate
transports covariantly.  This is the guardrail flagged in the C2 design
discussion: it answers "why is a proposed nonzero index not just a basis / gauge
conjugation?" - because conjugation provably CANNOT change the index.  A genuine
topological index must come from a *signature change* (a Wilson mass driven across
zero), never from a similarity transform.

Main results:

* `overlapIndex_conj`: for a unitary `U` (`Uᴴ U = 1`),
  `overlapIndex (U g Uᴴ) (U eps Uᴴ) = overlapIndex g eps` (trace cyclicity).
* `SignCertificate.conj`: if `eps` is a sign certificate for `H`, then
  `U eps Uᴴ` is a sign certificate for `U H Uᴴ` (involution, commutation, and
  positive-semidefiniteness are all conjugation-covariant).

Together: the certified-sign construction is gauge-covariant and the index it
carries is gauge-invariant.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (gauge invariance of the finite index).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace OverlapIndexGaugeInvariance

open Matrix
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Trace is invariant under unitary conjugation: `Tr(U M Uᴴ) = Tr M`. -/
theorem trace_conj (M U : Matrix n n ℂ) (hU : Uᴴ * U = 1) :
    (U * M * Uᴴ).trace = M.trace := by
  rw [Matrix.trace_mul_comm, ← Matrix.mul_assoc, hU, Matrix.one_mul]

/-- **Gauge invariance of the overlap index.**  Unitary conjugation (a gauge
transformation) leaves `overlapIndex` unchanged. -/
theorem overlapIndex_conj (g eps U : Matrix n n ℂ)
    (hg : g * g = 1) (hU : Uᴴ * U = 1) :
    overlapIndex (U * g * Uᴴ) (U * eps * Uᴴ) = overlapIndex g eps := by
  have hU' : U * Uᴴ = 1 := mul_eq_one_comm.mp hU
  have hgc : (U * g * Uᴴ) * (U * g * Uᴴ) = 1 := by
    rw [show (U * g * Uᴴ) * (U * g * Uᴴ) = U * g * (Uᴴ * U) * g * Uᴴ by noncomm_ring,
      hU, show U * g * 1 * g * Uᴴ = U * (g * g) * Uᴴ by noncomm_ring, hg,
      show U * 1 * Uᴴ = U * Uᴴ by noncomm_ring, hU']
  rw [overlapIndex_eq _ _ hgc, overlapIndex_eq g eps hg, trace_conj g U hU,
    trace_conj eps U hU]

/-- **The sign certificate is gauge-covariant.**  If `eps` certifies `sign(H)`,
then `U eps Uᴴ` certifies `sign(U H Uᴴ)` for any unitary `U`. -/
theorem SignCertificate.conj (H eps U : Matrix n n ℂ) (hU : Uᴴ * U = 1)
    (hc : SignCertificate H eps) :
    SignCertificate (U * H * Uᴴ) (U * eps * Uᴴ) where
  involution := by
    have hU' : U * Uᴴ = 1 := mul_eq_one_comm.mp hU
    rw [show (U * eps * Uᴴ) * (U * eps * Uᴴ) = U * eps * (Uᴴ * U) * eps * Uᴴ by
        noncomm_ring, hU,
      show U * eps * 1 * eps * Uᴴ = U * (eps * eps) * Uᴴ by noncomm_ring,
      hc.involution, show U * 1 * Uᴴ = U * Uᴴ by noncomm_ring, hU']
  commute := by
    have e1 : (U * eps * Uᴴ) * (U * H * Uᴴ) = U * (eps * H) * Uᴴ := by
      rw [show (U * eps * Uᴴ) * (U * H * Uᴴ) = U * eps * (Uᴴ * U) * H * Uᴴ by
          noncomm_ring, hU]
      noncomm_ring
    have e2 : (U * H * Uᴴ) * (U * eps * Uᴴ) = U * (H * eps) * Uᴴ := by
      rw [show (U * H * Uᴴ) * (U * eps * Uᴴ) = U * H * (Uᴴ * U) * eps * Uᴴ by
          noncomm_ring, hU]
      noncomm_ring
    rw [e1, e2, hc.commute]
  posSemidef := by
    have e1 : (U * eps * Uᴴ) * (U * H * Uᴴ) = U * (eps * H) * Uᴴ := by
      rw [show (U * eps * Uᴴ) * (U * H * Uᴴ) = U * eps * (Uᴴ * U) * H * Uᴴ by
          noncomm_ring, hU]
      noncomm_ring
    rw [e1]
    have hP := hc.posSemidef.conjTranspose_mul_mul_same Uᴴ
    rwa [Matrix.conjTranspose_conjTranspose] at hP

end OverlapIndexGaugeInvariance
end GateC2
end NullEdge
end Draft
end PhysicsSM
