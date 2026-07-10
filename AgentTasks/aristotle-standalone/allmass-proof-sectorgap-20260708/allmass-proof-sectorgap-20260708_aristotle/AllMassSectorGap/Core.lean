/-
# The full 6x6 sector mass gap is aperture minus |closure|

Proof job (Aristotle). Mathlib-only. The two-edge Cl(4) carrier's physical sector
form is (at general couplings) the block diagonal `Msec(lam,kappa) = B(lam,kappa)
(+) B(lam,-kappa)` of the 3x3 mass block and its closure-mirror (kernel-checked at
the fixed point (2,1) in the project as M6 = B(2,1)(+)B(2,-1)). Since B(lam,kappa)
has spectrum {lam-kappa, lam, lam+kappa}, the sector spectrum is the union
{lam-|kappa|, lam, lam+|kappa|} (each doubled), so the SECTOR mass gap (least
eigenvalue) is `lam - |kappa|`.

## Targets (prove kernel-clean, no `sorry`)

Define `Msec (lam kappa : ℝ) : Matrix (Fin 6) (Fin 6) ℂ` as the block diagonal of
`B lam kappa` and `B lam (-kappa)`. Prove:

- **Msec_isHermitian:** `(Msec lam kappa).IsHermitian`.
- **Msec_least_eigenvalue:** for `0 <= kappa <= lam`, the least eigenvalue of
  `Msec lam kappa` is `lam - kappa` (= `lam - |kappa|` since kappa >= 0).
- **Msec_posDef_iff:** `(Msec lam kappa).PosDef <-> |kappa| < lam`.

`B`, `B_isHermitian`, `B_least_eigenvalue`, `B_posDef_iff` are reproduced from the
kernel-checked MassGapWitness (Mathlib-only).

## Semantic alignment

The load-bearing content is "the full sector mass gap = aperture - |closure|",
lifting the block result to the actual 6-dim sector form.  We compute, for any
Hermitian `A`, `Set.range A.eigenvalues = spectrum ℝ A`, and evaluate both spectra
by the characteristic determinant:
`det (μ•1 - B lam kappa) = (μ-lam)(μ-lam-kappa)(μ-lam+kappa)`, so
`spectrum ℝ (B lam kappa) = {lam-kappa, lam, lam+kappa}`; and the block-diagonal
determinant factors, giving `spectrum ℝ (Msec lam kappa) = {lam-kappa, lam,
lam+kappa}` as well (the two mirror blocks contribute the same set).  The least
eigenvalue is then `lam - kappa` and positive definiteness is `|kappa| < lam`.

Provenance: all-mass solo run 2026-07-08 [orig].
-/

import Mathlib

namespace AllMassSectorGap

open Matrix Complex
open scoped ComplexOrder

/-- The carrier-sector 3x3 Hermitian mass block. -/
noncomputable def B (lam kappa : ℝ) : Matrix (Fin 3) (Fin 3) ℂ :=
  !![(lam : ℂ), (kappa : ℂ) * Complex.I, 0;
     -((kappa : ℂ) * Complex.I), (lam : ℂ), 0;
     0, 0, (lam : ℂ)]

theorem B_isHermitian (lam kappa : ℝ) : (B lam kappa).IsHermitian := by
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ B ]

/-- Characteristic determinant of the 3x3 block:
`det (μ•1 - B) = (μ-lam)(μ-lam-kappa)(μ-lam+kappa)`. -/
theorem B_det_char (lam kappa μ : ℝ) :
    ((algebraMap ℝ (Matrix (Fin 3) (Fin 3) ℂ) μ) - B lam kappa).det
      = ((μ:ℂ) - lam) * ((μ:ℂ) - lam - kappa) * ((μ:ℂ) - lam + kappa) := by
  rw [Matrix.det_fin_three]
  simp [B, Algebra.algebraMap_eq_smul_one]
  ring_nf
  simp [Complex.I_sq]

/-- The (real) spectrum of the 3x3 block is `{lam-kappa, lam, lam+kappa}`. -/
theorem B_spectrum (lam kappa : ℝ) :
    spectrum ℝ (B lam kappa) = {lam - kappa, lam, lam + kappa} := by
  ext μ
  rw [spectrum.mem_iff, Matrix.isUnit_iff_isUnit_det, B_det_char,
      isUnit_iff_ne_zero, not_not]
  simp only [mul_eq_zero, Set.mem_insert_iff, Set.mem_singleton_iff]
  constructor
  · rintro ((h | h) | h)
    · right; left
      have : (μ:ℂ) = lam := by linear_combination h
      exact_mod_cast this
    · right; right
      have : (μ:ℂ) = lam + kappa := by linear_combination h
      exact_mod_cast this
    · left
      have : (μ:ℂ) = lam - kappa := by linear_combination h
      exact_mod_cast this
  · rintro (h | h | h) <;> subst h <;> push_cast <;> ring_nf <;> simp

/-- Block-level mass gap: for `0 ≤ kappa ≤ lam`, the least eigenvalue of
`B lam kappa` is `lam - kappa`. -/
theorem B_least_eigenvalue (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hk : kappa ≤ lam) :
    IsLeast (Set.range (B_isHermitian lam kappa).eigenvalues) (lam - kappa) := by
  rw [← (B_isHermitian lam kappa).spectrum_real_eq_range_eigenvalues, B_spectrum]
  refine ⟨by left; rfl, ?_⟩
  rintro x (h | h | h) <;> subst h <;> linarith

/-- Block-level positive definiteness criterion: `B lam kappa` is positive definite
iff `|kappa| < lam`. -/
theorem B_posDef_iff (lam kappa : ℝ) :
    (B lam kappa).PosDef ↔ |kappa| < lam := by
  rw [(B_isHermitian lam kappa).posDef_iff_eigenvalues_pos,
      ← Set.forall_mem_range (p := fun x => 0 < x),
      ← (B_isHermitian lam kappa).spectrum_real_eq_range_eigenvalues, B_spectrum]
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff, forall_eq_or_imp, forall_eq]
  constructor
  · rintro ⟨h1, h2, h3⟩
    rw [abs_lt]; constructor <;> linarith
  · intro h
    rw [abs_lt] at h
    exact ⟨by linarith, by linarith, by linarith⟩

/-- The 6x6 physical-sector mass matrix: block diagonal of `B lam kappa` (the mass
block) and `B lam (-kappa)` (its closure-mirror). -/
noncomputable def Msec (lam kappa : ℝ) : Matrix (Fin 6) (Fin 6) ℂ :=
  Matrix.reindex finSumFinEquiv finSumFinEquiv
    (Matrix.fromBlocks (B lam kappa) 0 0 (B lam (-kappa)))

theorem Msec_isHermitian (lam kappa : ℝ) : (Msec lam kappa).IsHermitian := by
  rw [Msec, Matrix.reindex_apply]
  refine Matrix.IsHermitian.submatrix ?_ _
  refine Matrix.IsHermitian.fromBlocks (B_isHermitian lam kappa) ?_ (B_isHermitian lam (-kappa))
  simp

/-- Characteristic determinant of the 6x6 sector matrix factors as the product of
the two blocks' characteristic determinants. -/
theorem Msec_det_char (lam kappa μ : ℝ) :
    ((algebraMap ℝ (Matrix (Fin 6) (Fin 6) ℂ) μ) - Msec lam kappa).det
      = ((algebraMap ℝ (Matrix (Fin 3) (Fin 3) ℂ) μ) - B lam kappa).det
        * ((algebraMap ℝ (Matrix (Fin 3) (Fin 3) ℂ) μ) - B lam (-kappa)).det := by
  have hAM : (algebraMap ℝ (Matrix (Fin 6) (Fin 6) ℂ) μ)
      = (Matrix.reindexAlgEquiv ℝ ℂ (finSumFinEquiv (m:=3) (n:=3)))
          (algebraMap ℝ (Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℂ) μ) :=
    ((Matrix.reindexAlgEquiv ℝ ℂ (finSumFinEquiv (m:=3) (n:=3))).commutes μ).symm
  rw [Msec, hAM, ← Matrix.reindexAlgEquiv_apply ℝ ℂ, ← map_sub,
      Matrix.reindexAlgEquiv_apply, Matrix.det_reindex_self]
  rw [show (algebraMap ℝ (Matrix (Fin 3 ⊕ Fin 3) (Fin 3 ⊕ Fin 3) ℂ) μ)
        = Matrix.fromBlocks (algebraMap ℝ (Matrix (Fin 3) (Fin 3) ℂ) μ) 0 0
            (algebraMap ℝ (Matrix (Fin 3) (Fin 3) ℂ) μ) from ?_]
  · rw [sub_eq_add_neg, Matrix.fromBlocks_neg, Matrix.fromBlocks_add]
    simp only [neg_zero, add_zero, ← sub_eq_add_neg]
    rw [Matrix.det_fromBlocks_zero₁₂]
  · simp [Algebra.algebraMap_eq_smul_one, ← Matrix.fromBlocks_one, Matrix.fromBlocks_smul]

/-- The (real) spectrum of the 6x6 sector matrix is the union of the two blocks'
spectra. -/
theorem Msec_spectrum_union (lam kappa : ℝ) :
    spectrum ℝ (Msec lam kappa)
      = spectrum ℝ (B lam kappa) ∪ spectrum ℝ (B lam (-kappa)) := by
  ext μ
  rw [Set.mem_union, spectrum.mem_iff, spectrum.mem_iff, spectrum.mem_iff,
      Matrix.isUnit_iff_isUnit_det, Matrix.isUnit_iff_isUnit_det,
      Matrix.isUnit_iff_isUnit_det, Msec_det_char,
      isUnit_iff_ne_zero, isUnit_iff_ne_zero, isUnit_iff_ne_zero,
      not_not, not_not, not_not, mul_eq_zero]

/-- The (real) spectrum of the 6x6 sector matrix is `{lam-kappa, lam, lam+kappa}`
(the two mirror blocks contribute the same set). -/
theorem Msec_spectrum (lam kappa : ℝ) :
    spectrum ℝ (Msec lam kappa) = {lam - kappa, lam, lam + kappa} := by
  rw [Msec_spectrum_union, B_spectrum, B_spectrum]
  ext x
  simp only [Set.mem_union, Set.mem_insert_iff, Set.mem_singleton_iff, sub_neg_eq_add]
  constructor
  · rintro ((h | h | h) | (h | h | h)) <;> tauto
  · rintro (h | h | h) <;> tauto

/-- **Sector mass gap = aperture − |closure|.**  For `0 ≤ kappa ≤ lam`, the least
eigenvalue of the full 6x6 physical-sector matrix `Msec lam kappa` is `lam - kappa`
(= `lam - |kappa|`). -/
theorem Msec_least_eigenvalue (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hk : kappa ≤ lam) :
    IsLeast (Set.range (Msec_isHermitian lam kappa).eigenvalues) (lam - kappa) := by
  rw [← (Msec_isHermitian lam kappa).spectrum_real_eq_range_eigenvalues, Msec_spectrum]
  refine ⟨by left; rfl, ?_⟩
  rintro x (h | h | h) <;> subst h <;> linarith

/-- Positive definiteness of the full sector matrix: `Msec lam kappa` is positive
definite iff `|kappa| < lam`. -/
theorem Msec_posDef_iff (lam kappa : ℝ) :
    (Msec lam kappa).PosDef ↔ |kappa| < lam := by
  rw [(Msec_isHermitian lam kappa).posDef_iff_eigenvalues_pos,
      ← Set.forall_mem_range (p := fun x => 0 < x),
      ← (Msec_isHermitian lam kappa).spectrum_real_eq_range_eigenvalues, Msec_spectrum]
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff, forall_eq_or_imp, forall_eq]
  constructor
  · rintro ⟨h1, h2, h3⟩
    rw [abs_lt]; constructor <;> linarith
  · intro h
    rw [abs_lt] at h
    exact ⟨by linarith, by linarith, by linarith⟩

end AllMassSectorGap
