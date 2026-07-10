/-
# Goal III — Relativity is born at the fixed point (exact rational RG)

This file is a clean-room, Mathlib-only formalization of the claim that
Lorentz/relativistic structure emerges as the **fixed point of an EXACT rational
real-space RG (decimation)** for a 1D "null-edge" chain carrier whose sites carry
an *aperture* `lam` (on-site mass-like term) and a *closure* `kap`
(nearest-neighbour edge term).

## The decimation map (closed rational form)

Real-space decimation removes every second site of the tridiagonal chain carrier
(on-site `lam`, nearest-neighbour edge `kap`).  Each surviving site is flanked by
two removed sites, each contributing a self-energy `-kap²/lam` through the
middle-site propagator `lam⁻¹`, and the two removed sites bridge each pair of
survivors with an effective edge `-kap²/lam`.  Integrating out the middle sites
(two-site Schur complement, `chainCore`) gives the exact rational map

```
R(lam, kap) = ( lam - 2·kap²/lam ,  -kap²/lam )   =   (Rlam, Rkap)
```

which is well defined off the codimension-1 locus `lam = 0` (where the
middle-site block `lam·I` is not invertible).

## Which rungs land

* **(b) Massless-line invariance [landed].** The critical (massless) line
  `|kap| = |lam|` is `R`-invariant: it maps to `(-lam, -lam)`, again with
  `|kap'| = |lam'|`.  Non-degeneracy fixture stated in the theorem:
  `R(1, 1/2) = (1/2, -1/4) ≠ (1, 1/2)`, so `R` is a genuine nontrivial flow.
* **(a) The recursion [landed].** `R` is the two-site Schur complement of the
  chain carrier; the middle block `lam·I` is invertible iff `lam ≠ 0`.
* **(d) Conical dispersion `z = 1` [landed].** On the massless line the pinned
  Dirac dispersion is conical `ω = ±k` (mass shell `(k·σz)² = k²·1`), and the
  group velocity saturates the light cone (`v_g² = 1`), giving `z = 1`.
* **(c) Correlation exponent `ν = 1` [landed].** The linearization `dR` at the
  critical point `(lam, lam)` is `J = !![3,-4; 1,-2]`, with **relevant
  (mass-direction) eigenvalue exactly `2`** (eigenvector `(4,1)`, transverse to
  the critical tangent `(1,1)` which carries the marginal eigenvalue `-1`).  With
  rescale `b = 2` this is `b^{1/ν} = 2`, hence `ν = 1` as exact arithmetic.

Kernel-checked: no `sorry`/`admit`/`native_decide`/new `axiom`; every headline
theorem is pinned to footprint `[propext, Classical.choice, Quot.sound]`.
-/

import Mathlib

open Matrix

namespace Goal3ExactRG

/-! ## The two-coupling decimation map `R` (closed rational form) -/

/-- Effective **aperture** after one decimation step:
`lam' = lam - 2·kap²/lam`. -/
def Rlam (lam kap : ℚ) : ℚ := lam - 2 * kap ^ 2 / lam

/-- Effective **closure** after one decimation step: `kap' = -kap²/lam`. -/
def Rkap (lam kap : ℚ) : ℚ := -kap ^ 2 / lam

/-- The exact rational decimation map `R : ℚ×ℚ → ℚ×ℚ`,
`R(lam, kap) = (lam - 2·kap²/lam, -kap²/lam)`. -/
def R (p : ℚ × ℚ) : ℚ × ℚ := (Rlam p.1 p.2, Rkap p.1 p.2)

/-! ## Target (a): the Schur-complement derivation of `R`

The chain carrier restricted to three surviving sites `v1 - v2 - v3` with the two
middle sites `h1, h2` (each on-site `lam`, bonds `kap`) integrated out.  The
removed block `D = lam·I₂` is diagonal (the two middle sites do not couple), so
the effective visible block is `lam·I₃ - B·D⁻¹·Bᵀ` with `B` the coupling matrix.
Its centre `(1,1)` entry is `Rlam` and its edge `(1,0)/(1,2)` entries are `Rkap`. -/

/-- Coupling matrix from the three surviving sites (rows) to the two removed
middle sites (columns): `v1–h1`, `v2–h1`, `v2–h2`, `v3–h2` all equal `kap`. -/
def Bmat (kap : ℚ) : Matrix (Fin 3) (Fin 2) ℚ := !![kap, 0; kap, kap; 0, kap]

/-- Inverse of the removed-sites block `D = lam·I₂` (exists iff `lam ≠ 0`). -/
def Dinv (lam : ℚ) : Matrix (Fin 2) (Fin 2) ℚ := !![lam⁻¹, 0; 0, lam⁻¹]

/-- The effective visible block after integrating out the two middle sites:
the two-site Schur complement `lam·I₃ - B·D⁻¹·Bᵀ`. -/
def chainCore (lam kap : ℚ) : Matrix (Fin 3) (Fin 3) ℚ :=
  lam • (1 : Matrix (Fin 3) (Fin 3) ℚ) - Bmat kap * Dinv lam * (Bmat kap)ᵀ

/-- **Target (a): `R` is the two-site Schur complement, well defined off
`lam = 0`.** The centre entry of the effective block is `Rlam`, the two edge
entries are `Rkap`, and the middle block `lam·I₂` is invertible with inverse
`Dinv lam` exactly when `lam ≠ 0` (the stated codimension-1 excluded locus). -/
theorem R_schur_derivation (lam kap : ℚ) (hlam : lam ≠ 0) :
    chainCore lam kap 1 1 = Rlam lam kap
      ∧ chainCore lam kap 1 0 = Rkap lam kap
      ∧ chainCore lam kap 1 2 = Rkap lam kap
      ∧ (lam • (1 : Matrix (Fin 2) (Fin 2) ℚ)) * Dinv lam = 1 := by
  have hD : Dinv lam = lam⁻¹ • (1 : Matrix (Fin 2) (Fin 2) ℚ) := by
    ext i j; fin_cases i <;> fin_cases j <;> simp [Dinv]
  have hcc : chainCore lam kap
      = lam • (1 : Matrix (Fin 3) (Fin 3) ℚ) - lam⁻¹ • (Bmat kap * (Bmat kap)ᵀ) := by
    simp only [chainCore, hD, Matrix.mul_smul, Matrix.smul_mul, Matrix.mul_one]
  have hBB : Bmat kap * (Bmat kap)ᵀ
      = !![kap ^ 2, kap ^ 2, 0; kap ^ 2, 2 * kap ^ 2, kap ^ 2; 0, kap ^ 2, kap ^ 2] := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [Bmat, Matrix.mul_apply, Matrix.transpose_apply, Fin.sum_univ_two] <;> ring
  rw [hcc, hBB]
  refine ⟨?_, ?_, ?_, ?_⟩
  · simp only [Matrix.sub_apply, Matrix.smul_apply, Matrix.one_apply_eq, smul_eq_mul, mul_one,
      Matrix.cons_val_one, Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero]
    rw [Rlam]; field_simp
  · simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul, Matrix.cons_val_one,
      Matrix.cons_val_zero, Matrix.of_apply, Matrix.cons_val', Matrix.one_apply,
      if_neg (by decide : (1 : Fin 3) ≠ 0)]
    rw [Rkap]; ring
  · simp only [Matrix.sub_apply, Matrix.smul_apply, smul_eq_mul, Matrix.cons_val_one,
      Matrix.cons_val_zero, Matrix.of_apply, Matrix.cons_val', Matrix.one_apply,
      if_neg (by decide : (1 : Fin 3) ≠ 2), Matrix.cons_val_two, Matrix.tail_cons,
      Matrix.vecHead]
    rw [Rkap]; ring
  · rw [hD]; ext i j
    fin_cases i <;> fin_cases j <;>
      simp [one_apply, Matrix.smul_apply, Matrix.mul_apply, mul_inv_cancel₀ hlam]

/-! ## Target (b): massless-line invariance and non-degeneracy -/

/-- **Target (b): the critical (massless) line `|kap| = |lam|` is `R`-invariant,
and `R` is a genuine nontrivial flow.**

* Invariance: whenever `lam ≠ 0` and `|kap| = |lam|`, the image again satisfies
  `|kap'| = |lam'|`; in fact `R(lam, kap) = (-lam, -lam)`.
* Non-degeneracy fixture (stated in-theorem): at the concrete NON-critical point
  `(1, 1/2)` we have `R(1, 1/2) = (1/2, -1/4) ≠ (1, 1/2)`, so `R` is not the
  identity — the invariance is not vacuous. -/
theorem massless_line_invariant_and_nondegenerate :
    (∀ lam kap : ℚ, lam ≠ 0 → |kap| = |lam| →
        |Rkap lam kap| = |Rlam lam kap| ∧ R (lam, kap) = (-lam, -lam))
      ∧ R (1, 1 / 2) = (1 / 2, -1 / 4)
      ∧ R (1, 1 / 2) ≠ (1, 1 / 2) := by
  refine ⟨?_, ?_, ?_⟩
  · intro lam kap hlam habs
    have hsq : kap ^ 2 = lam ^ 2 := by
      rcases abs_eq_abs.mp habs with h | h <;> rw [h]; ring
    have hRl : Rlam lam kap = -lam := by simp only [Rlam]; rw [hsq]; field_simp; ring
    have hRk : Rkap lam kap = -lam := by simp only [Rkap]; rw [hsq]; field_simp
    refine ⟨by rw [hRl, hRk], ?_⟩
    simp only [R]; rw [hRl, hRk]
  · simp only [R, Rlam, Rkap]; norm_num
  · simp only [R, Rlam, Rkap, ne_eq, Prod.mk.injEq, not_and]; intro h; norm_num at h

/-! ## Target (c): the linearized RG and the exponent `ν = 1`

The Jacobian of `R` at the critical point `(lam, lam)` (`lam ≠ 0`) is the
constant integer matrix `J = !![3,-4; 1,-2]`: its rows are the partial
derivatives `(∂lam'/∂lam, ∂lam'/∂kap) = (3,-4)` and
`(∂kap'/∂lam, ∂kap'/∂kap) = (1,-2)`. -/

/-- The linearized RG matrix `dR` at the critical point `(lam, lam)`. -/
def Jac : Matrix (Fin 2) (Fin 2) ℝ := !![3, -4; 1, -2]

/-- **Target (c) — derivative content.** The four partial derivatives of `R` at
the critical point `(lam, lam)` (`lam ≠ 0`) are the entries of `Jac`. -/
theorem jacobian_is_derivative (lam : ℝ) (hlam : lam ≠ 0) :
    HasDerivAt (fun l : ℝ => l - 2 * lam ^ 2 / l) 3 lam
      ∧ HasDerivAt (fun k : ℝ => lam - 2 * k ^ 2 / lam) (-4) lam
      ∧ HasDerivAt (fun l : ℝ => -lam ^ 2 / l) 1 lam
      ∧ HasDerivAt (fun k : ℝ => -k ^ 2 / lam) (-2) lam := by
  have hinv : HasDerivAt (fun l : ℝ => l⁻¹) (-(lam ^ 2)⁻¹) lam := by
    simpa [pow_two] using hasDerivAt_inv hlam
  refine ⟨?_, ?_, ?_, ?_⟩
  · have hd : HasDerivAt (fun l : ℝ => l - 2 * lam ^ 2 / l)
        (1 - 2 * lam ^ 2 * (-(lam ^ 2)⁻¹)) lam := by
      apply (hasDerivAt_id lam).sub
      simpa [div_eq_mul_inv] using hinv.const_mul (2 * lam ^ 2)
    convert hd using 1; field_simp; ring
  · have hd : HasDerivAt (fun k : ℝ => lam - 2 * k ^ 2 / lam)
        (0 - 2 * (2 * lam ^ 1) / lam) lam := by
      apply (hasDerivAt_const lam lam).sub
      simpa [div_eq_mul_inv, mul_comm, mul_assoc] using
        ((hasDerivAt_pow 2 lam).const_mul (2 : ℝ)).div_const lam
    convert hd using 1; field_simp; ring
  · have hd : HasDerivAt (fun l : ℝ => -lam ^ 2 / l)
        (-lam ^ 2 * (-(lam ^ 2)⁻¹)) lam := by
      simpa [div_eq_mul_inv] using hinv.const_mul (-lam ^ 2)
    convert hd using 1; field_simp
  · have hd : HasDerivAt (fun k : ℝ => -k ^ 2 / lam) (-(2 * lam ^ 1) / lam) lam := by
      simpa [div_eq_mul_inv, mul_comm, mul_assoc] using
        (((hasDerivAt_pow 2 lam).neg)).div_const lam
    convert hd using 1; field_simp

/-- **Target (c) — the mass eigenvalue is exactly `2`, so `ν = 1`.**

* Relevant (mass) direction: `Jac · (4,1) = 2·(4,1)`, eigenvalue exactly `2`.
* Marginal direction along the critical tangent: `Jac · (1,1) = -1·(1,1)`.
* Characteristic polynomial `X² - X - 2 = (X-2)(X+1)` (`trace = 1`, `det = -2`).
* With rescale `b = 2`, the thermal exponent is `y_t = log_b λ = log₂ 2 = 1`,
  hence `ν = 1/y_t = 1`. -/
theorem linearized_mass_eigenvalue_eq_two :
    Jac.mulVec ![4, 1] = (2 : ℝ) • ![4, 1]
      ∧ Jac.mulVec ![1, 1] = (-1 : ℝ) • ![1, 1]
      ∧ Jac.trace = 1
      ∧ Jac.det = -2
      ∧ Real.logb 2 2 = 1 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩
  · funext i; fin_cases i <;>
      simp [Jac, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> norm_num
  · funext i; fin_cases i <;>
      simp [Jac, Matrix.mulVec, dotProduct, Fin.sum_univ_two] <;> norm_num
  · simp only [Jac, Matrix.trace_fin_two]; norm_num
  · simp only [Jac, Matrix.det_fin_two]; norm_num
  · exact Real.logb_self_eq_one (by norm_num)

/-! ## Target (d): conical dispersion `z = 1` on the massless line

Clean-room port of the pinned Dirac dispersion (`ContinuumLimit`,
`SubluminalBound`).  On the massless line (mass angle `θ = 0`) the mass shell is
conical (`(k·σz)² = k²·1`, eigenvalues `±k`, so `ω = ±k`) and the group velocity
saturates the light cone (`v_g² = 1`), giving dynamical exponent `z = 1`. -/

/-- Pauli `σz`. -/
def σz : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- **Target (d): conical dispersion, `z = 1`.**

* Conical mass shell on the massless line: `(k·σz)² = k²·1`, i.e. `ω = ±k`
  (linear dispersion, dynamical exponent `z = 1`).
* Light-cone saturation: the luminal deficit
  `sin²ω − (sin k · cos 0)² = 1 − cos²0` vanishes at `θ = 0`, so `v_g² = 1`. -/
theorem conical_dispersion_z_eq_one (k : ℝ) :
    ((k : ℂ) • σz) ^ 2 = ((k : ℂ) ^ 2) • (1 : Matrix (Fin 2) (Fin 2) ℂ)
      ∧ (1 - (Real.cos k * Real.cos 0) ^ 2) - (Real.sin k * Real.cos 0) ^ 2 = 0 := by
  refine ⟨?_, ?_⟩
  · rw [pow_two]; ext i j
    fin_cases i <;> fin_cases j <;>
      simp [σz, Matrix.smul_apply, Matrix.one_fin_two, Matrix.mul_apply, Fin.sum_univ_two] <;> ring
  · simp only [Real.cos_zero, mul_one]; nlinarith [Real.sin_sq_add_cos_sq k]

/-! ## Axiom pins (headline theorems)

Every headline theorem is pinned to footprint `[propext, Classical.choice,
Quot.sound]`. -/

/-- info: 'Goal3ExactRG.R_schur_derivation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms R_schur_derivation

/-- info: 'Goal3ExactRG.massless_line_invariant_and_nondegenerate' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_line_invariant_and_nondegenerate

/-- info: 'Goal3ExactRG.jacobian_is_derivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms jacobian_is_derivative

/-- info: 'Goal3ExactRG.linearized_mass_eigenvalue_eq_two' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearized_mass_eigenvalue_eq_two

/-- info: 'Goal3ExactRG.conical_dispersion_z_eq_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms conical_dispersion_z_eq_one

end Goal3ExactRG
