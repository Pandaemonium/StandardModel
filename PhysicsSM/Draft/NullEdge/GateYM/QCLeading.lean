import PhysicsSM.Draft.NullEdge.GateYM.SlabGapAssembly
import PhysicsSM.Draft.NullEdge.GateYM.TYAreaLaw

noncomputable section

/-!
# QCLeading: the finite `Z2` leading closure-flux normalization scalar

This module is the first kernel-shaped statement for the Codex-owned
`Q_C`-identification thread of the two-day carrier run.  It deliberately proves
only a finite `Z2` normalization identity:

* the leading closure-flux coefficient is named as the one-plaquette
  Tomboulis-Yaffe / center-flux partition ratio,
* this coefficient is exactly `tanh beta`,
* and, for `beta > 0`, it is the OS contraction factor `exp(-gap)` for the
  already-landed finite slab gap.

Honest scope: this is a finite identity / leading-coefficient read-off.  It is
not an expectation theorem for the carrier operator `Q_C`, not a nonabelian
`SU(2)` statement, and not a beyond-leading positivity result for `<Q_C>`.
The later bridge to the concrete torus curvature operator belongs after the
Carrier-side `Q_C` realization has been ratified.

Aristotle strategy audit (2026-07-06): keep this module at the scalar
normalization layer.  The next honest carrier bridge should introduce an
observable parameter/contract first; this file should only prove scalar facts
about the leading coefficient and the already-landed slab gap.

Provenance: this is a bookkeeping bridge over the landed `Z2` slab chain, whose
Osterwalder-Seiler background is [SMH5768W] Osterwalder-Seiler 1978 and
[UARD9T5Q] Seiler LNP 159.  The TY partition-ratio side follows the audited
Tomboulis-Yaffe lineage, especially [N7SIEMAC] Tomboulis-Yaffe 1985, through
`SlabTransferGap.neU4_exp_neg_closure_gap_eq_tanh`,
`TYAreaLaw.partitionRatio_eq_exp_neg_osSpectralGap`, and
`SlabGapAssembly.slabGapAssembly`.  It follows the two-day run Fable queue item
`[QUEUE 21:34 Codex QC]` and the Tomboulis-Yaffe lineage audit recorded in
`LIT_LOG.md`.
-/

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace QCLeading

/-- The finite `Z2` leading closure-flux coefficient.

At this stage the word "leading" is a normalization label, not an asymptotic
theorem: it names the one-plaquette center-flux partition ratio that the later
carrier `Q_C` bridge should recover at leading order. -/
def leadingClosureFluxCoeff (beta : ℝ) : ℝ :=
  TYAreaLaw.partitionRatio beta

/-- The named leading closure-flux coefficient is exactly the TY partition
ratio by definition. -/
theorem leadingClosureFluxCoeff_eq_partitionRatio (beta : ℝ) :
    leadingClosureFluxCoeff beta = TYAreaLaw.partitionRatio beta := rfl

/-- The leading closure-flux coefficient reduces to the one-link strong-coupling
factor `tanh beta`. -/
theorem leadingClosureFluxCoeff_eq_tanh (beta : ℝ) :
    leadingClosureFluxCoeff beta = Real.tanh beta := by
  rw [leadingClosureFluxCoeff, TYAreaLaw.partitionRatio_eq_tanh]

/-- For positive coupling, the leading closure-flux coefficient lies strictly
between zero and one.

This is still a scalar normalization fact, not a positivity theorem for a
carrier `Q_C` expectation. -/
theorem leadingClosureFluxCoeff_mem_Ioo {beta : ℝ} (hbeta : 0 < beta) :
    leadingClosureFluxCoeff beta ∈ Set.Ioo (0 : ℝ) 1 := by
  rw [leadingClosureFluxCoeff_eq_tanh beta]
  constructor
  · rw [Real.tanh_eq_sinh_div_cosh]
    positivity
  · exact Real.tanh_lt_one beta

/-- The leading closure-flux coefficient is the contraction factor attached to
the assembled OS slab gap: `coeff = exp(-gap)`.

This is the QC-leading normalization bridge.  It still does not claim that an
expectation value of the carrier `Q_C` operator is nonnegative or equal to this
coefficient beyond leading order. -/
theorem leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap {beta : ℝ}
    (hbeta : 0 < beta) :
    leadingClosureFluxCoeff beta =
      Real.exp (-OSReconstruction.osSpectralGap beta hbeta) := by
  rw [leadingClosureFluxCoeff, TYAreaLaw.partitionRatio_eq_exp_neg_osSpectralGap hbeta]

/-- The same bridge in the direction often used by transfer-matrix statements:
`exp(-gap) = coeff`. -/
theorem exp_neg_osSpectralGap_eq_leadingClosureFluxCoeff {beta : ℝ}
    (hbeta : 0 < beta) :
    Real.exp (-OSReconstruction.osSpectralGap beta hbeta) =
      leadingClosureFluxCoeff beta :=
  (leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap hbeta).symm

/-- The bundled finite `Z2` QC-leading read-off.

The fields intentionally keep the TY partition ratio, the OS gap, and the named
leading coefficient separate.  They coincide numerically here because this is
the exactly-solvable one-plaquette `Z2` slab; no general equality of Wilson
area-law ratios, transfer gaps, and carrier expectations is asserted. -/
structure Z2LeadingQCReadout (beta : ℝ) (hbeta : 0 < beta) : Prop where
  /-- The leading coefficient is the concrete `tanh beta` scalar. -/
  coeff_eq_tanh : leadingClosureFluxCoeff beta = Real.tanh beta
  /-- The leading coefficient is the OS contraction factor `exp(-gap)`. -/
  coeff_eq_exp_neg_osGap :
    leadingClosureFluxCoeff beta =
      Real.exp (-OSReconstruction.osSpectralGap beta hbeta)
  /-- The OS gap has the explicit one-link strong-coupling value. -/
  os_gap_value :
    OSReconstruction.osSpectralGap beta hbeta = -Real.log (Real.tanh beta)
  /-- The assembled finite slab gap chain whose gap field has this value. -/
  slab_chain : SlabGapAssembly.SlabGapChain beta hbeta

/-- Kernel-checked package of the finite `Z2` QC-leading normalization bridge. -/
theorem z2LeadingQCReadout (beta : ℝ) (hbeta : 0 < beta) :
    Z2LeadingQCReadout beta hbeta where
  coeff_eq_tanh := leadingClosureFluxCoeff_eq_tanh beta
  coeff_eq_exp_neg_osGap := leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap hbeta
  os_gap_value := OSReconstruction.osSpectralGap_eq_neg_log_tanh beta hbeta
  slab_chain := SlabGapAssembly.slabGapAssembly beta hbeta

end QCLeading
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
