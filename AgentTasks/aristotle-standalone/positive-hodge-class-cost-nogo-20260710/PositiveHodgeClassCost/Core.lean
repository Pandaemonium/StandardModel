import Mathlib

/-!
# Nilpotent positive-Hodge class cost is representative invariant

This target audits the proposed variational mass over representatives
`h + Q chi`. Under the actual cohomological hypotheses, exact directions are
radical and a commuting spectral operator preserves exactness. Their spectral
pairing therefore vanishes: the cost is constant on the class, not merely
minimized by one representative.

The explicit rational witness uses a nonzero nilpotent `Q`, a degenerate Krein
form whose radical contains `range Q`, a positive surviving class, and spectral
cost `4/25`.
-/

namespace PositiveHodgeClassCost

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- Exact vectors are left- and right-orthogonal to every closed vector. -/
def RadicalProperty (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q : V →ₗ[ℝ] V) : Prop :=
  ∀ y chi : V, Q y = 0 → B y (Q chi) = 0 ∧ B (Q chi) y = 0

/-- Under nilpotence and descent, every exact direction has zero spectral
pairing with itself. -/
theorem exact_spectral_cost_zero
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S) (chi : V) :
    B (Q chi) (S (Q chi)) = 0 := by
  have hclosed : Q (Q chi) = 0 := by
    have h := LinearMap.congr_fun hQQ chi
    simpa using h
  have hSQ : S (Q chi) = Q (S chi) := LinearMap.congr_fun hcomm chi
  rw [hSQ]
  exact (hrad (Q chi) (S chi) hclosed).1

/-- The spectral pairing of a normalized closed eigen-representative is
constant under addition of exact vectors. -/
theorem class_cost_constant
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h : V) (hclosed : Q h = 0) (mu2 : ℝ)
    (heig : S h = mu2 • h) (hnorm : B h h = 1) (chi : V) :
    B (h + Q chi) (S (h + Q chi)) = mu2 := by
  have hsplit :
      B (h + Q chi) (S (h + Q chi)) =
        mu2 + B (Q chi) (S (Q chi)) := by
    have hSQ : S (Q chi) = Q (S chi) := LinearMap.congr_fun hcomm chi
    obtain ⟨_, hr2⟩ := hrad h chi hclosed
    obtain ⟨hr3, _⟩ := hrad h (S chi) hclosed
    rw [map_add S, heig]
    simp only [map_add, map_smul, LinearMap.add_apply, smul_eq_mul, hnorm]
    rw [hSQ, hr3, hr2]
    ring
  rw [hsplit, exact_spectral_cost_zero B Q S hrad hQQ hcomm chi, add_zero]

/-- The set of spectral costs over representatives is exactly a singleton. -/
theorem class_cost_set_eq_singleton
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h : V) (hclosed : Q h = 0) (mu2 : ℝ)
    (heig : S h = mu2 • h) (hnorm : B h h = 1) :
    {c : ℝ | ∃ chi : V, c = B (h + Q chi) (S (h + Q chi))} = {mu2} := by
  ext c
  constructor
  · rintro ⟨chi, rfl⟩
    simpa using class_cost_constant B Q S hrad hQQ hcomm h hclosed mu2 heig hnorm chi
  · intro hc
    have hcmu : c = mu2 := by simpa using hc
    subst c
    exact ⟨0, (class_cost_constant B Q S hrad hQQ hcomm h hclosed mu2 heig hnorm 0).symm⟩

open Matrix in
/-- Degenerate form `diag(0,1,1)`; the exact `e0` direction is radical while
the surviving `e2` class is positive. -/
noncomputable def witnessB :
    (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) →ₗ[ℝ] ℝ :=
  Matrix.toLinearMap₂' ℝ !![(0 : ℝ), 0, 0; 0, 1, 0; 0, 0, 1]

open Matrix in
/-- Nonzero nilpotent differential sending `e1` to `e0`. -/
noncomputable def witnessQ : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(0 : ℝ), 1, 0; 0, 0, 0; 0, 0, 0]

open Matrix in
/-- Spectral operator with cost `4/25` on the surviving `e2` class and zero on
the exact direction. -/
noncomputable def witnessS : (Fin 3 → ℝ) →ₗ[ℝ] (Fin 3 → ℝ) :=
  Matrix.toLin' !![(0 : ℝ), 0, 0; 0, 0, 0; 0, 0, 4 / 25]

/-- Nondegenerate rational fixture for the class-invariant cost theorem. -/
theorem nilpotent_positive_class_witness :
    witnessQ ≠ 0 ∧
      witnessQ ∘ₗ witnessQ = 0 ∧
      RadicalProperty witnessB witnessQ ∧
      witnessS ∘ₗ witnessQ = witnessQ ∘ₗ witnessS ∧
      witnessQ (![0, 0, 1] : Fin 3 → ℝ) = 0 ∧
      witnessS (![0, 0, 1] : Fin 3 → ℝ) =
        (4 / 25 : ℝ) • (![0, 0, 1] : Fin 3 → ℝ) ∧
      witnessB (![0, 0, 1] : Fin 3 → ℝ) (![0, 0, 1] : Fin 3 → ℝ) = 1 ∧
      ∀ chi : Fin 3 → ℝ,
        witnessB ((![0, 0, 1] : Fin 3 → ℝ) + witnessQ chi)
          (witnessS ((![0, 0, 1] : Fin 3 → ℝ) + witnessQ chi)) = 4 / 25 := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · intro hcon
    have h1 := DFunLike.congr_fun hcon (![0, 1, 0] : Fin 3 → ℝ)
    have h2 := congrFun h1 0
    simp [witnessQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_three] at h2
  · unfold witnessQ
    rw [← Matrix.toLin'_mul]
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_three, Matrix.cons_val_two]
  · intro y chi hy
    constructor <;>
      simp [witnessB, witnessQ, Matrix.toLinearMap₂'_apply,
        Matrix.toLin'_apply, dotProduct, Fin.sum_univ_three]
  · unfold witnessQ witnessS
    rw [← Matrix.toLin'_mul, ← Matrix.toLin'_mul]
    congr 1
    ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Matrix.mul_apply, Fin.sum_univ_three, Matrix.cons_val_two]
  · funext i
    fin_cases i <;>
      simp +decide [witnessQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three, Matrix.cons_val_two]
  · funext i
    fin_cases i <;>
      norm_num [witnessS, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
        Fin.sum_univ_three, Matrix.cons_val_zero, Matrix.cons_val_one,
        Matrix.cons_val_two]
  · norm_num [witnessB, Matrix.toLinearMap₂'_apply, Fin.sum_univ_three,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two]
  · intro chi
    simp +decide [witnessB, witnessQ, witnessS, Matrix.toLinearMap₂'_apply,
      Matrix.toLin'_apply, dotProduct, Fin.sum_univ_three,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two]

end PositiveHodgeClassCost
