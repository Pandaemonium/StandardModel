import Mathlib

/-!
# Signed flavor-cover Clifford core

The eight flavors are the occupation basis of three fermionic modes.  Unsigned
bit flips give the regular `Z2^3` deck action.  Inserting the standard
lower-index occupation sign turns them into Clifford generators.

This focused target proves the exact finite relations and their unsigned
negative control.  It does not identify the sheets with particle species and
does not yet prove invariance under a physical flavored QCA.

Provenance: finite clean-room specialization of the standard lower-index
Jordan-Wigner occupation sign.  The construction was completed by Aristotle
project `5ed47bad-6557-4c68-ac6b-bacfc0a84142` and independently reviewed in
`AutonomousLab/reviews/CODEX_REVIEW_CliffordCoverDecoder_2026-07-13.md`.

Status: draft theorem module.  Every executable theorem is complete.  The
rejected vacuum inequality is retained only as a commented failure record.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CliffordCoverDecoder

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

/-! ## Finite auxiliary lemmas -/

/-- Flipping the same mode twice returns the original flavor (`ZMod 2` is
characteristic two, so `singleton j + singleton j = 0`). -/
theorem singleton_add_self (j : Fin 3) : singleton j + singleton j = 0 := by
  funext i; simp only [Pi.add_apply, Pi.zero_apply]; exact CharTwo.add_self_eq_zero _

/-- The lower-index parity is additive in the flavor. -/
theorem lowerParity_add (j : Fin 3) (a b : Flavor) :
    lowerParity j (a + b) = lowerParity j a + lowerParity j b := by
  simp only [lowerParity, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl; intro i _
  by_cases h : i < j <;> simp [h, Pi.add_apply]

/-- Lower-index parity of a single occupied mode counts it iff it is below `j`. -/
theorem lowerParity_singleton (j i : Fin 3) :
    lowerParity j (singleton i) = (if i < j then 1 else 0) := by
  revert j i; decide

/-- Adding `singleton j` (a bit at `j`, not below `j`) leaves `lowerParity j`
unchanged. -/
theorem lowerParity_add_self (j : Fin 3) (x : Flavor) :
    lowerParity j (x + singleton j) = lowerParity j x := by
  simp only [lowerParity]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hij : i < j
  · simp only [hij, if_true, Pi.add_apply, singleton]
    simp [ne_of_lt hij]
  · simp [hij]

/-- The Jordan-Wigner sign of `j` is unchanged when flipping mode `j`. -/
theorem fermionSign_add_self (j : Fin 3) (x : Flavor) :
    fermionSign j (x + singleton j) = fermionSign j x := by
  simp only [fermionSign, lowerParity_add_self]

/-- The Jordan-Wigner sign squares to one. -/
theorem fermionSign_sq (j : Fin 3) (x : Flavor) :
    fermionSign j x * fermionSign j x = 1 := by
  simp only [fermionSign]; split <;> norm_num

/-- Incrementing the lower-index parity flips the sign. -/
theorem sgn_succ (v : ZMod 2) :
    (if v + 1 = 0 then (1 : Complex) else -1) = -(if v = 0 then 1 else -1) := by
  have h2 : v = 0 ∨ v = 1 := by revert v; decide
  rcases h2 with h | h <;> subst h <;>
    simp only [(by decide : ((0 : ZMod 2) + 1) = 1), (by decide : ((1 : ZMod 2) + 1) = 0),
      (by decide : ((1 : ZMod 2)) ≠ 0)] <;> norm_num

/-! ## The exact finite relations -/

theorem deckFlip_involutive (j : Fin 3) (psi : State) :
    deckFlip j (deckFlip j psi) = psi := by
  funext x; simp only [deckFlip]; rw [add_assoc, singleton_add_self, add_zero]

theorem deckFlip_commute (i j : Fin 3) (psi : State) :
    deckFlip i (deckFlip j psi) = deckFlip j (deckFlip i psi) := by
  funext x; simp only [deckFlip]; rw [add_assoc, add_assoc, add_comm (singleton j)]

theorem cliffordFlip_involutive (j : Fin 3) (psi : State) :
    cliffordFlip j (cliffordFlip j psi) = psi := by
  funext x
  simp only [cliffordFlip]
  rw [fermionSign_add_self, add_assoc, singleton_add_self, add_zero, ← mul_assoc,
    fermionSign_sq, one_mul]

theorem cliffordFlip_anticommute (i j : Fin 3) (hij : i ≠ j) (psi : State) :
    cliffordFlip i (cliffordFlip j psi) =
      -cliffordFlip j (cliffordFlip i psi) := by
  funext x
  simp only [cliffordFlip, Pi.neg_apply]
  rw [show x + singleton i + singleton j = x + singleton j + singleton i by ac_rfl]
  have key : fermionSign i x * fermionSign j (x + singleton i) =
      -(fermionSign j x * fermionSign i (x + singleton j)) := by
    have hj : fermionSign j (x + singleton i) =
        if lowerParity j x + (if i < j then 1 else 0) = 0 then (1 : Complex) else -1 := by
      simp only [fermionSign, lowerParity_add, lowerParity_singleton]
    have hi : fermionSign i (x + singleton j) =
        if lowerParity i x + (if j < i then 1 else 0) = 0 then (1 : Complex) else -1 := by
      simp only [fermionSign, lowerParity_add, lowerParity_singleton]
    rw [hj, hi]
    rcases lt_or_gt_of_ne hij with h | h
    · rw [if_pos h, if_neg (lt_asymm h), add_zero, sgn_succ]
      simp only [fermionSign]; ring
    · rw [if_neg (lt_asymm h), if_pos h, add_zero, sgn_succ]
      simp only [fermionSign]; ring
  rw [← mul_assoc, ← mul_assoc, key]; ring

/-- Nondegenerate witness that the signed and unsigned lifts differ. -/
def occupiedZero : Flavor := fun i => if i = 0 then 1 else 0

def vacuumState : State := fun x => if x = 0 then 1 else 0

theorem sign_witness : fermionSign 1 occupiedZero = -1 := by
  have : lowerParity 1 occupiedZero = 1 := by decide
  simp [fermionSign, this]

/-
SEMANTIC ISSUE (reported, not silently weakened).

The statement below is FALSE with the definitions in this file, so it is kept
verbatim (commented out) and replaced by a corrected, provable control.

  theorem unsigned_signed_distinct :
      deckFlip 1 vacuumState ≠ cliffordFlip 1 vacuumState := by
    s o r r y

Reason: `vacuumState` is supported only on the empty occupation `0`.  A flip of
mode `1` sends it to the single flavor `singleton 1`, and that is the only
flavor on which either lift is nonzero.  There, the Jordan-Wigner sign
`fermionSign 1 (singleton 1)` counts occupied modes strictly below `1`, i.e.
mode `0`, which is empty; hence the sign is `+1`.  Therefore the signed and
unsigned lifts coincide pointwise:

  `deckFlip 1 vacuumState = cliffordFlip 1 vacuumState`  (provable, see below).

From the vacuum every single flip is sign-degenerate (nothing lies below the
flipped mode with any occupation), so the vacuum cannot separate the two lifts.
A faithful nondegenerate control must start from a state whose lower modes are
occupied — exactly the data of `sign_witness` (`occupiedZero`, axis `1`).
-/

/-- The precise semantic defect: on the vacuum the two lifts are *equal*, which
is why the original `≠` statement is unprovable. -/
theorem deckFlip_eq_cliffordFlip_on_vacuum :
    deckFlip 1 vacuumState = cliffordFlip 1 vacuumState := by
  funext x
  simp only [deckFlip, cliffordFlip, vacuumState]
  by_cases h : x + singleton 1 = 0
  · have hx : x = singleton 1 := by
      funext i
      have hi := congrFun h i
      simp only [Pi.add_apply, Pi.zero_apply] at hi
      revert hi; decide +revert
    subst hx
    have hp : lowerParity 1 (singleton 1) = 0 := by decide
    simp only [fermionSign, hp]; simp
  · simp [h]

/-- Corrected nondegenerate control: on a state whose mode `0` is occupied, the
unsigned deck flip and the signed Clifford flip of mode `1` genuinely differ
(the lower-index Jordan-Wigner sign is `-1`, matching `sign_witness`). -/
theorem unsigned_signed_distinct_corrected :
    deckFlip 1 (fun x => if x = occupiedZero then 1 else 0) ≠
      cliffordFlip 1 (fun x => if x = occupiedZero then 1 else 0) := by
  intro h
  have h1 := congrFun h (occupiedZero + singleton 1)
  simp only [deckFlip, cliffordFlip] at h1
  have e1 : occupiedZero + singleton 1 + singleton 1 = occupiedZero := by
    rw [add_assoc, singleton_add_self, add_zero]
  rw [e1] at h1
  have hs : fermionSign 1 (occupiedZero + singleton 1) = -1 := by
    have : lowerParity 1 (occupiedZero + singleton 1) = 1 := by decide
    simp [fermionSign, this]
  rw [hs] at h1
  norm_num at h1

end PhysicsSM.Draft.NullEdge.CliffordCoverDecoder
