import Mathlib

/-!
# Finite soldering local-frame covariance

DRAFT (kernel-clean). This module closes the first finite geometric kill test on
the null-edge soldering interpretation. A rational vector-valued coframe avatar
has a transport defect that transforms covariantly under independent endpoint
frame changes, composes under refinement, and has an invariant quadratic action
for orthogonal frames. Closed-loop holonomy transforms by conjugation.

This is not yet a nondegenerate tetrad field, a continuum local-Lorentz theorem,
or a gravitational field equation. It validates only the displayed finite
transformation law and refinement algebra.

Provenance: clean-room finite linear-algebra formalization, with the coframe and
teleparallel transformation pattern checked against Baez--Wise,
arXiv:1204.4339. Aristotle job
`f34795b7-2aaa-4a5d-8932-9e43f7e7c81c` supplied the proof.
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
  unfold edgeDefect transformTransport transformCoframe
  rw [Matrix.mulVec_sub, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
    Matrix.mul_assoc, Matrix.mul_assoc, hX, Matrix.mul_one]

/-- Vanishing soldering defect is preserved by an invertible endpoint frame
change. -/
theorem edgeDefect_zero_iff_frame_change
    (gX gXInv gY gYInv U : Matrix n n ℚ) (eX eY : Coframe n)
    (hX : gXInv * gX = 1) (hY : gYInv * gY = 1) :
    edgeDefect (transformTransport gXInv gY U)
        (transformCoframe gX eX) (transformCoframe gY eY) = 0 ↔
      edgeDefect U eX eY = 0 := by
  rw [edgeDefect_covariant gX gXInv gY U eX eY hX]
  unfold transformCoframe
  constructor
  · intro h
    have h2 := congrArg (gYInv.mulVec) h
    rw [Matrix.mulVec_mulVec, hY, Matrix.one_mulVec, Matrix.mulVec_zero] at h2
    exact h2
  · intro h; rw [h, Matrix.mulVec_zero]

omit [DecidableEq n] in
/-- **Refinement/composition law.** The defect of a two-edge composite is the
second-edge defect plus the transported first-edge defect. -/
theorem edgeDefect_composition
    (Uxy Uyz : Transport n) (eX eY eZ : Coframe n) :
    edgeDefect (Uyz * Uxy) eX eZ =
      edgeDefect Uyz eY eZ + Uyz.mulVec (edgeDefect Uxy eX eY) := by
  unfold edgeDefect
  rw [Matrix.mulVec_sub, Matrix.mulVec_mulVec]
  abel

omit [DecidableEq n] in
/-- A perfectly transported coframe has zero edge defect. -/
theorem edgeDefect_zero_of_parallel
    (U : Transport n) (eX eY : Coframe n) (h : eY = U.mulVec eX) :
    edgeDefect U eX eY = 0 := by
  unfold edgeDefect; rw [h]; abel

/-- Euclidean quadratic norm of a rational coframe defect. -/
def defectNormSq (v : Coframe n) : ℚ := dotProduct v v

/-- Finite soldering action attached to one edge. -/
def solderingAction (U : Transport n) (eX eY : Coframe n) : ℚ :=
  defectNormSq (edgeDefect U eX eY)

/-- Orthogonal frame changes preserve the quadratic defect norm. -/
theorem defectNormSq_orthogonal
    (g : Matrix n n ℚ) (v : Coframe n) (hg : gᵀ * g = 1) :
    defectNormSq (g.mulVec v) = defectNormSq v := by
  unfold defectNormSq
  rw [Matrix.dotProduct_mulVec, Matrix.vecMul_mulVec, hg, Matrix.vecMul_one]

/-- The edge soldering action is invariant under orthogonal endpoint frame
changes. -/
theorem solderingAction_frame_invariant
    (gX gXInv gY U : Matrix n n ℚ) (eX eY : Coframe n)
    (hX : gXInv * gX = 1) (hY : gYᵀ * gY = 1) :
    solderingAction (transformTransport gXInv gY U)
        (transformCoframe gX eX) (transformCoframe gY eY) =
      solderingAction U eX eY := by
  unfold solderingAction
  rw [edgeDefect_covariant gX gXInv gY U eX eY hX]
  exact defectNormSq_orthogonal gY (edgeDefect U eX eY) hY

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
  unfold holonomyDefect transformHolonomy transformCoframe
  rw [Matrix.mulVec_sub, Matrix.mulVec_mulVec, Matrix.mulVec_mulVec,
    Matrix.mul_assoc, Matrix.mul_assoc, hInv, Matrix.mul_one]

/-- Trace of holonomy is invariant under frame conjugation when `gInv` is a
left inverse of `g`. -/
theorem holonomy_trace_invariant
    (g gInv H : Matrix n n ℚ)
    (hLeft : gInv * g = 1) :
    (transformHolonomy gInv g H).trace = H.trace := by
  unfold transformHolonomy
  rw [Matrix.trace_mul_cycle, hLeft, Matrix.one_mul]

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
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  · funext i; fin_cases i <;>
      simp [edgeDefect, witnessU, witnessEX, witnessEY]
  · intro h
    have := congrFun h 1
    simp [edgeDefect, witnessU, witnessEX, witnessEY] at this
  · intro h
    have := congrFun (congrFun h 0) 0
    simp [witnessG] at this
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [witnessG, Matrix.mul_apply, Fin.sum_univ_two, Matrix.transpose]
  · funext i; fin_cases i <;>
      simp [transformCoframe, edgeDefect, witnessU, witnessEX, witnessEY, witnessG]
  · simp [solderingAction, defectNormSq, edgeDefect, witnessU, witnessEX, witnessEY]

/-- Finite geometric verdict: covariance, refinement composition, invariant
action, holonomy conjugacy, and a nonzero rational fixture. -/
theorem soldering_local_frame_covariance_verdict :
    (∀ (gX gXInv gY U : Matrix (Fin 2) (Fin 2) ℚ)
        (eX eY : Coframe (Fin 2)), gXInv * gX = 1 →
      edgeDefect (transformTransport gXInv gY U)
          (transformCoframe gX eX) (transformCoframe gY eY) =
        transformCoframe gY (edgeDefect U eX eY))
      ∧ (∀ (Uxy Uyz : Transport (Fin 2)) (eX eY eZ : Coframe (Fin 2)),
        edgeDefect (Uyz * Uxy) eX eZ =
          edgeDefect Uyz eY eZ + Uyz.mulVec (edgeDefect Uxy eX eY))
      ∧ (∀ (g : Matrix (Fin 2) (Fin 2) ℚ) (v : Coframe (Fin 2)),
        gᵀ * g = 1 → defectNormSq (g.mulVec v) = defectNormSq v)
      ∧ (∀ (g gInv H : Matrix (Fin 2) (Fin 2) ℚ) (e : Coframe (Fin 2)),
        gInv * g = 1 →
          holonomyDefect (transformHolonomy gInv g H) (transformCoframe g e) =
            transformCoframe g (holonomyDefect H e))
      ∧ (∀ (g gInv H : Matrix (Fin 2) (Fin 2) ℚ), gInv * g = 1 →
        (transformHolonomy gInv g H).trace = H.trace)
      ∧ edgeDefect witnessU witnessEX witnessEY ≠ 0
      ∧ solderingAction witnessU witnessEX witnessEY = 1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · exact fun gX gXInv gY U eX eY hX =>
      edgeDefect_covariant gX gXInv gY U eX eY hX
  · exact fun Uxy Uyz eX eY eZ => edgeDefect_composition Uxy Uyz eX eY eZ
  · exact fun g v hg => defectNormSq_orthogonal g v hg
  · exact fun g gInv H e hInv => holonomyDefect_covariant g gInv H e hInv
  · exact fun g gInv H hInv => holonomy_trace_invariant g gInv H hInv
  · exact rational_nonzero_covariant_witness.2.1
  · exact rational_nonzero_covariant_witness.2.2.2.2.2

/-! ## Local axiom-footprint guards

Each headline theorem is confirmed to rest only on the standard Lean/Mathlib
axioms (`propext`, `Classical.choice`, `Quot.sound`). -/

/-- info: 'SolderingLocalFrameCovariance.edgeDefect_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edgeDefect_covariant

/-- info: 'SolderingLocalFrameCovariance.edgeDefect_zero_iff_frame_change' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edgeDefect_zero_iff_frame_change

/-- info: 'SolderingLocalFrameCovariance.edgeDefect_composition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edgeDefect_composition

/-- info: 'SolderingLocalFrameCovariance.edgeDefect_zero_of_parallel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edgeDefect_zero_of_parallel

/-- info: 'SolderingLocalFrameCovariance.defectNormSq_orthogonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms defectNormSq_orthogonal

/-- info: 'SolderingLocalFrameCovariance.solderingAction_frame_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms solderingAction_frame_invariant

/-- info: 'SolderingLocalFrameCovariance.holonomyDefect_covariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms holonomyDefect_covariant

/-- info: 'SolderingLocalFrameCovariance.holonomy_trace_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms holonomy_trace_invariant

/-- info: 'SolderingLocalFrameCovariance.rational_nonzero_covariant_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms rational_nonzero_covariant_witness

/-- info: 'SolderingLocalFrameCovariance.soldering_local_frame_covariance_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms soldering_local_frame_covariance_verdict

end SolderingLocalFrameCovariance
