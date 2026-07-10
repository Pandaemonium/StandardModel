import Mathlib

/-!
# Finite kernel lemmas for the continuum limit of the Dirac quantum walk

This file records the *finite, kernel-provable* content on the way to the
continuum (Dirac PDE) limit of the carrier's transfer step, for the simplest
`1+1D` channel (a two-component / `Cl(1,1)` coin).  These are the exact matrix
identities that underlie the standard 1D Dirac-quantum-walk continuum limit
(the Feynman-checkerboard limit of Gersch and of Jacobson–Schulman, imported
as `[import]`).  The continuum theorem itself (strong/Trotter–Kato convergence
of the propagators) is *not* a finite statement and lives outside the kernel
program; here we prove only the finite symbol facts that any such limit must
match.

## The one-step walk symbol

Working in momentum space with lattice spacing `a = 1` (absorbed into `k`) and
mass angle `θ = m·dt`, one step of the 1D Dirac quantum walk is the product of
a spin-dependent shift and a mass coin:

* `Ushift k = exp (-i k σ_z) = diag (e^{-ik}, e^{ik})`
* `Ucoin θ  = exp (-i θ σ_x) = cos θ · I - i sin θ · σ_x`
* `Ustep k θ = Ushift k * Ucoin θ`.

## Finite results proved here

* `Ustep_trace` : `tr (Ustep k θ) = 2 cos k cos θ`.
* `Ustep_det`   : `det (Ustep k θ) = 1`  (so `Ustep k θ ∈ SU(2)`).

  Together these give the **exact lattice dispersion relation**
  `cos ω(k) = cos k · cos θ`, with eigenvalues `e^{∓ i ω(k)}`.

* `Ushift_eq_exp` : the shift entries are the genuine exponentials `e^{∓ik}`.
  At `θ = 0` (massless) this makes the dispersion `ω(k) = k` **exact**, i.e.
  the massless walk propagates on the light cone with group velocity `dω/dk = 1`.

* `sigmax_sq`, `sigmaz_sq`, `sigma_anticomm` : the coin **Clifford relations**
  `σ_x² = σ_z² = 1`, `σ_z σ_x + σ_x σ_z = 0`.

* `dirac_mass_shell` : `(k • σ_z + m • σ_x)² = (k² + m²) • 1`, the finite content
  of the relativistic **mass shell** `E² = k² + m²`; as `m → 0` this gives
  `E = |k|`, group velocity `±1`.

* `Ustep_hasDerivAt_generator` : the **leading-order symbol match** — the one-step
  family `ε ↦ Ushift (kε) * Ucoin (mε)` has derivative `-i (k σ_z + m σ_x)` at
  `ε = 0`, i.e. `Ustep = 1 - i ε (k σ_z + m σ_x) + O(ε²)`, matching the Dirac
  Hamiltonian symbol `H(k) = k σ_z + m σ_x` to first order.
-/

open Matrix Complex

namespace ContinuumLimit

/-- Pauli `σ_x`. -/
noncomputable def σx : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

/-- Pauli `σ_z`. -/
noncomputable def σz : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- Spin-dependent shift `exp (-i k σ_z) = diag (e^{-ik}, e^{ik})`. -/
noncomputable def Ushift (k : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(Real.cos k : ℂ) - I * Real.sin k, 0; 0, (Real.cos k : ℂ) + I * Real.sin k]

/-- Mass coin `exp (-i θ σ_x) = cos θ · I - i sin θ · σ_x`. -/
noncomputable def Ucoin (θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![(Real.cos θ : ℂ), -I * Real.sin θ; -I * Real.sin θ, (Real.cos θ : ℂ)]

/-- One step of the 1D Dirac quantum walk in momentum space. -/
noncomputable def Ustep (k θ : ℝ) : Matrix (Fin 2) (Fin 2) ℂ := Ushift k * Ucoin θ

/-- **Dispersion (trace part).** `tr (Ustep k θ) = 2 cos k cos θ`.  With
`det (Ustep k θ) = 1` this yields `cos ω(k) = cos k cos θ`. -/
theorem Ustep_trace (k θ : ℝ) :
    (Ustep k θ).trace = 2 * (Real.cos k : ℂ) * (Real.cos θ) := by
  simp only [Ustep, Ushift, Ucoin, Matrix.trace_fin_two, Matrix.mul_fin_two, Matrix.of_apply,
    Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.empty_val', Matrix.cons_val_fin_one]
  ring

/-- `det (Ushift k) = 1`. -/
theorem Ushift_det (k : ℝ) : (Ushift k).det = 1 := by
  have hk : (Real.sin k : ℂ) ^ 2 + (Real.cos k : ℂ) ^ 2 = 1 := by
    exact_mod_cast Real.sin_sq_add_cos_sq k
  simp only [Ushift, Matrix.det_fin_two_of]
  linear_combination hk - (Real.sin k : ℂ) ^ 2 * Complex.I_sq

/-- `det (Ucoin θ) = 1`. -/
theorem Ucoin_det (θ : ℝ) : (Ucoin θ).det = 1 := by
  have hθ : (Real.sin θ : ℂ) ^ 2 + (Real.cos θ : ℂ) ^ 2 = 1 := by
    exact_mod_cast Real.sin_sq_add_cos_sq θ
  simp only [Ucoin, Matrix.det_fin_two_of]
  linear_combination hθ - (Real.sin θ : ℂ) ^ 2 * Complex.I_sq

/-- **Dispersion (determinant part).** `det (Ustep k θ) = 1`, so `Ustep k θ`
lies in `SU(2)` and has eigenvalues `e^{∓ i ω(k)}`. -/
theorem Ustep_det (k θ : ℝ) : (Ustep k θ).det = 1 := by
  rw [Ustep, Matrix.det_mul, Ushift_det, Ucoin_det, mul_one]

/-- The shift entries are the genuine exponentials `e^{∓ik}`; at `θ = 0` this
makes the dispersion `ω(k) = k` exact (massless light cone). -/
theorem Ushift_eq_exp (k : ℝ) :
    Ushift k = !![Complex.exp (-(I * k)), 0; 0, Complex.exp (I * k)] := by
  have key : ∀ x : ℝ, Complex.exp (I * (x : ℂ)) = (Real.cos x : ℂ) + I * Real.sin x := by
    intro x
    rw [mul_comm, Complex.exp_mul_I, ← Complex.ofReal_cos, ← Complex.ofReal_sin]; ring
  have h1 := key k
  have h2 : Complex.exp (-(I * (k : ℂ))) = (Real.cos k : ℂ) - I * Real.sin k := by
    have hneg : -(I * (k : ℂ)) = I * ((-k : ℝ) : ℂ) := by push_cast; ring
    rw [hneg, key (-k)]; push_cast [Real.cos_neg, Real.sin_neg]; ring
  rw [Ushift, h1, h2]

/-- Coin Clifford relation `σ_x² = 1`. -/
theorem sigmax_sq : σx * σx = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [σx]

/-- Coin Clifford relation `σ_z² = 1`. -/
theorem sigmaz_sq : σz * σz = 1 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [σz]

/-- Coin Clifford anticommutation `σ_z σ_x + σ_x σ_z = 0`. -/
theorem sigma_anticomm : σz * σx + σx * σz = 0 := by
  ext i j; fin_cases i <;> fin_cases j <;> simp [σz, σx]

/-- **Relativistic mass shell.** `(k • σ_z + m • σ_x)² = (k² + m²) • 1`, the
finite content of `E² = k² + m²`.  As `m → 0`, `E = |k|` and `dE/dk = ±1`. -/
theorem dirac_mass_shell (k m : ℝ) :
    ((k : ℂ) • σz + (m : ℂ) • σx) ^ 2
      = ((k : ℂ) ^ 2 + (m : ℂ) ^ 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  rw [pow_two]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [σz, σx, Matrix.smul_apply, Matrix.one_fin_two] <;> ring

/-
**Leading-order symbol match.** The one-step family
`ε ↦ Ushift (k ε) * Ucoin (m ε)` has derivative `-i (k σ_z + m σ_x)` at `ε = 0`.
Equivalently `Ustep = 1 - i ε (k σ_z + m σ_x) + O(ε²)`, matching the continuum
Dirac Hamiltonian symbol `H(k) = k σ_z + m σ_x` to first order.
-/
theorem Ustep_hasDerivAt_generator (k m : ℝ) :
    HasDerivAt (fun ε : ℝ => Ushift (k * ε) * Ucoin (m * ε))
      (-I • ((k : ℂ) • σz + (m : ℂ) • σx)) 0 := by
  unfold Ushift Ucoin σz σx;
  rw [ hasDerivAt_pi ];
  norm_num [ Fin.forall_fin_two, Matrix.mul_apply ];
  constructor <;> rw [ hasDerivAt_pi ] <;> norm_num [ Fin.forall_fin_two ];
  · constructor;
    · convert HasDerivAt.mul ( HasDerivAt.sub ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) <| HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) <| HasDerivAt.const_mul _ <| HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) <| HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) <| HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) using 1 ; norm_num;
    · convert HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.sub ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) ( HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ( HasDerivAt.const_mul _ <| HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) ( HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ) ( HasDerivAt.const_mul _ <| HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) ( HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) ) using 1 ; norm_num;
  · constructor;
    · convert HasDerivAt.neg ( HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) ( HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) <| HasDerivAt.const_mul _ <| HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) ( HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) <| HasDerivAt.const_mul _ <| HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) ( HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ) using 1 ; norm_num;
    · convert HasDerivAt.mul ( HasDerivAt.add ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) <| HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) <| HasDerivAt.const_mul _ <| HasDerivAt.comp _ ( Complex.hasDerivAt_sin _ ) <| HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) ( HasDerivAt.comp _ ( Complex.hasDerivAt_cos _ ) <| HasDerivAt.const_mul _ <| hasDerivAt_id _ |> HasDerivAt.ofReal_comp ) using 1 ; norm_num

end ContinuumLimit
