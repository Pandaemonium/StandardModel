import Mathlib

/-!
# Draft.NullEdgeSuperconnectionCrossTermHiggsKinetic

Finite block algebra naming the cross terms in the superconnection square.

The corrected super-Dirac conjecture should not simply discard the cross terms.
In an interacting theory these terms are the finite analogue of a gauged Higgs
kinetic or covariant-derivative block.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSuperconnectionCrossTermHiggsKinetic

open Matrix Complex

variable {L R : Type*} [Fintype L] [Fintype R]

/-- Off-diagonal operator on a finite `L plus R` space. -/
def offDiagonal
    (phi : Matrix R L Complex) (psi : Matrix L R Complex) :
    Matrix (Sum L R) (Sum L R) Complex :=
  fun a b =>
    match a, b with
    | Sum.inl _, Sum.inl _ => 0
    | Sum.inl l, Sum.inr r => psi l r
    | Sum.inr r, Sum.inl l => phi r l
    | Sum.inr _, Sum.inr _ => 0

/-- Differential plus odd zero-form, in abstract block notation. -/
def finiteSuperconnection
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex) :
    Matrix (Sum L R) (Sum L R) Complex :=
  offDiagonal (d + phi) (delta + psi)

/-- Left-block finite Higgs kinetic cross term. -/
def leftHiggsKineticCross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex) :
    Matrix L L Complex :=
  delta * phi + psi * d

/-- Right-block finite Higgs kinetic cross term. -/
def rightHiggsKineticCross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex) :
    Matrix R R Complex :=
  d * psi + phi * delta

/-- Left block of the finite superconnection square, with the cross term named. -/
theorem finiteSuperconnection_sq_leftBlock_with_cross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (l l' : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inl l') =
      ((delta * d) + leftHiggsKineticCross d phi delta psi + (psi * phi)) l l' := by
  unfold finiteSuperconnection leftHiggsKineticCross
  simp +decide [Matrix.mul_apply, Fintype.sum_sum_type, offDiagonal]
  simp +decide only [mul_add, add_mul, Finset.sum_add_distrib]
  ring

/-- Right block of the finite superconnection square, with the cross term named. -/
theorem finiteSuperconnection_sq_rightBlock_with_cross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (r r' : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inr r') =
      ((d * delta) + rightHiggsKineticCross d phi delta psi + (phi * psi)) r r' := by
  unfold finiteSuperconnection rightHiggsKineticCross
  simp +decide [offDiagonal, Matrix.mul_apply, Finset.sum_add_distrib, add_mul, mul_add]
  ring

omit [Fintype L] in
/--
The left cross term vanishes exactly when the finite Higgs kinetic block
vanishes.
-/
theorem leftCrossTerm_zero_iff_covariantly_constant
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex) :
    leftHiggsKineticCross d phi delta psi = 0 <->
      delta * phi + psi * d = 0 := by
  rfl

omit [Fintype R] in
/--
The right cross term vanishes exactly when the finite Higgs kinetic block
vanishes.
-/
theorem rightCrossTerm_zero_iff_covariantly_constant
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex) :
    rightHiggsKineticCross d phi delta psi = 0 <->
      d * psi + phi * delta = 0 := by
  rfl

end PhysicsSM.Draft.NullEdgeSuperconnectionCrossTermHiggsKinetic

end
