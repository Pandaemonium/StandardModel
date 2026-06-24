import Mathlib.Tactic
import Mathlib.Analysis.SpecialFunctions.Log.Basic

/-!
# Same determinant, different data-processing deficit

This focused standalone target supports the P7 observer-channel branch of the
null-edge program.

Physics meaning: the normalized determinant/mass-ratio proxy is not enough to
determine the operational information loss of an observer channel. Two
trace-one positive real `2 x 2` density proxies can have the same determinant
but different Kullback-Leibler data-processing deficits under the same
dephasing observer channel.

This is a finite witness, not a continuum dynamics theorem and not a Petz
recovery characterization.
-/

noncomputable section

namespace NullEdgeP7SameDetDifferentDPDeficit

open BigOperators

/-- Real symmetric `2 x 2` proxy with entries `[[a,c],[c,b]]`. -/
structure RealSym2 where
  a : Real
  b : Real
  c : Real

/-- Determinant of `[[a,c],[c,b]]`. -/
def det (rho : RealSym2) : Real :=
  rho.a * rho.b - rho.c * rho.c

/-- Hilbert-Schmidt pairing in the real symmetric proxy model. -/
def tracePair (obs rho : RealSym2) : Real :=
  obs.a * rho.a + obs.b * rho.b + 2 * obs.c * rho.c

/-- Identity effect. -/
def idEffect : RealSym2 :=
  { a := 1, b := 1, c := 0 }

/-- Subtraction of real symmetric proxy blocks. -/
def sub (x y : RealSym2) : RealSym2 :=
  { a := x.a - y.a, b := x.b - y.b, c := x.c - y.c }

/-- Coherent trace-one state with determinant `3/16`. -/
def rhoCoh : RealSym2 :=
  { a := (1 : Real) / 2, b := (1 : Real) / 2, c := (1 : Real) / 4 }

/-- Tilted same-det positive witness with different off-diagonal magnitude. -/
def rhoTilt : RealSym2 :=
  { a := (13 : Real) / 20, b := (7 : Real) / 20, c := (1 : Real) / 5 }

/-- X-basis positive effect `[[1/2,1/2],[1/2,1/2]]`. -/
def xBasisEffect : RealSym2 :=
  { a := (1 : Real) / 2, b := (1 : Real) / 2, c := (1 : Real) / 2 }

/-- Two-outcome observer readout from an effect and its complement. -/
def twoOutcome (obs rho : RealSym2) : Fin 2 -> Real :=
  fun i =>
    if i = 0 then
      tracePair obs rho
    else
      tracePair (sub idEffect obs) rho

/-- Finite Kullback-Leibler divergence for two-outcome distributions. -/
def kl2 (p q : Fin 2 -> Real) : Real :=
  Finset.univ.sum fun i => p i * Real.log (p i / q i)

/-- Apply a finite column-stochastic map to a two-outcome vector. -/
def applyMap2 (T : Fin 2 -> Fin 2 -> Real)
    (p : Fin 2 -> Real) : Fin 2 -> Real :=
  fun i => Finset.univ.sum fun j => T i j * p j

/-- Data-processing deficit for a fixed two-outcome observer channel. -/
def dpDeficit (T : Fin 2 -> Fin 2 -> Real)
    (p q : Fin 2 -> Real) : Real :=
  kl2 p q - kl2 (applyMap2 T p) (applyMap2 T q)

/-- The complete erasing/dephasing observer channel on two outcomes. -/
def completeDephase : Fin 2 -> Fin 2 -> Real :=
  fun _ _ => (1 : Real) / 2

theorem rhoCoh_det :
    det rhoCoh = (3 : Real) / 16 := by
  norm_num [det, rhoCoh]

theorem rhoTilt_det :
    det rhoTilt = (3 : Real) / 16 := by
  norm_num [det, rhoTilt]

theorem same_det_rhoCoh_rhoTilt :
    det rhoCoh = det rhoTilt := by
  rw [rhoCoh_det, rhoTilt_det]

theorem xBasisEffect_rhoCoh :
    tracePair xBasisEffect rhoCoh = (3 : Real) / 4 := by
  norm_num [tracePair, xBasisEffect, rhoCoh]

theorem xBasisComplement_rhoCoh :
    tracePair (sub idEffect xBasisEffect) rhoCoh = (1 : Real) / 4 := by
  norm_num [tracePair, sub, idEffect, xBasisEffect, rhoCoh]

theorem xBasisEffect_rhoTilt :
    tracePair xBasisEffect rhoTilt = (7 : Real) / 10 := by
  norm_num [tracePair, xBasisEffect, rhoTilt]

theorem xBasisComplement_rhoTilt :
    tracePair (sub idEffect xBasisEffect) rhoTilt = (3 : Real) / 10 := by
  norm_num [tracePair, sub, idEffect, xBasisEffect, rhoTilt]

theorem applyMap2_completeDephase (p : Fin 2 -> Real) :
    applyMap2 completeDephase p =
      fun _ => (1 : Real) / 2 * (p 0 + p 1) := by
  ext i
  fin_cases i <;>
    norm_num [applyMap2, completeDephase, Fin.sum_univ_two] <;>
    ring

theorem twoOutcome_rhoCoh_sum :
    twoOutcome xBasisEffect rhoCoh 0 + twoOutcome xBasisEffect rhoCoh 1 = 1 := by
  norm_num [twoOutcome, xBasisEffect_rhoCoh, xBasisComplement_rhoCoh]

theorem twoOutcome_rhoTilt_sum :
    twoOutcome xBasisEffect rhoTilt 0 + twoOutcome xBasisEffect rhoTilt 1 = 1 := by
  norm_num [twoOutcome, xBasisEffect_rhoTilt, xBasisComplement_rhoTilt]

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
    exact same_det_rhoCoh_rhoTilt
  case right =>
    sorry

end NullEdgeP7SameDetDifferentDPDeficit
