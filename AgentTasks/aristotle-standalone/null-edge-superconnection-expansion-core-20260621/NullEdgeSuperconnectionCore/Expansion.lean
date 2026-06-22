import Mathlib

/-!
# Finite superconnection expansion core

Standalone block-matrix algebra for expanding the square of a finite
superconnection-like operator.

This is the next abstraction after the off-diagonal block-square theorem:
split the odd operator into a differential/codifferential part and a
Higgs/Yukawa zero-form part, then prove that the square expands into
Laplacian, cross, and mass blocks.
-/

noncomputable section

namespace NullEdgeSuperconnectionCore

open Matrix Complex

variable {L R : Type*} [Fintype L] [Fintype R]

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

theorem finiteSuperconnection_sq_leftBlock
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (l l' : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inl l') =
      ((delta * d) + (delta * phi) + (psi * d) + (psi * phi)) l l' := by
  sorry

theorem finiteSuperconnection_sq_rightBlock
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (r r' : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inr r') =
      ((d * delta) + (d * psi) + (phi * delta) + (phi * psi)) r r' := by
  sorry

theorem finiteSuperconnection_sq_offBlock_zero_left
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (l : L) (r : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inr r) = 0 := by
  sorry

theorem finiteSuperconnection_sq_offBlock_zero_right
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (r : R) (l : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inl l) = 0 := by
  sorry

/-- If the cross terms vanish, the left block is Laplacian plus Higgs mass. -/
theorem finiteSuperconnection_sq_leftBlock_noCross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (h1 : delta * phi = 0) (h2 : psi * d = 0) (l l' : L) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inl l) (Sum.inl l') =
      ((delta * d) + (psi * phi)) l l' := by
  sorry

/-- If the cross terms vanish, the right block is Laplacian plus Higgs mass. -/
theorem finiteSuperconnection_sq_rightBlock_noCross
    (d phi : Matrix R L Complex) (delta psi : Matrix L R Complex)
    (h1 : d * psi = 0) (h2 : phi * delta = 0) (r r' : R) :
    (finiteSuperconnection d phi delta psi *
        finiteSuperconnection d phi delta psi) (Sum.inr r) (Sum.inr r') =
      ((d * delta) + (phi * psi)) r r' := by
  sorry

end NullEdgeSuperconnectionCore

end
