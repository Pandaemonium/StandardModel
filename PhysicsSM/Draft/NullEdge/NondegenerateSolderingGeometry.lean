import Mathlib

/-!
# Nondegenerate finite matrix-coframe geometry

This module upgrades vector-valued soldering covariance to square matrix
coframes.  It proves preservation of coframe nondegeneracy, invariance of the
induced metric and volume under the appropriate finite frame groups, covariance
and exact refinement of matrix soldering defects, and invariance of a
Lorentzian quadratic defect action.

The exact rational 1+1 fixture uses a nonidentity Lorentz boost, invertible
source and target coframes, and a nonzero defect action.  This remains finite
linear algebra; it does not construct a continuum tetrad bundle or derive a
gravitational field equation.

Recovered from Aristotle project `96135427-97fc-4cce-86bd-43bbc0aedf55`.
-/

open Matrix

namespace PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry

variable {n : Type*} [Fintype n] [DecidableEq n]

/-- A square finite coframe. -/
abbrev Coframe (n : Type*) := Matrix n n ℚ

/-- A finite frame transport. -/
abbrev Transport (n : Type*) := Matrix n n ℚ

/-- A coframe is nondegenerate when its determinant is nonzero. -/
def Nondegenerate (e : Coframe n) : Prop := e.det ≠ 0

/-- Metric induced from an internal bilinear form by a coframe. -/
def inducedMetric (eta e : Matrix n n ℚ) : Matrix n n ℚ :=
  eᵀ * eta * e

/-- Matrix-valued coframe mismatch on an oriented edge. -/
def coframeDefect (U : Transport n) (eX eY : Coframe n) : Matrix n n ℚ :=
  eY - U * eX

/-- Endpoint frame action on a coframe. -/
def transformCoframe (g : Matrix n n ℚ) (e : Coframe n) : Coframe n :=
  g * e

/-- Endpoint frame action on transport: `U' = gY U gX^{-1}`. -/
def transformTransport
    (gXInv gY : Matrix n n ℚ) (U : Transport n) : Transport n :=
  gY * U * gXInv

/-- Invertible local frame changes preserve and reflect nondegeneracy. -/
theorem nondegenerate_transform_iff
    (g gInv e : Matrix n n ℚ)
    (_hLeft : gInv * g = 1) (hRight : g * gInv = 1) :
    Nondegenerate (transformCoframe g e) ↔ Nondegenerate e := by
  have hg : g.det ≠ 0 :=
    left_ne_zero_of_mul_eq_one (by rw [← det_mul, hRight, det_one])
  unfold Nondegenerate transformCoframe
  rw [det_mul]
  exact mul_ne_zero_iff.trans ⟨fun h => h.2, fun h => ⟨hg, h⟩⟩

omit [DecidableEq n] in
/-- An `eta`-orthogonal internal frame leaves the induced metric unchanged. -/
theorem inducedMetric_frame_invariant
    (eta g e : Matrix n n ℚ) (hLorentz : gᵀ * eta * g = eta) :
    inducedMetric eta (transformCoframe g e) = inducedMetric eta e := by
  unfold inducedMetric transformCoframe
  rw [transpose_mul,
    show eᵀ * gᵀ * eta * (g * e) = eᵀ * (gᵀ * eta * g) * e by noncomm_ring,
    hLorentz]

/-- A determinant-one internal frame leaves the coframe volume unchanged. -/
theorem coframeVolume_specialLinear
    (g e : Matrix n n ℚ) (hdet : g.det = 1) :
    (transformCoframe g e).det = e.det := by
  unfold transformCoframe
  rw [det_mul, hdet, one_mul]

/-- The matrix-coframe soldering defect transforms covariantly at its target. -/
theorem coframeDefect_covariant
    (gX gXInv gY U eX eY : Matrix n n ℚ)
    (hX : gXInv * gX = 1) :
    coframeDefect (transformTransport gXInv gY U)
        (transformCoframe gX eX) (transformCoframe gY eY) =
      gY * coframeDefect U eX eY := by
  unfold coframeDefect transformTransport transformCoframe
  rw [show gY * U * gXInv * (gX * eX) =
      gY * U * (gXInv * gX) * eX by noncomm_ring, hX]
  simp [mul_sub, mul_assoc]

omit [DecidableEq n] in
/-- Exact subdivision law for matrix-coframe defects. -/
theorem coframeDefect_composition
    (Uxy Uyz eX eY eZ : Matrix n n ℚ) :
    coframeDefect (Uyz * Uxy) eX eZ =
      coframeDefect Uyz eY eZ + Uyz * coframeDefect Uxy eX eY := by
  unfold coframeDefect
  noncomm_ring

/-- Lorentzian quadratic action of a matrix-valued soldering defect. -/
def defectAction (eta T : Matrix n n ℚ) : ℚ :=
  (Tᵀ * eta * T).trace

omit [DecidableEq n] in
/-- The defect action is invariant under an `eta`-orthogonal frame. -/
theorem defectAction_frame_invariant
    (eta g T : Matrix n n ℚ) (hLorentz : gᵀ * eta * g = eta) :
    defectAction eta (g * T) = defectAction eta T := by
  unfold defectAction
  rw [transpose_mul,
    show Tᵀ * gᵀ * eta * (g * T) = Tᵀ * (gᵀ * eta * g) * T by
      noncomm_ring,
    hLorentz]

/-- The transported edge action is invariant under endpoint frame changes
whose target frame preserves `eta`. -/
theorem coframeDefectAction_frame_invariant
    (eta gX gXInv gY U eX eY : Matrix n n ℚ)
    (hX : gXInv * gX = 1) (hY : gYᵀ * eta * gY = eta) :
    defectAction eta
        (coframeDefect (transformTransport gXInv gY U)
          (transformCoframe gX eX) (transformCoframe gY eY)) =
      defectAction eta (coframeDefect U eX eY) := by
  rw [coframeDefect_covariant gX gXInv gY U eX eY hX,
    defectAction_frame_invariant eta gY _ hY]

/-! ## Exact rational 1+1 fixture -/

def eta11 : Matrix (Fin 2) (Fin 2) ℚ := !![1, 0; 0, -1]

def boost : Matrix (Fin 2) (Fin 2) ℚ := !![5 / 3, 4 / 3; 4 / 3, 5 / 3]

def witnessEX : Coframe (Fin 2) := 1

def witnessEY : Coframe (Fin 2) := !![2, 0; 0, 1]

def witnessU : Transport (Fin 2) := 1

/-- The rational boost is nonidentity, determinant one, and Lorentz. -/
theorem boost_exact :
    boost ≠ 1 ∧ boost.det = 1 ∧ boostᵀ * eta11 * boost = eta11 := by
  refine ⟨?_, ?_, ?_⟩
  · intro h
    have h01 := congrFun (congrFun h 0) 1
    simp [boost] at h01
  · simp [boost, det_fin_two]
    norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [boost, eta11, mul_apply, Fin.sum_univ_two] <;> norm_num

/-- Both coframes are nondegenerate, their mismatch is nonzero, and its
Lorentzian quadratic action is exactly one. -/
theorem nondegenerate_nonzero_defect_witness :
    Nondegenerate witnessEX
      ∧ Nondegenerate witnessEY
      ∧ coframeDefect witnessU witnessEX witnessEY = !![1, 0; 0, 0]
      ∧ coframeDefect witnessU witnessEX witnessEY ≠ 0
      ∧ defectAction eta11 (coframeDefect witnessU witnessEX witnessEY) = 1
      ∧ defectAction eta11
          (boost * coframeDefect witnessU witnessEX witnessEY) = 1 := by
  have hd : coframeDefect witnessU witnessEX witnessEY = !![1, 0; 0, 0] := by
    unfold coframeDefect witnessU witnessEX witnessEY
    ext i j
    fin_cases i <;> fin_cases j <;> simp <;> norm_num
  refine ⟨?_, ?_, hd, ?_, ?_, ?_⟩
  · simp [Nondegenerate, witnessEX]
  · simp [Nondegenerate, witnessEY, det_fin_two]
  · rw [hd]
    intro h
    have h00 := congrFun (congrFun h 0) 0
    simp at h00
  · rw [hd]
    simp [defectAction, eta11, mul_apply, Fin.sum_univ_two, trace, diag]
  · rw [hd]
    simp [defectAction, eta11, boost, mul_apply, Fin.sum_univ_two, trace, diag]
    norm_num

/-- Nondegenerate finite soldering verdict with a genuine rational Lorentz
frame change, generic target covariance, and exact two-edge refinement. -/
theorem nondegenerate_soldering_geometry_verdict :
    (boost ≠ 1
        ∧ boost.det = 1
        ∧ boostᵀ * eta11 * boost = eta11
        ∧ Nondegenerate witnessEX
        ∧ Nondegenerate witnessEY
        ∧ coframeDefect witnessU witnessEX witnessEY ≠ 0
        ∧ defectAction eta11 (coframeDefect witnessU witnessEX witnessEY) = 1
        ∧ inducedMetric eta11 (transformCoframe boost witnessEX) =
            inducedMetric eta11 witnessEX)
      ∧ (∀ (gX gXInv gY U eX eY : Matrix (Fin 2) (Fin 2) ℚ),
          gXInv * gX = 1 →
          coframeDefect (transformTransport gXInv gY U)
              (transformCoframe gX eX) (transformCoframe gY eY) =
            gY * coframeDefect U eX eY)
      ∧ (∀ (Uxy Uyz eX eY eZ : Matrix (Fin 2) (Fin 2) ℚ),
          coframeDefect (Uyz * Uxy) eX eZ =
            coframeDefect Uyz eY eZ + Uyz * coframeDefect Uxy eX eY) := by
  obtain ⟨hb1, hb2, hb3⟩ := boost_exact
  obtain ⟨hnx, hny, _hdeq, hdne, hda, _⟩ :=
    nondegenerate_nonzero_defect_witness
  refine ⟨⟨hb1, hb2, hb3, hnx, hny, hdne, hda, ?_⟩, ?_, ?_⟩
  · exact inducedMetric_frame_invariant eta11 boost witnessEX hb3
  · exact fun gX gXInv gY U eX eY hX =>
      coframeDefect_covariant gX gXInv gY U eX eY hX
  · exact fun Uxy Uyz eX eY eZ =>
      coframeDefect_composition Uxy Uyz eX eY eZ

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.nondegenerate_transform_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.nondegenerate_transform_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.nondegenerate_nonzero_defect_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.nondegenerate_nonzero_defect_witness

/-- info: 'PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.nondegenerate_soldering_geometry_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry.nondegenerate_soldering_geometry_verdict

end PhysicsSM.Draft.NullEdge.NondegenerateSolderingGeometry
