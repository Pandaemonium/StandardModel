import Mathlib

/-!
# Draft.NullEdgeSuperconnectionExpansionCore

Finite block-matrix expansion for a superconnection-like odd operator.

This module is the next abstraction after
`PhysicsSM.Draft.NullEdgeSuperDiracBlockCore`: split the odd operator into a
differential/codifferential part and a Higgs/Yukawa zero-form part, then prove
that its square expands into Laplacian, cross, and mass blocks.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSuperconnectionCore

open Matrix Complex

variable {L R : Type*} [Fintype L] [Fintype R]

/-- Off-diagonal operator on a finite `L ⊕ R` space. -/
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

/-- Left block of the finite superconnection square. -/
theorem finiteSuperconnection_sq_leftBlock
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (l l' : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inl l') =
      ((delta * d) + (delta * phi) + (psi * d) + (psi * phi)) l l' := by
  unfold finiteSuperconnection
  simp +decide [Matrix.mul_apply, offDiagonal]
  simpa only [← Finset.sum_add_distrib] using
    Finset.sum_congr rfl fun _ _ => by ring

set_option linter.flexible false in
/-- Right block of the finite superconnection square. -/
theorem finiteSuperconnection_sq_rightBlock
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (r r' : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inr r') =
      ((d * delta) + (d * psi) + (phi * delta) + (phi * psi)) r r' := by
  unfold finiteSuperconnection
  simp +decide [Matrix.mul_apply, Fintype.sum_sum_type]
  unfold offDiagonal
  simp +decide [mul_add, add_mul, Finset.sum_add_distrib]
  ring

/-- The left-to-right block of the square vanishes. -/
theorem finiteSuperconnection_sq_offBlock_zero_left
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (l : L) (r : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inr r) = 0 := by
  simp_all +decide [Matrix.mul_apply, finiteSuperconnection, offDiagonal]

/-- The right-to-left block of the square vanishes. -/
theorem finiteSuperconnection_sq_offBlock_zero_right
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (r : R) (l : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inl l) = 0 := by
  unfold finiteSuperconnection
  unfold offDiagonal
  simp +decide [Matrix.mul_apply]

/-- If the cross terms vanish, the left block is Laplacian plus Higgs mass. -/
theorem finiteSuperconnection_sq_leftBlock_noCross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (h1 : delta * phi = 0) (h2 : psi * d = 0) (l l' : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inl l') =
      ((delta * d) + (psi * phi)) l l' := by
  convert finiteSuperconnection_sq_leftBlock d phi delta psi l l' using 1
  simp +decide [h1, h2]

/-- If the cross terms vanish, the right block is Laplacian plus Higgs mass. -/
theorem finiteSuperconnection_sq_rightBlock_noCross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (h1 : d * psi = 0) (h2 : phi * delta = 0) (r r' : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inr r') =
      ((d * delta) + (phi * psi)) r r' := by
  convert finiteSuperconnection_sq_rightBlock d phi delta psi r r' using 1
  simp +decide [h1, h2]

end PhysicsSM.Draft.NullEdgeSuperconnectionCore

end
