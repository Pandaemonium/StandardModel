import PhysicsSM.Draft.NullEdge.GateC2.GaugeOverlapInterface

/-!
# Gate C2: the gauge overlap index as a trace / eigenvalue-count formula

This Draft module closes the algebraic distance between the abstract gauge index
and the concrete eigenvalue-sign counts of the gauge Wilson operator `H`.

The gauge-overlap interface already gives the index in signature form
(`GaugeOverlapInterface.gaugeOverlap_index_signature_form`):
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - sig(epsCFC H))`.  Because the
certified sign `epsCFC H = |H| H^{-1}` is an involution, its signature equals its
trace (`OverlapIndexMatrixSignature.matrix_trace_eq_signature`), so:

* `gaugeOverlap_index_trace_form` (UNCONDITIONAL, kernel-checked here): the gauge
  index is `(1/2)(sig gamma5 - trace(epsCFC H))`.  The trace of the certified sign
  is manifestly "the sum of the eigenvalue signs of `H`", so this already expresses
  the index through `H`'s spectral sign data - with no functional calculus left in
  the outer formula.

* `gaugeOverlap_index_inertia_form` (CONDITIONAL on the inertia identity): once the
  certified sign's trace is identified with the inertia `n_+ - n_-` of `H` (the
  number of positive minus negative eigenvalues), the gauge index becomes
  `(1/2)(sig gamma5 - (n_+ - n_-))`, computable directly from `H`'s eigenvalue
  signs.  The single hypothesis `hinertia : (epsCFC H).trace = n_+ - n_-` is
  EXACTLY the spectral bridge lemma `epsCFC_trace_eq_inertia` handed to Aristotle
  (job 25f0b738); when that lands, discharging `hinertia` upgrades this to an
  unconditional eigenvalue-count formula in one step.

So the remaining gap between "abstract certified-sign index" and "count eigenvalue
signs of `H`" is isolated to the one spectral fact `trace(sign H) = n_+ - n_-`,
made explicit here as a hypothesis rather than hidden.

Draft-trust: no `s o r r y`, no `n a t i v e _ d e c i d e`; kernel-checked.
Claim label: **structural theorem** (gauge index as trace / eigenvalue counts).
Prerequisites: `GaugeOverlapInterface`, `OverlapIndexMatrixSignature`,
`OverlapSignExistence`.  Successor: discharge `hinertia` via
`epsCFC_trace_eq_inertia` for the unconditional eigenvalue-count index.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC2
namespace GaugeIndexInertiaForm

open PhysicsSM.Draft.NullEdge.GateC1.OverlapIndexToy
open PhysicsSM.Draft.NullEdge.GateC2.OverlapSignExistence
open PhysicsSM.Draft.NullEdge.GateC2.OverlapIndexMatrixSignature
open PhysicsSM.Draft.NullEdge.GateC2.GaugeOverlapInterface

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- **The gauge overlap index in trace form (unconditional).**  For a gapped
Hermitian `H` and chirality involution `gamma5`, the chiral index is
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - trace(epsCFC H))`.  Since the
certified sign `epsCFC H = |H| H^{-1}` is an involution, its signature `n_+ - n_-`
coincides with its trace, and that trace is the sum of the eigenvalue signs of
`H`.  This expresses the gauge index directly through `H`'s spectral sign data. -/
theorem gaugeOverlap_index_trace_form (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) :
    overlapIndex gamma5 (epsCFC H)
      = (2 : ℂ)⁻¹ * (matrixTraceSignature gamma5 - (epsCFC H).trace) := by
  rw [gaugeOverlap_index_signature_form H gamma5 hHherm hg5,
    matrix_trace_eq_signature (epsCFC H) (certifiedSign_exists H hHherm).involution]

/-- **The gauge overlap index in eigenvalue-count form (given the inertia
identity).**  If the certified sign's trace equals the inertia `n_+ - n_-` of `H`
(number of positive minus negative eigenvalues), then
`overlapIndex gamma5 (epsCFC H) = (1/2)(sig gamma5 - (n_+ - n_-))`.  The hypothesis
`hinertia` is precisely the spectral bridge lemma `epsCFC_trace_eq_inertia`; with
it discharged, the gauge chiral index is read off from the eigenvalue signs of the
gauge Wilson operator `H` alone, with no functional calculus in the formula. -/
theorem gaugeOverlap_index_inertia_form (H gamma5 : Matrix n n ℂ) [Invertible H]
    (hHherm : H.IsHermitian) (hg5 : gamma5 * gamma5 = 1) (nPos nNeg : ℕ)
    (hinertia : (epsCFC H).trace = (nPos : ℂ) - (nNeg : ℂ)) :
    overlapIndex gamma5 (epsCFC H)
      = (2 : ℂ)⁻¹ * (matrixTraceSignature gamma5 - ((nPos : ℂ) - (nNeg : ℂ))) := by
  rw [gaugeOverlap_index_trace_form H gamma5 hHherm hg5, hinertia]

end GaugeIndexInertiaForm
end GateC2
end NullEdge
end Draft
end PhysicsSM
