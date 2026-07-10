import PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo

/-!
# Positive-Hodge physical-mass conditions and a nondegenerate quartet

The class-cost no-go proves representative invariance but does not by itself
prove that the eigenvalue is well-defined across normalized eigen-representatives
or nonnegative. This module supplies those two conditional theorems and replaces
the degenerate `diag(0,1,1)` evidence fixture with a nondegenerate four-dimensional
Krein quartet.

In the quartet, `Q e1 = e0`; the exact null vector `e0` is orthogonal to every
closed vector but pairs nontrivially with the non-closed partner `e1`. The
surviving `e2` class is positive with decoder value `4/25`, while `e3` supplies
the negative Krein direction. Thus radicality is not obtained by making the
exact direction globally null.

Provenance: direct response to Aristotle Hodge audit
`8e7bf01f-ddf1-479c-95d0-623ebf0bdb08`; clean-room finite construction by
Codex on 2026-07-10.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass

open PhysicsSM.Draft.NullEdge.PositiveHodgeRayleigh
open PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgeClassCostNoGo

variable {V : Type*} [AddCommGroup V] [Module ℝ V]

/-- Two normalized closed eigen-representatives in the same cohomology class
have the same eigenvalue. -/
theorem class_mass_wellDefined
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (Q S : V →ₗ[ℝ] V)
    (hrad : RadicalProperty B Q) (hQQ : Q ∘ₗ Q = 0)
    (hcomm : S ∘ₗ Q = Q ∘ₗ S)
    (h h' : V) (hcl : Q h = 0)
    (mu2 mu2' : ℝ) (heig : S h = mu2 • h)
    (heig' : S h' = mu2' • h')
    (hn : B h h = 1) (hn' : B h' h' = 1)
    (hcohom : ∃ chi, h' = h + Q chi) :
    mu2' = mu2 := by
  rcases hcohom with ⟨chi, rfl⟩
  have hcost :=
    class_cost_constant B Q S hrad hQQ hcomm h hcl mu2 heig hn chi
  have hcost' : B (h + Q chi) (S (h + Q chi)) = mu2' := by
    rw [heig']
    rw [map_smul, hn', smul_eq_mul, mul_one]
  linarith

/-- Positivity of the spectral pairing on a normalized eigen-representative
implies nonnegativity of its mass-squared eigenvalue. -/
theorem class_mass_nonneg
    (B : V →ₗ[ℝ] V →ₗ[ℝ] ℝ) (S : V →ₗ[ℝ] V)
    (h : V) (mu2 : ℝ) (heig : S h = mu2 • h)
    (hn : B h h = 1) (hpos : 0 ≤ B h (S h)) :
    0 ≤ mu2 := by
  rw [heig] at hpos
  simpa [hn] using hpos

abbrev Quartet := Fin 4 → ℝ

open Matrix in
/-- Nondegenerate Krein matrix: a null pair block plus one positive and one
negative physical direction. -/
def quartetBMatrix : Matrix (Fin 4) (Fin 4) ℝ :=
  !![(0 : ℝ), 1, 0, 0;
     1, 0, 0, 0;
     0, 0, 1, 0;
     0, 0, 0, -1]

open Matrix in
noncomputable def quartetB : Quartet →ₗ[ℝ] Quartet →ₗ[ℝ] ℝ :=
  Matrix.toLinearMap₂' ℝ quartetBMatrix

open Matrix in
/-- Nilpotent constraint sending the non-closed partner `e1` to exact `e0`. -/
noncomputable def quartetQ : Quartet →ₗ[ℝ] Quartet :=
  Matrix.toLin' !![(0 : ℝ), 1, 0, 0;
                   0, 0, 0, 0;
                   0, 0, 0, 0;
                   0, 0, 0, 0]

open Matrix in
/-- Decoder with positive class value `4/25` on `e2`. -/
noncomputable def quartetS : Quartet →ₗ[ℝ] Quartet :=
  Matrix.toLin' !![(0 : ℝ), 0, 0, 0;
                   0, 0, 0, 0;
                   0, 0, 4 / 25, 0;
                   0, 0, 0, 0]

open Matrix in
/-- One-parameter decoder family whose positive-class eigenvalue is derived as
`m^2`. This retains the same nondegenerate Krein form and nilpotent constraint
for every scale. -/
noncomputable def quartetSAt (m : ℝ) : Quartet →ₗ[ℝ] Quartet :=
  Matrix.toLin' !![(0 : ℝ), 0, 0, 0;
                   0, 0, 0, 0;
                   0, 0, m ^ 2, 0;
                   0, 0, 0, 0]

def qe0 : Quartet := ![1, 0, 0, 0]
def qe1 : Quartet := ![0, 1, 0, 0]
def qe2 : Quartet := ![0, 0, 1, 0]
def qe3 : Quartet := ![0, 0, 0, 1]

/-- Left nondegeneracy of the quartet pairing. -/
theorem quartetB_left_nondegenerate :
    ∀ x : Quartet, (∀ y : Quartet, quartetB x y = 0) → x = 0 := by
  intro x hx
  funext i
  fin_cases i
  · have h := hx qe1
    simpa [quartetB, quartetBMatrix, qe1, Matrix.toLinearMap₂'_apply,
      Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three] using h
  · have h := hx qe0
    simpa [quartetB, quartetBMatrix, qe0, Matrix.toLinearMap₂'_apply,
      Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three] using h
  · have h := hx qe2
    simpa [quartetB, quartetBMatrix, qe2, Matrix.toLinearMap₂'_apply,
      Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three] using h
  · have h := hx qe3
    simpa [quartetB, quartetBMatrix, qe3, Matrix.toLinearMap₂'_apply,
      Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three] using h

/-- The exact vector is not globally null: it pairs with its non-closed
partner, which excludes the degenerate-witness failure mode. -/
theorem quartet_exact_pairs_nonclosed :
    quartetB qe0 qe1 = 1 ∧ quartetQ qe1 = qe0 ∧ quartetQ qe0 = 0 := by
  constructor
  · norm_num [quartetB, quartetBMatrix, qe0, qe1,
      Matrix.toLinearMap₂'_apply, Fin.sum_univ_four,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.cons_val_three]
  constructor <;>
    funext i <;> fin_cases i <;>
      norm_num [quartetQ, qe0, qe1, Matrix.toLin'_apply, Matrix.mulVec,
        dotProduct, Fin.sum_univ_four, Matrix.cons_val_zero,
        Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartetQ_ne_zero : quartetQ ≠ 0 := by
  intro hzero
  have h := DFunLike.congr_fun hzero qe1
  rw [quartet_exact_pairs_nonclosed.2.1] at h
  have h0 := congrFun h 0
  norm_num [qe0, Matrix.cons_val_zero] at h0

theorem quartetQ_sq : quartetQ ∘ₗ quartetQ = 0 := by
  unfold quartetQ
  rw [← Matrix.toLin'_mul]
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Fin.sum_univ_four, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartet_radical : RadicalProperty quartetB quartetQ := by
  intro y chi hy
  have hy1 : y 1 = 0 := by
    have h := congrFun hy 0
    simpa [quartetQ, Matrix.toLin'_apply, Matrix.mulVec, dotProduct,
      Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
      Matrix.cons_val_two, Matrix.cons_val_three] using h
  constructor <;>
    simp [quartetB, quartetBMatrix, quartetQ, Matrix.toLinearMap₂'_apply,
      Matrix.toLin'_apply, dotProduct, Fin.sum_univ_four, hy1,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.cons_val_two,
      Matrix.cons_val_three]

theorem quartet_commutes :
    quartetS ∘ₗ quartetQ = quartetQ ∘ₗ quartetS := by
  unfold quartetQ quartetS
  rw [← Matrix.toLin'_mul, ← Matrix.toLin'_mul]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Fin.sum_univ_four, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartet_e2_closed : quartetQ qe2 = 0 := by
  funext i
  fin_cases i <;>
    norm_num [quartetQ, qe2, Matrix.toLin'_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_four, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartet_e2_eigen : quartetS qe2 = (4 / 25 : ℝ) • qe2 := by
  funext i
  fin_cases i <;>
    norm_num [quartetS, qe2, Matrix.toLin'_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_four, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartet_e2_positive : quartetB qe2 qe2 = 1 := by
  norm_num [quartetB, quartetBMatrix, qe2, Matrix.toLinearMap₂'_apply,
    Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartet_e3_negative : quartetB qe3 qe3 = -1 := by
  norm_num [quartetB, quartetBMatrix, qe3, Matrix.toLinearMap₂'_apply,
    Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three]

/-- The explicit quartet decoder pairing is globally positive semidefinite even
though the underlying Krein form is nondegenerate and indefinite. -/
theorem quartet_decoder_pairing_formula (x : Quartet) :
    quartetB x (quartetS x) = (4 / 25 : ℝ) * (x 2) ^ 2 := by
  simp [quartetB, quartetBMatrix, quartetS, Matrix.toLinearMap₂'_apply,
    Matrix.toLin'_apply, dotProduct, Fin.sum_univ_four,
    Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three]
  ring

/-- The decoder pairing formula for the full nondegenerate scale family. -/
theorem quartetSAt_decoder_pairing_formula (m : ℝ) (x : Quartet) :
    quartetB x (quartetSAt m x) = m ^ 2 * (x 2) ^ 2 := by
  simp [quartetB, quartetBMatrix, quartetSAt, Matrix.toLinearMap₂'_apply,
    Matrix.toLin'_apply, dotProduct, Fin.sum_univ_four,
    Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three]
  ring

theorem quartetSAt_commutes (m : ℝ) :
    quartetSAt m ∘ₗ quartetQ = quartetQ ∘ₗ quartetSAt m := by
  unfold quartetQ quartetSAt
  rw [← Matrix.toLin'_mul, ← Matrix.toLin'_mul]
  congr 1
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, Fin.sum_univ_four, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

theorem quartetSAt_e2_eigen (m : ℝ) :
    quartetSAt m qe2 = m ^ 2 • qe2 := by
  funext i
  fin_cases i <;>
    norm_num [quartetSAt, qe2, Matrix.toLin'_apply, Matrix.mulVec,
      dotProduct, Fin.sum_univ_four, Matrix.cons_val_zero,
      Matrix.cons_val_one, Matrix.cons_val_two, Matrix.cons_val_three]

/-- Every exact representative of the positive quartet class has cost `m^2`
under the decoder selected by `m`; no separate eigenvalue-equality premise is
required. -/
theorem quartetSAt_class_cost (m : ℝ) (chi : Quartet) :
    quartetB (qe2 + quartetQ chi)
      (quartetSAt m (qe2 + quartetQ chi)) = m ^ 2 := by
  rw [quartetSAt_decoder_pairing_formula]
  simp [qe2, quartetQ, Matrix.toLin'_apply, dotProduct,
    Fin.sum_univ_four, Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.cons_val_two, Matrix.cons_val_three]

/-- The one-parameter family retains nilpotence, nondegeneracy, descent,
positive normalization, a negative Krein direction, and exact class cost. -/
theorem parameterized_nondegenerate_quartet_witness (m : ℝ) :
    quartetQ ≠ 0 ∧
      quartetQ ∘ₗ quartetQ = 0 ∧
      RadicalProperty quartetB quartetQ ∧
      quartetSAt m ∘ₗ quartetQ = quartetQ ∘ₗ quartetSAt m ∧
      quartetQ qe2 = 0 ∧
      quartetSAt m qe2 = m ^ 2 • qe2 ∧
      quartetB qe2 qe2 = 1 ∧
      quartetB qe3 qe3 = -1 ∧
      ∀ chi : Quartet,
        quartetB (qe2 + quartetQ chi)
          (quartetSAt m (qe2 + quartetQ chi)) = m ^ 2 := by
  exact ⟨quartetQ_ne_zero, quartetQ_sq, quartet_radical,
    quartetSAt_commutes m, quartet_e2_closed, quartetSAt_e2_eigen m,
    quartet_e2_positive, quartet_e3_negative, quartetSAt_class_cost m⟩

/-- Two distinct nonzero rational scales rule out a relabeled single-point
fixture: the same quartet architecture realizes both `4/25` and `9/25`. -/
theorem parameterized_quartet_two_scale_control :
    (∀ chi : Quartet,
        quartetB (qe2 + quartetQ chi)
          (quartetSAt (2 / 5) (qe2 + quartetQ chi)) = 4 / 25) ∧
      (∀ chi : Quartet,
        quartetB (qe2 + quartetQ chi)
          (quartetSAt (3 / 5) (qe2 + quartetQ chi)) = 9 / 25) ∧
      (4 / 25 : ℝ) ≠ 9 / 25 := by
  refine ⟨?_, ?_, by norm_num⟩
  · intro chi
    calc
      quartetB (qe2 + quartetQ chi)
          (quartetSAt (2 / 5) (qe2 + quartetQ chi)) = (2 / 5 : ℝ) ^ 2 :=
        quartetSAt_class_cost (2 / 5) chi
      _ = 4 / 25 := by norm_num
  · intro chi
    calc
      quartetB (qe2 + quartetQ chi)
          (quartetSAt (3 / 5) (qe2 + quartetQ chi)) = (3 / 5 : ℝ) ^ 2 :=
        quartetSAt_class_cost (3 / 5) chi
      _ = 9 / 25 := by norm_num

theorem quartet_decoder_pairing_nonneg (x : Quartet) :
    0 ≤ quartetB x (quartetS x) := by
  rw [quartet_decoder_pairing_formula]
  positivity

/-- Every normalized eigenvector of the explicit quartet decoder has
nonnegative eigenvalue. Thus the quartet instantiates the positivity premise of
`class_mass_nonneg`, rather than merely assuming it. -/
theorem quartet_normalized_eigen_mass_nonneg (x : Quartet) (mu2 : ℝ)
    (heig : quartetS x = mu2 • x) (hnorm : quartetB x x = 1) :
    0 ≤ mu2 := by
  exact class_mass_nonneg quartetB quartetS x mu2 heig hnorm
    (quartet_decoder_pairing_nonneg x)

/-- Full nondegenerate nilpotent quartet fixture with one positive physical
class, one negative Krein direction, and exact class cost `4/25`. -/
theorem nondegenerate_quartet_witness :
    quartetQ ≠ 0 ∧
      quartetQ ∘ₗ quartetQ = 0 ∧
      RadicalProperty quartetB quartetQ ∧
      quartetS ∘ₗ quartetQ = quartetQ ∘ₗ quartetS ∧
      quartetQ qe2 = 0 ∧
      quartetS qe2 = (4 / 25 : ℝ) • qe2 ∧
      quartetB qe2 qe2 = 1 ∧
      quartetB qe3 qe3 = -1 ∧
      ∀ chi : Quartet,
        quartetB (qe2 + quartetQ chi)
          (quartetS (qe2 + quartetQ chi)) = 4 / 25 := by
  refine ⟨quartetQ_ne_zero, quartetQ_sq, quartet_radical,
    quartet_commutes, quartet_e2_closed, quartet_e2_eigen,
    quartet_e2_positive, quartet_e3_negative, ?_⟩
  intro chi
  exact class_cost_constant quartetB quartetQ quartetS quartet_radical
    quartetQ_sq quartet_commutes qe2 quartet_e2_closed (4 / 25)
    quartet_e2_eigen quartet_e2_positive chi

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.class_mass_wellDefined' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms class_mass_wellDefined

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.class_mass_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms class_mass_nonneg

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.nondegenerate_quartet_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nondegenerate_quartet_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.quartet_normalized_eigen_mass_nonneg' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quartet_normalized_eigen_mass_nonneg

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.parameterized_nondegenerate_quartet_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parameterized_nondegenerate_quartet_witness

/-- info: 'PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass.parameterized_quartet_two_scale_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms parameterized_quartet_two_scale_control

end PhysicsSM.Draft.NullEdge.Carrier.PositiveHodgePhysicalMass
