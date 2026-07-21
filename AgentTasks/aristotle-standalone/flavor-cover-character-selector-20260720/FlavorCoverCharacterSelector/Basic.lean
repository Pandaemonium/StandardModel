import Mathlib

/-!
# Fourier-character selectors for the regular Z2^3 flavor cover

Focused Aristotle target. The goal is to classify translation-compatible
one-dimensional sectors of the regular three-bit flavor cover. Do not weaken
the statements. In particular, preserve the explicit orthogonality constant,
the commuting-projector theorem, the one-dimensional common-eigenspace
classification, and the bare-sheet negative control.
-/

noncomputable section

namespace FlavorCoverCharacterSelector

abbrev Flavor := Fin 3 -> ZMod 2
abbrev State := Flavor -> Complex

def singleton (j : Fin 3) : Flavor :=
  fun i => if i = j then 1 else 0

def deckFlip (j : Fin 3) (psi : State) : State :=
  fun x => psi (x + singleton j)

def parityPair (chi x : Flavor) : ZMod 2 :=
  Finset.univ.sum fun i : Fin 3 => chi i * x i

def characterState (chi : Flavor) : State :=
  fun x => if parityPair chi x = 0 then 1 else -1

def eigenSign (chi : Flavor) (j : Fin 3) : Complex :=
  if chi j = 0 then 1 else -1

def innerSum (psi phi : State) : Complex :=
  Finset.univ.sum fun x => starRingEnd Complex (psi x) * phi x

def characterProjector (chi : Flavor) (psi : State) : State :=
  fun x => (8 : Complex)⁻¹ * characterState chi x *
    innerSum (characterState chi) psi

def basisState (f : Flavor) : State :=
  fun x => if x = f then 1 else 0

def sheetProjector (f : Flavor) (psi : State) : State :=
  fun x => if x = f then psi x else 0

theorem singleton_add_self (j : Fin 3) :
    singleton j + singleton j = 0 := by
  sorry

theorem parityPair_add_right (chi x y : Flavor) :
    parityPair chi (x + y) = parityPair chi x + parityPair chi y := by
  sorry

theorem parityPair_singleton (chi : Flavor) (j : Fin 3) :
    parityPair chi (singleton j) = chi j := by
  sorry

theorem characterState_ne_zero (chi : Flavor) :
    Not (characterState chi = 0) := by
  sorry

theorem deckFlip_characterState (chi : Flavor) (j : Fin 3) :
    deckFlip j (characterState chi) =
      fun x => eigenSign chi j * characterState chi x := by
  sorry

theorem character_orthogonality (chi eta : Flavor) :
    innerSum (characterState chi) (characterState eta) =
      if chi = eta then 8 else 0 := by
  sorry

theorem characterProjector_on_character (chi eta : Flavor) :
    characterProjector chi (characterState eta) =
      if chi = eta then characterState chi else 0 := by
  sorry

theorem characterProjector_idempotent (chi : Flavor) (psi : State) :
    characterProjector chi (characterProjector chi psi) =
      characterProjector chi psi := by
  sorry

theorem characterProjector_commutes_deckFlip (chi : Flavor) (j : Fin 3)
    (psi : State) :
    characterProjector chi (deckFlip j psi) =
      deckFlip j (characterProjector chi psi) := by
  sorry

theorem common_eigenspace_one_dimensional (chi : Flavor) (psi : State)
    (hpsi : forall j : Fin 3,
      deckFlip j psi = fun x => eigenSign chi j * psi x) :
    exists c : Complex, psi = fun x => c * characterState chi x := by
  sorry

theorem character_family_complete (psi : State) :
    psi = fun x => Finset.univ.sum fun chi : Flavor =>
      (characterProjector chi psi) x := by
  sorry

theorem singleton_ne_zero (j : Fin 3) : Not (singleton j = 0) := by
  sorry

theorem sheetProjector_not_commutes_deckFlip (f : Flavor) (j : Fin 3) :
    Not ((fun psi => sheetProjector f (deckFlip j psi)) =
      (fun psi => deckFlip j (sheetProjector f psi))) := by
  sorry

end FlavorCoverCharacterSelector
