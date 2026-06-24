import Mathlib.Tactic

/-!
# Same normalized determinant, different chirality coherence

This focused Aristotle target proves a small finite counterexample for the
observer-channel mass program.

Physics context: in the null-edge origin-of-mass story, the normalized
determinant of a visible two-state observer channel gives the static mass-ratio
observable. The hidden/chirality coherence story is richer: determinant mass
does not by itself determine how much off-diagonal coherence was present before
the observer channel or dephasing step. This file asks for a tiny exact witness:
two trace-one real symmetric `2 x 2` density proxies have the same determinant
but different squared off-diagonal coherence.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet

/-- Real symmetric `2 x 2` density proxy with entries `[[a,c],[c,b]]`. -/
structure RealSym2 where
  a : Real
  b : Real
  c : Real

/-- Trace of `[[a,c],[c,b]]`. -/
def tr (rho : RealSym2) : Real :=
  rho.a + rho.b

/-- Determinant of `[[a,c],[c,b]]`. -/
def det (rho : RealSym2) : Real :=
  rho.a * rho.b - rho.c * rho.c

/-- Squared off-diagonal coherence. -/
def coherenceSq (rho : RealSym2) : Real :=
  rho.c * rho.c

/--
Elementary positive-semidefinite proxy for a real symmetric `2 x 2` matrix.
For a matrix `[[a,c],[c,b]]`, nonnegative principal minors are the finite
density-class condition used by this toy observer-channel witness.
-/
def psdProxy (rho : RealSym2) : Prop :=
  0 <= rho.a /\ 0 <= rho.b /\ 0 <= det rho

/--
Hilbert-Schmidt pairing with another real symmetric `2 x 2` block. The
off-diagonal entry appears twice because both symmetric off-diagonal matrix
entries contribute to the trace pairing.
-/
def tracePair (obs rho : RealSym2) : Real :=
  obs.a * rho.a + obs.b * rho.b + 2 * obs.c * rho.c

/-- Identity effect in the real symmetric `2 x 2` proxy model. -/
def idEffect : RealSym2 :=
  { a := 1, b := 1, c := 0 }

/-- Subtraction of real symmetric proxy blocks. -/
def sub (x y : RealSym2) : RealSym2 :=
  { a := x.a - y.a, b := x.b - y.b, c := x.c - y.c }

/-- Positive-effect proxy: both `E` and `I - E` are positive semidefinite. -/
def effectProxy (obs : RealSym2) : Prop :=
  psdProxy obs /\ psdProxy (sub idEffect obs)

/-- Diagonal trace-one state with determinant `3/16`. -/
def rhoDiag : RealSym2 :=
  { a := (1 : Real) / 4, b := (3 : Real) / 4, c := 0 }

/-- Coherent trace-one state with the same determinant `3/16`. -/
def rhoCoh : RealSym2 :=
  { a := (1 : Real) / 2, b := (1 : Real) / 2, c := (1 : Real) / 4 }

/-- Rational off-diagonal readout separating the two same-det witnesses. -/
def offDiagReadout : RealSym2 :=
  { a := 0, b := 0, c := 1 }

/-- Tilted same-det positive witness with different off-diagonal magnitude. -/
def rhoTilt : RealSym2 :=
  { a := (13 : Real) / 20, b := (7 : Real) / 20, c := (1 : Real) / 5 }

/-- X-basis positive effect `[[1/2,1/2],[1/2,1/2]]`. -/
def xBasisEffect : RealSym2 :=
  { a := (1 : Real) / 2, b := (1 : Real) / 2, c := (1 : Real) / 2 }

theorem rhoDiag_trace_one :
    tr rhoDiag = 1 := by
  norm_num [tr, rhoDiag]

theorem rhoCoh_trace_one :
    tr rhoCoh = 1 := by
  norm_num [tr, rhoCoh]

theorem rhoDiag_det :
    det rhoDiag = (3 : Real) / 16 := by
  norm_num [det, rhoDiag]

theorem rhoCoh_det :
    det rhoCoh = (3 : Real) / 16 := by
  norm_num [det, rhoCoh]

theorem rhoTilt_trace_one :
    tr rhoTilt = 1 := by
  norm_num [tr, rhoTilt]

theorem rhoTilt_det :
    det rhoTilt = (3 : Real) / 16 := by
  norm_num [det, rhoTilt]

theorem rhoDiag_psdProxy :
    psdProxy rhoDiag := by
  norm_num [psdProxy, det, rhoDiag]

theorem rhoCoh_psdProxy :
    psdProxy rhoCoh := by
  norm_num [psdProxy, det, rhoCoh]

theorem rhoTilt_psdProxy :
    psdProxy rhoTilt := by
  norm_num [psdProxy, det, rhoTilt]

theorem xBasisEffect_effectProxy :
    effectProxy xBasisEffect := by
  norm_num [effectProxy, psdProxy, sub, idEffect, det, xBasisEffect]

theorem tracePair_complement_add (obs rho : RealSym2) :
    tracePair obs rho + tracePair (sub idEffect obs) rho = tr rho := by
  unfold tracePair sub idEffect tr
  ring

theorem tracePair_add_complement (obs rho : RealSym2) :
    tracePair (sub idEffect obs) rho + tracePair obs rho = tr rho := by
  rw [add_comm, tracePair_complement_add]

theorem offDiagReadout_rhoDiag :
    tracePair offDiagReadout rhoDiag = 0 := by
  norm_num [tracePair, offDiagReadout, rhoDiag]

theorem offDiagReadout_rhoCoh :
    tracePair offDiagReadout rhoCoh = (1 : Real) / 2 := by
  norm_num [tracePair, offDiagReadout, rhoCoh]

theorem xBasisEffect_rhoCoh :
    tracePair xBasisEffect rhoCoh = (3 : Real) / 4 := by
  norm_num [tracePair, xBasisEffect, rhoCoh]

theorem xBasisEffect_rhoTilt :
    tracePair xBasisEffect rhoTilt = (7 : Real) / 10 := by
  norm_num [tracePair, xBasisEffect, rhoTilt]

theorem xBasisComplement_rhoCoh :
    tracePair (sub idEffect xBasisEffect) rhoCoh = (1 : Real) / 4 := by
  norm_num [tracePair, sub, idEffect, xBasisEffect, rhoCoh]

theorem xBasisComplement_rhoTilt :
    tracePair (sub idEffect xBasisEffect) rhoTilt = (3 : Real) / 10 := by
  norm_num [tracePair, sub, idEffect, xBasisEffect, rhoTilt]

theorem offDiagReadout_separates :
    tracePair offDiagReadout rhoDiag != tracePair offDiagReadout rhoCoh := by
  rw [offDiagReadout_rhoDiag, offDiagReadout_rhoCoh]
  norm_num

theorem xBasisEffect_separates :
    tracePair xBasisEffect rhoCoh != tracePair xBasisEffect rhoTilt := by
  rw [xBasisEffect_rhoCoh, xBasisEffect_rhoTilt]
  norm_num

theorem same_det :
    det rhoDiag = det rhoCoh := by
  rw [rhoDiag_det, rhoCoh_det]

theorem different_coherenceSq :
    coherenceSq rhoDiag != coherenceSq rhoCoh := by
  norm_num [coherenceSq, rhoDiag, rhoCoh]

theorem determinant_does_not_determine_coherenceSq :
    exists rho sigma : RealSym2,
      tr rho = 1 /\ tr sigma = 1 /\
      det rho = det sigma /\
      coherenceSq rho != coherenceSq sigma := by
  refine Exists.intro rhoDiag (Exists.intro rhoCoh ?_)
  refine And.intro rhoDiag_trace_one ?_
  refine And.intro rhoCoh_trace_one ?_
  refine And.intro same_det ?_
  exact different_coherenceSq

theorem determinant_does_not_determine_coherenceSq_in_densityClass :
    exists rho sigma : RealSym2,
      tr rho = 1 /\ tr sigma = 1 /\
      psdProxy rho /\ psdProxy sigma /\
      det rho = det sigma /\
      coherenceSq rho != coherenceSq sigma := by
  refine Exists.intro rhoDiag (Exists.intro rhoCoh ?_)
  refine And.intro rhoDiag_trace_one ?_
  refine And.intro rhoCoh_trace_one ?_
  refine And.intro rhoDiag_psdProxy ?_
  refine And.intro rhoCoh_psdProxy ?_
  refine And.intro same_det ?_
  exact different_coherenceSq

theorem determinant_does_not_determine_operationalReadout_in_densityClass :
    exists rho sigma obs : RealSym2,
      tr rho = 1 /\ tr sigma = 1 /\
      psdProxy rho /\ psdProxy sigma /\
      det rho = det sigma /\
      tracePair obs rho != tracePair obs sigma := by
  refine Exists.intro rhoDiag (Exists.intro rhoCoh (Exists.intro offDiagReadout ?_))
  refine And.intro rhoDiag_trace_one ?_
  refine And.intro rhoCoh_trace_one ?_
  refine And.intro rhoDiag_psdProxy ?_
  refine And.intro rhoCoh_psdProxy ?_
  refine And.intro same_det ?_
  exact offDiagReadout_separates

theorem determinant_does_not_determine_positiveEffectReadout_in_densityClass :
    exists rho sigma obs : RealSym2,
      tr rho = 1 /\ tr sigma = 1 /\
      psdProxy rho /\ psdProxy sigma /\
      effectProxy obs /\
      det rho = det sigma /\
      tracePair obs rho != tracePair obs sigma := by
  refine Exists.intro rhoCoh (Exists.intro rhoTilt (Exists.intro xBasisEffect ?_))
  refine And.intro rhoCoh_trace_one ?_
  refine And.intro rhoTilt_trace_one ?_
  refine And.intro rhoCoh_psdProxy ?_
  refine And.intro rhoTilt_psdProxy ?_
  refine And.intro xBasisEffect_effectProxy ?_
  exact And.intro (by rw [rhoCoh_det, rhoTilt_det]) xBasisEffect_separates

theorem determinant_does_not_determine_twoOutcomeReadout_in_densityClass :
    exists rho sigma obs : RealSym2,
      tr rho = 1 /\ tr sigma = 1 /\
      psdProxy rho /\ psdProxy sigma /\
      effectProxy obs /\
      det rho = det sigma /\
      tracePair obs rho != tracePair obs sigma /\
      tracePair obs rho + tracePair (sub idEffect obs) rho = 1 /\
      tracePair obs sigma + tracePair (sub idEffect obs) sigma = 1 := by
  refine Exists.intro rhoCoh (Exists.intro rhoTilt (Exists.intro xBasisEffect ?_))
  refine And.intro rhoCoh_trace_one ?_
  refine And.intro rhoTilt_trace_one ?_
  refine And.intro rhoCoh_psdProxy ?_
  refine And.intro rhoTilt_psdProxy ?_
  refine And.intro xBasisEffect_effectProxy ?_
  refine And.intro (by rw [rhoCoh_det, rhoTilt_det]) ?_
  refine And.intro xBasisEffect_separates ?_
  exact And.intro
    (by rw [tracePair_complement_add, rhoCoh_trace_one])
    (by rw [tracePair_complement_add, rhoTilt_trace_one])

end PhysicsSM.Draft.NullEdgeP7CoherenceNotDeterminedByDet

end
