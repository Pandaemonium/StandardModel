/-
# NE-U5, quantitative: binding mass of two equal-energy massless quanta

This file strengthens the qualitative NE-U5 "mass from massless" statement to a
**quantitative, exact, finite** identity.

## Physical setup

Consider two future-null four-momenta of equal energy `E`,

  `p = (E, 𝐮)`,   `q = (E, 𝐰)`,

with `𝐮, 𝐰` the spatial momenta.  Future-null means `p·p = q·q = 0` in the
mostly-minus Minkowski metric `x·x = x₀² - ‖𝐱‖²`, i.e. `‖𝐮‖ = ‖𝐰‖ = E`.
The composite (bound) system carries four-momentum `P = p + q = (2E, 𝐮 + 𝐰)`,
and its invariant mass squared is

  `M² = P·P = (2E)² - ‖𝐮 + 𝐰‖²`.

Writing `θ` for the relative spatial angle between `𝐮` and `𝐰`, we prove the
clean closed form

  `M² = 2 E² (1 - cos θ) = 4 E² sin²(θ/2)`,

so **100 % of the composite mass is a definite function of the binding geometry**
(energy `E` and angle `θ`) while each constituent is individually massless.

We also show `M²` ranges over `[0, 4E²]` as `θ` ranges over `[0, π]`:
- `θ = 0` (collinear): `M = 0`, the composite is again massless;
- `θ = π` (back-to-back): `M² = 4E²`, the maximal binding mass.

This makes "mass = binding energy" a precise finite identity.

## Honesty note

This is a *finite two-body relativistic kinematic identity*, not a derivation of
hadron masses from QCD.  It captures exactly the statement that the invariant
mass of a composite of massless quanta is fixed by their energies and relative
angle, nothing more.

The spatial momenta live in an arbitrary real inner product space `V`; the angle
`θ` is `InnerProductGeometry.angle 𝐮 𝐰`, and `M²` is `compositeMassSq E 𝐮 𝐰`.
-/
import Mathlib

namespace PhysicsSM.Draft.NullEdge.GateI1.BindingMassQuantitative

open InnerProductGeometry Real

variable {V : Type*} [NormedAddCommGroup V] [InnerProductSpace ℝ V]

/-- Invariant mass squared `M² = (2E)² - ‖𝐮 + 𝐰‖²` of the composite of two
equal-energy future-null momenta whose spatial parts are `u` and `w`
(each of Euclidean norm `E`).  The time component of the sum is `2E`, and the
spatial part is `u + w`. -/
noncomputable def compositeMassSq (E : ℝ) (u w : V) : ℝ :=
  (2 * E) ^ 2 - ‖u + w‖ ^ 2

/-- **Closed form (cosine version).**  For two equal-energy future-null momenta
with spatial parts `u`, `w` of norm `E` and relative spatial angle
`θ = angle u w`, the composite invariant mass squared is exactly
`M² = 2 E² (1 - cos θ)`. -/
theorem compositeMassSq_eq (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E) :
    compositeMassSq E u w = 2 * E ^ 2 * (1 - Real.cos (angle u w)) := by
  unfold compositeMassSq
  rw [norm_add_sq_real]
  have hinner : (inner ℝ u w : ℝ) = E ^ 2 * Real.cos (angle u w) := by
    have h := InnerProductGeometry.cos_angle_mul_norm_mul_norm u w
    rw [hu, hw] at h
    nlinarith [h]
  rw [hu, hw, hinner]; ring

/-- **Closed form (half-angle version).**  Equivalently `M² = 4 E² sin²(θ/2)`.
This manifestly nonnegative form makes the range `[0, 4E²]` transparent. -/
theorem compositeMassSq_eq_sin_half (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E) :
    compositeMassSq E u w = 4 * E ^ 2 * Real.sin (angle u w / 2) ^ 2 := by
  rw [compositeMassSq_eq E u w hu hw]
  have h : 1 - Real.cos (angle u w) = 2 * Real.sin (angle u w / 2) ^ 2 := by
    have h2 : Real.cos (2 * (angle u w / 2)) = 1 - 2 * Real.sin (angle u w / 2) ^ 2 := by
      rw [Real.cos_two_mul']
      nlinarith [Real.sin_sq_add_cos_sq (angle u w / 2)]
    rw [show (2 : ℝ) * (angle u w / 2) = angle u w by ring] at h2
    linarith
  rw [h]; ring

/-- **Lower bound.**  The composite invariant mass squared is nonnegative:
`0 ≤ M²`. -/
theorem compositeMassSq_nonneg (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E) :
    0 ≤ compositeMassSq E u w := by
  rw [compositeMassSq_eq_sin_half E u w hu hw]
  positivity

/-- **Upper bound.**  The composite invariant mass squared never exceeds the
back-to-back value: `M² ≤ 4 E²`. -/
theorem compositeMassSq_le (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E) :
    compositeMassSq E u w ≤ 4 * E ^ 2 := by
  rw [compositeMassSq_eq_sin_half E u w hu hw]
  have hs : Real.sin (angle u w / 2) ^ 2 ≤ 1 := by
    nlinarith [Real.sin_sq_add_cos_sq (angle u w / 2), sq_nonneg (Real.cos (angle u w / 2))]
  nlinarith [sq_nonneg E]

/-- **Range.**  Combining the two bounds: `M² ∈ [0, 4E²]`. -/
theorem compositeMassSq_mem_Icc (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E) :
    compositeMassSq E u w ∈ Set.Icc (0 : ℝ) (4 * E ^ 2) :=
  ⟨compositeMassSq_nonneg E u w hu hw, compositeMassSq_le E u w hu hw⟩

/-- **Collinear endpoint (`θ = 0`).**  When the two spatial momenta are aligned
the composite is again massless: `M² = 0`. -/
theorem compositeMassSq_collinear (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E)
    (hθ : angle u w = 0) : compositeMassSq E u w = 0 := by
  rw [compositeMassSq_eq E u w hu hw, hθ]; simp

/-- **Back-to-back endpoint (`θ = π`).**  When the two spatial momenta are
anti-aligned the binding mass is maximal: `M² = 4 E²`. -/
theorem compositeMassSq_antipodal (E : ℝ) (u w : V) (hu : ‖u‖ = E) (hw : ‖w‖ = E)
    (hθ : angle u w = π) : compositeMassSq E u w = 4 * E ^ 2 := by
  rw [compositeMassSq_eq E u w hu hw, hθ]
  rw [Real.cos_pi]; ring

/-! ### Concrete achievability of the endpoints

Taking the spatial line `V = ℝ` we exhibit explicit momenta realizing both
endpoints of the range, confirming that `M²` genuinely attains `0` and `4E²`.
-/

/-- Collinear achievability on the line: for `E > 0`, `u = w = E` gives `M² = 0`. -/
theorem compositeMassSq_collinear_real {E : ℝ} (hE : 0 < E) :
    compositeMassSq E E E = 0 := by
  have hu : ‖(E : ℝ)‖ = E := by rw [Real.norm_eq_abs, abs_of_pos hE]
  refine compositeMassSq_collinear E E E hu hu ?_
  have : angle (E : ℝ) E = 0 := by
    rw [InnerProductGeometry.angle_self (by positivity)]
  exact this

/-- Back-to-back achievability on the line: for `E > 0`, `u = E`, `w = -E`
gives `M² = 4E²`, the top of the range. -/
theorem compositeMassSq_antipodal_real {E : ℝ} (hE : 0 < E) :
    compositeMassSq E E (-E) = 4 * E ^ 2 := by
  have hu : ‖(E : ℝ)‖ = E := by rw [Real.norm_eq_abs, abs_of_pos hE]
  have hw : ‖(-E : ℝ)‖ = E := by rw [norm_neg, Real.norm_eq_abs, abs_of_pos hE]
  refine compositeMassSq_antipodal E E (-E) hu hw ?_
  exact InnerProductGeometry.angle_self_neg_of_nonzero (ne_of_gt hE)

end PhysicsSM.Draft.NullEdge.GateI1.BindingMassQuantitative
