import PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk

/-!
# An explicit nontrivial coin for the finite D4 null walk

This module replaces the supplied abstract coin in `D4FiniteUnitaryWalk` with a
concrete rational unitary. The six direction channels are grouped into the
three opposite-direction pairs `(x+, x-)`, `(y+, y-)`, and `(z+, z-)`. Each
pair carries the same normalized checkerboard block with straight amplitude
`3/5` and imaginary turn amplitude `4i/5`.

The resulting periodic D4 walk is exactly norm preserving. The controls prove
that the coin is not the identity, genuinely mixes an opposite-direction pair,
and has no cross-axis leakage. This does not exhibit a four-dimensional
coin-invariant Dirac sector; that remains a separate construction problem
forced by the six-versus-four rank obstruction.

Provenance: proof completed by Aristotle project
`f3224799-5cd3-4c8e-ac80-f948ab60ec7d`; clean-room project port on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin

open PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk

abbrev Coin := Matrix Direction Direction Complex

/-- Three identical normalized checkerboard blocks, one for each spatial axis. -/
noncomputable def axisBlockCoin : Coin :=
  fun finish start =>
    if finish.val / 2 = start.val / 2 then
      if finish.val % 2 = start.val % 2 then ((3 / 5 : ℝ) : Complex)
      else I * ((4 / 5 : ℝ) : Complex)
    else 0

/-- The explicit three-axis coin is two-sided unitary. -/
theorem axis_block_coin_unitary : IsUnitary axisBlockCoin := by
  constructor
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp +decide [Fin.sum_univ_six, Matrix.mul_apply, axisBlockCoin]
    all_goals norm_num [Complex.ext_iff, div_eq_mul_inv]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp +decide [Fin.sum_univ_six, Matrix.mul_apply, axisBlockCoin]
    all_goals norm_num [Complex.ext_iff, div_eq_mul_inv]

/-- The explicit coin is nonidentity, mixes `x+` with `x-`, and does not send
the `y+` channel directly into `x+`. -/
theorem axis_block_coin_controls :
    axisBlockCoin ≠ 1 ∧
      axisBlockCoin (0 : Direction) (1 : Direction) =
        I * ((4 / 5 : ℝ) : Complex) ∧
      axisBlockCoin (0 : Direction) (2 : Direction) = 0 := by
  refine' ⟨?_, ?_, ?_⟩ <;> norm_num [Fin.ext_iff, axisBlockCoin]
  intro h
  have h01 := congr_fun (congr_fun h 0) 1
  norm_num [axisBlockCoin] at h01

/-- Squaring one axis block leaves a nonzero off-diagonal amplitude. -/
theorem axis_block_coin_sq_offdiag :
    (axisBlockCoin * axisBlockCoin) (0 : Direction) (1 : Direction) =
      I * ((24 / 25 : ℝ) : Complex) := by
  simp +decide [Fin.sum_univ_six, Matrix.mul_apply, axisBlockCoin]
  norm_num [Complex.ext_iff]

/-- The full explicit coin is not itself a Clifford involution up to any
scalar. This does not rule out all possible invariant restricted sectors. -/
theorem axis_block_coin_sq_ne_scalar (r : Complex) :
    axisBlockCoin * axisBlockCoin ≠ r • (1 : Coin) := by
  intro h
  have h01 := congr_fun (congr_fun h (0 : Direction)) (1 : Direction)
  rw [axis_block_coin_sq_offdiag] at h01
  norm_num [Complex.ext_iff] at h01

/-- The finite periodic D4 null walk with the explicit nontrivial rational coin
is exactly norm preserving. -/
theorem axis_block_walk_preserves_norm {L : ℕ} [NeZero L]
    (psi : State L) :
    inner (walk axisBlockCoin psi) (walk axisBlockCoin psi) = inner psi psi := by
  exact walk_preserves_norm axisBlockCoin axis_block_coin_unitary psi

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin.axis_block_coin_unitary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axis_block_coin_unitary

/-- info: 'PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin.axis_block_coin_controls' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axis_block_coin_controls

/-- info: 'PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin.axis_block_coin_sq_ne_scalar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axis_block_coin_sq_ne_scalar

/-- info: 'PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin.axis_block_walk_preserves_norm' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms axis_block_walk_preserves_norm

end PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin
