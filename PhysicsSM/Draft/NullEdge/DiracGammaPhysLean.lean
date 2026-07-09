import Mathlib

/-!
# Dirac gamma algebra grounded in PhysLean's convention

Clean-room port grounding the Dirac gamma matrices in the PhysLean convention
(github HEPLean/PhysLean, `spaceTime.gamma`, the Dirac representation).  This is a
reference/provenance port, NOT an import: PhysLean is pinned off our v4.28.0 toolchain.

We reproduce PhysLean's explicit Dirac-representation gamma matrices as complex `4×4`
constant matrices and verify that they satisfy the Clifford algebra
`{γ^μ, γ^ν} = 2 η^{μν} · I` with the mostly-minus metric `η = diag(1,-1,-1,-1)`,
i.e. signature `(+,-,-,-)`.

Everything is explicit-constant complex (entries in `{0, ±1, ±I}`); proofs go by
`ext`/`fin_cases` + `Matrix.mul_apply` + `Fin.sum_univ_four` + `simp`/`norm_num`
together with `Complex.I_sq`.  No symbolic complex analysis, no real transcendentals.
-/

open scoped BigOperators
open scoped Classical

namespace DiracGammaPhysLean

set_option maxHeartbeats 4000000

/-- Dirac-representation gamma matrix `γ^0` (PhysLean `spaceTime.gamma 0`). -/
def g0 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- Dirac-representation gamma matrix `γ^1` (PhysLean `spaceTime.gamma 1`). -/
def g1 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,0,1; 0,0,1,0; 0,-1,0,0; -1,0,0,0]

/-- Dirac-representation gamma matrix `γ^2` (PhysLean `spaceTime.gamma 2`). -/
def g2 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,0,-Complex.I; 0,0,Complex.I,0; 0,Complex.I,0,0; -Complex.I,0,0,0]

/-- Dirac-representation gamma matrix `γ^3` (PhysLean `spaceTime.gamma 3`). -/
def g3 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,1,0; 0,0,0,-1; -1,0,0,0; 0,1,0,0]

/-- The four gamma matrices indexed by `Fin 4`. -/
def gamma : Fin 4 → Matrix (Fin 4) (Fin 4) ℂ
  | 0 => g0
  | 1 => g1
  | 2 => g2
  | 3 => g3

/-- The mostly-minus Minkowski metric `η = diag(1,-1,-1,-1)` as a complex-valued
diagonal form, signature `(+,-,-,-)`. -/
def eta : Fin 4 → Fin 4 → ℂ
  | 0, 0 => 1
  | 1, 1 => -1
  | 2, 2 => -1
  | 3, 3 => -1
  | _, _ => 0

/-! ## Diagonal Clifford relations `(γ^μ)^2 = η^{μμ} · I` -/

/-- `(γ^0)^2 = I`. -/
theorem gamma_sq_0 : g0 * g0 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g0, Matrix.mul_apply, Fin.sum_univ_four]

/-- `(γ^1)^2 = -I`. -/
theorem gamma_sq_1 : g1 * g1 = -1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g1, Matrix.mul_apply, Fin.sum_univ_four]

/-- `(γ^2)^2 = -I`. -/
theorem gamma_sq_2 : g2 * g2 = -1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g2, Matrix.mul_apply, Fin.sum_univ_four]

/-- `(γ^3)^2 = -I`. -/
theorem gamma_sq_3 : g3 * g3 = -1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g3, Matrix.mul_apply, Fin.sum_univ_four]

/-! ## Off-diagonal Clifford anticommutation `γ^μ γ^ν = - γ^ν γ^μ` (μ ≠ ν) -/

theorem gamma_anticomm_01 : g0 * g1 = -(g1 * g0) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g0, g1, Matrix.mul_apply, Fin.sum_univ_four]

theorem gamma_anticomm_02 : g0 * g2 = -(g2 * g0) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g0, g2, Matrix.mul_apply, Fin.sum_univ_four]

theorem gamma_anticomm_03 : g0 * g3 = -(g3 * g0) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g0, g3, Matrix.mul_apply, Fin.sum_univ_four]

theorem gamma_anticomm_12 : g1 * g2 = -(g2 * g1) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g1, g2, Matrix.mul_apply, Fin.sum_univ_four]

theorem gamma_anticomm_13 : g1 * g3 = -(g3 * g1) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g1, g3, Matrix.mul_apply, Fin.sum_univ_four]

theorem gamma_anticomm_23 : g2 * g3 = -(g3 * g2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [g2, g3, Matrix.mul_apply, Fin.sum_univ_four]

/-! ## The packaged Clifford relation `{γ^μ, γ^ν} = 2 η^{μν} · I` -/

/-- The full Clifford algebra of the mostly-minus metric:
`γ^μ γ^ν + γ^ν γ^μ = (2 · η^{μν}) • I` for all `μ, ν ∈ Fin 4`. -/
theorem clifford_relation (μ ν : Fin 4) :
    gamma μ * gamma ν + gamma ν * gamma μ =
      (2 * eta μ ν) • (1 : Matrix (Fin 4) (Fin 4) ℂ) := by
  fin_cases μ <;> fin_cases ν <;>
    simp only [gamma, eta] <;>
    first
      | (rw [gamma_sq_0]; module)
      | (rw [gamma_sq_1]; module)
      | (rw [gamma_sq_2]; module)
      | (rw [gamma_sq_3]; module)
      | (simp only [mul_zero, zero_smul];
          first
            | (rw [gamma_anticomm_01]; abel)
            | (rw [gamma_anticomm_02]; abel)
            | (rw [gamma_anticomm_03]; abel)
            | (rw [gamma_anticomm_12]; abel)
            | (rw [gamma_anticomm_13]; abel)
            | (rw [gamma_anticomm_23]; abel))

/-! ## Non-degeneracy witnesses -/

/-- The gammas are genuinely nonzero and distinct, and the metric is genuinely
indefinite (so the Clifford relation is not the trivial Euclidean/all-`+1` case). -/
theorem nondegeneracy :
    g0 0 0 = 1 ∧ g2 0 3 = -Complex.I ∧ (-Complex.I : ℂ) ≠ 0 ∧ g0 ≠ g3 ∧
      eta 0 0 = 1 ∧ eta 1 1 = -1 ∧ (eta 0 0 : ℂ) ≠ eta 1 1 := by
  refine ⟨by simp [g0], by simp [g2], by simp [Complex.ext_iff], ?_, by simp [eta],
    by simp [eta], by norm_num [eta]⟩
  intro h
  have : g0 0 0 = g3 0 0 := by rw [h]
  simp [g0, g3] at this

/-! ## Verdict -/

/-- **Verdict.** The PhysLean Dirac-representation gamma matrices satisfy the Clifford
algebra of the mostly-minus metric `(+,-,-,-)`:
`(γ^0)^2 = I`, `(γ^i)^2 = -I` for `i ∈ {1,2,3}`, distinct gammas anticommute, and the
packaged relation `{γ^μ,γ^ν} = 2 η^{μν} I` holds for all `μ, ν`; moreover the setup is
non-degenerate (gammas nonzero/distinct, `η` indefinite).

Honest scope: this is the finite Clifford *algebra* (anticommutation) only — not the
Lorentz covariance, the spinor representation, or the mass term.
Provenance: PhysLean `spaceTime.gamma` (Dirac representation), clean-room port. -/
theorem dirac_gamma_verdict :
    (g0 * g0 = 1) ∧
    (g1 * g1 = -1) ∧ (g2 * g2 = -1) ∧ (g3 * g3 = -1) ∧
    (g0 * g1 = -(g1 * g0)) ∧ (g0 * g2 = -(g2 * g0)) ∧ (g0 * g3 = -(g3 * g0)) ∧
    (g1 * g2 = -(g2 * g1)) ∧ (g1 * g3 = -(g3 * g1)) ∧ (g2 * g3 = -(g3 * g2)) ∧
    (∀ μ ν : Fin 4, gamma μ * gamma ν + gamma ν * gamma μ =
      (2 * eta μ ν) • (1 : Matrix (Fin 4) (Fin 4) ℂ)) ∧
    (g0 0 0 = 1 ∧ eta 0 0 = 1 ∧ eta 1 1 = -1) :=
  ⟨gamma_sq_0, gamma_sq_1, gamma_sq_2, gamma_sq_3,
   gamma_anticomm_01, gamma_anticomm_02, gamma_anticomm_03,
   gamma_anticomm_12, gamma_anticomm_13, gamma_anticomm_23,
   clifford_relation, ⟨by simp [g0], by simp [eta], by simp [eta]⟩⟩

/-! ## Axiom footprint checks -/

/-- info: 'DiracGammaPhysLean.clifford_relation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms clifford_relation

/-- info: 'DiracGammaPhysLean.nondegeneracy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegeneracy

/-- info: 'DiracGammaPhysLean.dirac_gamma_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms dirac_gamma_verdict

end DiracGammaPhysLean
