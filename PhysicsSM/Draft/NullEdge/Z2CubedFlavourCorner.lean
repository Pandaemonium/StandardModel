import Mathlib

/-!
# Exact `Z2^3` corner-flavour census

This module folds the eight `{0, pi}^3` corner labels to one reduced-zone
representative and records the lost corner coordinate as a `Z2^3` flavour.
The result is deliberately a relabelling theorem: it does not remove any
crossing or derive a physical family count.

The full translation-symbol intertwiner belongs in a successor module.  Here
the finite census is isolated from matrix and trigonometric details, with a
too-coarse diagonal `Z2` negative control.

Provenance: clean-room formalization of the finite covering strategy discussed
in Bakircioglu, Arnault, and Arrighi (arXiv:2505.07900), specialized following
Aristotle strategy task `88a4d101-3cd4-43b1-ba8f-068a5707ee14`.  No external
code was copied.
-/

namespace PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner

/-- The eight zero/pi phase corners. -/
abbrev PhaseCorner : Type := Fin 3 → ZMod 2

/-- The sheet label retained after folding to the reduced corner zone. -/
abbrev Flavour : Type := Fin 3 → ZMod 2

/-- Folding the corner orbit by all three pi translations leaves one point. -/
abbrev ReducedRep : Type := PUnit

/-- The corner cover: the reduced representative carries no data, while the
flavour records the original corner. -/
def cover : ReducedRep → Flavour → PhaseCorner := fun _ f => f

/-- Componentwise deck translation on the corner orbit. -/
def deck (g : Flavour) : PhaseCorner → PhaseCorner := fun c => g + c

/-- Parity character of a flavour label. -/
def chi (f : Flavour) : ℤ := (-1) ^ (f 0 + f 1 + f 2).val

theorem card_corner : Fintype.card PhaseCorner = 8 := by
  decide

/-- The corner cover is a bijection, hence a relabelling rather than a
projection that deletes aliases. -/
theorem cover_bijective : Function.Bijective (cover PUnit.unit) := by
  constructor
  · intro a b h
    exact h
  · intro c
    exact ⟨c, rfl⟩

/-- Every old corner has exactly one reduced representative and flavour label. -/
theorem corner_unique_rep_and_flavour (c : PhaseCorner) :
    ∃! f : Flavour, cover PUnit.unit f = c := by
  refine ⟨c, rfl, ?_⟩
  intro f hf
  exact hf

/-- The `Z2^3` deck action is free and transitive on the eight corners. -/
theorem deck_regular (c : PhaseCorner) : Function.Bijective (deck · c) := by
  constructor
  · intro a b h
    have hh := congrArg (fun x => x - c) h
    simpa [deck] using hh
  · intro y
    refine ⟨y - c, ?_⟩
    simp [deck]

/-- A single diagonal flavour bit cannot label all eight corners. -/
theorem wrongCover_diagonal_not_surjective :
    ¬ Function.Surjective (fun g : ZMod 2 => (fun _ => g : PhaseCorner)) := by
  decide

/-! ## Assumption-footprint audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner.card_corner' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms card_corner

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner.corner_unique_rep_and_flavour' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms corner_unique_rep_and_flavour

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner.deck_regular' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms deck_regular

/-- info: 'PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner.wrongCover_diagonal_not_surjective' depends on axioms: [propext,
 Classical.choice,
 Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms wrongCover_diagonal_not_surjective

end PhysicsSM.Draft.NullEdge.Z2CubedFlavourCorner
