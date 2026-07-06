import Mathlib

/-!
# The finite matrix-grade Overlap (Neuberger) Dirac operator and Ginsparg–Wilson

This file gives an **honest finite matrix identity** capturing the algebraic core of the
overlap / Ginsparg–Wilson (GW) construction.  It is *not* a full lattice field theory: we
work at "matrix grade", i.e. with `n × n` complex matrices, and isolate the purely
algebraic content of the overlap construction.

## Setup

* `γ₅` is a Hermitian involution: `γ₅ᴴ = γ₅` and `γ₅ * γ₅ = 1`.
* `V` is the **sign** of a Hermitian operator `A`, `V = A |A|⁻¹`.  For an invertible
  Hermitian `A` this sign is itself a Hermitian involution: `Vᴴ = V` and `V * V = 1`.
  We therefore encode `V` abstractly by exactly these two defining properties
  (`hV : Vᴴ = V`, `hv : V * V = 1`); no further structure of `A` is needed for the GW
  algebra.  This is the honest content of `V = A |A|⁻¹`.

## Main definitions

* `overlapD γ₅ V = 1 + γ₅ * V` — the (Neuberger) overlap Dirac operator, in the clean
  normalization for which the massless GW relation holds with lattice spacing `a = 1`.
* `gamma5Hat γ₅ V = γ₅ * (1 - overlapD γ₅ V)` — the deformed chirality matrix `γ̂₅`.

## Main results

* `ginspargWilson`  : `γ₅ D + D γ₅ = D γ₅ D`   (the Ginsparg–Wilson relation).
* `gamma5Hat_involutive` : `γ̂₅ * γ̂₅ = 1`   (exact lattice chiral symmetry: `γ̂₅` is an
  involution).  In fact `γ̂₅ = -V`.
* `overlapD_gamma5_hermitian` : `γ₅ D γ₅ = Dᴴ`   (γ₅-Hermiticity of the overlap operator).

## Concrete example

A concrete `2 × 2` instance with `γ₅ = σ₃` and the explicit sign matrix `V = σ₁`,
for which all of the above are verified (`example_ginspargWilson`,
`example_gamma5Hat_involutive`, `example_overlapD_gamma5_hermitian`).

Only `sorry`-free proofs are used; the axiom footprint is the standard
`propext`, `Classical.choice`, `Quot.sound` (see the `#print axioms` calls at the end).
-/

namespace PhysicsSM.Draft.NullEdge.GateYM.OverlapDirac

open Matrix

section Abstract

variable {n : ℕ}

/-- The overlap (Neuberger) Dirac operator `D = 1 + γ₅ V`, where `V` is the sign of a
Hermitian operator (`V² = 1`).  This is the clean normalization giving the
Ginsparg–Wilson relation with lattice spacing `a = 1`. -/
noncomputable def overlapD (g5 V : Matrix (Fin n) (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ :=
  1 + g5 * V

/-- The deformed chirality matrix `γ̂₅ = γ₅ (1 - D)`. -/
noncomputable def gamma5Hat (g5 V : Matrix (Fin n) (Fin n) ℂ) : Matrix (Fin n) (Fin n) ℂ :=
  g5 * (1 - overlapD g5 V)

/-- **Ginsparg–Wilson relation.**  For a Hermitian involution `γ₅` (`γ₅² = 1`) and a sign
matrix `V` (`V² = 1`), the overlap operator `D = 1 + γ₅ V` satisfies
`γ₅ D + D γ₅ = D γ₅ D`.  (Only the involution properties `γ₅² = 1` and `V² = 1` are
needed; Hermiticity is not.) -/
theorem ginspargWilson (g5 V : Matrix (Fin n) (Fin n) ℂ)
    (hg : g5 * g5 = 1) (hv : V * V = 1) :
    g5 * overlapD g5 V + overlapD g5 V * g5 = overlapD g5 V * g5 * overlapD g5 V := by
  simp only [overlapD, mul_add, add_mul, mul_one, one_mul]
  have e1 : g5 * (g5 * V) = V := by rw [← mul_assoc, hg, one_mul]
  have e2 : g5 * V * g5 * (g5 * V) = g5 := by
    rw [mul_assoc (g5 * V) g5 (g5 * V), ← mul_assoc g5 g5 V, hg, one_mul,
        mul_assoc g5 V V, hv, mul_one]
  rw [e1, e2]
  abel

/-- The deformed chirality matrix collapses to `γ̂₅ = -V`. -/
theorem gamma5Hat_eq_neg (g5 V : Matrix (Fin n) (Fin n) ℂ) (hg : g5 * g5 = 1) :
    gamma5Hat g5 V = -V := by
  simp only [gamma5Hat, overlapD]
  rw [show (1 : Matrix (Fin n) (Fin n) ℂ) - (1 + g5 * V) = -(g5 * V) by abel,
      mul_neg, ← mul_assoc, hg, one_mul]

/-- **Modified (exact lattice) chiral symmetry.**  The deformed chirality matrix
`γ̂₅ = γ₅ (1 - D)` is an involution: `γ̂₅² = 1`. -/
theorem gamma5Hat_involutive (g5 V : Matrix (Fin n) (Fin n) ℂ)
    (hg : g5 * g5 = 1) (hv : V * V = 1) :
    gamma5Hat g5 V * gamma5Hat g5 V = 1 := by
  rw [gamma5Hat_eq_neg g5 V hg, neg_mul_neg, hv]

/-- **γ₅-Hermiticity of the overlap operator.**  For Hermitian `γ₅`, `V` with `γ₅² = 1`,
one has `γ₅ D γ₅ = Dᴴ`. -/
theorem overlapD_gamma5_hermitian (g5 V : Matrix (Fin n) (Fin n) ℂ)
    (hg5 : g5ᴴ = g5) (hV : Vᴴ = V) (hgg : g5 * g5 = 1) :
    g5 * overlapD g5 V * g5 = (overlapD g5 V)ᴴ := by
  simp only [overlapD, conjTranspose_add, conjTranspose_one, conjTranspose_mul, hg5, hV,
    add_mul, mul_add, mul_one]
  rw [← mul_assoc g5 g5 V, hgg, one_mul]

end Abstract

/-! ## Concrete `2 × 2` example: `γ₅ = σ₃`, sign matrix `V = σ₁`. -/

section Example

/-- `γ₅ = σ₃`, a Hermitian involution. -/
def g5₂ : Matrix (Fin 2) (Fin 2) ℂ := !![1, 0; 0, -1]

/-- An explicit sign matrix `V = σ₁` (Hermitian, `V² = 1`). -/
def V₂ : Matrix (Fin 2) (Fin 2) ℂ := !![0, 1; 1, 0]

theorem g5₂_sq : g5₂ * g5₂ = 1 := by
  simp only [g5₂]
  rw [show (1 : Matrix (Fin 2) (Fin 2) ℂ) = !![1, 0; 0, 1] from by simp [Matrix.one_fin_two]]
  norm_num [Matrix.mul_fin_two]

theorem V₂_sq : V₂ * V₂ = 1 := by
  simp only [V₂]
  rw [show (1 : Matrix (Fin 2) (Fin 2) ℂ) = !![1, 0; 0, 1] from by simp [Matrix.one_fin_two]]
  norm_num [Matrix.mul_fin_two]

theorem g5₂_herm : g5₂ᴴ = g5₂ := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [g5₂, Matrix.conjTranspose_apply]

theorem V₂_herm : V₂ᴴ = V₂ := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [V₂, Matrix.conjTranspose_apply]

/-- The explicit overlap operator in this example: `D = !![1, 1; -1, 1]`. -/
theorem overlapD₂_eq : overlapD g5₂ V₂ = !![1, 1; -1, 1] := by
  simp only [overlapD, g5₂, V₂]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.one_fin_two, Matrix.add_apply]

/-- Ginsparg–Wilson relation for the concrete example. -/
theorem example_ginspargWilson :
    g5₂ * overlapD g5₂ V₂ + overlapD g5₂ V₂ * g5₂
      = overlapD g5₂ V₂ * g5₂ * overlapD g5₂ V₂ :=
  ginspargWilson g5₂ V₂ g5₂_sq V₂_sq

/-- Deformed chiral involution for the concrete example. -/
theorem example_gamma5Hat_involutive :
    gamma5Hat g5₂ V₂ * gamma5Hat g5₂ V₂ = 1 :=
  gamma5Hat_involutive g5₂ V₂ g5₂_sq V₂_sq

/-- γ₅-Hermiticity for the concrete example. -/
theorem example_overlapD_gamma5_hermitian :
    g5₂ * overlapD g5₂ V₂ * g5₂ = (overlapD g5₂ V₂)ᴴ :=
  overlapD_gamma5_hermitian g5₂ V₂ g5₂_herm V₂_herm g5₂_sq

end Example

-- Axiom footprint (should be only `propext`, `Classical.choice`, `Quot.sound`):
#print axioms ginspargWilson
#print axioms gamma5Hat_involutive
#print axioms overlapD_gamma5_hermitian
#print axioms example_ginspargWilson
#print axioms example_gamma5Hat_involutive
#print axioms example_overlapD_gamma5_hermitian

end PhysicsSM.Draft.NullEdge.GateYM.OverlapDirac
