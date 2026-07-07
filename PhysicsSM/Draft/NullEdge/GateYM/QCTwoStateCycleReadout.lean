import PhysicsSM.Draft.NullEdge.GateYM.QCLeading
import PhysicsSM.Draft.NullEdge.GateYM.TwoStateTransferZ2L1

/-!
# Gate YM: exact two-step Z2 transfer readout for the QC scalar

This module records the smallest finite-cycle calculation behind Fable call 03's
suggestion that the `Q_C` scalar should next be upgraded from a one-plaquette
normalization contract to an exact `Z2` transfer theorem with a finite-volume
correction term.

We use the already-landed one-link `Z2` slab weights from
`TwoStateTransferZ2L1`.  On a two-step periodic cycle, the partition sum is

`sum_{u,v} T(u,v) T(v,u)`,

and the plaquette insertion numerator is

`sum_{u,v} sign(u) sign(v) T(u,v) T(v,u)`.

The normalized readout is exactly `tanh (2 * beta)`, hence it is the
one-plaquette leading scalar `tanh beta` plus an explicit finite-cycle
correction.  This is a finite transfer-matrix identity only.  It is not a
carrier `Q_C` expectation theorem, not a gauge-measure theorem, not a
nonabelian result, and not an infinite-volume/beyond-leading positivity theorem.

Provenance: clean-room finite calculation from the existing `Z2` slab transfer
weights in `TwoStateTransferZ2L1`, themselves part of the Osterwalder-Seiler /
Tomboulis-Yaffe scalar chain documented in `QCLeading`.
-/

noncomputable section

open scoped BigOperators

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace QCTwoStateCycleReadout

open TwoStateTransferZ2L1

/-- The two-step periodic `Z2` transfer partition sum. -/
def twoStepPartition (beta : ℝ) : ℝ :=
  ∑ u : Fin 2, ∑ v : Fin 2, slabWeight beta u v * slabWeight beta v u

/-- The two-step periodic plaquette-insertion numerator.  The insertion is the
`Z2` product `sign(u) * sign(v)` on the transfer edge being read. -/
def twoStepPlaquetteNumerator (beta : ℝ) : ℝ :=
  ∑ u : Fin 2, ∑ v : Fin 2,
    bitSign u * bitSign v * slabWeight beta u v * slabWeight beta v u

/-- The normalized two-step periodic plaquette readout. -/
def twoStepPlaquetteReadout (beta : ℝ) : ℝ :=
  twoStepPlaquetteNumerator beta / twoStepPartition beta

/-- The two-step partition sum in closed form. -/
theorem twoStepPartition_eq (beta : ℝ) :
    twoStepPartition beta =
      8 * (Real.exp (2 * beta) + Real.exp (-(2 * beta))) := by
  simp [twoStepPartition, slabWeight, plaquetteSign, bitSign, Fin.sum_univ_two]
  ring_nf
  have hbeta : Real.exp beta ^ 2 = Real.exp (2 * beta) := by
    rw [pow_two, ← Real.exp_add]
    ring_nf
  have hneg : Real.exp (-beta) ^ 2 = Real.exp (-(2 * beta)) := by
    rw [pow_two, ← Real.exp_add]
    ring_nf
  rw [hbeta, hneg]
  ring_nf

/-- The two-step insertion numerator in closed form. -/
theorem twoStepPlaquetteNumerator_eq (beta : ℝ) :
    twoStepPlaquetteNumerator beta =
      8 * (Real.exp (2 * beta) - Real.exp (-(2 * beta))) := by
  simp [twoStepPlaquetteNumerator, slabWeight, plaquetteSign, bitSign, Fin.sum_univ_two]
  ring_nf
  have hbeta : Real.exp beta ^ 2 = Real.exp (2 * beta) := by
    rw [pow_two, ← Real.exp_add]
    ring_nf
  have hneg : Real.exp (-beta) ^ 2 = Real.exp (-(2 * beta)) := by
    rw [pow_two, ← Real.exp_add]
    ring_nf
  rw [hbeta, hneg]
  ring_nf

/-- The two-step partition sum is strictly positive. -/
theorem twoStepPartition_pos (beta : ℝ) : 0 < twoStepPartition beta := by
  rw [twoStepPartition_eq]
  positivity

/-- The exact normalized two-step readout is `tanh (2 * beta)`. -/
theorem twoStepPlaquetteReadout_eq_tanh_two_beta (beta : ℝ) :
    twoStepPlaquetteReadout beta = Real.tanh (2 * beta) := by
  rw [twoStepPlaquetteReadout, twoStepPlaquetteNumerator_eq, twoStepPartition_eq]
  rw [Real.tanh_eq]
  have hsum : Real.exp (2 * beta) + Real.exp (-(2 * beta)) ≠ 0 :=
    ne_of_gt (add_pos (Real.exp_pos _) (Real.exp_pos _))
  field_simp [hsum]

/-- The finite two-step correction relative to the one-plaquette leading
coefficient.  This is deliberately a finite-cycle correction term, not an
asymptotic expansion theorem. -/
def twoStepFiniteCycleCorrection (beta : ℝ) : ℝ :=
  Real.tanh (2 * beta) - QCLeading.leadingClosureFluxCoeff beta

/-- The exact two-step readout is the leading scalar plus the explicit
finite-cycle correction. -/
theorem twoStepPlaquetteReadout_eq_leading_plus_correction (beta : ℝ) :
    twoStepPlaquetteReadout beta =
      QCLeading.leadingClosureFluxCoeff beta + twoStepFiniteCycleCorrection beta := by
  rw [twoStepPlaquetteReadout_eq_tanh_two_beta, twoStepFiniteCycleCorrection]
  ring

/-- The same readout is the QC-leading scalar evaluated at doubled coupling. -/
theorem twoStepPlaquetteReadout_eq_leadingClosureFluxCoeff_double (beta : ℝ) :
    twoStepPlaquetteReadout beta =
      QCLeading.leadingClosureFluxCoeff (2 * beta) := by
  rw [twoStepPlaquetteReadout_eq_tanh_two_beta,
    QCLeading.leadingClosureFluxCoeff_eq_tanh]

/-- For positive coupling, the two-step readout is the OS contraction factor at
doubled coupling. -/
theorem twoStepPlaquetteReadout_eq_exp_neg_osSpectralGap_double {beta : ℝ}
    (hbeta : 0 < beta) :
    twoStepPlaquetteReadout beta =
      Real.exp (-OSReconstruction.osSpectralGap (2 * beta) (by linarith)) := by
  rw [twoStepPlaquetteReadout_eq_leadingClosureFluxCoeff_double]
  exact QCLeading.leadingClosureFluxCoeff_eq_exp_neg_osSpectralGap (by linarith : 0 < 2 * beta)

end QCTwoStateCycleReadout
end GateYM
end NullEdge
end Draft
end PhysicsSM

end
