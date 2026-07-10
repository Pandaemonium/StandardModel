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
-/

namespace RapidityInformationDistance

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
  sorry

/-- Target 2: boosts are unimodular. -/
theorem boost_det_one (η : ℝ) : (boost η).det = 1 := by
  sorry

/-- Target 3: Einstein velocity addition is `tanh` addition. -/
theorem velocity_addition (η₁ η₂ : ℝ) :
    Real.tanh (η₁ + η₂) =
      (Real.tanh η₁ + Real.tanh η₂) / (1 + Real.tanh η₁ * Real.tanh η₂) := by
  sorry

/-- Target 4: the speed limit on the rapidity line. -/
theorem speed_limit (η : ℝ) : |Real.tanh η| < 1 := by
  sorry

/-- Target 5: rapidity is the log-coordinate distance on the diagonal
positive slice. -/
theorem rapidity_is_log_distance (η₁ η₂ : ℝ) :
    |Real.log (boost η₁ 0 0) - Real.log (boost η₂ 0 0)| = |η₁ - η₂| := by
  sorry

/-- Target 6: invariant mass is boost invariant while the momentum moves.
The determinant of the boosted momentum equals the determinant of the
momentum (`= E² (1 - v²) = m²`), and the explicit rest momentum `E = 1,
v = 0` genuinely moves under the unit boost. -/
theorem mass_boost_invariant (E v η : ℝ) :
    (boost η * mom E v * (boost η)ᵀ).det = (mom E v).det ∧
      (mom E v).det = E ^ 2 * (1 - v ^ 2) ∧
        boost 1 * mom 1 0 * (boost 1)ᵀ ≠ mom 1 0 := by
  sorry

end RapidityInformationDistance
