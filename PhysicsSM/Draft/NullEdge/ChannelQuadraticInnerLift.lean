import Mathlib

/-!
# Inner-product-space lift of the weighted channel selector

This module lifts the scalar positive quadratic selector family to arbitrary
real inner-product channel spaces. It proves an exact weighted completion of
squares, the sharp lower bound, and global uniqueness of the weighted
barycentric minimizer on every fixed-total fibre. Distinct positive metrics
select distinct decompositions of every nonzero total.

This is generic variational infrastructure for Paper F. The inner product and
three channel weights are supplied inputs; no physical Hilbert metric,
positive sector, locality principle, or information monotone is derived here.

Provenance: theorem statements prepared in the overnight Paper F
classification lane and proved by Aristotle project
`c6b52d4a-41ab-470b-b4a9-7965dad75daa`; reviewed and rebuilt locally under
Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelQuadraticInnerLift

noncomputable section

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace Real V]

/-- Positive quadratic resource cost with three supplied channel weights. -/
def quadraticCost (a b c : Real) (x y z : V) : Real :=
  a * ‖x‖ ^ 2 + b * ‖y‖ ^ 2 + c * ‖z‖ ^ 2

def weightDenom (a b c : Real) : Real := a * b + a * c + b * c

def selectedX (a b c : Real) (s : V) : V :=
  (b * c / weightDenom a b c) • s

def selectedY (a b c : Real) (s : V) : V :=
  (a * c / weightDenom a b c) • s

def selectedZ (a b c : Real) (s : V) : V :=
  (a * b / weightDenom a b c) • s

/-- Exact Hilbert-space weighted completion of squares. -/
theorem weighted_completion_identity (a b c : Real) (x y z : V) :
    weightDenom a b c * quadraticCost a b c x y z
      - a * b * c * ‖x + y + z‖ ^ 2
      = c * ‖a • x - b • y‖ ^ 2
        + b * ‖a • x - c • z‖ ^ 2
        + a * ‖b • y - c • z‖ ^ 2 := by
  unfold weightDenom quadraticCost
  norm_num [norm_sub_sq_real, norm_add_sq_real, inner_add_left, inner_add_right,
    inner_smul_left, inner_smul_right]
  ring
  simp +decide [norm_smul, mul_pow]
  ring

/-- Positive weights give the sharp lower bound in every real inner-product
space. -/
theorem weighted_cost_lower_bound {a b c : Real} {x y z : V}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    a * b * c * ‖x + y + z‖ ^ 2
      <= weightDenom a b c * quadraticCost a b c x y z := by
  have h_identity :
      weightDenom a b c * quadraticCost a b c x y z
          - a * b * c * ‖x + y + z‖ ^ 2
        = c * ‖a • x - b • y‖ ^ 2
          + b * ‖a • x - c • z‖ ^ 2
          + a * ‖b • y - c • z‖ ^ 2 :=
    weighted_completion_identity a b c x y z
  nlinarith [show 0 ≤ c * ‖a • x - b • y‖ ^ 2 by positivity,
    show 0 ≤ b * ‖a • x - c • z‖ ^ 2 by positivity,
    show 0 ≤ a * ‖b • y - c • z‖ ^ 2 by positivity]

theorem weightDenom_pos {a b c : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    0 < weightDenom a b c := by
  exact add_pos (add_pos (mul_pos ha hb) (mul_pos ha hc)) (mul_pos hb hc)

/-- The selected vectors have the prescribed total. -/
theorem selected_sum {a b c : Real} (s : V)
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    selectedX a b c s + selectedY a b c s + selectedZ a b c s = s := by
  unfold selectedX selectedY selectedZ
  rw [← add_smul, ← add_smul, ← add_div]
  unfold weightDenom
  ring_nf
  rw [← add_mul, ← add_mul, mul_inv_cancel₀ (by positivity), one_smul]

/-- The selected vectors satisfy weighted balance. -/
theorem selected_balanced {a b c : Real} (s : V) :
    a • selectedX a b c s = b • selectedY a b c s
      ∧ a • selectedX a b c s = c • selectedZ a b c s := by
  unfold selectedX selectedY selectedZ
  ring_nf
  simp +decide [mul_assoc, mul_comm, mul_left_comm, smul_smul]

/-- The weighted barycentric point is the unique minimizer on a fixed-total
fibre, without a differentiability hypothesis. -/
theorem selected_unique_of_cost_le {a b c : Real} {s x y z : V}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c)
    (hsum : x + y + z = s)
    (hcost : quadraticCost a b c x y z
      <= quadraticCost a b c (selectedX a b c s)
        (selectedY a b c s) (selectedZ a b c s)) :
    x = selectedX a b c s
      ∧ y = selectedY a b c s
      ∧ z = selectedZ a b c s := by
  have h_eq : a • x = b • y ∧ a • x = c • z := by
    have h_nonpos :
        c * ‖a • x - b • y‖ ^ 2
            + b * ‖a • x - c • z‖ ^ 2
            + a * ‖b • y - c • z‖ ^ 2 <= 0 := by
      have h_selected :
          weightDenom a b c
              * quadraticCost a b c (selectedX a b c s)
                (selectedY a b c s) (selectedZ a b c s)
            = a * b * c * ‖s‖ ^ 2 := by
        have := selected_sum s ha hb hc
        have := selected_balanced (a := a) (b := b) (c := c) s
        simp_all +decide [selectedX, selectedY, selectedZ, quadraticCost,
          weightDenom]
        simp +decide [norm_smul, mul_pow, mul_assoc, mul_comm, mul_left_comm,
          div_eq_mul_inv]
        field_simp
        ring
      have h_completion := weighted_completion_identity a b c x y z
      exact h_completion ▸ sub_nonpos_of_le (by
        rw [hsum]
        nlinarith [weightDenom_pos ha hb hc])
    have h_zero :
        ‖a • x - b • y‖ = 0
          ∧ ‖a • x - c • z‖ = 0
          ∧ ‖b • y - c • z‖ = 0 :=
      ⟨by contrapose! h_nonpos; positivity,
        by contrapose! h_nonpos; positivity,
        by contrapose! h_nonpos; positivity⟩
    exact ⟨sub_eq_zero.mp (norm_eq_zero.mp h_zero.1),
      sub_eq_zero.mp (norm_eq_zero.mp h_zero.2.1)⟩
  have hy : y = (a / b) • x := by
    have hxy : b • y = a • x := h_eq.1.symm
    rw [div_eq_inv_mul, mul_smul, ← hxy, inv_smul_smul₀ hb.ne']
  have hz : z = (a / c) • x := by
    have hz' : z = (1 / c) • (a • x) := by
      simp +decide [h_eq.2, hc.ne']
    rw [hz', smul_smul, one_div, inv_mul_eq_div]
  have hD : weightDenom a b c ≠ 0 := (weightDenom_pos ha hb hc).ne'
  have hbc : b * c ≠ 0 := by positivity
  have hx : x = (b * c / weightDenom a b c) • s := by
    have key : (weightDenom a b c / (b * c)) • x = s := by
      rw [← hsum, hy, hz, weightDenom,
        show (a * b + a * c + b * c) / (b * c) = 1 + a / b + a / c by
          field_simp
          ring,
        add_smul, add_smul, one_smul]
    rw [← key, smul_smul,
      show b * c / weightDenom a b c * (weightDenom a b c / (b * c)) = 1 by
        field_simp,
      one_smul]
  refine ⟨hx, ?_, ?_⟩
  · rw [hy, hx, selectedY, smul_smul]
    congr 1
    field_simp
  · rw [hz, hx, selectedZ, smul_smul]
    congr 1
    field_simp

/-- The explicit positive metrics `(1,1,1)` and `(1,2,3)` select distinct
decompositions for every nonzero total, so strict convexity does not produce a
metric-independent selector. -/
theorem positive_metrics_disagree {s : V} (hs : s ≠ 0) :
    (selectedX 1 1 1 s, selectedY 1 1 1 s, selectedZ 1 1 1 s)
      ≠ (selectedX 1 2 3 s, selectedY 1 2 3 s, selectedZ 1 2 3 s) := by
  simp +decide [selectedX, selectedY, selectedZ]
  norm_num [weightDenom, hs, smul_right_inj]

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticInnerLift.weighted_completion_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weighted_completion_identity

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticInnerLift.selected_unique_of_cost_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selected_unique_of_cost_le

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticInnerLift.positive_metrics_disagree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_metrics_disagree

end

end PhysicsSM.Draft.NullEdge.ChannelQuadraticInnerLift
