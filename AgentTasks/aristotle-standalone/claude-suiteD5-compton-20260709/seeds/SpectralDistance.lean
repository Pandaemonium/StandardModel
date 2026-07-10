import Mathlib

/-!
# Background independence via the Connes spectral distance (Conjecture P, finite witness)

This file formalizes the **Connes spectral distance**

`d(x,y) = sup { |f x - f y| : f ∈ A, ‖[D,f]‖ ≤ 1 }`

for a *finite null-edge carrier*, where

* the algebra `A` is the algebra of `ℂ`-valued functions on the finite vertex set `Fin n`,
  acting on the Hilbert space `EuclideanSpace ℂ (Fin n)` by the diagonal multiplication
  operator `Matrix.diagonal f`;
* the Dirac operator `D` is a self-adjoint matrix `Matrix (Fin n) (Fin n) ℂ`;
* `[D,f] = D · diag f − diag f · D` is the commutator, and `‖·‖` is the genuine
  L² operator norm of matrices (`Matrix.Norms.L2Operator`), i.e. the C*-norm coming
  from viewing a matrix as a bounded operator on `EuclideanSpace ℂ (Fin n)`.

We then work with the explicit **2-vertex witness** (a "T2 carrier") whose Dirac
operator is the off-diagonal matrix

`Dm m = ![![0, m], ![m, 0]]`  (`m > 0` the decoration / mass scale),

and prove the headline result:

* `spectral_distance_two_point` : `spectralDist (Dm m) 0 1 = 1 / m`.

Consequences:

* `spectral_distance_recovers_edges` : the adjacent pair `0, 1` is placed at the finite,
  strictly positive distance `1 / m` — the vertex set and its distances are *recovered*
  from `(A, D)`, and the decoration scale `m` sets the units (unit mass ⇒ unit edge).
* `spectral_distance_nondegenerate` : the distance is neither `0` nor `∞` (the "Kill"
  condition of the strategy is avoided).
* `causal_order_recovers_adjacency` : the finite Malament step — the causal link relation
  read off from `D` recovers exactly the adjacency of the carrier.

All proofs are kernel-checked; the axiom footprint is verified at the bottom of the file.
-/

open scoped Matrix Matrix.Norms.L2Operator

namespace NullEdge

/-! ## Generic definitions for a finite carrier -/

/-- The commutator `[D, f] = D · diag f − diag f · D` of the Dirac operator `D` with the
diagonal multiplication operator of a function `f` on the vertex set. -/
noncomputable def diracCommutator {n : ℕ} (D : Matrix (Fin n) (Fin n) ℂ) (f : Fin n → ℂ) :
    Matrix (Fin n) (Fin n) ℂ :=
  D * Matrix.diagonal f - Matrix.diagonal f * D

/-- The unit-Lipschitz ball: functions whose Dirac commutator has operator norm `≤ 1`. -/
def lipBall {n : ℕ} (D : Matrix (Fin n) (Fin n) ℂ) : Set (Fin n → ℂ) :=
  {f | ‖diracCommutator D f‖ ≤ 1}

/-- The Connes spectral distance associated to a finite carrier with Dirac operator `D`. -/
noncomputable def spectralDist {n : ℕ} (D : Matrix (Fin n) (Fin n) ℂ) (x y : Fin n) : ℝ :=
  sSup ((fun f => ‖f x - f y‖) '' lipBall D)

/-! ## A general fact: matrix entries are bounded by the L² operator norm -/

/-- Every entry of a matrix is bounded in absolute value by its L² operator norm. -/
theorem entry_norm_le_l2_opNorm {n : Type*} [Fintype n] [DecidableEq n]
    (A : Matrix n n ℂ) (i j : n) : ‖A i j‖ ≤ ‖A‖ := by
  have hmv := Matrix.l2_opNorm_mulVec A (EuclideanSpace.single j (1 : ℂ))
  rw [EuclideanSpace.norm_single] at hmv
  simp only [norm_one, mul_one] at hmv
  refine le_trans ?_ hmv
  have h2 : (EuclideanSpace.equiv n ℂ).symm (A *ᵥ (EuclideanSpace.single j (1 : ℂ)).ofLp) i
      = A i j := by
    rw [EuclideanSpace.ofLp_single]
    simp [Matrix.mulVec_single]
  rw [← h2]
  exact PiLp.norm_apply_le _ i

/-! ## The 2-vertex witness (T2 carrier) -/

/-- The Dirac operator of the 2-vertex witness, with decoration / mass scale `m`. -/
noncomputable def Dm (m : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of ![![0, (m : ℂ)], ![(m : ℂ), 0]]

/-- The Dirac operator of the witness is self-adjoint (a valid Dirac operator). -/
theorem Dm_isSelfAdjoint (m : ℝ) : (Dm m)ᴴ = Dm m := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Dm, Matrix.conjTranspose_apply]

/-- The off-diagonal entry of the commutator on the witness: `[Dm m, f]₀₁ = m·(f 1 − f 0)`. -/
theorem diracComm_Dm_entry01 (m : ℝ) (f : Fin 2 → ℂ) :
    diracCommutator (Dm m) f 0 1 = (m : ℂ) * (f 1 - f 0) := by
  simp only [diracCommutator, Dm, Matrix.sub_apply, Matrix.mul_apply, Fin.sum_univ_two,
    Matrix.of_apply, Matrix.cons_val', Matrix.diagonal_apply]
  simp [Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-- The optimizing test function for the witness: `f = ![0, 1/m]`. -/
noncomputable def fwit (m : ℝ) : Fin 2 → ℂ := ![0, (1 / (m : ℂ))]

/-- On the witness, the commutator of the optimizing test function is the rotation matrix
`![![0, 1], ![-1, 0]]`. -/
theorem diracComm_Dm_fwit (m : ℝ) (hm : 0 < m) :
    diracCommutator (Dm m) (fwit m) = Matrix.of ![![0, 1], ![(-1), 0]] := by
  have hm0 : (m : ℂ) ≠ 0 := by exact_mod_cast ne_of_gt hm
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [diracCommutator, Dm, fwit, Matrix.mul_apply, Matrix.diagonal_apply,
      Matrix.vecMul_diagonal] <;>
    field_simp

/-- The rotation matrix `![![0, 1], ![-1, 0]]` has operator norm exactly `1`
(it is unitary). -/
theorem rotation_l2_opNorm : ‖(Matrix.of ![![(0 : ℂ), 1], ![(-1), 0]])‖ = 1 := by
  apply CStarRing.norm_of_mem_unitary
  rw [Matrix.mem_unitaryGroup_iff]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_two, Matrix.star_apply]

/-- **Upper bound.** Any unit-Lipschitz function separates the two vertices by at most
`1 / m`. -/
theorem lipBall_sep_le (m : ℝ) (hm : 0 < m) {f : Fin 2 → ℂ} (hf : f ∈ lipBall (Dm m)) :
    ‖f 0 - f 1‖ ≤ 1 / m := by
  have hentry : ‖diracCommutator (Dm m) f 0 1‖ ≤ 1 :=
    le_trans (entry_norm_le_l2_opNorm _ 0 1) hf
  rw [diracComm_Dm_entry01] at hentry
  have hnorm : m * ‖f 1 - f 0‖ ≤ 1 := by
    have : ‖(m : ℂ) * (f 1 - f 0)‖ = m * ‖f 1 - f 0‖ := by
      rw [norm_mul, Complex.norm_real, Real.norm_of_nonneg hm.le]
    rwa [this] at hentry
  rw [norm_sub_rev]
  rw [le_div_iff₀ hm, mul_comm]
  exact hnorm

/-- **Attainment.** The optimizing test function lies in the unit-Lipschitz ball and
separates the two vertices by exactly `1 / m`. -/
theorem fwit_mem_lipBall (m : ℝ) (hm : 0 < m) : fwit m ∈ lipBall (Dm m) := by
  show ‖diracCommutator (Dm m) (fwit m)‖ ≤ 1
  rw [diracComm_Dm_fwit m hm, rotation_l2_opNorm]

theorem fwit_sep (m : ℝ) (hm : 0 < m) : ‖fwit m 0 - fwit m 1‖ = 1 / m := by
  simp only [fwit, Matrix.cons_val_zero, Matrix.cons_val_one, zero_sub,
    norm_neg, norm_div, norm_one]
  rw [Complex.norm_real]
  simp [abs_of_pos hm]

/-! ## The prize: the spectral distance recovers the metric of the carrier -/

/-- **Main computation.** The Connes spectral distance between the two vertices of the
witness equals `1 / m`, where `m` is the decoration / mass scale. -/
theorem spectral_distance_two_point (m : ℝ) (hm : 0 < m) :
    spectralDist (Dm m) 0 1 = 1 / m := by
  have hg : IsGreatest ((fun f => ‖f 0 - f 1‖) '' lipBall (Dm m)) (1 / m) := by
    constructor
    · exact ⟨fwit m, fwit_mem_lipBall m hm, fwit_sep m hm⟩
    · rintro z ⟨f, hf, rfl⟩
      exact lipBall_sep_le m hm hf
  simpa [spectralDist] using hg.csSup_eq

/-- **Edge recovery (the prize).** The two adjacent vertices are placed at the finite,
strictly positive spectral distance `1 / m`; the decoration scale `m` fixes the units, so
that a unit mass scale (`m = 1`) recovers exactly a unit edge. The vertex set and its
distances are therefore *recovered* from `(A, D)`, not assumed as background. -/
theorem spectral_distance_recovers_edges (m : ℝ) (hm : 0 < m) :
    spectralDist (Dm m) 0 1 = 1 / m ∧ spectralDist (Dm 1) 0 1 = 1 := by
  refine ⟨spectral_distance_two_point m hm, ?_⟩
  simpa using spectral_distance_two_point 1 (by norm_num)

/-- **Non-degeneracy (Kill condition avoided).** The spectral distance on the witness is
neither `0` nor infinite: it is a strictly positive real number. -/
theorem spectral_distance_nondegenerate (m : ℝ) (hm : 0 < m) :
    0 < spectralDist (Dm m) 0 1 := by
  rw [spectral_distance_two_point m hm]
  positivity

/-! ## Finite Malament step: causal order recovery -/

/-- The causal-link relation read off directly from the Dirac operator: two vertices are
linked when they coincide or when `D` propagates between them (`D x y ≠ 0`). For a genuine
Lorentzian (Krein) carrier the sign of the Krein form would orient this relation into a
causal *order*; the Riemannian witness below carries no time arrow, so the relation is the
symmetric adjacency relation. -/
def CausallyLinked {n : ℕ} (D : Matrix (Fin n) (Fin n) ℂ) (x y : Fin n) : Prop :=
  x = y ∨ D x y ≠ 0

/-- **Finite Malament step (witness).** On the 2-vertex carrier the causal-link relation
recovered from `D` relates every pair of vertices: it reproduces exactly the adjacency of
the complete 2-vertex graph, so the causal/topological data is recovered from `(A, D)`. -/
theorem causal_order_recovers_adjacency (m : ℝ) (hm : 0 < m) (x y : Fin 2) :
    CausallyLinked (Dm m) x y := by
  fin_cases x <;> fin_cases y <;>
    first
      | (left; rfl)
      | (right; simp [Dm]; exact hm.ne')

end NullEdge

-- Axiom footprint guard.
#print axioms NullEdge.spectral_distance_recovers_edges
#print axioms NullEdge.spectral_distance_two_point
#print axioms NullEdge.spectral_distance_nondegenerate
#print axioms NullEdge.causal_order_recovers_adjacency
