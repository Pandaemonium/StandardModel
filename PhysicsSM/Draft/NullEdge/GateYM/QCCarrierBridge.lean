import PhysicsSM.Draft.NullEdge.GateYM.QCLeading

noncomputable section

/-!
# QCCarrierBridge: parameterized leading readout contract

This module is the deliberately thin carrier-facing layer for the two-day run's
leading `Q_C` identification thread.  It does not construct a gauge measure, an
expectation value, a nonabelian model, or a beyond-leading positivity theorem.

Instead it records the smallest honest bridge shape ratified by the run notes:
an arbitrary observable type `Obs`, a real-valued leading readout on `Obs`, and
a distinguished observable whose readout is the scalar leading closure-flux
coefficient from `QCLeading`.  All numerical consequences are imported from the
scalar normalization layer.

Provenance: this is a bookkeeping bridge over `QCLeading`, following the
two-day run Fable/Aristotle queue item for a parameterized
`QCCarrierBridge.LeadingQCCarrierContract`.  The scalar coefficient ultimately
uses the finite `Z2` slab/Tomboulis-Yaffe/OS provenance recorded in
`QCLeading`: [SMH5768W] Osterwalder-Seiler 1978, [UARD9T5Q] Seiler LNP 159, and
[N7SIEMAC] Tomboulis-Yaffe 1985.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace QCCarrierBridge

/-- A parameterized leading carrier readout contract.

The observable type is supplied externally.  The only bridge hypothesis is that
one distinguished leading readout equals the scalar finite `Z2` leading
closure-flux coefficient.  This keeps the carrier attachment separate from any
claim about a concrete expectation, measure, nonabelian theory, or higher-order
positivity. -/
structure LeadingQCCarrierContract (beta : ℝ) (_hbeta : 0 < beta)
    (Obs : Type*) where
  /-- The externally supplied leading closure observable/readout. -/
  qCLeadingReadout : Obs -> ℝ
  /-- The distinguished observable whose readout is being normalized. -/
  qC0 : Obs
  /-- The bridge equality to the scalar leading closure-flux coefficient. -/
  readout_eq_coeff :
    qCLeadingReadout qC0 = QCLeading.leadingClosureFluxCoeff beta

namespace LeadingQCCarrierContract

variable {beta : ℝ} {hbeta : 0 < beta} {Obs : Type*}

/-- The defining bridge equality, named for downstream imports. -/
theorem readout_eq_leadingClosureFluxCoeff
    (C : LeadingQCCarrierContract beta hbeta Obs) :
    C.qCLeadingReadout C.qC0 = QCLeading.leadingClosureFluxCoeff beta :=
  C.readout_eq_coeff

/-- The contracted leading readout is the concrete `tanh beta` scalar. -/
theorem readout_eq_tanh (C : LeadingQCCarrierContract beta hbeta Obs) :
    C.qCLeadingReadout C.qC0 = Real.tanh beta := by
  calc
    C.qCLeadingReadout C.qC0 = QCLeading.leadingClosureFluxCoeff beta :=
      C.readout_eq_coeff
    _ = Real.tanh beta :=
      QCLeading.leadingClosureFluxCoeff_eq_tanh beta

/-- The contracted leading readout is the OS contraction factor
`exp(-gap)`. -/
theorem readout_eq_exp_neg_osSpectralGap
    (C : LeadingQCCarrierContract beta hbeta Obs) :
    C.qCLeadingReadout C.qC0 =
      Real.exp (-OSReconstruction.osSpectralGap beta hbeta) := by
  calc
    C.qCLeadingReadout C.qC0 = QCLeading.leadingClosureFluxCoeff beta :=
      C.readout_eq_coeff
    _ = Real.exp (-OSReconstruction.osSpectralGap beta hbeta) :=
      QCLeading.leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap hbeta

/-- For positive coupling, the contracted leading readout lies in `(0,1)`.

This is inherited from the scalar normalization layer.  It is not a positivity
theorem for a carrier expectation beyond leading order. -/
theorem readout_mem_Ioo (C : LeadingQCCarrierContract beta hbeta Obs) :
    C.qCLeadingReadout C.qC0 ∈ Set.Ioo (0 : ℝ) 1 := by
  rw [C.readout_eq_coeff]
  exact QCLeading.leadingClosureFluxCoeff_mem_Ioo hbeta

/-- Positivity of the contracted leading readout. -/
theorem readout_pos (C : LeadingQCCarrierContract beta hbeta Obs) :
    0 < C.qCLeadingReadout C.qC0 :=
  (readout_mem_Ioo C).1

/-- The contracted leading readout is strictly less than one. -/
theorem readout_lt_one (C : LeadingQCCarrierContract beta hbeta Obs) :
    C.qCLeadingReadout C.qC0 < 1 :=
  (readout_mem_Ioo C).2

end LeadingQCCarrierContract

/-- The scalar normalization contract, showing that the bridge shape is
non-vacuous before any concrete carrier observable is attached. -/
def scalarNormalizationContract (beta : ℝ) (hbeta : 0 < beta) :
    LeadingQCCarrierContract beta hbeta ℝ where
  qCLeadingReadout := id
  qC0 := QCLeading.leadingClosureFluxCoeff beta
  readout_eq_coeff := rfl

/-- The scalar normalization contract reads out `tanh beta`. -/
theorem scalarNormalizationContract_readout_eq_tanh (beta : ℝ)
    (hbeta : 0 < beta) :
    (scalarNormalizationContract beta hbeta).qCLeadingReadout
      (scalarNormalizationContract beta hbeta).qC0 = Real.tanh beta :=
  LeadingQCCarrierContract.readout_eq_tanh
    (scalarNormalizationContract beta hbeta)

/-- The scalar normalization contract reads out the OS contraction factor. -/
theorem scalarNormalizationContract_readout_eq_exp_neg_osSpectralGap (beta : ℝ)
    (hbeta : 0 < beta) :
    (scalarNormalizationContract beta hbeta).qCLeadingReadout
      (scalarNormalizationContract beta hbeta).qC0 =
        Real.exp (-OSReconstruction.osSpectralGap beta hbeta) :=
  LeadingQCCarrierContract.readout_eq_exp_neg_osSpectralGap
    (scalarNormalizationContract beta hbeta)

end QCCarrierBridge
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
