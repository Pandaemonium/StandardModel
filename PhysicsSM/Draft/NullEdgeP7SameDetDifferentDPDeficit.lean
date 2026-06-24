import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic
import PhysicsSM.Draft.NullEdgeP7KLDataProcessing
import PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet

/-!
# Same determinant, different data-processing deficit

This draft module strengthens the P7 observer-channel guardrail. The scalar
determinant/mass-ratio proxy does not determine the operational KL
data-processing deficit of an observer channel.

The witness uses the same finite real symmetric `2 x 2` density proxies from
`NullEdgeP7CoherenceNotDeterminedByDet`. They have equal determinant, but their
X-basis two-outcome readouts have different KL deficits under the same complete
dephasing channel.

This is a finite two-outcome witness only. It is not a Petz recovery theorem, a
general CPTP-channel theorem, or a continuum dynamics result.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7SameDetDifferentDPDeficit

open BigOperators
open PhysicsSM.Draft.NullEdgeP7KLDataProcessing
open PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet

/-- Two-outcome observer readout from an effect and its complement. -/
def twoOutcome (obs rho : RealSym2) : Fin 2 -> Real :=
  fun i =>
    if i = 0 then
      tracePair obs rho
    else
      tracePair (sub idEffect obs) rho

/-- The complete erasing/dephasing observer channel on two outcomes. -/
def completeDephase : Fin 2 -> Fin 2 -> Real :=
  fun _ _ => (1 : Real) / 2

/-- Data-processing deficit for a fixed two-outcome observer channel. -/
def dpDeficit (T : Fin 2 -> Fin 2 -> Real)
    (p q : Fin 2 -> Real) : Real :=
  kl p q - kl (applyMap T p) (applyMap T q)

theorem applyMap_completeDephase (p : Fin 2 -> Real) :
    applyMap completeDephase p =
      fun _ => (1 : Real) / 2 * (p 0 + p 1) := by
  ext i
  fin_cases i <;>
    norm_num [applyMap, completeDephase, Fin.sum_univ_two] <;>
    ring

theorem twoOutcome_rhoCoh_sum :
    twoOutcome xBasisEffect rhoCoh 0 + twoOutcome xBasisEffect rhoCoh 1 = 1 := by
  norm_num [twoOutcome, xBasisEffect_rhoCoh, xBasisComplement_rhoCoh]

theorem twoOutcome_rhoTilt_sum :
    twoOutcome xBasisEffect rhoTilt 0 + twoOutcome xBasisEffect rhoTilt 1 = 1 := by
  norm_num [twoOutcome, xBasisEffect_rhoTilt, xBasisComplement_rhoTilt]

theorem dpDeficit_rhoCoh_rhoCoh :
    dpDeficit completeDephase
        (twoOutcome xBasisEffect rhoCoh)
        (twoOutcome xBasisEffect rhoCoh) = 0 := by
  unfold dpDeficit kl
  norm_num [applyMap, completeDephase, twoOutcome, tracePair, sub, idEffect,
    xBasisEffect, rhoCoh, Fin.sum_univ_two]

theorem dpDeficit_rhoTilt_rhoCoh :
    dpDeficit completeDephase
        (twoOutcome xBasisEffect rhoTilt)
        (twoOutcome xBasisEffect rhoCoh)
      = (7 : Real) / 10 * Real.log ((14 : Real) / 15) +
          (3 : Real) / 10 * Real.log ((6 : Real) / 5) := by
  unfold dpDeficit twoOutcome completeDephase xBasisEffect rhoTilt rhoCoh
  unfold kl applyMap tracePair sub idEffect
  norm_num [Fin.sum_univ_succ]

theorem dpDeficit_value_ne_zero :
    Not ((7 : Real) / 10 * Real.log ((14 : Real) / 15) +
        (3 : Real) / 10 * Real.log ((6 : Real) / 5) = 0) := by
  field_simp
  norm_num [<- Real.log_rpow, <- Real.log_mul, Real.log_pos]

/--
The focused observer-channel witness: determinant mass agrees for the two
states, but the KL data-processing deficit against the coherent readout
reference differs under the same complete-dephasing channel.
-/
theorem same_det_different_dpDeficit :
    det rhoCoh = det rhoTilt /\
      dpDeficit completeDephase
          (twoOutcome xBasisEffect rhoCoh)
          (twoOutcome xBasisEffect rhoCoh) !=
        dpDeficit completeDephase
          (twoOutcome xBasisEffect rhoTilt)
          (twoOutcome xBasisEffect rhoCoh) := by
  constructor
  case left =>
    rw [rhoCoh_det, rhoTilt_det]
  case right =>
    rw [bne_iff_ne, dpDeficit_rhoCoh_rhoCoh, dpDeficit_rhoTilt_rhoCoh]
    exact Ne.symm dpDeficit_value_ne_zero

end PhysicsSM.Draft.NullEdgeP7SameDetDifferentDPDeficit
