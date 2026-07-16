import Mathlib

/-!
# Flavor-cover charge obstruction

This module records a cheap representation-theoretic kill test for the proposed
eight-cover route to a strict local `3+1` null-edge walk.

The flavored-QCA cover is indexed by the regular additive action of
`(ZMod 2)^3`.  A scalar charge that commutes with every naked deck translation
must therefore be constant.  The explicit `6 + 2` hypercharge-shaped labeling
below is not constant, so it cannot be an invariant of the bare regular deck
action.

This does not rule out the wider route.  It requires additional structure:
gauge-twisted translation, a decoded/quotient charge, or physical breaking of
the full deck symmetry.

Provenance: clean-room formalization of the regular-cover argument motivated by
Bakircioglu, Arnault, and Arrighi, "Fermion Doubling in Quantum Cellular
Automata", arXiv:2505.07900.  The `6 + 2` multiplicities follow the conventional
one-generation left-handed quark/lepton doublet count used in
`PhysicsSM.StandardModel.OneGenerationTable`.

Status: draft theorem module.  All proofs are kernel checked; no external
evaluator is used.
-/

namespace PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction

/-- The three-bit flavor-cover register. -/
abbrev Flavor := Fin 3 -> ZMod 2

/-- Invariance of a scalar label under every regular deck translation. -/
def DeckInvariant {R : Type*} (q : Flavor -> R) : Prop :=
  forall g x, q (g + x) = q x

/-- A scalar invariant of the full regular deck action is constant. -/
theorem deckInvariant_forces_constant {R : Type*} (q : Flavor -> R)
    (hq : DeckInvariant q) :
    forall x y, q x = q y := by
  intro x y
  have h := hq (y - x) x
  simpa using h.symm

/--
An explicit `6 + 2` labeling of the eight cover sheets: the two labels whose
first two bits vanish are assigned lepton-doublet hypercharge `-1`; the other
six are assigned quark-doublet hypercharge `1/3`.
-/
def leftDoubletHypercharge (x : Flavor) : Rat :=
  if x 0 = 0 && x 1 = 0 then -1 else 1 / 3

/-- The two cover sheets assigned the lepton-doublet hypercharge. -/
def leptonSheets : Finset Flavor :=
  Finset.univ.filter fun x => x 0 = 0 && x 1 = 0

/-- Exactly two of the eight sheets carry the lepton label. -/
theorem leptonSheets_card : leptonSheets.card = 2 := by
  decide

/-- Exactly six of the eight sheets carry the complementary quark label. -/
theorem quarkSheets_card : (Finset.univ \ leptonSheets).card = 6 := by
  decide

/-- A sheet in the two-state lepton-labelled subset. -/
def leptonWitness : Flavor := fun _ => 0

/-- A sheet in the six-state quark-labelled complement. -/
def quarkWitness : Flavor := fun i => if i = 0 then 1 else 0

/-- The lepton witness has hypercharge `-1`. -/
theorem leftDoubletHypercharge_leptonWitness :
    leftDoubletHypercharge leptonWitness = -1 := by
  norm_num [leftDoubletHypercharge, leptonWitness]

/-- The quark witness has hypercharge `1/3`. -/
theorem leftDoubletHypercharge_quarkWitness :
    leftDoubletHypercharge quarkWitness = 1 / 3 := by
  norm_num [leftDoubletHypercharge, quarkWitness]

/-- The `6 + 2` Standard Model-shaped labeling is genuinely nonconstant. -/
theorem leftDoubletHypercharge_nonconstant :
    leftDoubletHypercharge leptonWitness ≠
      leftDoubletHypercharge quarkWitness := by
  rw [leftDoubletHypercharge_leptonWitness,
    leftDoubletHypercharge_quarkWitness]
  norm_num

/--
The Standard Model-shaped hypercharge labeling cannot commute with every naked
regular deck translation.
-/
theorem leftDoubletHypercharge_not_deckInvariant :
    ¬ DeckInvariant leftDoubletHypercharge := by
  intro h
  exact leftDoubletHypercharge_nonconstant
    (deckInvariant_forces_constant leftDoubletHypercharge h
      leptonWitness quarkWitness)

end PhysicsSM.Draft.NullEdge.FlavorCoverChargeObstruction
