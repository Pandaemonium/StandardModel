import PhysicsSM.Algebra.Octonion.Basic

/-!
# The 3+1 QCA flavor cover and the octonion XOR basis

Focused Aristotle target for a lateral response to the strict 3+1 doubling
obstruction.  The eight sheets of the flavor cover are modeled by three bits.
The project's octonion basis is independently indexed by the same three-bit
XOR geometry.  This file asks for the exact equivariant bridge and records a
non-canonicity control: the shared cardinality is not itself a particle-physics
derivation. This bridge transports no color, hypercharge, chirality, generation,
or particle content. `FlavorCoverChargeObstruction` separately proves that a
bare deck-invariant scalar charge cannot reproduce the nonconstant left-doublet
hypercharge pattern.

Provenance: the eight-cover flavor architecture is based on Bakircioglu,
Arnault, and Arrighi, arXiv:2505.07900v3.  The octonion convention is the
project XOR/Fano convention in `PhysicsSM.Algebra.Octonion.Basic`; it is not a
verbatim convention from the paper.
-/

namespace PhysicsSM.Draft.NullEdge.QCAOctonionFlavorBridge

open PhysicsSM.Algebra.Octonion

/-- Three binary covering-sheet labels. -/
abbrev Flavor := Fin 3 -> Bool

/-- Componentwise deck-group addition. -/
def flavorAdd (a b : Flavor) : Flavor := fun k => xor (a k) (b k)

/-- The zero sheet. -/
def flavorZero : Flavor := fun _ => false

/-- Binary encoding in the project order `001`, `010`, `100`. -/
def flavorNat (f : Flavor) : Nat :=
  (if f 0 then 1 else 0) +
  (if f 1 then 2 else 0) +
  (if f 2 then 4 else 0)

theorem flavorNat_lt_eight (f : Flavor) : flavorNat f < 8 := by
  simp only [flavorNat]
  split_ifs <;> omega

/-- Encode a covering sheet as the matching octonion XOR index. -/
def flavorIndex (f : Flavor) : Fin 8 :=
  ⟨flavorNat f, flavorNat_lt_eight f⟩

/-- Decode an octonion XOR index into its three covering bits. -/
def indexFlavor (i : Fin 8) : Flavor := fun k => Nat.testBit i.val k.val

/-- The exact eight-sheet/octet equivalence. -/
def flavorEquivOctonionIndex : Flavor ≃ Fin 8 where
  toFun := flavorIndex
  invFun := indexFlavor
  left_inv := by
    intro f
    funext k
    simp only [indexFlavor, flavorIndex]
    fin_cases k <;>
      (cases h0 : f 0 <;> cases h1 : f 1 <;> cases h2 : f 2 <;>
        simp [flavorNat, h0, h1, h2] <;> decide)
  right_inv := by
    intro i
    fin_cases i <;> decide

/-- XOR on octonion labels, transported from componentwise deck addition. -/
def xorIndex (a b : Fin 8) : Fin 8 :=
  flavorEquivOctonionIndex
    (flavorAdd (flavorEquivOctonionIndex.symm a)
      (flavorEquivOctonionIndex.symm b))

/-- `xorIndex` unfolded through the equivalence: it is the sheet encoding of the
deck-sum of the two decoded labels.  Both sides are definitionally equal because
the equivalence's forward/backward maps are `flavorIndex`/`indexFlavor`. -/
theorem xorIndex_eq (i j : Fin 8) :
    xorIndex i j = flavorIndex (flavorAdd (indexFlavor i) (indexFlavor j)) := rfl

theorem flavorEquiv_add (a b : Flavor) :
    flavorEquivOctonionIndex (flavorAdd a b) =
      xorIndex (flavorEquivOctonionIndex a) (flavorEquivOctonionIndex b) := by
  simp only [xorIndex, Equiv.symm_apply_apply]

theorem flavorAdd_assoc (a b c : Flavor) :
    flavorAdd (flavorAdd a b) c = flavorAdd a (flavorAdd b c) := by
  funext k
  simp only [flavorAdd, Bool.xor_assoc]

theorem flavorAdd_comm (a b : Flavor) :
    flavorAdd a b = flavorAdd b a := by
  funext k
  simp only [flavorAdd, Bool.xor_comm]

theorem flavorAdd_zero (a : Flavor) :
    flavorAdd a flavorZero = a := by
  funext k
  simp only [flavorAdd, flavorZero, Bool.xor_false]

theorem flavorAdd_self (a : Flavor) :
    flavorAdd a a = flavorZero := by
  funext k
  simp only [flavorAdd, flavorZero, Bool.xor_self]

/-- The deck action is regular: exactly one sheet translation carries any
chosen sheet to any other sheet. -/
theorem deck_action_regular (a b : Flavor) :
    ∃! g : Flavor, flavorAdd g a = b := by
  refine ⟨flavorAdd b a, ?_, ?_⟩
  · calc
      flavorAdd (flavorAdd b a) a
          = flavorAdd b (flavorAdd a a) := flavorAdd_assoc b a a
      _ = flavorAdd b flavorZero := by rw [flavorAdd_self]
      _ = b := flavorAdd_zero b
  · intro y hy
    calc
      y = flavorAdd y flavorZero := (flavorAdd_zero y).symm
      _ = flavorAdd y (flavorAdd a a) := by rw [flavorAdd_self]
      _ = flavorAdd (flavorAdd y a) a := (flavorAdd_assoc y a a).symm
      _ = flavorAdd b a := by rw [hy]

/-- The octonion basis vector attached to a covering sheet. -/
def basisOfFlavor (f : Flavor) : Octonion :=
  basisElem (flavorEquivOctonionIndex f)

set_option maxHeartbeats 2000000 in
/-- Basis products in the project XOR/Fano convention: the product of two basis
vectors lands on the XOR of their labels, up to the orientation sign recorded in
`lookupSign`.  This is the coordinate content underlying
`basisOfFlavor_mul_support`. -/
theorem basisElem_mul_eq (i j : Fin 8) :
    basisElem i * basisElem j =
      ((lookupSign i j : Int) : Real) • basisElem (xorIndex i j) := by
  rw [xorIndex_eq]
  fin_cases i <;> fin_cases j <;>
    (ext <;>
      simp [basisElem, lookupSign, flavorIndex, indexFlavor, flavorAdd, flavorNat] <;>
      decide)

/-- Multiplication of sheet-labeled basis vectors lands on the deck-group sum
of their labels, up to the orientation sign from the Fano convention. -/
theorem basisOfFlavor_mul_support (a b : Flavor) :
    basisOfFlavor a * basisOfFlavor b =
      ((lookupSign (flavorEquivOctonionIndex a)
        (flavorEquivOctonionIndex b) : Int) : Real) •
        basisOfFlavor (flavorAdd a b) := by
  simp only [basisOfFlavor, flavorEquiv_add]
  exact basisElem_mul_eq _ _

/-- Exchange the first two cover axes. -/
def swapFirstTwoBits (f : Flavor) : Flavor
  | 0 => f 1
  | 1 => f 0
  | 2 => f 2

theorem swapFirstTwoBits_add (a b : Flavor) :
    swapFirstTwoBits (flavorAdd a b) =
      flavorAdd (swapFirstTwoBits a) (swapFirstTwoBits b) := by
  funext k
  fin_cases k <;> simp only [swapFirstTwoBits, flavorAdd]

/-- Non-canonicity control: the unanchored three-bit deck group has a
nonidentity automorphism.  Additional dynamics or charge data must choose an
identification with particle labels. -/
theorem swapFirstTwoBits_nontrivial :
    swapFirstTwoBits ≠ id := by
  intro h
  have h2 := congrFun (congrFun h (fun k => decide (k = 0))) 0
  simp only [swapFirstTwoBits, id_eq] at h2
  exact absurd h2 (by decide)

/-! ## Build-enforced trust pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.QCAOctonionFlavorBridge.basisElem_mul_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms basisElem_mul_eq

/-- info: 'PhysicsSM.Draft.NullEdge.QCAOctonionFlavorBridge.basisOfFlavor_mul_support' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms basisOfFlavor_mul_support

/-- info: 'PhysicsSM.Draft.NullEdge.QCAOctonionFlavorBridge.deck_action_regular' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms deck_action_regular

/-- info: 'PhysicsSM.Draft.NullEdge.QCAOctonionFlavorBridge.swapFirstTwoBits_nontrivial' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms swapFirstTwoBits_nontrivial

end PhysicsSM.Draft.NullEdge.QCAOctonionFlavorBridge
