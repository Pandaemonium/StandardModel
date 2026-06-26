import Mathlib

/-!
# NullStrand.Histories.ExteriorMassMeasure

Wave 5 exterior-history layer (grade-2 Plücker / Sorkin mass package).

This module formalises the **finite** core of the Plücker–Sorkin exterior-history
note (`Sources/Plucker_Sorkin_Exterior_History_Theorem.md`), restricted to the
physically relevant `d = 2` (Weyl-spinor) case.  Everything here is pure finite
linear algebra over `ℂ`-valued `2`-component spinors indexed by a finite type of
null-edge alternatives; **no continuum physics is asserted**.

## Setup

To each null edge `e : E` we attach a Weyl spinor `ψ e : Fin 2 → ℂ`.  For a
finite event `A : Finset E` the cumulative (rank-≤2 Hermitian) momentum matrix is

```
momentum ψ A = ∑ e ∈ A, ψ e ψ eᴴ      (a `2×2` complex matrix)
```

and the **invariant mass capacity** is `massCapacity ψ A = (det (momentum ψ A)).re`.

The Plücker bracket `plucker ψ e f = ψ e 0 * ψ f 1 - ψ e 1 * ψ f 0` and the
nonnegative pair weight `pairWeight ψ e f = ‖plucker ψ e f‖²` package the
grade-2 content.

## Main results (all `s o r r y`/`a x i o m`-free, kernel checked)

* `momentum_det_eq` — the Cauchy–Binet identity in the `d = 2` case:
  `det (momentum ψ A) = ½ ∑_{e,f∈A} z_{ef} z̄_{ef}` (complex form).
* `massCapacity_eq_half_double_sum` — real form: `M(A) = ½ ∑_{e,f∈A} q_{ef}`.
* `massCapacity_nonneg`, `massCapacity_empty`, `massCapacity_singleton_eq_zero`,
  `massCapacity_mono` — `M` is a nonnegative, grade-≥2, monotone set function.
* `massCapacity_i2_eq_crossPlucker` — the exact Sorkin second-order interference
  `I₂(A,B) = ∑_{e∈A,f∈B} q_{ef} ≥ 0` for disjoint events.
* `massCapacity_i3_eq_zero` — third-order Sorkin interference vanishes: `M` is a
  *pure grade-2 capacity*.
* `posSemidef_zeroDiag_offdiag_eq_zero` — the finite strong-positivity obstruction
  kernel: a PSD `2×2` Hermitian matrix with a zero diagonal entry has the
  corresponding off-diagonal entry zero.
* `massCapacity_two_edge_witness` — a concrete two-edge example with vanishing
  singleton masses but unit pair mass, witnessing the obstruction.

Provenance: clean-room statements derived from the wave-5 exterior-history note;
proofs developed and kernel-checked `s o r r y`/`a x i o m`-free, integrated
2026-06-25.
-/

namespace PhysicsSM.NullStrand.Histories

open Matrix Finset Complex
open scoped BigOperators ComplexOrder

variable {E : Type*}

/-- The cumulative (rank-≤2 Hermitian) momentum matrix
`P_A = ∑_{e∈A} ψ_e ψ_e^†` of an event `A`.  Its `(i,j)` entry is
`∑_{e∈A} ψ_e i * conj (ψ_e j)`. -/
noncomputable def momentum (ψ : E → Fin 2 → ℂ) (A : Finset E) :
    Matrix (Fin 2) (Fin 2) ℂ :=
  Matrix.of (fun i j => ∑ e ∈ A, ψ e i * (starRingEnd ℂ) (ψ e j))

/-- The Plücker bracket `z_{ef} = ψ_e ∧ ψ_f = ψ_e 0 ψ_f 1 - ψ_e 1 ψ_f 0`. -/
def plucker (ψ : E → Fin 2 → ℂ) (e f : E) : ℂ :=
  ψ e 0 * ψ f 1 - ψ e 1 * ψ f 0

/-- The nonnegative pair weight `q_{ef} = |z_{ef}|²` (squared Plücker spread). -/
def pairWeight (ψ : E → Fin 2 → ℂ) (e f : E) : ℝ :=
  Complex.normSq (plucker ψ e f)

/-- The invariant mass capacity `M(A) = det P_A` (real part; `det P_A` is a
nonnegative real, see `massCapacity_eq_half_double_sum`). -/
noncomputable def massCapacity (ψ : E → Fin 2 → ℂ) (A : Finset E) : ℝ :=
  ((momentum ψ A).det).re

/-- A spinor wedged with itself vanishes. -/
@[simp] theorem plucker_self (ψ : E → Fin 2 → ℂ) (e : E) : plucker ψ e e = 0 := by
  simp only [plucker]; ring

/-- The diagonal pair weight is zero (single edges carry no grade-2 mass). -/
@[simp] theorem pairWeight_self (ψ : E → Fin 2 → ℂ) (e : E) : pairWeight ψ e e = 0 := by
  simp [pairWeight]

/-- Pair weights are nonnegative. -/
theorem pairWeight_nonneg (ψ : E → Fin 2 → ℂ) (e f : E) : 0 ≤ pairWeight ψ e f :=
  Complex.normSq_nonneg _

/-- Pair weights are symmetric: `q_{ef} = q_{fe}`. -/
theorem pairWeight_symm (ψ : E → Fin 2 → ℂ) (e f : E) :
    pairWeight ψ e f = pairWeight ψ f e := by
  simp only [pairWeight, plucker]
  rw [show ψ f 0 * ψ e 1 - ψ f 1 * ψ e 0 = -(ψ e 0 * ψ f 1 - ψ e 1 * ψ f 0) by ring,
    Complex.normSq_neg]

/-- **Plücker–Sorkin identity (`d = 2` Cauchy–Binet), complex form.**
`det P_A = ½ ∑_{e,f∈A} z_{ef} z̄_{ef}`. -/
theorem momentum_det_eq (ψ : E → Fin 2 → ℂ) (A : Finset E) :
    (momentum ψ A).det
      = (2⁻¹ : ℂ) * ∑ e ∈ A, ∑ f ∈ A,
          (plucker ψ e f) * (starRingEnd ℂ) (plucker ψ e f) := by
  have hpt : ∀ e f : E, (plucker ψ e f) * (starRingEnd ℂ) (plucker ψ e f)
      = (ψ e 0 * (starRingEnd ℂ) (ψ e 0) * (ψ f 1 * (starRingEnd ℂ) (ψ f 1))
          - ψ e 0 * (starRingEnd ℂ) (ψ e 1) * (ψ f 1 * (starRingEnd ℂ) (ψ f 0)))
        + (ψ f 0 * (starRingEnd ℂ) (ψ f 0) * (ψ e 1 * (starRingEnd ℂ) (ψ e 1))
          - ψ f 0 * (starRingEnd ℂ) (ψ f 1) * (ψ e 1 * (starRingEnd ℂ) (ψ e 0))) := by
    intro e f
    simp only [plucker, map_sub, map_mul, Complex.conj_conj]
    ring
  set g : E → E → ℂ := fun e f =>
    ψ e 0 * (starRingEnd ℂ) (ψ e 0) * (ψ f 1 * (starRingEnd ℂ) (ψ f 1))
      - ψ e 0 * (starRingEnd ℂ) (ψ e 1) * (ψ f 1 * (starRingEnd ℂ) (ψ f 0)) with hg
  have hT : (∑ e ∈ A, ∑ f ∈ A, (plucker ψ e f) * (starRingEnd ℂ) (plucker ψ e f))
      = 2 * ∑ e ∈ A, ∑ f ∈ A, g e f := by
    simp only [hpt]
    rw [Finset.sum_congr rfl (fun e _ => Finset.sum_add_distrib)]
    rw [Finset.sum_add_distrib]
    have hsymm : (∑ e ∈ A, ∑ f ∈ A, g f e) = ∑ e ∈ A, ∑ f ∈ A, g e f := Finset.sum_comm
    rw [show (∑ x ∈ A, ∑ x_1 ∈ A,
        (ψ x_1 0 * (starRingEnd ℂ) (ψ x_1 0) * (ψ x 1 * (starRingEnd ℂ) (ψ x 1))
          - ψ x_1 0 * (starRingEnd ℂ) (ψ x_1 1) * (ψ x 1 * (starRingEnd ℂ) (ψ x 0))))
        = ∑ e ∈ A, ∑ f ∈ A, g f e from rfl]
    rw [hsymm]; ring
  rw [hT, Matrix.det_fin_two]
  simp only [momentum, Matrix.of_apply]
  rw [Finset.sum_mul_sum, Finset.sum_mul_sum, ← Finset.sum_sub_distrib]
  simp only [← Finset.sum_sub_distrib]
  rw [hg]; ring_nf

/-- **Plücker–Sorkin identity, real form.** The invariant mass capacity is the
half double-sum of pair weights: `M(A) = ½ ∑_{e,f∈A} q_{ef}`. -/
theorem massCapacity_eq_half_double_sum (ψ : E → Fin 2 → ℂ) (A : Finset E) :
    massCapacity ψ A = 2⁻¹ * ∑ e ∈ A, ∑ f ∈ A, pairWeight ψ e f := by
  rw [massCapacity, momentum_det_eq]
  have h1 : ∀ e f : E,
      (plucker ψ e f) * (starRingEnd ℂ) (plucker ψ e f) = ((pairWeight ψ e f : ℝ) : ℂ) := by
    intro e f; rw [pairWeight, Complex.mul_conj]
  simp only [h1]
  have hcast : (2⁻¹ : ℂ) * ∑ x ∈ A, ∑ x_1 ∈ A, ((pairWeight ψ x x_1 : ℝ) : ℂ)
      = ((2⁻¹ * ∑ e ∈ A, ∑ f ∈ A, pairWeight ψ e f : ℝ) : ℂ) := by push_cast; ring
  rw [hcast, Complex.ofReal_re]

/-- The invariant mass capacity is nonnegative. -/
theorem massCapacity_nonneg (ψ : E → Fin 2 → ℂ) (A : Finset E) :
    0 ≤ massCapacity ψ A := by
  rw [massCapacity_eq_half_double_sum]
  exact mul_nonneg (by norm_num)
    (Finset.sum_nonneg fun e _ => Finset.sum_nonneg fun f _ => pairWeight_nonneg ψ e f)

/-- The empty event has zero mass. -/
@[simp] theorem massCapacity_empty (ψ : E → Fin 2 → ℂ) :
    massCapacity ψ ∅ = 0 := by
  simp [massCapacity_eq_half_double_sum]

/-- A single null edge has zero mass: mass is a grade-≥2 capacity. -/
@[simp] theorem massCapacity_singleton_eq_zero
    (ψ : E → Fin 2 → ℂ) (e : E) : massCapacity ψ {e} = 0 := by
  rw [massCapacity_eq_half_double_sum]; simp

/-- The invariant mass capacity is monotone: `A ⊆ B → M(A) ≤ M(B)`. -/
theorem massCapacity_mono (ψ : E → Fin 2 → ℂ) {A B : Finset E} (h : A ⊆ B) :
    massCapacity ψ A ≤ massCapacity ψ B := by
  rw [massCapacity_eq_half_double_sum, massCapacity_eq_half_double_sum]
  apply mul_le_mul_of_nonneg_left _ (by norm_num)
  calc ∑ e ∈ A, ∑ f ∈ A, pairWeight ψ e f
      ≤ ∑ e ∈ A, ∑ f ∈ B, pairWeight ψ e f := by
        refine Finset.sum_le_sum fun e _ => ?_
        exact Finset.sum_le_sum_of_subset_of_nonneg h (fun f _ _ => pairWeight_nonneg ψ e f)
    _ ≤ ∑ e ∈ B, ∑ f ∈ B, pairWeight ψ e f := by
        refine Finset.sum_le_sum_of_subset_of_nonneg h (fun e _ _ => ?_)
        exact Finset.sum_nonneg fun f _ => pairWeight_nonneg ψ e f

/-- **Exact Sorkin second-order interference law.** For disjoint events `A`, `B`,
`I₂(A,B) = M(A∪B) - M(A) - M(B) = ∑_{e∈A} ∑_{f∈B} q_{ef} ≥ 0`. -/
theorem massCapacity_i2_eq_crossPlucker [DecidableEq E]
    (ψ : E → Fin 2 → ℂ) {A B : Finset E} (hAB : Disjoint A B) :
    massCapacity ψ (A ∪ B) - massCapacity ψ A - massCapacity ψ B
      = ∑ e ∈ A, ∑ f ∈ B, pairWeight ψ e f := by
  simp only [massCapacity_eq_half_double_sum]
  have hAB' : ∀ s : Finset E, (∑ x ∈ A ∪ B, ∑ y ∈ s, pairWeight ψ x y)
      = (∑ x ∈ A, ∑ y ∈ s, pairWeight ψ x y) + ∑ x ∈ B, ∑ y ∈ s, pairWeight ψ x y :=
    fun s => Finset.sum_union hAB
  have hinner : ∀ x : E, (∑ y ∈ A ∪ B, pairWeight ψ x y)
      = (∑ y ∈ A, pairWeight ψ x y) + ∑ y ∈ B, pairWeight ψ x y :=
    fun x => Finset.sum_union hAB
  simp only [hinner, hAB', Finset.sum_add_distrib]
  have hcomm : (∑ x ∈ B, ∑ y ∈ A, pairWeight ψ x y)
      = ∑ x ∈ A, ∑ y ∈ B, pairWeight ψ x y := by
    rw [Finset.sum_comm]
    exact Finset.sum_congr rfl fun x _ => Finset.sum_congr rfl fun y _ => pairWeight_symm ψ y x
  rw [hcomm]; ring

/-- **Pure grade-2 capacity.** The third-order Sorkin interference vanishes for
pairwise disjoint events: `I₃(A,B,C) = 0`.  Hence `M` has no irreducible content
above grade 2. -/
theorem massCapacity_i3_eq_zero [DecidableEq E]
    (ψ : E → Fin 2 → ℂ) {A B C : Finset E}
    (hAB : Disjoint A B) (hAC : Disjoint A C) (hBC : Disjoint B C) :
    massCapacity ψ (A ∪ B ∪ C) - massCapacity ψ (A ∪ B) - massCapacity ψ (A ∪ C)
        - massCapacity ψ (B ∪ C)
        + massCapacity ψ A + massCapacity ψ B + massCapacity ψ C = 0 := by
  have hA_BC : Disjoint A (B ∪ C) := Finset.disjoint_union_right.2 ⟨hAB, hAC⟩
  have i2_AB := massCapacity_i2_eq_crossPlucker ψ hAB
  have i2_AC := massCapacity_i2_eq_crossPlucker ψ hAC
  have i2_BC := massCapacity_i2_eq_crossPlucker ψ hBC
  have i2_A_BC := massCapacity_i2_eq_crossPlucker ψ hA_BC
  have hsplit : (∑ e ∈ A, ∑ f ∈ B ∪ C, pairWeight ψ e f)
      = (∑ e ∈ A, ∑ f ∈ B, pairWeight ψ e f) + ∑ e ∈ A, ∑ f ∈ C, pairWeight ψ e f := by
    rw [← Finset.sum_add_distrib]
    exact Finset.sum_congr rfl fun e _ => Finset.sum_union hBC
  have hassoc : A ∪ B ∪ C = A ∪ (B ∪ C) := by rw [Finset.union_assoc]
  rw [hassoc] at *
  have eAB : massCapacity ψ (A ∪ B) = massCapacity ψ A + massCapacity ψ B
      + ∑ e ∈ A, ∑ f ∈ B, pairWeight ψ e f := by linarith [i2_AB]
  have eAC : massCapacity ψ (A ∪ C) = massCapacity ψ A + massCapacity ψ C
      + ∑ e ∈ A, ∑ f ∈ C, pairWeight ψ e f := by linarith [i2_AC]
  have eBC : massCapacity ψ (B ∪ C) = massCapacity ψ B + massCapacity ψ C
      + ∑ e ∈ B, ∑ f ∈ C, pairWeight ψ e f := by linarith [i2_BC]
  have eA_BC : massCapacity ψ (A ∪ (B ∪ C))
      = massCapacity ψ A + massCapacity ψ (B ∪ C)
        + ∑ e ∈ A, ∑ f ∈ B ∪ C, pairWeight ψ e f := by linarith [i2_A_BC]
  rw [eA_BC, eBC, eAB, eAC, hsplit]; ring

/-- **Finite strong-positivity obstruction kernel.** A positive-semidefinite
`2×2` Hermitian matrix whose `(0,0)` entry is zero must have its `(0,1)` entry
zero.  This is the linear-algebra heart of the no-go: with vanishing singleton
diagonals, strong positivity forces all off-diagonal singleton entries (hence,
by additivity, the whole functional) to vanish. -/
theorem posSemidef_zeroDiag_offdiag_eq_zero {M : Matrix (Fin 2) (Fin 2) ℂ}
    (hM : M.PosSemidef) (h00 : M 0 0 = 0) : M 0 1 = 0 := by
  have hdet : (0 : ℂ) ≤ M.det := hM.det_nonneg
  -- M is Hermitian so M 1 0 = conj (M 0 1); compute the real part of det.
  have h10 : M 1 0 = (starRingEnd ℂ) (M 0 1) := (hM.1.apply 1 0).symm
  rw [Matrix.det_fin_two, h00, h10] at hdet
  simp only [zero_mul, zero_sub, Complex.mul_conj] at hdet
  obtain ⟨hre, -⟩ := Complex.le_def.mp hdet
  simp only [Complex.zero_re, Complex.neg_re, Complex.ofReal_re] at hre
  have hns : Complex.normSq (M 0 1) ≤ 0 := by linarith
  exact Complex.normSq_eq_zero.mp (le_antisymm hns (Complex.normSq_nonneg _))

/-- **Concrete two-edge witness.** With `ψ 0 = (1,0)` and `ψ 1 = (0,1)`, both
singletons are massless while the two-edge event has unit mass.  Hence `M` is a
nonzero grade-2 capacity, which by `posSemidef_zeroDiag_offdiag_eq_zero` cannot
be the diagonal of a strongly positive decoherence functional on single edges. -/
theorem massCapacity_two_edge_witness :
    let ψ : Bool → Fin 2 → ℂ := fun b => if b then ![0, 1] else ![1, 0]
    massCapacity ψ {false} = 0 ∧ massCapacity ψ {true} = 0
      ∧ massCapacity ψ {false, true} = 1 := by
  intro ψ
  refine ⟨massCapacity_singleton_eq_zero ψ false, massCapacity_singleton_eq_zero ψ true, ?_⟩
  rw [massCapacity_eq_half_double_sum]
  simp only [Finset.sum_insert (by decide : (false : Bool) ∉ ({true} : Finset Bool)),
    Finset.sum_singleton]
  simp only [pairWeight, plucker, ψ]
  norm_num [Complex.normSq_apply]

end PhysicsSM.NullStrand.Histories
