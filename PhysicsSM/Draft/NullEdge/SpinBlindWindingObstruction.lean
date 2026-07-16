import Mathlib

/-!
# Spin-blind Floquet winding obstruction (pointwise algebraic core)

This file is a self-contained, Mathlib-only formalization of the **exact
algebraic core** of the spin-blind winding obstruction for the Null-Edge `3+1`
fork, following `HNU_SINGLE_WEYL_RECONSTRUCTION.md` (§5, §7, ladder item L9).

## What is proved here

The standard three-dimensional winding density of a momentum-space unitary
`U : T^3 -> U(N)`
is built from the logarithmic derivatives `R_j(k) := U(k)ᴴ ∂_{k_j} U(k)` via the
integrand
`Σ_{i,j,k} ε^{ijk} Tr[ R_i R_j R_k ] = Tr[ antisymCubic R ]`,
the fully antisymmetrized cubic trace density.

For scalar logarithmic derivatives `R_j = (-i m_j) • 1`, as produced by a
spin-blind schedule `U(k) = exp(-i k*m) W_0`, we prove that the
antisymmetrized cubic matrix expression vanishes identically, and therefore so
does its trace, for every finite matrix dimension. This is the pointwise
winding-integrand obstruction.

To show the obstruction is genuinely about *spin-blind commutativity* and not a
vacuous definition, we exhibit a **noncommuting** `2 × 2` control (the Pauli
matrices) whose antisymmetrized cubic trace is `12 i ≠ 0`.

## Scope (honest)

This is a **pointwise, purely algebraic** statement. The Lean theorem assumes
the scalar logarithmic-derivative form; it does not derive that form from a
unitary family. We do **not** formalize a
global winding *integral*, a degree map, or the geometry of `𝕋³`; and we do not
claim `W = 1` for the full HNU model. The result is a *scoped* no-go for the
spin-blind alphabet `{ unconditional (spin-blind) null shift, on-site turn }`,
i.e. exactly the `U(k) = exp(-i k·m) W₀` family. It says nothing against
*projector-conditioned* shifts, which are what carry the nonzero winding in the
HNU construction (see §7 of the reconstruction). No new assumptions are used and
no trusted-compiler evaluation (`n a t i v e _ d e c i d e` /
`Lean.ofReduceBool`) appears;
`#print axioms` guards below enforce a clean kernel dependency set.
-/

namespace PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction

open scoped Matrix
open Matrix Complex

/-- Complex `n × n` matrices. -/
abbrev Mat (n : ℕ) := Matrix (Fin n) (Fin n) ℂ

/-- The fully antisymmetrized cubic expression over the six permutations of the
three indices, with Levi-Civita signs `+, -, -, +, +, -`:

`antisymCubic R = R₀R₁R₂ - R₀R₂R₁ - R₁R₀R₂ + R₁R₂R₀ + R₂R₀R₁ - R₂R₁R₀`.

Its trace is the winding integrand `Σ_{i,j,k} ε^{ijk} Tr[R_i R_j R_k]`. -/
noncomputable def antisymCubic {n : ℕ} (R : Fin 3 → Mat n) : Mat n :=
  R 0 * R 1 * R 2 - R 0 * R 2 * R 1 - R 1 * R 0 * R 2
    + R 1 * R 2 * R 0 + R 2 * R 0 * R 1 - R 2 * R 1 * R 0

/-! ## 1. Scalar matrices commute -/

/-- Scalar matrices `c • 1` commute (the algebraic heart of the spin-blind
obstruction: an unconditional schedule produces only commuting scalar
generators). -/
theorem scalar_matrix_comm {n : ℕ} (c d : ℂ) :
    (c • (1 : Mat n)) * (d • (1 : Mat n)) = (d • (1 : Mat n)) * (c • (1 : Mat n)) := by
  rw [smul_mul_smul_comm, smul_mul_smul_comm, one_mul, mul_comm]

/-- A product of scalar matrices is the scalar matrix of the product. -/
theorem scalar_matrix_mul {n : ℕ} (c d : ℂ) :
    (c • (1 : Mat n)) * (d • (1 : Mat n)) = (c * d) • (1 : Mat n) := by
  rw [smul_mul_smul_comm, one_mul]

/-! ## 2. The antisymmetrized cubic vanishes for scalar coefficients -/

/-- **Pointwise obstruction (matrix form).** For arbitrary scalar coefficients
`c : Fin 3 → ℂ`, the antisymmetrized cubic of the scalar matrices `c j • 1`
vanishes identically, in every finite dimension `n`. -/
theorem antisymCubic_scalar {n : ℕ} (c : Fin 3 → ℂ) :
    antisymCubic (fun j => c j • (1 : Mat n)) = 0 := by
  simp only [antisymCubic, smul_mul_smul_comm, mul_one]
  module

/-! ## 3. Trace vanishes in every finite dimension -/

/-- **Pointwise obstruction (trace form).** The winding integrand
`Σ_{i,j,k} ε^{ijk} Tr[R_i R_j R_k]` vanishes for scalar `R_j = c_j • 1`, in
every finite matrix dimension. -/
theorem trace_antisymCubic_scalar {n : ℕ} (c : Fin 3 → ℂ) :
    (antisymCubic (fun j => c j • (1 : Mat n))).trace = 0 := by
  rw [antisymCubic_scalar]; simp

/-! ## 4. Specialization to the spin-blind displacement data `c_j = -i m_j`

For `U(k) = exp(-i k·m) W₀` the logarithmic derivative is
`R_j = U(k)ᴴ ∂_{k_j} U(k) = (-i m_j) • 1`. We record the vanishing of the
winding integrand for both real and integer displacement data `m`. -/

/-- Spin-blind obstruction for **real** displacement data `m : Fin 3 → ℝ`. -/
theorem trace_antisymCubic_spinBlind_real {n : ℕ} (m : Fin 3 → ℝ) :
    (antisymCubic (fun j => (-Complex.I * (m j : ℂ)) • (1 : Mat n))).trace = 0 :=
  trace_antisymCubic_scalar _

/-- Spin-blind obstruction for **integer** displacement data `m : Fin 3 → ℤ`
(the physical `m ∈ ℤ³` null shift). -/
theorem trace_antisymCubic_spinBlind_int {n : ℕ} (m : Fin 3 → ℤ) :
    (antisymCubic (fun j => (-Complex.I * (m j : ℂ)) • (1 : Mat n))).trace = 0 :=
  trace_antisymCubic_scalar _

/-- The matrix expression itself vanishes for integer displacement data. -/
theorem antisymCubic_spinBlind_int {n : ℕ} (m : Fin 3 → ℤ) :
    antisymCubic (fun j => (-Complex.I * (m j : ℂ)) • (1 : Mat n)) = 0 :=
  antisymCubic_scalar _

/-! ## 5. Noncommuting nonzero Pauli witness

To show the obstruction is about spin-blind *commutativity* and not a vacuous
definition, we take the three Pauli matrices as a noncommuting control and
compute a **nonzero** antisymmetrized cubic trace `12 i`. -/

/-- The three Pauli matrices `σ₁, σ₂, σ₃` as a `Fin 3`-indexed control. -/
def pauli : Fin 3 → Mat 2
  | 0 => !![0, 1; 1, 0]
  | 1 => !![0, -Complex.I; Complex.I, 0]
  | 2 => !![1, 0; 0, -1]

/-- The Pauli control is genuinely **noncommuting**: `σ₁ σ₂ ≠ σ₂ σ₁`. -/
theorem pauli_not_comm : pauli 0 * pauli 1 ≠ pauli 1 * pauli 0 := by
  intro h
  have := congrFun (congrFun h 0) 0
  simp only [pauli, Matrix.mul_fin_two] at this
  norm_num [Complex.ext_iff] at this

/-- Each Pauli generator is **nonzero**. -/
theorem pauli_ne_zero (j : Fin 3) : pauli j ≠ 0 := by
  fin_cases j
  · intro h; have := congrFun (congrFun h 0) 1; simp [pauli] at this
  · intro h; have := congrFun (congrFun h 0) 1; simp [pauli] at this
  · intro h; have := congrFun (congrFun h 0) 0; simp [pauli] at this

/-- **Nonzero control.** For the noncommuting Pauli control the antisymmetrized
cubic trace equals `12 i`. -/
theorem trace_antisymCubic_pauli : (antisymCubic pauli).trace = 12 * Complex.I := by
  simp only [antisymCubic, pauli]
  rw [Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two,
      Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two,
      Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two, Matrix.mul_fin_two]
  simp only [Matrix.trace_fin_two]
  simp [Matrix.sub_apply]
  ring

/-- **Nonvacuity.** The winding integrand does not vanish for the noncommuting
Pauli control: the obstruction genuinely requires spin-blind commutativity. -/
theorem trace_antisymCubic_pauli_ne_zero : (antisymCubic pauli).trace ≠ 0 := by
  rw [trace_antisymCubic_pauli]
  simp [Complex.ext_iff]

/-! ## Kernel-cleanliness guards (build-enforced)

Each `#guard_msgs` block fails the build if the axiom dependency set changes,
enforcing that only the standard `propext, Classical.choice, Quot.sound` axioms
are used (no `s o r r y`, no `Lean.ofReduceBool` / trusted-compiler evaluation). -/

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.antisymCubic_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms antisymCubic_scalar

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_scalar

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_spinBlind_int' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_spinBlind_int

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_pauli' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_pauli

/-- info: 'PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction.trace_antisymCubic_pauli_ne_zero' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms trace_antisymCubic_pauli_ne_zero

end PhysicsSM.Draft.NullEdge.SpinBlindWindingObstruction
