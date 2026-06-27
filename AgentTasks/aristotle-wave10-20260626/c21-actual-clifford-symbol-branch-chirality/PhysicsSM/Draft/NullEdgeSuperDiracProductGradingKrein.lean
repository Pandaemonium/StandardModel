import Mathlib

/-!
# Draft.NullEdgeSuperDiracProductGradingKrein

Finite product-grading and Krein-symmetry layer for the corrected null-edge
super-Dirac conjecture.

The module proves that:

* a diagonal grading anticommutes with any operator supported on opposite signs;
* the product grading on degree times chirality flips under either an external
  degree-odd block or an internal chirality-odd block;
* finite `J`-self-adjointness is the natural Lorentzian/Krein predicate;
* ordinary self-adjointness plus commutation with `J` implies
  `J`-self-adjointness.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSuperDiracProductGradingKrein

open Matrix Complex

variable {Idx : Type*} [Fintype Idx] [DecidableEq Idx]

/-- Diagonal grading matrix attached to a sign function. -/
def grading (sign : Idx -> Complex) : Matrix Idx Idx Complex :=
  fun i j => if i = j then sign i else 0

/-- An operator is odd for `sign` if it has no entries between equal signs. -/
def OddForSign (sign : Idx -> Complex) (D : Matrix Idx Idx Complex) : Prop :=
  ∀ i j, sign i = sign j -> D i j = 0

/-- A diagonal grading anticommutes with any operator supported on opposite signs. -/
theorem grading_anticommutes_of_oddForSign
    (sign : Idx -> Complex) (D : Matrix Idx Idx Complex)
    (hSq : ∀ i, sign i * sign i = 1)
    (hOdd : OddForSign sign D) :
    grading sign * D + D * grading sign = 0 := by
  ext i j
  by_cases hij : sign i = sign j <;> simp_all +decide [OddForSign]
  · simp_all +decide [grading, Matrix.mul_apply]
  · simp +decide [grading, Matrix.mul_apply, Finset.sum_ite_eq]
    grind

/-- Finite parity factor for simplicial degree. -/
inductive Deg where
  | even
  | odd
  deriving DecidableEq, Fintype

/-- Finite chirality factor. -/
inductive Chir where
  | left
  | right
  deriving DecidableEq, Fintype

/-- Degree sign. -/
def degSign : Deg -> Complex
  | Deg.even => 1
  | Deg.odd => -1

/-- Chirality sign. -/
def chirSign : Chir -> Complex
  | Chir.left => 1
  | Chir.right => -1

/-- The product grading sign: degree sign times chirality sign. -/
def productSign (x : Deg × Chir) : Complex :=
  degSign x.1 * chirSign x.2

/-- Product grading on degree times chirality. -/
def productGrading : Matrix (Deg × Chir) (Deg × Chir) Complex :=
  grading productSign

theorem productSign_sq (x : Deg × Chir) :
    productSign x * productSign x = 1 := by
  cases x with
  | mk d c =>
      cases d <;> cases c <;> simp [productSign, degSign, chirSign]

/-- An external block flips simplicial degree and preserves chirality. -/
def ExternalBlock (D : Matrix (Deg × Chir) (Deg × Chir) Complex) : Prop :=
  ∀ i j, i.2 != j.2 || i.1 = j.1 -> D i j = 0

/-- An internal block preserves simplicial degree and flips chirality. -/
def InternalBlock (D : Matrix (Deg × Chir) (Deg × Chir) Complex) : Prop :=
  ∀ i j, i.1 != j.1 || i.2 = j.2 -> D i j = 0

theorem externalBlock_oddForProductSign
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex)
    (hD : ExternalBlock D) :
    OddForSign productSign D := by
  rintro ⟨d1, c1⟩ ⟨d2, c2⟩ h
  apply hD
  revert h
  cases d1 <;> cases d2 <;> cases c1 <;> cases c2 <;>
    simp_all [productSign, degSign, chirSign] <;> norm_num

theorem internalBlock_oddForProductSign
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex)
    (hD : InternalBlock D) :
    OddForSign productSign D := by
  rintro ⟨d1, c1⟩ ⟨d2, c2⟩ h
  apply hD
  revert h
  cases d1 <;> cases d2 <;> cases c1 <;> cases c2 <;>
    simp_all [productSign, degSign, chirSign] <;> norm_num

theorem productGrading_anticommutes_externalBlock
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex)
    (hD : ExternalBlock D) :
    productGrading * D + D * productGrading = 0 := by
  exact grading_anticommutes_of_oddForSign
    productSign D productSign_sq (externalBlock_oddForProductSign D hD)

theorem productGrading_anticommutes_internalBlock
    (D : Matrix (Deg × Chir) (Deg × Chir) Complex)
    (hD : InternalBlock D) :
    productGrading * D + D * productGrading = 0 := by
  exact grading_anticommutes_of_oddForSign
    productSign D productSign_sq (internalBlock_oddForProductSign D hD)

/-- Finite `J`-self-adjointness for a Krein form with fundamental symmetry `J`. -/
def IsKreinSelfAdjoint (J D : Matrix Idx Idx Complex) : Prop :=
  J * D = D.conjTranspose * J

omit [DecidableEq Idx] in
/--
Ordinary self-adjointness plus commutation with `J` implies
`J`-self-adjointness.
-/
theorem isKreinSelfAdjoint_of_selfAdjoint_commutes
    (J D : Matrix Idx Idx Complex)
    (hD : D.conjTranspose = D)
    (hcomm : J * D = D * J) :
    IsKreinSelfAdjoint J D := by
  unfold IsKreinSelfAdjoint
  aesop

end PhysicsSM.Draft.NullEdgeSuperDiracProductGradingKrein

end
