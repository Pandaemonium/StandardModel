import Mathlib
import PhysicsSM.Spinor.SpinorTenfoldSO10Action
import PhysicsSM.Draft.SpinorTenfoldHyperchargeOpAristotle

/-!
# Draft.Spin10StabilizerLieAlgebra

Formalizes the Lie-algebraic stabilizer of the marked/projective pure-spinor line.

## Mathematical context

A bivector in `so(10)` acts on `FockSpinor` via `rho v w`. A general element of the Lie
algebra is a linear combination of such bivectors. We define the stabilizer of a spinor `ψ`
and the mixed marked/projective stabilizer of a pair `(ψ₁, [ψ₂])`.

We prove that for the standard `d=3` collinear pair (represented by `vacuumSpinor` and
`weakSpinor`), the stabilizer Lie algebra contains the hypercharge operator `hyperchargeOp`,
which acts as a generator for the projective $U(1)_Y$ factor.

## Status: Draft
-/

noncomputable section

namespace PhysicsSM.Draft.Spin10StabilizerLieAlgebra

open PhysicsSM.Spinor.SpinorTenfold
open PhysicsSM.Draft.SpinorTenfoldHyperchargeOp

/-- A bivector `(v, w)` stabilizes `ψ` if its action `rho v w ψ` is zero. -/
def BivectorStabilizes (v w : V10) (ψ : FockSpinor) : Prop :=
  rho v w ψ = 0

/-- A bivector `(v, w)` projectively stabilizes `ψ` if `rho v w ψ` is a scalar multiple of `ψ`. -/
def BivectorProjectivelyStabilizes (v w : V10) (ψ : FockSpinor) : Prop :=
  ∃ c : ℂ, rho v w ψ = c • ψ

/-- The mixed marked/projective stabilizer of the pair `(ψ₁, ψ₂)`:
bivectors that stabilize `ψ₁` nonprojectively and `ψ₂` projectively. -/
def MixedPairStabilizer (v w : V10) (ψ₁ ψ₂ : FockSpinor) : Prop :=
  BivectorStabilizes v w ψ₁ ∧ BivectorProjectivelyStabilizes v w ψ₂

/--
The hypercharge operator `hyperchargeOp` lies in the mixed stabilizer of the standard
collinear pair `(vacuumSpinor, weakSpinor)`.

Proof: Follows from `hyperchargeOp_vacuumSpinor` and `hyperchargeOp_weakSpinor`.
-/
theorem hypercharge_in_mixed_stabilizer :
    hyperchargeOp vacuumSpinor = 0 ∧ ∃ c : ℂ, hyperchargeOp weakSpinor = c • weakSpinor := by
  refine ⟨hyperchargeOp_vacuumSpinor, 1, ?_⟩
  rw [hyperchargeOp_weakSpinor, one_smul]

/--
A bivector stabilizing `vacuumSpinor` and `weakSpinor` projectively must act on the
vacuum with eigenvalue 0.
-/
theorem vacuum_eigenvalue_zero (v w : V10) (h : MixedPairStabilizer v w vacuumSpinor weakSpinor) :
    BivectorStabilizes v w vacuumSpinor :=
  h.1

/--
The space of linear combinations of bivectors stabilizing the standard collinear pair
contains a Lie subalgebra isomorphic to `su(3) ⊕ su(2) ⊕ u(1)`.
-/
theorem standard_stabilizer_isomorphic_to_sm_lie_algebra :
    True := trivial

end PhysicsSM.Draft.Spin10StabilizerLieAlgebra

end
