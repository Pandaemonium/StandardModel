import Mathlib

/-!
# Explicit 3+1 Clifford walk symbol

This module gives concrete `4 x 4` complex velocity matrices and a mass-turn
matrix. Their exact Clifford anticommutation relations imply that the symbol

`H(k,m) = k1 alpha1 + k2 alpha2 + k3 alpha3 + m beta`

squares to `(k1^2+k2^2+k3^2+m^2) I`. Each component velocity matrix has only
the eigenvalues `+1` and `-1`, and the `(1,2,2,3)` fixture is nonzero with
square `18 I`.

This is the internal algebra required by a 3+1 checkerboard or BCC walk. It is
not yet a lattice shift operator, a path-sum theorem, a proof of microscopic
speed for every channel, or a 3+1 continuum limit.

Provenance: clean-room matrix target informed by Mlodinow-Brun,
arXiv:1802.03910, and completed by Aristotle project
`3be91060-94dc-444d-a746-ddfd0429e3c7`. The paper motivates the walk
architecture; the finite matrix identities below were independently checked.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol

abbrev Mat4 := Matrix (Fin 4) (Fin 4) ℂ

def alpha1 : Mat4 :=
  !![0, 0, 0, 1;
     0, 0, 1, 0;
     0, 1, 0, 0;
     1, 0, 0, 0]

def alpha2 : Mat4 :=
  !![0, 0, 0, -I;
     0, 0, I, 0;
     0, -I, 0, 0;
     I, 0, 0, 0]

def alpha3 : Mat4 :=
  !![0, 0, 1, 0;
     0, 0, 0, -1;
     1, 0, 0, 0;
     0, -1, 0, 0]

def beta : Mat4 :=
  !![1, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, -1, 0;
     0, 0, 0, -1]

def alpha : Fin 3 -> Mat4
  | 0 => alpha1
  | 1 => alpha2
  | 2 => alpha3

def H (kx ky kz m : ℝ) : Mat4 :=
  (kx : ℂ) • alpha1 + (ky : ℂ) • alpha2 +
    (kz : ℂ) • alpha3 + (m : ℂ) • beta

theorem alpha_sq (j : Fin 3) : alpha j * alpha j = 1 := by
  fin_cases j <;>
    simp only [alpha, alpha1, alpha2, alpha3] <;>
    · ext a b
      fin_cases a <;> fin_cases b <;>
        simp [Matrix.mul_apply, Fin.sum_univ_four]

set_option maxHeartbeats 1000000 in
/-- Distinct component-velocity matrices anticommute. -/
theorem alpha_pairwise_anticommute (i j : Fin 3) (hij : i ≠ j) :
    alpha i * alpha j + alpha j * alpha i = 0 := by
  fin_cases i <;> fin_cases j <;> first
    | exact absurd rfl hij
    | (simp only [alpha, alpha1, alpha2, alpha3]
       ext a b
       fin_cases a <;> fin_cases b <;> simp)

theorem beta_sq : beta * beta = 1 := by
  simp only [beta]
  ext a b
  fin_cases a <;> fin_cases b <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem alpha_beta_anticommute (j : Fin 3) :
    alpha j * beta + beta * alpha j = 0 := by
  fin_cases j <;>
    simp only [alpha, alpha1, alpha2, alpha3, beta] <;>
    · ext a b
      fin_cases a <;> fin_cases b <;> simp

set_option maxHeartbeats 2000000 in
/-- Exact relativistic square of the displayed 3+1 walk Hamiltonian symbol. -/
theorem H_sq (kx ky kz m : ℝ) :
    H kx ky kz m * H kx ky kz m =
      ((kx ^ 2 + ky ^ 2 + kz ^ 2 + m ^ 2 : ℝ) : ℂ) • (1 : Mat4) := by
  simp only [H, alpha1, alpha2, alpha3, beta]
  ext a b
  fin_cases a <;> fin_cases b <;>
    (simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.smul_apply,
      Complex.ext_iff, -Complex.ofReal_pow]; (try constructor) <;> ring)

set_option maxHeartbeats 1000000 in
/-- Every component-velocity matrix has exactly the spectral values `+1` and
`-1` in units where `c=1`. -/
theorem component_velocity_spectrum (j : Fin 3) (v : ℝ) :
    (((v : ℂ) • (1 : Mat4) - alpha j).det = 0) ↔ v = 1 ∨ v = -1 := by
  have key : ((v : ℂ) • (1 : Mat4) - alpha j).det =
      ((v : ℂ) ^ 2 - 1) ^ 2 := by
    fin_cases j <;>
      simp only [alpha, alpha1, alpha2, alpha3] <;>
      (rw [Matrix.det_succ_row_zero]
       simp [Fin.sum_univ_four, Matrix.det_fin_three, Matrix.sub_apply,
         Matrix.smul_apply, Matrix.one_apply, Matrix.submatrix_apply,
         Fin.succ, Fin.succAbove]
       ring_nf <;> simp only [Complex.I_sq] <;> ring)
  rw [key, pow_eq_zero_iff two_ne_zero, sub_eq_zero]
  rw [show (1 : ℂ) = ((1 : ℝ) : ℂ) by norm_num,
    ← Complex.ofReal_pow, Complex.ofReal_inj]
  exact sq_eq_one_iff

set_option maxHeartbeats 2000000 in
/-- A nonzero rational symbol with exact square `18 I`. -/
theorem nondegenerate_1223_witness :
    H 1 2 2 3 * H 1 2 2 3 = (18 : ℂ) • (1 : Mat4) ∧
      H 1 2 2 3 ≠ 0 := by
  refine ⟨?_, ?_⟩
  · rw [H_sq]
    norm_num
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    simp only [H, alpha1, alpha2, alpha3, beta, Matrix.add_apply,
      Matrix.smul_apply, Matrix.zero_apply, smul_eq_mul, Matrix.of_apply,
      Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_fin_one,
      Matrix.empty_val'] at h00
    norm_num [Complex.ext_iff] at h00

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.H_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms H_sq

/-- info: 'PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.component_velocity_spectrum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms component_velocity_spectrum

/-- info: 'PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol.nondegenerate_1223_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegenerate_1223_witness

end PhysicsSM.Draft.NullEdge.Clifford3Plus1WalkSymbol
