import Mathlib
import PhysicsSM.Algebra.Octonion.ComplexTripleModule

/-!
# Algebra.Octonion.ComplexTripleHermitian

Standard Hermitian inner product and squared norm on the `ℂ³` complement
coordinates of the splitting `𝕆 = ℂ ⊕ ℂ³`.

## Mathematical context

Given the complex-coordinate representation
`ComplexTriple.toComplexVec : ComplexTriple → Fin 3 → ℂ`
from `ComplexTripleModule`, we define:

- **Hermitian form**: `⟨u, v⟩ = ∑ₖ conj(uₖ) · vₖ` (physics convention:
  conjugate-linear in the first argument, linear in the second).
- **Squared norm**: `‖w‖² = ∑ₖ |wₖ|²`, equivalently `Re ⟨w, w⟩`.

We prove the basic scalar-multiplication rules:

- `hermitian (z · u) v = conj(z) · hermitian u v`
- `hermitian u (z · v) = z · hermitian u v`
- `normSq (z · w) = |z|² · normSq w`

and structural facts: non-negativity, zero characterization, and
`hermitian w w` is real.

## Convention

The convention `⟨u, v⟩ = ∑ conj(uₖ) · vₖ` makes the form conjugate-linear
in the first slot and linear in the second (physics convention). This matches
the downstream usage where `SU(3)` acts linearly on the complement.

## Main declarations

- `ComplexTriple.hermitian` — the Hermitian inner product
- `ComplexTriple.normSq` — the squared norm
- `ComplexTriple.normSq_nonneg` — non-negativity
- `ComplexTriple.normSq_zero` — squared norm of zero
- `ComplexTriple.normSq_eq_zero_iff` — zero characterization
- `ComplexTriple.hermitian_self_re` — diagonal is real (re part)
- `ComplexTriple.hermitian_self_im` — diagonal is real (im part)
- `ComplexTriple.hermitian_complexSmul_left` — conjugate-linearity
- `ComplexTriple.hermitian_complexSmul_right` — linearity
- `ComplexTriple.normSq_complexSmul` — norm scaling

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
Convention: project XOR basis from `PhysicsSM.Algebra.Octonion.Basic`.

Theorems in this module are trusted and contain no `sorry`.
-/

namespace PhysicsSM.Algebra.Octonion

/-! ## Hermitian inner product -/

/-- The standard Hermitian inner product on `ComplexTriple`, viewed through
    the `toComplexVec` coordinates:
    `hermitian u v = ∑ₖ conj(uₖ) · vₖ`.

    This is conjugate-linear in the first argument and linear in the
    second. -/
noncomputable def ComplexTriple.hermitian
    (u v : ComplexTriple) : ℂ :=
  ∑ k : Fin 3, starRingEnd ℂ (u.toComplexVec k) * v.toComplexVec k

/-! ## Squared norm -/

/-- The squared norm on `ComplexTriple`:
    `normSq w = ∑ₖ |wₖ|²`.

    This equals `Re (hermitian w w)` and is always a non-negative real. -/
noncomputable def ComplexTriple.normSq
    (w : ComplexTriple) : ℝ :=
  ∑ k : Fin 3, Complex.normSq (w.toComplexVec k)

/-! ## Non-negativity and zero characterization -/

/-- The squared norm is non-negative. -/
theorem ComplexTriple.normSq_nonneg (w : ComplexTriple) :
    0 ≤ w.normSq :=
  Finset.sum_nonneg fun _ _ => Complex.normSq_nonneg _

/-- The squared norm of the zero triple is zero. -/
theorem ComplexTriple.normSq_zero :
    ComplexTriple.normSq 0 = 0 := by
  unfold ComplexTriple.normSq
  rw [ComplexTriple.toComplexVec_zero]
  exact Finset.sum_eq_zero (fun _ _ => by simp)

/-- The squared norm is zero if and only if the triple is zero. -/
theorem ComplexTriple.normSq_eq_zero_iff (w : ComplexTriple) :
    w.normSq = 0 ↔ w = 0 := by
  constructor <;> intro hh
  · unfold ComplexTriple.normSq at hh
    rw [Finset.sum_eq_zero_iff_of_nonneg
      fun _ _ => Complex.normSq_nonneg _] at hh
    simp_all +decide [Complex.ext_iff, Fin.forall_fin_succ]
    cases w; aesop
  · exact hh.symm ▸ ComplexTriple.normSq_zero

/-! ## Hermitian form is real on the diagonal -/

/-- `hermitian w w` has real part equal to `normSq w`. -/
theorem ComplexTriple.hermitian_self_re (w : ComplexTriple) :
    (ComplexTriple.hermitian w w).re = w.normSq := by
  unfold ComplexTriple.hermitian ComplexTriple.normSq
  simp +decide [Complex.normSq]

/-- `hermitian w w` has zero imaginary part. -/
theorem ComplexTriple.hermitian_self_im (w : ComplexTriple) :
    (ComplexTriple.hermitian w w).im = 0 := by
  unfold ComplexTriple.hermitian
  simp_all +decide [Fin.sum_univ_three]
  ring

/-! ## Scalar multiplication rules -/

/-- Hermitian form with complex scalar in the first slot:
    `hermitian (z · u) v = conj(z) · hermitian u v`. -/
theorem ComplexTriple.hermitian_complexSmul_left
    (z : ℂ) (u v : ComplexTriple) :
    ComplexTriple.hermitian (ComplexTriple.complexSmul z u) v =
      starRingEnd ℂ z * ComplexTriple.hermitian u v := by
  unfold ComplexTriple.hermitian
  simp +decide only [toComplexVec, complexSmul, Fin.sum_univ_three]
  simp +decide [Complex.ext_iff, mul_add,
    mul_comm, mul_left_comm]
  constructor <;> ring

/-- Hermitian form with complex scalar in the second slot:
    `hermitian u (z · v) = z · hermitian u v`. -/
theorem ComplexTriple.hermitian_complexSmul_right
    (z : ℂ) (u v : ComplexTriple) :
    ComplexTriple.hermitian u (ComplexTriple.complexSmul z v) =
      z * ComplexTriple.hermitian u v := by
  simp only [ComplexTriple.hermitian,
    ComplexTriple.toComplexVec_complexSmul]
  rw [Finset.mul_sum]
  congr 1; ext k; ring

/-- The squared norm scales by `|z|²` under complex scalar
    multiplication: `normSq (z · w) = |z|² · normSq w`. -/
theorem ComplexTriple.normSq_complexSmul
    (z : ℂ) (w : ComplexTriple) :
    ComplexTriple.normSq (ComplexTriple.complexSmul z w) =
      Complex.normSq z * w.normSq := by
  simp only [ComplexTriple.normSq,
    ComplexTriple.toComplexVec_complexSmul, Complex.normSq_mul]
  rw [Finset.mul_sum]

end PhysicsSM.Algebra.Octonion
