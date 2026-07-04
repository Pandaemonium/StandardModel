import PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexIntegrality
import PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
import PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexMatrixSignature

/-!
# Gate C2: the abstract gauge-overlap interface

This Draft module packages the certified-sign machinery into the reusable
interface that a genuine gauge-Wilson operator plugs into.  For ANY gapped
(invertible) Hermitian operator `H` (the eventual gauge-background Wilson
operator `H_U`) and any chirality involution `gamma5`, the certified overlap sign
`epsCFC H = |H| H^{-1}` gives:

* a well-defined sign - it EXISTS (`certifiedSign_exists`) and is UNIQUE
  (`certifiedSign_eq_epsCFC`), so nothing depends on a choice;
* a Ginsparg-Wilson overlap `Dov = 1 + gamma5 . epsCFC H`
  (`gaugeOverlap_ginspargWilson`);
* an INTEGER chiral index `overlapIndex gamma5 (epsCFC H)`
  (`gaugeOverlap_index_isInteger`).

So "the overlap index is a well-defined integer" holds for every gapped Hermitian
operator, gauge background or not - the remaining C2 frontier is only to EXHIBIT a
gauge `H_U` whose index is nonzero (a genuine flux), which then instantiates this
interface directly.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (abstract gauge-overlap interface).
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace GaugeOverlapInterface

open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC1.OverlapGinspargWilson
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignCertificate
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexMatrixSignature

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **The gauge overlap index is a well-defined integer.**  For a gapped Hermitian
`H` and a chirality involution `gamma5`, the chiral index of the certified overlap
sign `epsCFC H = |H| H^{-1}` is an integer. -/
theorem gaugeOverlap_index_isInteger (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) :
    ∃ k : ℤ, overlapIndex gamma5 (epsCFC H) = (k : ℂ) :=
  OverlapIndexIntegrality.overlapIndex_isInteger gamma5 (epsCFC H) hg5
    (certifiedSign_exists H hHherm).involution

/-- **The gauge overlap satisfies the Ginsparg-Wilson relation.**  For any gapped
Hermitian `H` and chirality involution `gamma5`, `Dov = 1 + gamma5 . epsCFC H`
satisfies `gamma5 Dov + Dov gamma5 = Dov gamma5 Dov`. -/
theorem gaugeOverlap_ginspargWilson (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) :
    gamma5 * Dov gamma5 (epsCFC H) + Dov gamma5 (epsCFC H) * gamma5
      = Dov gamma5 (epsCFC H) * gamma5 * Dov gamma5 (epsCFC H) :=
  SignCertificate.dov_ginspargWilson H (epsCFC H) gamma5 hg5
    (certifiedSign_exists H hHherm)

/-- **The gauge overlap index is certificate-choice independent** (well-defined).
Computing the chiral index with ANY sign certificate `eps` of `H` gives the same
value as with the explicit `epsCFC H`, since the certified sign is unique.  So the
gauge index does not depend on how the sign is exhibited. -/
theorem gaugeOverlap_index_certificate_independent (H eps gamma5 : Matrix n n ℂ)
    [Invertible H] (hHherm : H.IsHermitian) (hc : SignCertificate H eps) :
    overlapIndex gamma5 eps = overlapIndex gamma5 (epsCFC H) := by
  rw [certifiedSign_eq_epsCFC H eps hHherm hc]

/-- **The gauge overlap index in computable signature form.**  For a gapped
Hermitian `H` and chirality involution `gamma5`, `overlapIndex gamma5 (epsCFC H) =
(1/2)(sig gamma5 - sig(epsCFC H))`.  This is the exact form a concrete gauge
Wilson operator `H_U` instantiates: once its certified sign's signature is known
(e.g. from the eigenvalue signs of `H_U`), the index is read off directly.  For a
balanced `gamma5` this is `-(1/2) sig(sign H)`. -/
theorem gaugeOverlap_index_signature_form (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) :
    overlapIndex gamma5 (epsCFC H)
      = (2 : ℂ)⁻¹ *
          (matrixTraceSignature gamma5 - matrixTraceSignature (epsCFC H)) :=
  overlapIndex_eq_half_signature gamma5 (epsCFC H) hg5
    (certifiedSign_exists H hHherm).involution

end GaugeOverlapInterface
end GateC2
end NullEdge
end Draft
end PhysicsSM
