import Mathlib

/-!
# Exact tetrahedral null-history kinematics in 3+1 dimensions

This module supplies the rational geometric core of a 3+1-dimensional
checkerboard-like construction. Four spatial directions form a regular
tetrahedral frame inside the three-dimensional sum-zero subspace of Q^4.
The spatial inner product is normalized so every direction has unit norm.
Pairing each direction with one unit of time therefore gives a null step.

The main identity is an exact 3+1 analogue of the null-edge disagreement
formula: for a history with direction multiplicities c_i,

  endpointMassSq = (8/3) * sum_{i<j} c_i c_j.

Thus a straight history is null, while using two distinct directions produces
a timelike endpoint. The module also proves the tetrahedral tight-frame factor
1/3. That factor is the normalization gate behind the simplest
spin-projector discretizations: a one-step microscopic speed normalized to one
produces a first-moment continuum coefficient 1/3; matching unit continuum
speed requires a step scale of three.

This is exact finite kinematics and isotropy. It does not yet construct the
spin-projector path amplitude, prove unitarity, or take a continuum limit.

Provenance: clean-room theorem shape from Foster--Jacobson,
arXiv:1610.01142, and the 3+1 Weyl-walk literature, especially
arXiv:1705.08552. No external code is imported.
-/

open scoped BigOperators
open Matrix

namespace PhysicsSM.Draft.NullEdge.TetrahedralNullHistory

/-- The four directions of the tetrahedral frame. -/
abbrev Dir := Fin 4

/-- A rational realization of the regular tetrahedron in the sum-zero
subspace of Q^4: coordinate i is 1, the other three are -1/3. -/
def tetraDir (i : Dir) : Dir -> ℚ :=
  fun j => if i = j then 1 else -(1 / 3)

/-- The spatial inner product on the sum-zero subspace. The factor 3/4
normalizes every tetrahedral direction to unit length. -/
def spatialDot (u v : Dir -> ℚ) : ℚ :=
  (3 / 4) * dotProduct u v

/-- Every tetrahedral direction lies in the three-dimensional sum-zero
subspace. -/
theorem tetraDir_sum_zero (i : Dir) :
    ∑ j, tetraDir i j = 0 := by
  fin_cases i <;>
    norm_num (config := { decide := true }) [tetraDir, Fin.sum_univ_four]

/-- Exact tetrahedral Gram matrix: unit diagonal and mutual angle -1/3. -/
theorem tetraDir_gram (i j : Dir) :
    spatialDot (tetraDir i) (tetraDir j) =
      if i = j then 1 else -(1 / 3) := by
  fin_cases i <;> fin_cases j <;>
    norm_num (config := { decide := true })
      [spatialDot, dotProduct, tetraDir, Fin.sum_univ_four]

/-- A finite history modulo ordering, represented by the multiplicity of each
tetrahedral direction. Ordering affects spin phase, but not endpoint
kinematics. -/
abbrev HistoryCount := Dir -> ℕ

/-- Elapsed microscopic time: one unit per primitive step. -/
def historyTime (c : HistoryCount) : ℚ :=
  ∑ i, (c i : ℚ)

/-- Spatial endpoint of the counted history. -/
def historySpace (c : HistoryCount) : Dir -> ℚ :=
  fun j => ∑ i, (c i : ℚ) * tetraDir i j

/-- Minkowski squared norm in mostly-minus convention. -/
def endpointMassSq (c : HistoryCount) : ℚ :=
  historyTime c ^ 2 - spatialDot (historySpace c) (historySpace c)

/-- Pairwise directional disagreement of a tetrahedral history. -/
def pairDisagreement (c : HistoryCount) : ℚ :=
  (8 / 3) *
    ((c 0 : ℚ) * c 1 + (c 0 : ℚ) * c 2 + (c 0 : ℚ) * c 3 +
      (c 1 : ℚ) * c 2 + (c 1 : ℚ) * c 3 + (c 2 : ℚ) * c 3)

/-- Exact 3+1 null-history disagreement identity. The endpoint mass squared is
the sum over unordered pairs of distinct tetrahedral directions, with weight
8/3. -/
theorem endpointMassSq_eq_pairDisagreement (c : HistoryCount) :
    endpointMassSq c = pairDisagreement c := by
  simp (config := { decide := true }) [endpointMassSq, historyTime,
    historySpace, spatialDot, dotProduct, pairDisagreement,
    Fin.sum_univ_four, tetraDir]
  ring

/-- Every counted tetrahedral null history has causal endpoint. -/
theorem endpointMassSq_nonneg (c : HistoryCount) :
    0 ≤ endpointMassSq c := by
  rw [endpointMassSq_eq_pairDisagreement]
  unfold pairDisagreement
  positivity

/-- A history using only one direction remains null, for every length. -/
def singleDirection (i : Dir) (n : ℕ) : HistoryCount :=
  fun j => if j = i then n else 0

theorem singleDirection_null (i : Dir) (n : ℕ) :
    endpointMassSq (singleDirection i n) = 0 := by
  rw [endpointMassSq_eq_pairDisagreement]
  fin_cases i <;> simp [pairDisagreement, singleDirection]

/-- Exact nondegenerate two-direction fixture. -/
def mixed01 : HistoryCount := ![1, 1, 0, 0]

theorem mixed01_timelike :
    historyTime mixed01 = 2
      ∧ endpointMassSq mixed01 = 8 / 3
      ∧ 0 < endpointMassSq mixed01 := by
  rw [endpointMassSq_eq_pairDisagreement]
  norm_num [historyTime, pairDisagreement, mixed01, Fin.sum_univ_four]

/-! ## Tetrahedral isotropy and the speed-normalization gate -/

/-- The tetrahedral frame operator. -/
def frameOp (v : Dir -> ℚ) : Dir -> ℚ :=
  fun j => (1 / 4) * ∑ i, spatialDot (tetraDir i) v * tetraDir i j

/-- The regular tetrahedron is a tight frame on its sum-zero spatial
subspace, with exact frame constant 1/3. -/
theorem frameOp_eq_third (v : Dir -> ℚ) (hv : ∑ j, v j = 0) :
    frameOp v = (1 / 3 : ℚ) • v := by
  funext j
  have hv' : v 0 + v 1 + v 2 + v 3 = 0 := by
    simpa [Fin.sum_univ_four] using hv
  fin_cases j <;>
    simp [frameOp, spatialDot, dotProduct, tetraDir, Fin.sum_univ_four] <;>
    linarith

/-- A unit microscopic step scale yields only one third of unit speed in the
tetrahedral first moment. -/
theorem unit_step_isotropy_factor :
    (1 / 3 : ℚ) < 1 := by
  norm_num

/-- Matching a unit first-moment continuum coefficient requires microscopic
step scale three in the basic tetrahedral averaging scheme. -/
theorem continuum_speed_one_iff_step_scale_three (s : ℚ) :
    s / 3 = 1 ↔ s = 3 := by
  constructor <;> intro h
  · linarith
  · rw [h]
    norm_num

/-- Compact verdict: primitive steps are null, mixed directions generate a
positive timelike defect, and tetrahedral isotropy carries the exact 1/3
normalization gate. -/
theorem tetrahedral_null_history_verdict :
    (∀ i : Dir, endpointMassSq (singleDirection i 1) = 0)
      ∧ endpointMassSq mixed01 = 8 / 3
      ∧ 0 < endpointMassSq mixed01
      ∧ (∀ s : ℚ, s / 3 = 1 ↔ s = 3) := by
  constructor
  · intro i
    exact singleDirection_null i 1
  constructor
  · exact mixed01_timelike.2.1
  constructor
  · exact mixed01_timelike.2.2
  · exact continuum_speed_one_iff_step_scale_three

end PhysicsSM.Draft.NullEdge.TetrahedralNullHistory

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.TetrahedralNullHistory.endpointMassSq_eq_pairDisagreement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetrahedralNullHistory.endpointMassSq_eq_pairDisagreement

/-- info: 'PhysicsSM.Draft.NullEdge.TetrahedralNullHistory.frameOp_eq_third' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetrahedralNullHistory.frameOp_eq_third

/-- info: 'PhysicsSM.Draft.NullEdge.TetrahedralNullHistory.tetrahedral_null_history_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.TetrahedralNullHistory.tetrahedral_null_history_verdict
