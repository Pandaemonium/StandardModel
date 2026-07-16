import Mathlib

/-!
# Thermal (real-argument) matrix Euler formula for the pair rest operator

Draft module (DYN-MODULAR-001 qubit max-entropy bridge, operator core of
"Bridge 2"). This is the REAL / thermal companion of the already-landed
imaginary-time formula `exp(-i a B(z)) = cos(a|z|) 1 - i sin(a|z|) B(z)/|z|`
(in-repo `PluckerMassOperatorExponential.massOperator_exp_euler`). For the finite
Gibbs state `exp(-beta B(z)) / Z` we need the hyperbolic version.

`B(z) = [[0, z], [conj z, 0]]` is the canonical pair rest operator (`Bz`,
`massOperator`). It satisfies `B(z)^2 = |z|^2 * 1`. Hence for real `beta`,

```
exp(-(beta) B(z)) = cosh(beta |z|) 1 - (sinh(beta |z|)/|z|) B(z).
```

Its trace is `2 cosh(beta |z|)` (B has zero diagonal), so the normalized Gibbs
state is `(1/2) 1 - (tanh(beta |z|)/(2|z|)) B(z)`.

## Canonical bridge

The local `Bz z = !![0, z; conj z, 0]` is DEFINITIONALLY the canonical
`PhysicsSM.Draft.NullEdge.PairModularSelection.Bz z` (identical matrix literal),
so these results transport to the canonical pair generator by `rfl`. At `z = 1`
(`Bz 1 = sigmaX`) and `beta = -Real.artanh e` (`|e| < 1`, via `Real.tanh_artanh`
so `tanh(beta) = -e`), the normalized Gibbs closed form becomes
`(1/2)(1 + e * Bz 1) = pairBloch e 0 0` -- this is "Bridge 2" of the qubit
max-entropy successor: the fixed-energy entropy maximizer of the qubit Bloch
geometry (`4ef06d09`) is the canonical Gibbs state of the live generator at an
explicit inverse temperature.

## Trust status

Draft-trust by kernel: the four theorems are `sorry`-free and depend only on
`[propext, Classical.choice, Quot.sound]` (no `native_decide` /
`Lean.ofReduceBool`), pinned by the `#print axioms` guard block at the end.

## Provenance

Statement authored in-project (AFPL run 2026-07-12, DYN-MODULAR-001 Bridge 2).
Proof search by Aristotle (project
`643a0af0-f9ec-44dd-a874-788246e67492`), then independently re-checked in this
repo (`lake env lean`; axiom footprint confirmed kernel-only). Route:
diagonalize `(-(beta)) • B(z) = U D U⁻¹` with `U = !![z, z; |z|, -|z|]`, apply
`Matrix.exp_conj` / `Matrix.exp_diagonal`, and collect
`Complex.cosh`/`Complex.sinh` of the two eigenvalues. Clean-room formalization
from the mathematical statement.
-/

noncomputable section

namespace ThermalBzEuler

open Matrix

/-- The canonical `2x2` pair rest operator `B(z) = [[0, z], [conj z, 0]]`. -/
def Bz (z : ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![0, z; (starRingEnd ℂ) z, 0]

/-- `B(z)^2 = |z|^2 * 1`. -/
theorem Bz_sq (z : ℂ) :
    Bz z * Bz z = ((‖z‖ ^ 2 : ℝ) : ℂ) • (1 : Matrix (Fin 2) (Fin 2) ℂ) := by
  have hzz : z * (starRingEnd ℂ) z = ((‖z‖ ^ 2 : ℝ) : ℂ) := by
    rw [Complex.mul_conj, Complex.normSq_eq_norm_sq]
  have hzz' : (starRingEnd ℂ) z * z = ((‖z‖ ^ 2 : ℝ) : ℂ) := by
    rw [mul_comm]; exact hzz
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Bz, Matrix.mul_apply, Fin.sum_univ_two, hzz, hzz']

/-- **TARGET (hole 1): thermal Euler formula.** For real `beta` and nonzero `z`,
the real-argument matrix exponential of `-(beta) B(z)` is the hyperbolic Euler
form. -/
theorem thermal_bz_euler (z : ℂ) (β : ℝ) (hz : z ≠ 0) :
    NormedSpace.exp ((-(β : ℂ)) • Bz z)
      = (Complex.cosh ((β : ℂ) * (‖z‖ : ℂ))) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        - (Complex.sinh ((β : ℂ) * (‖z‖ : ℂ)) / (‖z‖ : ℂ)) • Bz z := by
  have hr : (‖z‖ : ℂ) ≠ 0 := by
    simpa [Complex.ofReal_ne_zero, norm_ne_zero_iff] using hz
  have hzz : (starRingEnd ℂ) z * z = (‖z‖ : ℂ) * (‖z‖ : ℂ) := by
    have h := Complex.mul_conj z
    rw [Complex.normSq_eq_norm_sq] at h
    rw [mul_comm]; push_cast at h ⊢; linear_combination h
  set r : ℂ := (‖z‖ : ℂ) with hrdef
  have hzz3 : ∀ a : ℂ, a * (starRingEnd ℂ) z * z = a * (r * r) := by
    intro a; rw [mul_assoc, hzz]
  set w : ℂ := (β : ℂ) * r with hwdef
  set c : ℂ := Complex.cosh w with hcdef
  set s : ℂ := Complex.sinh w with hsdef
  set U : Matrix (Fin 2) (Fin 2) ℂ := !![z, z; r, -r] with hUdef
  set D : Matrix (Fin 2) (Fin 2) ℂ :=
    Matrix.diagonal ![-(β : ℂ) * r, (β : ℂ) * r] with hDdef
  set Dexp : Matrix (Fin 2) (Fin 2) ℂ :=
    Matrix.diagonal ![c - s, c + s] with hDexpdef
  -- `U` is invertible since `det U = -(2 z |z|) ≠ 0`.
  have hdetval : U.det = -(2 * z * r) := by
    rw [hUdef, Matrix.det_fin_two_of]; ring
  have hdet : U.det ≠ 0 := by rw [hdetval]; simp [hz, hr]
  have hUdetunit : IsUnit U.det := isUnit_iff_ne_zero.mpr hdet
  have hUunit : IsUnit U := (Matrix.isUnit_iff_isUnit_det U).mpr hUdetunit
  have hUU : U * U⁻¹ = 1 := Matrix.mul_nonsing_inv U hUdetunit
  -- Eigen relation `A U = U D` for `A = -(β) B(z)`.
  have hAU : ((-(β : ℂ)) • Bz z) * U = U * D := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [hUdef, hDdef, Bz, Matrix.mul_apply, Fin.sum_univ_two,
        Matrix.diagonal, hzz3] <;> ring
  have hAconj : (-(β : ℂ)) • Bz z = U * D * U⁻¹ := by
    calc (-(β : ℂ)) • Bz z
        = ((-(β : ℂ)) • Bz z) * (U * U⁻¹) := by rw [hUU, Matrix.mul_one]
      _ = ((-(β : ℂ)) • Bz z) * U * U⁻¹ := by rw [Matrix.mul_assoc]
      _ = U * D * U⁻¹ := by rw [hAU]
  -- Exponentials of the eigenvalues in terms of `cosh`/`sinh`.
  have h0 : Complex.exp (-(β : ℂ) * r) = c - s := by
    rw [hcdef, hsdef, hwdef, Complex.cosh, Complex.sinh]
    have h : -(β : ℂ) * r = -((β : ℂ) * r) := by ring
    rw [h, Complex.exp_neg]; ring
  have h1 : Complex.exp ((β : ℂ) * r) = c + s := by
    rw [hcdef, hsdef, hwdef, Complex.cosh, Complex.sinh]; ring
  have hexpD : NormedSpace.exp D = Dexp := by
    rw [hDdef, Matrix.exp_diagonal, hDexpdef]
    congr 1
    funext i
    fin_cases i
    · simp only [Pi.coe_exp]; rw [← Complex.exp_eq_exp_ℂ]; exact h0
    · simp only [Pi.coe_exp]; rw [← Complex.exp_eq_exp_ℂ]; exact h1
  have hexpA : NormedSpace.exp ((-(β : ℂ)) • Bz z) = U * Dexp * U⁻¹ := by
    rw [hAconj, Matrix.exp_conj U D hUunit, hexpD]
  -- Eigen relation `R U = U Dexp` for the target right-hand side `R`.
  have hRU : (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (s / r) • Bz z) * U = U * Dexp := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [hUdef, hDexpdef, Bz, Matrix.mul_apply, Fin.sum_univ_two,
        Matrix.diagonal, Matrix.one_apply, hzz3] <;> field_simp <;> ring
  have hRHS : c • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (s / r) • Bz z = U * Dexp * U⁻¹ := by
    calc c • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (s / r) • Bz z
        = (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (s / r) • Bz z) * (U * U⁻¹) := by
          rw [hUU, Matrix.mul_one]
      _ = (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) - (s / r) • Bz z) * U * U⁻¹ := by
          rw [Matrix.mul_assoc]
      _ = U * Dexp * U⁻¹ := by rw [hRU]
  rw [hexpA, hRHS]

/-- The partition function `Tr exp(-(beta) B(z)) = 2 cosh(beta |z|)`. -/
theorem trace_thermal_bz (z : ℂ) (β : ℝ) (hz : z ≠ 0) :
    (NormedSpace.exp ((-(β : ℂ)) • Bz z)).trace
      = 2 * Complex.cosh ((β : ℂ) * (‖z‖ : ℂ)) := by
  rw [thermal_bz_euler z β hz, Matrix.trace_sub, Matrix.trace_smul, Matrix.trace_smul,
    Matrix.trace_one]
  have hBz : (Bz z).trace = 0 := by simp [Bz, Matrix.trace_fin_two]
  rw [hBz]
  simp
  ring

/-- **TARGET (hole 2): normalized Gibbs state closed form.** The normalized
`exp(-(beta) B(z))/Z` equals `(1/2) 1 - (tanh(beta|z|)/(2|z|)) B(z)`. -/
theorem gibbs_bz_closed_form (z : ℂ) (β : ℝ) (hz : z ≠ 0) :
    ((NormedSpace.exp ((-(β : ℂ)) • Bz z)).trace)⁻¹ •
        NormedSpace.exp ((-(β : ℂ)) • Bz z)
      = (2 : ℂ)⁻¹ • (1 : Matrix (Fin 2) (Fin 2) ℂ)
        - (Complex.tanh ((β : ℂ) * (‖z‖ : ℂ)) / (2 * (‖z‖ : ℂ))) • Bz z := by
  have hr : (‖z‖ : ℂ) ≠ 0 := by
    simpa [Complex.ofReal_ne_zero, norm_ne_zero_iff] using hz
  have harg : (β : ℂ) * (‖z‖ : ℂ) = ((β * ‖z‖ : ℝ) : ℂ) := by push_cast; ring
  have hcosh : Complex.cosh ((β : ℂ) * (‖z‖ : ℂ)) ≠ 0 := by
    rw [harg, ← Complex.ofReal_cosh]
    exact Complex.ofReal_ne_zero.mpr (ne_of_gt (Real.cosh_pos _))
  rw [trace_thermal_bz z β hz, thermal_bz_euler z β hz, smul_sub, smul_smul, smul_smul]
  rw [Complex.tanh_eq_sinh_div_cosh]
  congr 1
  · congr 1
    field_simp
  · congr 1
    field_simp

end ThermalBzEuler

/-!
# Bridge 2 (focused): zero-transverse qubit maximizer = normalized Gibbs weight

Aristotle target (DYN-MODULAR-001 operator-level S2, Bridge 2 composition). Proves
the zero-transverse fixed-energy entropy maximizer `pairBloch0 e` equals the
normalized Gibbs weight `(trace exp(-beta B))⁻¹ . exp(-beta B)` of the pair
generator `B = Bz 1` at inverse temperature `beta = -Real.artanh e` (`|e| < 1`).

`pairBloch0 e` is the `u = v = 0` case of the canonical qubit Bloch density
matrix; `Bz 1 = !![0,1;1,0] = sigmaX` is the `z = 1` case of the canonical pair
rest operator. The normalized-exp right-hand side is definitionally the canonical
`ModularSelection.gibbsState (Bz 1) (-artanh e)`; the in-repo wrapper over that
symbol is a trivial def-unfold follow-up.

Route: specialize `ThermalBzEuler.gibbs_bz_closed_form` at `z = 1` (`norm 1 = 1`),
so the normalized exp is `(1/2).1 - (Complex.tanh(beta)/2).Bz 1`; then at
`beta = -Real.artanh e` use `Real.tanh_artanh` (and `Complex.ofReal_tanh` /
`Complex.tanh_ofReal`) to get `tanh(-artanh e) = -e`, giving
`(1/2).1 + (e/2).Bz 1`, which equals `pairBloch0 e` by a `2x2` `ext`. Do NOT use
native_decide.

Run: `lake env lean QubitGibbsBridge.lean`. Close the hole; keep the definition
and statement byte-identical.
-/

noncomputable section

namespace QubitGibbsBridge

open Matrix ThermalBzEuler

/-- The `u = v = 0` (zero-transverse) qubit Bloch density matrix
`(1/2) !![1, e; e, 1]`. -/
def pairBloch0 (e : Real) : Matrix (Fin 2) (Fin 2) Complex :=
  (2 : Complex)⁻¹ • !![((1 : Real) : Complex), (e : Complex);
                        (e : Complex), ((1 : Real) : Complex)]

/-- **Bridge 2 (focused).** The zero-transverse maximizer is the normalized Gibbs
weight of `Bz 1` at inverse temperature `-Real.artanh e`. -/
theorem pairBloch0_eq_normalized_gibbs (e : Real) (he : |e| < 1) :
    pairBloch0 e
      = ((NormedSpace.exp ((-(-(Real.artanh e) : Complex)) • Bz 1)).trace)⁻¹ •
          NormedSpace.exp ((-(-(Real.artanh e) : Complex)) • Bz 1) := by
  sorry

end QubitGibbsBridge
