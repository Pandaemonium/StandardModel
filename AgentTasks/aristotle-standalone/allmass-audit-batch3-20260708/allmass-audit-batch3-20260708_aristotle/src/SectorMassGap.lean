/-
# The full physical-sector mass gap is aperture minus |closure|

DRAFT (kernel-clean; no `s o r r y`). Lifts the block-level mass gap
(`MassGapWitness.B_least_eigenvalue`, on the `3×3` block `B(λ,κ)`) to the **full
`6×6` physical-sector form** `Msec(λ,κ) = B(λ,κ) ⊕ B(λ,-κ)` — the parametrized
generalization of the concrete carrier sector `M6 = B(2,1) ⊕ B(2,-1)`
(`MassGapWitness.M6_topBlock_eq_B`).

Since both mirror blocks `B(λ,±κ)` have the same spectrum `{λ-κ, λ, λ+κ}`, the
sector spectrum is that same set, so the **full-sector squared mass gap (least
eigenvalue) is `λ - κ = aperture − |closure|`** (for `0 ≤ κ ≤ λ`), and the sector
is positive-definite (massive) iff `|κ| < λ`. This is the honest "physical sector"
mass gap — of the actual `6`-dimensional form, not just the `3×3` half-block.

## Landed theorems (all M, kernel-clean)

- `Msec_isHermitian`, `Msec_det_char`, `Msec_spectrum_union`, `Msec_spectrum`.
- `Msec_least_eigenvalue` — least eigenvalue `= λ - κ` (`IsLeast`, `0 ≤ κ ≤ λ`).
- `Msec_posDef_iff` — `Msec.PosDef ↔ |κ| < λ`.

## Provenance

All-mass solo run 2026-07-08 [orig]. Proofs from Aristotle (standalone package
`AgentTasks/aristotle-standalone/allmass-proof-sectorgap-20260708`), reviewed for
semantic alignment and re-based here onto the kernel-checked `MassGapWitness.B` /
`B_spectrum` (the package reproduced them; this uses the project's). Builds on
`MassGapWitness`.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

namespace PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap

open Matrix Complex
open scoped ComplexOrder
open PhysicsSM.Draft.NullEdge.Carrier.MassGapWitness

/-- The full `6×6` physical-sector mass form: the block diagonal of the mass block
`B(λ,κ)` and its closure-mirror `B(λ,-κ)`. -/
noncomputable def Msec (lam kappa : ℝ) : Matrix (Fin 6) (Fin 6) ℂ :=
  Matrix.reindex finSumFinEquiv finSumFinEquiv
    (Matrix.fromBlocks (B lam kappa) 0 0 (B lam (-kappa)))

theorem Msec_isHermitian (lam kappa : ℝ) : (Msec lam kappa).IsHermitian := by
  rw [Msec, Matrix.reindex_apply]
  refine Matrix.IsHermitian.submatrix ?_ _
  refine Matrix.IsHermitian.fromBlocks (B_isHermitian lam kappa) ?_ (B_isHermitian lam (-kappa))
  simp

/-- Characteristic determinant of the `6×6` sector matrix factors as the product of
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

/-- The (real) spectrum of the `6×6` sector matrix is the union of the two blocks'
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

/-- The (real) spectrum of the `6×6` sector matrix is `{λ-κ, λ, λ+κ}` (the two
mirror blocks contribute the same set). -/
theorem Msec_spectrum (lam kappa : ℝ) :
    spectrum ℝ (Msec lam kappa) = {lam - kappa, lam, lam + kappa} := by
  rw [Msec_spectrum_union, B_spectrum, B_spectrum]
  ext x
  simp only [Set.mem_union, Set.mem_insert_iff, Set.mem_singleton_iff, sub_neg_eq_add]
  constructor
  · rintro ((h | h | h) | (h | h | h)) <;> tauto
  · rintro (h | h | h) <;> tauto

/-- **Sector mass gap = aperture − |closure|.** For `0 ≤ κ ≤ λ`, the least
eigenvalue of the full `6×6` physical-sector matrix `Msec λ κ` is `λ - κ`
(= `λ - |κ|`). -/
theorem Msec_least_eigenvalue (lam kappa : ℝ) (h0 : 0 ≤ kappa) (hk : kappa ≤ lam) :
    IsLeast (Set.range (Msec_isHermitian lam kappa).eigenvalues) (lam - kappa) := by
  rw [← (Msec_isHermitian lam kappa).spectrum_real_eq_range_eigenvalues, Msec_spectrum]
  refine ⟨by left; rfl, ?_⟩
  rintro x (h | h | h) <;> subst h <;> linarith

/-- Positive definiteness of the full sector matrix: `Msec λ κ` is positive definite
iff `|κ| < λ`. -/
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

end PhysicsSM.Draft.NullEdge.Carrier.SectorMassGap
