import Mathlib

/-!
# Independent replay target: finite support under a rational Lorentz boost

Re-prove the exact AFPL L0 fixed-support no-go from the displayed definitions.
This standalone target intentionally contains no project imports and no copied
proofs. The result is only a finite-support obstruction. It is not a theorem
about invariant point-process laws or distributional Lorentz symmetry.
-/

namespace AFPL.L0BoostReplay

abbrev Vec := Fin 2 -> Rat

def Boost (c s : Rat) : Matrix (Fin 2) (Fin 2) Rat := !![c, s; s, c]

def Q (v : Vec) : Rat := v 0 ^ 2 - v 1 ^ 2

def Lam : Matrix (Fin 2) (Fin 2) Rat := Boost (5 / 3) (4 / 3)

def boostVec (v : Vec) : Vec := Matrix.mulVec Lam v

def restVec : Vec := ![1, 0]

def nullPlus (v : Vec) : Rat := v 0 + v 1

def orbit : Nat -> Vec
  | 0 => restVec
  | n + 1 => boostVec (orbit n)

lemma nullPlus_boostVec (v : Vec) :
    nullPlus (boostVec v) = 3 * nullPlus v := by
  sorry

lemma nullPlus_orbit (n : Nat) : nullPlus (orbit n) = (3 : Rat) ^ n := by
  sorry

lemma pow_three_strictMono : StrictMono (fun n : Nat => (3 : Rat) ^ n) := by
  sorry

theorem orbit_injective : Function.Injective orbit := by
  sorry

def ForwardInvariant (S : Finset Vec) : Prop :=
  forall v, v ∈ S -> boostVec v ∈ S

lemma orbit_mem_of_forwardInvariant (S : Finset Vec)
    (hrest : restVec ∈ S) (hinv : ForwardInvariant S) :
    forall n, orbit n ∈ S := by
  sorry

theorem no_finite_forward_invariant_support :
    ¬ ∃ S : Finset Vec, restVec ∈ S ∧ ForwardInvariant S := by
  sorry

theorem boost_preserves_Q (v : Vec) : Q (boostVec v) = Q v := by
  sorry

theorem restVec_control :
    restVec ≠ 0 ∧ 0 < restVec 0 ∧ Q restVec = 1 := by
  sorry

theorem zero_fixed : boostVec 0 = 0 := by
  sorry

theorem zero_singleton_forwardInvariant : ForwardInvariant {0} := by
  sorry

theorem identity_preserves_every_finite_support (S : Finset Vec) :
    forall v, v ∈ S -> Matrix.mulVec (1 : Matrix (Fin 2) (Fin 2) Rat) v ∈ S := by
  sorry

end AFPL.L0BoostReplay
