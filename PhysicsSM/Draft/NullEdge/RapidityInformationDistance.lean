import Mathlib

/-!
# Rapidity as information distance on the positive boost slice

Completion of the causal-Bloch-geometry suite.  The parent repository already
carries the Bloch half (mass ratio `m/E = 2 sqrt(det ρ)`, Bloch-ball speed
limit, channel monotonicity).  This package supplies the missing hyperbolic
half on the diagonal boost slice: boosts form a one-parameter group, the
velocity map is `tanh`, the relativistic velocity-addition law is exactly
`tanh` addition, the speed limit is `|tanh| < 1`, rapidity is the
log-coordinate distance on the positive slice, and the invariant mass
(determinant) is boost invariant.

## Convention

The diagonal boost with rapidity `η` acts on light-cone coordinates as
`boost η = !![exp η, 0; 0, exp (-η)]`.  A future-directed 1+1 momentum in
light-cone form is `mom E v = !![E * (1 + v), 0; 0, E * (1 - v)]` with
`det = E² (1 - v²) = m²`.

## Targets

1. `boost_group` — `boost η₁ * boost η₂ = boost (η₁ + η₂)` and
   `boost 0 = 1`: rapidities add.
2. `boost_det_one` — `det (boost η) = 1`.
3. `velocity_addition` — `tanh (η₁ + η₂)` equals the relativistic addition
   of `tanh η₁` and `tanh η₂`: Einstein velocity addition IS `tanh`
   addition on the rapidity line.
4. `speed_limit` — `|tanh η| < 1` for every rapidity: the open Bloch/velocity
   interval is never left.
5. `rapidity_is_log_distance` — the log-coordinate distance between two
   boost matrices on the diagonal slice is exactly the rapidity difference:
   `|Real.log ((boost η₁) 0 0) - Real.log ((boost η₂) 0 0)| = |η₁ - η₂|`.
6. `mass_boost_invariant` — the determinant (invariant mass squared) of a
   light-cone momentum is unchanged by the boost action
   `P ↦ boost η * P * (boost η)ᵀ`, while the momentum itself moves for
   `η ≠ 0` (a nonzero witness is included in the statement).

Honest scope: the diagonal (collinear, 1+1) boost slice with light-cone
coordinates; not the full `SL(2,ℂ)/SU(2) ≅ H³` isometry theorem.  Do not
weaken the statements.  Helper lemmas welcome.  Run the narrow check
`lake env lean RapidityInformationDistance/RapidityDistance.lean` first;
avoid a full lake build until the holes are closed.
Recovered from Aristotle project `f001c5e8-58e6-41b6-8f62-87058d9249cb`; proof bodies verified locally
under the pinned toolchain before porting.
-/

namespace PhysicsSM.Draft.NullEdge.RapidityInformationDistance

open Matrix

/-- The diagonal boost with rapidity `η`, in light-cone coordinates. -/
noncomputable def boost (η : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![Real.exp η, 0; 0, Real.exp (-η)]

/-- A future-directed 1+1 momentum in light-cone coordinates: energy `E`,
velocity `v`. -/
def mom (E v : ℝ) : Matrix (Fin 2) (Fin 2) ℝ :=
  !![E * (1 + v), 0; 0, E * (1 - v)]

/-- Target 1: rapidities add — boosts form a one-parameter group. -/
theorem boost_group (η₁ η₂ : ℝ) :
    boost η₁ * boost η₂ = boost (η₁ + η₂) ∧ boost 0 = 1 := by
  refine ⟨?_, ?_⟩
  · simp only [boost, Matrix.mul_fin_two]
    rw [← Real.exp_add, ← Real.exp_add]
    ring_nf
  · simp only [boost, neg_zero, Real.exp_zero, Matrix.one_fin_two]

/-- Target 2: boosts are unimodular. -/
theorem boost_det_one (η : ℝ) : (boost η).det = 1 := by
  simp [boost, Matrix.det_fin_two_of, ← Real.exp_add]

/-- Target 3: Einstein velocity addition is `tanh` addition. -/
theorem velocity_addition (η₁ η₂ : ℝ) :
    Real.tanh (η₁ + η₂) =
      (Real.tanh η₁ + Real.tanh η₂) / (1 + Real.tanh η₁ * Real.tanh η₂) := by
  have h1 := Real.cosh_pos (x := η₁)
  have h2 := Real.cosh_pos (x := η₂)
  rw [Real.tanh_eq_sinh_div_cosh, Real.tanh_eq_sinh_div_cosh, Real.tanh_eq_sinh_div_cosh,
    Real.sinh_add, Real.cosh_add]
  field_simp

/-- Target 4: the speed limit on the rapidity line. -/
theorem speed_limit (η : ℝ) : |Real.tanh η| < 1 := by
  rw [abs_lt]
  exact ⟨Real.neg_one_lt_tanh η, Real.tanh_lt_one η⟩

/-- Target 5: rapidity is the log-coordinate distance on the diagonal
positive slice. -/
theorem rapidity_is_log_distance (η₁ η₂ : ℝ) :
    |Real.log (boost η₁ 0 0) - Real.log (boost η₂ 0 0)| = |η₁ - η₂| := by
  simp [boost, Real.log_exp]

/-- Target 6: invariant mass is boost invariant while the momentum moves.
The determinant of the boosted momentum equals the determinant of the
momentum (`= E² (1 - v²) = m²`), and the explicit rest momentum `E = 1,
v = 0` genuinely moves under the unit boost. -/
theorem mass_boost_invariant (E v η : ℝ) :
    (boost η * mom E v * (boost η)ᵀ).det = (mom E v).det ∧
      (mom E v).det = E ^ 2 * (1 - v ^ 2) ∧
        boost 1 * mom 1 0 * (boost 1)ᵀ ≠ mom 1 0 := by
  refine ⟨?_, ?_, ?_⟩
  · rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose, boost_det_one]
    ring
  · simp [mom, Matrix.det_fin_two_of]; ring
  · intro h
    have h00 := congrFun (congrFun h 0) 0
    simp [boost, mom, Matrix.mul_apply, Fin.sum_univ_two] at h00
    nlinarith [Real.add_one_le_exp (1:ℝ), h00]

end PhysicsSM.Draft.NullEdge.RapidityInformationDistance

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RapidityInformationDistance.velocity_addition' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RapidityInformationDistance.velocity_addition

/-- info: 'PhysicsSM.Draft.NullEdge.RapidityInformationDistance.mass_boost_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RapidityInformationDistance.mass_boost_invariant
