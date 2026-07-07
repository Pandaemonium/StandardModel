import Mathlib

/-!
# Q10-L3: Lorentzian transitivity of positive null pairing

This module discharges formalization-ladder item L3 of the Q10
signature-selection memo: in real Lorentzian signature `(1, m)`, positive
pairing of null rays is transitive, with an honest equality/orthogonality
rigidity clause.

We use the coordinate model `ℝ × EuclideanSpace ℝ (Fin m)` with bilinear form
`u_t * v_t - ⟪u_x, v_x⟫` (one timelike direction and `m` spacelike directions).
A vector is null when it pairs to zero with itself.

Main statements:

* `lorentzian_pos_pairing_trans`: for null `u v w`, if `lform u v > 0` and
  `lform v w > 0`, then `lform u w >= 0`.
* `lorentzian_pos_pairing_rigidity`: under the same endpoint hypotheses,
  `lform u w = 0` iff `w` is a scalar multiple of `u`.

The mathematical content is Cauchy-Schwarz on the spatial parts, together with
its equality case realized by a norm-zero computation.

This is the Lorentzian half paired with the split `(2,2)` witnesses in
`SignatureSelection.lean`; it does not by itself claim full dimension or
signature selection.

Provenance: `AgentTasks/fable_parallel/Q10_answer.md`, section 1a and
formalization ladder item L3; Aristotle project `dbe113e5`, task `2ac0c7ea`.
-/

open scoped RealInnerProductSpace

namespace PhysicsSM.Draft.NullEdge.GateI1.Lorentzian

variable {m : ℕ}

/-- A Lorentzian vector: one time coordinate together with `m` spatial ones. -/
abbrev LVec (m : ℕ) := ℝ × EuclideanSpace ℝ (Fin m)

/-- The Lorentzian bilinear form of signature `(1, m)`: `u_t v_t - (u_x . v_x)`. -/
noncomputable def lform (u v : LVec m) : ℝ :=
  u.1 * v.1 - ⟪u.2, v.2⟫

/-- A vector is null when it pairs to zero with itself. -/
def IsNull (u : LVec m) : Prop :=
  lform u u = 0

/-- The form is symmetric. -/
theorem lform_comm (u v : LVec m) : lform u v = lform v u := by
  simp only [lform, mul_comm u.1 v.1, real_inner_comm u.2 v.2]

/-- The form is linear in the second argument under scalar multiplication. -/
theorem lform_smul_right (k : ℝ) (u v : LVec m) :
    lform u (k • v) = k * lform u v := by
  simp only [lform, Prod.smul_fst, Prod.smul_snd, smul_eq_mul, real_inner_smul_right]
  ring

/-- For a null vector, the spatial norm equals the absolute value of the time coordinate. -/
theorem norm_spatial_of_null {u : LVec m} (h : IsNull u) : ‖u.2‖ = |u.1| := by
  rw [← sq_eq_sq₀] <;> norm_num [*, mul_self_pos, inner_self_eq_norm_sq_to_K] at *
  unfold IsNull at h
  unfold lform at h
  norm_num at h
  linarith [real_inner_self_eq_norm_sq u.2]

/-- Positive pairing of null vectors forces their time coordinates to share a nonzero sign. -/
theorem time_prod_pos_of_pos_pairing {u v : LVec m}
    (hu : IsNull u) (hv : IsNull v) (huv : 0 < lform u v) :
    0 < u.1 * v.1 := by
  unfold lform at *
  have h_cauchy_schwarz : |⟪u.2, v.2⟫| ≤ ‖u.2‖ * ‖v.2‖ :=
    abs_real_inner_le_norm _ _
  rw [norm_spatial_of_null hu, norm_spatial_of_null hv] at h_cauchy_schwarz
  cases abs_cases u.1 <;> cases abs_cases v.1 <;>
    nlinarith [abs_le.mp h_cauchy_schwarz]

/-- Positive pairing of null rays is transitive in Lorentzian signature `(1, m)`. -/
theorem lorentzian_pos_pairing_trans {u v w : LVec m}
    (hu : IsNull u) (hv : IsNull v) (hw : IsNull w)
    (huv : 0 < lform u v) (hvw : 0 < lform v w) :
    0 ≤ lform u w := by
  unfold lform at *
  have h_mul : 0 < u.1 * v.1 ∧ 0 < v.1 * w.1 :=
    ⟨time_prod_pos_of_pos_pairing hu hv huv, time_prod_pos_of_pos_pairing hv hw hvw⟩
  have h_norm_eq : ‖u.2‖ * ‖w.2‖ = u.1 * w.1 := by
    rw [norm_spatial_of_null hu, norm_spatial_of_null hw, ← abs_mul]
    cases abs_cases (u.1 * w.1) <;> nlinarith [sq_nonneg v.1]
  linarith [abs_le.mp (abs_real_inner_le_norm u.2 w.2)]

/--
Under the transitivity hypotheses, the endpoint pairing vanishes exactly when
`w` is a scalar multiple of `u`; the boundary of positive-pairing transitivity
is projective collinearity of the endpoint null rays.

The nullity of the intermediate vector `v` is not needed for this rigidity
statement, so it is omitted.  The hypothesis `0 < lform u v` still rules out
the degenerate endpoint `u = 0`.
-/
theorem lorentzian_pos_pairing_rigidity {u v w : LVec m}
    (hu : IsNull u) (hw : IsNull w)
    (huv : 0 < lform u v) (_hvw : 0 < lform v w) :
    lform u w = 0 ↔ ∃ k : ℝ, w = k • u := by
  constructor
  · intro h
    have hu0 : u.1 ≠ 0 := by
      rintro h0
      apply absurd huv
      have h2 : u.2 = 0 := by
        have := norm_spatial_of_null hu
        rw [h0, abs_zero] at this
        exact norm_eq_zero.mp this
      simp [lform, h0, h2]
    refine ⟨w.1 / u.1, ?_⟩
    have hzero : ‖w.1 • u.2 - u.1 • w.2‖ = 0 := by
      have hsq : ‖w.1 • u.2 - u.1 • w.2‖ ^ 2 = 0 := by
        rw [norm_sub_sq_real]
        simp only [norm_smul, real_inner_smul_left, real_inner_smul_right,
          Real.norm_eq_abs]
        rw [show ‖u.2‖ = |u.1| from norm_spatial_of_null hu,
          show ‖w.2‖ = |w.1| from norm_spatial_of_null hw]
        have hinner : ⟪u.2, w.2⟫ = u.1 * w.1 := by
          unfold lform at h
          linarith
        rw [hinner, mul_pow, mul_pow, sq_abs, sq_abs]
        ring
      exact pow_eq_zero_iff (by norm_num) |>.mp hsq
    have heq : w.1 • u.2 = u.1 • w.2 :=
      sub_eq_zero.mp (norm_eq_zero.mp hzero)
    have h2 : w.2 = (w.1 / u.1) • u.2 := by
      rw [div_eq_mul_inv, mul_comm, mul_smul, heq, smul_smul, inv_mul_cancel₀ hu0,
        one_smul]
    refine Prod.ext ?_ ?_
    · show w.1 = (w.1 / u.1) * u.1
      field_simp
    · show w.2 = (w.1 / u.1) • u.2
      exact h2
  · rintro ⟨k, rfl⟩
    show lform u (k • u) = 0
    rw [lform_smul_right]
    unfold IsNull at hu
    rw [hu, mul_zero]

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Lorentzian.lorentzian_pos_pairing_trans' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzian_pos_pairing_trans

/-- info: 'PhysicsSM.Draft.NullEdge.GateI1.Lorentzian.lorentzian_pos_pairing_rigidity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms lorentzian_pos_pairing_rigidity

end PhysicsSM.Draft.NullEdge.GateI1.Lorentzian
