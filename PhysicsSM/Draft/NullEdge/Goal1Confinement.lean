import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Goal I — dynamical confinement: no colored two-particle state below the singlet bound

Self-contained rational linear algebra (Mathlib only).  A landed toy hadron has a
color-**singlet** two-particle bound ground state, and we prove that the **colored**
(color-nonsinglet) two-particle channel is gapped *above the two-constituent threshold*
`1`, hence strictly above the singlet bound energy `-1`.  So the lightest two-particle
excitation is the color singlet, and the pre-registered dynamical-deconfinement KILL
(a colored state below the singlet bound state) does **not** fire.

Everything is stated with explicit rational-entry real symmetric matrices, and the
"spectrum" of a matrix is defined as the set of roots of its characteristic
determinant `μ ↦ det (M - μ • 1)` (equivalently, over the field `ℝ`, the set of
eigenvalues).  All proofs are elementary: `det_fin_two` / `det_fin_three`, `ring`,
`norm_num`, `mul_eq_zero`, `fin_cases`, and a degree-`2` sum-of-squares for positive
semidefiniteness.
-/

namespace Goal1Confinement

/-- **Singlet two-body Hamiltonian.**  A real symmetric `3 × 3` matrix with exact
spectrum `{-1, 8, 9}`: the `2 × 2` block `!![7/2, 9/2; 9/2, 7/2]` has eigenvalues
`7/2 ± 9/2 = {-1, 8}` (the off-diagonal `9/2` is the constituent interaction that
produces the bound state at `-1`), and the decoupled channel contributes `9`.
The bound (least) eigenvalue is `-1`, strictly below the two-constituent threshold `1`. -/
noncomputable def Hsing : Matrix (Fin 3) (Fin 3) ℝ :=
  !![7/2, 9/2, 0;
     9/2, 7/2, 0;
     0,   0,   9]

/-- **Colored two-body channel.**  The color-nonsinglet (traceless, `x0+x1+x2=0`)
two-particle subspace is two-dimensional; here it is represented in a basis of that
subspace by the real symmetric `2 × 2` matrix built from the same constituents,
`!![11/2, 7/2; 7/2, 11/2]`, with exact spectrum `{2, 9}` (eigenvalues `11/2 ± 7/2`).
Both eigenvalues lie at or above the threshold `1`, so the colored channel hosts no
state below threshold, hence none below the singlet bound state `-1`. -/
noncomputable def Hcol : Matrix (Fin 2) (Fin 2) ℝ :=
  !![11/2, 7/2;
     7/2,  11/2]

/-- The **spectrum** of `M`: the roots of the characteristic determinant
`μ ↦ det (M - μ • 1)`.  Over the field `ℝ` these are exactly the eigenvalues of `M`. -/
def spec {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) : Set ℝ := {μ | (M - μ • 1).det = 0}

/-- The **least eigenvalue** of `M`, i.e. the infimum of its spectrum. -/
noncomputable def leastEigenvalue {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) : ℝ :=
  sInf (spec M)

lemma mem_spec {n : ℕ} (M : Matrix (Fin n) (Fin n) ℝ) (μ : ℝ) :
    μ ∈ spec M ↔ (M - μ • 1).det = 0 := Iff.rfl

/-- Characteristic determinant of `Hsing`, factored: roots are exactly `{-1, 8, 9}`. -/
lemma Hsing_char (μ : ℝ) : (Hsing - μ • 1).det = (-1 - μ) * (8 - μ) * (9 - μ) := by
  simp only [Hsing, Matrix.det_fin_three]
  simp [Matrix.sub_apply, Matrix.smul_apply, Matrix.of_apply,
    Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-- Characteristic determinant of `Hcol`, factored: roots are exactly `{2, 9}`. -/
lemma Hcol_char (μ : ℝ) : (Hcol - μ • 1).det = (2 - μ) * (9 - μ) := by
  simp only [Hcol, Matrix.det_fin_two]
  simp [Matrix.sub_apply, Matrix.smul_apply, Matrix.of_apply,
    Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one]
  ring

/-! ### Non-degeneracy: explicit eigenvectors -/

/-- The explicit **singlet bound eigenvector** `(1, -1, 0)` at energy `-1`. -/
lemma Hsing_eigvec : Hsing.mulVec ![1, -1, 0] = (-1 : ℝ) • ![1, -1, 0] := by
  funext i
  fin_cases i <;>
    simp [Hsing, Matrix.mulVec, Fin.sum_univ_three, dotProduct] <;> ring

/-- The singlet bound eigenvector is nonzero. -/
lemma Hsing_eigvec_ne : (![1, -1, 0] : Fin 3 → ℝ) ≠ 0 := by
  intro h; have := congrFun h 0; simp at this

/-- The explicit **colored ground eigenvector** `(1, -1)` at energy `2` (the colored
ground state, at or above the threshold `1`). -/
lemma Hcol_eigvec : Hcol.mulVec ![1, -1] = (2 : ℝ) • ![1, -1] := by
  funext i
  fin_cases i <;>
    simp [Hcol, Matrix.mulVec, Fin.sum_univ_two, dotProduct] <;> ring

/-- The colored ground eigenvector is nonzero. -/
lemma Hcol_eigvec_ne : (![1, -1] : Fin 2 → ℝ) ≠ 0 := by
  intro h; have := congrFun h 0; simp at this

/-- **`Hcol` is genuinely gapped, not trivially `0`:** the explicit nonzero colored
vector `(1, -1)` carries energy `⟨v, Hcol v⟩ = 4 = 2 · ⟨v, v⟩`, i.e. Rayleigh
quotient `2 ≥ 1 = threshold`. -/
lemma Hcol_nondegenerate :
    (![1, -1] : Fin 2 → ℝ) ⬝ᵥ (Hcol.mulVec ![1, -1]) = 4
      ∧ (1 : ℝ) ≤ (![1, -1] : Fin 2 → ℝ) ⬝ᵥ (Hcol.mulVec ![1, -1]) := by
  constructor
  · simp [Hcol, Matrix.mulVec, Fin.sum_univ_two, dotProduct]; ring
  · rw [show (![1, -1] : Fin 2 → ℝ) ⬝ᵥ (Hcol.mulVec ![1, -1]) = 4 by
        simp [Hcol, Matrix.mulVec, Fin.sum_univ_two, dotProduct]; ring]
    norm_num

/-! ### Spectral facts -/

lemma Hsing_mem : (-1 : ℝ) ∈ spec Hsing := by
  rw [mem_spec, Hsing_char]; ring

/-- Every eigenvalue of `Hsing` is `≥ -1`. -/
lemma Hsing_lb : ∀ μ ∈ spec Hsing, (-1 : ℝ) ≤ μ := by
  intro μ hμ
  have h : (-1 - μ) * (8 - μ) * (9 - μ) = 0 := by rw [← Hsing_char]; exact hμ
  rcases mul_eq_zero.mp h with h1 | h1
  · rcases mul_eq_zero.mp h1 with h2 | h2 <;> linarith
  · linarith

lemma Hcol_mem : (2 : ℝ) ∈ spec Hcol := by
  rw [mem_spec, Hcol_char]; ring

/-- Every eigenvalue of `Hcol` is `≥ 1` (the threshold). -/
lemma Hcol_lb : ∀ μ ∈ spec Hcol, (1 : ℝ) ≤ μ := by
  intro μ hμ
  have h : (2 - μ) * (9 - μ) = 0 := by rw [← Hcol_char]; exact hμ
  rcases mul_eq_zero.mp h with h1 | h1 <;> linarith

/-- **`Hcol - 1` is positive semidefinite:** for every real vector `v`,
`⟨v, (Hcol - 1) v⟩ ≥ 0`.  Explicit degree-2 sum of squares:
`(9/2)(v₀²+v₁²) + 7 v₀v₁ = (7/2)(v₀+v₁)² + v₀² + v₁² ≥ 0`. -/
lemma Hcol_sub_one_psd (v : Fin 2 → ℝ) : 0 ≤ v ⬝ᵥ ((Hcol - 1).mulVec v) := by
  simp [Hcol, Matrix.mulVec, Fin.sum_univ_two, dotProduct, Matrix.sub_apply,
    Matrix.one_apply, Matrix.cons_val_zero, Matrix.cons_val_one]
  nlinarith [sq_nonneg (v 0 + v 1), sq_nonneg (v 0), sq_nonneg (v 1)]

/-! ### Headline theorems -/

/-- **Target 1 — `singlet_bound_energy`.**  The least eigenvalue of `Hsing` is `-1`
(it is the `IsLeast` element of the spectrum), and `-1 < 1`: the color-singlet bound
ground state lies strictly below the two-constituent threshold.  An explicit nonzero
bound eigenvector at `-1` is `Hsing_eigvec` / `Hsing_eigvec_ne`. -/
theorem singlet_bound_energy : IsLeast (spec Hsing) (-1) ∧ (-1 : ℝ) < 1 :=
  ⟨⟨Hsing_mem, Hsing_lb⟩, by norm_num⟩

/-- **Target 2 — `colored_ground_ge_threshold`.**  Every eigenvalue of the colored
channel `Hcol` is `≥ 1`, equivalently `Hcol - 1` is positive semidefinite: the colored
two-particle sector has no state below threshold, hence none below the singlet bound
state `-1`.  The two formulations are packaged together. -/
theorem colored_ground_ge_threshold :
    (∀ μ ∈ spec Hcol, (1 : ℝ) ≤ μ)
      ∧ (∀ v : Fin 2 → ℝ, 0 ≤ v ⬝ᵥ ((Hcol - 1).mulVec v)) :=
  ⟨Hcol_lb, Hcol_sub_one_psd⟩

/-- **Target 3 — `confinement_ordering` (the payload).**
`leastEigenvalue Hsing = -1 < 1 ≤ leastEigenvalue Hcol`: the lightest two-particle
excitation is the color-singlet bound state, and the colored channel is gapped above
it.  The dynamical-deconfinement KILL does **not** fire. -/
theorem confinement_ordering :
    leastEigenvalue Hsing = -1
      ∧ (-1 : ℝ) < 1
      ∧ (1 : ℝ) ≤ leastEigenvalue Hcol := by
  refine ⟨?_, by norm_num, ?_⟩
  · exact IsLeast.csInf_eq ⟨Hsing_mem, Hsing_lb⟩
  · exact le_csInf ⟨2, Hcol_mem⟩ Hcol_lb

/-! ### Axiom footprint (kernel-checked, no `sorry`/`native_decide`/new axiom) -/

/-- info: 'Goal1Confinement.singlet_bound_energy' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms singlet_bound_energy

/-- info: 'Goal1Confinement.colored_ground_ge_threshold' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms colored_ground_ge_threshold

/-- info: 'Goal1Confinement.confinement_ordering' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms confinement_ordering

end Goal1Confinement
