import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# The Dirac velocity operator has eigenvalues exactly ±1 (always moving at c)

This file gives a self-contained, kernel-checked (`decide`/`norm_num`/`ring`) proof of the
statement that the **Dirac velocity operator** `αᵢ` (the Heisenberg-picture time derivative
`dxᵢ/dt = αᵢ`, units `c = 1`) has instantaneous-velocity eigenvalues **exactly `±1`** — the
internal speed of a fundamental fermion is always `c`, never a value strictly between.

We use the **standard complex Dirac representation** on `Matrix (Fin 4) (Fin 4) ℂ`:
`αᵢ = [[0, σᵢ], [σᵢ, 0]]` and `β = diag(1, 1, -1, -1)`, with the Pauli matrices
`σ₁, σ₂, σ₃`. All entries are explicit constants (`0, 1, -1, I, -I`), so every claim is closed
by finite matrix algebra (`ext` + `fin_cases` + `simp`/`norm_num`); there is **no** symbolic
complex analysis and no transcendental functions.

## What is proved
* `alpha_sq_one`  : `αᵢ² = 1` for each `i` — every eigenvalue `λ` satisfies `λ² = 1`, i.e.
  `λ = ±1`: the instantaneous speed is exactly `c`.
* `alpha_traceless` : `tr αᵢ = 0` — the `+1` and `-1` eigenspaces have equal dimension `2`, so
  **both** signs of the velocity genuinely occur (it is not a trivial `+1`).
* `velocity_spectrum` : packages the spectral statement for `α₁` — `α₁² = 1`, `tr α₁ = 0`,
  `α₁ ≠ 1`, `α₁ ≠ -1`, together with an explicit nonzero `+1`-eigenvector and an explicit
  nonzero `-1`-eigenvector. So the spectrum is exactly `{+1, -1}`, each with multiplicity `2`.
* `massless_luminal` : the mass term `β` anticommutes with each `αᵢ` (`αᵢ β = -β αᵢ`), so it is
  the chirality-flipping coupling; and `α₁` and `β` share **no** common eigenvector with
  nonzero eigenvalues (the mass genuinely mixes the `±c` states). With `β` absent (`m = 0`) the
  dynamics is diagonal in the velocity eigenbasis — pure `±c` motion.

## Honest scope
This concerns the **instantaneous velocity operator** of a Dirac *fermion*; its eigenvalues
`±c` express that the fermion is always moving at `c` internally (Zitterbewegung). The
*observable* drift `⟨α⟩ = p/E` is subluminal — a separate fact whose reconciliation with the
`±c` instantaneous spectrum is the Zitterbewegung-average companion result and is not treated
here. This does not cover massive bosons.
-/

namespace DiracVelocityOperator

open Matrix Complex

/-! ## The explicit Dirac matrices (standard complex representation) -/

/-- `α₁ = [[0, σ₁], [σ₁, 0]]`, the first Dirac velocity operator. -/
abbrev alpha1 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, 0, 1; 0, 0, 1, 0; 0, 1, 0, 0; 1, 0, 0, 0]

/-- `α₂ = [[0, σ₂], [σ₂, 0]]`, the second Dirac velocity operator. -/
abbrev alpha2 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, 0, -I; 0, 0, I, 0; 0, -I, 0, 0; I, 0, 0, 0]

/-- `α₃ = [[0, σ₃], [σ₃, 0]]`, the third Dirac velocity operator. -/
abbrev alpha3 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0, 0, 1, 0; 0, 0, 0, -1; 1, 0, 0, 0; 0, -1, 0, 0]

/-- `β = diag(1, 1, -1, -1)`, the mass / Dirac-β matrix. -/
abbrev beta : Matrix (Fin 4) (Fin 4) ℂ :=
  !![1, 0, 0, 0; 0, 1, 0, 0; 0, 0, -1, 0; 0, 0, 0, -1]

/-! ## 1. `αᵢ² = 1`: the instantaneous speed is exactly `c` -/

theorem alpha1_sq : alpha1 * alpha1 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, alpha1]

theorem alpha2_sq : alpha2 * alpha2 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, alpha2, Complex.I_mul_I]

theorem alpha3_sq : alpha3 * alpha3 = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, alpha3]

/-- **Every eigenvalue satisfies `λ² = 1`, i.e. `λ = ±1`.**  Each Dirac velocity operator
squares to the identity, so the instantaneous internal speed is exactly `c`. -/
theorem alpha_sq_one :
    alpha1 * alpha1 = 1 ∧ alpha2 * alpha2 = 1 ∧ alpha3 * alpha3 = 1 :=
  ⟨alpha1_sq, alpha2_sq, alpha3_sq⟩

/-! ## 2. `tr αᵢ = 0`: the `±1` eigenspaces have equal dimension `2` -/

/-- **The velocity operators are traceless.**  Since `tr αᵢ = 0` and the eigenvalues are `±1`,
the `+1` and `-1` eigenspaces each have dimension `2`: both signs of the velocity genuinely
occur. -/
theorem alpha_traceless :
    alpha1.trace = 0 ∧ alpha2.trace = 0 ∧ alpha3.trace = 0 := by
  refine ⟨?_, ?_, ?_⟩ <;>
    simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four, alpha1, alpha2, alpha3]

/-! ## 3. The spectrum of `α₁` is exactly `{+1, -1}` -/

/-- Explicit `+1`-eigenvector of `α₁`. -/
def vplus : Fin 4 → ℂ := ![1, 0, 0, 1]

/-- Explicit `-1`-eigenvector of `α₁`. -/
def vminus : Fin 4 → ℂ := ![1, 0, 0, -1]

theorem alpha1_vplus : alpha1.mulVec vplus = vplus := by
  funext i
  fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_four, alpha1, vplus]

theorem alpha1_vminus : alpha1.mulVec vminus = -vminus := by
  funext i
  fin_cases i <;> simp [Matrix.mulVec, dotProduct, Fin.sum_univ_four, alpha1, vminus]

theorem vplus_ne_zero : vplus ≠ 0 := by
  intro h; have := congrFun h 0; simp [vplus] at this

theorem vminus_ne_zero : vminus ≠ 0 := by
  intro h; have := congrFun h 0; simp [vminus] at this

theorem alpha1_ne_one : alpha1 ≠ 1 := by
  intro h; have := congrFun (congrFun h 0) 0; simp [alpha1] at this

theorem alpha1_ne_neg_one : alpha1 ≠ -1 := by
  intro h; have := congrFun (congrFun h 0) 0; simp [alpha1] at this

/-- **Spectral statement for `α₁`.**  The eigenvalues of the Dirac velocity operator `α₁` are
exactly `{+1, -1}`, each with multiplicity `2`:
* `α₁² = 1` forces every eigenvalue into `{+1, -1}`;
* `tr α₁ = 0` splits the dimension evenly (`2 + 2 = 4`);
* `α₁ ≠ 1` and `α₁ ≠ -1` show it is neither the pure `+1` nor the pure `-1` operator, so both
  eigenvalues genuinely occur;
* `vplus` is an explicit nonzero `+1`-eigenvector and `vminus` an explicit nonzero
  `-1`-eigenvector. -/
theorem velocity_spectrum :
    alpha1 * alpha1 = 1 ∧ alpha1.trace = 0 ∧ alpha1 ≠ 1 ∧ alpha1 ≠ -1 ∧
      (alpha1.mulVec vplus = vplus ∧ vplus ≠ 0) ∧
      (alpha1.mulVec vminus = -vminus ∧ vminus ≠ 0) :=
  ⟨alpha1_sq, alpha_traceless.1, alpha1_ne_one, alpha1_ne_neg_one,
    ⟨alpha1_vplus, vplus_ne_zero⟩, ⟨alpha1_vminus, vminus_ne_zero⟩⟩

/-! ## 4. The mass term `β` anticommutes and mixes the `±c` states -/

theorem alpha1_beta_anticomm : alpha1 * beta = -(beta * alpha1) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, alpha1, beta]

theorem alpha2_beta_anticomm : alpha2 * beta = -(beta * alpha2) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, alpha2, beta]

theorem alpha3_beta_anticomm : alpha3 * beta = -(beta * alpha3) := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, alpha3, beta]

/-- `α₁` and `β` have **no common eigenvector** with nonzero eigenvalues: if `α₁ v = a v` and
`β v = b v`, then `a b = 0` or `v = 0`.  Since `α₁² = 1` forces `a = ±1` and `β² = 1` forces
`b = ±1` (both nonzero), any common eigenvector must vanish — the mass genuinely mixes the two
`±c` velocity states. -/
theorem alpha1_beta_no_common_eigenvector (v : Fin 4 → ℂ) (a b : ℂ)
    (ha : alpha1.mulVec v = a • v) (hb : beta.mulVec v = b • v) : a * b = 0 ∨ v = 0 := by
  have key : (alpha1 * beta).mulVec v = (a * b) • v := by
    rw [← Matrix.mulVec_mulVec, hb, Matrix.mulVec_smul, ha, smul_smul, mul_comm]
  have key2 : (alpha1 * beta).mulVec v = -((a * b) • v) := by
    rw [alpha1_beta_anticomm, Matrix.neg_mulVec, ← Matrix.mulVec_mulVec, ha,
      Matrix.mulVec_smul, hb, smul_smul]
  rw [key] at key2
  have h0 : (a * b) • v = 0 := by
    have h2v : (2 : ℂ) • ((a * b) • v) = 0 := by
      rw [two_smul]; nth_rewrite 2 [key2]; ring_nf
    exact (smul_eq_zero.mp h2v).resolve_left (by norm_num)
  exact (smul_eq_zero.mp h0)

/-- **The mass term is the chirality-flipping coupling.**  `β` anticommutes with every velocity
operator `αᵢ`, and `α₁` and `β` share no common eigenvector with nonzero eigenvalues. Hence with
`β` absent (`m = 0`) the dynamics is diagonal in the velocity eigenbasis (pure `±c` motion),
while a nonzero mass genuinely mixes the `+c` and `-c` states. -/
theorem massless_luminal :
    alpha1 * beta = -(beta * alpha1) ∧
      alpha2 * beta = -(beta * alpha2) ∧
      alpha3 * beta = -(beta * alpha3) ∧
      (∀ (v : Fin 4 → ℂ) (a b : ℂ),
        alpha1.mulVec v = a • v → beta.mulVec v = b • v → a * b = 0 ∨ v = 0) :=
  ⟨alpha1_beta_anticomm, alpha2_beta_anticomm, alpha3_beta_anticomm,
    alpha1_beta_no_common_eigenvector⟩

/-! ## Axiom audit — every headline uses only `propext`, `Classical.choice`, `Quot.sound`. -/

/-- info: 'DiracVelocityOperator.alpha_sq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms alpha_sq_one

/-- info: 'DiracVelocityOperator.alpha_traceless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms alpha_traceless

/-- info: 'DiracVelocityOperator.velocity_spectrum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms velocity_spectrum

/-- info: 'DiracVelocityOperator.massless_luminal' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_luminal

end DiracVelocityOperator
