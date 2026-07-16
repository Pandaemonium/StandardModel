import Mathlib

/-!
# Even Clifford-cover commutant projector

The three-bit flavor register is represented over `C`.  Left Clifford flips
use lower occupation parity, while commuting right Clifford flips use upper
occupation parity.  The even right bivector `B = I r_0 r_1` is Hermitian and
involutive.  Its projector `(1 + B) / 2` commutes with every left generator
and with occupation parity `Gamma`, unlike a projector made from one odd right
generator.

All finite sign calculations below use kernel reduction (`decide`).
-/

noncomputable section

namespace CliffordCoverProjector

abbrev Flavor := Fin 3 -> ZMod 2
abbrev State := Flavor -> Complex
abbrev Operator := State -> State

def singleton (j : Fin 3) : Flavor := fun i => if i = j then 1 else 0
def deckFlip (j : Fin 3) : Operator := fun psi x => psi (x + singleton j)

def lowerParity (j : Fin 3) (x : Flavor) : ZMod 2 :=
  Finset.univ.sum fun i : Fin 3 => if i < j then x i else 0

def upperParity (j : Fin 3) (x : Flavor) : ZMod 2 :=
  Finset.univ.sum fun i : Fin 3 => if j < i then x i else 0

def totalParity (x : Flavor) : ZMod 2 := Finset.univ.sum x
def paritySign (p : ZMod 2) : Int := if p = 0 then 1 else -1
def leftSign (j : Fin 3) (x : Flavor) : Int := paritySign (lowerParity j x)
def rightSign (j : Fin 3) (x : Flavor) : Int := paritySign (upperParity j x)

def leftFlip (j : Fin 3) : Operator :=
  fun psi x => (leftSign j x : Complex) * psi (x + singleton j)

def rightFlip (j : Fin 3) : Operator :=
  fun psi x => (rightSign j x : Complex) * psi (x + singleton j)

def Gamma : Operator := fun psi x => (paritySign (totalParity x) : Complex) * psi x

private theorem toggle_twice : forall x j, x + singleton j + singleton j = x := by decide
private theorem toggle_commute : forall x i j,
    x + singleton i + singleton j = x + singleton j + singleton i := by decide
private theorem left_sign_square : forall x j,
    leftSign j x * leftSign j (x + singleton j) = 1 := by decide
private theorem right_sign_square : forall x j,
    rightSign j x * rightSign j (x + singleton j) = 1 := by decide
private theorem left_right_sign_commute : forall x i j,
    leftSign i x * rightSign j (x + singleton i) =
      rightSign j x * leftSign i (x + singleton j) := by decide
private theorem right_sign_anticommute : forall x i j, i ≠ j ->
    rightSign i x * rightSign j (x + singleton i) =
      -(rightSign j x * rightSign i (x + singleton j)) := by decide
private theorem gamma_right_sign : forall x j,
    paritySign (totalParity x) * rightSign j x =
      -(rightSign j x * paritySign (totalParity (x + singleton j))) := by decide

theorem deckFlip_commute (i j : Fin 3) (psi : State) :
    deckFlip i (deckFlip j psi) = deckFlip j (deckFlip i psi) := by
  funext x
  exact congrArg psi (toggle_commute x i j)

theorem leftFlip_involutive (j : Fin 3) (psi : State) :
    leftFlip j (leftFlip j psi) = psi := by
  sorry

theorem rightFlip_involutive (j : Fin 3) (psi : State) :
    rightFlip j (rightFlip j psi) = psi := by
  sorry

theorem leftFlip_rightFlip_commute (i j : Fin 3) (psi : State) :
    leftFlip i (rightFlip j psi) = rightFlip j (leftFlip i psi) := by
  sorry

theorem rightFlip_anticommute (i j : Fin 3) (hij : i ≠ j) (psi : State) :
    rightFlip i (rightFlip j psi) = -rightFlip j (rightFlip i psi) := by
  sorry

theorem Gamma_rightFlip_anticommute (j : Fin 3) (psi : State) :
    Gamma (rightFlip j psi) = -rightFlip j (Gamma psi) := by
  sorry

theorem rightFlip_add (j : Fin 3) (psi phi : State) :
    rightFlip j (psi + phi) = rightFlip j psi + rightFlip j phi := by
  funext x
  simp [rightFlip, mul_add]

theorem rightFlip_smul (j : Fin 3) (a : Complex) (psi : State) :
    rightFlip j (a • psi) = a • rightFlip j psi := by
  funext x
  simp [rightFlip]
  ring

/-- The even right bivector.  The factor `I` changes `(r_0 r_1)^2 = -1` to `B^2 = 1`. -/
def B : Operator := fun psi => Complex.I • rightFlip 0 (rightFlip 1 psi)

theorem B_involutive (psi : State) : B (B psi) = psi := by
  sorry

theorem B_commutes_left (j : Fin 3) (psi : State) :
    B (leftFlip j psi) = leftFlip j (B psi) := by
  sorry

theorem B_commutes_Gamma (psi : State) : B (Gamma psi) = Gamma (B psi) := by
  sorry

def delta (y : Flavor) : State := fun x => if x = y then 1 else 0

/-- Hermitian means conjugate symmetry in the canonical orthonormal delta basis. -/
def IsHermitian (T : Operator) : Prop :=
  forall x y, star (T (delta y) x) = T (delta x) y

private theorem bivector_coefficient_skew : forall x y,
    rightSign 0 x * rightSign 1 (x + singleton 0) *
        (if x + singleton 0 + singleton 1 = y then 1 else 0) =
      -(rightSign 0 y * rightSign 1 (y + singleton 0) *
        (if y + singleton 0 + singleton 1 = x then 1 else 0)) := by decide

theorem B_hermitian : IsHermitian B := by
  sorry

/-- The parity-compatible, even right-action projector. -/
def projector : Operator := fun psi => (2 : Complex)⁻¹ • (psi + B psi)

theorem projector_idempotent (psi : State) : projector (projector psi) = projector psi := by
  sorry

theorem projector_commutes_left (j : Fin 3) (psi : State) :
    projector (leftFlip j psi) = leftFlip j (projector psi) := by
  funext x
  simp only [projector, Pi.smul_apply, Pi.add_apply]
  rw [B_commutes_left]
  simp [leftFlip]
  ring

theorem projector_commutes_Gamma (psi : State) :
    projector (Gamma psi) = Gamma (projector psi) := by
  funext x
  simp only [projector, Pi.smul_apply, Pi.add_apply]
  rw [B_commutes_Gamma]
  simp [Gamma]
  ring

def vacuum : Flavor := 0

theorem projector_vacuum_value : projector (delta vacuum) vacuum = 1 / 2 := by
  sorry

theorem projector_nonzero : projector ≠ (fun _ => 0) := by
  intro h
  have hv := congrFun (congrFun h (delta vacuum)) vacuum
  rw [projector_vacuum_value] at hv
  norm_num at hv

theorem projector_nonidentity : projector ≠ id := by
  intro h
  have hv := congrFun (congrFun h (delta vacuum)) vacuum
  rw [projector_vacuum_value] at hv
  norm_num [id, delta] at hv

/-- Linear packaging of the explicit projector. -/
def projectorLinear : State →ₗ[Complex] State where
  toFun := projector
  map_add' := by
    sorry
  map_smul' := by
    sorry

/-
Proof handoff (rank/nonprimitivity):
Current goal: prove the theorem below.  The matrix is four disjoint 2-by-2
blocks and `B` has eigenvalues `+1,-1` once per block.  A direct route is to
give four explicit `+1` eigenvectors and four explicit `-1` eigenvectors, then
use them as a basis of `State`.
-/
theorem projector_rank_four :
    Module.finrank Complex (LinearMap.range projectorLinear) = 4 := by
  sorry

theorem commuting_anticommuting_family_not_invertible
    (A : Fin 3 -> Operator)
    (hcomm : forall i j psi, A i (A j psi) = A j (A i psi))
    (hanti : forall i j, i ≠ j -> forall psi, A i (A j psi) = -A j (A i psi))
    (hbij : forall i, Function.Bijective (A i)) : False := by
  sorry

theorem no_conjugacy_to_anticommuting_invertibles
    (U V : Operator) (hVU : forall psi, V (U psi) = psi)
    (hanti : forall i j, i ≠ j -> forall psi,
      U (deckFlip i (V (U (deckFlip j (V psi))))) =
        -U (deckFlip j (V (U (deckFlip i (V psi))))))
    (hbij : forall i, Function.Bijective (fun psi => U (deckFlip i (V psi)))) : False := by
  apply commuting_anticommuting_family_not_invertible
    (fun i psi => U (deckFlip i (V psi)))
  · intro i j psi
    simp only [hVU]
    exact congrArg U (deckFlip_commute i j (V psi))
  · exact hanti
  · exact hbij

end CliffordCoverProjector
