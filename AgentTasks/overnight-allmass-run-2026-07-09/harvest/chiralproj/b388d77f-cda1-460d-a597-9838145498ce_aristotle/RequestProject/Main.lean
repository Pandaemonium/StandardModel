import Mathlib

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

/-!
# Chiral projectors P_L, P_R in the Dirac representation (rational 4×4)

Clean-room grounding of the chiral (Weyl) decomposition of a Dirac spinor, in the
Dirac representation. In the Dirac representation

  `gamma5 = i·gamma0·gamma1·gamma2·gamma3`

is the REAL block off-diagonal identity matrix
`!![0,0,1,0; 0,0,0,1; 1,0,0,0; 0,1,0,0]`, so the chiral projectors
`P_L = (1 - gamma5)/2`, `P_R = (1 + gamma5)/2` are RATIONAL
(entries in `{0, 1/2, -1/2}`).

We prove they are a complete pair of orthogonal projectors splitting the 4-spinor
into two 2-dimensional chirality sectors — the Weyl decomposition — kernel-checked.

Provenance: PhysLean `Fermion.LeftHandedWeyl` / `RightHandedWeyl` and its `gamma5`
(used as a REFERENCE / convention only, NOT imported). Honest scope: the finite
projector algebra only (not the Lorentz representation or the mass coupling).
-/

namespace ChiralProjectorsDirac

/-- The Dirac-representation `gamma5` as a real (rational) 4×4 matrix:
the block off-diagonal identity `i·gamma0·gamma1·gamma2·gamma3`. -/
def g5 : Matrix (Fin 4) (Fin 4) ℚ :=
  !![0, 0, 1, 0;
     0, 0, 0, 1;
     1, 0, 0, 0;
     0, 1, 0, 0]

/-- Left chiral projector `P_L = (1 - gamma5)/2` (as `(1/2) • (1 - gamma5)`). -/
def PL : Matrix (Fin 4) (Fin 4) ℚ := (1/2 : ℚ) • (1 - g5)

/-- Right chiral projector `P_R = (1 + gamma5)/2` (as `(1/2) • (1 + gamma5)`). -/
def PR : Matrix (Fin 4) (Fin 4) ℚ := (1/2 : ℚ) • (1 + g5)

/-! ## 1. `gamma5` is an involution -/

theorem g5_involutive : g5 * g5 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g5, Matrix.mul_apply, Fin.sum_univ_four]

/-- info: 'ChiralProjectorsDirac.g5_involutive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms g5_involutive

/-! ## 2. `gamma5` is traceless -/

theorem g5_traceless : Matrix.trace g5 = 0 := by
  simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four, g5]

/-- info: 'ChiralProjectorsDirac.g5_traceless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms g5_traceless

/-! ## 3. Completeness: `P_L + P_R = 1` -/

theorem projectors_complete : PL + PR = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [PL, PR, g5, Matrix.add_apply, Matrix.smul_apply, Matrix.sub_apply] <;> ring

/-- info: 'ChiralProjectorsDirac.projectors_complete' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_complete

/-! ## 4. Idempotency (payload): each of `P_L`, `P_R` is a projector -/

theorem projectors_idempotent : PL * PL = PL ∧ PR * PR = PR := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PL, g5, Matrix.mul_apply, Matrix.smul_apply, Matrix.sub_apply,
        Fin.sum_univ_four, Matrix.one_apply] <;> norm_num
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PR, g5, Matrix.mul_apply, Matrix.smul_apply, Matrix.add_apply,
        Fin.sum_univ_four, Matrix.one_apply] <;> norm_num

/-- info: 'ChiralProjectorsDirac.projectors_idempotent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_idempotent

/-! ## 5. Orthogonality (payload): the chiralities are disjoint -/

theorem projectors_orthogonal : PL * PR = 0 ∧ PR * PL = 0 := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PL, PR, g5, Matrix.mul_apply, Matrix.smul_apply, Matrix.sub_apply,
        Matrix.add_apply, Fin.sum_univ_four, Matrix.one_apply]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PL, PR, g5, Matrix.mul_apply, Matrix.smul_apply, Matrix.sub_apply,
        Matrix.add_apply, Fin.sum_univ_four, Matrix.one_apply]

/-- info: 'ChiralProjectorsDirac.projectors_orthogonal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_orthogonal

/-! ## 6. Chirality eigenvalues: `P_L` = -1 eigenspace, `P_R` = +1 eigenspace -/

theorem chirality_eigenvalues : g5 * PL = - PL ∧ g5 * PR = PR := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PL, g5, Matrix.mul_apply, Matrix.smul_apply, Matrix.sub_apply,
        Matrix.neg_apply, Fin.sum_univ_four, Matrix.one_apply]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PR, g5, Matrix.mul_apply, Matrix.smul_apply, Matrix.add_apply,
        Fin.sum_univ_four, Matrix.one_apply]

/-- info: 'ChiralProjectorsDirac.chirality_eigenvalues' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms chirality_eigenvalues

/-! ## 7. Projector ranks: each chirality sector is 2-dimensional -/

theorem projector_ranks : Matrix.trace PL = 2 ∧ Matrix.trace PR = 2 := by
  constructor
  · simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four, PL, g5, Matrix.smul_apply,
      Matrix.sub_apply]
    norm_num
  · simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four, PR, g5, Matrix.smul_apply,
      Matrix.add_apply]
    norm_num

/-- info: 'ChiralProjectorsDirac.projector_ranks' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projector_ranks

/-! ## Non-degeneracy: the involution and projectors are genuinely nontrivial -/

theorem g5_nontrivial : g5 ≠ 1 ∧ g5 ≠ -1 := by
  constructor
  · intro h
    have : g5 0 0 = (1 : Matrix (Fin 4) (Fin 4) ℚ) 0 0 := by rw [h]
    simp [g5] at this
  · intro h
    have : g5 0 2 = (-1 : Matrix (Fin 4) (Fin 4) ℚ) 0 2 := by rw [h]
    simp [g5, Matrix.neg_apply] at this

/-- info: 'ChiralProjectorsDirac.g5_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms g5_nontrivial

theorem projectors_nontrivial :
    PL ≠ 0 ∧ PR ≠ 0 ∧ PL ≠ PR ∧ PL 0 2 = -1/2 := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro h
    have : PL 0 0 = (0 : Matrix (Fin 4) (Fin 4) ℚ) 0 0 := by rw [h]
    simp [PL, g5, Matrix.smul_apply, Matrix.sub_apply] at this
  · intro h
    have : PR 0 0 = (0 : Matrix (Fin 4) (Fin 4) ℚ) 0 0 := by rw [h]
    simp [PR, g5, Matrix.smul_apply, Matrix.add_apply] at this
  · intro h
    have : PL 0 2 = PR 0 2 := by rw [h]
    simp [PL, PR, g5, Matrix.smul_apply, Matrix.sub_apply, Matrix.add_apply] at this
    norm_num at this
  · simp [PL, g5, Matrix.smul_apply, Matrix.sub_apply]; norm_num

/-- info: 'ChiralProjectorsDirac.projectors_nontrivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms projectors_nontrivial

/-! ## 8. Weyl decomposition verdict -/

/-- **Weyl decomposition verdict.** In the Dirac representation, `gamma5` is a
traceless involution; the chiral projectors `P_L, P_R = (1 ∓ gamma5)/2` are a
complete pair of orthogonal idempotents projecting the Dirac spinor onto its two
2-dimensional chirality (Weyl) sectors, the `-1`/`+1` eigenspaces of `gamma5`.

This grounds the chiral decomposition (the massless Weyl pieces of the zigzag) in
the PhysLean Weyl-spinor convention (`Fermion.LeftHandedWeyl` / `RightHandedWeyl`,
`gamma5`), clean-room. Honest scope: the finite projector algebra only (not the
Lorentz representation or the mass coupling). -/
theorem weyl_decomposition_verdict :
    -- gamma5 is a traceless involution
    g5 * g5 = 1 ∧ Matrix.trace g5 = 0 ∧
    -- complete pair of orthogonal idempotents
    PL + PR = 1 ∧ PL * PL = PL ∧ PR * PR = PR ∧
    PL * PR = 0 ∧ PR * PL = 0 ∧
    -- chirality eigenspaces
    g5 * PL = - PL ∧ g5 * PR = PR ∧
    -- 2-dimensional sectors
    Matrix.trace PL = 2 ∧ Matrix.trace PR = 2 ∧
    -- non-degeneracy
    g5 ≠ 1 ∧ g5 ≠ -1 ∧ PL ≠ 0 ∧ PR ≠ 0 ∧ PL ≠ PR ∧ PL 0 2 = -1/2 := by
  refine ⟨g5_involutive, g5_traceless, projectors_complete,
    projectors_idempotent.1, projectors_idempotent.2,
    projectors_orthogonal.1, projectors_orthogonal.2,
    chirality_eigenvalues.1, chirality_eigenvalues.2,
    projector_ranks.1, projector_ranks.2,
    g5_nontrivial.1, g5_nontrivial.2,
    projectors_nontrivial.1, projectors_nontrivial.2.1,
    projectors_nontrivial.2.2.1, projectors_nontrivial.2.2.2⟩

/-- info: 'ChiralProjectorsDirac.weyl_decomposition_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weyl_decomposition_verdict

end ChiralProjectorsDirac
