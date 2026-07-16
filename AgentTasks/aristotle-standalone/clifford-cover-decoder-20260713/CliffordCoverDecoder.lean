import Mathlib

/-!
# Signed flavor-cover Clifford core

The eight flavors are the occupation basis of three fermionic modes.  Unsigned
bit flips give the regular `Z2^3` deck action.  Inserting the standard
lower-index occupation sign turns them into Clifford generators.

This focused target proves the exact finite relations and their unsigned
negative control.  It does not identify the sheets with particle species and
does not yet prove invariance under a physical flavored QCA.
-/

noncomputable section

namespace CliffordCoverDecoder

abbrev Flavor := Fin 3 -> ZMod 2
abbrev State := Flavor -> Complex

/-- The flavor with only bit `j` set. -/
def singleton (j : Fin 3) : Flavor :=
  fun i => if i = j then 1 else 0

/-- Unsigned regular deck translation. -/
def deckFlip (j : Fin 3) (psi : State) : State :=
  fun x => psi (x + singleton j)

/-- Parity of occupied bits strictly below `j`. -/
def lowerParity (j : Fin 3) (x : Flavor) : ZMod 2 :=
  Finset.univ.sum fun i : Fin 3 => if i < j then x i else 0

/-- Fermionic sign associated with the ordered occupation basis. -/
def fermionSign (j : Fin 3) (x : Flavor) : Complex :=
  if lowerParity j x = 0 then 1 else -1

/-- Signed bit flip, i.e. creation plus contraction on the occupation basis. -/
def cliffordFlip (j : Fin 3) (psi : State) : State :=
  fun x => fermionSign j x * psi (x + singleton j)

theorem deckFlip_involutive (j : Fin 3) (psi : State) :
    deckFlip j (deckFlip j psi) = psi := by
  sorry

theorem deckFlip_commute (i j : Fin 3) (psi : State) :
    deckFlip i (deckFlip j psi) = deckFlip j (deckFlip i psi) := by
  sorry

theorem cliffordFlip_involutive (j : Fin 3) (psi : State) :
    cliffordFlip j (cliffordFlip j psi) = psi := by
  sorry

theorem cliffordFlip_anticommute (i j : Fin 3) (hij : i ≠ j) (psi : State) :
    cliffordFlip i (cliffordFlip j psi) =
      -cliffordFlip j (cliffordFlip i psi) := by
  sorry

/-- Nondegenerate witness that the signed and unsigned lifts differ. -/
def occupiedZero : Flavor := fun i => if i = 0 then 1 else 0

def vacuumState : State := fun x => if x = 0 then 1 else 0

theorem sign_witness : fermionSign 1 occupiedZero = -1 := by
  sorry

theorem unsigned_signed_distinct :
    deckFlip 1 vacuumState ≠ cliffordFlip 1 vacuumState := by
  sorry

end CliffordCoverDecoder
