import Mathlib

/-!
# Finite soldering local-frame covariance target

Focused Mathlib-only target for the geometric kill test on the null-edge
soldering interpretation. The target proves that a discrete coframe transport
defect transforms covariantly under independent endpoint frame changes, composes
under refinement, and has an invariant quadratic action for orthogonal frames.
-/

open Matrix

namespace SolderingLocalFrameCovariance

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- Finite coframe vector at a vertex. -/
abbrev Coframe (n : Type*) := n → ℚ

/-- Finite parallel transport between two local frames. -/
abbrev Transport (n : Type*) := Matrix n n ℚ

/-- Discrete soldering/coframe defect on an oriented edge `x -> y`. -/
def edgeDefect (U : Transport n) (eX eY : Coframe n) : Coframe n :=
  eY - U.mulVec eX

/-- Change the local frame of a coframe vector. -/
def transformCoframe (g : Matrix n n ℚ) (e : Coframe n) : Coframe n :=
  g.mulVec e

/-- Endpoint frame change of a transport: `U' = gY U gX^{-1}`. -/
def transformTransport (gXInv gY : Matrix n n ℚ) (U : Transport n) : Transport n :=
  gY * U * gXInv

/-- **Local-frame covariance.** If `gXInv` is a left inverse of `gX`, then the
transformed edge defect is exactly `gY` applied to the original defect. -/
theorem edgeDefect_covariant
    (gX gXInv gY U : Matrix n n ℚ) (eX eY : Coframe n)
    (hX : gXInv * gX = 1) :
    edgeDefect (transformTransport gXInv gY U)
        (transformCoframe gX eX) (transformCoframe gY eY) =
      transformCoframe gY (edgeDefect U eX eY) := by
  sorry

/-- Vanishing soldering defect is preserved by an invertible endpoint frame
change. -/
theorem edgeDefect_zero_iff_frame_change
    (gX gXInv gY gYInv U : Matrix n n ℚ) (eX eY : Coframe n)
    (hX : gXInv * gX = 1) (hY : gYInv * gY = 1) :
    edgeDefect (transformTransport gXInv gY U)
        (transformCoframe gX eX) (transformCoframe gY eY) = 0 ↔
      edgeDefect U eX eY = 0 := by
  sorry

/-- **Refinement/composition law.** The defect of a two-edge composite is the
second-edge defect plus the transported first-edge defect. -/
theorem edgeDefect_composition
    (Uxy Uyz : Transport n) (eX eY eZ : Coframe n) :
    edgeDefect (Uyz * Uxy) eX eZ =
      edgeDefect Uyz eY eZ + Uyz.mulVec (edgeDefect Uxy eX eY) := by
  sorry

/-- A perfectly transported coframe has zero edge defect. -/
theorem edgeDefect_zero_of_parallel
    (U : Transport n) (eX eY : Coframe n) (h : eY = U.mulVec eX) :
    edgeDefect U eX eY = 0 := by
  sorry

/-- Euclidean quadratic norm of a rational coframe defect. -/
def defectNormSq (v : Coframe n) : ℚ := dotProduct v v

/-- Finite soldering action attached to one edge. -/
def solderingAction (U : Transport n) (eX eY : Coframe n) : ℚ :=
  defectNormSq (edgeDefect U eX eY)

/-- Orthogonal frame changes preserve the quadratic defect norm. -/
theorem defectNormSq_orthogonal
    (g : Matrix n n ℚ) (v : Coframe n) (hg : gᵀ * g = 1) :
    defectNormSq (g.mulVec v) = defectNormSq v := by
  sorry

/-- The edge soldering action is invariant under orthogonal endpoint frame
changes. -/
theorem solderingAction_frame_invariant
    (gX gXInv gY U : Matrix n n ℚ) (eX eY : Coframe n)
    (hX : gXInv * gX = 1) (hY : gYᵀ * gY = 1) :
    solderingAction (transformTransport gXInv gY U)
        (transformCoframe gX eX) (transformCoframe gY eY) =
      solderingAction U eX eY := by
  sorry

/-! ## Closed-loop holonomy defect -/

/-- Failure of a coframe to close after transport around a loop. -/
def holonomyDefect (H : Transport n) (e : Coframe n) : Coframe n :=
  H.mulVec e - e

/-- Holonomy changes by conjugation under a base-point frame change. -/
def transformHolonomy (gInv g H : Matrix n n ℚ) : Matrix n n ℚ :=
  g * H * gInv

/-- The holonomy defect transforms covariantly under conjugation. -/
theorem holonomyDefect_covariant
    (g gInv H : Matrix n n ℚ) (e : Coframe n) (hInv : gInv * g = 1) :
    holonomyDefect (transformHolonomy gInv g H) (transformCoframe g e) =
      transformCoframe g (holonomyDefect H e) := by
  sorry

/-- Trace of holonomy is invariant under a two-sided frame conjugation. -/
theorem holonomy_trace_invariant
    (g gInv H : Matrix n n ℚ)
    (hLeft : gInv * g = 1) (hRight : g * gInv = 1) :
    (transformHolonomy gInv g H).trace = H.trace := by
  sorry

/-! ## Exact nondegenerate witness -/

/-- Identity transport on the rational two-frame. -/
def witnessU : Matrix (Fin 2) (Fin 2) ℚ := 1

/-- Source coframe for the nonzero-defect witness. -/
def witnessEX : Coframe (Fin 2) := ![1, 0]

/-- Target coframe for the nonzero-defect witness. -/
def witnessEY : Coframe (Fin 2) := ![1, 1]

/-- Nontrivial orthogonal endpoint frame change. -/
def witnessG : Matrix (Fin 2) (Fin 2) ℚ := !![0, 1; 1, 0]

/-- Exact nonzero soldering defect, nontrivial frame covariance, and invariant
action in the `2x2` rational fixture. -/
theorem rational_nonzero_covariant_witness :
    edgeDefect witnessU witnessEX witnessEY = ![0, 1]
      ∧ edgeDefect witnessU witnessEX witnessEY ≠ 0
      ∧ witnessG ≠ 1
      ∧ witnessGᵀ * witnessG = 1
      ∧ transformCoframe witnessG (edgeDefect witnessU witnessEX witnessEY) = ![1, 0]
      ∧ solderingAction witnessU witnessEX witnessEY = 1 := by
  sorry

/-- Finite geometric verdict: covariance, refinement composition, invariant
action, holonomy conjugacy, and a nonzero rational fixture. -/
theorem soldering_local_frame_covariance_verdict :
    (∀ (Uxy Uyz : Transport (Fin 2)) (eX eY eZ : Coframe (Fin 2)),
      edgeDefect (Uyz * Uxy) eX eZ =
        edgeDefect Uyz eY eZ + Uyz.mulVec (edgeDefect Uxy eX eY))
      ∧ edgeDefect witnessU witnessEX witnessEY ≠ 0
      ∧ solderingAction witnessU witnessEX witnessEY = 1 := by
  sorry

end SolderingLocalFrameCovariance
