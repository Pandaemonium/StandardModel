import Mathlib

/-!
# SCG measure candidate: Gram positivity and the back-reaction criterion

PROOF TARGETS for Aristotle (complete every `sorry`; do NOT change any
statement). Self-contained, Mathlib only.

## Context (not needed for the proofs)

A quantum-measure (decoherence-functional) candidate for a growth dynamics
factorizes into a classical "skeleton" layer with probabilities `P s` and a
quantum "decoration" layer with skeleton-conditional path amplitudes
`A s gamma` (histories `gamma`, with incompatible pairs handled by
`A s gamma = 0`).  The induced history matrix is

    D gamma gamma' = sum_s P s * A s gamma * conj (A s gamma').

Two structural facts make this class well-posed, and they are this package's
targets:

1. **Gram positivity (Lemma 1).**  `D` is positive semidefinite, and so is
   every event-level aggregation `B * D * B^H` - so "strong positivity" of
   the decoherence functional holds for FREE for any candidate built this
   way.
2. **Back-reaction criterion (Lemma 2).**  Deforming the factorization so
   the skeleton weight depends on the decoration pair,
   `D gamma gamma' = A gamma * W gamma gamma' * conj (A gamma')`, the
   deformed matrix is PSD iff the weight kernel `W` is PSD (on the support
   of `A`; stated here in the clean full-support form).  So coupling
   geometry to matter preserves quantum-measure structure exactly when the
   geometry-dependence enters as a PSD (record-overlap) kernel.

## Proof notes (verified by hand; use freely)

* Lemma 1 core: `D = sum_s (P s) • (v_s v_s^H)` with `v_s = A s`; each
  rank-one term is PSD (column-times-conjTranspose,
  `Matrix.posSemidef_self_mul_conjTranspose` on the `H x (Fin 1)` column, or
  the quadratic form directly), nonnegative scalar multiples and sums of PSD
  are PSD.  Alternatively evaluate the quadratic form:
  `star x  dot  (D *v x) = sum_s P s * |c_s|^2` with
  `c_s = sum_gamma conj (x gamma) * A s gamma`.
* Event level: congruence `B * M * B^H` preserves PSD (Mathlib has
  `Matrix.PosSemidef.mul_mul_conjTranspose_same` or prove via the quadratic
  form with `y = B^H *v x`).
* Lemma 2 sufficiency: `deformed W A = diagonal A * W * (diagonal A)^H`
  (entrywise check; `Matrix.diagonal_conjTranspose`), then congruence.
  Equivalently: `deformed W A` is the Hadamard product of `W` with the
  rank-one PSD matrix `(A gamma * conj (A gamma'))` - the Schur product
  theorem also closes it if more convenient.
* Lemma 2 necessity (full support): with all `A gamma != 0`, test the
  quadratic form of `W` at `x` against the quadratic form of `deformed W A`
  at `y gamma = x gamma / conj (A gamma)`; Hermitianness of `W` similarly
  transfers back entrywise (`W gamma gamma' =
  D gamma gamma' / (A gamma * conj (A gamma'))`).

## Deliverables

No `sorry`, no `native_decide`, axiom footprint
`[propext, Classical.choice, Quot.sound]`.  If a statement appears false,
STOP and report rather than weakening it.
-/

noncomputable section

namespace SCGGram

open Matrix
open scoped ComplexOrder

variable {S H E : Type*} [Fintype S] [Fintype H] [Fintype E] [DecidableEq H]

/-- The skeleton-factorized (Gram) decoherence matrix:
`D gamma gamma' = sum_s P s * A s gamma * conj (A s gamma')`. -/
def gramDecoherence (P : S → ℝ) (A : S → H → ℂ) : Matrix H H ℂ :=
  Matrix.of fun γ γ' => ∑ s, (P s : ℂ) * A s γ * (starRingEnd ℂ) (A s γ')

/-- **Lemma 1 (Gram positivity).**  The skeleton-factorized decoherence
matrix of nonnegative skeleton weights is positive semidefinite. -/
theorem gramDecoherence_posSemidef (P : S → ℝ) (hP : ∀ s, 0 ≤ P s)
    (A : S → H → ℂ) :
    (gramDecoherence P A).PosSemidef := by
  sorry

/-- **Lemma 1, event level.**  Every aggregation `B * D * B^H` of a
skeleton-factorized decoherence matrix is positive semidefinite - i.e.
strong positivity on every finite event partition holds for free. -/
theorem gramDecoherence_event_posSemidef (P : S → ℝ) (hP : ∀ s, 0 ≤ P s)
    (A : S → H → ℂ) (B : Matrix E H ℂ) :
    (B * gramDecoherence P A * Bᴴ).PosSemidef := by
  sorry

/-- The back-reaction deformation: skeleton weights depending on the
decoration pair through a kernel `W`,
`D gamma gamma' = A gamma * W gamma gamma' * conj (A gamma')`. -/
def deformed (W : Matrix H H ℂ) (A : H → ℂ) : Matrix H H ℂ :=
  Matrix.of fun γ γ' => A γ * W γ γ' * (starRingEnd ℂ) (A γ')

/-- **Lemma 2, sufficiency.**  A PSD weight kernel yields a PSD deformed
decoherence matrix (congruence by `diagonal A`, or Schur with the rank-one
PSD Hadamard factor). -/
theorem deformed_posSemidef_of_posSemidef (W : Matrix H H ℂ) (A : H → ℂ)
    (hW : W.PosSemidef) :
    (deformed W A).PosSemidef := by
  sorry

/-- **Lemma 2, criterion (full support).**  With `A` nowhere zero, the
deformed decoherence matrix is PSD IFF the weight kernel is PSD: coupling
the skeleton to decorations preserves quantum-measure positivity exactly
when the coupling is a PSD (record-overlap) kernel. -/
theorem deformed_posSemidef_iff (W : Matrix H H ℂ) (A : H → ℂ)
    (hA : ∀ γ, A γ ≠ 0) :
    (deformed W A).PosSemidef ↔ W.PosSemidef := by
  sorry

end SCGGram
