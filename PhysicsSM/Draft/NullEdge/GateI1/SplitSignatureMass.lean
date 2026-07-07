import Mathlib

/-!
# Split-signature mass identity

This module formalizes the Q10-L5 split-signature determinant identity.  For
families of plane vectors `psi i, chi i : Fin 2 -> R`, the determinant of the
rank-one sum

`sum_i psi_i * chi_i^T`

decomposes as a signed sum of independent left/right two-dimensional wedges:

`det = sum_{i < j} wedge psi_i psi_j * wedge chi_i chi_j`.

The explicit two-constituent corollary recovers the split tachyonic witness:
two rank-one determinant-zero constituents can sum to a matrix of determinant
`-1`.

Claim boundary: this is a finite split-signature algebraic witness only.  It
does not prove Lorentzian uniqueness or any continuum signature-selection
theorem.

Provenance: Aristotle project
`3a66e413-069a-4ad9-8f6b-b9452c94700b`
(`ne-q10-l5-split-tachyon-witness-20260707`), clean-room formalization of
`AgentTasks/fable_parallel/Q10_answer.md` L5.
-/

namespace PhysicsSM.Draft.NullEdge.GateI1.SplitSignatureMass

open scoped BigOperators

/-- The antisymmetric wedge, or signed area, of two plane vectors. -/
def wedge (u v : Fin 2 -> ℝ) : ℝ :=
  u 0 * v 1 - u 1 * v 0

@[simp] theorem wedge_self (u : Fin 2 -> ℝ) : wedge u u = 0 := by
  simp [wedge]
  ring

theorem wedge_swap (u v : Fin 2 -> ℝ) : wedge u v = -wedge v u := by
  simp [wedge]
  ring

/-- The soldered rank-one sum `sum_i psi_i chi_i^T` as a `2 x 2` real matrix. -/
noncomputable def outerSum (n : ℕ) (psi chi : Fin n -> Fin 2 -> ℝ) :
    Matrix (Fin 2) (Fin 2) ℝ :=
  Matrix.of (fun a b => ∑ i, psi i a * chi i b)

/-- Split-signature determinant identity for a sum of rank-one `2 x 2` blocks. -/
theorem det_outerSum (n : ℕ) (psi chi : Fin n -> Fin 2 -> ℝ) :
    (outerSum n psi chi).det
      = ∑ j, ∑ i ∈ Finset.Iio j, wedge (psi i) (psi j) * wedge (chi i) (chi j) := by
  have h_sum_symm : ∀ (f : Fin n -> Fin n -> ℝ),
      (∑ x, ∑ y, f x y)
        = (∑ x, ∑ y ∈ Finset.Iio x, (f x y + f y x)) + ∑ x, f x x := by
    intro f
    have hrow : ∀ (x : Fin n),
        ∑ y, f x y
          = ∑ y ∈ Finset.Iio x, f x y + f x x + ∑ y ∈ Finset.Ioi x, f x y := by
      intro x
      have hset : (Finset.univ.erase x : Finset (Fin n))
          = Finset.Iio x ∪ Finset.Ioi x := by
        ext y
        simp only [Finset.mem_erase, Finset.mem_union, Finset.mem_Iio, Finset.mem_Ioi,
          Finset.mem_univ, and_true]
        exact ne_iff_lt_or_gt
      have hdisj : Disjoint (Finset.Iio x) (Finset.Ioi x) :=
        Finset.disjoint_left.mpr fun y hy₁ hy₂ =>
          lt_asymm (Finset.mem_Iio.mp hy₁) (Finset.mem_Ioi.mp hy₂)
      rw [← Finset.sum_erase_add _ _ (Finset.mem_univ x), hset, Finset.sum_union hdisj]
      abel
    have hIoi : (∑ x, ∑ y ∈ Finset.Ioi x, f x y)
        = ∑ x, ∑ y ∈ Finset.Iio x, f y x := by
      rw [Finset.sum_sigma', Finset.sum_sigma']
      apply Finset.sum_nbij' (fun p => (⟨p.2, p.1⟩ : Σ _ : Fin n, Fin n))
        (fun p => (⟨p.2, p.1⟩ : Σ _ : Fin n, Fin n)) <;>
        simp [Finset.mem_sigma, Finset.mem_Iio, Finset.mem_Ioi]
    simp only [hrow, Finset.sum_add_distrib, hIoi]
    ring
  rw [Matrix.det_fin_two]
  simp only [outerSum, Matrix.of_apply]
  rw [Finset.sum_mul_sum, Finset.sum_mul_sum,
    h_sum_symm (fun x y => psi x 0 * chi x 0 * (psi y 1 * chi y 1)),
    h_sum_symm (fun x y => psi x 0 * chi x 1 * (psi y 1 * chi y 0))]
  have hdiag : (∑ x, psi x 0 * chi x 0 * (psi x 1 * chi x 1))
      = ∑ x, psi x 0 * chi x 1 * (psi x 1 * chi x 0) := by
    apply Finset.sum_congr rfl
    intro x _
    ring
  rw [hdiag, add_sub_add_right_eq_sub, ← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro j _
  rw [← Finset.sum_sub_distrib]
  apply Finset.sum_congr rfl
  intro i _
  simp only [wedge]
  ring

/-- Left constituents `(1,0)` and `(0,1)`. -/
def psiWit : Fin 2 -> Fin 2 -> ℝ :=
  ![![1, 0], ![0, 1]]

/-- Right constituents `(0,1)` and `(1,0)`. -/
def chiWit : Fin 2 -> Fin 2 -> ℝ :=
  ![![0, 1], ![1, 0]]

/-- The witness rank-one sum is the anti-diagonal matrix. -/
theorem outerSum_witness :
    outerSum 2 psiWit chiWit = Matrix.of ![![0, 1], ![1, 0]] := by
  ext a b
  fin_cases a <;> fin_cases b <;>
    simp [outerSum, psiWit, chiWit, Fin.sum_univ_two]

/-- The two-constituent split witness has determinant `-1`. -/
theorem det_outerSum_witness :
    (outerSum 2 psiWit chiWit).det = -1 := by
  rw [outerSum_witness, Matrix.det_fin_two]
  norm_num

/-- The explicit witness follows from the general determinant identity. -/
theorem det_outerSum_witness_via_identity :
    (outerSum 2 psiWit chiWit).det = -1 := by
  rw [det_outerSum]
  have h0 : (Finset.Iio (0 : Fin 2)) = ∅ := by decide
  have h1 : (Finset.Iio (1 : Fin 2)) = {0} := by decide
  rw [Fin.sum_univ_two, h0, h1]
  simp [wedge, psiWit, chiWit]

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SplitSignatureMass.det_outerSum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_outerSum

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.SplitSignatureMass.det_outerSum_witness_via_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms det_outerSum_witness_via_identity

end PhysicsSM.Draft.NullEdge.GateI1.SplitSignatureMass
