import Mathlib

open scoped BigOperators ComplexConjugate
open Matrix

namespace D4Walk

abbrev Direction := Fin 6
abbrev Vec3 := Fin 3 -> ℤ
abbrev Vec4 := Fin 4 -> ℤ

def spatialStep : Direction -> Vec3
  | 0 => ![1, 0, 0]
  | 1 => ![-1, 0, 0]
  | 2 => ![0, 1, 0]
  | 3 => ![0, -1, 0]
  | 4 => ![0, 0, 1]
  | 5 => ![0, 0, -1]

def futureNullRoot (d : Direction) : Vec4 :=
  ![1, spatialStep d 0, spatialStep d 1, spatialStep d 2]

def minkowskiSq (v : Vec4) : ℤ :=
  v 0 ^ 2 - v 1 ^ 2 - v 2 ^ 2 - v 3 ^ 2

theorem six_roots_are_unit_luminal :
    ∀ d : Direction,
      minkowskiSq (futureNullRoot d) = 0 ∧
      (spatialStep d 0) ^ 2 + (spatialStep d 1) ^ 2 +
        (spatialStep d 2) ^ 2 = 1 := by
  sorry

abbrev Position (L : ℕ) := Fin 3 -> ZMod L
abbrev State (L : ℕ) := Position L × Direction -> ℂ

def advance (L : ℕ) (q : Position L × Direction) :
    Position L × Direction :=
  (fun i => q.1 i + (spatialStep q.2 i : ZMod L), q.2)

def retreat (L : ℕ) (q : Position L × Direction) :
    Position L × Direction :=
  (fun i => q.1 i - (spatialStep q.2 i : ZMod L), q.2)

def shiftEquiv (L : ℕ) :
    (Position L × Direction) ≃ (Position L × Direction) where
  toFun := advance L
  invFun := retreat L
  left_inv := by
    intro q
    ext i <;> simp [advance, retreat]
  right_inv := by
    intro q
    ext i <;> simp [advance, retreat]

noncomputable def inner {L : ℕ} [NeZero L] (psi phi : State L) : ℂ :=
  ∑ q, conj (psi q) * phi q

noncomputable def shift {L : ℕ} [NeZero L] (psi : State L) : State L :=
  fun q => psi ((shiftEquiv L).symm q)

theorem shift_preserves_inner {L : ℕ} [NeZero L] (psi phi : State L) :
    inner (shift psi) (shift phi) = inner psi phi := by
  sorry

noncomputable def coin {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (psi : State L) : State L :=
  fun q => ∑ e, U q.2 e * psi (q.1, e)

def IsUnitary (U : Matrix Direction Direction ℂ) : Prop :=
  U.conjTranspose * U = 1 ∧ U * U.conjTranspose = 1

theorem coin_preserves_inner {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (hU : IsUnitary U)
    (psi phi : State L) :
    inner (coin U psi) (coin U phi) = inner psi phi := by
  sorry

noncomputable def walk {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (psi : State L) : State L :=
  shift (coin U psi)

/-- A finite periodic six-direction D4 null walk is exactly norm preserving
for every supplied unitary coin. -/
theorem walk_preserves_norm {L : ℕ} [NeZero L]
    (U : Matrix Direction Direction ℂ) (hU : IsUnitary U)
    (psi : State L) :
    inner (walk U psi) (walk U psi) = inner psi psi := by
  sorry

def origin5 : Position 5 := fun _ => 0

/-- The x-plus null shift moves a site on a nontrivial periodic lattice. -/
theorem nontrivial_shift_control :
    advance 5 (origin5, (0 : Direction)) ≠ (origin5, (0 : Direction)) := by
  sorry

end D4Walk
