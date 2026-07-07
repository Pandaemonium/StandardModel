import PhysicsSM.Draft.NullEdge.GateYM.QCCarrierBridge
import PhysicsSM.Draft.NullEdge.Carrier.WeitzenbockQC_Torus

noncomputable section

/-!
# QCCarrierTorusAttachment: concrete torus type for the leading QC readout

This module is the concrete, but still deliberately non-expectational, attachment
layer for `QCCarrierBridge`.  It instantiates the bridge's observable type with
the finite Carrier torus gauge-configuration type from
`Carrier.WeitzenbockQC_Torus` and pins the distinguished observable `qC0` to a
chosen configuration `U`.

Honest scope: the scalar leading readout and the torus curvature remain separate
axes.  The equality between the readout and
`QCLeading.leadingClosureFluxCoeff beta` is still an external field/hypothesis of
the inherited `LeadingQCCarrierContract`; it is not derived from
`plaquetteCurvature`.  The flatness theorem below is only the Carrier torus
curvature identity `mZero_iff_commute`, re-exported in the attachment context.
This is not a gauge measure, an expectation value of `Q_C`, a nonabelian result,
or a beyond-leading positivity theorem.

Provenance: follows the Aristotle QC attachment strategy job
`f4e21d1c-0c93-4d9f-8754-3c4759603c80` /
`8068bd6e-e126-4ca8-a7f3-82b94d8657fd`, which recommended coding only this
bookkeeping layer plus a scalar-free re-export of `mZero_iff_commute`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace QCCarrierBridge

open PhysicsSM.Draft.NullEdge.Carrier.Torus

/-- The concrete finite Carrier torus gauge-configuration type used as the
observable type for the leading QC attachment. -/
abbrev TorusGaugeConfig (R W : Type*) [CommRing R] [AddCommGroup W]
    [Module R W] :=
  Fin 2 -> Site -> (W →ₗ[R] W)

/-- Bookkeeping attachment of the leading QC readout to the concrete Carrier
torus configuration type.

The fields `U`, `a`, and `b` select a concrete torus gauge configuration and
plaquette directions.  The field `contract` supplies the leading scalar readout
contract over the configuration type, and `qC0_eq_U` pins its distinguished
observable to the chosen configuration.  No theorem in this structure derives
the scalar readout from the plaquette curvature. -/
structure TorusLeadingAttachment (beta : ℝ) (hbeta : 0 < beta)
    (R W : Type*) [CommRing R] [AddCommGroup W] [Module R W] where
  /-- The selected finite torus gauge configuration. -/
  U : TorusGaugeConfig R W
  /-- First plaquette direction. -/
  a : Fin 2
  /-- Second plaquette direction. -/
  b : Fin 2
  /-- The leading scalar readout contract over torus configurations. -/
  contract : LeadingQCCarrierContract beta hbeta (TorusGaugeConfig R W)
  /-- The distinguished observable of the contract is the selected configuration. -/
  qC0_eq_U : contract.qC0 = U

namespace TorusLeadingAttachment

variable {beta : ℝ} {hbeta : 0 < beta}
variable {R W : Type*} [CommRing R] [AddCommGroup W] [Module R W]

/-- Constructor from an external readout whose value at the chosen torus
configuration is the scalar leading closure-flux coefficient. -/
def ofReadout (U : TorusGaugeConfig R W) (a b : Fin 2)
    (qCLeadingReadout : TorusGaugeConfig R W -> ℝ)
    (hreadout :
      qCLeadingReadout U = QCLeading.leadingClosureFluxCoeff beta) :
    TorusLeadingAttachment beta hbeta R W where
  U := U
  a := a
  b := b
  contract :=
    { qCLeadingReadout := qCLeadingReadout
      qC0 := U
      readout_eq_coeff := hreadout }
  qC0_eq_U := rfl

/-- The external readout at the selected torus configuration is the scalar
leading closure-flux coefficient. -/
theorem readout_at_config_eq_leadingClosureFluxCoeff
    (A : TorusLeadingAttachment beta hbeta R W) :
    A.contract.qCLeadingReadout A.U = QCLeading.leadingClosureFluxCoeff beta := by
  rw [← A.qC0_eq_U]
  exact A.contract.readout_eq_coeff

/-- The external readout at the selected torus configuration is `tanh beta`. -/
theorem readout_at_config_eq_tanh
    (A : TorusLeadingAttachment beta hbeta R W) :
    A.contract.qCLeadingReadout A.U = Real.tanh beta := by
  rw [← A.qC0_eq_U]
  exact LeadingQCCarrierContract.readout_eq_tanh A.contract

/-- The external readout at the selected torus configuration is the OS
contraction factor `exp(-gap)`. -/
theorem readout_at_config_eq_exp_neg_osSpectralGap
    (A : TorusLeadingAttachment beta hbeta R W) :
    A.contract.qCLeadingReadout A.U =
      Real.exp (-OSReconstruction.osSpectralGap beta hbeta) := by
  rw [← A.qC0_eq_U]
  exact LeadingQCCarrierContract.readout_eq_exp_neg_osSpectralGap A.contract

/-- The external readout at the selected torus configuration lies in `(0,1)`.

This is inherited from the scalar leading contract; it does not assert
positivity of a curvature expectation. -/
theorem readout_at_config_mem_Ioo
    (A : TorusLeadingAttachment beta hbeta R W) :
    A.contract.qCLeadingReadout A.U ∈ Set.Ioo (0 : ℝ) 1 := by
  rw [← A.qC0_eq_U]
  exact LeadingQCCarrierContract.readout_mem_Ioo A.contract

/-- In the selected Carrier torus configuration, vanishing gauge-multiplied
plaquette curvature is equivalent to commutation of the two covariant
differences.

This is the scalar-free curvature axis.  It intentionally mentions no
`leadingClosureFluxCoeff`, `tanh beta`, or readout value. -/
theorem flat_iff_commute (A : TorusLeadingAttachment beta hbeta R W) :
    gaugeLM (plaquetteCurvature A.U A.a A.b) = 0
      ↔ (nabla A.U A.a).comp (nabla A.U A.b)
        = (nabla A.U A.b).comp (nabla A.U A.a) :=
  mZero_iff_commute A.U A.a A.b

end TorusLeadingAttachment
end QCCarrierBridge
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
