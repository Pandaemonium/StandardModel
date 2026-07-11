import Mathlib

/-!
# A family of quadratic selectors for channel refinements

The type-only three-channel fibre is affine. A positive diagonal quadratic
cost selects one point of each scalar fixed-total fibre, but the selected point
depends on three positive channel weights. Thus strict convexity supplies a
canonical section only after a metric on channel space has been chosen.

The completion-of-squares identity below classifies the minimizer exactly. An
explicit equal-weight versus `1,2,3` witness proves that different positive
metrics select different decompositions of the same nonzero total. This is a
positive selector theorem and a negative canonicity control; it does not claim
that either metric is selected by carrier dynamics, positivity, locality, or
information theory.

Provenance: elementary weighted Cauchy identity, formalized for the Paper F
classification program. Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily

noncomputable section

set_option maxHeartbeats 2000000

/-- Positive diagonal resource cost for three scalar channels. -/
def quadraticCost (a b c x y z : Real) : Real :=
  a * x ^ 2 + b * y ^ 2 + c * z ^ 2

/-- Denominator controlling the weighted barycentric minimizer. -/
def weightDenom (a b c : Real) : Real := a * b + a * c + b * c

/-- Exact weighted completion of squares. -/
theorem weighted_completion_identity (a b c x y z : Real) :
    weightDenom a b c * quadraticCost a b c x y z
      - a * b * c * (x + y + z) ^ 2
      = c * (a * x - b * y) ^ 2
        + b * (a * x - c * z) ^ 2
        + a * (b * y - c * z) ^ 2 := by
  simp only [weightDenom, quadraticCost]
  ring

/-- Positive weights give the sharp weighted lower bound. -/
theorem weighted_cost_lower_bound {a b c x y z : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    a * b * c * (x + y + z) ^ 2
      <= weightDenom a b c * quadraticCost a b c x y z := by
  have hxy : 0 <= c * (a * x - b * y) ^ 2 :=
    mul_nonneg hc.le (sq_nonneg _)
  have hxz : 0 <= b * (a * x - c * z) ^ 2 :=
    mul_nonneg hb.le (sq_nonneg _)
  have hyz : 0 <= a * (b * y - c * z) ^ 2 :=
    mul_nonneg ha.le (sq_nonneg _)
  rw [sub_nonneg.symm]
  rw [weighted_completion_identity]
  positivity

/-- The first coordinate of the weighted barycentric selector. -/
def selectedX (a b c s : Real) : Real := b * c * s / weightDenom a b c

/-- The second coordinate of the weighted barycentric selector. -/
def selectedY (a b c s : Real) : Real := a * c * s / weightDenom a b c

/-- The third coordinate of the weighted barycentric selector. -/
def selectedZ (a b c s : Real) : Real := a * b * s / weightDenom a b c

theorem weightDenom_pos {a b c : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    0 < weightDenom a b c := by
  simp only [weightDenom]
  positivity

/-- The selected coordinates have the prescribed total. -/
theorem selected_sum {a b c s : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    selectedX a b c s + selectedY a b c s + selectedZ a b c s = s := by
  have hD := (weightDenom_pos ha hb hc).ne'
  simp only [selectedX, selectedY, selectedZ]
  simp only [weightDenom] at hD ⊢
  field_simp [hD]
  ring

/-- At the selected point all three weighted channel amplitudes agree. -/
theorem selected_balanced {a b c s : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c) :
    a * selectedX a b c s = b * selectedY a b c s
      ∧ a * selectedX a b c s = c * selectedZ a b c s := by
  have hD := (weightDenom_pos ha hb hc).ne'
  simp only [selectedX, selectedY, selectedZ]
  constructor <;> field_simp [hD]

/-- Equality in the sharp bound forces weighted balance. -/
theorem balanced_of_cost_equality {a b c x y z : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c)
    (heq : weightDenom a b c * quadraticCost a b c x y z
      = a * b * c * (x + y + z) ^ 2) :
    a * x = b * y ∧ a * x = c * z := by
  have hxy : 0 <= c * (a * x - b * y) ^ 2 :=
    mul_nonneg hc.le (sq_nonneg _)
  have hxz : 0 <= b * (a * x - c * z) ^ 2 :=
    mul_nonneg hb.le (sq_nonneg _)
  have hyz : 0 <= a * (b * y - c * z) ^ 2 :=
    mul_nonneg ha.le (sq_nonneg _)
  have hsum :
      c * (a * x - b * y) ^ 2
        + b * (a * x - c * z) ^ 2
        + a * (b * y - c * z) ^ 2 = 0 := by
    rw [← weighted_completion_identity]
    linarith
  have hxy0 : (a * x - b * y) ^ 2 = 0 := by nlinarith
  have hxz0 : (a * x - c * z) ^ 2 = 0 := by nlinarith
  constructor <;> nlinarith

/-- The weighted barycentric point is the unique minimizer on a fixed-total
fibre. The premise is phrased as cost no larger than the selected cost, so the
theorem packages both minimality and uniqueness without differentiability. -/
theorem selected_unique_of_cost_le {a b c s x y z : Real}
    (ha : 0 < a) (hb : 0 < b) (hc : 0 < c)
    (hsum : x + y + z = s)
    (hcost : quadraticCost a b c x y z
      <= quadraticCost a b c (selectedX a b c s)
        (selectedY a b c s) (selectedZ a b c s)) :
    x = selectedX a b c s
      ∧ y = selectedY a b c s
      ∧ z = selectedZ a b c s := by
  have hDpos := weightDenom_pos ha hb hc
  have hselectedSum := selected_sum (s := s) ha hb hc
  have hselectedBalanced := selected_balanced (s := s) ha hb hc
  have hselectedEq :
      weightDenom a b c *
          quadraticCost a b c (selectedX a b c s)
            (selectedY a b c s) (selectedZ a b c s)
        = a * b * c * s ^ 2 := by
    rcases hselectedBalanced with ⟨hxy, hxz⟩
    have hyz : b * selectedY a b c s = c * selectedZ a b c s := hxy.symm.trans hxz
    have dxy : a * selectedX a b c s - b * selectedY a b c s = 0 :=
      sub_eq_zero.mpr hxy
    have dxz : a * selectedX a b c s - c * selectedZ a b c s = 0 :=
      sub_eq_zero.mpr hxz
    have dyz : b * selectedY a b c s - c * selectedZ a b c s = 0 :=
      sub_eq_zero.mpr hyz
    have hid := weighted_completion_identity a b c
      (selectedX a b c s) (selectedY a b c s) (selectedZ a b c s)
    rw [dxy, dxz, dyz] at hid
    norm_num at hid
    rw [hselectedSum] at hid
    linarith
  have hlower := weighted_cost_lower_bound (x := x) (y := y) (z := z) ha hb hc
  have heq :
      weightDenom a b c * quadraticCost a b c x y z
        = a * b * c * (x + y + z) ^ 2 := by
    rw [hsum] at hlower ⊢
    nlinarith
  obtain ⟨hxy, hxz⟩ := balanced_of_cost_equality ha hb hc heq
  have hDne := hDpos.ne'
  have hyz : b * y = c * z := hxy.symm.trans hxz
  have hxyc := congrArg (fun t : Real => c * t) hxy
  have hxzb := congrArg (fun t : Real => b * t) hxz
  have hsumBC := congrArg (fun t : Real => b * c * t) hsum
  have hxyc' := congrArg (fun t : Real => c * t) hxy
  have hyza := congrArg (fun t : Real => a * t) hyz
  have hsumAC := congrArg (fun t : Real => a * c * t) hsum
  have hxzb' := congrArg (fun t : Real => b * t) hxz
  have hyza' := congrArg (fun t : Real => a * t) hyz
  have hsumAB := congrArg (fun t : Real => a * b * t) hsum
  have hxFormula : x * weightDenom a b c = b * c * s := by
    simp only [weightDenom]
    ring_nf at hxyc hxzb hsumBC ⊢
    nlinarith
  have hyFormula : y * weightDenom a b c = a * c * s := by
    simp only [weightDenom]
    ring_nf at hxyc' hyza hsumAC ⊢
    nlinarith
  have hzFormula : z * weightDenom a b c = a * b * s := by
    simp only [weightDenom]
    ring_nf at hxzb' hyza' hsumAB ⊢
    nlinarith
  simp only [selectedX, selectedY, selectedZ]
  constructor
  · exact (eq_div_iff hDne).2 hxFormula
  constructor
  · exact (eq_div_iff hDne).2 hyFormula
  · exact (eq_div_iff hDne).2 hzFormula

/-- Equal weights select equal thirds of a unit total. -/
theorem equalWeight_selector :
    selectedX 1 1 1 1 = 1 / 3
      ∧ selectedY 1 1 1 1 = 1 / 3
      ∧ selectedZ 1 1 1 1 = 1 / 3 := by
  norm_num [selectedX, selectedY, selectedZ, weightDenom]

/-- The positive weights `1,2,3` select the distinct exact split
`(6/11, 3/11, 2/11)` of the same unit total. -/
theorem unequalWeight_selector :
    selectedX 1 2 3 1 = 6 / 11
      ∧ selectedY 1 2 3 1 = 3 / 11
      ∧ selectedZ 1 2 3 1 = 2 / 11 := by
  norm_num [selectedX, selectedY, selectedZ, weightDenom]

/-- Strict convexity alone does not make the selector metric-independent. -/
theorem positive_quadratic_selectors_disagree :
    (selectedX 1 1 1 1, selectedY 1 1 1 1, selectedZ 1 1 1 1)
      ≠ (selectedX 1 2 3 1, selectedY 1 2 3 1, selectedZ 1 2 3 1) := by
  norm_num [selectedX, selectedY, selectedZ, weightDenom]

/-- Invariance under exchanging the first two channel labels is equivalent to
equality of their diagonal metric weights. -/
theorem swapXY_invariant_iff (a b c : Real) :
    (∀ x y z : Real,
      quadraticCost a b c x y z = quadraticCost a b c y x z) ↔ a = b := by
  constructor
  · intro h
    have hw := h 1 0 0
    norm_num [quadraticCost] at hw
    exact hw
  · intro hab x y z
    simp only [quadraticCost, hab]
    ring

/-- Invariance under exchanging the last two channel labels is equivalent to
equality of their diagonal metric weights. -/
theorem swapYZ_invariant_iff (a b c : Real) :
    (∀ x y z : Real,
      quadraticCost a b c x y z = quadraticCost a b c x z y) ↔ b = c := by
  constructor
  · intro h
    have hw := h 0 1 0
    norm_num [quadraticCost] at hw
    exact hw
  · intro hbc x y z
    simp only [quadraticCost, hbc]
    ring

/-- Full adjacent-swap symmetry forces and is forced by equal weights. -/
theorem full_permutation_invariance_iff (a b c : Real) :
    ((∀ x y z : Real,
        quadraticCost a b c x y z = quadraticCost a b c y x z)
      ∧ (∀ x y z : Real,
        quadraticCost a b c x y z = quadraticCost a b c x z y))
      ↔ a = b ∧ b = c := by
  rw [swapXY_invariant_iff, swapYZ_invariant_iff]

/-- For any nonzero common weight, the symmetric selector formula returns
equal thirds. Its minimizer interpretation additionally requires positivity;
see `positive_symmetric_unique_equal_thirds`. -/
theorem symmetric_weights_select_equal_thirds {a s : Real} (ha : a ≠ 0) :
    selectedX a a a s = s / 3
      ∧ selectedY a a a s = s / 3
      ∧ selectedZ a a a s = s / 3 := by
  simp only [selectedX, selectedY, selectedZ, weightDenom]
  constructor
  · field_simp [ha]
    ring
  constructor <;> field_simp [ha] <;> ring

/-- For a positive fully symmetric metric, equal thirds are the unique global
minimizer on the fixed-total fibre. -/
theorem positive_symmetric_unique_equal_thirds {a s x y z : Real}
    (ha : 0 < a) (hsum : x + y + z = s)
    (hcost : quadraticCost a a a x y z
      <= quadraticCost a a a (s / 3) (s / 3) (s / 3)) :
    x = s / 3 ∧ y = s / 3 ∧ z = s / 3 := by
  obtain ⟨hx, hy, hz⟩ := symmetric_weights_select_equal_thirds ha.ne' (s := s)
  have hcost' : quadraticCost a a a x y z
      <= quadraticCost a a a (selectedX a a a s)
        (selectedY a a a s) (selectedZ a a a s) := by
    simpa [hx, hy, hz] using hcost
  obtain ⟨hxs, hys, hzs⟩ :=
    selected_unique_of_cost_le ha ha ha hsum hcost'
  exact ⟨hxs.trans hx, hys.trans hy, hzs.trans hz⟩

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily.weighted_completion_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms weighted_completion_identity

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily.selected_unique_of_cost_le' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms selected_unique_of_cost_le

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily.positive_quadratic_selectors_disagree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_quadratic_selectors_disagree

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily.full_permutation_invariance_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms full_permutation_invariance_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily.symmetric_weights_select_equal_thirds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms symmetric_weights_select_equal_thirds

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily.positive_symmetric_unique_equal_thirds' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms positive_symmetric_unique_equal_thirds

end

end PhysicsSM.Draft.NullEdge.ChannelQuadraticSelectorFamily
