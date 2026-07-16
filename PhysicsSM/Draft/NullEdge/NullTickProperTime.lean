import Mathlib

/-!
# Aggregate proper time from null ticks in 1+1 dimensions

This module formalizes the elementary special-relativistic kinematics of a
history made from right- and left-moving null ticks. If `nPlus` and `nMinus`
count ticks of coordinate duration `epsilon`, then the endpoint displacement is

```text
t = epsilon * (nPlus + nMinus),
x = epsilon * (nPlus - nMinus),
t^2 - x^2 = 4 * epsilon^2 * nPlus * nMinus.
```

Thus one-directional support has a null endpoint displacement, support in both
directions has a timelike endpoint displacement, and balanced populations
maximize endpoint proper time at fixed coordinate duration.

The result concerns the Lorentzian norm of the aggregate endpoint
displacement. It does not assign positive proper time to an individual null
segment or corner, and it does not depend on the ordering or number of
direction reversals within a history.

Convention: signature `(+,-)` and units `c = 1`.
-/

namespace PhysicsSM.Draft.NullEdge.NullTickProperTime

/-- Coordinate time of a two-direction null-tick history. -/
def coordinateTime (epsilon : ℝ) (nPlus nMinus : ℕ) : ℝ :=
  epsilon * ((nPlus : ℝ) + (nMinus : ℝ))

/-- Coordinate displacement of a two-direction null-tick history. -/
def coordinateSpace (epsilon : ℝ) (nPlus nMinus : ℕ) : ℝ :=
  epsilon * ((nPlus : ℝ) - (nMinus : ℝ))

/-- Endpoint coordinate velocity in units `c = 1`. -/
noncomputable def coordinateVelocity (nPlus nMinus : ℕ) : ℝ :=
  ((nPlus : ℝ) - (nMinus : ℝ)) /
    ((nPlus : ℝ) + (nMinus : ℝ))

/-- Squared endpoint proper time, equivalently the squared `(+,-)` interval. -/
def endpointProperTimeSq (epsilon : ℝ) (nPlus nMinus : ℕ) : ℝ :=
  coordinateTime epsilon nPlus nMinus ^ 2 -
    coordinateSpace epsilon nPlus nMinus ^ 2

/-- **Null-tick endpoint formula.** Aggregate endpoint proper time comes from
the cross term between the two null directions. -/
theorem endpointProperTimeSq_eq
    (epsilon : ℝ) (nPlus nMinus : ℕ) :
    endpointProperTimeSq epsilon nPlus nMinus =
      4 * epsilon ^ 2 * (nPlus : ℝ) * (nMinus : ℝ) := by
  simp only [endpointProperTimeSq, coordinateTime, coordinateSpace]
  ring

/-- For a nonempty history, endpoint space displacement is velocity times
coordinate time. -/
theorem coordinateVelocity_mul_coordinateTime
    (epsilon : ℝ) (nPlus nMinus : ℕ)
    (hTicks : 0 < nPlus + nMinus) :
    coordinateVelocity nPlus nMinus * coordinateTime epsilon nPlus nMinus =
      coordinateSpace epsilon nPlus nMinus := by
  unfold coordinateVelocity coordinateTime coordinateSpace
  have hDenominator : (nPlus : ℝ) + (nMinus : ℝ) ≠ 0 := by
    exact_mod_cast (Nat.ne_of_gt hTicks)
  calc
    (((nPlus : ℝ) - (nMinus : ℝ)) /
          ((nPlus : ℝ) + (nMinus : ℝ))) *
        (epsilon * ((nPlus : ℝ) + (nMinus : ℝ))) =
      epsilon * ((((nPlus : ℝ) - (nMinus : ℝ)) /
        ((nPlus : ℝ) + (nMinus : ℝ))) *
          ((nPlus : ℝ) + (nMinus : ℝ))) := by ac_rfl
    _ = epsilon * ((nPlus : ℝ) - (nMinus : ℝ)) := by
      rw [div_mul_cancel₀ _ hDenominator]

/-- **Time-dilation identity.** For every nonempty history, the null-tick
endpoint interval obeys `tau^2 = t^2 * (1 - v^2)`. -/
theorem endpointProperTimeSq_eq_time_sq_mul_one_sub_velocity_sq
    (epsilon : ℝ) (nPlus nMinus : ℕ)
    (hTicks : 0 < nPlus + nMinus) :
    endpointProperTimeSq epsilon nPlus nMinus =
      coordinateTime epsilon nPlus nMinus ^ 2 *
        (1 - coordinateVelocity nPlus nMinus ^ 2) := by
  unfold endpointProperTimeSq
  rw [← coordinateVelocity_mul_coordinateTime epsilon nPlus nMinus hTicks]
  ring

/-- With a nonzero tick scale, the endpoint interval is null exactly when the
history uses only one of the two null directions. -/
theorem endpointProperTimeSq_eq_zero_iff
    {epsilon : ℝ} (hEpsilon : epsilon ≠ 0) (nPlus nMinus : ℕ) :
    endpointProperTimeSq epsilon nPlus nMinus = 0 ↔
      nPlus = 0 ∨ nMinus = 0 := by
  rw [endpointProperTimeSq_eq]
  constructor
  · intro h
    rcases mul_eq_zero.mp h with hLeft | hMinus
    · rcases mul_eq_zero.mp hLeft with hCoefficient | hPlus
      · have : (4 : ℝ) * epsilon ^ 2 ≠ 0 :=
          mul_ne_zero (by norm_num) (pow_ne_zero 2 hEpsilon)
        exact (this hCoefficient).elim
      · left
        exact_mod_cast hPlus
    · right
      exact_mod_cast hMinus
  · rintro (hPlus | hMinus)
    · simp [hPlus]
    · simp [hMinus]

/-- With a nonzero tick scale, occupying both null directions makes the
endpoint separation timelike. -/
theorem endpointProperTimeSq_pos_iff
    {epsilon : ℝ} (hEpsilon : epsilon ≠ 0) (nPlus nMinus : ℕ) :
    0 < endpointProperTimeSq epsilon nPlus nMinus ↔
      0 < nPlus ∧ 0 < nMinus := by
  rw [endpointProperTimeSq_eq]
  constructor
  · intro h
    constructor
    · by_contra hNotPos
      have hZero : nPlus = 0 := Nat.eq_zero_of_not_pos hNotPos
      simp [hZero] at h
    · by_contra hNotPos
      have hZero : nMinus = 0 := Nat.eq_zero_of_not_pos hNotPos
      simp [hZero] at h
  · rintro ⟨hPlus, hMinus⟩
    positivity

/-- The coordinate-time square exceeds the endpoint proper-time square by the
squared directional imbalance. -/
theorem coordinateTime_sq_sub_endpointProperTimeSq
    (epsilon : ℝ) (nPlus nMinus : ℕ) :
    coordinateTime epsilon nPlus nMinus ^ 2 -
        endpointProperTimeSq epsilon nPlus nMinus =
      epsilon ^ 2 * ((nPlus : ℝ) - (nMinus : ℝ)) ^ 2 := by
  rw [endpointProperTimeSq_eq]
  simp only [coordinateTime]
  ring

/-- Endpoint proper time never exceeds coordinate time. The nonnegative gap is
the squared directional imbalance from the preceding theorem. -/
theorem endpointProperTimeSq_le_coordinateTime_sq
    (epsilon : ℝ) (nPlus nMinus : ℕ) :
    endpointProperTimeSq epsilon nPlus nMinus ≤
      coordinateTime epsilon nPlus nMinus ^ 2 := by
  rw [← sub_nonneg]
  rw [coordinateTime_sq_sub_endpointProperTimeSq]
  positivity

/-- For nonzero tick scale, endpoint proper time saturates the coordinate-time
bound exactly at balanced right/left occupation. -/
theorem endpointProperTimeSq_eq_coordinateTime_sq_iff
    {epsilon : ℝ} (hEpsilon : epsilon ≠ 0) (nPlus nMinus : ℕ) :
    endpointProperTimeSq epsilon nPlus nMinus =
        coordinateTime epsilon nPlus nMinus ^ 2 ↔
      nPlus = nMinus := by
  constructor
  · intro h
    have hGap :
        epsilon ^ 2 * ((nPlus : ℝ) - (nMinus : ℝ)) ^ 2 = 0 := by
      rw [← coordinateTime_sq_sub_endpointProperTimeSq, h]
      ring
    rcases mul_eq_zero.mp hGap with hScale | hBalance
    · exact ((pow_ne_zero 2 hEpsilon) hScale).elim
    · have hDifference : (nPlus : ℝ) - (nMinus : ℝ) = 0 := by
        nlinarith [sq_nonneg ((nPlus : ℝ) - (nMinus : ℝ))]
      exact_mod_cast (sub_eq_zero.mp hDifference)
  · intro h
    subst nMinus
    rw [endpointProperTimeSq_eq]
    simp only [coordinateTime]
    ring

/-- A concrete two-tick witness has positive aggregate proper time and saturates
the coordinate-time bound. -/
theorem balanced_two_tick_witness :
    endpointProperTimeSq 1 1 1 = 4 ∧
      coordinateTime 1 1 1 ^ 2 = 4 := by
  norm_num [endpointProperTimeSq, coordinateTime, coordinateSpace]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq

/-- info: 'PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq_zero_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq_zero_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq_time_sq_mul_one_sub_velocity_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq_time_sq_mul_one_sub_velocity_sq

/-- info: 'PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_pos_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_pos_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq_coordinateTime_sq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.NullTickProperTime.endpointProperTimeSq_eq_coordinateTime_sq_iff

end PhysicsSM.Draft.NullEdge.NullTickProperTime
