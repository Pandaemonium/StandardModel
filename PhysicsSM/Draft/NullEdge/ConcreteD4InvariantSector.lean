import PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin

/-!
# A concrete anisotropic rank-four sector of the explicit D4 coin

The first four direction channels `(x+,x-,y+,y-)` form an exact invariant
sector of `ExplicitSixChannelCoin.axisBlockCoin`. Its coordinate projector is
idempotent, commutes with the coin, and commutes with every diagonal
momentum-space shift. The four-channel inclusion is injective and intertwines
the concrete `6x6` coin with its `4x4` restriction.

This positive sector theorem is deliberately also a control against overclaim:
the nonzero `z+` channel is annihilated by the projector. The sector is therefore
anisotropic and is not the full `3+1` Clifford/Dirac walk.

Provenance: proofs completed by Aristotle project
`cc870ab1-4d96-4151-b733-0933d2940bf3`; clean-room port through the landed coin
API on 2026-07-10.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector

open PhysicsSM.Draft.NullEdge.D4FiniteUnitaryWalk
open PhysicsSM.Draft.NullEdge.ExplicitSixChannelCoin

abbrev FourDirection := Fin 4
abbrev DirectionSpace := Direction → Complex
abbrev FourSpace := FourDirection → Complex

noncomputable def projector : Coin :=
  fun i j => if i = j ∧ i.val < 4 then 1 else 0

/-- A general diagonal momentum-space shift on the six direction channels. -/
noncomputable def diagonalShift (phase : Direction → Complex) : Coin :=
  fun i j => if i = j then phase i else 0

noncomputable def includeFour (v : FourSpace) : DirectionSpace :=
  fun d => if h : d.val < 4 then v ⟨d.val, h⟩ else 0

noncomputable def fourCoin : Matrix FourDirection FourDirection Complex :=
  fun i j => axisBlockCoin ⟨i.val, Nat.lt_trans i.isLt (by decide)⟩
    ⟨j.val, Nat.lt_trans j.isLt (by decide)⟩

noncomputable def matrixAction {n : ℕ}
    (M : Matrix (Fin n) (Fin n) Complex) (v : Fin n → Complex) :
    Fin n → Complex :=
  fun i => ∑ j, M i j * v j

theorem include_four_injective : Function.Injective includeFour := by
  intro v w hEq
  ext i
  have hi := congr_fun hEq ⟨i.val, Nat.lt_trans i.isLt (by decide)⟩
  simp [includeFour] at hi ⊢
  exact hi

theorem projector_idempotent : projector * projector = projector := by
  ext i j
  simp [projector, Matrix.mul_apply]
  rw [Finset.sum_eq_single j] <;> aesop

theorem projector_commutes_axis_coin :
    projector * axisBlockCoin = axisBlockCoin * projector := by
  ext i j
  simp [projector, axisBlockCoin, Matrix.mul_apply]
  simp [Fin.sum_univ_succ] at *
  fin_cases i <;> fin_cases j <;> simp +decide

theorem projector_commutes_every_diagonal_shift
    (phase : Direction → Complex) :
    projector * diagonalShift phase = diagonalShift phase * projector := by
  ext i j
  simp [projector, diagonalShift, Matrix.mul_apply]
  by_cases h : i = j <;> simp [h]
  · rw [Finset.sum_eq_single j] <;> aesop
  · rw [Finset.sum_eq_zero]
    aesop

/-- The actual explicit coin restricts to the first four direction channels. -/
theorem concrete_coin_intertwines_four_sector (v : FourSpace) :
    matrixAction axisBlockCoin (includeFour v) =
      includeFour (matrixAction fourCoin v) := by
  ext i
  fin_cases i <;> simp +decide [Fin.sum_univ_succ, matrixAction,
    axisBlockCoin, fourCoin, includeFour]

theorem four_sector_has_exact_rank : Module.finrank Complex FourSpace = 4 := by
  simp [FourSpace]

def zPlus : DirectionSpace := fun d => if d = 4 then 1 else 0

/-- The invariant rank-four sector excludes a genuine spatial direction. -/
theorem excluded_z_channel_control :
    zPlus ≠ 0 ∧ matrixAction projector zPlus = 0 := by
  simp [zPlus, funext_iff]
  simp [matrixAction, projector, zPlus]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector.concrete_coin_intertwines_four_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms concrete_coin_intertwines_four_sector

/-- info: 'PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector.excluded_z_channel_control' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms excluded_z_channel_control

end PhysicsSM.Draft.NullEdge.ConcreteD4InvariantSector
