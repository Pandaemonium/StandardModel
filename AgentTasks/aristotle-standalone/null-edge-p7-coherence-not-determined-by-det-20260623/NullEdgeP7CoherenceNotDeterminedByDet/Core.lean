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

namespace NullEdgeP7CoherenceNotDeterminedByDet

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

/-- Diagonal trace-one state with determinant `3/16`. -/
def rhoDiag : RealSym2 :=
  { a := (1 : Real) / 4, b := (3 : Real) / 4, c := 0 }

/-- Coherent trace-one state with the same determinant `3/16`. -/
def rhoCoh : RealSym2 :=
  { a := (1 : Real) / 2, b := (1 : Real) / 2, c := (1 : Real) / 4 }

theorem rhoDiag_trace_one :
    tr rhoDiag = 1 := by
  unfold tr rhoDiag
  norm_num

theorem rhoCoh_trace_one :
    tr rhoCoh = 1 := by
  unfold tr rhoCoh
  norm_num

theorem rhoDiag_det :
    det rhoDiag = (3 : Real) / 16 := by
  unfold det rhoDiag
  norm_num

theorem rhoCoh_det :
    det rhoCoh = (3 : Real) / 16 := by
  unfold det rhoCoh
  norm_num

theorem same_det :
    det rhoDiag = det rhoCoh := by
  rw [rhoDiag_det, rhoCoh_det]

theorem different_coherenceSq :
    coherenceSq rhoDiag != coherenceSq rhoCoh := by
  unfold coherenceSq rhoDiag rhoCoh
  norm_num

theorem determinant_does_not_determine_coherenceSq :
    exists rho sigma : RealSym2,
      tr rho = 1 /\ tr sigma = 1 /\
      det rho = det sigma /\
      coherenceSq rho != coherenceSq sigma := by
  exact ⟨rhoDiag, rhoCoh, rhoDiag_trace_one, rhoCoh_trace_one, same_det,
    different_coherenceSq⟩

end NullEdgeP7CoherenceNotDeterminedByDet

end
