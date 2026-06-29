import PhysicsSM.Draft.NullEdge.GateC1.TetraScalarWilsonSymbol

/-!
# Finite block-diagonal operator gap bridge

This module isolates the Fourier/Parseval part of the Gate C1 proof lane.

It deliberately does not mention tetrahedral geometry, Wilson masses, gamma
matrices, or concrete finite cyclic tori.  It proves the generic theorem:

if a free operator is unitarily block-diagonalized into finite momentum symbols,
and every symbol has a uniform finite-L2 gap, then the free operator has the
same finite-L2 gap.

The concrete rank-4 cyclic tetrahedral translation torus should instantiate the
`UnitaryBlockDiagonalization` interface later.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateC1
namespace FiniteBlockDiagonalGap

open scoped BigOperators
open TetraScalarWilsonSymbol

/-- Finite momentum-block L2 norm squared. -/
def blockL2NormSq {Mom Spin : Type*} [Fintype Mom] [Fintype Spin]
    (Phi : Mom -> Spin -> ℂ) : ℝ :=
  ∑ k : Mom, l2NormSq (Phi k)

/--
Thin interface for a unitary block diagonalization.

`F` is the finite Fourier/block transform.  `parseval` records that it preserves
the chosen finite L2 norm square.  `diagonalizes` records that the free operator
acts blockwise after applying `F`.
-/
structure UnitaryBlockDiagonalization
    (Field Mom Spin : Type*) [Fintype Mom] [Fintype Spin] where
  fieldL2NormSq : Field -> ℝ
  F : Field -> Mom -> Spin -> ℂ
  Hfree : Field -> Field
  Hsym : Mom -> Matrix Spin Spin ℂ
  parseval : ∀ Ψ, fieldL2NormSq Ψ = blockL2NormSq (F Ψ)
  diagonalizes : ∀ Ψ k, F (Hfree Ψ) k = (Hsym k).mulVec (F Ψ k)

/--
Generic operator-gap theorem from a unitary block diagonalization and a
pointwise finite-L2 symbol gap.
-/
theorem operator_gap_of_unitary_block_diagonalization
    {Field Mom Spin : Type*} [Fintype Mom] [Fintype Spin]
    (B : UnitaryBlockDiagonalization Field Mom Spin)
    (gamma : ℝ)
    (hpoint :
      ∀ k : Mom, ∀ psi : Spin -> ℂ,
        gamma * l2NormSq psi ≤ l2NormSq ((B.Hsym k).mulVec psi))
    (Ψ : Field) :
    gamma * B.fieldL2NormSq Ψ ≤ B.fieldL2NormSq (B.Hfree Ψ) := by
  rw [B.parseval Ψ, B.parseval (B.Hfree Ψ)]
  unfold blockL2NormSq
  rw [Finset.mul_sum]
  exact Finset.sum_le_sum (by
    intro k _hk
    simpa [B.diagonalizes Ψ k] using hpoint k (B.F Ψ k))

/-- Existential packaging of
`operator_gap_of_unitary_block_diagonalization`. -/
theorem operator_gap_exists_of_unitary_block_diagonalization
    {Field Mom Spin : Type*} [Fintype Mom] [Fintype Spin]
    (B : UnitaryBlockDiagonalization Field Mom Spin)
    (hpoint :
      ∃ gamma : ℝ, 0 < gamma ∧
        ∀ k : Mom, ∀ psi : Spin -> ℂ,
          gamma * l2NormSq psi ≤ l2NormSq ((B.Hsym k).mulVec psi)) :
    ∃ gamma : ℝ, 0 < gamma ∧
      ∀ Ψ : Field,
        gamma * B.fieldL2NormSq Ψ ≤ B.fieldL2NormSq (B.Hfree Ψ) := by
  rcases hpoint with ⟨gamma, hgamma, hgap⟩
  exact ⟨gamma, hgamma,
    operator_gap_of_unitary_block_diagonalization B gamma hgap⟩

end FiniteBlockDiagonalGap
end GateC1
end NullEdge
end Draft
end PhysicsSM
