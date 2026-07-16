import Mathlib

/-!
# All-moving null dilation of a projector-conditioned shift

A projector-conditioned lattice shift usually moves one internal sector and
holds its complement fixed. This file asks whether the hold can be resolved
into genuine microscopic motion after adding one compact auxiliary direction.

One fine tick moves the selected sector by tx and the complementary sector by
ts. The second fine tick again moves the selected sector by tx but moves the
complement by the inverse of ts. Under the exact projector relations, the
two-tick composition is the original coarse conditioned shift: the selected
sector has moved by two tx steps, while the auxiliary excursion cancels.

The intended physical reading requires an additional soldering declaration:
the physical and compact auxiliary edges must have equal null length per fine
tick. The algebra below proves the dilation, not that geometric declaration.
-/

namespace NullDilationConditionedShift

open Matrix

noncomputable section

abbrev Spin := Fin 2 -> Complex

def State (X S : Type) := X -> S -> Spin

/-- First all-moving fine tick: P moves physically and Q moves outward in the
compact auxiliary direction. -/
def microOut {X S : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X) (ts : S ≃ S) (psi : State X S) : State X S :=
  fun x s => P *ᵥ psi (tx.symm x) s + Q *ᵥ psi x (ts.symm s)

/-- Second all-moving fine tick: P moves physically again and Q returns in the
compact auxiliary direction. -/
def microBack {X S : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X) (ts : S ≃ S) (psi : State X S) : State X S :=
  fun x s => P *ᵥ psi (tx.symm x) s + Q *ᵥ psi x (ts s)

/-- Coarse update decoded after two fine ticks. -/
def coarse {X S : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X) (psi : State X S) : State X S :=
  fun x s => P *ᵥ psi (tx.symm (tx.symm x)) s + Q *ᵥ psi x s

/-- The auxiliary out-and-back motion exactly dilates the stationary sector:
after two fine ticks, P has translated twice and Q has returned to its original
auxiliary site. -/
theorem microBack_microOut {X S : Type} (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (tx : X ≃ X) (ts : S ≃ S)
    (hPP : P * P = P) (hQQ : Q * Q = Q)
    (hPQ : P * Q = 0) (hQP : Q * P = 0)
    (psi : State X S) :
    microBack P Q tx ts (microOut P Q tx ts psi) = coarse P Q tx psi := by
  sorry

/-- Momentum-space control: opposite auxiliary phases cancel on Q, while the
selected physical phase is squared. -/
theorem symbol_dilation (P Q : Matrix (Fin 2) (Fin 2) Complex)
    (cx cs : Complex)
    (hPP : P * P = P) (hQQ : Q * Q = Q)
    (hPQ : P * Q = 0) (hQP : Q * P = 0)
    (hcs : cs != 0) :
    (cx • P + cs⁻¹ • Q) * (cx • P + cs • Q) =
      (cx * cx) • P + Q := by
  sorry

/-- Each fine tick preserves the finite inner product under complementary
Hermitian projectors and bijective physical/auxiliary shifts. -/
theorem microOut_inner_preserving {X S : Type} [Fintype X] [Fintype S]
    (P Q : Matrix (Fin 2) (Fin 2) Complex) (tx : X ≃ X) (ts : S ≃ S)
    (hP : P.conjTranspose = P) (hQ : Q.conjTranspose = Q)
    (hPP : P * P = P) (hQQ : Q * Q = Q)
    (hPQ : P * Q = 0) (hQP : Q * P = 0)
    (psi phi : State X S) :
    (∑ x, ∑ s, ∑ a,
      starRingEnd Complex (microOut P Q tx ts psi x s a) *
        microOut P Q tx ts phi x s a) =
    ∑ x, ∑ s, ∑ a, starRingEnd Complex (psi x s a) * phi x s a := by
  sorry

end

end NullDilationConditionedShift
